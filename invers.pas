unit invers;

{$MODE Delphi}

{ Version vom 27.4.2020 }

interface

// uses { $IFDEF private_version} privates, {meltpond,} { $ENDIF}
uses   defaults, misc;

type   PVector   = Array[1..M1+1] of double;    { Set of fit parameters }

const  ch_fit_min   : array[1..FC]of integer = (1, 1, 1, 1);  { first channel that is fitted }
       ch_fit_max   : array[1..FC]of integer = (MaxChannels, MaxChannels, MaxChannels, MaxChannels);  { last channel that is fitted }
       best         : byte = 0;            { Vertex having best residuum }
       worst        : byte = 1;            { Vertex having worst residuum }
var    ign_min, ign_max : double;          { ignore these wavelengths when fitting }
       ch_ign_min, ch_ign_max : integer;   { ignore these channels when fitting }
       IMax        : integer;

procedure neu_aY(SS:double; k:integer);
procedure set_borders;
procedure set_c(n:integer; P:Fitparameters);
procedure perform_fit_Ed_GC(F:byte; Sender:TObject);
procedure calc_R_Rrs;
procedure calc_initial_z_Ed;
procedure calc_initial_X;
procedure calc_initial_X_f;
procedure calc_initial_Y_C;
procedure perform_fit_Lup(F:byte; Sender:TObject);
procedure perform_fit_Rrs0(F:byte; Sender:TObject);
procedure perform_fit_Rrs(F:byte; Sender:TObject);
procedure perform_fit_R(F:byte; Sender:TObject);
procedure perform_fit_Rsurf(Sender:TObject);
procedure perform_fit_a(Sender:TObject);
procedure perform_fit_Kd(Sender:TObject);
procedure perform_fit_test(Sender:TObject);
procedure perform_fit_Rbottom(Sender:TObject);
procedure calculate_Fitfunction;
procedure define_curves;
procedure set_parameters_inverse;
procedure set_actual_parameters;
procedure setsteps;
procedure GetData;
procedure GetData_2D(v: byte);
procedure SumOfResiduals(var vec : PVector);
procedure Simpl;
procedure calc_initial_zB(F:byte; k1, k2: integer);
procedure calc_initial_X_shallow;
procedure calc_initial_Y_C_shallow(Sender:TObject);
procedure calc_initial_fa;
function  Fa_inv(theta:double):double;
function  M(theta:double):double;
function  Tr_GC(M, P:double; k:integer):double;
function  tau_a_GC(k:integer):double;
function  T_as(taua,M:double):double;
function  kurve_kL_uW(k:integer):double;
function  kurve_kL_uB(k:integer):double;
function  kurve_KE_uW(k:integer):double;
function  kurve_KE_uB(k:integer):double;
procedure calculate_Ed0_function;
procedure calculate_K_function;
procedure calculate_Kd_inv;
function  kurve_Rrs_surf(k:integer):double;
function  kurve_Rrs_above(k:integer):double;
function  kurve_Rrs_deep_below(k:integer):double;
function  kurve_R(k:integer):double;
function  kurve_R_deep(k:integer):double;
function  kurve_Kd(k:integer):double;
function  kurve_Kdd(k:integer; sz_cos:double):double;
function  kurve_Kds(k:integer; sz_cos:double):double;
function  kurve_Ed_GC(k:integer):double;
function  a_coeff(k:integer):double;
function  bb_coeff(k:integer):double;

const Root2 = 1.414213562;
      S_ALFA  = 1.0;          { reflection coefficient   >0   }
      S_BETA  = 0.5;          { contraction coefficient  0..1 }
      S_GAMMA = 2.0;          { expansion coefficient    >1   }

type Werte     = (Messung, Theorie);
     DataSet   = array[1..MaxChannels, Werte]of double;  { measured and calculated values }
     Simplex   = Array[1..M1+1] of PVector;   { element M1+1 contains residuum }

var  Data      : DataSet;  { the data set }
     Mean,
     Fehler,
     Step,
     Maxerr,               { maximum error accepted }
     par_Err   : PVector;
     Simp      : Simplex;  { the Simplex }
     Em        : byte;     { Zahl der Variablen des Simplex, in GetData gesetzt }
     Em1       : byte;     { = Em+1, in GetData gesetzt } 
     sum       : double;
     Kurve     : function(j:integer):double;
     r_theta_inv   : double = 1.0;                   { Ratio of cosines of sun zenith angles, inverse mode }

implementation

uses { $IFDEF private_version} privates, meltpond, { $ENDIF}
     fw_calc, math;

{ Downwelling irradiance; model of Gregg and Carder (1990) }

function Fa_inv(theta:double):double;
{ Aerosol forward scattering probability }
var B1, B2, B3 : double;
    argument   : double;
begin
    if par.c[19]<0 then argument:=1-0.82
        else if par.c[19]>1.2 then argument:=1-0.65
        else argument:=1+0.1417*par.c[19]-0.82;
    if argument<nenner_min then argument:=nenner_min;
    B3:=ln(argument);
    B2:=B3*(0.0783+B3*(-0.3824-0.5874*B3));
    B1:=B3*(1.459+B3*(0.1595+0.4129*B3));
    argument:=(B1+B2*cos(theta))*cos(theta);
    if argument>exp_max then argument:=exp_max;
    Fa_inv:=1-0.5*exp(argument);
    end;

function M(theta:double):double;
{ Air mass. The equation given in Gregg and Carder (1990), which was taken from
  Kasten (1965), is not correct. Kasten and Young (1989) provide updated
  numerical values a = 0.50572, b = 6.07995°, c = 1.6364. }
var nenner : double;
    arg    : double;
begin
    arg:=96.07995-theta*180/pi;
    if arg>nenner_min then nenner:=cos(theta)+0.50572*power(arg,-1.6364)
                      else nenner:=cos(theta);
    if abs(nenner)<nenner_min then nenner:=nenner_min;
    M:=1/nenner;
    end;

function Tr_GC(M, P:double; k:integer):double;
{ Transmittance of atmosphere caused by Rayleigh scattering; Gregg and
  Carder (1990) }
var nenner : double;
    sq     : double;
    Mc     : double;  { atmospheric path length corrected for pressure }
begin
    Mc:=M*P/1013.25;
    sq:=sqr(x^.y[k]/1000);
    nenner:=115.6406*sq*sq-1.335*sq;
    if abs(nenner)>nenner_min then if -Mc/nenner<exp_max then Tr_GC := exp(-Mc/nenner)
        else Tr_GC:=0 else Tr_GC:=0;
    end;

function tau_a_GC(k:integer):double;
{ Aerosol optical thickness; Gregg and Carder (1990) }
begin
    if x^.y[k]/Lambda_a>nenner_min then
        tau_a_GC:= par.c[18]*power(x^.y[k]/Lambda_a, -par.c[19])
    else tau_a_GC:=0;
    end;

function T_as(taua,M:double):double;
{ Atmospheric transmittance after aerosol scattering; Gregg and Carder (1990) }
begin
    T_as:= exp(-omega_a*taua*M);
    end;

function T_aa(taua,M:double):double;
{ Atmospheric transmittance after aerosol absorption; Gregg and Carder (1990) }
begin
    T_aa:= exp(-(1-omega_a)*taua*M);
    end;

function T_o(MM:double; k:integer):double;
{ Atmospheric transmittance after oxygen absorption; Gregg and Carder (1990) }
var argument : double;
begin
    argument:=-1.41*aO2^.y[k]*MM/power(1+118.3*aO2^.y[k]*MM,0.45);
    if argument>exp_max then argument:=exp_max;
    T_o:=exp(argument);
    end;

function T_o3(Moz,Hoz:double; k:integer):double;
{ Atmospheric transmittance after ozone absorption; Gregg and Carder (1990) }
var argument : double;
begin
    argument:=-aO3^.y[k]*Moz*Hoz;
    if argument>exp_max then argument:=exp_max;
    T_o3:=exp(argument);
    end;


function T_WV(WV,M:double; k:integer):double;
{ Atmospheric transmittance after water vapor absorption; Gregg and Carder (1990) }
var argument : double;
begin
    argument:=-0.2385*aWV^.y[k]*WV*M/power(1+20.07*aWV^.y[k]*WV*M,0.45);
    if argument>exp_max then argument:=exp_max;
    T_WV:=exp(argument);
    end;


function Edd(sun_a,Tr,Taa,Tas,To3,To2,TWV,Kdd,z,rho:double; k:integer):double;
{ Direct downwelling irradiance, Gregg and Carder (1990) }
var y : double;

begin
    y:=E0^.y[k]*sun_earth*cos(sun_a)*Tr*Taa*Tas*To3*To2*TWV;
    if model_Ed=0 then begin
        if not flag_above then y:=y*exp(-Kdd*z)*r_theta_inv*(1-rho);
        Edd:=y;
        end
    else begin
        if not flag_above then y:=y*exp(-Kdd*z)*r_theta_inv*(1-rho);
        Edd:=par.c[20]*y;
        end;
    end;

function Edsr(sun_a,Tr,Taa,To3,To2,TWV,Kds,z,rho:double; k:integer):double;
{ Diffuse downwelling irradiance from Rayleigh scattering, Gregg and Carder (1990) }
var y : double;
begin
    y:=0.5*E0^.y[k]*sun_earth*cos(sun_a)*Taa*To3*To2*TWV*(1-power(Tr,0.95));
    if not flag_above then y:=y*exp(-Kds*z)*r_theta_inv*(1-rho);
    if model_Ed=0 then Edsr:=y else Edsr:=par.c[21]*y;
    end;

function Edsa(sun_a,Tr,Taa,Tas,Fa,To3,To2,TWV,Kds,z,rho:double; k:integer):double;
{ Diffuse downwelling irradiance, Gregg and Carder (1990) }
var y : double;
begin
    y:=E0^.y[k]*sun_earth*cos(sun_a)*Taa*To3*To2*TWV*power(Tr,1.5)*(1-Tas)*Fa;
    if not flag_above then y:=y*exp(-Kds*z)*r_theta_inv*(1-rho);
    if model_Ed=0 then Edsa:=y else Edsa:=par.c[21]*y;
    end;

function Eu_d(Eds, R, rd0:double):double;
{ Upwelling irradiance reflected downwards at the water surface }
begin
    if flag_above then Eu_d:=0
                  else Eu_d:=par.c[21]*rho_Eu*R*(1+rd0)*Eds;
    end;

function rd0(Tr, Tas, Fa, rho_ds, rho_dd: double):double;
{ Ratio of direct to diffuse Ed component just below water surface }
var nenner : double;
begin
    nenner:=par.c[21]*
                (1-power(Tr,0.95)+2*power(Tr,1.5)*(1-Tas)*Fa)*(1-rho_ds);
    if abs(nenner)<nenner_min then nenner:=nenner_min;
    rd0:=par.c[21]*2*Tr*Tas*(1-rho_dd)/nenner;
    end;

function a_WC_coeff(k:integer):double;
{ Absorption of water constituents. Parameters:
 c[1]..c[6] = C[0]..C[5] = concentration of phytoplankton classes #0..#5
 c[7]       = C_X        = Concentration of suspended particles Type I
 c[8]       = C_Mie      = Concentration of suspended particles Type II
 c[9]       = C_Y        = concentration Gelbstoff
 c[10]      = S          = exponent of Gelbstoff absorption }
var i     : integer;
    lna   : double;
    C_NAP : double;
begin
with par do begin
    if (fit[10]=1) and flag_Y_exp then neu_aY(c[10], k);

    if (not flag_public) and flag_aph_C and (c[1]>nenner_min) and (aphA^.y[k]>nenner_min) then begin
    { Calculate specific phytoplankton absorption as a function of CHL concentration. Reference:
      P. Ylöstalo, K. Kallio and J.  Seppälä (2014): Absorption properties of in-water constituents
      and their variation among various lake types in the boreal region. Remote Sensing of Environment
      148, 190-205. }
        lna:=ln(aphA^.y[k]) - aphB^.y[k] * ln(c[1]);
        aP[0]^.y[k]:=exp(lna);
        end;

    C_NAP:= c[7] + c[8];
    aP_calc^.y[k]:=0;
    for i:=0 to 5 do aP_calc^.y[k]:=aP_calc^.y[k] + c[i+1]*aP[i]^.y[k];
    Chl_a:=0; for i:=0 to 5 do Chl_a:=Chl_a+c[i+1];
    aNAP_calc^.y[k]:=C_NAP * aNAP440 * aNAP^.y[k];
    aCDOM_calc^.y[k]:=c[9]*aY^.y[k];
    a_WC_coeff:=aP_calc^.y[k] + aNAP_calc^.y[k] + aCDOM_calc^.y[k];
    aP_calc^.ParText:='Phytoplankton absorption (1/m)';
    aNAP_calc^.ParText:='Non-algal particle absorption (1/m)';
    aCDOM_calc^.ParText:='CDOM absorption (1/m)';
    end;
    end;

function a_coeff(k:integer):double;
{ Absorption coefficient. Parameter:
  c[12] = T_W      = water temperature }
begin
    a_calc^.y[k]:=a_WC_coeff(k);
    if flag_aW or (spec_type<>S_a) then
        a_calc^.y[k]:=a_calc^.y[k] + aW^.y[k] + (par.c[12]-T_W0)*dadT^.y[k];
    a_coeff:=a_calc^.y[k];
    end;

procedure neu_bS(nn:double; k:integer);
{ Scattering of 'Mie' particles for channel k and Angström exponent nn. }
var n, e : double;
begin
    n:=x^.y[k]/Lambda_S;
    if n<nenner_min then n:=nenner_min;
    e:=nn*ln(n);
    if e<exp_min then bMie^.y[k]:=1
    else if e>exp_max then bMie^.y[k]:=exp(exp_max)
    else bMie^.y[k]:=b_Mie*exp(e);
    end;

