unit meltpond;
{ Version vom 23.9.2019 }

{ Implementation of my melt pond model.
  P. Gege: An analytic model for the spectral reflectance of Arctic sea ice
  and melt ponds. Draft version from 19.9.2019. }

interface

uses classes, SysUtils, math, defaults, fw_calc, misc, invers;

procedure Active_meltpond;
procedure note_parameters_before_MP;
procedure reset_parameters_before_MP;
procedure set_global_parameters_fw_MP;
procedure set_global_parameters_inv_MP;
procedure MP_Rrs_ocean;
procedure calc_p_ice;
procedure calc_meltpond;
procedure perform_fit_meltpond(Sender:TObject);
function  kurve_MP_RRp(k:integer):double;
var       tsun_fw    : double;
          tsun_inv   : double;
          tview_fw   : double;
          tview_inv  : double;


implementation

const  { Constants and parameters for interfaces of melt pond model }
      nIce         : double = 1.31;           // Refractive index of ice
      rho_io       : double = 2.7E-5;         // Radiance reflectance from ice to ocean
      rho_oi       : double = 3.8E-5;         // Radiance reflectance from ocean to ice
      rho_io_E     = 0.0024;                  // Irradiance reflectance from ice to ocean
      rho_oi_E     = 0.0165;                  // Irradiance reflectance from ocean to ice
      rho_pi       : double = 1.8E-5;         // Radiance reflectance from pond to ice
      rho_pi_E     = 0.00088;                 // Irradiance reflectance from pond to ice
      rho_ip_E     = 0.00076;                 // Irradiance reflectance from ice to pond
      rho_pa       : double = 0.0064;         // Radiance reflectance from pond to air
      rho_ap_E     = 0.0141;                  // Irradiance reflectance from air to pond
      rho_pa_E     = 0.0902;                  // Irradiance reflectance from pond to air
      theta_d_a    = 45;                      // Effective sun zenith angle in air for overcast sky
      theta_d_o    = 40;                      // Effective sun zenith angle in ocean
      theta_u_o    = 45;                      // Average zenith angle of upwelling light in ocean
      theta_u_i    = 45.9;                    // Average zenith angle of upwelling light in ice
      theta_d_p    : double = 0;
      theta_d_i    : double = 0;

var   { Previous values of melt pond parameters }
      fl_aph_C   : boolean;
      fl_CXisC0  : boolean;
      fl_bX_linear : boolean;
      fl_Y_exp   : boolean;
      fl_shallow : boolean;
      fl_fluo    : boolean;
      fl_above   : boolean;
      fl_Fresnel_view : boolean;
      fl_use_Ed  : boolean;
      fl_use_Ls  : boolean;
      tModelR    : byte;
      tModelf    : byte;
      tModelfrs  : byte;
      tModelRrsB : byte;
      tModelKdd  : byte;
      tbbW500    : double;
      tQ         : double;
      tnW        : double;
      tChl       : array[0..5]of double;
      tfA        : array[0..5]of double;
      tC_X       : double;
      tC_Mie     : double;
      tC_NAP     : double;
      tC_Y       : double;
      tS         : double;
      tn         : double;
      tT_W       : double;
      tzB        : double;
      tg_dd      : Fitparameters;
      tg_dsr     : Fitparameters;
      tg_dsa     : Fitparameters;

var   cos_u_i    : double;
      cos_d_i    : double;


procedure Active_meltpond;
{ Activate / deactivate parameters of melt pond model in GUI. }
var i : integer;
begin
    for i:=0 to 5 do C[i].active:=TRUE;
    C_X.active       :=TRUE;
    C_Mie.active     :=FALSE;
    bbs_phy.active   :=TRUE;
    C_Y.active       :=TRUE;
    S.active         :=flag_Y_exp;
    n.active         :=TRUE;
    T_W.active       :=FALSE;
    Q.active         :=FALSE;
    rho_L.active     :=FALSE;
    rho_dd.active    :=FALSE;
    rho_ds.active    :=FALSE;
    f_dd.active      :=TRUE;
    f_ds.active      :=TRUE;
    H_oz.active      :=FALSE;
    WV.active        :=FALSE;
    alpha.active     :=TRUE;
    beta.active      :=TRUE;
    f.active         :=FALSE;
    z.active         :=FALSE;
    zB.active        :=TRUE;
    sun.active       :=TRUE;
    view.active      :=TRUE;
    dphi.active      :=FALSE;
    f_nw.active      :=FALSE;
    for i:=0 to 4 do fA[i].active:=TRUE;
    fA[5].active     :=FALSE;
    fluo.active      :=FALSE;
    g_dd.active      :=TRUE;
    g_dsr.active     :=TRUE;
    g_dsa.active     :=TRUE;
    dummy.active     :=FALSE;
    end;

{ **************************************************************************** }
{ **********************         forward simulation          ***************** }
{ **************************************************************************** }

