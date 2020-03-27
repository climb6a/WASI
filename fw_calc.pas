unit fw_calc;

{$MODE Delphi}

{ Calculates spectra in forward mode.
  Version vom 22.8.2019 }

interface
uses  defaults;

procedure calc_T_WV;
procedure calc_T_O3;
procedure calc_Tr_GC;
procedure calc_omega_a;
procedure calc_M;
procedure calc_Fa;
procedure calc_tau_a_GC;
procedure calc_T_as;
procedure calc_Ed_GreggCarder;
procedure calc_a;
procedure calc_b;
procedure calc_omega_b;
procedure calc_R_rs;
procedure calc_R;
procedure calc_Rrs_surface;
procedure calc_Kd;
procedure calc_kL_uW;
procedure calc_Lu;
procedure calc_R_rs_below;
procedure calc_R_bottom;
procedure calc_KE_uW(sun:double);
procedure calc_KE_uB(sun:double);
procedure calc_f_factor;
procedure calc_Rrs_F(z, zB, flu, A_phy, A_DOM: double);
procedure calc_test;


implementation
uses  SysUtils, misc, privates, math, gui;

{ Downwelling irradiance; model of Gregg and Carder (1990):
W. W. Gregg, K. L. Carder, "A simple spectral solar irradiance model
for cloudless maritime atmospheres," Limnol. Oceanogr. 35, 1657-1675 (1990) }

procedure calc_omega_a;
{ Aerosol single scattering albedo }
begin
    omega_a:=(-0.0032*AM+0.972)*exp(3.06E-4*RH);
    end;

procedure calc_Fa;
{ Aerosol forward scattering probability }
var B1, B2, B3 : double;
    argument   : double;
begin
    if alpha.fw<0 then argument:=1-0.82
        else if alpha.fw>1.2 then argument:=1-0.65
        else argument:=1+0.1417*alpha.fw-0.82;
    if argument<nenner_min then argument:=nenner_min;
    B3:=ln(argument);
    B2:=B3*(0.0783+B3*(-0.3824-0.5874*B3));
    B1:=B3*(1.459+B3*(0.1595+0.4129*B3));
    F_a:=1-0.5*exp((B1+B2*cos(sun.fw*pi/180))*cos(sun.fw*pi/180));
    end;

procedure calc_M;
{ Air mass. The equation given in Gregg and Carder (1990), which was taken from
  Kasten (1965), is outdated. Kasten and Young (1989) provide updated
  numerical values a = 0.50572, b = 6.07995°, c = 1.6364. These replace
  the old values a = 0.15, b = 3.885°, c = 1.253. }
var nenner : double;
begin
    nenner:=cos(sun.fw*pi/180)+0.50572*power((96.07995-sun.fw),-1.6364);
    if abs(nenner)<nenner_min then nenner:=nenner_min;
    GC_M:=1/nenner;
    end;

procedure calc_M_ozone;
{ Atmospheric path length of ozone}
var nenner : double;
begin
    nenner:=sqrt(sqr(cos(sun.fw*pi/180))+0.007);
    if abs(nenner)<nenner_min then nenner:=nenner_min;
    M_oz:=1.0035/nenner;
    end;

procedure calc_Tr_GC;
{ Transmittance of atmosphere caused by Rayleigh scattering, eq. (2.27);
  Gregg and Carder (1990) }
var k      : integer;
    nenner : double;
    sq     : double;
    M      : double;  { atmospheric path length corrected for pressure }
begin
    M:=GC_M*GC_P/1013.25;
    for k:=1 to Channel_number do begin
        sq:=sqr(x^.y[k]/1000);
        nenner:=115.6406*sq*sq-1.335*sq;
        if abs(nenner)<nenner_min then nenner:=nenner_min;
        GC_T_r^.y[k] := exp(-M/nenner);
        end;
    GC_T_r^.ParText:='Transmittance of the atmosphere after Rayleigh scattering';
    GC_T_r^.sim:=TRUE;
    end;

procedure calc_tau_a_GC;
{ Aerosol optical thickness; Gregg and Carder (1990) }
var k : integer;
begin
    for k:=1 to Channel_number do
        GC_tau_a^.y[k]:= beta.fw*power(x^.y[k]/Lambda_a, -alpha.fw);
    GC_tau_a^.ParText:='Aerosol optical thickness';
    GC_tau_a^.sim:=TRUE;
    end;

procedure calc_T_as;
{ Atmospheric transmittance after aerosol scattering, eq. (2.29);
  Gregg and Carder (1990) }
var k : integer;
begin
    for k:=1 to Channel_number do
        GC_T_as^.y[k]:= exp(-omega_a*GC_tau_a^.y[k]*GC_M);
    GC_T_as^.ParText:='Transmittance of the atmosphere after aerosol scattering';
    GC_T_as^.sim:=TRUE;
    end;

procedure calc_T_aa;
{ Atmospheric transmittance after aerosol absorption, eq. (2.28);
  Gregg and Carder (1990) }
var k : integer;
begin
    for k:=1 to Channel_number do
        GC_T_aa^.y[k]:= exp(-(1-omega_a)*GC_tau_a^.y[k]*GC_M);
    GC_T_aa^.ParText:='Transmittance of the atmosphere after aerosol absorption';
    GC_T_aa^.sim:=TRUE;
    end;

procedure calc_T_o2;
{ Atmospheric transmittance after oxygen absorption, eq. (2.31);
  Gregg and Carder (1990) }
var k        : integer;
    argument : double;
    M        : double;  { atmospheric path length corrected for pressure }
begin
    M:=GC_M*GC_P/1013.25;
    for k:=1 to Channel_number do begin
        argument:=-1.41*aO2^.y[k]*M/power(1+118.3*aO2^.y[k]*M,0.45);
        if argument>exp_max then argument:=exp_max; 
        GC_T_o2^.y[k]:=exp(argument);
        end;
    GC_T_o2^.ParText:='Transmittance of the atmosphere after oxygen absorption';
    GC_T_o2^.sim:=TRUE;
    end;

procedure calc_T_o3;
{ Atmospheric transmittance after ozone absorption, eq. (2.30);
  Gregg and Carder (1990) }
var k        : integer;
    argument : double;
begin
    calc_M_ozone;
    for k:=1 to Channel_number do begin
        argument:=-aO3^.y[k]*M_oz*H_oz.fw;
        if argument>exp_max then argument:=exp_max;
        GC_T_o3^.y[k]:=exp(argument);
        end;
    GC_T_o3^.ParText:='Transmittance of the atmosphere after ozone absorption';
    GC_T_o3^.sim:=TRUE;
    end;

procedure calc_T_WV;
{ Atmospheric transmittance after water vapor absorption, eq. (2.32);
  Gregg and Carder (1990) }
var argument : double;
    k        : integer;
begin
    for k:=1 to Channel_number do begin
        argument:=-0.2385*aWV^.y[k]*WV.fw*GC_M/power(1+20.07*aWV^.y[k]*WV.fw*GC_M,0.45);
        if argument>exp_max then argument:=exp_max;
        GC_T_WV^.y[k]:=exp(argument);
        end;
    GC_T_WV^.ParText:='Transmittance of the atmosphere after water vapor absorption';
    GC_T_WV^.sim:=TRUE;
    end;

procedure calc_Edd;
{ Direct downwelling irradiance, eq. (2.24);
  Gregg and Carder (1990) }
var k        : integer;
    sz_air   : double;
    rho      : double;
begin
    sz_air   :=sun.fw*pi/180;
    if flag_fresnel_sun then rho:=Fresnel(sun.fw) else rho:=rho_dd.fw;
    for k:=1 to Channel_number do begin
        GC_Edd^.y[k]:=f_dd.fw*E0^.y[k]*sun_earth*cos(sz_air)*
                      GC_T_r^.y[k]*GC_T_aa^.y[k]*GC_T_o2^.y[k]*GC_T_o3^.y[k]*
                      GC_T_WV^.y[k]*GC_T_as^.y[k];
        if not flag_above then
            GC_Edd^.y[k]:=GC_Edd^.y[k]*exp(-Kdd^.y[k]*z.fw)*r_theta_fw*(1-rho);
            end;
    if dsmpl>0 then resample_Rect(GC_Edd^);
    GC_Edd^.ParText:='Downwelling direct irradiance (mW m^-2 nm^-1)';
    GC_Edd^.sim:=TRUE;
    end;

procedure calc_Eds;
{ Diffuse downwelling irradiance, eqs. (2.25) and (2.26);
  Gregg and Carder (1990) }
var k        : integer;
    rho      : double;
    sz_air   : double;
begin
    sz_air   :=sun.fw*pi/180;
    if flag_calc_rho_ds then rho:=rho_diffuse(sz_air)
                        else rho:=rho_ds.fw;
    for k:=1 to Channel_number do begin
        GC_Edsr^.y[k]:=0.5*E0^.y[k]*sun_earth*cos(sz_air)*
                     GC_T_aa^.y[k]*GC_T_o2^.y[k]*GC_T_o3^.y[k]*GC_T_WV^.y[k]*
                     (1-power(GC_T_r^.y[k],0.95));
        GC_Edsa^.y[k]:=E0^.y[k]*sun_earth*cos(sz_air)*GC_T_aa^.y[k]*
                     GC_T_o2^.y[k]*GC_T_o3^.y[k]*GC_T_WV^.y[k]*
                     power(GC_T_r^.y[k],1.5)*(1-GC_T_as^.y[k])*F_a;
        end;

    { Average irradiance spectra above water for consistency with Hydrolight.
      Note: this averaging accounts for non-linearity of E with concentrations
      of atmospheric components, but not with concentrations of water
      constituents. }
    if dsmpl>0 then resample_Rect(GC_Edsr^);
    if dsmpl>0 then resample_Rect(GC_Edsa^);

    for k:=1 to Channel_number do begin
        if not flag_above then begin
            GC_Edsa^.y[k]:=GC_Edsa^.y[k]*exp(-Kds^.y[k]*z.fw)*r_theta_fw*(1-rho);
            GC_Edsr^.y[k]:=GC_Edsr^.y[k]*exp(-Kds^.y[k]*z.fw)*r_theta_fw*(1-rho);
            end;
        GC_Eds^.y[k]:=f_ds.fw*GC_Edsr^.y[k] + f_ds.fw*GC_Edsa^.y[k];

        { Upwelling irradiance reflected at the water surface in downward direction }
        if not flag_above then
            GC_Eds^.y[k]:=GC_Eds^.y[k] *
                          (1 + f_ds.fw *rho_Eu*R^.y[k]*(1+r_d^.y[k]));
        end;
    GC_Edsr^.ParText:='Downwelling irradiance due to Rayleigh scattering (mW m^-2 nm^-1)';
    GC_Edsa^.ParText:='Downwelling irradiance due to aerosol scattering (mW m^-2 nm^-1)';
    GC_Eds^.ParText :='Downwelling diffuse irradiance (mW m^-2 nm^-1)';
    GC_Edsr^.sim:=TRUE;
    GC_Edsa^.sim:=TRUE;
    GC_Eds^.sim :=TRUE;
    end;

procedure calc_rd0;
{ Ratio of direct to diffuse Ed component just below water surface,
  see WASI manual eq. (2.37) }
var k      : integer;
    nenner : double;
begin
    for k:=1 to Channel_number do begin
        nenner:=f_ds.fw*
                (1-power(GC_T_r^.y[k],0.95)+2*power(GC_T_r^.y[k],1.5)*
                (1-GC_T_as^.y[k])*F_a)*(1-rho_ds.fw);
        if abs(nenner)<nenner_min then nenner:=nenner_min;
        r_d^.y[k]:=f_dd.fw*2*GC_T_r^.y[k]*GC_T_as^.y[k]*(1-rho_dd.fw)/nenner;
        end;
    r_d^.ParText:='Ratio of direct to diffuse downwelling irradiance just below water surface';
    r_d^.sim:=TRUE;
    end;

procedure calc_rd;
{ Ratio of direct to diffuse Ed component }
var k      : integer;
    nenner : double;
begin
    for k:=1 to Channel_number do begin
        nenner:=GC_Eds^.y[k];
        if abs(nenner)<nenner_min then nenner:=nenner_min;
        r_d^.y[k]:=GC_Edd^.y[k]/nenner;
        end;
    r_d^.ParText:='Ratio of direct to diffuse downwelling irradiance';
    r_d^.sim:=TRUE;
    end;

procedure calc_Ed_GC;
{ Downwelling irradiance, Gregg and Carder (1990) }
var k : integer;
begin
    for k:=1 to Channel_number do
        Ed^.y[k]:=GC_Edd^.y[k]+GC_Eds^.y[k];
    Ed^.ParText:='Downwelling irradiance (mW m^-2 nm^-1)';
    Ed^.sim:=TRUE;
    end;

procedure calc_Ed_GreggCarder;
var flag_merk : boolean;
    Fluo_merk : Attr_spec;
begin
    flag_merk:=flag_fluo;
    Fluo_merk:=RrsF^;
    flag_fluo:=FALSE;
    if not flag_above then calc_Kd;
    calc_omega_a;       { omega_a,  Single scattering albedo }
    calc_Fa;            { F_a,      Aerosol forward scattering probability }
    calc_M;             { GC_M,     Air mass }
    calc_Tr_GC;         { GC_T_r,   Rayleigh scattering transmittance }
    calc_tau_a_GC;      { GC_tau_a, Aerosol optical thickness }
    calc_T_as;          { GC_T_as,  Aerosol scattering transmittance }
    calc_T_aa;          { GC_T_aa,  Aerosol absorption transmittance }
    calc_T_o2;          { GC_T_o2,  Oxygen absorption transmittance }
    calc_T_o3;          { GC_T_o3,  Ozone absorption transmittance }
    calc_T_WV;          { GC_T_WV,  Water vapour transmittance }
    if not flag_use_R  then calc_R;
    calc_rd0;           { r_d(0-),  Ratio of direct to diffuse Ed component }
    calc_Edd;           { GC_Edd,   Direct downwelling irradiance }
    calc_Eds;           { GC_Eds,   Diffuse downwelling irradiance }
    calc_Ed_GC;         { Ed,       Downwelling irradiance }
    calc_rd;            { r_d,      Ratio of direct to diffuse Ed component }
    flag_fluo:=flag_merk;
    RrsF^:=Fluo_merk;
    end;

{ Absorption }

procedure calc_a_WC;
{ Absorption of water constituents }
var i, k   : integer;
    lna    : double;
    C_NAP  : double;
begin
    if (not flag_public) and flag_aph_C and (c[0].fw>nenner_min) then begin
        for k:=1 to Channel_number do begin
        { Calculate specific phytoplankton absorption as a function of CHL concentration. Reference:
          P. Ylöstalo, K. Kallio and J.  Seppälä (2014): Absorption properties of in-water constituents
          and their variation among various lake types in the boreal region. Remote Sensing of Environment
          148, 190-205. }
            if (aphA^.y[k]>nenner_min) then begin
                lna:=ln(aphA^.y[k]) - aphB^.y[k] * ln(c[0].fw);
                aP[0]^.y[k]:=exp(lna);
                end
            else aP[0]^.y[k]:=0;
            end;
        aP[0]^.ParText:='Specific absorption (m^2/mg) (Simulated spectrum)';
        end;
    C_NAP:=C_X.fw + C_Mie.fw;
    Chl_a:=0; for i:=0 to 5 do Chl_a:=Chl_a+c[i].fw;
    for k:=1 to Channel_number do begin
        aP_calc^.y[k]:=0;
        for i:=0 to 5 do aP_calc^.y[k]:=aP_calc^.y[k] + C[i].fw*aP[i]^.y[k];
        aNAP_calc^.y[k]:=C_NAP * aNAP440 * aNAP^.y[k];
        aCDOM_calc^.y[k]:=C_Y.fw * aY^.y[k];
        a^.y[k]:=aP_calc^.y[k] + aNAP_calc^.y[k] + aCDOM_calc^.y[k];
        end;
    a^.ParText:= 'Absorption of water constituents (m^-1)';
    a^.sim:=TRUE;
    aP_calc^.ParText:='Phytoplankton absorption (m^-1)';
    aP_calc^.sim:=TRUE;
    aNAP_calc^.ParText:='Non-algal particle absorption (m^-1)';
    aNAP_calc^.sim:=TRUE;
    aCDOM_calc^.ParText:='CDOM absorption (m^-1)';
    aCDOM_calc^.sim:=TRUE;
    end;

procedure calc_a;
{ Absorption of water }
var k   : integer;
begin
    calc_a_WC;
    if flag_aW or (spec_type<>S_a) then begin
        for k:=1 to Channel_number do
            a^.y[k]:=a^.y[k]+ aW^.y[k] + (T_W.fw-T_W0)*dadT^.y[k];
        a^.ParText:= 'Absorption coefficient (m^-1)';
        a^.sim:=TRUE;
        end;
    end;

procedure calc_bb;
{ Backscattering }
var k       : integer;
    cc, fak : double;
begin
    if flag_CXisC0 then cc:=C[0].fw else cc:=C_X.fw;
    if flag_bX_linear then fak:=bb_X else begin
        { b_bL* = A C^B (Morel 1980) }
        if cc>nenner_min then fak:=bbX_A*exp(bbX_B*ln(cc))
                         else fak:=bbX_A;
        end;
    for k:=1 to Channel_number do begin
        bb_phy^.y[k] := Chl_a * bbs_phy.fw * bPhyN^.y[k];
        bb_NAP^.y[k] := cc * fak * bXN^.y[k] + C_Mie.fw * bbMie^.y[k];
        bb^.y[k] := bbW^.y[k] + bb_phy^.y[k] + bb_NAP^.y[k];
        end;
    bb^.ParText:= 'Backscattering coefficient (m^-1)';
    bb^.sim:=TRUE;
    bb_phy^.ParText:= 'Phytoplankton backscattering coefficient (m^-1)';
    bb_phy^.sim:=TRUE;
    bb_NAP^.ParText:= 'Non-algal particle backscattering coefficient (m^-1)';
    bb_NAP^.sim:=TRUE;
    end;

procedure calc_b;
{ Scattering }
var k  : integer;
    cc : double;
begin
    if flag_CXisC0 then cc:=C[0].fw else cc:=C_X.fw;
    for k:=1 to Channel_number do
        b^.y[k] := 2*bbW^.y[k] + cc * b_X * bXN^.y[k] + C_Mie.fw * bMie^.y[k];
    b^.ParText:= 'Scattering coefficient (m^-1)';
    b^.sim:=TRUE;
    end;

procedure calc_omega_b;
{ Backscattering albedo }
var k     : integer;
begin
    calc_a;
    calc_bb;
    for k:=1 to Channel_number do
        if Model_R=0 then omega_b^.y[k] := bb^.y[k] / (a^.y[k] + bb.y[k])  // Gordon et al. (1975)
                     else omega_b^.y[k] := bb^.y[k] / a^.y[k];             // Prieur (1976)
    omega_b^.ParText:= 'omega_b = bb / (a+bb)';
    omega_b^.sim:=TRUE;
    end;

procedure calc_f_factor;
{ Factor f of irradiance reflectance spectrum }
var k  : integer;
begin
    calc_omega_b;
    for k:=1 to Channel_number do begin
        f_R^.y[k]:=calc_f(omega_b^.y[k], bbW^.y[k]/bb^.y[k], sun.fw); // in unit misc
        if f_rs^.sim then Q_f^.y[k]:=calc_Q_f(f_rs^.y[k], f_R^.y[k]);
        end;
    f_R^.ParText:='f factor';
    f_R^.sim:=TRUE;
    if f_rs^.sim then Q_f^.ParText:='Q factor (sr)';
    if f_rs^.sim then Q_f^.sim:=TRUE;
    end;

{ Fluorescence }

procedure calculate_Ed_Ed0(zz:double);
{ Downwelling irradiance at depth zz and just beneath water surface.
  Used for fluorescence calculation. }
var temp_flag : boolean;
    temp_z    : double;
begin
    temp_flag :=flag_above;
    temp_z    :=z.fw;
    flag_above:=FALSE;
    z.fw :=0;
    calc_Ed_GreggCarder;
    Ed0^:=Ed^;
    Ed0^.ParText:='Downwelling irradiance just beneath water surface (mW m^-2 nm^-1)';
    Ed0^.sim:=TRUE;
    z.fw :=zz;
    calc_Ed_GreggCarder;   { Ed at depth z }
    flag_above:=temp_flag; { restore flag_above }
    z.fw :=temp_z;         { restore z.fw }
    end;

function calc_Lf(ex, em: integer; z, zB, A_chl, A_phy, A_DOM: double): double;
{ Calculate fluorescence radiance as integral over water layer from depth z
  to depth zB. ex, em are the channels of excitation and emission wavelength,
  the A's are the fluorescence amplitudes. }
var layer  : double;   // Depth integral of water layer
    nenner : double;   // Denominator; avoid division by zero
    Lf_chl : double;   // Fluorescence radiance caused by chl-a
    Lf_phy : double;   // Fluorescence radiance caused by phytoplankton
    Lf_DOM : double;   // Fluorescence radiance caused by dissolved organic matter
begin
    if (A_chl>0) and (x^.y[ex]>=PAR_min) and (x^.y[ex]<=PAR_max)
        then Lf_chl:=Gauss(x^.y[em]-Lambda_f0, Sigma_f0, A_chl)
        else Lf_chl:=0;
    (*
    Deactivated until EEMs of Anna are properly implemented
    if not flag_public then begin
        if A_phy>0 then Lf_phy:=A_phy*EEM_ph.EEM[em,ex]
                   else Lf_phy:=0;
        if A_DOM>0 then Lf_DOM:=A_DOM*EEM_DOM.EEM[em,ex]
                   else Lf_DOM:=0;
        end
    else begin     *)
        Lf_phy:=0;
        Lf_DOM:=0;
(*        end;  *)
    if flag_above then // sensor above water, z=0
        layer:=abs(1-exp(-(Kd^.y[ex]+kL_uW^.y[em])*zB))
    else               // sensor in water, z>0
        layer:=abs(exp(-Kd^.y[ex]*z)-exp(-(Kd^.y[ex]*zB-kL_uW^.y[em])*(zB-z)));
    nenner:=4*pi*x^.y[em]*(Kd^.y[ex]+kL_uW^.y[em]);
    if abs(nenner)<nenner_min then nenner:=nenner_min;
    calc_Lf:=(Lf_chl + Lf_phy + Lf_DOM) * f_EO * Ed0^.y[ex] * x^.y[ex] / nenner;
    end;

procedure calc_Lf_layer(z, zB, flu, A_phy, A_DOM: double);
{ Calculate fluorescence radiance spectrum Lf^.y[em] for channels em.
  Excitation is integrated over the channels [1, em]. }
var ex    : integer;   // Channel number of excitation wavelength
    em    : integer;   // Channel number of emission wavelength
    dex   : double;    // Excitation wavelength interval
    Ac    : double;    // Amplitude of chl-a fluorescence
begin
    calculate_Ed_Ed0(z);   // Calculate spectra Ed0^ at depth 0 and Ed^ at depth z
    if kL_uW^.sim=FALSE then calc_kL_uW;      // calculate spectrum kL_uW^
    if Kd^.sim=FALSE then calc_Kd;            // calculate spectra Kd^, Kdd^, Kds^
    for em:=1 to Channel_number do begin
        Lf^.y[em]:=0;                        // initialize spectrum Lf^
        for ex:=1 to em-1 do begin
            dex:=x^.y[ex+1]-x^.y[ex];
            Ac:=flu*Q_a*ap_calc^.y[ex];
            Lf^.y[em]:=Lf^.y[em]+calc_Lf(ex,em,z,zB,Ac,A_phy,A_DOM)*dex;
            end;
        end;
    Lf^.ParText:='Fluorescence component of upwelling radiance (mW m^-2 nm^-1 sr^-1)';
    Lf^.Sim:=TRUE;
    end;

procedure calc_Rrs_F(z, zB, flu, A_phy, A_DOM: double);
{ Fluorescence component of radiance reflectance, eq. (2.47) }
var em     : integer;  // channel number of emission
    nenner : double;   // Denominator; avoid division by zero
begin
    set_zero(RrsF^);
    if flag_fluo then begin
        if (spec_type=S_Rrs) or (spec_type=S_R) or (spec_type=S_Lup)
            then calc_Lf_layer(z, zB, flu, A_phy, A_DOM);
        for em:=1 to Channel_number do begin
            nenner:=Ed^.y[em];
            if abs(nenner)<nenner_min then nenner:=nenner_min;
            RrsF^.y[em]:=Lf^.y[em]/nenner;
            if RrsF^.y[em]>10 then RrsF^.y[em]:=10; // avoid scaling problem
            end;
        RrsF^.ParText:='Fluorescence component of radiance reflectance (1/sr)';
        end
    else RrsF^.ParText:='';
    RrsF^.sim:=TRUE;
    end;

procedure calc_R_deep;
{ Subsurface irradiance reflectance of deep water, eq. (2.14) }
var k  : integer;
begin
    calc_f_factor;
    if flag_fluo then calc_Rrs_F(z.fw, zB.fw, fluo.fw, dummy.fw, test.fw);    { Fluorescence }
    for k:=1 to Channel_number do
        R^.y[k]:= f_R^.y[k]*omega_b^.y[k] + Q.fw*RrsF^.y[k];
    R^.ParText:='Irradiance reflectance';
    R^.sim:=TRUE;
    end;

procedure calc_Ls;
{ Sky radiance reflected at the surface, eq. (2.42) }
var k      : integer;
begin
    if not flag_use_Ls then for k:=1 to Channel_number do begin
        Ls^.y[k]:= g_dd.fw * GC_Edd^.y[k]  + g_dsr.fw * GC_Edsr^.y[k] +
                             g_dsa.fw * GC_Edsa^.y[k];
        Ls^.ParText:='Sky radiance (mW m^-2 nm^-1 sr^-1)';
        Ls^.sim:=TRUE;
        end;
    { otherwise measured spectrum Ls is taken }
    end;


{ Reflectance }

procedure calc_Rrs_surface;
{ Specular reflections at the surface, eq. (2.13a) or eq. (2.13b) }
var k      : integer;
    nenner : double;
begin
    if flag_surf_fw then begin { wavelength dependent surface reflections }
        calc_Ed_GreggCarder;
        calc_Ls;
        for k:=1 to Channel_number do begin
            nenner:=Ed^.y[k];
            if abs(nenner)<nenner_min then nenner:=nenner_min;
            Rrs_surf^.y[k]:= rho_L.fw * Ls^.y[k] / nenner;
            if flag_MP then Rrs_surf^.y[k]:=Rrs_surf^.y[k]+rho_L.fw * fA[4].fw;
            end;
        end
    else for k:=1 to Channel_number do { constant surface reflections }
        Rrs_surf^.y[k]:= rho_L.fw / pi;

    Rrs_surf^.ParText:='Surface reflectance (1/sr)';
    Rrs_surf^.sim:=TRUE;
    end;

procedure calc_R_bottom;
{ Bottom reflectance, eq. (2.21) for L sensors, eq. (2.22) for E sensors }
var k, i : integer;
    sum  : double;
begin
    if flag_L then { L sensor: R_rs_bottom }
        for k:=1 to Channel_number do begin
            sum:=0;
            for i:=0 to 5 do sum:=sum + fA[i].fw*BRDF[i]*albedo[i]^.y[k];
            bottom^.y[k]:= sum;
            bottom^.ParText:='Bottom radiance reflectance (1/sr)';
            end
    else { E sensor: R_bottom = bottom albedo}
        for k:=1 to Channel_number do begin
            sum:=0;
            for i:=0 to 5 do sum:=sum + fA[i].fw*albedo[i]^.y[k];
            bottom^.y[k]:= sum;
            bottom^.ParText:='Bottom albedo';
            end;
    bottom^.sim:=TRUE;
    end;

procedure calc_Kd;
{ Attenuation coefficients of downwelling irradiance:
  Kd  = attenuation of Ed,  eq. (2.17)
  Kdd = attenuation of Edd, eq. (2.55)
  Kds = attenuation of Eds, eq. (2.56) }
var k, i     : integer;
    sz_water : double;
    sz_cos   : double;
    sz_1cos  : double;
    lds      : double;
    z99      : double;
    eu       : double;
begin
    calc_a;
    calc_b;
    calc_bb;
    sz_water :=arcsin(sin(sun.fw*pi/180)/nW);
    sz_cos := cos(sz_water);
    if abs(sz_cos)>nenner_min then sz_1cos:=1/sz_cos else sz_1cos:=1;
    if (sun.fw<90) and(view.fw=-1) then r_theta_fw:=sz_cos/cos(sun.fw*pi/180)
        else r_theta_fw:=1;
    lds:=lds0+lds1*(1-sz_cos);
    if p_Ed>0 then z99:=-ln(p_Ed/100) else z99:=0;
    i:=0;
    eu:=0;
    Kd^.avg:=0;
    for k:=1 to Channel_number do begin
        Kd^.y[k]:=(a^.y[k]+bb^.y[k])*ld*sz_1cos;
        if model_Kdd=0 then Kdd^.y[k]:=(a^.y[k]+bb^.y[k])*ldd*sz_1cos
            else Kdd^.y[k]:=ldda*a^.y[k]*sz_1cos + lddb*bb^.y[k];
        Kds^.y[k]:=(a^.y[k]+bb^.y[k])*lds;
        if abs(Kd^.y[k])>nenner_min then z_Ed^.y[k]:=z99/Kd^.y[k]
                                    else z_Ed^.y[k]:=999;
        if (x^.y[k]>=PAR_min) and (x^.y[k]<=PAR_max)
           and (abs(Kd^.y[k])>nenner_min) then begin
               inc(i);
               eu:=eu + z_Ed^.y[k];
               Kd^.avg:=Kd^.avg + Kd^.y[k];
               end;
        end;
    if i>0 then begin eu:=eu/i; Kd^.avg:=Kd^.avg/i; end;
    Kd^.ParText :='Diffuse attenuation coefficient (1/m)';
    Kdd^.ParText:='Attenuation coefficient of direct irradiance (1/m)';
    Kds^.ParText:='Attenuation coefficient of diffuse irradiance (1/m)';
    z_Ed^.ParText:='Depth (m) where ' + IntToStr(p_Ed) +
        ' % of downwelling irradiance remains.';
    if (i>0) and (p_Ed=1) then z_Ed^.ParText:=z_Ed^.ParText +
        ' Euphotic depth: ' + FloatToStrF(eu, ffFixed, 5, 2) + ' m'
    else if i>0 then z_Ed^.ParText:=z_Ed^.ParText +
        ' Average over PAR: ' + FloatToStrF(eu, ffFixed, 5, 2) + ' m';
    Kd^.sim :=TRUE;
    Kdd^.sim:=TRUE;
    Kds^.sim:=TRUE;
    end;

procedure calc_KE_uW(sun:double);
{ KE_uW = attenuation of upwelling irradiance backscattered in the water, eq. (2.6) }
var k       : integer;
    mue_sun : double;
begin
    mue_sun:=K2W/cos(arcsin(sin(sun*pi/180)/nW));
    for k:=1 to Channel_number do
        KE_uW^.y[k]:=(a^.y[k]+bb^.y[k])*exp(K1W*ln(1+omega_b.y[k]))*(1+mue_sun);
    KE_uW^.ParText:='Diffuse attenuation of upwelling irradiance backscattered in water (1/m)';
    KE_uW^.sim:=TRUE;
    end;

procedure calc_KE_uB(sun:double);
{ KE_uB = attenuation of upwelling irradiance reflected at the bottom, eq. (2.7) }
var k       : integer;
    mue_sun : double;
begin
    mue_sun:=K2B/cos(arcsin(sin(sun*pi/180)/nW));
    for k:=1 to Channel_number do
        KE_uB^.y[k]:=(a^.y[k]+bb^.y[k])*exp(K1B*ln(1+omega_b^.y[k]))*(1+mue_sun);
    KE_uB^.ParText:='Diffuse attenuation of upwelling irradiance reflected from the bottom (1/m)';
    KE_uB^.sim:=TRUE;
    end;

procedure calc_kL_uW;
{ kL_uW = attenuation of upwelling radiance backscattered in the water, eq. (2.9) }
var k        : integer;
    mue_sun  : double;
    mue_view : double;
begin
    mue_sun :=K2Wrs/cos(arcsin(sin(sun.fw*pi/180)/nW));
    mue_view:=1/cos(arcsin(sin(view.fw*pi/180)/nW));
    for k:=1 to Channel_number do
        kL_uW^.y[k]:=(a^.y[k]+bb^.y[k])*mue_view*exp(K1Wrs*ln(1+omega_b^.y[k]))*(1+mue_sun);
    kL_uW^.ParText:='Attenuation of upwelling radiance backscattered in water (1/m)';
    kL_uW^.sim:=TRUE;
    end;

procedure calc_kL_uB;
{ kL_uB = attenuation of upwelling radiance reflected at the bottom, eq. (2.10) }
var k        : integer;
    mue_sun  : double;
    mue_view : double;
begin
    mue_sun :=K2Brs/cos(arcsin(sin(sun.fw*pi/180)/nW));
    mue_view:=1/cos(arcsin(sin(view.fw*pi/180)/nW));
    for k:=1 to Channel_number do
        kL_uB^.y[k]:=(a^.y[k]+bb^.y[k])*mue_view*exp(K1Brs*ln(1+omega_b^.y[k]))*(1+mue_sun);
    kL_uB^.ParText:='Attenuation of upwelling radiance reflected from the bottom (1/m)';
    kL_uB^.sim:=TRUE;
    end;

procedure calc_R_shallow;
{ Irradiance reflectance below surface for shallow water, eq. (2.16).  }
{ Algorithm of Albert and Mobley (2003) }
var k  : integer;
    zz : double;
begin
    flag_L:=FALSE;
    calc_R_bottom;
    calc_Kd;
    calc_KE_uW(sun.fw);
    calc_KE_uB(sun.fw);
    zz:=zB.fw;
    if (zB.fw-z.fw>0.001) then zz:=zz-z.fw else zz:=0.001;
    for k:=1 to Channel_number do
        R^.y[k]:=R^.y[k] * (1-A1*exp(-(Kd^.y[k] + KE_uW^.y[k])*zz)) +
                 A2 * bottom^.y[k] * exp(-(Kd^.y[k] + KE_uB^.y[k])*zz);
    R^.ParText:='Irradiance reflectance';
    R^.sim:=TRUE;
    end;

procedure calc_R_rs_deep_below;
{ Radiance reflectance below surface for deep water }
var k  : integer;
begin
    if Model_R_rsB<2 then begin      // R_rs = f_rs * omega_b + R_rs,F
        for k:=1 to Channel_number do begin
            f_rs^.y[k] :=calc_f_rs(omega_b^.y[k], bbW^.y[k]/bb^.y[k], sun.fw, view.fw, Q.fw);
            r_rs^.y[k] :=f_rs^.y[k] * omega_b^.y[k] + RrsF^.y[k];
            if f_R^.sim then Q_f^.y[k]:=calc_Q_f(f_rs^.y[k], f_R^.y[k]);
            end;
        f_rs^.ParText:='f_rs factor';
        f_rs^.sim:=TRUE;
        end
    else begin                       // R_rs = R / Q
        if not flag_use_R then calc_R_deep;
        for k:=1 to Channel_number do r_rs^.y[k]:= R^.y[k]/Q.fw;
        end;
    r_rs^.ParText:='Radiance reflectance (sr^-1)';
    r_rs^.sim:=TRUE;
    if f_R^.sim then Q_f^.ParText:='Q factor (sr)';
    if f_R^.sim then Q_f^.sim:=TRUE;
    end;

procedure calc_R_rs_shallow_below;
{ Radiance reflectance below surface for shallow water, eq. (2.19) }
{ Algorithm of Albert and Mobley (2003) }
var k  : integer;
    zz : double;
begin
    flag_L:=TRUE;
    calc_R_bottom;
    calc_Kd;
    calc_kL_uW;
    calc_kL_uB;
    zz:=zB.fw;
    if abs(zB.fw-z.fw)>0.001 then zz:=zz-z.fw else zz:=0.001;
    for k:=1 to Channel_number do
        r_rs^.y[k]:=r_rs^.y[k] * (1-A1rs*exp(-(Kd^.y[k] + kL_uW^.y[k])*zz)) +
                    A2rs * bottom^.y[k] * exp(-(Kd^.y[k] + kL_uB^.y[k])*zz);
    r_rs^.ParText:='Radiance reflectance (sr^-1)';
    r_rs^.sim:=TRUE;
    end;

procedure calc_r_rs_below;
{ Radiance reflectance below surface }
begin
    calc_omega_b;
    calc_R_rs_deep_below;
    if flag_shallow then calc_R_rs_shallow_below;
    end;

procedure use_R_rs_below;
{ Underwater term of r_rs(0+) for Model_R_rsA = 0}
var k      : integer;
    nenner : double;
begin
    calc_R_rs_below;
    for k:=1 to Channel_number do begin
        nenner:=1-rho_Eu*Q.fw*r_rs^.y[k]; { Q nicht, wenn model_f=4 ? }
        if abs(nenner)<nenner_min then nenner:=nenner_min;
        r_rs^.y[k]:= r_rs^.y[k]/nenner;
        end;
    r_rs^.ParText:='Radiance reflectance (sr^-1)';
    r_rs^.sim:=TRUE;
    end;

procedure use_R;
{ Underwater term of R_rs(0+) for Model_R_rsA = 1}
var k      : integer;
    nenner : double;
begin
    if not flag_use_R then calc_R;
    for k:=1 to Channel_number do begin
        nenner:=Q.fw * (1-rho_Eu*R^.y[k]); { Q nicht, wenn model_f=4 ? }
        if abs(nenner)<nenner_min then nenner:=nenner_min;
        r_rs^.y[k]:= R^.y[k]/nenner;
        end;
    r_rs^.ParText:='Radiance reflectance (sr^-1)';
    r_rs^.sim:=TRUE;
    end;

procedure use_both;
{ Underwater term of R_rs(0+) for Model_R_rsA = 2}
var k      : integer;
    nenner : double;
begin
    if not flag_use_R then calc_R;
    calc_r_rs_below;
    for k:=1 to Channel_number do begin
        nenner:=1-rho_Eu*R^.y[k];
        if abs(nenner)<nenner_min then nenner:=nenner_min;
        r_rs^.y[k]:= r_rs^.y[k]/nenner;
        end;
    r_rs^.ParText:='Radiance reflectance (sr^-1)';
    r_rs^.sim:=TRUE;
    end;

procedure calc_R_rs_above;
{ Radiance reflectance above surface }
var k : integer;
begin
    case Model_R_rsA of
        0 : use_R_rs_below;
        1 : use_R;
        2 : use_both;
        end;
    calc_Rrs_surface;
    if (sun.fw<90) and(view.fw=-1) then
        r_theta_fw := cos(arcsin(sin(sun.fw*pi/180)/nW)) / cos(sun.fw*pi/180)
        else r_theta_fw:=1;
    for k:=1 to Channel_number do begin
        Rrs^.y[k] := (1-rho_Ed)*(1-rho_Lu)/sqr(nW)*r_theta_fw*r_rs^.y[k];
        r_rs^.y[k]:= Rrs^.y[k] + Rrs_surf^.y[k];
        end;
    Rrs^.ParText:='Remote sensing reflectance (sr^-1)';
    r_rs^.ParText:='Radiance reflectance (sr^-1)';
    Rrs^.sim:=TRUE;
    r_rs^.sim:=TRUE;
    end;

procedure calc_R;
{ Irradiance reflectance }
var merk_z : double;
begin
    merk_z:=z.fw;
    if flag_above then z.fw:=0;
    calc_R_deep;
    if flag_shallow then calc_R_shallow;
    z.fw:=merk_z;
    f_R^.sim:=TRUE;
    end;

procedure calc_r_rs;
{ Radiance reflectance }
var k      : integer;
    merk_z : double;
begin
    merk_z:=z.fw;
    if flag_above then z.fw:=0;
    if flag_fluo then calc_Rrs_F(z.fw, zB.fw, fluo.fw, dummy.fw, test.fw);    { Fluorescence }
    if flag_above then calc_R_rs_above
                  else calc_R_rs_below;
    if flag_mult_Rrs then for k:=1 to Channel_number do
        r_rs^.y[k]:=Rrs_factor*r_rs^.y[k];

    { mixed pixel, eq. (2.56)}
    if abs(1-f_nw.fw)>nenner_min then for k:=1 to Channel_number do
        r_rs^.y[k]:=(1-f_nw.fw)*r_rs^.y[k]+f_nw.fw*a_nw^.y[k]/pi;

    r_rs^.ParText:='Radiance reflectance (sr^-1)';
    r_rs^.sim:=TRUE;
    z.fw:=merk_z;
    end;

procedure calc_Lu_below;
{ Upwelling radiance below surface. }
var k         : integer;
    merk_z    : double;
    merk_flag : boolean;
begin
    merk_z:=z.fw;
    merk_flag:=flag_above;
    if flag_above then z.fw:=0;
 {   flag_above:=FALSE;    }
    if flag_fluo then calc_Rrs_F(z.fw, zB.fw, fluo.fw, dummy.fw, test.fw)    { Fluorescence }
                 else calc_Ed_GreggCarder;
    calc_r_rs_below;
    for k:=1 to Channel_number do Lu^.y[k]:= Ed^.y[k]*r_rs^.y[k]+Lf^.y[k];
    Lu^.ParText:='Upwelling radiance (mW m^-2 nm^-1 sr^-1)';
    Lu^.sim:=TRUE;
    z.fw:=merk_z;
    flag_above:=merk_flag;
    end;

procedure calc_Lr;
{ Radiance reflected at the water surface. }
var k  : integer;
begin
    if not flag_use_Ls then begin
        if flag_surf_fw then calc_Ls else calc_Ed_GreggCarder;
        end;
    { else measurement of Ls or Ed is taken }
    for k:=1 to Channel_number do begin
        if flag_surf_fw then Lr^.y[k]:=rho_L.fw * Ls^.y[k]
                        else Lr^.y[k]:=rho_L.fw * Ed^.y[k]/pi;
        end;
    Lr^.ParText:='Radiance reflected at the water surface (mW m^-2 nm^-1 sr^-1)';
    Lr^.sim:=TRUE;
    end;

procedure calc_Lu_above;
{ Upwelling radiance above surface (eq. 2.61). }
var k  : integer;
begin
    calc_Lr;
    for k:=1 to Channel_number do
        Lu^.y[k]:= (1-rho_Lu)/sqr(nW)*Lu^.y[k] + Lr^.y[k];

    { Mixed pixel (eq. 2.73) }
    if abs(f_nw.fw)>nenner_min then for k:=1 to Channel_number do
        Lu^.y[k]:=(1-f_nw.fw)*Lu^.y[k] + f_nw.fw*Ed^.y[k]*a_nw^.y[k]/pi;

    Lu^.ParText:='Upwelling radiance (mW m^-2 nm^-1 sr^-1)';
    Lu^.sim:=TRUE;
    end;

procedure calc_Lu;
{ Upwelling radiance }
begin
    calc_Lu_below;
    if flag_above then calc_Lu_above;
    end;

{ **************************************************************************** }

procedure calc_test;
begin
    if not flag_public then calc_DESIS;    // in unit privates
    end;



end.