procedure neu_bbS(nn:double; k:integer);
{ Backscattering of particles type II for channel k and Angström exponent nn. }
var n, e : double;
begin
    n:=x^.y[k]/Lambda_S;
    if n<nenner_min then n:=nenner_min;
    e:=nn*ln(n);
    if e<exp_min then bbMie^.y[k]:=1
    else if e>exp_max then bbMie^.y[k]:=exp(exp_max)
    else bbMie^.y[k]:=bb_Mie*exp(e);
    end;


function b_coeff(k:integer):double;
{ Scattering coefficient. Parameters:
 c[1]  = C[0]     = concentration of phytoplankton class no. 0
 c[7]  = C_X      = Concentration of suspended particles Type I
 c[8]  = C_Mie    = Concentration of suspended particles Type II
 c[11] = n        = Angström exponent of suspended particles
}
var cc : double;
begin
    if flag_CXisC0 then cc:=par.c[1] else cc:=par.c[7];
    if par.fit[11]=1 then neu_bS(par.c[11], k);
    b_calc^.y[k]:=2*bbW^.y[k] + cc * b_X * bXN^.y[k] + par.c[8] * bMie^.y[k];
    b_coeff:=b_calc^.y[k];
    b_calc^.ParText:='Scattering of water + constituents (1/m)';
    b_calc^.sim:=TRUE;
    end;

function bb_coeff(k:integer):double;
{ Backscattering coefficient. Parameters:
 c[1]  = C[0]     = concentration of phytoplankton class no. 0
 c[7]  = C_X      = concentration suspended particles Type I
 c[8]  = C_Mie    = concentration suspended particles Type II
 c[11] = n        = Angström exponent of particle scattering
}
var fak, cc : double;
    i       : integer;
begin
    if flag_CXisC0 then cc:=par.c[1] else cc:=par.c[7];
    if flag_bX_linear then fak:=bb_X else begin
        { b_bL* = A C^B (Morel 1980) }
        if cc>nenner_min then fak:=bbX_A*exp(bbX_B*ln(cc))
                         else fak:=bbX_A;
        end;
    if par.fit[11]=1 then neu_bbS(par.c[11], k);
    if Chl_a=0 then for i:=0 to 5 do Chl_a:=Chl_a+c[i].actual;
    bb_phy^.y[k]:=Chl_a * par.c[36] * bPhyN^.y[k];
    bb_NAP^.y[k]:=cc * fak * bXN^.y[k] + par.c[8] * bbMie^.y[k];
    bb_calc^.y[k]:=bbW^.y[k] + bb_phy^.y[k] + bb_NAP^.y[k];
    bb_coeff:=bb_calc^.y[k];
    bb_calc^.ParText:='Backscattering coefficient (m^-1)';
    bb_calc^.sim:=TRUE;
    bb_phy^.ParText:='Phytoplankton backscattering coefficient (m^-1)';
    bb_phy^.sim:=TRUE;
    bb_NAP^.ParText:='Non-algal particle backscattering coefficient (m^-1)';
    bb_NAP^.sim:=TRUE;
    end;

function kurve_Kd(k:integer):double;
{ Diffuse attenuation of downwelling irradiance (Gordon 1989) }
begin
    Kd^.y[k]:=ld*(a_coeff(k) + bb_coeff(k))/cos(arcsin(sin(par.c[27]*pi/180)/nW));
    kurve_Kd:= Kd^.y[k];
    Kd^.sim:=TRUE;
    end;

function kurve_Kdd(k:integer; sz_cos:double):double;
{ Attenuation of direct downwelling irradiance }
begin
    if abs(sz_cos)<nenner_min then sz_cos:=nenner_min;
    if model_Kdd=0 then Kdd^.y[k]:= (a_coeff(k) + bb_coeff(k))*ldd/sz_cos
                   else Kdd^.y[k]:= ldda*a_coeff(k)/sz_cos + lddb*bb_coeff(k);
    kurve_Kdd:= Kdd^.y[k];
    Kdd^.sim:=TRUE;
    end;

function kurve_Kds(k:integer; sz_cos:double):double;
{ Attenuation of diffuse downwelling irradiance }
begin
    Kds^.y[k]:= (a_coeff(k) + bb_coeff(k))*(lds0+lds1*(1-sz_cos));
    kurve_Kds:= Kds^.y[k];
    Kds^.sim:=TRUE;
    end;


function kurve_Ed_GC(k:integer):double;
{ Downwelling irradiance Ed, Gregg and Carder (1990) }
var Fa      : double;  { Aerosol forward scattering probability }
    sz_air  : double;  { Sun zenith angle in air }
    sz_water: double;  { Sun zenith angle in water }
    t_M     : double;  { Air mass }
    t_MM    : double;  { Air mass corrected for pressure}
    t_Moz   : double;  { Path length for ozone }
    Tr      : double;  { Rayleigh scattering transmittance }
    tau_a   : double;  { Aerosol optical thickness }
    Tas     : double;  { Aerosol scattering transmittance }
    Taa     : double;  { Aerosol absorption transmittance }
    To2     : double;  { Oxygen transmittance }
    To3     : double;  { Ozone transmittance }
    vp      : double;  { Precipitable water vapor }
    TWV     : double;  { Water vapor transmittance }
    E_dd    : double;  { Direct downwelling irradiance }
    E_dsr   : double;  { Diffuse downwelling irradiance due to Rayleigh scattering }
    E_dsa   : double;  { Diffuse downwelling irradiance due to aerosol scattering }
    E_up    : double;  { Upwelling irradiance }
    rd_0    : double;  { Ratio direct to diffuse irradiance at depth 0- }
    tz      : double;  { Sensor depth }
    tKdd    : double;  { Diffuse attenuation coefficient for direct radiation }
    tKds    : double;  { Diffuse attenuation coefficient for diffuse radiation }
    trhodd  : double;  { Surface reflection factor for direct radiation }
    trhods  : double;  { Surface reflection factor for diffuse radiation }
    nenner  : double;
    flag_merk : boolean;
    Fluo_merk : Attr_spec;
begin
if not flag_use_Ed then with par do begin
    flag_merk:=flag_fluo;
    Fluo_merk:=RrsF^;
    flag_fluo:=FALSE;
    sz_air   :=c[27]*pi/180;
    sz_water :=arcsin(sin(c[27]*pi/180)/nW);

    if (sun.actual<90) and(view.actual=-1) then r_theta_inv:=cos(sz_water)/cos(sz_air)
        else r_theta_inv:=1;

    if flag_above then begin { above water surface }
        tz     :=0;
        tKdd   :=0;
        tKds   :=0;
        trhodd :=0;
        trhods :=0;
        end
    else begin { below water surface }
        tz   :=c[25];
        tKdd :=kurve_Kdd(k, cos(sz_water));
        tKds :=kurve_Kds(k, cos(sz_water));
        if flag_fresnel_sun then trhodd:=Fresnel(c[27])
                            else trhodd:=c[16];
        if flag_calc_rho_ds then trhods:=rho_diffuse(sz_air)
                            else trhods:=c[17];
        end;

    vp      := c[23];
    Fa      := Fa_inv(sz_air);
    t_M     := M(sz_air);
    t_MM    := t_M*GC_P/1013.25;
    t_Moz   := 1.0035/sqrt(sqr(cos(sz_air))+0.007);
    Tr      := Tr_GC(t_M,GC_P,k);
    tau_a   := tau_a_GC(k);
    Tas     := T_as(tau_a,t_M);
    Taa     := T_aa(tau_a,t_M);
    To2     := T_o(t_MM,k);
    To3     := T_o3(t_Moz,c[22],k);
    TWV     := T_WV(vp,t_M,k);
    rd_0    := rd0(Tr, Tas, Fa, trhods, trhodd);
    E_dd    := Edd(sz_air,Tr,Taa,Tas,To3,To2,TWV,tKdd,tz,trhodd,k);
    E_dsr   := Edsr(sz_air,Tr,Taa,To3,To2,TWV,tKds,tz,trhods,k);
    E_dsa   := Edsa(sz_air,Tr,Taa,Tas,Fa,To3,To2,TWV,tKds,tz,trhods,k);
    E_up    := Eu_d(E_dsr+E_dsa, R^.y[k], rd_0);

    { Downwelling irradiance }
    Kurve_Ed_GC:=E_dd + E_dsr + E_dsa + E_up;

    { Ratio of direct to diffuse downwelling irradiance }
    nenner:=E_dsr + E_dsa + E_up;
    if abs(nenner)<nenner_min then nenner:=nenner_min;
    r_d^.y[k]:=E_dd/nenner;
    r_d^.sim:=TRUE;

    { Update vectors of direct and diffuse components }
    GC_Edd^.y[k]:=E_dd;
    GC_Eds^.y[k]:=E_dsr + E_dsa + E_up;
    GC_Edsr^.y[k]:=E_dsr;
    GC_Edsa^.y[k]:=E_dsa;
    Ed^.y[k]     := E_dd + E_dsr + E_dsa + E_up;  { new for fluorescence calculation }
    flag_fluo:=flag_merk;
    RrsF^:=Fluo_merk;
    end
    else kurve_Ed_GC:=Ed^.y[k]; { measurement }
    end;

procedure neu_aY(SS:double; k:integer);
{ Gelbstoff absorption for channel k and exponent SS. }
var e : double;
begin
    e:=-SS*(x^.y[k]-Lambda_0);
    if e<exp_min then aY^.y[k]:=exp(exp_min)
    else if e>exp_max then aY^.y[k]:=exp(exp_max)
    else aY^.y[k]:=exp(e);
    end;

function kurve_Lsurf(k:integer):double;
{ Downwelling radiance reflected at the water surface. Parameters:
 c[37] = g_dd   = Fraction of sky radiance due to direct solar radiation
 c[38] = g_dsr  = Fraction of sky radiance due to Rayleigh scattering
 c[39] = g_dsa  = Fraction of sky radiance due to aerosol scattering  }
// const r_ar     = 0.693;       for Ocean Optics XXIII paper
 begin
    if flag_use_Ls then kurve_Lsurf:=Ls^.y[k] { use measured Ls spectrum }
    else with par do begin                    { calculate Ls spectrum }
        { if not already done, calculate GC_Edd, GC_Edsr, GC_Edsa }
        if flag_use_Ed then kurve_Ed_GC(k);
        kurve_Lsurf:=c[37]*GC_Edd^.y[k] + c[38]*GC_Edsr^.y[k] +
                     c[39]*GC_Edsa^.y[k];
//         r_ar*c[38]*GC_Edsa^.y[k];      for Ocean Optics XXIII paper

        end;
    end;                     

function kurve_Lf_chl(k:integer):double;
{ Chlorophyll-a fluorescence }
begin
    if flag_fluo then kurve_Lf_chl:=Lf^.y[k]
                 else kurve_Lf_chl:=0;
    end;

function kurve_Rrs_surf(k:integer):double;
{ Specular reflectance at the surface. Parameter:
  c[15] = rho_L  = reflection factor for downwelling radiance
  c[34] = fA[4]  = g_dsc in melt pond mode }
var nenner, zaehler : double;
    flag_merk       : boolean;
begin
    flag_merk:=flag_above;
    flag_above:=TRUE;
    if flag_surf_inv then begin { wavelength dependent surface reflections }
        if flag_use_Ed then nenner:=Ed^.y[k]            { use measured Ed spectrum }
                       else nenner:=kurve_Ed_GC(k);     { calculate Ed spectrum }
        if abs(nenner)<nenner_min then nenner:=nenner_min;
        if flag_use_Ls then zaehler:=Ls^.y[k]           { use measured Ls spectrum }
                       else zaehler:=kurve_Lsurf(k);    { calculate Ls spectrum }
        Rrs_surf^.y[k]:=par.c[15] * zaehler / nenner;
        if flag_MP then Rrs_surf^.y[k]:=Rrs_surf^.y[k]+par.c[15]*par.c[34];
        end
    else Rrs_surf^.y[k]:=par.c[15] / pi;
    Rrs_surf^.sim:=TRUE;
    kurve_Rrs_surf:= Rrs_surf^.y[k];
    flag_above:=flag_merk;
    end;

function omega_back(k:integer):double;
{ Backscattering albedo. }
var nenner, b_b : double;
begin
    b_b:=bb_coeff(k);
    if Model_R=0 then nenner:=a_coeff(k) + b_b
                 else nenner:=a_coeff(k);
    if abs(nenner)<nenner_min then nenner:=nenner_min;
    omega_b^.y[k]:= b_b / nenner;
    if omega_b^.y[k]>1 then omega_b^.y[k]:=1;
    omega_back:=omega_b^.y[k];
    end;

function kurve_R_deep(k:integer):double;
{ Subsurface irradiance reflectance of deep water, eq. (2.14). Parameters:
 c[13] = Q        = Q-factor Eu/Lu
 c[24] = f        = f-factor of irradiance reflectance
 c[27] = sun      = sun zenith angle in air }
var w_b : double;
begin
    w_b:=omega_back(k);
    if Model_f>0 then f_R^.y[k]:=calc_f(w_b, bbW^.y[k]/bb_calc^.y[k], par.c[27])
                 else f_R^.y[k]:=par.c[24];
    kurve_R_deep:=f_R^.y[k] * w_b + par.c[13]*RrsF^.y[k];
    end;