procedure note_parameters_before_MP;
{ Note values of parameters which might be modified during melt pond simulation. }
var k : integer;
begin
    fl_CXisC0:=flag_CXisC0;
    fl_bX_linear:=flag_bX_linear;
    fl_Y_exp:=flag_Y_exp;
    fl_shallow:=flag_shallow;
    fl_fluo:=flag_fluo;
    fl_above:=flag_above;
    fl_Fresnel_view:=flag_Fresnel_view;
    fl_use_Ed:=flag_use_Ed;
    fl_use_Ls:=flag_use_Ls;
    tModelR:=Model_R;
    tModelf:=Model_f;
    tModelfrs:=Model_f_rs;
    tModelRrsB:=Model_R_rsB;
    tModelKdd:=Model_Kdd;
    tbbW500:=bbW500;
    tQ:=Q.fw;
    tsun_fw:=sun.fw;
    tsun_inv:=sun.actual;
    tview_fw:=view.fw;
    tview_inv:=view.actual;
    tnW:=nW;
    for k:=0 to 5 do tChl[k]:=C[k].fw;
    for k:=0 to 5 do tfA[k]:=fA[k].fw;
    tg_dd:=g_dd;
    tg_dsr:=g_dsr;
    tg_dsa:=g_dsr;

    tC_X:=C_X.fw;
    tC_Mie:=C_Mie.fw;
    tC_NAP:=bbs_phy.fw;
    tC_Y:=C_Y.fw;
    tS:=S.fw;
    tn:=n.fw;
    tt_W:=t_W.fw;
    tzB:=zB.fw;
    end;

procedure set_global_parameters_fw_MP;
{ Set melt-pond specific global parameters of forward mode. }
begin
    if f_dd.fw=0 then begin // overcast sky
        sun.fw:=theta_d_a;
        g_dd.fw:=0;
        g_dsa.fw:=0;
        g_dsr.fw:=0;
        fA[4].fw:=1/pi;
        end
    else begin              // blue sky
        sun.fw:=tsun_fw;
        g_dd.fw:=0;
        g_dsa.fw:=1/pi;
        g_dsr.fw:=1/pi;
        fA[4].fw:=0;
        end;
    T_W.fw:=0;
    flag_Fresnel_view:=TRUE;
    flag_use_Ed:=FALSE;
    flag_use_Ls:=FALSE;
    flag_shallow:=TRUE;
    end;

procedure reset_parameters_before_MP;
{ Restore original values used before melt pond modeling. }
var k : integer;
begin
    flag_CXisC0:=fl_CXisC0;
    flag_bX_linear:=fl_bX_linear;
    flag_Y_exp:=fl_Y_exp;
    flag_shallow:=fl_shallow;
    flag_fluo:=fl_fluo;
    flag_above:=fl_above;
    flag_Fresnel_view:=fl_Fresnel_view;
    flag_use_Ed:=fl_use_Ed;
    fl_use_Ls:=flag_use_Ls;
    Model_R:=tModelR;
    Model_f:=tModelf;
    Model_f_rs:=tModelfrs;
    Model_R_rsB:=tModelRrsB;
    Model_Kdd:=tModelKdd;
    bbW500:=tbbW500;
    Q.fw:=tQ;
    sun.fw:=tsun_fw;
    sun.actual:=tsun_inv;
    view.fw:=tview_fw;
    view.actual:=tview_inv;
    nW:=tnW;
    for k:=0 to 5 do C[k].fw:=tChl[k];
    for k:=0 to 5 do fA[k].fw:=tfA[k];
    C_X.fw:=tC_X;
    C_Mie.fw:=tC_Mie;
    bbs_phy.fw:=tC_NAP;
    C_Y.fw:=tC_Y;
    S.fw:=tS;
    n.fw:=tn;
    t_W.fw:=tt_W;
    zB.fw:=tzB;
    g_dd:=tg_dd;
    g_dsr:=tg_dsr;
    g_dsa:=tg_dsa;
    berechne_bbW;       // Reset spectral backscattering by water, bbW
    berechne_bbMie;     // Reset spectral particle backscattering coefficient, bbMie
    berechne_aY(S.fw);  // Reset spectral CDOM absorption coefficient, aY
    end;

procedure calc_a_ice;
{ Absorption of sea ice. Eq. (42).
  fA[1] = f_wi    = Fraction of water in the ice layer
  fA[3] = C_Y_ice = CDOM absorption at 440 nm in ice }
var k  : integer;
begin
    for k:=1 to Channel_number do
        MP_a_i.y[k]:=(1-fA[1].fw)*a_ice.y[k]+fA[1].fw*aW^.y[k]+fA[3].fw*aY^.y[k];
    MP_a_i.ParText:= 'Absorption coefficient of ice layer (m^-1)';
    MP_a_i.sim:=TRUE;
    end;

procedure calc_bb_ice;
{ Backscattering of sea ice. Eq. (43).
  fA[2] = f_air = Fraction of air bubbles in the ice layer. }
var k  : integer;
begin
    for k:=1 to Channel_number do
        MP_bb_i.y[k]:=fA[2].fw*bb_ice;
    MP_bb_i.ParText:= 'Backscattering coefficient of ice layer (m^-1)';
    MP_bb_i.sim:=TRUE;
    end;

procedure calc_u_ice;
{ Backscattering albedo u = omaga_b of sea ice. Eq. (23). }
var k  : integer;
begin
    calc_a_ice;
    calc_bb_ice;
    for k:=1 to Channel_number do
        MP_ui.y[k] := MP_bb_i.y[k] / (MP_a_i.y[k] + MP_bb_i.y[k]);
    MP_ui.ParText:= 'u_i = bb_i / (a_i + bb_i)';
    MP_ui.sim:=TRUE;
    end;