function kurve_R_bottom(k:integer):double;
{ Bottom irradiance reflectance (albedo). Parameter:
  c[30]...c[35] = fA[0]...fA[5] = fraction bottom surface type #0 ... #5 }
var  i   : integer;
     sum : double;
begin
    sum:=0;
    for i:=0 to 5 do sum:=sum + par.c[30+i]*albedo[i]^.y[k];
    kurve_R_bottom:=sum;
    end;

procedure adjust_bottom_weight_inv;
{ Adjust weights of bottom albedo such that the sum of all weights is
  between SfA_min and SfA_max. }
var i     : integer;
    sum   : double;
    first : integer;
begin
    sum:=0;   for i:=0 to 5 do sum:=sum + par.c[30+i];
    { Handle the case that all par.c[30+i] are close to zero. }
    if abs(sum)<nenner_min then begin
        first:=0;
        while (par.fit[30+first]=0) and (first<5) do inc(first);
        sum:=SfA_min;
        par.c[30+first]:=sum;
        end;
    if sum<SfA_min then for i:=0 to 5 do par.c[30+i]:=par.c[30+i]*SfA_min/sum;
    if sum>SfA_max then for i:=0 to 5 do par.c[30+i]:=par.c[30+i]*SfA_max/sum;
    end;

function kurve_Rrs_bottom(k:integer):double;
{ Bottom radiance reflectance. Parameter:
  c[30]...c[35] = fA[0]...fA[5] = fraction bottom surface type #0 ... #5 }
var  i   : integer;
     sum : double;
begin
    sum:=0;
    for i:=0 to 5 do sum:=sum + par.c[30+i]*BRDF[i]*albedo[i]^.y[k];
    kurve_Rrs_bottom:=sum;
    end;

function kurve_KE_uW(k:integer):double;
{ K_uW = attenuation of upwelling irradiance backscattered in the water. Parameter:
  c[27] = sun      = sun zenith angle in air }
var mue_sun : double;
begin
    mue_sun:=K2W/cos(arcsin(sin(par.c[27]*pi/180)/nW));
    KE_uW^.y[k]:=(a_calc^.y[k]+bb_calc^.y[k])*exp(K1W*ln(1+omega_b^.y[k]))*(1+mue_sun);
    kurve_KE_uW:=KE_uW^.y[k];
    end;

function kurve_KE_uB(k:integer):double;
{ K_uB = attenuation of upwelling irradiance reflected at the bottom. Parameter:
  c[27] = sun      = sun zenith angle in air }
var mue_sun : double;
begin
    mue_sun:=K2B/cos(arcsin(sin(par.c[27]*pi/180)/nW));
    KE_uB^.y[k]:=(a_calc^.y[k]+bb_calc^.y[k])*exp(K1B*ln(1+omega_b^.y[k]))*(1+mue_sun);
    kurve_KE_uB:=KE_uB^.y[k];
    end;

function kurve_kL_uW(k:integer):double;
{ k_uW = attenuation of upwelling radiance backscattered in the water. Parameter:
  c[27] = sun      = sun zenith angle in air
  c[28] = view     = viewing angle in air }
var mue_sun  : double;
    mue_view : double;
begin
    mue_sun :=K2Wrs/cos(arcsin(sin(par.c[27]*pi/180)/nW));
    mue_view:=1/cos(arcsin(sin(par.c[28]*pi/180)/nW));
    kL_uW^.y[k]:=(a_calc^.y[k]+bb_calc^.y[k])*mue_view*exp(K1Wrs*ln(1+omega_b^.y[k]))*(1+mue_sun);
    kurve_kL_uW:=kL_uW^.y[k];
    end;

function kurve_kL_uB(k:integer):double;
{ k_uW = attenuation of upwelling radiance reflected at the bottom. Parameter:
  c[27] = sun      = sun zenith angle in air
  c[28] = view     = viewing angle in air }
var mue_sun  : double;
    mue_view : double;
begin
    mue_sun :=K2Brs/cos(arcsin(sin(par.c[27]*pi/180)/nW));
    mue_view:=1/cos(arcsin(sin(par.c[28]*pi/180)/nW));
    kL_uB^.y[k]:=(a_calc^.y[k]+bb_calc^.y[k])*mue_view*exp(K1Brs*ln(1+omega_b^.y[k]))*(1+mue_sun);
    kurve_kL_uB:=kL_uB^.y[k];
    end;

function kurve_R_shallow(k:integer):double;
{ Irradiance reflectance below surface for shallow water.  Andreas Albert (2003). Parameter:
  c[25] = z    = sensor depth
  c[26] = zB   = bottom depth }
var Kd, zz : double;
begin
    Kd:=kurve_Kd(k);
    zz:=par.c[26]-par.c[25];
    if zz<0.001 then zz:=0.001;
    kurve_R_shallow:=kurve_R_deep(k) * (1-A1*exp(-(Kd + kurve_KE_uW(k))*zz)) +
                     A2 * kurve_R_bottom(k) * exp(-(Kd + kurve_KE_uB(k))*zz);
    end;

function kurve_R(k:integer):double;
{ Subsurface irradiance reflectance of deep water. }
begin
    if flag_shallow then kurve_R:=kurve_R_shallow(k)
                    else kurve_R:=kurve_R_deep(k);
    end;

function kurve_Rrs_deep_below(k:integer):double;
{ Radiance reflectance of deep water below surface. Parameters:
  c[13] = Q     = Q-factor (sr)
  c[27] = sun   = sun zenith angle
  c[28] = view  = viewing angle }
var w_b    : double;
begin
    w_b:=omega_back(k);
    if Model_R_rsB<2 then begin      { R_rs(0-) = f_rs * omega_b }
        if abs(bb_calc^.y[k])>nenner_min then
            f_rs^.y[k]:=calc_f_rs(w_b, bbW^.y[k]/bb_calc^.y[k], par.c[27], par.c[28], par.c[13])
            else f_rs^.y[k]:=0;
        kurve_Rrs_deep_below:=f_rs^.y[k] * w_b + RrsF^.y[k];
        if R^.sim then Q_f^.y[k]:=calc_Q_f(f_rs^.y[k], f_R^.y[k]);
        { Contribution from fluorescence, RrsF, is calculated in unit fw_calc }
        end
    else begin                  { R_rs(0-) = R / Q }
        if flag_use_R then kurve_Rrs_deep_below:=R^.y[k]/par.c[13]
                      else kurve_Rrs_deep_below:=kurve_R(k)/par.c[13];
        end;
    end;

function kurve_Rrs_shallow_below(k:integer):double;
{ Radiance reflectance below surface for shallow water.
  Andreas Albert (2003). Parameter:
  c[25] = z    = sensor depth
  c[26] = zB   = bottom depth }
var Kd, zz : double;
begin
    Kd:=kurve_Kd(k);
    zz:=par.c[26]-par.c[25];
    if zz<0.001 then zz:=0.001;
    kurve_Rrs_shallow_below:=
        kurve_Rrs_deep_below(k) * (1-A1rs*exp(-(Kd + kurve_kL_uW(k))*zz)) +
        A2rs * kurve_Rrs_bottom(k) * exp(-(Kd + kurve_kL_uB(k))*zz);
    end;

function kurve_Rrs_below(k:integer):double;
{ Radiance reflectance below surface. }
begin
    if flag_shallow then kurve_Rrs_below:=kurve_Rrs_shallow_below(k)
                    else kurve_Rrs_below:=kurve_Rrs_deep_below(k);
    end;

function use_R_rs_below(k:integer):double;
{ Underwater term of R_rs(0+) for Model_R_rsA = 0. Parameter:
  c[13] = Q        = Q-factor (sr) }
var  nenner : double;
     Rrs    : double;
begin
    Rrs:=kurve_Rrs_below(k);
    nenner:=1-rho_Eu*par.c[13]*Rrs;
    if abs(nenner)<nenner_min then nenner:=nenner_min;
    use_R_rs_below:= Rrs/nenner;
    end;

function use_R(k:integer):double;
{ Underwater term of R_rs(0+) for Model_R_rsA = 1. Parameter:
  c[13] = Q        = Q-factor (sr) }
var  nenner : double;
     RR     : double;
begin
    if flag_use_R then RR:=R^.y[k] else RR:=kurve_R(k);
    nenner:=par.c[13] * (1-rho_Eu * RR);
    if abs(nenner)<nenner_min then nenner:=nenner_min;
    use_R:=RR/nenner;
    end;

function use_both(k:integer):double;
{ Underwater term of R_rs(0+) for Model_R_rsA = 2}
var  nenner  : double;
     RR, Rrs : double;
begin
    if flag_use_R then RR:=R^.y[k] else RR:=kurve_R(k);
    Rrs:=kurve_Rrs_below(k);
    nenner:=1 - rho_Eu * RR;
    if abs(nenner)<nenner_min then nenner:=nenner_min;
    use_both:= Rrs/nenner;
    end;


function kurve_Rrs_above(k:integer):double;
{ Radiance reflectance above surface (eq. 2.20) }
var x, xi, r_rs : double;
begin
    if      Model_R_rsA=0 then x:=use_R_rs_below(k)
    else if Model_R_rsA=1 then x:=use_R(k)
    else                       x:=use_both(k);

    if (sun.actual<90) and(view.actual=-1) then
        r_theta_inv := cos(arcsin(sin(par.c[27]*pi/180)/nW)) / cos(par.c[27]*pi/180)
        else r_theta_inv:=1;

    xi:=(1-rho_Ed)*(1-rho_Lu)/sqr(nW);
    r_rs:=xi*r_theta_inv*x + kurve_Rrs_surf(k);
    if abs(par.c[50])>nenner_min then   // mixed pixel (eq. 2.56)
        r_rs:=(1-par.c[50])*r_rs + par.c[50]*a_nw^.y[k]/pi;
    kurve_Rrs_above:=r_rs;
    end;

function kurve_Lup_below(k:integer):double;
{ Upwelling radiance below surface. }
begin
    kurve_Lup_below:=kurve_Rrs_below(k) * kurve_Ed_GC(k) + kurve_Lf_chl(k);
    end;

function kurve_Lr(k:integer):double;
{ Radiance reflected at the water surface. Parameter:
  c[15] = rho_L  = reflection factor for downwelling radiance }
var temp_flag : boolean;
begin
    temp_flag:=flag_above;
    flag_above:=TRUE;
    if flag_surf_inv then Lr^.y[k]:=par.c[15]*kurve_Lsurf(k)
                     else Lr^.y[k]:=par.c[15]*kurve_Ed_GC(k)/pi;
    kurve_Lr:=Lr^.y[k];
    flag_above:=temp_flag;
    end;

function kurve_Lup_above(k:integer):double;
{ Upwelling radiance above surface (eq. 2.45). }
var Lu : double;
begin
    Lu:=(1-rho_Lu)/sqr(nW)*kurve_Lup_below(k) + kurve_Lr(k);
    if abs(par.c[50])>nenner_min then         // mixed pixel (eq. 2.57)
        Lu:=(1-par.c[50])*Lu + par.c[50]*kurve_Ed_GC(k)*a_nw^.y[k]/pi;
    kurve_Lup_above:=Lu;
    end;


procedure set_borders;
{ Define borders of fit interval. }
var j : integer;
begin
    for j:=1 to FC do begin
        ch_fit_min[j]:=Nachbar(fit_min[j]);
        if ch_fit_min[j]<1 then ch_fit_min[j]:=1;
        ch_fit_max[j]:=Nachbar(fit_max[j]);
        if ch_fit_max[j]>Channel_number then ch_fit_max[j]:=Channel_number;
        end;

    ch_Int_min:=Nachbar(Int_min);
    if ch_Int_min<1 then ch_int_min:=1;
    ch_Int_max:=Nachbar(Int_max);
    if ch_Int_max>Channel_number then ch_Int_max:=Channel_number;
    ch_ign_min:=Nachbar(ign_min);
    if ch_ign_min<1 then ch_ign_min:=1;
    ch_ign_max:=Nachbar(ign_max);
    if ch_ign_max>Channel_number then ch_ign_max:=Channel_number;
    end;


procedure GetData_2D(v:byte);
{ Transfer parameters par.c to Simplex' vertex no. v, simp[v]).
  This procedure is called in WASI's 2D mode instead of GetData.
  It corresponds to GetData, except 'step' and 'maxErr' are here not
  initialized. }
var i, p : integer;
begin
    if (v<1) then v:=1 else if (v>M1) then v:=M1;
    for i:=1 to M1+1 do Simp[v,i]:=0;
    Em:=0;  { Em = number of fit parameters }
    for p:=1 to M1 do if (par.fit[p]=1) then begin
        inc(Em);
        Simp[v,Em]:=par.c[p];
        if (v=3) then if (p=26) then Simp[v,Em]:=20; // deep water
        end;
    Em1:=Em+1;
    if mean_R>0 then maxerr[Em1]:=2*mean_R;
    SumOfResiduals(Simp[v]);
    end;


procedure init_Simplex;
{ Define initial steps (par.step_c[i]) and quantisation of fit parameters
  (par_Err[i]). The related parameters f_step and f_err are imported from
  WASI.INI and PRIVATE.INI.
  This parameter specific initialization is implemented in WASI since 13.08.2017.
  Before, an automated routine was used for initialization. }
var i : integer;
begin
    for i:=0 to 5 do begin                                          // C[i]
        par.step_c[1+i]:=C[i].f_step;
        par_Err[1+i]:=C[i].f_err;
        end;
    par.step_c[7]:=C_X.f_step;      par_Err[7]:=C_X.f_err;          // C_X
    par.step_c[8]:=C_Mie.f_step;    par_Err[8]:=C_Mie.f_err;        // C_Mie
    par.step_c[9]:=C_Y.f_step;      par_Err[9]:=C_Y.f_err;          // C_Y
    par.step_c[10]:=S.f_step;       par_Err[10]:=S.f_err;           // S
    par.step_c[11]:=n.f_step;       par_Err[11]:=n.f_err;           // n
    par.step_c[12]:=T_W.f_step;     par_Err[12]:=T_W.f_err;         // T_W
    par.step_c[13]:=Q.f_step;       par_Err[13]:=Q.f_err;           // Q
    par.step_c[14]:=fluo.f_step;    par_Err[14]:=fluo.f_err;        // fluo
    par.step_c[15]:=rho_L.f_step;   par_Err[15]:=rho_L.f_err;       // rho_L
    par.step_c[16]:=rho_dd.f_step;  par_Err[16]:=rho_dd.f_err;      // rho_dd
    par.step_c[17]:=rho_ds.f_step;  par_Err[17]:=rho_ds.f_err;      // rho_ds
    par.step_c[18]:=beta.f_step;    par_Err[18]:=beta.f_err;        // beta
    par.step_c[19]:=alpha.f_step;   par_Err[19]:=alpha.f_err;       // alpha
    par.step_c[20]:=f_dd.f_step;    par_Err[20]:=f_dd.f_err;        // f_dd
    par.step_c[21]:=f_ds.f_step;    par_Err[21]:=f_ds.f_err;        // f_ds
    par.step_c[22]:=H_oz.f_step;    par_Err[22]:=H_oz.f_err;        // H_oz
    par.step_c[23]:=WV.f_step;      par_Err[23]:=WV.f_err;          // WV
    par.step_c[24]:=f.f_step;       par_Err[24]:=f.f_err;           // f
    par.step_c[25]:=z.f_step;       par_Err[25]:=z.f_err;           // z
    par.step_c[26]:=zB.f_step;      par_Err[26]:=zB.f_err;          // zB
    par.step_c[27]:=sun.f_step;     par_Err[27]:=sun.f_err;         // sun
    par.step_c[28]:=view.f_step;    par_Err[28]:=view.f_err;        // view
    par.step_c[29]:=dphi.f_step;    par_Err[29]:=dphi.f_err;        // dphi
    for i:=0 to 5 do begin                                          // fA[i]
        par.step_c[30+i]:=fA[i].f_step;
        par_Err[30+i]:=fA[i].f_err;
        end;
    par.step_c[36]:=bbs_phy.f_step; par_Err[36]:=bbs_phy.f_err;     // bbs_phy
    par.step_c[37]:=g_dd.f_step;    par_Err[37]:=g_dd.f_err;        // g_dd
    par.step_c[38]:=g_dsr.f_step;   par_Err[38]:=g_dsr.f_err;       // g_dsr
    par.step_c[39]:=g_dsa.f_step;   par_Err[39]:=g_dsa.f_err;       // g_dsa
    par.step_c[40]:=delta_r.f_step; par_Err[40]:=delta_r.f_err;     // delta_r
    par.step_c[41]:=alpha_d.f_step; par_Err[41]:=alpha_d.f_err;     // alpha_d
    par.step_c[42]:=beta_d.f_step;  par_Err[42]:=beta_d.f_err;      // beta_d
    par.step_c[43]:=gamma_d.f_step; par_Err[43]:=gamma_d.f_err;     // gamma_d
    par.step_c[44]:=delta_d.f_step; par_Err[44]:=delta_d.f_err;     // delta_d
    par.step_c[45]:=dummy.f_step;   par_Err[45]:=dummy.f_err;       // dummy
    par.step_c[46]:=test.f_step;    par_Err[46]:=test.f_err;        // test
    par.step_c[47]:=alpha_r.f_step; par_Err[47]:=alpha_r.f_err;     // alpha_r
    par.step_c[48]:=beta_r.f_step;  par_Err[48]:=beta_r.f_err;      // beta_r
    par.step_c[49]:=gamma_r.f_step; par_Err[49]:=gamma_r.f_err;     // gamma_r
    par.step_c[50]:=f_nw.f_step;    par_Err[50]:=f_nw.f_err;        // f_nw
    end;


procedure setsteps;
{ Define initial steps and quantisation of fit parameters. }
var j, N : integer;
BEGIN
with par do begin
    init_Simplex;     // define step_c and par_Err (since 13.8.2017)
    par_Err[M1+1]:=0;
    N:=0;
    for j:=1 to M1 do if map[j]=j then begin
        par_Err[M1+1]:=par_Err[M1+1]+sqr(par_Err[j]);
        inc(N);
        end;
    if N>0 then par_Err[M1+1]:=sqrt(par_Err[M1+1])/N;
    end;
    END;

procedure GetData;
{ Transfer parameters par.c to Simplex' first column, simp[1] (vertex no. 1).
  Determine Em (number of fit parameters) and Em1 (= Em+1). }
var  j : integer;
begin
with par do begin

    { Initialize simp[1] }
    for j:=1 to M1+1 do simp[1,j]:=0;

    { Set map, simp, step, maxErr }
    Em1:=1;
    for j:=1 to M1 do
        if map[j]=j then begin
            simp[1, Em1]:=c[j];
            step[Em1]:=step_c[j];
            maxErr[Em1]:=par_Err[j];
            inc(Em1);
            end;
    Em:=Em1-1;  { Number of fit parameters }
    simp[1, Em1]:=0;
    step[Em1]:=0;
    maxerr[Em1]:=res_max; { Apply user-defined threshold for residual }
    end;
    end;


procedure maptopar(var v : PVector; out range : boolean);
{ Vector 'v' contains the fit parameter. Its actual values are copied
  to parameter set 'par'. }
var  j, k  : integer;
begin
with par do begin
    j:=1;
    range:=TRUE;  { all parameters are inside range }
    for k:=1 to M1 do begin
        if map[k]=k then begin
            if      v[j]<cmin[k] then c[k]:=cmin[k]
            else if v[j]>cmax[k] then c[k]:=cmax[k]
            else c[k]:=v[j];
            inc(j);
            end;
        end;
    end;
    end;

Procedure SumOfResiduals(var vec : PVector);
{ Calculate correspondence between measured and calculated spectrum.
  Write the result (residual) to element Em1 of vec. }
var k, n   : integer;
    xx     : double;
    mm, tt : double;   // required for spectral angle
    mt     : double;   // required for spectral angle
    Sum_mm : double;   // required for spectral angle
    Sum_tt : double;   // required for spectral angle
    Sum_mt : double;   // required for spectral angle
    m, t   : double;
    range  : boolean;
    flag_SAM : boolean;
Begin
    Sum := 0.0;
    Sum_mm:=0;
    Sum_tt:=0;
    Sum_mt:=0;
    SAngle:=1;
    n:=0;
    flag_SAM:=FALSE;
    Maptopar (vec, range);
    k:=ch_fit_min[FIT];
    if flag_fluo and (par.map[14]=14) and
        ((spec_type=S_Rrs) or (spec_type=S_R) or (spec_type=S_Lup))
        then calc_Rrs_F(par.c[25],par.c[26],par.c[14],par.c[45],par.c[46]);
    if flag_shallow and (N_fit_bot>0) and (not flag_MP) then adjust_bottom_weight_inv;
    repeat
        data[k, Theorie]:=kurve(k);
        inc(k, fit_dk);
    until k>ch_fit_max[FIT];
    k:=ch_fit_min[FIT];
    repeat
        m:=Data[K, Messung];
        t:=Data[K, Theorie];
        if flag_Res_log then begin { logarithmic weighting }
            if m>nenner_min then m:=ln(m) else m:=ln(nenner_min);
            if t>nenner_min then t:=ln(t) else t:=ln(nenner_min);
            end;
        if res_mode=0 then xx:=Sqr(t-m)             // least squares
        else if res_mode=1 then xx:=abs(t-m)        // absolute differences
        else begin                                  // relative differences
            if abs(m)>nenner_min then xx:=abs(1-t/m)
            else xx:=0;
            end;
        Sum := Sum + Gew^.y[k]*xx;
                                                    // spectral angle
        mm:=sqr(m);
        tt:=sqr(t);
        mt:=m*t;
        Sum_mm:=Sum_mm + Gew^.y[k]*mm;
        Sum_tt:=Sum_tt + Gew^.y[k]*tt;
        Sum_mt:=Sum_mt + Gew^.y[k]*mt;

        inc(k, fit_dk);
        if Gew^.y[k]<>0 then inc(n);
    until k>ch_fit_max[FIT];
    if n>0 then begin
        if res_mode=0 then vec[Em1]:=sqrt(sum)/n    // least squares
        else if res_mode=1 then vec[Em1]:=sum/n     // absolute differences
        else if res_mode=2 then vec[Em1]:=sum/n;    // relative differences
        SAngle:=pi;                                 // spectral angle
        if abs(sum_mm*sum_tt)>nenner_min then begin
            SAngle:=sum_mt/sqrt(sum_mm*sum_tt);
            if (SAngle>=-1) and (SAngle<=1) then SAngle:=abs(arccos(SAngle));
            end;
        Resid:=vec[Em1];
  //      if flag_SAM then Resid:=Resid*SAngle;
        end;
    End;


procedure simpl;
{ Carrying out the fit routine. }
{ The algorithm is published here:
  - Nelder J.A. & R. Mead, Computer J. 7, 308 (1965)
  - L.A. Yarbro & S.N. Deming, Anal. Chim. Acta 74, 391(1974)
  The original Pascal procedure is from Marco Caceci, with help from
  William Caceris, 1983. It was published in BYTE May 1984.
  The procedure has been refined and adapted to WASI by Peter Gege. }

var
    Done    : Boolean;                    { convergence }
    i, j    : integer;
    D       : double;
    p, q,              { to compute first simplex }
    Next,              { new vertex to be tested }
    Center  : pvector; { center of hyperplane described by all vertexes,
                         excluding the worst }


    Procedure NewVertex;           { next in place of worst vertex }
    BEGIN
        { Worst is Vertex having worst residuum }
        Simp[Worst] := Next;
    End;

    Procedure Order;    { gives high/low in each parameter dimension }
    var j : integer;
    begin
            for j:=1 to Em1 do begin   // abs() added 24.4.2020
                If abs(Simp[j,Em1]) < abs(Simp[Best,Em1])  then  Best := j;
                If abs(Simp[j,Em1]) > abs(Simp[Worst,Em1]) then Worst := j;
                end;
        end;


BEGIN     { SIMPLEX}
    IMax:=NIter + Maxiter[FIT];

    if flag_Simpl_ini then begin
        SumOfResiduals(simp[1]); { first vertex }
        For i:=1 to Em Do begin { compute offset of the vertexes }
            p[i] := Step[i] * (sqrt(Em1) + Em ) / (Em1 * Root2);
            q[i] := Step[i] * sqrt(Em1) / (Em1 * Root2)
            end;
        For j:=2 to Em1 Do Begin { all vertexes of the starting simplex }
            For i:=1 to Em Do
                Simp[j,i] := simp[1,i] + q[i];
            Simp[j,j-1] := simp[1,j-1] + p[j-1];
            SumOfResiduals(Simp[j]);  { and their residuals }
            End;
        end;
    if Best=0 then Best:=1;    // Initialize only first fit, new 27.4.2020
    Worst:=1;
    Order;

    REPEAT
        inc(NIter);
        For I:=1 TO Em DO BEGIN
            D := 0.0;
            For J:=1 to Em1 Do      { compute centroid }
                if J <> Worst then  D := D  + Simp[J,I];
            Center[I] := D/Em;
            { first attempt to reflect }
            Next[i] := Center[i]*(1.0+S_ALFA) - Simp[Worst,i]*S_ALFA
            { next vertex is the specular reflection of the worst }
            END;
        SumOfResiduals(Next);

        If Next[Em1] <= Simp[Best,Em1] Then Begin
            { better than the best }
            NewVertex;

            { try a 2nd expansion }
            For i:=1 to Em Do
                Next[i] := S_GAMMA * Simp[Worst,i]
                           + (1.0- S_GAMMA) * Center[i];
            SumOfResiduals(Next);
            { still better ? }
            If Next[Em1] <= Simp[Best,Em1] Then
                { yes, accept it }
                NewVertex
        End

        Else Begin
            { not better than the best }
            If Next[Em1] <= Simp[Worst,Em1] Then
                { better than the worst }
                NewVertex
            Else Begin
                { worse than worst -> contract }
                FOR i:=1 TO Em DO
                    Next[i] := Simp[Worst,i]*S_BETA
                               + Center[i]*(1.0-S_BETA);
                SumOfResiduals(Next);
                If Next[Em1] <= Simp[Worst,Em1] Then
                    { now better than worst, contraction accepted }
                    NewVertex
                Else Begin
                    { still bad, shrink all bad vertexes towards best }
                    FOR j:=1 TO Em1 DO BEGIN
                        if j<>Best then FOR I:=1 TO Em DO   // j<>Best new 24.4.2020
                            Simp[j,i] := Simp[j,i]*S_BETA
                                         +Simp[Best,i]*(1.0-S_BETA);
                        SumOfResiduals(Simp[j]);
                    End { j loop }
                End     { else }
            End         { else }
        End;            { else }

        Order;

        Done := TRUE;

        for i:=1 to Em1 do begin
            Fehler[i] := abs(Simp[Worst,i]-Simp[Best,i]);
            If Fehler[i] > Maxerr[i] then Done := FALSE;
            end;
        if (MaxErr[Em1]>0) and (abs(Simp[Best,Em1])> MaxErr[Em1]) then Done:=FALSE;
    UNTIL Done Or (NIter >= IMax);
    for i:=1 to Em do Mean[i]:=simp[best,i];
    SumOfResiduals(Mean);
end;

procedure Null2Eins(var spek: spektrum);
{ Replace 0 by 1 }
var k : integer;
begin
    for k:=1 to MaxChannels do if abs(spek[k])<nenner_min then spek[k]:=1.0;
    end;

procedure set_c(n:integer; P:Fitparameters);
{ Set model parameter no. n of inverse mode. }
begin
    par.c[n]      := P.actual;    { parameter value }
    par.step_c[n] := P.f_step;    { initial steps }
    par.cmin[n]   := P.min;       { minimum allowed for inverse modeling }
    par.cmax[n]   := P.max;       { maximum allowed for inverse modeling }
    par.fit[n]    := P.fit;       { parameter is fit parameter? 0: no, 1: yes }
    end;

procedure set_parameters_inverse;
{ Set model parameters for inverse mode. }
var i : integer;
begin
    for i:=0 to 5 do set_c(i+1,  C[i]);
    set_c(7,  C_X);
    set_c(8,  C_Mie);
    set_c(9,  C_Y);
    set_c(10, S);
    set_c(11, n);
    set_c(12, T_W);
    set_c(13, Q);
    set_c(14, fluo);
    set_c(15, rho_L);
    set_c(16, rho_dd);
    set_c(17, rho_ds);
    set_c(18, beta);
    set_c(19, alpha);
    set_c(20, f_dd);
    set_c(21, f_ds);
    set_c(22, H_oz);
    set_c(23, WV);
    set_c(24, f);
    set_c(25, z);
    set_c(26, zB);
    set_c(27, sun);
    set_c(28, view);
    set_c(29, dphi);
    set_c(30, fA[0]);
    set_c(31, fA[1]);
    set_c(32, fA[2]);
    set_c(33, fA[3]);
    set_c(34, fA[4]);
    set_c(35, fA[5]);
    set_c(36, bbs_phy);
    set_c(37, g_dd);
    set_c(38, g_dsr);
    set_c(39, g_dsa);
    set_c(40, delta_r);
    set_c(41, alpha_d);
    set_c(42, beta_d);
    set_c(43, gamma_d);
    set_c(44, delta_d);
    set_c(45, dummy);
    set_c(46, test);
    set_c(47, alpha_r);
    set_c(48, beta_r);
    set_c(49, gamma_r);
    set_c(50, f_nw);
    N_fit_bot:=0;
    for i:=30 to 35 do if par.fit[i]=1 then inc(N_fit_bot);
    end;


procedure set_actual_parameters;
{ Set actual parameter values after inversion. }
var i : integer;
begin
    for i:=0 to 5 do C[i].actual := par.c[i+1];
    with par do begin
    C_X.actual       := c[7];
    C_Mie.actual     := c[8];
    C_Y.actual       := c[9];
    S.actual         := c[10];
    n.actual         := c[11];
    T_W.actual       := c[12];
    Q.actual         := c[13];
    fluo.actual      := c[14];
    rho_L.actual     := c[15];
    rho_dd.actual    := c[16];
    rho_ds.actual    := c[17];
    beta.actual      := c[18];
    alpha.actual     := c[19];
    f_dd.actual      := c[20];
    f_ds.actual      := c[21];
    H_oz.actual      := c[22];
    WV.actual        := c[23];
    f.actual         := c[24];
    z.actual         := c[25];
    zB.actual        := c[26];
    sun.actual       := c[27];
    view.actual      := c[28];
    dphi.actual      := c[29];
    fA[0].actual     := c[30];
    fA[1].actual     := c[31];
    fA[2].actual     := c[32];
    fA[3].actual     := c[33];
    fA[4].actual     := c[34];
    fA[5].actual     := c[35];
    bbs_phy.actual   := c[36];
    g_dd.actual      := c[37];
    g_dsr.actual     := c[38];
    g_dsa.actual     := c[39];
    delta_r.actual   := c[40];
    alpha_d.actual   := c[41];
    beta_d.actual    := c[42];
    gamma_d.actual   := c[43];
    delta_d.actual   := c[44];
    dummy.actual     := c[45];
    test.actual      := c[46];
    alpha_r.actual   := c[47];
    beta_r.actual    := c[48];
    gamma_r.actual   := c[49];
    f_nw.actual      := c[50];
    end;
    end;


{ ************************************************************************** }

procedure define_fitted_parameters_Ed_GC(F:byte);
var j : integer;
begin
    with par do begin
        for j:=1 to M1 do map[j]:=0;
        case F of
            2: begin
                   if fit[20]=1 then map[20]:=20; { f_dd }
                   end;
            4: begin
                   if fit[27]=1 then map[27]:=27; { sun zenith angle }
                   if flag_above then
                       for j:=18 to 23 do if fit[j]=1 then map[j]:=j;
                   if not flag_above then begin { below surface: R parameters }
                       if not flag_use_Ed then begin
                           for j:=18 to 19 do if fit[j]=1 then map[j]:=j;
                           if Model_Ed=1 then for j:=20 to 21 do if fit[j]=1 then map[j]:=j;
                           for j:=22 to 23 do if fit[j]=1 then map[j]:=j;
                           end;
                       for j:=1 to 17 do if fit[j]=1 then map[j]:=j;
                       if fit[24]=1 then map[24]:=24;   { f }
                       if fit[25]=1 then map[25]:=25;   { z }
                       if fit[46]=1 then map[46]:=46;   { test }
                       end;
                   end;
            end;
        end;
    end;

procedure perform_fit_Ed_GC(F:byte; Sender:TObject);
var k : integer;
begin
    FIT:=F;
    fit_dk:=abs(Nachbar(fit_min[FIT]+fit_dL[FIT])-Nachbar(fit_min[FIT]));
    if fit_dk=0 then fit_dk:=1;
    set_parameters_inverse;
    for k:=1 to Channel_number do data[k, Messung]:=spec[1]^.y[k];
    define_fitted_parameters_Ed_GC(F);
    setsteps;
    GetData;
    Simpl;
    set_actual_parameters;
    end;

procedure define_fitted_parameters_Rrs0(F:byte);
{ Define which parameters are kept constant and which are fitted. }
var j : integer;
begin
with par do begin
    for j:=1 to M1 do par.map[j]:=0;
    case F of
        2: begin { Fit C_X and g_dd, and zB if shallow water }
               if fit[7]=1  then map[7]:=7;     { fit of C_X }
               if (flag_shallow) and (fit[26]=1) then map[26]:=26;  { fit of zB }
               if fit[37]=1 then map[37]:=37;   { fit of g_dd }
               end;
        3: begin { Fit only C_P, C_Y, S and Q, and zB if shallow water }
               for j:=1 to 6 do if fit[j]=1 then map[j]:=j;  { fit of C_P }
               if fit[9]=1  then map[9]:=9;     { fit of C_Y }
               if fit[10]=1 then map[10]:=10;   { fit of S }
               if fit[13]=1 then map[13]:=13;   { fit of Q }
               if (flag_shallow) and (fit[26]=1) then map[26]:=26;  { fit of zB }
               if fit[37]=1 then map[37]:=37;   { fit of g_dd }
               end;
        4: begin { Fit all parameters of R_rs model }
               for j:=1 to M1 do if fit[j]=1 then map[j]:=j;
               for j:=41 to 44 do map[j]:=0;      // no fit of old Ed parameters }
               if not flag_shallow then begin     // optically deep water
                   map[26]:=0;                    // not fit of water depth
                   for j:=30 to 35 do map[j]:=0;  // no fit of bottom parameters
                   end;
               end;
        end;
    end;
    end;

procedure perform_fit_Rrs0(F:byte; Sender:TObject);
{ Fit radiance reflectance with constant surface reflections. }
var k : integer;
begin
    FIT:=F;
    if flag_Simpl_ini then fit_dk:=abs(Nachbar(fit_min[F]+fit_dL[F])-Nachbar(fit_min[F]));
    if fit_dk=0 then fit_dk:=1;
    with par do begin
        if flag_Simpl_ini then set_parameters_inverse;
        for k:=1 to Channel_number do data[k, Messung]:=spec[1]^.y[k];
        for k:=1 to Channel_number do neu_bbS(c[11], k);
        if flag_Simpl_ini then begin
            define_fitted_parameters_Rrs0(F);
            setsteps;
            GetData;
            end;
        Simpl;
        if flag_Simpl_ini then set_actual_parameters;
        end;
    end;

procedure define_fitted_parameters_Rrs(F:byte);
{ Define which parameters are kept constant and which are fitted. }
var j : integer;
begin
with par do begin
    for j:=1 to M1 do par.map[j]:=0;
    case F of
        // Pre-fit of infrared region
        2: begin { Fit C_X, Q, g_dd, and zB if shallow water }
               if fit[7]=1  then map[7]:=7;     { fit of C_X }
               if fit[8]=1  then map[8]:=8;     { fit of C_Mie }
               if (flag_shallow) and (fit[26]=1) then map[26]:=26;  { fit of zB }
               if fit[37]=1 then map[37]:=37;   { fit of g_dd }
               end;

        // Pre-fit of blue region
        3: begin { Fit C_P, C_Y, S, Q and weights of Lu*, and zB if shallow water }
               for j:=1 to 6 do if fit[j]=1 then map[j]:=j; { fit of phytoplankton }
               if fit[9]=1  then map[9]:=9;     { fit of C_Y }
               if fit[10]=1 then map[10]:=10;   { fit of S }
               if (flag_shallow) and (fit[26]=1) then map[26]:=26;  { fit of zB }
               end;

        // Final fit
        4: begin { Fit all parameters of R_rs model }
               for j:=1 to M1   do if fit[j]=1 then map[j]:=j;
               end;
        end;
    end;
    end;

procedure perform_fit_Rrs(F:byte; Sender:TObject);
{ Fit radiance reflectance with wavelength dependent surface reflections. }
var k : integer;
begin
    FIT:=F;
    if flag_Simpl_ini then fit_dk:=abs(Nachbar(fit_min[F]+fit_dL[F])-Nachbar(fit_min[F]));
    if fit_dk=0 then fit_dk:=1;
    with par do begin
        if flag_Simpl_ini then set_parameters_inverse;
        for k:=1 to Channel_number do data[k, Messung]:=spec[1]^.y[k];
        for k:=1 to Channel_number do neu_bbS(c[11], k);
        if flag_Simpl_ini then begin
            define_fitted_parameters_Rrs(F);
            setsteps;
            GetData;
            end;
        Simpl;
        if flag_Simpl_ini then set_actual_parameters;
        end;
    end;

procedure define_fitted_parameters_Lup(F:byte);
{ Define which parameters are kept constant and which are fitted. }
var j : integer;
begin
with par do begin
    for j:=1 to M1 do par.map[j]:=0;
    case F of
        2: begin { Fit of X, Q, and surface parameters }
               if fit[7]=1  then map[7]:=7;     { fit of X }
               if fit[13]=1 then map[13]:=13;   { fit of Q   }
               if fit[15]=1 then map[15]:=15;   { fit of rho_L }
               if fit[16]=1 then map[16]:=16;   { fit of rho_dd }
               if fit[17]=1 then map[17]:=17;   { fit of rho_ds }
               for j:=37 to 39 do               { fit of g_dd, g_dsr, g_dsa }
                   if flag_surf_inv and (fit[j]=1) then map[j]:=j else map[j]:=0;
               end;
        3: begin { Fit C[0], C_Y, S, Q, and eventually weights of Lu* }
               if fit[1]=1  then map[1]:=1;     { fit of C[0] }
               if fit[9]=1  then map[9]:=9;     { fit of C_Y }
               if fit[10]=1 then map[10]:=10;   { fit of S }
               if fit[13]=1 then map[13]:=13;   { fit of Q }
               if flag_surf_inv then for j:=37 to 39 do
                   if fit[j]=1 then map[j]:=j; { fit of weights of L_s }
               end;
        4: begin { Fit all parameters of L_up model }
               for j:=1 to M1   do if fit[j]=1 then map[j]:=j;
               if not flag_surf_inv then for j:=37 to 39 do map[j]:=0; { no fit of L_s }
               end;
        end;
    end;
    end;

procedure perform_fit_Lup(F:byte; Sender:TObject);
{ Fit upwelling radiance. }
var k : integer;
begin
    FIT:=F;
    fit_dk:=abs(Nachbar(fit_min[F]+fit_dL[F])-Nachbar(fit_min[F]));
    if fit_dk=0 then fit_dk:=1;
    with par do begin
        set_parameters_inverse;  { actual --> par.c }
        for k:=1 to Channel_number do data[k, Messung]:=spec[1]^.y[k];
        define_fitted_parameters_Lup(F);
        setsteps;
        GetData;
        Simpl;
        set_actual_parameters;
        if flag_above then Lr^.ParText:=
            'Radiance reflected at the water surface (mW m^-2 nm^-1 sr^-1)';
        end;
    end;

{ **************************************************************************** }
{ **************  Determine initial values  ********************************** }
{ **************************************************************************** }


function zB_analytic(k:integer):double;
{ Analytical estimate of bottom depth using eqs. (4.8) and (4.9)
  in Dissertation of Albert (2004), which are identical to eqs. (9) and (10)
  in Albert and Gege (2006).
  c[13] = Q
  c[28] = view = viewing angle }
var mue_view         : double;
    bot, refl, deep  : double;
    nenner, fak      : double;
    xi, Gamma        : double;
begin
    zB_analytic:=0;
    mue_view:=cos(arcsin(sin(par.c[28]*pi/180)/nW));
    xi:=(1-rho_Ed)*(1-rho_Lu)/sqr(nW);
    Gamma:=rho_Eu*par.c[13];

    refl:=spec[S_actual]^.y[k]-refl_IR; // Radiance reflectance above water
    if refl<nenner_min then refl:=nenner_min;
    refl:=refl/(xi+Gamma*refl);         // radiance reflectance under water

    if spec_type=S_Rrs then begin
        bot :=kurve_Rrs_bottom(k);              { bottom reflectance }
        deep:=kurve_Rrs_deep_below(k); {Radiance reflectance of deep water}
        nenner:=deep - refl;
        if abs(nenner)<nenner_min then zB_analytic:=zB_inimin else begin
            fak:=(A1rs*deep - A2rs*bot)/nenner;
            if fak<nenner_min then zB_analytic:=10 else begin
                fak:=ln(abs(fak));
                nenner:= (1+1/mue_view) * kurve_Kd(k);
                if abs(nenner)<nenner_min then nenner:=nenner_min;
                zB_analytic:=fak/nenner;
                end;
            end;
        end
    else if spec_type=S_R then begin
        bot :=kurve_R_bottom(k);              { bottom reflectance }
        deep:=kurve_R_deep(k);  { reflectance of deep water }
        nenner:=deep - refl;
        if abs(nenner)<nenner_min then zB_analytic:=zB_inimin else begin
            fak:=(A1*deep - A2*bot)/nenner;
            if abs(fak)<nenner_min then fak:=ln(nenner_min) else fak:=ln(fak);
            nenner:=2 * kurve_Kd(k);
            if abs(nenner)<nenner_min then nenner:=nenner_min;
            zB_analytic:=fak/nenner;
            end;
        end;
    end;


procedure calc_R_Rrs;
{ Subtract surface reflections from radiance reflectance measurement
  to obtain remote sensing reflectance. }
var k : integer;
begin
    for k:=1 to Channel_number do begin
        Rrs^.y[k]:=spec[1]^.y[k]-Rrs_surf^.y[k];
        R^.y[k]:=kurve_R(k);
        end;
    Rrs^.sim:=TRUE;
    Rrs^.ParText:='Rrs';
    R^.sim:=TRUE;
    R^.ParText:='R';
    end;

procedure calc_initial_z_Ed;
{ Analytic calculation of sensor depth for irradiance measurement. }
var kuN, koN  : integer;
    kuZ, koZ  : integer;
    k         : integer;
    E0N, E0Z  : double;
    EdN, EdZ  : double;
    Kd1, Kd2  : double;
    rz, r0    : double;
    sz_air    : double;
    sz_water  : double;
    t_M       : double;
    t_MM      : double;
    t_Moz     : double;
    ratio     : double;
begin
    sz_air   :=par.c[27]*pi/180;
    sz_water :=arcsin(sin(par.c[27]*pi/180)/nW);
    t_M     := M(sz_air);
    t_MM    := t_M*GC_P/1013.25;
    t_Moz   := 1.0035/sqrt(sqr(cos(sz_air))+0.007);

    kuN:=Nachbar(LambdaRN-dLambdaRN);
    koN:=Nachbar(LambdaRN+dLambdaRN);
    kuZ:=Nachbar(LambdaRZ-dLambdaRZ);
    koZ:=Nachbar(LambdaRZ+dLambdaRZ);
    E0N:=0; E0Z:=0;
    EdN:=0; EdZ:=0;
    Kd1:=0; Kd2:=0;
    for k:=kuN to koN do E0N:=E0N+Edd(sz_air,
                         Tr_GC(t_M,GC_P,k),T_aa(tau_a_GC(k),t_M),
                         T_as(tau_a_GC(k),t_M),T_o3(t_Moz,par.c[22],k),
                         T_o(t_MM,k),T_WV(par.c[23],t_M,k),kurve_Kd(k),
                         0,Fresnel(par.c[27]),k);
    for k:=kuZ to koZ do E0Z:=E0Z+Edd(sz_air,
                         Tr_GC(t_M,GC_P,k),T_aa(tau_a_GC(k),t_M),
                         T_as(tau_a_GC(k),t_M),T_o3(t_Moz,par.c[22],k),
                         T_o(t_MM,k),T_WV(par.c[23],t_M,k),kurve_Kd(k),
                         0,Fresnel(par.c[27]),k);
    for k:=kuN to koN do EdN:=EdN+spec[1]^.y[k];
    for k:=kuZ to koZ do EdZ:=EdZ+spec[1]^.y[k];
    for k:=kuZ to koZ do Kd1:=Kd1+kurve_Kd(k);
    for k:=kuN to koN do Kd2:=Kd2+kurve_Kd(k);
    EdN:=EdN/(koN-kuN+1);
    EdZ:=EdZ/(koZ-kuZ+1);
    Kd1:=Kd1/(koZ-kuZ+1);
    Kd2:=Kd2/(koN-kuN+1);
    if abs(E0N)>nenner_min then r0:=E0Z/E0N else r0:=1;
    if abs(EdN)>nenner_min then rz:=EdZ/EdN else rz:=1;
    ratio:=rz/r0;
    if ratio>nenner_min then ratio:=ln(ratio) else ratio:=0;
    if abs(Kd1-Kd2)>nenner_min then ratio:=1.2*cos(sz_water)*ratio/(Kd2-Kd1) else ratio:=0;
    if ratio>0.1 then z.actual:=ratio else z.actual:=0.1;
    end;

procedure calc_initial_zB(F:byte; k1, k2: integer);
{ Analytical calculation of bottom depth from irradiance and radiance
  reflectance measurement or forward simulation between channel k1 and k2
  after Andreas Albert 2003 }
{ c[7] = C_X }
var k, n          : integer;
    l, dl         : double;
    tzB, tzB_old, sum : double;
begin
    n:=abs(k2-k1)+1;
    sum:=0;
    tzB_old:=0;
    dl:=0.5;
    case F of
        0: begin { first step to estimate range of C_X if unknown }
           for k:=k1 to k2 do begin
              l:=C_X.min;
              repeat
                par.c[7]:=l;
                tzB:=zB_analytic(k);
                l:=l+dl;
              until (tzB>=zB.max) or (l>C_X.max);
              C_X.actual:=(l-1)/2;
              if C_X.actual<CL_inimin then C_X.actual:=CL_inimin;
              par.c[7]:=C_X.actual;
              end;
           end;
        1: begin { estimate mean bottom depth in wavelength interval }
            for k:=k1 to k2 do begin
               tzB:=zB_analytic(k);
               if tzB<0 then sum:=sum + tzB_old
               else begin sum:=sum + tzB; tzB_old:=tzB; end;
               sum:= sum + tzB;
               end;
            zB.actual:=sum/n;
            if zB.actual<=zB_inimin then zB.actual:=zB_inimin;
            if zB.actual>=zB.max then zB.actual:=zB.max;
            set_c(26, zB);
           end;
        end;
    end;

{ -> Andreas Albert}

procedure calc_initial_X_shallow;
{ Calculation of the concentration of suspended matter at one or more wavelengths
  with bottom influence but without influence of phytoplankton and Gelbstoff.
  Analytical approximation for the irradiance and radiance reflectance by
  Andreas Albert 2003. The bottom depth must be known from the user or from
  initial determination.
  c[13] = Q    = Q-factor
  c[27] = sun  = sun zenith angle
  c[28] = view = viewing angle }
var k, k1, k2, n            : integer;
    w_b, ff, bot, kfak, att : double;
    mue_sun, mue_view, refl : double;
    nenner, fak, sum        : double;
    xi, Gamma               : double;
begin
    ff:=0;
    bot:=0;
    kfak:=0;
    mue_sun:=cos(arcsin(sin(par.c[27]*pi/180)/nW));
    if abs(mue_sun)<nenner_min then mue_sun:=nenner_min;
    mue_view:=cos(arcsin(sin(par.c[28]*pi/180)/nW));
    if abs(mue_view)<nenner_min then mue_view:=nenner_min;
    xi:=(1-rho_Ed)*(1-rho_Lu)/sqr(nW);
    Gamma:=rho_Eu*par.c[13];
    k1:=Nachbar(LambdaLsh-dLambdaLsh);
    k2:=Nachbar(LambdaLsh+dLambdaLsh);
    n:=abs(k2-k1)+1;
    sum:=0;
    nenner:=0;
    for k:=k1 to k2 do begin
        att:=ld * (aW^.y[k] + (T_W.fw-T_W0)*dadT^.y[k] + bbW^.y[k])/mue_sun;
        w_b:=bbW^.y[k]/(a_coeff(k)+bbW^.y[k]);
        refl:=spec[S_actual]^.y[k]  - refl_IR;     // Radiance reflectance above water
        if refl<nenner_min then refl:=nenner_min;
        refl:=refl/(xi+Gamma*refl);               // radiance reflectance under water

        if spec_type=S_Rrs then begin
          nenner:=bb^.y[k];
          if abs(nenner)<nenner_min then nenner:=nenner_min;
          ff:=calc_f_rs(w_b, bbW^.y[k]/nenner, par.c[27], par.c[28], par.c[13]);
{          refl:=R_rs^.y[k]; }
          bot:=A2rs*kurve_Rrs_bottom(k);
          kfak:=1+1/mue_view;
          nenner:=1-A1rs*exp(-att*(1+1/mue_view)*zB.actual);
          end;
        if spec_type=S_R then begin
          nenner:=bb^.y[k];
          if abs(nenner)<nenner_min then nenner:=nenner_min;
          ff:=calc_f(w_b, bbW^.y[k]/nenner, par.c[27]);
{          refl:=R^.y[k]; }
          bot:=A2*kurve_R_bottom(k);
          kfak:=2;
          nenner:=1-A1*exp(-2*att*zB.actual);
          end;
        if abs(nenner)<nenner_min then nenner:=nenner_min;
        if flag_b_loadAll and flag_batch
            then fak:=1/ff * (meas^.y[k]-bot*exp(-kfak*att*zB.actual))/nenner
            else fak:=1/ff * (refl-bot*exp(-kfak*att*zB.actual))/nenner;
        nenner:=bb_X*(1-fak);
        if abs(nenner)<nenner_min then nenner:=nenner_min;
        sum:=sum + (fak*att-bbW^.y[k])/nenner;
        end;
    C_X.actual:=sum/n;
    if C_X.actual<=CL_inimin then C_X.actual:=CL_inimin;
    if C_X.actual>=C_X.max then C_X.actual:=C_X.max;
    set_c(7,  C_X);
    end;

function a_interval_refl(startval,step,inval:double; k:integer):double;
{ Estimation of sum of absorption of phytoplankton and gelbstoff
  for irradiance or radiance reflectance by nested interval
  (Andreas Albert 2003.
  c[13] = Q    = Q-factor
  c[27] = sun  = sun zenith angle
  c[28] = view = viewing angle }
var i                            : integer;
    ta, trefl, delta             : double;
    ff, w_b, bot, att            : double;
    mue_sun, mue_view            : double;
    l_wb, e_w, e_b, e_wrs, e_brs : double;
    nenner                       : double;
begin
    i:=1;
    att:=aW^.y[k] + (T_W.fw-T_W0)*dadT^.y[k] + bb_coeff(k);
    mue_sun:=cos(arcsin(sin(par.c[27]*pi/180)/nW));
    if abs(mue_sun)<nenner_min then mue_sun:=nenner_min;
    mue_view:=cos(arcsin(sin(par.c[28]*pi/180)/nW));
    if abs(mue_view)<nenner_min then mue_view:=nenner_min;
    trefl:=0;
    repeat
      ta:=startval;
      w_b:=bb_coeff(k)/(att+ta);
      l_wb:=1+w_b;
      if l_wb<nenner_min then l_wb:=nenner_min;
      e_w:=K1W*ln(l_wb);
      if e_w<exp_min then e_w:=exp_min;
      if e_w>exp_max then e_w:=exp_max;
      e_b:=K1B*ln(l_wb);
      if e_b<exp_min then e_b:=exp_min;
      if e_b>exp_max then e_b:=exp_max;
      e_wrs:=K1Wrs*ln(l_wb);
      if e_wrs<exp_min then e_wrs:=exp_min;
      if e_wrs>exp_max then e_wrs:=exp_max;
      e_brs:=K1Brs*ln(l_wb);
      if e_brs<exp_min then e_brs:=exp_min;
      if e_brs>exp_max then e_brs:=exp_max;
      if spec_type=S_Rrs then begin
        nenner:=bb^.y[k];
        if abs(nenner)<nenner_min then nenner:=nenner_min;
        ff:=calc_f_rs(w_b, bbW^.y[k]/nenner, par.c[27], par.c[28], par.c[13]);
        bot:=kurve_Rrs_bottom(k);
        e_wrs:=-(ld*(att+ta)/mue_sun+(att+ta)/mue_view*exp(e_wrs)*(1+K2Wrs/mue_sun))*zB.actual;
        if e_wrs<exp_min then e_wrs:=exp_min;
        if e_wrs>exp_max then e_wrs:=exp_max;
        e_brs:=-(ld*(att+ta)/mue_sun+(att+ta)/mue_view*exp(e_brs)*(1+K2Brs/mue_sun))*zB.actual;
        if e_brs<exp_min then e_brs:=exp_min;
        if e_brs>exp_max then e_brs:=exp_max;
        trefl:=ff*w_b*(1-A1rs*exp(e_wrs)) + A2rs*bot* exp(e_brs);
        end;
      if spec_type=S_R then begin
        nenner:=bb^.y[k];
        if abs(nenner)<nenner_min then nenner:=nenner_min;
        ff:=calc_f(w_b, bbW^.y[k]/nenner, par.c[27]);
        bot:=kurve_R_bottom(k);
        e_w:=-(ld*(att+ta)/mue_sun+(att+ta)/mue_view*exp(e_w)*(1+K2Wrs/mue_sun))*zB.actual;
        if e_w<exp_min then e_w:=exp_min;
        if e_w>exp_max then e_w:=exp_max;
        e_b:=-(ld*(att+ta)/mue_sun+(att+ta)/mue_view*exp(e_b)*(1+K2Brs/mue_sun))*zB.actual;
        if e_b<exp_min then e_b:=exp_min;
        if e_b>exp_max then e_b:=exp_max;
        trefl:=ff*w_b*(1-A1*exp(e_w)) + A2*bot*exp(e_b);
        end;
      if abs(inval)<nenner_min then inval:=nenner_min;
      delta:=trefl/inval-1;
      if delta<0 then ta:=ta-step/i
                 else ta:=ta+step/i;
      w_b:=bb_coeff(k)/(att+ta);
      l_wb:=1+w_b;
      if l_wb<nenner_min then l_wb:=nenner_min;
      e_w:=K1W*ln(l_wb);
      if e_w<exp_min then e_w:=exp_min;
      if e_w>exp_max then e_w:=exp_max;
      e_b:=K1B*ln(l_wb);
      if e_b<exp_min then e_b:=exp_min;
      if e_b>exp_max then e_b:=exp_max;
      e_wrs:=K1Wrs*ln(l_wb);
      if e_wrs<exp_min then e_wrs:=exp_min;
      if e_wrs>exp_max then e_wrs:=exp_max;
      e_brs:=K1Brs*ln(l_wb);
      if e_brs<exp_min then e_brs:=exp_min;
      if e_brs>exp_max then e_brs:=exp_max;
      if spec_type=S_Rrs then begin
        nenner:=bb^.y[k];
        if abs(nenner)<nenner_min then nenner:=nenner_min;
        ff:=calc_f_rs(w_b, bbW^.y[k]/nenner, par.c[27], par.c[28], par.c[13]);
        bot:=kurve_Rrs_bottom(k);
        e_wrs:=-(ld*(att+ta)/mue_sun+(att+ta)/mue_view*exp(e_wrs)*(1+K2Wrs/mue_sun))*zB.actual;
        if e_wrs<exp_min then e_wrs:=exp_min;
        if e_wrs>exp_max then e_wrs:=exp_max;
        e_brs:=-(ld*(att+ta)/mue_sun+(att+ta)/mue_view*exp(e_brs)*(1+K2Brs/mue_sun))*zB.actual;
        if e_brs<exp_min then e_brs:=exp_min;
        if e_brs>exp_max then e_brs:=exp_max;
        trefl:=ff*w_b*(1-A1rs*exp(e_wrs)) + A2rs*bot*exp(e_brs);
        end;
      if spec_type=S_R then begin
        nenner:=bb^.y[k];
        if abs(nenner)<nenner_min then nenner:=nenner_min;
        ff:=calc_f(w_b, bbW^.y[k]/nenner, par.c[27]);
        bot:=kurve_R_bottom(k);
        e_w:=-(ld*(att+ta)/mue_sun+(att+ta)/mue_view*exp(e_w)*(1+K2Wrs/mue_sun))*zB.actual;
        if e_w<exp_min then e_w:=exp_min;
        if e_w>exp_max then e_w:=exp_max;
        e_b:=-(ld*(att+ta)/mue_sun+(att+ta)/mue_view*exp(e_b)*(1+K2Brs/mue_sun))*zB.actual;
        if e_b<exp_min then e_b:=exp_min;
        if e_b>exp_max then e_b:=exp_max;
        trefl:=ff*w_b*(1-A1*exp(e_w)) + A2*bot*exp(e_b);
        end;
      delta:=trefl/inval-1;
      startval:=ta;
      inc(i);
    until (abs(delta)<delta_min) or (i>MaxIterSh[1]);
    a_interval_refl:=ta;
    end;

procedure calc_initial_Y_C_shallow(Sender:TObject);
{ Calculation of the concentration of phytoplankton and absorption of
  Gelbstoff with bottom influence. Nested intervals for the irradiance or
  radiance reflectance to find the value of the total absorption,
  which is inverted for phytoplankton and Gelbstoff by the simplex.
  Depth and concentration of large particles must be known from the user or
  is estimated by initial determination (Andreas Albert 2003).
  c[13] = Q    = Q-factor
  c[27] = sun  = sun zenith angle
  c[28] = view = viewing angle }
var k, j   : integer;
    refl   : double;
    ta_spk : spektrum;
begin
    FIT:=1;
    fit_dk:=abs(Nachbar(fitsh_min[FIT]+fitsh_dL[FIT])-Nachbar(fitsh_min[FIT]));
    if fit_dk=0 then fit_dk:=1;
    for k:=1 to Channel_number do begin
        refl:=spec[S_actual]^.y[k] - refl_IR;
        ta_spk[k]:=a_interval_refl(a_ini,da_ini,refl,k)
                   + aW^.y[k]+(T_W.fw-T_W0)*dadT^.y[k];
        end;

    { Determination of the absorption spectra using the simplex. }
    Kurve:=a_coeff;
    set_parameters_inverse;
    for k:=1 to Channel_number do data[k, Messung]:=ta_spk[k];
    for j:=1 to M1 do par.map[j]:=0;
    if par.fit[1]=1 then par.map[1]:=1;
    if par.fit[9]=1 then par.map[9]:=9;
    setsteps;
    GetData;
    Simpl;
    set_actual_parameters;
    if par.fit[1]=1 then begin
      if C[0].actual<=C0_inimin then C[0].actual:=C0_inimin;
      if C[0].actual>=C[0].max then C[0].actual:=C[0].max;
      end;
    if par.fit[9]=1 then begin
      if C_Y.actual<=CY_inimin then C_Y.actual:=CY_inimin;
      if C_Y.actual>=C_Y.max then C_Y.actual:=C_Y.max;
      end;

    if spec_type=S_R then Kurve:=Kurve_R;
    if spec_type=S_Rrs then
    if flag_above then Kurve:=Kurve_Rrs_above
                  else Kurve:=Kurve_Rrs_below;

    end;

procedure calc_initial_fa;
{ Calculation of the initial values (=1/n) of the areal fraction of n bottom
  types. (Andreas Albert 2003). }
var i : integer;
    n : double;
begin
    n:=0;
    for i:=0 to 5 do begin
      if par.fit[i+30]=1 then n:=n+1;
      end;
    if n<nenner_min then n:=nenner_min;
    for i:=0 to 5 do begin
      if par.fit[i+30]=1 then fA[i].actual:=1/n;
      end;
    end;

{ <- Andreas Albert}


procedure convert_B0_X(B0:double);
{ Conversion from optical units B0 to gravimetric concentrations C_L, C_S. }
var  rLS, fak : double;
begin
    if par.fit[7]=1 then begin { fit of C_L }
        if C_Mie.actual>nenner_min then rLS:=C_X.actual/C_Mie.actual else rLS:=-1;
        if rLS>nenner_min then begin
            if par.fit[8]=1 then begin
                if par.c[7]<nenner_min then fak:=1 else
                    fak:=exp(par.c[11]*ln(LambdaLf[1]/Lambda_S));
                par.c[7]:=B0 / (bb_X + fak*bb_Mie/rLS);
                par.c[8]:=par.c[7]/rLS;
                C_Mie.actual:=par.c[8];
                end
            else par.c[7]:=(B0 - C_Mie.actual*bb_Mie)/bb_X;
            end
        else par.c[7]:=B0/bb_X;
        C_X.actual:=par.c[7];
        end
    else if par.fit[8]=1 then begin { no fit of C_L, only of C_S }
        par.c[8]:=(B0 - C_X.actual*bb_X)/bb_Mie;
        C_Mie.actual:=par.c[8];
        end;
    end;

function calc_B0(k:integer):double;
{ R: Estimate backscattering from a single channel k.
  See Gege and Albert (2005), eq. (29) }
var n : double;
begin
    n:=f.actual - spec[S_actual]^.y[k];
    if abs(n)<nenner_min then n:=nenner_min;
    calc_B0:=a_coeff(k)*spec[S_actual]^.y[k]/n - bbW^.y[k];
    end;


procedure calc_a;
{ Calculate absorption of water constituents. }
var i, k   : integer;
    C_NAP  : double;
begin
    C_NAP:= par.c[7] + par.c[8];
    Chl_a:=0; for i:=0 to 5 do Chl_a:=Chl_a+c[i].actual;
    for k:=1 to Channel_number do begin
        aP_calc^.y[k]:=0;
        for i:=0 to 5 do aP_calc^.y[k]:=aP_calc^.y[k] + C[i].actual*aP[i]^.y[k];
        aNAP_calc^.y[k]:=C_NAP * aNAP440 * aNAP^.y[k];
        aCDOM_calc^.y[k]:=C_Y.actual * aY^.y[k];
        a_calc^.y[k] :=aP_calc^.y[k] + aNAP_calc^.y[k] + aCDOM_calc^.y[k];
        end;
    end;

procedure calc_f_lambda_inv;
{ f factor with invers parameters
  ACHTUNG: Durch Vorwärts-Algorithmus ersetzen! }
var k : integer;
    x : double;
begin
    calc_a;
    for k:=1 to Channel_number do begin
        if abs(bb^.y[k])<nenner_min then bb^.y[k]:=nenner_min;
        if Model_R=0 then x := bb_coeff(k) /
                               (a_calc^.y[k]+aW^.y[k] + bb_coeff(k))
                     else x := bb_coeff(k) /
                               (a_calc^.y[k]+aW^.y[k]);
        if Model_f>0 then spec[S_actual]^.y[k]:=calc_f(x, bbW^.y[k]/bb^.y[k], sun.actual)
                     else spec[S_actual]^.y[k]:=f.actual;
        end;
    end;

procedure calc_initial_X;
{ R: Estimate start value of suspended matter concentration. }
var   R1         : double;
      a1         : double;
      b1         : double;
      f1         : double;
      nenner     : double;
      k          : integer;
      k1u, k1o   : integer;
      B0         : double;
      merk_fl_a  : boolean;
      merk_spek  : Attr_spec;
begin
    set_parameters_inverse;
    k1u:=Nachbar(LambdaLf[1]-dLambdaLf[1]);
    k1o:=Nachbar(LambdaLf[1]+dLambdaLf[1]);
    R1:=0; for k:=k1u to k1o do R1:=R1+spec[S_actual]^.y[k]; R1:=R1/(1+k1o-k1u);
    b1:=0; for k:=k1u to k1o do b1:=b1+bbW^.y[k]; b1:=b1/(1+k1o-k1u);
    merk_fl_a:=flag_aW; flag_aW:=TRUE;
    a1:=0; for k:=k1u to k1o do a1:=a1+a_coeff(k); a1:=a1/(1+k1o-k1u);
    flag_aW:=merk_fl_a;
    merk_spek:=spec[S_actual]^;
    calc_f_lambda_inv;
    f1:=0; for k:=k1u to k1o do f1:=f1+spec[S_actual]^.y[k]; f1:=f1/(1+k1o-k1u);
    spec[S_actual]^:=merk_spek;
    if Model_R=0 then nenner:=f1-R1 else nenner:=f1;
    if abs(nenner)<nenner_min then nenner:=nenner_min;
    B0:=a1*R1/nenner-b1;
    convert_B0_X(B0);
    f.actual:=f1;
    par.c[24]:=f1;
    end;


procedure calc_initial_X_f;
{ R: Estimate start values of suspended matter concentration and f-factor. }
var   a, b, c    : double;
      R1, R2     : double;
      a2         : double;
      b1, b2     : double;
      c1, c2     : double;
      k          : integer;
      k1u, k1o   : integer;
      k2u, k2o   : integer;
      k3u, k3o   : integer;
      l1, l2     : double;
      w, n       : double;
      B0         : double;
      merk_fl_a  : boolean;
begin
    set_parameters_inverse;
    k1u:=Nachbar(LambdaLf[1]-dLambdaLf[1]);
    k1o:=Nachbar(LambdaLf[1]+dLambdaLf[1]);
    k2u:=Nachbar(LambdaLf[2]-dLambdaLf[2]);
    k2o:=Nachbar(LambdaLf[2]+dLambdaLf[2]);
    if k1o>k2o then begin k3u:=k1u; k3o:=k1o  end
               else begin k3u:=k2u; k3o:=k2o; end;
    R1:=0; for k:=k1u to k1o do R1:=R1+spec[S_actual]^.y[k]; R1:=R1/(1+k1o-k1u);
    R2:=0; for k:=k2u to k2o do R2:=R2+spec[S_actual]^.y[k]; R2:=R2/(1+k2o-k2u);
    b1:=0; for k:=k1u to k1o do b1:=b1+bbW^.y[k]; b1:=b1/(1+k1o-k1u);
    b2:=0; for k:=k2u to k2o do b2:=b2+bbW^.y[k]; b2:=b2/(1+k2o-k2u);
    merk_fl_a:=flag_aW; flag_aW:=TRUE;
    c1:=0; for k:=k1u to k1o do c1:=c1+a_coeff(k)+b1; c1:=c1/(1+k1o-k1u);
    c2:=0; for k:=k2u to k2o do c2:=c2+a_coeff(k)+b2; c2:=c2/(1+k2o-k2u);
    flag_aW:=merk_fl_a;
    a2:=0; for k:=k3u to k3o do a2:=a2+a_coeff(k); a2:=a2/(1+k3o-k3u);
    a:=R1-R2;
    if abs(a)<nenner_min then begin
        B0:=0;
        for k:=k1u to k1o do B0:=B0+calc_B0(k); B0:=B0/(1+k1o-k1u);
        end
    else begin
        b:=R1*(c1+b2)-R2*(c2+b1);
        c:=R1*c1*b2-R2*c2*b1;
        w:=b*b-4.0*a*c; if w<0 then w:=0;
        l1:=(-b+sqrt(w))/(a+a); { usual solution }
        l2:=(-b-sqrt(w))/(a+a);
        if l2>l1 then B0:=l2 else B0:=l1;
        end;

    if par.fit[24]=1 then begin { determine initial value of f }
        n:=b2+B0; if abs(n)<nenner_min then n:=nenner_min;
        par.c[24]:=R2*(a2+b2+B0)/n;
        f.actual:=par.c[24];
        end;
    convert_B0_X(B0);
    end;

function Y_C(k1,k2:integer):double;
{ Calculate ratio of Gelbstoff to phytoplankton concentration
  from two channels k1, k2. SPM concentration must be known. }
var nenner  : double;
    z, n    : double;
    R_A     : double;
    b1, b2  : double;
    fak, cc : double;
begin
    if flag_CXisC0 then cc:=par.c[1] else cc:=par.c[7];
    if flag_bX_linear then fak:=bb_X else begin
        if cc>nenner_min then fak:=bbX_A*exp(bbX_B*ln(cc))
                         else fak:=bbX_A;
        end;
    b1:=bbW^.y[k1] + C_X.actual*fak*bXN^.y[k1] + C_Mie.actual*bbMie^.y[k1];
    b2:=bbW^.y[k2] + C_X.actual*fak*bXN^.y[k1] + C_Mie.actual*bbMie^.y[k2];
    nenner:=spec[1]^.y[k1];
    if abs(nenner)<nenner_min then nenner:=nenner_min;
    z:=f.actual*b1/nenner - aW^.y[k1]-b1;
    nenner:=spec[1]^.y[k2];
    if abs(nenner)<nenner_min then nenner:=nenner_min;
    n:=f.actual*b2/nenner - aW^.y[k2]-b2;
    if abs(n)<nenner_min then n:=nenner_min;
    R_A:=z/n;
    nenner:=aY^.y[k1] - R_A*aY^.y[k2];
    if abs(nenner)<nenner_min then nenner:=nenner_min;
    Y_C:=abs((R_A*aP[0]^.y[k2]-aP[0]^.y[k1]) / nenner);
    end;

function CP(k3:integer; YC:double):double;
{ Calculate phytoplankton concentration from channel k3. SPM concentration
  and ratio Gelbstoff to phytoplankton concentration must be known.
  Concentration of non-chlorophyllous particles is set equal zero. }
var  b, z, n : double;
     nenner  : double;
     fak, cc : double;
begin
    if flag_CXisC0 then cc:=par.c[1] else cc:=par.c[7];
    if flag_bX_linear then fak:=bb_X else begin
        if cc>nenner_min then fak:=bbX_A*exp(bbX_B*ln(cc))
                         else fak:=bbX_A;
        end;
    b:=bbW^.y[k3] + C_X.actual*fak*bXN^.y[k3] + C_Mie.actual*bbMie^.y[k3];
    nenner:=spec[1]^.y[k3];
    if abs(nenner)<nenner_min then nenner:=nenner_min;
    z:=f.actual*b/nenner - aW^.y[k3]-b;
    n:=aP[0]^.y[k3]+YC*aY^.y[k3];
    if abs(n)<nenner_min then n:=nenner_min;
    CP:=abs(z/n);
    end;

procedure set_CP;
var i    : integer;
    sum  : double;
begin
    sum:=0;
    for i:=1 to 6 do sum:=sum+par.c[i];
    if sum<nenner_min then sum:=nenner_min;
    for i:=1 to 6 do par.c[i]:=par.c[i] * C[0].actual / sum;
    end;

procedure calc_initial_Y_C;
{ Estimate start values of phytoplankton and Gelbstoff concentration. }
var YC   : double;
begin
    YC:=Y_C(Nachbar(LambdaCY[1]), Nachbar(LambdaCY[2]));
    if par.fit[1]=1 then C[0].actual:=CP(Nachbar(LambdaCY[3]), YC);
    if par.fit[9]=1 then par.c[9]:=C[0].actual*YC;
    if par.fit[9]=1 then C_Y.actual:=par.c[9];
    set_CP;
    end;

procedure define_fitted_parameters_R_deep(F:byte);
{ Define which parameters are kept constant and which are fitted
  for irradiance reflectance spectrum in deep water. }
var j : integer;
    g : spektrum;
begin
    case F of
        2: begin { Fit only C_L, C_S, C_Y }
               for j:=1 to M1 do par.map[j]:=0;
               for j:=7 to 9 do if par.fit[j]=1 then par.map[j]:=j;
               if par.fit[7]=1 then begin
                   g:=calc_gewicht(7, C_X.actual, 2*C_X.actual, fit_min[F], fit_max[F]);
                   for j:=1 to Channel_number do gew^.y[j]:=g[j];
                   end
               else for j:=1 to Channel_number do gew^.y[j]:=0;
               if par.fit[8]=1 then begin
                   g:=calc_gewicht(8, C_Mie.actual, 2*C_Mie.actual, fit_min[F], fit_max[F]);
                   for j:=1 to Channel_number do gew^.y[j]:=gew^.y[j]+g[j];
                   end;
               if par.fit[9]=1 then begin
                   g:=calc_gewicht(9, C_Y.actual, 2*C_Y.actual, fit_min[F], fit_max[F]);
                   for j:=1 to Channel_number do gew^.y[j]:=gew^.y[j]+g[j];
                   end;
               norm_mx(gew^.y, fit_min[4], fit_max[4]);
               end;
        3: begin { Fit only C[0], C_Y, S }
               for j:=1 to M1 do par.map[j]:=0;
               if par.fit[1]=1 then par.map[1]:=1;
               for j:=9 to 10 do if par.fit[j]=1 then par.map[j]:=j;
               end;
        4: begin { Fit all parameters of R model }
               for j:=1 to M1 do if par.fit[j]=1 then par.map[j]:=j else par.map[j]:=0;
               for j:=13 to 23 do par.map[j]:=0;
               for j:=25 to 26 do par.map[j]:=0;
               for j:=28 to 35 do par.map[j]:=0;
               end;
        else for j:=1 to M1 do par.map[j]:=0;
        end;
    end;

procedure define_fitted_parameters_R_shallow(F:byte);
{ Define which parameters are kept constant and which are fitted
  for irradiance reflectance spectrum in shallow water. }
{ TO BE UPDATED !!! }
var j : integer;
begin
    case F of
        2: begin { Fit only C_L, C_S, C_Y, and zB if shallow water }
               for j:=1 to M1 do par.map[j]:=0;
               for j:=7 to 9 do if par.fit[j]=1 then par.map[j]:=j;
               if (flag_shallow) and (par.fit[26]=1) then par.map[26]:=26;  { fit of zB }
{               if par.fit[7]=1 then begin
                   g:=calc_gewicht(7, C_L.actual, 2*C_L.actual, fit_min[F], fit_max[F]);
                   for j:=1 to Channel_number do gew^.y[j]:=g[j];
                   end
               else for j:=1 to Channel_number do gew^.y[j]:=0;
               if par.fit[8]=1 then begin
                   g:=calc_gewicht(8, C_S.actual, 2*C_S.actual, fit_min[F], fit_max[F]);
                   for j:=1 to Channel_number do gew^.y[j]:=gew^.y[j]+g[j];
                   end;
               if par.fit[9]=1 then begin
                   g:=calc_gewicht(9, C_Y.actual, 2*C_Y.actual, fit_min[F], fit_max[F]);
                   for j:=1 to Channel_number do gew^.y[j]:=gew^.y[j]+g[j];
                   end;
               norm_mx(gew^.y, fit_min[4], fit_max[4]);              } end;
        3: begin { Fit only C[0], C_Y, S, and zB if shallow water }
               for j:=1 to M1 do par.map[j]:=0;
               if par.fit[1]=1 then par.map[1]:=1;
               for j:=9 to 10 do if par.fit[j]=1 then par.map[j]:=j;
               if (flag_shallow) and (par.fit[26]=1) then par.map[26]:=26;  { fit of zB }
               end;
        4: begin { Fit all parameters of R model }
               for j:=1 to M1 do if par.fit[j]=1 then par.map[j]:=j else par.map[j]:=0;
               for j:=13 to 23 do par.map[j]:=0;
               if (flag_shallow) and (par.fit[26]=1) then par.map[26]:=26;  { fit of zB }
               par.map[29]:=0;
               end;
        else for j:=1 to M1 do par.map[j]:=0;
        end;
    end;

procedure define_fitted_parameters_R(F:byte);
{ Define which parameters are kept constant and which are fitted
  for irradiance reflectance spectrum . }
begin
    if flag_shallow then define_fitted_parameters_R_shallow(F)
                    else define_fitted_parameters_R_deep(F);
    end;

procedure perform_fit_R(F:byte; Sender:TObject);
{ Irradiance reflectance }
var k : integer;
begin
    FIT:=F;
    fit_dk:=abs(Nachbar(fit_min[F]+fit_dL[F])-Nachbar(fit_min[F]));
    if fit_dk=0 then fit_dk:=1;
    with par do begin
        set_parameters_inverse;
        for k:=1 to Channel_number do neu_bbS(c[11], k);
        for k:=1 to Channel_number do data[k, Messung]:=spec[1]^.y[k];
        define_fitted_parameters_R(F);
        setsteps;
        GetData;
        Simpl;
        set_actual_parameters;
        end;
    end;

procedure perform_fit_Rsurf;
{ Surface reflectance }
var j, k   : integer;
begin
    FIT:=4;
    fit_dk:=abs(Nachbar(fit_min[FIT]+fit_dL[FIT])-Nachbar(fit_min[FIT]));
    if fit_dk=0 then fit_dk:=1;
    with par do begin
        set_parameters_inverse;
        for k:=1 to Channel_number do data[k, Messung]:=spec[1]^.y[k];
        for j:=1 to M1 do map[j]:=0;
        for j:=15 to 23 do if fit[j]=1 then map[j]:=j;
        for j:=37 to 39 do if fit[j]=1 then map[j]:=j;
        if fit[50]=1 then map[50]:=50;
        setsteps;
        GetData;
        Simpl;
        set_actual_parameters;
        end;
    end;

procedure perform_fit_a;
{ Absorption }
var j, k   : integer;
begin
    FIT:=4;
    fit_dk:=abs(Nachbar(fit_min[FIT]+fit_dL[FIT])-Nachbar(fit_min[FIT]));
    if fit_dk=0 then fit_dk:=1;
    with par do begin
        set_parameters_inverse;
        for k:=1 to Channel_number do data[k, Messung]:=spec[1]^.y[k];
        for j:=1 to M1 do map[j]:=0;
        for j:=1 to 7  do if fit[j]=1 then map[j]:=j;
        for j:=9 to 10 do if fit[j]=1 then map[j]:=j;
        if flag_aW then if fit[12]=1 then map[12]:=12;
        setsteps;
        GetData;
        Simpl;
        set_actual_parameters;
        end;
    end;

procedure perform_fit_Rbottom;
{ Bottom reflectance }
var j, k   : integer;
begin
    FIT:=4;
    fit_dk:=abs(Nachbar(fit_min[FIT]+fit_dL[FIT])-Nachbar(fit_min[FIT]));
    if fit_dk=0 then fit_dk:=1;
    with par do begin
        set_parameters_inverse;
        for k:=1 to Channel_number do data[k, Messung]:=spec[1]^.y[k];
        for j:=1 to M1 do map[j]:=0;
        for j:=30 to 35 do if fit[j]=1 then map[j]:=j;
        setsteps;
        GetData;
        Simpl;
        set_actual_parameters;
        end;
    end;

procedure perform_fit_Kd;
{ Diffuse attenuation of downwelling irradiance }
var j, k      : integer;
begin
    FIT:=4;
    fit_dk:=abs(Nachbar(fit_min[FIT]+fit_dL[FIT])-Nachbar(fit_min[FIT]));
    if fit_dk=0 then fit_dk:=1;
    with par do begin
        set_parameters_inverse;
        for k:=1 to Channel_number do data[k, Messung]:=spec[1]^.y[k];
        for j:=1 to M1 do map[j]:=0;
        for j:=1 to 12 do if fit[j]=1 then map[j]:=j;
        if fit[27]=1 then map[27]:=27; { sun zenith angle }
        setsteps;
        GetData;
        Simpl;
        set_actual_parameters;
        end;
    end;


procedure perform_fit_test;
var j, k      : integer;
begin
    FIT:=4;
    fit_dk:=abs(Nachbar(fit_min[FIT]+fit_dL[FIT])-Nachbar(fit_min[FIT]));
    if fit_dk=0 then fit_dk:=1;
    with par do begin
        set_parameters_inverse;
        for k:=1 to Channel_number do data[k, Messung]:=spec[1]^.y[k];
        for j:=1 to M1 do map[j]:=0;
        for j:=1 to 12   do if fit[j]=1 then map[j]:=j;
        for j:=18 to 28  do if fit[j]=1 then map[j]:=j;
        for j:=41 to 44  do if fit[j]=1 then map[j]:=j;
        setsteps;
        GetData;
        Simpl;
        set_actual_parameters;
        end;
    end;

procedure calculate_K_function;
{ Used for fluorescence calculation. }
var k : integer;
begin
    for k:=1 to Channel_Number do begin
        Kd^.y[k]:=Kurve_Kd(k);
        kL_uW^.y[k]:=kurve_kL_uW(k);
        end;
    end;

procedure calculate_Ed0_function;
{ Downwelling irradiance just beneath water surface.
  Used for fluorescence calculation. }
var k         : integer;
    temp_flag : boolean;
    temp_z    : double;
begin
    temp_flag:=flag_above;
    temp_z   :=par.C[25]; { z }
    flag_above:=FALSE;
    par.C[25] :=0;
    for k:=1 to Channel_Number do Ed0^.y[k]:=Kurve_Ed_GC(k);
    flag_above:=temp_flag;
    par.C[25] :=temp_z;
    end;

procedure calculate_Kd_inv;
{ Calculate Kd using fit parameters. }
var k, j : integer;
    mean : double;
begin
    j:=0;
    for k:=1 to Channel_Number do begin
        mean:=kurve_Kd(k);
        if (x^.y[k]>=PAR_min) and (x^.y[k]<=PAR_max) then begin
            Kd^.avg:=Kd^.avg + mean;
            inc(j);
            end;
        end;
    if j>0 then Kd^.avg:=Kd^.avg/j;
    end;

procedure calculate_Fitfunction;
var k         : integer;
begin
    for k:=1 to Channel_Number do spec[2]^.y[k]:=kurve(k) ;
    if dsmpl>0 then resample_Rect(spec[2]^);
    average(spec[2]^);
    end;




procedure define_curves;
begin
    case spec_type of
    S_Ed_GC   :  Kurve:=Kurve_Ed_GC;
    S_Lup     :  if flag_above then Kurve:=Kurve_Lup_above
                               else Kurve:=Kurve_Lup_below;
    S_Rrs     : begin
                    if flag_above then Kurve:=Kurve_Rrs_above
                                  else Kurve:=Kurve_Rrs_below;
                    if (not flag_public) and flag_Rbottom then
                        Kurve:=kurve_Rrs_waterlayer;
                 end;
    S_R       :  if (not flag_public) and flag_Rbottom then
                     Kurve:=kurve_R_waterlayer
                     else Kurve:=Kurve_R;
    S_Rsurf   :  Kurve:=Kurve_Rrs_surf;
    S_a       :  Kurve:=a_coeff;
    S_Kd      :  Kurve:=Kurve_Kd;
    S_Rbottom :  if flag_L then Kurve:=Kurve_Rrs_bottom
                           else Kurve:=Kurve_R_bottom;
    S_Ed_Gege :  if flag_above then Kurve:=Kurve_Ed_above_Gege
                               else Kurve:=Kurve_Ed_below_Gege;
    S_test    :  if flag_MP then Kurve:=kurve_MP_RRp
                            else ;
    end;
    end;

begin
    end.