procedure calc_frs_f_Q_ice;
{ Calculate factors f, f_rs and Q of sea ice. }
var k   : integer;
begin
    calc_u_ice;
    for k:=1 to Channel_number do begin
        MP_frsi.y[k]:=calc_f_rs(MP_ui.y[k], 1, sun.fw, view.fw, Q.fw); { Unit misc }
        MP_fi.y[k] :=calc_f(MP_ui.y[k], 1, sun.fw); { Unit misc }
        MP_Qi.y[k]:=calc_Q_f(MP_frsi.y[k], MP_fi.y[k]);
        end;
    MP_frsi.ParText:='f_rs factor of ice';
    MP_fi.ParText  :='f factor of ice';
    MP_Qi.ParText  :='Q factor of ice (sr)';
    MP_frsi.sim:=TRUE;
    MP_fi.sim:=TRUE;
    MP_Qi.sim:=TRUE;
    end;

procedure calc_frs_f_Q_water;
{ Calculate factors f, f_rs, Q and R_rs of melt pond water. }
var k   : integer;
    dum : double;
begin
    dum:=1;
    for k:=1 to Channel_number do begin
        f_rs^.y[k]:=calc_f_rs(omega_b^.y[k], dum, sun.fw, view.fw, Q.fw);
        f_R^.y[k] :=calc_f(omega_b^.y[k], dum, sun.fw);
        if f_rs^.sim then Q_f^.y[k]:=calc_Q_f(f_rs^.y[k], f_R^.y[k]);
        r_rs^.y[k] :=f_rs^.y[k] * omega_b^.y[k]
        end;
    f_R^.ParText:='f factor of melt pond water';
    f_R^.sim:=TRUE;
    r_rs^.ParText:='Radiance reflectance (sr^-1)';
    r_rs^.sim:=TRUE;
    if f_rs^.sim then Q_f^.ParText:='Q factor of melt pond water (sr)';
    if f_rs^.sim then Q_f^.sim:=TRUE;
    end;

procedure MP_Rrs_ocean;
{ Calculate optical properties of the ocean beneath ice.
  All parameters are fix and cannot be changed by the user.
  Before calling this procedure, the re-defined model parameters
  need to be noted using the procedure "note_parameters_before_MP".
  After execution, the original values of the model parameters are
  restored using the procedure "reset_parameters_before_MP".}
var k       : integer;
    nenner  : double;
begin
    // Set model parameters
    flag_CXisC0:=FALSE;
    flag_bX_linear:=TRUE;
    flag_Y_exp:=TRUE;
    flag_shallow:=FALSE;
    flag_fluo:=FALSE;
    flag_above:=false;
    Model_R:=0;         // R model of Gordon et al. (1975)
    Model_f:=4;         // f model of Albert and Mobley (2003), wind speed ignored
    Model_f_rs:=0;      // f_rs model of Albert and Mobley (2003), wind speed ignored
    Model_R_rsB:=0;     // R_rs model below water surface: f_rs * bb / (a+bb)
    Model_Kdd:=0;       // K_dd model of Gege (2012)
    bbW500:=0.00144;    // Backscattering coefficient of oceanic water at 500 nm
    berechne_bbW;       // Update spectrum bbW, Eq. (39)
    nW:=tnW/nIce;       // Relative refractive index water - ice
    sun.fw:=theta_d_o;  // Effective sun zenith angle in ocean
    view.fw:=theta_u_o; // Average zenith angle of upwelling light in ocean
    for k:=0 to 4 do C[k].fw:=0;  // C[0]...C[4]
    C[5].fw:=0.5;       // C[5]
    C_X.fw:=0;          // C_X
    C_Mie.fw:=0.05;     // C_Mie; from Reynolds et al. (2016)
    C_Y.fw:=0.05;       // C_Y
    S.fw:=0.014;        // S
    n.fw:=-1.1;         // n; from Reynolds et al. (2016)
    t_W.fw:=0;          // T_W
    Q.fw:=pi();         // Q
    bbs_phy.fw:=0.001;  // bbs_phy
    rho_io:=Fresnel(sun.fw)/pi;  // Radiance reflectance from ice to ocean; Eq. (32)

    berechne_bbMie;     // Calculate particle backscattering coefficient, bbMie
    berechne_aY(S.fw);  // Calculate CDOM absorption coefficient

    // Calculate a, bb, frs, f and Q of water
    // and internal reflection of the ocean, MP_ro
    calc_R_rs_below;              // Eq. (22)
    calc_frs_f_Q_water;           // Eqs. (24), (25), (26), (22)
    for k:=1 to Channel_number do MP_ro.y[k]:=r_rs^.y[k];
    MP_ro.ParText:='Reflectance of ocean under ice surface (sr^-1)';

    // Calculate transmision of boundary ocean - ice, MP_tau_io
    // and external reflection of the ocean, MP_RRo
    for k:=1 to Channel_number do begin
        nenner:=1-rho_oi_E*Q.fw*MP_ro.y[k];
        if abs(nenner)>nenner_min then
            MP_tau_io.y[k]:=(1-rho_io_E)*(1-rho_oi)/nenner   // Eq. (12)
            else MP_tau_io.y[k]:=1;
        MP_RRo.y[k]:=rho_io +  MP_tau_io.y[k]*MP_ro.y[k];    // Eq. (5)
        end;
    MP_tau_io.ParText:='Transmission of boundary ice - ocean';
    MP_RRo.ParText:='Reflectance of ocean above ice surface (sr^-1)';
    end;

procedure calc_p_ice;
{ Estimate path length ratio, MP_p_ice, based on data from Katlein et al. 2014.
    Q_ice_m = 1.70 +/- 0.05       Table 1 of Katlein et al. 2014
    Q_ice_p = pi                  Approximation for overcast sky
    z_ice   = 1.32 +/- 0.38 m     Table 1 of Katlein et al. 2014
    bb_ice  = 1 m^-1              Assumption }
var k      : integer;
    nenner : double;
begin
    for k:=1 to Channel_number do begin
        nenner:=(a_ice.y[k]+1)*ldd_ice*1.32;
        if abs(nenner)>nenner_min then
            MP_p_ice.y[k]:=1-ln(1.70/pi)/nenner                     // Eq. (31)
            else MP_p_ice.y[k]:=1;
        // Calculate relative path length of diffuse radiation
        MP_lds_ice.y[k]:=MP_p_ice.y[k]*ldd_ice;                     // Eq. (29)
        end;
    MP_p_ice.ParText:='Path length ratio in ice';
    MP_lds_ice.ParText:='Relative path length of diffuse radiation in ice';
    end;

procedure calc_lds_ice;
{ Estimate relative path length of diffuse radiation in ice.
    Q_ice_m = 1.70 +/- 0.05       Table 1 of Katlein et al. 2014
    Q_ice_p = pi                  Approximation for overcast sky }
var k      : integer;
    nenner : double;
begin
    for k:=1 to Channel_number do begin
        nenner:=(MP_a_i.y[k]+MP_bb_i.y[k])*fA[0].fw;
        if abs(nenner)>nenner_min then
            MP_lds_ice.y[k]:=cos(sun.fw*pi/180)*(1-ln(1.70/pi)/nenner)                  // Eq. (32)
            else MP_p_ice.y[k]:=1;
        end;
    MP_lds_ice.ParText:='Relative path length of diffuse radiation in ice';
    end;

procedure calc_MP_ice;
{ Calculate parameters of ice. Re-defined parameters:
  fA[0]    = ice layer thickness
  fA[1]    = fraction of water in the ice layer
  fA[2]    = fraction of air bubbles in the ice layer
  fA[3]    = concentration of CDOM in ice [m^-1] }
var k          : integer;
    nenner     : double;
begin
   // Set sun zenith angle in air for overcast sky
   // No reset to original angle for clear sky because user may have changed it
   if f_dd.fw=0 then sun.fw:=theta_d_a;

   // Calculate angle of incidence, theta_d_i
   // and reflectance at interface for downwelling light, rho_pi
   if zB.fw=0 then begin                                         // bare ice, Eq. (44)
       theta_d_i:=180/pi*arcsin(sin(sun.fw*pi/180)/nIce);
       nW:=nIce;
       end
   else begin                                                    // pond ice, Eq. (45)
       theta_d_p:=180/pi*arcsin(sin(sun.fw*pi/180)/tnW);         // angle in pond
       theta_d_i:=180/pi*arcsin(sin(theta_d_p*pi/180)*tnW/nIce); // angle in ice
       nW:=tnW/nIce;
       sun.fw:=theta_d_p;                                        // SZA in pond
       end;
   rho_pi:=Fresnel(sun.fw)/pi;                                   // Eq. (32)

   cos_d_i:=cos(theta_d_i*pi/180);
   if abs(cos_d_i)<nenner_min then cos_d_i:=1;
   cos_u_i:=cos(theta_u_i*pi/180);

   // Update normalized CDOM absorption spectrum
   berechne_aY(S.fw);

   // Calculate a, bb, frs, f and Q_f of ice
   calc_frs_f_Q_ice;
(*
   // Estimate path length ratio, MP_p_ice
   calc_p_ice;
*)

   // Estimate relative path length of diffuse radiation in ice, MP_lds_ice
   calc_lds_ice;

   // Calculate irradiance extinction coefficient, MP_Kd_i
   // and irradiance transmission, MP_Td_i
   for k:=1 to Channel_number do begin
       MP_Kd_i.y[k]:=(MP_a_i.y[k] + MP_bb_i.y[k])*MP_lds_ice.y[k]/cos_d_i; // Eq. (27)
       MP_Td_i.y[k]:=exp(-MP_Kd_i.y[k]*fA[0].fw);                  // Eq. (13)
       end;
   MP_Kd_i.ParText:='Irradiance extinction coefficient for ice (m^-1)';
   MP_Td_i.ParText:='Irradiance transmission coefficient for ice';

   // Calculate radiance extinction coefficient, MP_ku_i
   // and radiance transmission, MP_tu_i
   for k:=1 to Channel_number do begin
       MP_ku_i.y[k]:=(MP_a_i.y[k] + MP_bb_i.y[k])*ldd_ice/cos_u_i; // Eq. (28)
       MP_tu_i.y[k]:=exp(-MP_ku_i.y[k]*fA[0].fw);                  // Eq. (14)
       end;
   MP_ku_i.ParText:='Radiance extinction coefficient for ice (m^-1)';
   MP_tu_i.ParText:='Radiance transmission coefficient for ice';

   // Calculate internal ice reflection of optically thick ice, MP_ri_inf
   // and internal ice reflection of ice layer, MP_ri
   for k:=1 to Channel_number do begin
       MP_ri_inf.y[k]:=MP_frsi.y[k]*MP_ui.y[k];                    // Eq. (22)
       MP_ri.y[k]:=(1-MP_tu_i.y[k]*MP_Td_i.y[k])*MP_ri_inf.y[k]
           + MP_tu_i.y[k]*MP_Td_i.y[k]*MP_RRo.y[k];                // Eq. (19)
       end;
   MP_ri_inf.ParText:='Reflectance of optically thick ice (sr^-1)';
   MP_ri.ParText:='Reflectance of ice in ice layer (sr^-1)';

   // Calculate transmision of boundary ice - pond, MP_tau_pi
   // and external reflection of ice layer, MP_RRi
   for k:=1 to Channel_number do begin
       nenner:=1-rho_ip_E*MP_Qi.y[k]*MP_ri.y[k];                   // Eq. (12)
       if abs(nenner)>nenner_min then
           MP_tau_pi.y[k]:=(1-rho_pi_E)*(1-rho_pi)/nenner
           else MP_tau_pi.y[k]:=1;
       MP_RRi.y[k]:=rho_pi +  MP_tau_pi.y[k]*MP_ri.y[k];           // Eq. (18)
       end;
   MP_tau_pi.ParText:='Transmission of boundary pond - ice';
   MP_RRi.ParText:='Reflectance of ice above ice layer (sr^-1)';
   end;

procedure calc_meltpond;
{ Calculate parameters of melt pond. }
var k      : integer;
    nenner : double;
begin
    // Calculate parameters of ice
    calc_MP_ice;

    // Set values of global parameters
    nW:=tnW;
    view.fw:=tview_fw;
    sun.fw:=tsun_fw;
    if f_dd.fw=0 then sun.fw:=theta_d_a;        // overcast sky
    rho_pa:=Fresnel(view.fw)/pi;    // Eq. (32)
    bbW500:=0.00111;   // Backscattering coefficient of fresh water at 500 nm
    berechne_bbW;      // Update spectrum bbW, Eq. (39)
    berechne_aY(S.fw); // Update normalized CDOM absorption spectrum

   // Calculate a, bb, frs, f and Q of melt pond
   calc_omega_b;        // a, bb, u=bb/(a+bb)
   calc_frs_f_Q_water;  // f_rs, f_R, Q_f, R_rs

   // Calculate irradiance extinction coefficient, MP_Kd_p
   // and radiance extinction coefficient, MP_ku_p
   calc_Kd;    // calculate Kd, Kdd, Kds
   for k:=1 to Channel_number do begin
       MP_Kd_p.y[k]:=Kd^.y[k];                          // Eq. (27)
       MP_ku_p.y[k]:=Kdd^.y[k];                         // Eq. (28)
       end;
   MP_Kd_p.ParText:='Irradiance extinction coefficient for melt pond (m^-1)';
   MP_ku_p.ParText:='Radiance extinction coefficient for melt pond (m^-1)';

   // Calculate irradiance transmission, MP_Td_p
   // and radiance transmission, MP_tu_p
   for k:=1 to Channel_number do begin
       MP_Td_p.y[k]:=exp(-MP_Kd_p.y[k]*zB.fw);          // Eq. (13)
       MP_tu_p.y[k]:=exp(-MP_ku_p.y[k]*zB.fw);          // Eq. (14)
       end;
   MP_Td_p.ParText:='Irradiance transmission coefficient for pond';
   MP_tu_p.ParText:='Radiance transmission coefficient for pond';

   // Calculate internal reflection of optically thick pond, MP_rp_inf
   // and internal reflection of pond layer, MP_rp
   for k:=1 to Channel_number do begin
       MP_rp_inf.y[k]:=f_rs^.y[k]*omega_b^.y[k];        // Eq. (22)
       MP_rp.y[k]:=(1-MP_tu_p.y[k]*MP_Td_p.y[k])*MP_rp_inf.y[k]
           + MP_tu_p.y[k]*MP_Td_p.y[k]*MP_RRi.y[k];     // Eq. (17)
       end;
   MP_rp_inf.ParText:='Reflectance of optically thick pond (sr^-1)';
   MP_rp.ParText:='Reflectance of pond under water surface (sr^-1)';

   // Calculate reflectance at the pond surface, Rrs_surf
   calc_Rrs_surface;          // in unit fw_calc

   // Calculate transmision of boundary air - pond, MP_tau_ap
   // and external reflection of the pond, MP_RRp
   for k:=1 to Channel_number do begin
       nenner:=1-rho_pa_E*Q_f^.y[k]*MP_rp.y[k];
       if abs(nenner)>nenner_min then
           MP_tau_ap.y[k]:=(1-rho_ap_E)*(1-rho_pa)/nenner        // Eq. (12)
           else MP_tau_ap.y[k]:=1;
       MP_RRp.y[k]:=Rrs_surf^.y[k] + MP_tau_ap.y[k]*MP_rp.y[k]; // Eq. (16)
       end;
   MP_tau_ap.ParText:='Transmission of boundary air - pond';
   MP_RRp.ParText:='Reflectance of pond above water surface (sr^-1)';

   // Copy calculated spectrum to STest
   for k:=1 to Channel_number do STest^.y[k]:=MP_RRp.y[k];
   STest^.ParText:=MP_RRp.ParText;

   for k:=1 to Channel_number do STest^.y[k]:=MP_lds_ice.y[k];
   STest^.ParText:=MP_lds_ice.ParText;

   YText:=STest^.ParText;
   end;


{ **************************************************************************** }
{ **********************          inverse modeling           ***************** }
{ **************************************************************************** }

procedure set_global_parameters_inv_MP;
{ Set melt-pond specific global parameters of inverse mode. }
begin
    if f_dd.actual=0 then begin // overcast sky
        sun.actual:=theta_d_a;
        g_dd.actual:=0;
        g_dsa.actual:=0;
        g_dsr.actual:=0;
        fA[4].actual:=1/pi;
        end
    else begin              // blue sky
        sun.actual:=tsun_inv;
        g_dd.actual:=0;
        g_dsa.actual:=1/pi;
        g_dsr.actual:=1/pi;
        fA[4].actual:=0;
        end;
    T_W.actual:=0;           // T_W = water temperature (°C)
    flag_Fresnel_view:=TRUE;
    flag_use_Ed:=FALSE;
    flag_use_Ls:=FALSE;
    flag_shallow:=TRUE;
    flag_surf_inv:=TRUE;
    end;

procedure perform_fit_meltpond(Sender:TObject);
{ Reflectance of melt pond. Fit parameters:
  c[20]  = f_dd
  c[26]  = zB
  c[27]  = sun }
var j, k       : integer;
begin
    FIT:=4;
    fit_dk:=abs(Nachbar(fit_min[FIT]+fit_dL[FIT])-Nachbar(fit_min[FIT]));
    if fit_dk=0 then fit_dk:=1;
    set_parameters_inverse;              // initialize par.c[i]

    with par do begin

    // Set sun zenith angle in air for overcast sky
    // No reset to original angle for clear sky because user may have changed it
    if c[20]=0 then c[27]:=theta_d_a;
    sz_cos:=cos(arcsin(sin(c[27]*pi/180)/tnW));

    // Calculate angle of incidence, theta_d_i
    // and reflectance at interface for downwelling light, rho_pi
    if c[26]=0 then begin  // bare ice, Eq. (44)
        theta_d_i:=180/pi*arcsin(sin(c[27]*pi/180)/nIce);
        nW:=nIce;
        rho_pi:=Fresnel(c[27])/pi;                                // Eq. (32)
        end
    else begin             // pond ice, Eq. (45)
        theta_d_p:=180/pi*arcsin(sin(c[27]*pi/180)/tnW);          // angle in pond
        theta_d_i:=180/pi*arcsin(sin(theta_d_p*pi/180)*tnW/nIce); // angle in ice
        nW:=tnW/nIce;
        rho_pi:=Fresnel(theta_d_p)/pi;                            // Eq. (32)
        end;

    // Set cosines of angles in ice
    cos_d_i:=cos(theta_d_i*pi/180);
    if abs(cos_d_i)<nenner_min then cos_d_i:=1;
    cos_u_i:=cos(theta_u_i*pi/180);

    // Update IOPs of water which may have been changed during ocean calculations
    bbW500:=0.00111;    // Backscattering coefficient of fresh water at 500 nm
    berechne_bbW;       // Update spectrum bbW, Eq. (39)
    berechne_bbMie;
    berechne_aY(c[10]); // Update normalized CDOM absorption spectrum

    // Initialize radiance reflectance pond - air, rho_pa
    nW:=tnW;
    rho_pa:=Fresnel(c[28])/pi;      // Eq. (32)

    // Set measurement curve
    for k:=1 to Channel_number do data[k, Messung]:=spec[1]^.y[k];

    // Define fit parameters
    for j:=1 to M1  do map[j]:=0;
    for j:=1 to 7   do if fit[j]=1 then map[j]:=j;  // C[i], C_X
    for j:=9 to 10  do if fit[j]=1 then map[j]:=j;  // C_Y, S
    for j:=18 to 19 do if fit[j]=1 then map[j]:=j;  // beta, alpha
    for j:=20 to 21 do if fit[j]=1 then map[j]:=j;  // f_dd, f_ds
    for j:=30 to 32 do if fit[j]=1 then map[j]:=j;  // z_ice, f_wi, f_air
    for j:=37 to 39 do if fit[j]=1 then map[j]:=j;  // g_dd, g_dsr, g_dsa
    if fit[26]=1 then map[26]:=26;                  // zB
    if fit[34]=1 then map[34]:=34;                  // g_dsc

    // Initialize inversion
    setsteps;
    GetData;

    // Run inversion
    Simpl;              // indirect calling of kurve_MP_RRp via kurve(k)

    // Copy fit parameters to actual parameter set
    set_actual_parameters;
    end;
    end;


function omega_pond(k:integer):double;
{ Gordon's IOP for melt pond water. }
var nenner : double;
    bb     : double;
begin
    bb:=bb_coeff(k);
    nenner:=a_coeff(k) + bb;
    if abs(nenner)>nenner_min then
        omega_b.y[k]:=bb/nenner                // Eq. (23)
        else omega_b.y[k]:=1;
    omega_pond:=omega_b.y[k];
    end;

function kurve_a_ice(k:integer):double;
{ Absorption of sea ice. Eq. (42). Parameters:
  par.c[31] = fA[1] = f_wi = Fraction of water in the ice layer
  par.c[33] = fA[3] = CDOM absorption at 440 nm  in ice}
begin
    MP_a_i.y[k]:=(1-par.c[31])*a_ice.y[k]+par.c[31]*aW^.y[k]+par.c[33]*aY^.y[k];
    MP_a_i.sim:=TRUE;
    kurve_a_ice:=MP_a_i.y[k];
    end;

function kurve_bb_ice(k:integer):double;
{ Backscattering of sea ice. Eq. (43). Parameter:
  par.c[32] = fA[2] = f_air = Fraction of air bubbles in the ice layer }
begin
    MP_bb_i.y[k]:=par.c[32]*bb_ice;
    MP_bb_i.sim:=TRUE;
    kurve_bb_ice:=MP_bb_i.y[k];
    end;

function omega_ice(k:integer):double;
{ Gordon's IOP for ice }
var nenner : double;
    bb     : double;
begin
    bb:=kurve_bb_ice(k);
    nenner:=kurve_a_ice(k) + bb;
    if abs(nenner)>nenner_min then
        MP_ui.y[k]:=bb/nenner                // Eq. (23)
        else MP_ui.y[k]:=1;
    omega_ice:=MP_ui.y[k];
    end;

procedure frs_f_Q_ice(k:integer);
{ Calculate factors f, f_rs and Q of sea ice. Parameters:
  par.c[13] = Q
  par.c[26] = zB
  par.c[27] = sun
  par.c[28] = view }
var dum     : double;
    sun_deg : double;
    omega   : double;
begin
    dum:=1;
    omega:=omega_ice(k);

    if par.c[26]=0 then begin  // bare ice
        sun_deg:=par.c[27];    // angle in air
        nW:=nIce;
        end
    else begin                 // pond ice
        sun_deg:=theta_d_p;    // angle in pond
        nW:=tnW/nIce;
        end;

    MP_frsi.y[k]:=calc_f_rs(omega, dum, sun_deg, par.c[28], par.c[13]); { Unit misc }
    MP_fi.y[k]  :=calc_f(omega, dum, sun_deg); { Unit misc }
    MP_Qi.y[k]  :=calc_Q_f(MP_frsi.y[k], MP_fi.y[k]);

    MP_frsi.sim:=TRUE;
    MP_fi.sim:=TRUE;
    MP_Qi.sim:=TRUE;
    end;

procedure frs_f_Q_water(k:integer);
{ Calculate factors f, f_rs, Q of melt pond water. Parameters:
  par.c[13] = Q
  par.c[27] = sun
  par.c[28] = view }
var dum     : double;
    omega   : double;
begin
    dum:=1;
    nW:=tnW;
    omega:=omega_pond(k);

    f_rs^.y[k]:=calc_f_rs(omega, dum, par.c[27], par.c[28], par.c[13]);
    f_R^.y[k] :=calc_f(omega, dum, par.c[27]);
    Q_f^.y[k] :=calc_Q_f(f_rs^.y[k], f_R^.y[k]);

    f_rs^.sim:=TRUE;
    f_R^.sim:=TRUE;
    Q_f^.sim:=TRUE;
    end;

function kurve_MP_ku_p(k:integer):double;
{ Radiance extinction coefficient for melt pond (m^-1) }
begin
    MP_ku_p.y[k]:=kurve_Kdd(k, sz_cos);                    // Eqs. (28)
    MP_ku_p.sim:=TRUE;
    kurve_MP_ku_p:=MP_ku_p.y[k];
    end;

function kurve_MP_Kd_p(k:integer):double;
{ Irradiance extinction coefficient for melt pond (m^-1) }
begin
    MP_Kd_p.y[k]:=kurve_Kd(k);                             // Eqs. (27)
    MP_Kd_p.sim:=TRUE;
    kurve_MP_Kd_p:=MP_Kd_p.y[k];
    end;

function kurve_MP_tu_p(k:integer):double;
{ Radiance transmission coefficient for pond. Parameter:
  par.c[26] = zB = bottom depth }
begin
    MP_tu_p.y[k]:=exp(-kurve_MP_ku_p(k)*par.c[26]);              // Eq. (14)
    MP_tu_p.sim:=TRUE;
    kurve_MP_tu_p:=MP_tu_p.y[k];
    end;

function kurve_MP_Td_p(k:integer):double;
{ Irradiance transmission coefficient for pond. Parameter:
  par.c[26] = zB = bottom depth }
begin
    MP_Td_p.y[k]:=exp(-kurve_MP_Kd_p(k)*par.c[26]);              // Eq. (13)
    MP_Td_p.sim:=TRUE;
    kurve_MP_Td_p:=MP_Td_p.y[k];
    end;

function kurve_MP_rp_inf(k:integer):double;
{ Reflectance of optically thick pond (sr^-1) }
begin
    MP_rp_inf.y[k]:=f_rs^.y[k]*omega_pond(k);                    // Eq. (22)
    MP_rp_inf.sim:=TRUE;
    kurve_MP_rp_inf:=MP_rp_inf.y[k];
    end;

function kurve_MP_ku_i(k:integer):double;
{ Radiance extinction coefficient for ice (m^-1)  }
begin
    MP_ku_i.y[k]:=(kurve_a_ice(k) +
                   kurve_bb_ice(k))*ldd_ice/cos_u_i;             // Eq. (28)
    kurve_MP_ku_i:=MP_ku_i.y[k];
    end;

function kurve_MP_tu_i(k:integer):double;
{ Radiance transmission coefficient for ice. Parameter:
  par.c[30] = fA[0] = z_ice = Ice layer thickness }
begin
    MP_tu_i.y[k]:=exp(-kurve_MP_ku_i(k)*par.c[30]);              // Eq. (14)
    kurve_MP_tu_i:=MP_tu_i.y[k];
    end;

function kurve_MP_Kd_i(k:integer):double;
{ Irradiance extinction coefficient for ice (m^-1) }
begin
    MP_Kd_i.y[k]:=(kurve_a_ice(k) +
                   kurve_bb_ice(k))*MP_lds_ice.y[k]/cos_d_i;     // Eq. (27)
    kurve_MP_Kd_i:=MP_Kd_i.y[k];
    end;

function kurve_MP_Td_i(k:integer):double;
{ Irradiance transmission coefficient for ice. Parameter:
  par.c[30] = fA[0] = z_ice = Ice layer thickness }
begin
    MP_Td_i.y[k]:=exp(-kurve_MP_Kd_i(k)*par.c[30]);              // Eq. (13)
    kurve_MP_Td_i:=MP_Td_i.y[k];
    end;

function kurve_MP_ri_inf(k:integer):double;
{ Reflectance of optically thick ice (sr^-1) }
begin
    MP_ri_inf.y[k]:=MP_frsi.y[k]*MP_ui.y[k];                     // Eq. (22)
    kurve_MP_ri_inf:=MP_ri_inf.y[k];
    end;

function kurve_MP_ri(k:integer):double;
{ Calculate internal ice reflection of ice layer, MP_ri }
var Td_i : double;
    tu_i : double;
begin
    Td_i:=kurve_MP_Td_i(k);
    tu_i:=kurve_MP_tu_i(k);
    MP_ri.y[k]:=(1-tu_i*Td_i)*kurve_MP_ri_inf(k) +
                 tu_i*Td_i*MP_RRo.y[k];                         // Eq. (19)
    kurve_MP_ri:=MP_ri.y[k];
    end;

function kurve_MP_tau_pi(k:integer):double;
{ Transmision of boundary ice - pond }
var nenner : double;
begin
    nenner:=1-rho_ip_E*MP_Qi.y[k]*kurve_MP_ri(k);                // Eq. (12)
    if abs(nenner)>nenner_min then
        MP_tau_pi.y[k]:=(1-rho_pi_E)*(1-rho_pi)/nenner
        else MP_tau_pi.y[k]:=1;
    kurve_MP_tau_pi:=MP_tau_pi.y[k];
    end;

function kurve_MP_RRi(k:integer):double;
{ Reflectance of ice above ice layer (sr^-1) }
begin
    MP_RRi.y[k]:=rho_pi +  kurve_MP_tau_pi(k)*kurve_MP_ri(k);    // Eq. (18)
    MP_RRi.sim:=TRUE;
    kurve_MP_RRi:=MP_RRi.y[k];
    end;

function kurve_MP_rp(k:integer):double;
{ Reflectance of pond under water surface (sr^-1) }
var tu_p : double;
    Td_p : double;
begin
    tu_p:=kurve_MP_tu_p(k);
    Td_p:=kurve_MP_Td_p(k);
    MP_rp.y[k]:=(1-tu_p*Td_p)*kurve_MP_rp_inf(k) +
                 tu_p*Td_p*kurve_MP_RRi(k);                      // Eq. (17)
    MP_rp.sim:=TRUE;
    kurve_MP_rp:=MP_rp.y[k];
    end;

function kurve_MP_tau_ap(k:integer):double;
{ Transmission of boundary air - pond }
var nenner : double;
begin
    nenner:=1-rho_pa_E*Q_f^.y[k]*kurve_MP_rp(k);
    if abs(nenner)>nenner_min then
        MP_tau_ap.y[k]:=(1-rho_ap_E)*(1-rho_pa)/nenner           // Eq. (12)
        else MP_tau_ap.y[k]:=1;
    MP_tau_ap.sim:=TRUE;
    kurve_MP_tau_ap:=MP_tau_ap.y[k];
    end;

function kurve_MP_RRp(k:integer):double;
{ Reflectance of meltpond above water surface (sr^-1) }
begin
//    spec[1]^.y[k]:= MP_lds_ice.y[k];    { to check consistency forward - inverse }

    frs_f_Q_ice(k);    // Calculate a, bb, f, f_rs, Q of sea ice.
    frs_f_Q_water(k);  // Calculate a, bb, f, f_rs, Q of melt pond water
    MP_RRp.y[k]:=kurve_Rrs_surf(k) + kurve_MP_tau_ap(k)*kurve_MP_rp(k);    // Eq. (16)
    MP_RRp.sim:=TRUE;
    kurve_MP_RRp:=MP_RRp.y[k];

//    kurve_MP_RRp:= MP_lds_ice.y[k];      { to check consistency forward - inverse }
    end;


end.

