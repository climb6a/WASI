unit Popup_Fitparameter;

{$MODE Delphi}

{ Version vom 24.7.2020 }

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, SCHOEN_, defaults;

type

  { TPopup_Fitparameters }

  TPopup_Fitparameters = class(TForm)
    Label_C_Mie: TLabel;
    Label_C4: TLabel;
    Label_C2: TLabel;
    Label_c1: TLabel;
    Label_C3: TLabel;
    Label_C5: TLabel;
    Label_fA2: TLabel;
    Label_fA3: TLabel;
    Label_fa4: TLabel;
    Label_fA1: TLabel;
    Label_fA0: TLabel;
    Label_fA5: TLabel;
    Label_T_W: TLabel;
    Label_X: TLabel;
    Label_fluo: TLabel;
    Label_C0: TLabel;
    Label_C_Y: TLabel;
    Label_S: TLabel;
    Label_angstroem: TLabel;
    Label_rho_dd: TLabel;
    Label_rho_ds: TLabel;
    Label_rho_L: TLabel;
    Label_g_dd: TLabel;
    Label_g_dsr: TLabel;
    Label_g_dsa: TLabel;
    Label_zB: TLabel;
    Label_f: TLabel;
    Label_sr: TLabel;
    Model_parameters: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Surface: TTabSheet;
    Reflectance: TTabSheet;
    Miscellaneous: TTabSheet;
    Par_private: TTabSheet;
    Label1: TLabel;
    alpha_d_fit: TCheckBox;
    alpha_d_0: TEdit;
    alpha_d_min: TEdit;
    alpha_d_max: TEdit;
    Label20: TLabel;
    beta_d_fit: TCheckBox;
    beta_d0: TEdit;
    beta_dmin: TEdit;
    beta_dmax: TEdit;
    Label21: TLabel;
    gamma_d_fit: TCheckBox;
    gamma_0: TEdit;
    gamma_min: TEdit;
    gamma_max: TEdit;
    Label22: TLabel;
    delta_d_fit: TCheckBox;
    delta_0: TEdit;
    delta_min: TEdit;
    delta_max: TEdit;
    alpha_fit: TCheckBox;
    alpha_0: TEdit;
    alpha_min: TEdit;
    alpha_max: TEdit;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    Button_Default_Ed_old: TButton;
    Label16: TLabel;
    Cp_fit: TCheckBox;
    CP_0: TEdit;
    CP_min: TEdit;
    CP_max: TEdit;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    CY_fit: TCheckBox;
    CY_0: TEdit;
    CY_min: TEdit;
    CY_max: TEdit;
    S_fit: TCheckBox;
    S_0: TEdit;
    S_min: TEdit;
    S_max: TEdit;
    CL_fit: TCheckBox;
    CL_0: TEdit;
    CL_min: TEdit;
    CL_max: TEdit;
    CMie_fit: TCheckBox;
    CMie_0: TEdit;
    CMie_min: TEdit;
    CMie_max: TEdit;
    Button_Default_WC: TButton;
    Label37: TLabel;
    TW_fit: TCheckBox;
    TW_0: TEdit;
    TW_min: TEdit;
    TW_max: TEdit;
    Label_Q_units: TLabel;
    Q_fit: TCheckBox;
    Q_0: TEdit;
    Q_min: TEdit;
    Q_max: TEdit;
    Label_rho_dd_units: TLabel;
    rho_dd_fit: TCheckBox;
    rho_dd_0: TEdit;
    rho_dd_min: TEdit;
    rho_dd_max: TEdit;
    Button_Default_Misc: TButton;
    Label47: TLabel;
    alpha_r_fit: TCheckBox;
    alpha_r_0: TEdit;
    alpha_r_min: TEdit;
    alpha_r_max: TEdit;
    Label48: TLabel;
    beta_r_fit: TCheckBox;
    beta_r_0: TEdit;
    beta_r_min: TEdit;
    beta_r_max: TEdit;
    Label49: TLabel;
    gamma_r_fit: TCheckBox;
    gamma_r_0: TEdit;
    gamma_r_min: TEdit;
    gamma_r_max: TEdit;
    Label50: TLabel;
    delta_r_fit: TCheckBox;
    delta_r_0: TEdit;
    delta_r_min: TEdit;
    delta_r_max: TEdit;
    Button_Default_Surface: TButton;
    Label52: TLabel;
    n_fit: TCheckBox;
    n_0: TEdit;
    n_min: TEdit;
    n_max: TEdit;
    Algae: TTabSheet;
    Label60: TLabel;
    Label61: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label64: TLabel;
    Ccl_fit: TCheckBox;
    CCl_0: TEdit;
    Ccl_min: TEdit;
    Ccl_max: TEdit;
    CCh_fit: TCheckBox;
    Cch_0: TEdit;
    Cch_min: TEdit;
    CCh_max: TEdit;
    CD_fit: TCheckBox;
    CD_0: TEdit;
    CD_min: TEdit;
    CD_max: TEdit;
    CDF_fit: TCheckBox;
    CDF_0: TEdit;
    CDF_min: TEdit;
    CDF_max: TEdit;
    CG_fit: TCheckBox;
    CG_0: TEdit;
    CG_min: TEdit;
    CG_max: TEdit;
    Button_Default_Algae: TButton;
    Label18: TLabel;
    f_fit: TCheckBox;
    f_0: TEdit;
    f_min: TEdit;
    f_max: TEdit;
    Shallow: TTabSheet;
    Label19: TLabel;
    zB_fit: TCheckBox;
    zB_0: TEdit;
    zB_min: TEdit;
    zB_max: TEdit;
    Label71: TLabel;
    fA0_fit: TCheckBox;
    fA0_0: TEdit;
    fA0_min: TEdit;
    fA0_max: TEdit;
    Label72: TLabel;
    fA1_fit: TCheckBox;
    fA1_0: TEdit;
    fA1_min: TEdit;
    fA1_max: TEdit;
    Label73: TLabel;
    fA2_fit: TCheckBox;
    fA2_0: TEdit;
    fA2_min: TEdit;
    fA2_max: TEdit;
    Label74: TLabel;
    fA3_fit: TCheckBox;
    fA3_0: TEdit;
    fA3_min: TEdit;
    fA3_max: TEdit;
    Label75: TLabel;
    fA4_fit: TCheckBox;
    fA4_0: TEdit;
    fA4_min: TEdit;
    fA4_max: TEdit;
    Label76: TLabel;
    fA5_fit: TCheckBox;
    fA5_0: TEdit;
    fA5_min: TEdit;
    fA5_max: TEdit;
    Button_Default_Ground: TButton;
    Label78: TLabel;
    Label_units_test: TLabel;
    test_fit: TCheckBox;
    test_0: TEdit;
    test_min: TEdit;
    test_max: TEdit;
    fluo_fit: TCheckBox;
    fluo_0: TEdit;
    fluo_min: TEdit;
    fluo_max: TEdit;
    Illumination: TTabSheet;
    Label_sun_units: TLabel;
    sun_fit: TCheckBox;
    sun_0: TEdit;
    sun_min: TEdit;
    sun_max: TEdit;
    Label_sun: TLabel;
    Label_fdd: TLabel;
    Label_units_fdd: TLabel;
    Label_fds: TLabel;
    Label_units_fds: TLabel;
    f_dd_fit: TCheckBox;
    f_dd_0: TEdit;
    f_dd_min: TEdit;
    f_dd_max: TEdit;
    f_ds_fit: TCheckBox;
    f_ds_0: TEdit;
    f_ds_min: TEdit;
    f_ds_max: TEdit;
    Label_H_oz: TLabel;
    Label_units_H_oz: TLabel;
    H_oz_fit: TCheckBox;
    H_oz_0: TEdit;
    H_oz_min: TEdit;
    H_oz_max: TEdit;
    Label_WV: TLabel;
    Label_units_WV: TLabel;
    WV_fit: TCheckBox;
    WV_0: TEdit;
    WV_min: TEdit;
    WV_max: TEdit;
    Label_beta: TLabel;
    Label_units_beta: TLabel;
    beta_fit: TCheckBox;
    beta_0: TEdit;
    beta_min: TEdit;
    beta_max: TEdit;
    Label_alpha: TLabel;
    Label_units_alpha: TLabel;
    Label_units_z: TLabel;
    z_fit: TCheckBox;
    z_0: TEdit;
    z_min: TEdit;
    z_max: TEdit;
    Label_z: TLabel;
    Label_test: TLabel;
    Button_Default_Illumination: TButton;
    Geometry: TTabSheet;
    Label_view_units: TLabel;
    view_fit: TCheckBox;
    view_0: TEdit;
    view_min: TEdit;
    view_max: TEdit;
    Label_view: TLabel;
    Button_Default_Geometry: TButton;
    Label_units_detritus: TLabel;
    C_D_fit: TCheckBox;
    C_D_0: TEdit;
    C_D_min: TEdit;
    C_D_max: TEdit;
    Label_bbs_phy: TLabel;
    Label_rho_ds_units: TLabel;
    rho_ds_fit: TCheckBox;
    rho_ds_0: TEdit;
    rho_ds_min: TEdit;
    rho_ds_max: TEdit;
    Label_rho_L_units: TLabel;
    rho_L_fit: TCheckBox;
    rho_L_0: TEdit;
    rho_L_min: TEdit;
    rho_L_max: TEdit;
    Label_g_dd_units: TLabel;
    g_dd_fit: TCheckBox;
    g_dd_0: TEdit;
    g_dd_min: TEdit;
    g_dd_max: TEdit;
    Label_g_dsr_units: TLabel;
    g_dsr_fit: TCheckBox;
    g_dsr_0: TEdit;
    g_dsr_min: TEdit;
    g_dsr_max: TEdit;
    Label_g_dsa_units: TLabel;
    g_dsa_fit: TCheckBox;
    g_dsa_0: TEdit;
    g_dsa_min: TEdit;
    g_dsa_max: TEdit;
    Label_Header: TLabel;
    Label17: TLabel;
    Label23: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure fA3_fitChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Hide_par(Sender: TObject);
    procedure alpha_d_fitClick(Sender: TObject);
    procedure beta_d_fitClick(Sender: TObject);
    procedure gamma_d_fitClick(Sender: TObject);
    procedure delta_d_fitClick(Sender: TObject);
    procedure alpha_r_0Change(Sender: TObject);
    procedure alpha_r_minChange(Sender: TObject);
    procedure alpha_r_maxChange(Sender: TObject);
    procedure alpha_d_0Change(Sender: TObject);
    procedure alpha_d_minChange(Sender: TObject);
    procedure alpha_d_maxChange(Sender: TObject);
    procedure define_temp_parameters(Sender: TObject);
    procedure Model_parametersChange(Sender: TObject);
    procedure update_parameterlist(Sender: TObject);
    procedure set_temp_parameters(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure alpha_r_fitClick(Sender: TObject);
    procedure beta_d0Change(Sender: TObject);
    procedure beta_dminChange(Sender: TObject);
    procedure beta_dmaxChange(Sender: TObject);
    procedure gamma_0Change(Sender: TObject);
    procedure gamma_minChange(Sender: TObject);
    procedure gamma_maxChange(Sender: TObject);
    procedure delta_0Change(Sender: TObject);
    procedure delta_minChange(Sender: TObject);
    procedure delta_maxChange(Sender: TObject);
    procedure alpha_0Change(Sender: TObject);
    procedure alpha_minChange(Sender: TObject);
    procedure alpha_maxChange(Sender: TObject);
    procedure alpha_fitClick(Sender: TObject);
    procedure Button_Default_Ed_oldClick(Sender: TObject);
    procedure beta_r_0Change(Sender: TObject);
    procedure beta_r_minChange(Sender: TObject);
    procedure beta_r_maxChange(Sender: TObject);
    procedure gamma_r_0Change(Sender: TObject);
    procedure gamma_r_minChange(Sender: TObject);
    procedure gamma_r_maxChange(Sender: TObject);
    procedure delta_r_0Change(Sender: TObject);
    procedure delta_r_minChange(Sender: TObject);
    procedure delta_r_maxChange(Sender: TObject);
    procedure beta_r_fitClick(Sender: TObject);
    procedure gamma_r_fitClick(Sender: TObject);
    procedure delta_r_fitClick(Sender: TObject);
    procedure nue2_0Change(Sender: TObject);
    procedure nue2_minChange(Sender: TObject);
    procedure nue2_maxChange(Sender: TObject);
    procedure Button_Default_SurfaceClick(Sender: TObject);
    procedure CP_0Change(Sender: TObject);
    procedure CP_minChange(Sender: TObject);
    procedure CP_maxChange(Sender: TObject);
    procedure CL_0Change(Sender: TObject);
    procedure CL_minChange(Sender: TObject);
    procedure CL_maxChange(Sender: TObject);
    procedure Cp_fitClick(Sender: TObject);
    procedure CL_fitClick(Sender: TObject);
    procedure CMie_fitClick(Sender: TObject);
    procedure CMie_0Change(Sender: TObject);
    procedure CMie_minChange(Sender: TObject);
    procedure CMie_maxChange(Sender: TObject);
    procedure CY_fitClick(Sender: TObject);
    procedure CY_0Change(Sender: TObject);
    procedure CY_minChange(Sender: TObject);
    procedure CY_maxChange(Sender: TObject);
    procedure S_fitClick(Sender: TObject);
    procedure S_0Change(Sender: TObject);
    procedure S_minChange(Sender: TObject);
    procedure S_maxChange(Sender: TObject);
    procedure n_fitClick(Sender: TObject);
    procedure n_0Change(Sender: TObject);
    procedure _minChange(Sender: TObject);
    procedure n_maxChange(Sender: TObject);
    procedure Button_Default_WCClick(Sender: TObject);
    procedure Ccl_fitClick(Sender: TObject);
    procedure CCl_0Change(Sender: TObject);
    procedure Ccl_minChange(Sender: TObject);
    procedure Ccl_maxChange(Sender: TObject);
    procedure CCh_fitClick(Sender: TObject);
    procedure Cch_0Change(Sender: TObject);
    procedure Cch_minChange(Sender: TObject);
    procedure CCh_maxChange(Sender: TObject);
    procedure CD_fitClick(Sender: TObject);
    procedure CD_0Change(Sender: TObject);
    procedure CD_minChange(Sender: TObject);
    procedure CD_maxChange(Sender: TObject);
    procedure CDF_fitClick(Sender: TObject);
    procedure CDF_0Change(Sender: TObject);
    procedure CDF_minChange(Sender: TObject);
    procedure CDF_maxChange(Sender: TObject);
    procedure CG_fitClick(Sender: TObject);
    procedure CG_0Change(Sender: TObject);
    procedure CG_minChange(Sender: TObject);
    procedure CG_maxChange(Sender: TObject);
    procedure Button_Default_AlgaeClick(Sender: TObject);
    procedure TW_fitClick(Sender: TObject);
    procedure TW_0Change(Sender: TObject);
    procedure TW_minChange(Sender: TObject);
    procedure TW_maxChange(Sender: TObject);
    procedure Q_fitClick(Sender: TObject);
    procedure Q_0Change(Sender: TObject);
    procedure Q_minChange(Sender: TObject);
    procedure Q_maxChange(Sender: TObject);
    procedure rho_dd_fitClick(Sender: TObject);
    procedure rho_dd_0Change(Sender: TObject);
    procedure rho_dd_minChange(Sender: TObject);
    procedure rho_dd_maxChange(Sender: TObject);
    procedure Button_Default_MiscClick(Sender: TObject);
    procedure f_fitClick(Sender: TObject);
    procedure f_0Change(Sender: TObject);
    procedure f_minChange(Sender: TObject);
    procedure f_maxChange(Sender: TObject);
    procedure zB_fitClick(Sender: TObject);
    procedure zB_0Change(Sender: TObject);
    procedure fA1_fitClick(Sender: TObject);
    procedure fA2_fitClick(Sender: TObject);
    procedure fA3_fitClick(Sender: TObject);
    procedure fA4_fitClick(Sender: TObject);
    procedure fA5_fitClick(Sender: TObject);
    procedure fA0_fitClick(Sender: TObject);
    procedure fA0_0Change(Sender: TObject);
    procedure fA1_0Change(Sender: TObject);
    procedure fA2_0Change(Sender: TObject);
    procedure fA3_0Change(Sender: TObject);
    procedure fA4_0Change(Sender: TObject);
    procedure fA5_0Change(Sender: TObject);
    procedure zB_minChange(Sender: TObject);
    procedure fA0_minChange(Sender: TObject);
    procedure fA1_minChange(Sender: TObject);
    procedure fA2_minChange(Sender: TObject);
    procedure fA3_minChange(Sender: TObject);
    procedure fA4_minChange(Sender: TObject);
    procedure fA5_minChange(Sender: TObject);
    procedure zB_maxChange(Sender: TObject);
    procedure fA0_maxChange(Sender: TObject);
    procedure fA1_maxChange(Sender: TObject);
    procedure fA2_maxChange(Sender: TObject);
    procedure fA3_maxChange(Sender: TObject);
    procedure fA4_maxChange(Sender: TObject);
    procedure fA5_maxChange(Sender: TObject);
    procedure Button_Default_GroundClick(Sender: TObject);
    procedure fluo_fitClick(Sender: TObject);
    procedure fluo_0Change(Sender: TObject);
    procedure fluo_minChange(Sender: TObject);
    procedure fluo_maxChange(Sender: TObject);
    procedure test_fitClick(Sender: TObject);
    procedure test_0Change(Sender: TObject);
    procedure test_minChange(Sender: TObject);
    procedure test_maxChange(Sender: TObject);
    procedure sun_0Change(Sender: TObject);
    procedure sun_fitClick(Sender: TObject);
    procedure sun_minChange(Sender: TObject);
    procedure sun_maxChange(Sender: TObject);
    procedure f_dd_fitClick(Sender: TObject);
    procedure f_dd_0Change(Sender: TObject);
    procedure f_dd_minChange(Sender: TObject);
    procedure f_dd_maxChange(Sender: TObject);
    procedure f_ds_fitClick(Sender: TObject);
    procedure f_ds_0Change(Sender: TObject);
    procedure f_ds_minChange(Sender: TObject);
    procedure f_ds_maxChange(Sender: TObject);
    procedure H_oz_fitClick(Sender: TObject);
    procedure H_oz_0Change(Sender: TObject);
    procedure H_oz_minChange(Sender: TObject);
    procedure H_oz_maxChange(Sender: TObject);
    procedure WV_fitClick(Sender: TObject);
    procedure WV_0Change(Sender: TObject);
    procedure WV_minChange(Sender: TObject);
    procedure WV_maxChange(Sender: TObject);
    procedure beta_fitClick(Sender: TObject);
    procedure beta_0Change(Sender: TObject);
    procedure beta_minChange(Sender: TObject);
    procedure beta_maxChange(Sender: TObject);
    procedure z_fitClick(Sender: TObject);
    procedure z_0Change(Sender: TObject);
    procedure z_minChange(Sender: TObject);
    procedure z_maxChange(Sender: TObject);
    procedure Button_Default_IlluminationClick(Sender: TObject);
    procedure view_fitClick(Sender: TObject);
    procedure view_0Change(Sender: TObject);
    procedure view_minChange(Sender: TObject);
    procedure view_maxChange(Sender: TObject);
    procedure Button_Default_GeometryClick(Sender: TObject);
    procedure C_D_fitClick(Sender: TObject);
    procedure C_D_0Change(Sender: TObject);
    procedure C_D_minChange(Sender: TObject);
    procedure C_D_maxChange(Sender: TObject);
    procedure rho_ds_fitClick(Sender: TObject);
    procedure rho_ds_0Change(Sender: TObject);
    procedure rho_ds_minChange(Sender: TObject);
    procedure rho_ds_maxChange(Sender: TObject);
    procedure rho_L_fitClick(Sender: TObject);
    procedure rho_L_0Change(Sender: TObject);
    procedure rho_L_minChange(Sender: TObject);
    procedure rho_L_maxChange(Sender: TObject);
    procedure g_dd_fitClick(Sender: TObject);
    procedure g_dd_0Change(Sender: TObject);
    procedure g_dd_minChange(Sender: TObject);
    procedure g_dd_maxChange(Sender: TObject);
    procedure g_dsr_fitClick(Sender: TObject);
    procedure g_dsr_0Change(Sender: TObject);
    procedure g_dsr_minChange(Sender: TObject);
    procedure g_dsr_maxChange(Sender: TObject);
    procedure g_dsa_fitClick(Sender: TObject);
    procedure g_dsa_0Change(Sender: TObject);
    procedure g_dsa_minChange(Sender: TObject);
    procedure g_dsa_maxChange(Sender: TObject);


  private
    input : single;
    error : integer;
  public
    tC           : array[0..5]of Fitparameters;
    tC_L         : Fitparameters;        { Concentration large particles }
    tC_Mie       : Fitparameters;        { Concentration small particles }
    tC_Y         : Fitparameters;        { Concentration yellow substance }
    tC_NAP       : Fitparameters;        { Concentration non-algal particles }
    tS           : Fitparameters;        { exponent yellow substance }
    tQ           : Fitparameters;        { Q-factor (sr) }
    trho_dd      : Fitparameters;        { reflection factor of Edd }
    trho_ds      : Fitparameters;        { reflection factor of Eds }
    trho_L       : Fitparameters;        { reflection factor of Ls }
    talpha_d     : Fitparameters;
    tbeta_d      : Fitparameters;
    tgamma_d     : Fitparameters;
    tdelta_d     : Fitparameters;
    talpha       : Fitparameters;         { Angström exponent of aerosol scattering }
    tn           : Fitparameters;         { Angström exponent of suspended matter backscattering }
    tf           : Fitparameters;         { f-factor (proportionality factor) }
    tT_W         : Fitparameters;        { Water temperature in °C }
    tz           : Fitparameters;        { Sensor depth }
    tzB          : Fitparameters;        { Bottom depth }
    tsun         : Fitparameters;        { sun zenith angle }
    tview        : Fitparameters;        { view zenith angle }
    tdphi        : Fitparameters;        { azimuth difference sun - view }
    tfA          : array[0..5]of Fitparameters;     { bottom albedo fractions }
    talpha_r     : Fitparameters;
    tg_dd        : Fitparameters;
    tg_dsr       : Fitparameters;
    tg_dsa       : Fitparameters;
    tbeta_r      : Fitparameters;
    tgamma_r     : Fitparameters;
    tdelta_r     : Fitparameters;
    tfluo        : Fitparameters;
    tf_dd        : Fitparameters;
    tf_ds        : Fitparameters;
    tH_oz        : Fitparameters;
    tWV          : Fitparameters;
    tbeta        : Fitparameters;
    ttest        : Fitparameters;
  end;

var
  Popup_Fitparameters: TPopup_Fitparameters;

implementation
uses privates;

{$R *.lfm}

procedure TPopup_Fitparameters.FormCreate(Sender: TObject);
begin
    if GUI_scale>1 then begin
        Height:=round(Height*GUI_scale);
        Width:=round(Width*GUI_scale);
        end;

    { Geometry parameters }
    sun_fit.Caption     :=par.name[27];
    view_fit.Caption    :=par.name[28];
    z_fit.Caption       :=par.name[25];
    zB_fit.Caption      :=par.name[26];
    f_fit.Caption       :=par.name[24];
    Q_fit.Caption       :=par.name[13];

    Label_sun.Hint      :=par.desc[27];
    Label_view.Hint     :=par.desc[28];
    Label_z.Hint        :=par.desc[25];
    Label_zB.Hint       :=par.desc[26];
    Label_f.Hint        :=par.desc[24];
    Label_sr.Hint       :=par.desc[13];


    { Illumination parameters }
    f_dd_fit.Caption    :=par.name[20];
    f_ds_fit.Caption    :=par.name[21];
    H_oz_fit.Caption    :=par.name[22];
    alpha_fit.Caption   :=par.name[19];
    beta_fit.Caption    :=par.name[18];
    WV_fit.Caption      :=par.name[23];

    Label_fdd.Hint      :=par.desc[20];
    Label_fds.Hint      :=par.desc[21];
    Label_H_oz.Hint     :=par.desc[22];
    Label_WV.Hint       :=par.desc[23];
    Label_beta.Hint     :=par.desc[18];
    Label_alpha.Hint    :=par.desc[19];

    { Surface parameters }
    rho_dd_fit.Caption  :=par.name[16];
    rho_ds_fit.Caption  :=par.name[17];
    rho_L_fit.Caption   :=par.name[15];
    g_dd_fit.Caption    :=par.name[37];
    g_dsr_fit.Caption   :=par.name[38];
    g_dsa_fit.Caption   :=par.name[39];

    Label_rho_dd.Hint   :=par.desc[16];
    Label_rho_ds.Hint   :=par.desc[17];
    Label_rho_L.Hint    :=par.desc[15];
    Label_g_dd.Hint     :=par.desc[37];
    Label_g_dsr.Hint    :=par.desc[38];
    Label_g_dsa.Hint    :=par.desc[39];

    { Water constituents parameters }
    fluo_fit.Caption    :=par.name[14];
    CL_fit.Caption      :=par.name[7];
    CMie_fit.Caption    :=par.name[8];
    CD_fit.Caption      :=par.name[36];
    CY_fit.Caption      :=par.name[9];
    S_fit.Caption       :=par.name[10];
    n_fit.Caption       :=par.name[11];

    Label_fluo.Hint     :=par.desc[14];
    Label_X.Hint        :=par.desc[7];
    Label_C_Mie.Hint    :=par.desc[8];
    Label_bbs_phy.Hint  :=par.desc[36];
    Label_C_Y.Hint      :=par.desc[9];
    Label_S.Hint        :=par.desc[10];
    Label_angstroem.Hint:=par.desc[11];

    { Algae classes parameters }
    Cp_fit.Caption      :=par.name[1];
    Ccl_fit.Caption     :=par.name[2];
    CCh_fit.Caption     :=par.name[3];
    CD_fit.Caption      :=par.name[4];
    CDF_fit.Caption     :=par.name[5];
    CG_fit.Caption      :=par.name[6];

    Label_C0.Hint       :=par.desc[1];
    Label_C1.Hint       :=par.desc[2];
    Label_C2.Hint       :=par.desc[3];
    Label_C3.Hint       :=par.desc[4];
    Label_C4.Hint       :=par.desc[5];
    Label_C5.Hint       :=par.desc[6];

    { Ground cover parameters }
    fa0_fit.Caption     :=par.name[30];
    fa1_fit.Caption     :=par.name[31];
    fa2_fit.Caption     :=par.name[32];
    fa3_fit.Caption     :=par.name[33];
    fa4_fit.Caption     :=par.name[34];
    fa5_fit.Caption     :=par.name[35];

    Label_fA0.Hint      :=par.desc[30];
    Label_fA1.Hint      :=par.desc[31];
    Label_fA2.Hint      :=par.desc[32];
    Label_fA3.Hint      :=par.desc[33];
    Label_fA4.Hint      :=par.desc[34];
    Label_fA5.Hint      :=par.desc[35];

    { Miscellaneous parameters }
    TW_fit.Caption      :=par.name[12];
    test_fit.Caption    :=par.name[46];

    Label_T_W.Hint      :=par.desc[12];
    Label_test.Hint     :=par.desc[46];

    { Private parameters }
    alpha_d_fit.Caption :=par.name[41];
    beta_d_fit.Caption  :=par.name[42];
    gamma_d_fit.Caption :=par.name[43];
    delta_d_fit.Caption :=par.name[44];
    alpha_r_fit.Caption :=par.name[47];
    beta_r_fit.Caption  :=par.name[48];
    gamma_r_fit.Caption :=par.name[49];
    delta_r_fit.Caption :=par.name[40];

    define_temp_parameters(Sender);
    update_parameterlist(Sender);
{    RegFitpar.ActivePage:=Reflectance; }
    end;

procedure TPopup_Fitparameters.fA3_fitChange(Sender: TObject);
begin

end;

procedure TPopup_Fitparameters.Hide_par(Sender: TObject);
{ Hide some elements in public mode }
begin
    Par_private.TabVisible :=FALSE;
    Label_test.Visible:=FALSE;
    Label_units_test.Visible:=FALSE;
    test_fit.Visible:=FALSE;
    test_0.Visible:=FALSE;
    test_min.Visible:=FALSE;
    test_max.Visible:=FALSE;
    end;

procedure TPopup_Fitparameters.define_temp_parameters(Sender: TObject);
var i : integer;
begin
    for i:=0 to 5 do tC[i]:=C[i];
    tC_L     :=C_X;
    tC_Mie   :=C_Mie;
    tC_Y     :=C_Y;
    tC_NAP   :=bbs_phy;
    tS       :=S;
    tn       :=n;
    tT_W     :=T_W;
    tQ       :=Q;
    trho_dd  :=rho_dd;
    trho_ds  :=rho_ds;
    trho_L   :=rho_L;
    tg_dd    :=g_dd;
    tg_dsr   :=g_dsr;
    tg_dsa   :=g_dsa;
    talpha_r :=alpha_r;
    tbeta_r  :=beta_r;
    tgamma_r :=gamma_r;
    tdelta_r :=delta_r;
    talpha   :=alpha;
    talpha_d :=alpha_d;
    tbeta_d  :=beta_d;
    tgamma_d :=gamma_d;
    tdelta_d :=delta_d;
    tf       :=f;
    tz       :=z;
    tzB      :=zB;
    tsun     :=sun;
    tview    :=view;
    tdphi    :=dphi;
    for i:=0 to 5 do tfA[i]:=fa[i];
    tfluo    :=fluo;
    tf_dd    :=f_dd;
    tf_ds    :=f_ds;
    tH_oz    :=H_oz;
    tWV      :=WV;
    tbeta    :=beta;
    ttest    :=test;

    CP_fit.checked :=C[0].fit=1;
    CCl_fit.checked:=C[1].fit=1;
    CCh_fit.checked:=C[2].fit=1;
    CD_fit.checked :=C[3].fit=1;
    CDF_fit.checked:=C[4].fit=1;
    CG_fit.checked :=C[5].fit=1;
    CL_fit.checked :=C_X.fit=1;
    CMie_fit.checked :=C_Mie.fit=1;
    CY_fit.checked :=C_Y.fit=1;
    C_D_fit.checked:=bbs_phy.fit=1;
    S_fit.checked  :=S.fit=1;
    TW_fit.checked :=T_W.fit=1;
    alpha_d_fit.checked:=alpha_d.fit=1;
    beta_d_fit.checked :=beta_d.fit=1;
    gamma_d_fit.checked:=gamma_d.fit=1;
    delta_d_fit.checked:=delta_d.fit=1;
    alpha_r_fit.checked:=alpha_r.fit=1;
    beta_r_fit.checked :=beta_r.fit=1;
    gamma_r_fit.checked:=gamma_r.fit=1;
    delta_r_fit.checked:=delta_r.fit=1;
    alpha_fit.checked:=alpha.fit=1;
    n_fit.checked:=n.fit=1;
    f_fit.checked:=f.fit=1;
    Q_fit.checked:=Q.fit=1;
    rho_dd_fit.checked:=rho_dd.fit=1;
    rho_ds_fit.checked:=rho_ds.fit=1;
    rho_L_fit.checked :=rho_L.fit=1;
    g_dd_fit.checked  :=g_dd.fit=1;
    g_dsr_fit.checked :=g_dsr.fit=1;
    g_dsa_fit.checked :=g_dsa.fit=1;
    test_fit.checked:=test.fit=1;
    zB_fit.checked:=zB.fit=1;
    z_fit.checked:=z.fit=1;
    fA0_fit.checked:=fA[0].fit=1;
    fA1_fit.checked:=fA[1].fit=1;
    fA2_fit.checked:=fA[2].fit=1;
    fA3_fit.checked:=fA[3].fit=1;
    fA4_fit.checked:=fA[4].fit=1;
    fA5_fit.checked:=fA[5].fit=1;
    fluo_fit.checked:=fluo.fit=1;
    sun_fit.checked:=sun.fit=1;
    view_fit.checked:=view.fit=1;
    f_dd_fit.checked:=f_dd.fit=1;
    f_ds_fit.checked:=f_ds.fit=1;
    H_oz_fit.Checked:=H_oz.fit=1;
    WV_fit.Checked:=WV.fit=1;
    beta_fit.Checked:=beta.fit=1;
    {
    dphi_fit.checked:=dphi.fit=1;
    }
    end;

procedure TPopup_Fitparameters.Model_parametersChange(Sender: TObject);
begin

end;

procedure TPopup_Fitparameters.update_parameterlist(Sender: TObject);
const SIG = 3;
begin
    CP_0.Text   :=schoen(tC[0].actual, SIG);
    CP_min.Text :=schoen(tC[0].min,    SIG);
    CP_max.Text :=schoen(tC[0].max,    SIG);
    CCl_0.Text  :=schoen(tC[1].actual,SIG);
    CCl_min.Text:=schoen(tC[1].min,   SIG);
    CCl_max.Text:=schoen(tC[1].max,   SIG);
    CCh_0.Text  :=schoen(tC[2].actual,SIG);
    CCh_min.Text:=schoen(tC[2].min,   SIG);
    CCh_max.Text:=schoen(tC[2].max,   SIG);
    CD_0.Text   :=schoen(tC[3].actual, SIG);
    CD_min.Text :=schoen(tC[3].min,    SIG);
    CD_max.Text :=schoen(tC[3].max,    SIG);
    CDF_0.Text  :=schoen(tC[4].actual,SIG);
    CDF_min.Text:=schoen(tC[4].min,   SIG);
    CDF_max.Text:=schoen(tC[4].max,   SIG);
    CG_0.Text   :=schoen(tC[5].actual, SIG);
    CG_min.Text :=schoen(tC[5].min,    SIG);
    CG_max.Text :=schoen(tC[5].max,    SIG);
    CL_0.Text   :=schoen(tC_L.actual, SIG);
    CL_min.Text :=schoen(tC_L.min,    SIG);
    CL_max.Text :=schoen(tC_L.max,    SIG);
    CMie_0.Text :=schoen(tC_Mie.actual, SIG);
    CMie_min.Text :=schoen(tC_Mie.min,  SIG);
    CMie_max.Text :=schoen(tC_Mie.max,  SIG);
    CY_0.Text   :=schoen(tC_Y.actual, SIG);
    CY_min.Text :=schoen(tC_Y.min,    SIG);
    CY_max.Text :=schoen(tC_Y.max,    SIG);
    C_D_0.Text   :=schoen(tC_NAP.actual, SIG);
    C_D_min.Text :=schoen(tC_NAP.min,  SIG);
    C_D_max.Text :=schoen(tC_NAP.max,  SIG);
    S_0.Text    :=schoen(tS.actual,   SIG);
    S_min.Text  :=schoen(tS.min,      SIG);
    S_max.Text  :=schoen(tS.max,      SIG);
    TW_0.Text   :=schoen(tT_W.actual, SIG);
    TW_min.Text :=schoen(tT_W.min,    SIG);
    TW_max.Text :=schoen(tT_W.max,    SIG);
    alpha_d_0.Text   :=schoen(talpha_d.actual, SIG);
    alpha_d_min.Text :=schoen(talpha_d.min,    SIG);
    alpha_d_max.Text :=schoen(talpha_d.max,    SIG);
    beta_d0.Text    :=schoen(tbeta_d.actual, SIG);
    beta_dmin.Text  :=schoen(tbeta_d.min,    SIG);
    beta_dmax.Text  :=schoen(tbeta_d.max,    SIG);
    gamma_0.Text   :=schoen(tgamma_d.actual, SIG);
    gamma_min.Text :=schoen(tgamma_d.min,    SIG);
    gamma_max.Text :=schoen(tgamma_d.max,    SIG);
    delta_0.Text   :=schoen(tdelta_d.actual, SIG);
    delta_min.Text :=schoen(tdelta_d.min,    SIG);
    delta_max.Text :=schoen(tdelta_d.max,    SIG);
    alpha_r_0.Text :=schoen(talpha_r.actual, SIG);
    alpha_r_min.Text :=schoen(talpha_r.min,   SIG);
    alpha_r_max.Text :=schoen(talpha_r.max,   SIG);
    beta_r_0.Text    :=schoen(tbeta_r.actual, SIG);
    beta_r_min.Text  :=schoen(tbeta_r.min,    SIG);
    beta_r_max.Text  :=schoen(tbeta_r.max,    SIG);
    gamma_r_0.Text   :=schoen(tgamma_r.actual, SIG);
    gamma_r_min.Text :=schoen(tgamma_r.min,    SIG);
    gamma_r_max.Text :=schoen(tgamma_r.max,    SIG);
    delta_r_0.Text   :=schoen(tdelta_r.actual, SIG);
    delta_r_min.Text :=schoen(tdelta_r.min,    SIG);
    delta_r_max.Text :=schoen(tdelta_r.max,    SIG);
    alpha_0.Text     :=schoen(talpha.actual, SIG);
    alpha_min.Text   :=schoen(talpha.min,    SIG);
    alpha_max.Text   :=schoen(talpha.max,    SIG);
    n_0.Text       :=schoen(tn.actual, SIG);
    n_min.Text     :=schoen(tn.min,    SIG);
    n_max.Text     :=schoen(tn.max,    SIG);
    f_0.Text       :=schoen(tf.actual, SIG);
    f_min.Text     :=schoen(tf.min,    SIG);
    f_max.Text     :=schoen(tf.max,    SIG);
    Q_0.Text       :=schoen(tQ.actual, SIG);
    Q_min.Text     :=schoen(tQ.min,    SIG);
    Q_max.Text     :=schoen(tQ.max,    SIG);
    rho_dd_0.Text  :=schoen(trho_dd.actual, SIG);
    rho_dd_min.Text:=schoen(trho_dd.min,    SIG);
    rho_dd_max.Text:=schoen(trho_dd.max,    SIG);
    rho_ds_0.Text  :=schoen(trho_ds.actual, SIG);
    rho_ds_min.Text:=schoen(trho_ds.min,    SIG);
    rho_ds_max.Text:=schoen(trho_ds.max,    SIG);
    rho_L_0.Text   :=schoen(trho_L.actual,  SIG);
    rho_L_min.Text :=schoen(trho_L.min,     SIG);
    rho_L_max.Text :=schoen(trho_L.max,     SIG);
    g_dd_0.Text    :=schoen(tg_dd.actual,   SIG);
    g_dd_min.Text  :=schoen(tg_dd.min,      SIG);
    g_dd_max.Text  :=schoen(tg_dd.max,      SIG);
    g_dsr_0.Text   :=schoen(tg_dsr.actual,  SIG);
    g_dsr_min.Text :=schoen(tg_dsr.min,     SIG);
    g_dsr_max.Text :=schoen(tg_dsr.max,     SIG);
    g_dsa_0.Text   :=schoen(tg_dsa.actual,  SIG);
    g_dsa_min.Text :=schoen(tg_dsa.min,     SIG);
    g_dsa_max.Text :=schoen(tg_dsa.max,     SIG);

    test_0.Text    :=schoen(ttest.actual, SIG);
    test_min.Text  :=schoen(ttest.min,    SIG);
    test_max.Text  :=schoen(ttest.max,    SIG);

    sun_0.Text    :=schoen(tsun.actual, SIG);
    sun_min.Text  :=schoen(tsun.min,    SIG);
    sun_max.Text  :=schoen(tsun.max,    SIG);
    view_0.Text   :=schoen(tview.actual, SIG);
    view_min.Text :=schoen(tview.min,    SIG);
    view_max.Text :=schoen(tview.max,    SIG);
    f_dd_0.Text   :=schoen(tf_dd.actual, SIG);
    f_dd_min.Text :=schoen(tf_dd.min,    SIG);
    f_dd_max.Text :=schoen(tf_dd.max,    SIG);
    f_ds_0.Text   :=schoen(tf_ds.actual, SIG);
    f_ds_min.Text :=schoen(tf_ds.min,    SIG);
    f_ds_max.Text :=schoen(tf_ds.max,    SIG);
    H_oz_0.Text   :=schoen(tH_oz.actual, SIG);
    H_oz_min.Text :=schoen(tH_oz.min,    SIG);
    H_oz_max.Text :=schoen(tH_oz.max,    SIG);
    WV_0.Text     :=schoen(tWV.actual,   SIG);
    WV_min.Text   :=schoen(tWV.min,      SIG);
    WV_max.Text   :=schoen(tWV.max,      SIG);
    beta_0.Text   :=schoen(tbeta.actual,   SIG);
    beta_min.Text :=schoen(tbeta.min,      SIG);
    beta_max.Text :=schoen(tbeta.max,      SIG);

    z_0.Text       :=schoen(tz.actual, SIG);
    z_min.Text     :=schoen(tz.min,    SIG);
    z_max.Text     :=schoen(tz.max,    SIG);
    zB_0.Text      :=schoen(tzB.actual, SIG);
    zB_min.Text    :=schoen(tzB.min,    SIG);
    zB_max.Text    :=schoen(tzB.max,    SIG);
    fA0_0.Text     :=schoen(tfA[0].actual, SIG);
    fA0_min.Text   :=schoen(tfA[0].min,    SIG);
    fA0_max.Text   :=schoen(tfA[0].max,    SIG);
    fA1_0.Text     :=schoen(tfA[1].actual, SIG);
    fA1_min.Text   :=schoen(tfA[1].min,    SIG);
    fA1_max.Text   :=schoen(tfA[1].max,    SIG);
    fA2_0.Text     :=schoen(tfA[2].actual, SIG);
    fA2_min.Text   :=schoen(tfA[2].min,    SIG);
    fA2_max.Text   :=schoen(tfA[2].max,    SIG);
    fA3_0.Text     :=schoen(tfA[3].actual, SIG);
    fA3_min.Text   :=schoen(tfA[3].min,    SIG);
    fA3_max.Text   :=schoen(tfA[3].max,    SIG);
    fA4_0.Text     :=schoen(tfA[4].actual, SIG);
    fA4_min.Text   :=schoen(tfA[4].min,    SIG);
    fA4_max.Text   :=schoen(tfA[4].max,    SIG);
    fA5_0.Text     :=schoen(tfA[5].actual, SIG);
    fA5_min.Text   :=schoen(tfA[5].min,    SIG);
    fA5_max.Text   :=schoen(tfA[5].max,    SIG);
    fluo_0.Text    :=schoen(tfluo.actual,   SIG);
    fluo_min.Text  :=schoen(tfluo.min,      SIG);
    fluo_max.Text  :=schoen(tfluo.max,      SIG);
    alpha_r_0.Text :=schoen(talpha_r.actual, SIG);
    beta_r_0.Text  :=schoen(tbeta_r.actual,  SIG);
    gamma_r_0.Text :=schoen(tgamma_r.actual, SIG);
    delta_r_0.Text :=schoen(tdelta_r.actual, SIG);
    if flag_public then Hide_par(Sender);
    end;

procedure TPopup_Fitparameters.set_temp_parameters(Sender: TObject);
var i : integer;
begin
    for i:=0 to 5 do C[i]:=tC[i];
    C_X     :=tC_L;
    C_Mie   :=tC_Mie;
    C_Y     :=tC_Y;
    bbs_phy :=tC_NAP;
    S       :=tS;
    n       :=tn;
    T_W     :=tT_W;
    Q       :=tQ;
    rho_dd  :=trho_dd;
    rho_ds  :=trho_ds;
    rho_L   :=trho_L;
    g_dd    :=tg_dd;
    g_dsr   :=tg_dsr;
    g_dsa   :=tg_dsa;
    alpha_r :=talpha_r;
    beta_r  :=tbeta_r;
    gamma_r :=tgamma_r;
    delta_r :=tdelta_r;
    alpha   :=talpha;
    alpha_d :=talpha_d;
    beta_d  :=tbeta_d;
    gamma_d :=tgamma_d;
    delta_d :=tdelta_d;
    f       :=tf;
    z       :=tz;
    zB      :=tzB;
    for i:=0 to 5 do fA[i]:=tfA[i];
    fluo    :=tfluo;
    sun     :=tsun;
    view    :=tview;
    f_dd    :=tf_dd;
    f_ds    :=tf_ds;
    H_oz    :=tH_oz;
    WV      :=tWV;
    beta    :=tbeta;
    test    :=ttest;
    end;



procedure TPopup_Fitparameters.alpha_d_fitClick(Sender: TObject);
begin
    if alpha_d_fit.checked then talpha_d.fit:=1 else talpha_d.fit:=0;
    end;

procedure TPopup_Fitparameters.beta_d_fitClick(Sender: TObject);
begin
    if beta_d_fit.checked then tbeta_d.fit:=1 else tbeta_d.fit:=0;
    end;

procedure TPopup_Fitparameters.gamma_d_fitClick(Sender: TObject);
begin
    if gamma_d_fit.checked then tgamma_d.fit:=1 else tgamma_d.fit:=0;
    end;

procedure TPopup_Fitparameters.delta_d_fitClick(Sender: TObject);
begin
    if delta_d_fit.checked then tdelta_d.fit:=1 else tdelta_d.fit:=0;
    end;

procedure TPopup_Fitparameters.alpha_r_0Change(Sender: TObject);
begin
    val(alpha_r_0.Text, input, error);
    if error=0 then talpha_r.actual:=input;
    if talpha_r.actual<talpha_r.min then talpha_r.actual:=talpha_r.min;
    end;

procedure TPopup_Fitparameters.alpha_r_minChange(Sender: TObject);
begin
    val(alpha_r_min.Text, input, error);
    if error=0 then talpha_r.min:=input;
    if talpha_r.min>talpha_r.max then talpha_r.min:=talpha_r.max;
    end;

procedure TPopup_Fitparameters.alpha_r_maxChange(Sender: TObject);
begin
    val(alpha_r_max.Text, input, error);
    if error=0 then talpha_r.max:=input;
    if talpha_r.max<talpha_r.min then talpha_r.max:=talpha_r.min;
    end;

procedure TPopup_Fitparameters.alpha_d_0Change(Sender: TObject);
begin
    val(alpha_d_0.Text, input, error);
    if error=0 then talpha_d.actual:=input;
    if talpha_d.actual<talpha_d.min then talpha_d.actual:=talpha_d.min;
    end;

procedure TPopup_Fitparameters.alpha_d_minChange(Sender: TObject);
begin
    val(alpha_d_min.Text, input, error);
    if error=0 then talpha_d.min:=input;
    if talpha_d.min>talpha_d.max then talpha_d.min:=talpha_d.max;
    end;

procedure TPopup_Fitparameters.alpha_d_maxChange(Sender: TObject);
begin
    val(alpha_d_max.Text, input, error);
    if error=0 then talpha_d.max:=input;
    if talpha_d.max<talpha_d.min then talpha_d.max:=talpha_d.min;
    end;

procedure TPopup_Fitparameters.ButtonOKClick(Sender: TObject);
begin
    set_temp_parameters(Sender);
    ModalResult := mrOK;
    end;

procedure TPopup_Fitparameters.ButtonCancelClick(Sender: TObject);
begin
    ModalResult := mrCancel;
    end;

procedure TPopup_Fitparameters.alpha_r_fitClick(Sender: TObject);
begin
    if alpha_r_fit.checked then talpha_r.fit:=1 else talpha_r.fit:=0;
    end;

procedure TPopup_Fitparameters.beta_d0Change(Sender: TObject);
begin
    val(beta_d0.Text, input, error);
    if error=0 then tbeta_d.actual:=input;
    if tbeta_d.actual<tbeta_d.min then tbeta_d.actual:=tbeta_d.min;
    end;

procedure TPopup_Fitparameters.beta_dminChange(Sender: TObject);
begin
    val(beta_dmin.Text, input, error);
    if error=0 then tbeta_d.min:=input;
    if tbeta_d.min>tbeta_d.max then tbeta_d.min:=tbeta_d.max;
    end;

procedure TPopup_Fitparameters.beta_dmaxChange(Sender: TObject);
begin
    val(beta_dmax.Text, input, error);
    if error=0 then tbeta_d.max:=input;
    if tbeta_d.max<tbeta_d.min then tbeta_d.max:=tbeta_d.min;
    end;

procedure TPopup_Fitparameters.gamma_0Change(Sender: TObject);
begin
    val(gamma_0.Text, input, error);
    if error=0 then tgamma_d.actual:=input;
    if tgamma_d.actual<tgamma_d.min then tgamma_d.actual:=tgamma_d.min;
    end;

procedure TPopup_Fitparameters.gamma_minChange(Sender: TObject);
begin
    val(gamma_min.Text, input, error);
    if error=0 then tgamma_d.min:=input;
    if tgamma_d.min>tgamma_d.max then tgamma_d.min:=tgamma_d.max;
    end;

procedure TPopup_Fitparameters.gamma_maxChange(Sender: TObject);
begin
    val(gamma_max.Text, input, error);
    if error=0 then tgamma_d.max:=input;
    if tgamma_d.max<tgamma_d.min then tgamma_d.max:=tgamma_d.min;
    end;

procedure TPopup_Fitparameters.delta_0Change(Sender: TObject);
begin
    val(delta_0.Text, input, error);
    if error=0 then tdelta_d.actual:=input;
    if tdelta_d.actual<tdelta_d.min then tdelta_d.actual:=tdelta_d.min;
    end;

procedure TPopup_Fitparameters.delta_minChange(Sender: TObject);
begin
    val(delta_min.Text, input, error);
    if error=0 then tdelta_d.min:=input;
    if tdelta_d.min>tdelta_d.max then tdelta_d.min:=tdelta_d.max;
    end;

procedure TPopup_Fitparameters.delta_maxChange(Sender: TObject);
begin
    val(delta_max.Text, input, error);
    if error=0 then tdelta_d.max:=input;
    if tdelta_d.max<tdelta_d.min then tdelta_d.max:=tdelta_d.min;
    end;

procedure TPopup_Fitparameters.alpha_0Change(Sender: TObject);
begin
    val(alpha_0.Text, input, error);
    if error=0 then talpha.actual:=input;
    if talpha.actual<talpha.min then talpha.actual:=talpha.min;
    end;

procedure TPopup_Fitparameters.alpha_minChange(Sender: TObject);
begin
    val(alpha_min.Text, input, error);
    if error=0 then talpha.min:=input;
    if talpha.min>talpha.max then talpha.min:=talpha.max;
    end;

procedure TPopup_Fitparameters.alpha_maxChange(Sender: TObject);
begin
    val(alpha_max.Text, input, error);
    if error=0 then talpha.max:=input;
    if talpha.max<talpha.min then talpha.max:=talpha.min;
    end;

procedure TPopup_Fitparameters.alpha_fitClick(Sender: TObject);
begin
    if alpha_fit.checked then talpha.fit:=1 else talpha.fit:=0;
    end;

procedure TPopup_Fitparameters.Button_Default_Ed_oldClick(Sender: TObject);
begin
    talpha_d.actual :=alpha_d.default;
    tbeta_d.actual  :=beta_d.default;
    tgamma_d.actual :=gamma_d.default;
    tdelta_d.actual :=delta_d.default;
    talpha_r.actual :=alpha_r.default;
    tbeta_r.actual  :=beta_r.default;
    tgamma_r.actual :=gamma_r.default;
    tdelta_r.actual :=delta_r.default;
    update_parameterlist(Sender);
    end;

procedure TPopup_Fitparameters.beta_r_0Change(Sender: TObject);
begin
    val(beta_r_0.Text, input, error);
    if error=0 then tbeta_r.actual:=input;
    if tbeta_r.actual<tbeta_r.min then tbeta_r.actual:=tbeta_r.min;
    end;

procedure TPopup_Fitparameters.beta_r_minChange(Sender: TObject);
begin
    val(beta_r_min.Text, input, error);
    if error=0 then tbeta_r.min:=input;
    if tbeta_r.min>tbeta_r.max then tbeta_r.min:=tbeta_r.max;
    end;

procedure TPopup_Fitparameters.beta_r_maxChange(Sender: TObject);
begin
    val(beta_r_max.Text, input, error);
    if error=0 then tbeta_r.max:=input;
    if tbeta_r.max<tbeta_r.min then tbeta_r.max:=tbeta_r.min;
    end;

procedure TPopup_Fitparameters.gamma_r_0Change(Sender: TObject);
begin
    val(gamma_r_0.Text, input, error);
    if error=0 then tgamma_r.actual:=input;
    if tgamma_r.actual<tgamma_r.min then tgamma_r.actual:=tgamma_r.min;
    end;

procedure TPopup_Fitparameters.gamma_r_minChange(Sender: TObject);
begin
    val(gamma_r_min.Text, input, error);
    if error=0 then tgamma_r.min:=input;
    if tgamma_r.min>tgamma_r.max then tgamma_r.min:=tgamma_r.max;
    end;

procedure TPopup_Fitparameters.gamma_r_maxChange(Sender: TObject);
begin
    val(gamma_r_max.Text, input, error);
    if error=0 then tgamma_r.max:=input;
    if tgamma_r.max<tgamma_r.min then tgamma_r.max:=tgamma_r.min;
    end;

procedure TPopup_Fitparameters.delta_r_0Change(Sender: TObject);
begin
    val(delta_r_0.Text, input, error);
    if error=0 then tdelta_r.actual:=input;
    if tdelta_r.actual<tdelta_r.min then tdelta_r.actual:=tdelta_r.min;
    end;

procedure TPopup_Fitparameters.delta_r_minChange(Sender: TObject);
begin
    val(delta_r_min.Text, input, error);
    if error=0 then tdelta_r.min:=input;
    if tdelta_r.min>tdelta_r.max then tdelta_r.min:=tdelta_r.max;
    end;

procedure TPopup_Fitparameters.delta_r_maxChange(Sender: TObject);
begin
    val(delta_r_max.Text, input, error);
    if error=0 then tdelta_r.max:=input;
    if tdelta_r.max<tdelta_r.min then tdelta_r.max:=tdelta_r.min;
    end;

procedure TPopup_Fitparameters.beta_r_fitClick(Sender: TObject);
begin
    if beta_r_fit.checked then tbeta_r.fit:=1 else tbeta_r.fit:=0;
    end;

procedure TPopup_Fitparameters.gamma_r_fitClick(Sender: TObject);
begin
    if gamma_r_fit.checked then tgamma_r.fit:=1 else tgamma_r.fit:=0;
    end;

procedure TPopup_Fitparameters.delta_r_fitClick(Sender: TObject);
begin
    if delta_r_fit.checked then tdelta_r.fit:=1 else tdelta_r.fit:=0;
    end;

procedure TPopup_Fitparameters.nue2_0Change(Sender: TObject);
begin
    if error=0 then talpha.actual:=input;
    if talpha.actual<talpha.min then talpha.actual:=talpha.min;
    end;

procedure TPopup_Fitparameters.nue2_minChange(Sender: TObject);
begin
    if error=0 then talpha.min:=input;
    if talpha.min>talpha.max then talpha.min:=talpha.max;
    end;

procedure TPopup_Fitparameters.nue2_maxChange(Sender: TObject);
begin
    if error=0 then talpha.max:=input;
    if talpha.max<talpha.min then talpha.max:=talpha.min;
    end;

procedure TPopup_Fitparameters.Button_Default_SurfaceClick(Sender: TObject);
begin
    trho_dd.actual :=rho_dd.default;
    trho_ds.actual :=rho_ds.default;
    trho_L.actual  :=rho_L.default;
    tg_dd.actual   :=g_dd.default;
    tg_dsr.actual  :=g_dsr.default;
    tg_dsa.actual  :=g_dsa.default;
    update_parameterlist(Sender);
    end;

procedure TPopup_Fitparameters.CP_0Change(Sender: TObject);
begin
    val(CP_0.Text, input, error);
    if error=0 then tC[0].actual:=input;
    if tC[0].actual<tC[0].min then tC[0].actual:=tC[0].min;
    end;

procedure TPopup_Fitparameters.CP_minChange(Sender: TObject);
begin
    val(CP_min.Text, input, error);
    if error=0 then tC[0].min:=input;
    if tC[0].min>tC[0].max then tC[0].min:=tC[0].max;
    end;

procedure TPopup_Fitparameters.CP_maxChange(Sender: TObject);
begin
    val(CP_max.Text, input, error);
    if error=0 then tC[0].max:=input;
    if tC[0].max<tC[0].min then tC[0].max:=tC[0].min;
    end;

procedure TPopup_Fitparameters.CL_0Change(Sender: TObject);
begin
    val(CL_0.Text, input, error);
    if error=0 then tC_L.actual:=input;
    if tC_L.actual<tC_L.min then tC_L.actual:=tC_L.min;
    end;

procedure TPopup_Fitparameters.CL_minChange(Sender: TObject);
begin
    val(CL_min.Text, input, error);
    if error=0 then tC_L.min:=input;
    if tC_L.min>tC_L.max then tC_L.min:=tC_L.max;
    end;

procedure TPopup_Fitparameters.CL_maxChange(Sender: TObject);
begin
    val(CL_max.Text, input, error);
    if error=0 then tC_L.max:=input;
    if tC_L.max<tC_L.min then tC_L.max:=tC_L.min;
    end;

procedure TPopup_Fitparameters.Cp_fitClick(Sender: TObject);
begin
    if CP_fit.checked then tC[0].fit:=1 else tC[0].fit:=0;
    end;

procedure TPopup_Fitparameters.CL_fitClick(Sender: TObject);
begin
    if CL_fit.checked then tC_L.fit:=1 else tC_L.fit:=0;
    end;

procedure TPopup_Fitparameters.CMie_fitClick(Sender: TObject);
begin
    if CMie_fit.checked then tC_Mie.fit:=1 else tC_Mie.fit:=0;
    end;

procedure TPopup_Fitparameters.CMie_0Change(Sender: TObject);
begin
    val(CMie_0.Text, input, error);
    if error=0 then tC_Mie.actual:=input;
    if tC_Mie.actual<tC_Mie.min then tC_Mie.actual:=tC_Mie.min;
    end;

procedure TPopup_Fitparameters.CMie_minChange(Sender: TObject);
begin
    val(CMie_min.Text, input, error);
    if error=0 then tC_Mie.min:=input;
    if tC_Mie.min>tC_Mie.max then tC_Mie.min:=tC_Mie.max;
    end;

procedure TPopup_Fitparameters.CMie_maxChange(Sender: TObject);
begin
    val(CMie_max.Text, input, error);
    if error=0 then tC_Mie.max:=input;
    if tC_Mie.max<tC_Mie.min then tC_Mie.max:=tC_Mie.min;
    end;

procedure TPopup_Fitparameters.CY_fitClick(Sender: TObject);
begin
    if CY_fit.checked then tC_Y.fit:=1 else tC_Y.fit:=0;
    end;

procedure TPopup_Fitparameters.CY_0Change(Sender: TObject);
begin
    val(CY_0.Text, input, error);
    if error=0 then tC_Y.actual:=input;
    if tC_Y.actual<tC_Y.min then tC_Y.actual:=tC_Y.min;
    end;

procedure TPopup_Fitparameters.CY_minChange(Sender: TObject);
begin
    val(CY_min.Text, input, error);
    if error=0 then tC_Y.min:=input;
    if tC_Y.min>tC_Y.max then tC_Y.min:=tC_Y.max;
    end;

procedure TPopup_Fitparameters.CY_maxChange(Sender: TObject);
begin
    val(CY_max.Text, input, error);
    if error=0 then tC_Y.max:=input;
    if tC_Y.max<tC_Y.min then tC_Y.max:=tC_Y.min;
    end;

procedure TPopup_Fitparameters.S_fitClick(Sender: TObject);
begin
    if S_fit.checked then tS.fit:=1 else tS.fit:=0;
    end;

procedure TPopup_Fitparameters.S_0Change(Sender: TObject);
begin
    val(S_0.Text, input, error);
    if error=0 then tS.actual:=input;
    if tS.actual<tS.min then tS.actual:=tS.min;
    end;

procedure TPopup_Fitparameters.S_minChange(Sender: TObject);
begin
    val(S_min.Text, input, error);
    if error=0 then tS.min:=input;
    if tS.min>tS.max then tS.min:=tS.max;
    end;

procedure TPopup_Fitparameters.S_maxChange(Sender: TObject);
begin
    val(S_max.Text, input, error);
    if error=0 then tS.max:=input;
    if tS.max<tS.min then tS.max:=tS.min;
    end;

procedure TPopup_Fitparameters.n_fitClick(Sender: TObject);
begin
    if n_fit.checked then tn.fit:=1 else tn.fit:=0;
    end;

procedure TPopup_Fitparameters.n_0Change(Sender: TObject);
begin
    val(n_0.Text, input, error);
    if error=0 then tn.actual:=input;
    if tn.actual<tn.min then tn.actual:=tn.min;
    end;

procedure TPopup_Fitparameters._minChange(Sender: TObject);
begin
    val(n_min.Text, input, error);
    if error=0 then tn.min:=input;
    if tn.min>tn.max then tn.min:=tn.max;
    end;

procedure TPopup_Fitparameters.n_maxChange(Sender: TObject);
begin
    val(n_max.Text, input, error);
    if error=0 then tn.max:=input;
    if tn.max<tn.min then tn.max:=tn.min;
    end;

procedure TPopup_Fitparameters.Button_Default_WCClick(Sender: TObject);
begin
    tC[0].actual  :=tC[0].default;
    tfluo.actual  :=fluo.default;
    tC_L.actual   :=C_X.default;
    tC_Mie.actual :=C_Mie.default;
    tC_NAP.actual :=bbs_phy.default;
    tC_Y.actual   :=C_Y.default;
    tS.actual     :=S.default;
    tn.actual     :=n.default;
    update_parameterlist(Sender);
    end;

procedure TPopup_Fitparameters.Ccl_fitClick(Sender: TObject);
begin
    if CCl_fit.checked then tC[1].fit:=1 else tC[1].fit:=0;
    end;

procedure TPopup_Fitparameters.CCl_0Change(Sender: TObject);
begin
    val(CCl_0.Text, input, error);
    if error=0 then tC[1].actual:=input;
    if tC[1].actual<tC[1].min then tC[1].actual:=tC[1].min;
    end;

procedure TPopup_Fitparameters.Ccl_minChange(Sender: TObject);
begin
    val(CCl_min.Text, input, error);
    if error=0 then tC[1].min:=input;
    if tC[1].min>tC[1].max then tC[1].min:=tC[1].max;
    end;

procedure TPopup_Fitparameters.Ccl_maxChange(Sender: TObject);
begin
    val(CCl_max.Text, input, error);
    if error=0 then tC[1].max:=input;
    if tC[1].max<tC[1].min then tC[1].max:=tC[1].min;
    end;

procedure TPopup_Fitparameters.CCh_fitClick(Sender: TObject);
begin
    if CCh_fit.checked then tC[2].fit:=1 else tC[2].fit:=0;
    end;

procedure TPopup_Fitparameters.Cch_0Change(Sender: TObject);
begin
    val(CCh_0.Text, input, error);
    if error=0 then tC[2].actual:=input;
    if tC[2].actual<tC[2].min then tC[2].actual:=tC[2].min;
    end;

procedure TPopup_Fitparameters.Cch_minChange(Sender: TObject);
begin
    val(CCh_min.Text, input, error);
    if error=0 then tC[2].min:=input;
    if tC[2].min>tC[2].max then tC[2].min:=tC[2].max;
    end;

procedure TPopup_Fitparameters.CCh_maxChange(Sender: TObject);
begin
    val(CCh_max.Text, input, error);
    if error=0 then tC[2].max:=input;
    if tC[2].max<tC[2].min then tC[2].max:=tC[2].min;
    end;

procedure TPopup_Fitparameters.CD_fitClick(Sender: TObject);
begin
    if CD_fit.checked then tC[3].fit:=1 else tC[3].fit:=0;
    end;

procedure TPopup_Fitparameters.CD_0Change(Sender: TObject);
begin
    val(CD_0.Text, input, error);
    if error=0 then tC[3].actual:=input;
    if tC[3].actual<tC[3].min then tC[3].actual:=tC[3].min;
    end;


procedure TPopup_Fitparameters.CD_minChange(Sender: TObject);
begin
    val(CD_min.Text, input, error);
    if error=0 then tC[3].min:=input;
    if tC[3].min>tC[3].max then tC[3].min:=tC[3].max;
    end;

procedure TPopup_Fitparameters.CD_maxChange(Sender: TObject);
begin
    val(CD_max.Text, input, error);
    if error=0 then tC[3].max:=input;
    if tC[3].max<tC[3].min then tC[3].max:=tC[3].min;
    end;

procedure TPopup_Fitparameters.CDF_fitClick(Sender: TObject);
begin
    if CDF_fit.checked then tC[4].fit:=1 else tC[4].fit:=0;
    end;

procedure TPopup_Fitparameters.CDF_0Change(Sender: TObject);
begin
    val(CDF_0.Text, input, error);
    if error=0 then tC[4].actual:=input;
    if tC[4].actual<tC[4].min then tC[4].actual:=tC[4].min;
    end;


procedure TPopup_Fitparameters.CDF_minChange(Sender: TObject);
begin
    val(CDF_min.Text, input, error);
    if error=0 then tC[4].min:=input;
    if tC[4].min>tC[4].max then tC[4].min:=tC[4].max;
    end;

procedure TPopup_Fitparameters.CDF_maxChange(Sender: TObject);
begin
    val(CDF_max.Text, input, error);
    if error=0 then tC[4].max:=input;
    if tC[4].max<tC[4].min then tC[4].max:=tC[4].min;
    end;

procedure TPopup_Fitparameters.CG_fitClick(Sender: TObject);
begin
    if CG_fit.checked then tC[5].fit:=1 else tC[5].fit:=0;
    end;

procedure TPopup_Fitparameters.CG_0Change(Sender: TObject);
begin
    val(CG_0.Text, input, error);
    if error=0 then tC[5].actual:=input;
    if tC[5].actual<tC[5].min then tC[5].actual:=tC[5].min;
    end;


procedure TPopup_Fitparameters.CG_minChange(Sender: TObject);
begin
    val(CG_min.Text, input, error);
    if error=0 then tC[5].min:=input;
    if tC[5].min>tC[5].max then tC[5].min:=tC[5].max;
    end;

procedure TPopup_Fitparameters.CG_maxChange(Sender: TObject);
begin
    val(CG_max.Text, input, error);
    if error=0 then tC[5].max:=input;
    if tC[5].max<tC[5].min then tC[5].max:=tC[5].min;
    end;

procedure TPopup_Fitparameters.Button_Default_AlgaeClick(Sender: TObject);
var i : integer;
begin
    for i:=1 to 5 do tC[i].actual:=C[i].default;
    update_parameterlist(Sender);
    end;

procedure TPopup_Fitparameters.TW_fitClick(Sender: TObject);
begin
    if TW_fit.checked then tT_W.fit:=1 else tT_W.fit:=0;
    end;

procedure TPopup_Fitparameters.TW_0Change(Sender: TObject);
begin
    val(TW_0.Text, input, error);
    if error=0 then tT_W.actual:=input;
    if tT_W.actual<tT_W.min then tT_W.actual:=tT_W.min;
    end;

procedure TPopup_Fitparameters.TW_minChange(Sender: TObject);
begin
    val(TW_min.Text, input, error);
    if error=0 then tT_W.min:=input;
    if tT_W.min>tT_W.max then tT_W.min:=tT_W.max;
    end;

procedure TPopup_Fitparameters.TW_maxChange(Sender: TObject);
begin
    val(TW_max.Text, input, error);
    if error=0 then tT_W.max:=input;
    if tT_W.max<tT_W.min then tT_W.max:=tT_W.min;
    end;

procedure TPopup_Fitparameters.Q_fitClick(Sender: TObject);
begin
    if Q_fit.checked then tQ.fit:=1 else tQ.fit:=0;
    end;

procedure TPopup_Fitparameters.Q_0Change(Sender: TObject);
begin
    val(Q_0.Text, input, error);
    if error=0 then tQ.actual:=input;
    if tQ.actual<tQ.min then tQ.actual:=tQ.min;
    end;

procedure TPopup_Fitparameters.Q_minChange(Sender: TObject);
begin
    val(Q_min.Text, input, error);
    if error=0 then tQ.min:=input;
    if tQ.min>tQ.max then tQ.min:=tQ.max;
    end;

procedure TPopup_Fitparameters.Q_maxChange(Sender: TObject);
begin
    val(Q_max.Text, input, error);
    if error=0 then tQ.max:=input;
    if tQ.max<tQ.min then tQ.max:=tQ.min;
    end;

procedure TPopup_Fitparameters.rho_dd_fitClick(Sender: TObject);
begin
    if rho_dd_fit.checked then trho_dd.fit:=1 else trho_dd.fit:=0;
    end;

procedure TPopup_Fitparameters.rho_dd_0Change(Sender: TObject);
begin
    val(rho_dd_0.Text, input, error);
    if error=0 then trho_dd.actual:=input;
    if trho_dd.actual<tdelta_r.min then tdelta_r.actual:=tdelta_r.min;
    end;

procedure TPopup_Fitparameters.rho_dd_minChange(Sender: TObject);
begin
    val(rho_dd_min.Text, input, error);
    if error=0 then trho_dd.min:=input;
    if trho_dd.min>trho_dd.max then trho_dd.min:=trho_dd.max;
    end;

procedure TPopup_Fitparameters.rho_dd_maxChange(Sender: TObject);
begin
    val(rho_dd_max.Text, input, error);
    if error=0 then trho_dd.max:=input;
    if trho_dd.max<trho_dd.min then trho_dd.max:=trho_dd.min;
    end;

procedure TPopup_Fitparameters.Button_Default_MiscClick(Sender: TObject);
begin
    tT_W.actual :=T_W.default;
    ttest.actual:=test.default;
    update_parameterlist(Sender);
    end;

procedure TPopup_Fitparameters.f_fitClick(Sender: TObject);
begin
    if f_fit.checked then tf.fit:=1 else tf.fit:=0;
    end;

procedure TPopup_Fitparameters.f_0Change(Sender: TObject);
begin
    val(f_0.Text, input, error);
    if error=0 then tf.actual:=input;
    if tf.actual<tf.min then tf.actual:=tf.min;
    end;

procedure TPopup_Fitparameters.f_minChange(Sender: TObject);
begin
    val(f_min.Text, input, error);
    if error=0 then tf.min:=input;
    if tf.min>tf.max then tf.min:=tf.max;
    end;

procedure TPopup_Fitparameters.f_maxChange(Sender: TObject);
begin
    val(f_max.Text, input, error);
    if error=0 then tf.max:=input;
    if tf.max<tf.min then tf.max:=tf.min;
    end;

procedure TPopup_Fitparameters.zB_fitClick(Sender: TObject);
begin
    if zB_fit.checked then tzB.fit:=1 else tzB.fit:=0;
    end;

procedure TPopup_Fitparameters.zB_0Change(Sender: TObject);
begin
    val(zB_0.Text, input, error);
    if error=0 then tzB.actual:=input;
    if tzB.actual<tzB.min then tzB.actual:=tzB.min;
    end;

procedure TPopup_Fitparameters.fA0_fitClick(Sender: TObject);
begin
    if fA0_fit.checked then tfA[0].fit:=1 else tfA[0].fit:=0;
    end;

procedure TPopup_Fitparameters.fA1_fitClick(Sender: TObject);
begin
    if fA1_fit.checked then tfA[1].fit:=1 else tfA[1].fit:=0;
    end;

procedure TPopup_Fitparameters.fA2_fitClick(Sender: TObject);
begin
    if fA2_fit.checked then tfA[2].fit:=1 else tfA[2].fit:=0;
    end;

procedure TPopup_Fitparameters.fA3_fitClick(Sender: TObject);
begin
    if fA3_fit.checked then tfA[3].fit:=1 else tfA[3].fit:=0;
    end;

procedure TPopup_Fitparameters.fA4_fitClick(Sender: TObject);
begin
    if fA4_fit.checked then tfA[4].fit:=1 else tfA[4].fit:=0;
    end;

procedure TPopup_Fitparameters.fA5_fitClick(Sender: TObject);
begin
    if fA5_fit.checked then tfA[5].fit:=1 else tfA[5].fit:=0;
    end;


procedure TPopup_Fitparameters.fA0_0Change(Sender: TObject);
begin
    val(fA0_0.Text, input, error);
    if error=0 then tfA[0].actual:=input;
    if tfA[0].actual<tfA[0].min then tfA[0].actual:=tfA[0].min;
    end;

procedure TPopup_Fitparameters.fA1_0Change(Sender: TObject);
begin
    val(fA1_0.Text, input, error);
    if error=0 then tfA[1].actual:=input;
    if tfA[1].actual<tfA[1].min then tfA[1].actual:=tfA[1].min;
    end;

procedure TPopup_Fitparameters.fA2_0Change(Sender: TObject);
begin
    val(fA2_0.Text, input, error);
    if error=0 then tfA[2].actual:=input;
    if tfA[2].actual<tfA[2].min then tfA[2].actual:=tfA[2].min;
    end;

procedure TPopup_Fitparameters.fA3_0Change(Sender: TObject);
begin
    val(fA3_0.Text, input, error);
    if error=0 then tfA[3].actual:=input;
    if tfA[3].actual<tfA[3].min then tfA[3].actual:=tfA[3].min;
    end;

procedure TPopup_Fitparameters.fA4_0Change(Sender: TObject);
begin
    val(fA4_0.Text, input, error);
    if error=0 then tfA[4].actual:=input;
    if tfA[4].actual<tfA[4].min then tfA[4].actual:=tfA[4].min;
    end;

procedure TPopup_Fitparameters.fA5_0Change(Sender: TObject);
begin
    val(fA5_0.Text, input, error);
    if error=0 then tfA[5].actual:=input;
    if tfA[5].actual<tfA[5].min then tfA[5].actual:=tfA[5].min;
    end;

procedure TPopup_Fitparameters.zB_minChange(Sender: TObject);
begin
    val(zB_min.Text, input, error);
    if error=0 then tzB.min:=input;
    if tzB.min>tzB.max then tzB.min:=tzB.max;
    end;

procedure TPopup_Fitparameters.fA0_minChange(Sender: TObject);
begin
    val(fA0_min.Text, input, error);
    if error=0 then tfA[0].min:=input;
    if tfA[0].min>tfA[0].max then tfA[0].min:=tfA[0].max;
    end;

procedure TPopup_Fitparameters.fA1_minChange(Sender: TObject);
begin
    val(fA1_min.Text, input, error);
    if error=0 then tfA[1].min:=input;
    if tfA[1].min>tfA[1].max then tfA[1].min:=tfA[1].max;
    end;

procedure TPopup_Fitparameters.fA2_minChange(Sender: TObject);
begin
    val(fA2_min.Text, input, error);
    if error=0 then tfA[2].min:=input;
    if tfA[2].min>tfA[2].max then tfA[2].min:=tfA[2].max;
    end;

procedure TPopup_Fitparameters.fA3_minChange(Sender: TObject);
begin
    val(fA3_min.Text, input, error);
    if error=0 then tfA[3].min:=input;
    if tfA[3].min>tfA[3].max then tfA[3].min:=tfA[3].max;
    end;

procedure TPopup_Fitparameters.fA4_minChange(Sender: TObject);
begin
    val(fA4_min.Text, input, error);
    if error=0 then tfA[4].min:=input;
    if tfA[4].min>tfA[4].max then tfA[4].min:=tfA[4].max;
    end;

procedure TPopup_Fitparameters.fA5_minChange(Sender: TObject);
begin
    val(fA5_min.Text, input, error);
    if error=0 then tfA[5].min:=input;
    if tfA[5].min>tfA[5].max then tfA[5].min:=tfA[5].max;
    end;

procedure TPopup_Fitparameters.zB_maxChange(Sender: TObject);
begin
    val(zB_max.Text, input, error);
    if error=0 then tzB.max:=input;
    if tzB.max<tzB.min then tzB.max:=tzB.min;
    end;

procedure TPopup_Fitparameters.fA0_maxChange(Sender: TObject);
begin
    val(fA0_max.Text, input, error);
    if error=0 then tfA[0].max:=input;
    if tfA[0].max<tfA[0].min then tfA[0].max:=tfA[0].min;
    end;

procedure TPopup_Fitparameters.fA1_maxChange(Sender: TObject);
begin
    val(fA1_max.Text, input, error);
    if error=0 then tfA[1].max:=input;
    if tfA[1].max<tfA[1].min then tfA[1].max:=tfA[1].min;
    end;

procedure TPopup_Fitparameters.fA2_maxChange(Sender: TObject);
begin
    val(fA2_max.Text, input, error);
    if error=0 then tfA[2].max:=input;
    if tfA[2].max<tfA[2].min then tfA[2].max:=tfA[2].min;
    end;

procedure TPopup_Fitparameters.fA3_maxChange(Sender: TObject);
begin
    val(fA3_max.Text, input, error);
    if error=0 then tfA[3].max:=input;
    if tfA[3].max<tfA[3].min then tfA[3].max:=tfA[3].min;
    end;

procedure TPopup_Fitparameters.fA4_maxChange(Sender: TObject);
begin
    val(fA4_max.Text, input, error);
    if error=0 then tfA[4].max:=input;
    if tfA[4].max<tfA[4].min then tfA[4].max:=tfA[4].min;
    end;

procedure TPopup_Fitparameters.fA5_maxChange(Sender: TObject);
begin
    val(fA5_max.Text, input, error);
    if error=0 then tfA[5].max:=input;
    if tfA[5].max<tfA[5].min then tfA[5].max:=tfA[5].min;
    end;

procedure TPopup_Fitparameters.Button_Default_GroundClick(Sender: TObject);
var i : integer;
begin
    for i:=0 to 5 do tfA[i].actual:=fA[i].default;
    update_parameterlist(Sender);
    end;

procedure TPopup_Fitparameters.fluo_fitClick(Sender: TObject);
begin
    if fluo_fit.checked then tfluo.fit:=1 else tfluo.fit:=0;
    end;

procedure TPopup_Fitparameters.fluo_0Change(Sender: TObject);
begin
    val(fluo_0.Text, input, error);
    if error=0 then tfluo.actual:=input;
    if tfluo.actual<tfluo.min then tfluo.actual:=tfluo.min;
    end;

procedure TPopup_Fitparameters.fluo_minChange(Sender: TObject);
begin
    val(fluo_min.Text, input, error);
    if error=0 then tfluo.min:=input;
    if tfluo.min>tfluo.max then tfluo.min:=tfluo.max;
    end;

procedure TPopup_Fitparameters.fluo_maxChange(Sender: TObject);
begin
    val(fluo_max.Text, input, error);
    if error=0 then tfluo.max:=input;
    if tfluo.max<tfluo.min then tfluo.max:=tfluo.min;
    end;

procedure TPopup_Fitparameters.test_fitClick(Sender: TObject);
begin
    if test_fit.checked then ttest.fit:=1 else ttest.fit:=0;
    end;

procedure TPopup_Fitparameters.test_0Change(Sender: TObject);
begin
    val(test_0.Text, input, error);
    if error=0 then ttest.actual:=input;
    if ttest.actual<ttest.min then ttest.actual:=ttest.min;
    end;

procedure TPopup_Fitparameters.test_minChange(Sender: TObject);
begin
    val(test_min.Text, input, error);
    if error=0 then ttest.min:=input;
    if ttest.min>ttest.max then ttest.min:=ttest.max;
    end;

procedure TPopup_Fitparameters.test_maxChange(Sender: TObject);
begin
    val(test_max.Text, input, error);
    if error=0 then ttest.max:=input;
    if ttest.max<ttest.min then ttest.max:=ttest.min;
    end;

procedure TPopup_Fitparameters.sun_fitClick(Sender: TObject);
begin
    if sun_fit.checked then tsun.fit:=1 else tsun.fit:=0;
    end;

procedure TPopup_Fitparameters.sun_0Change(Sender: TObject);
begin
    val(sun_0.Text, input, error);
    if error=0 then tsun.actual:=input;
    if tsun.actual<tsun.min then tsun.actual:=tsun.min;
    end;

procedure TPopup_Fitparameters.sun_minChange(Sender: TObject);
begin
    val(sun_min.Text, input, error);
    if error=0 then tsun.min:=input;
    if tsun.min>tsun.max then tsun.min:=tsun.max;
    end;

procedure TPopup_Fitparameters.sun_maxChange(Sender: TObject);
begin
    val(sun_max.Text, input, error);
    if error=0 then tsun.max:=input;
    if tsun.max<tsun.min then tsun.max:=tsun.min;
    end;

procedure TPopup_Fitparameters.f_dd_fitClick(Sender: TObject);
begin
    if f_dd_fit.checked then tf_dd.fit:=1 else tf_dd.fit:=0;
    end;

procedure TPopup_Fitparameters.f_dd_0Change(Sender: TObject);
begin
    val(f_dd_0.Text, input, error);
    if error=0 then tf_dd.actual:=input;
    if tf_dd.actual<tf_dd.min then tf_dd.actual:=tf_dd.min;
    end;

procedure TPopup_Fitparameters.f_dd_minChange(Sender: TObject);
begin
    val(f_dd_min.Text, input, error);
    if error=0 then tf_dd.min:=input;
    if tf_dd.min>tf_dd.max then tf_dd.min:=tf_dd.max;
    end;

procedure TPopup_Fitparameters.f_dd_maxChange(Sender: TObject);
begin
    val(f_dd_max.Text, input, error);
    if error=0 then tf_dd.max:=input;
    if tf_dd.max<tf_dd.min then tf_dd.max:=tf_dd.min;
    end;

procedure TPopup_Fitparameters.f_ds_fitClick(Sender: TObject);
begin
    if f_ds_fit.checked then tf_ds.fit:=1 else tf_ds.fit:=0;
    end;

procedure TPopup_Fitparameters.f_ds_0Change(Sender: TObject);
begin
    val(f_ds_0.Text, input, error);
    if error=0 then tf_ds.actual:=input;
    if tf_ds.actual<tf_ds.min then tf_ds.actual:=tf_ds.min;
    end;

procedure TPopup_Fitparameters.f_ds_minChange(Sender: TObject);
begin
    val(f_ds_min.Text, input, error);
    if error=0 then tf_ds.min:=input;
    if tf_ds.min>tf_ds.max then tf_ds.min:=tf_ds.max;
    end;

procedure TPopup_Fitparameters.f_ds_maxChange(Sender: TObject);
begin
    val(f_ds_max.Text, input, error);
    if error=0 then tf_ds.max:=input;
    if tf_ds.max<tf_ds.min then tf_ds.max:=tf_ds.min;
    end;

procedure TPopup_Fitparameters.H_oz_fitClick(Sender: TObject);
begin
    if H_oz_fit.checked then tH_oz.fit:=1 else tH_oz.fit:=0;
    end;

procedure TPopup_Fitparameters.H_oz_0Change(Sender: TObject);
begin
    val(H_oz_0.Text, input, error);
    if error=0 then tH_oz.actual:=input;
    if tH_oz.actual<tH_oz.min then tH_oz.actual:=tH_oz.min;
    end;

procedure TPopup_Fitparameters.H_oz_minChange(Sender: TObject);
begin
    val(H_oz_min.Text, input, error);
    if error=0 then tH_oz.min:=input;
    if tH_oz.min>tH_oz.max then tH_oz.min:=tH_oz.max;
    end;

procedure TPopup_Fitparameters.H_oz_maxChange(Sender: TObject);
begin
    val(H_oz_max.Text, input, error);
    if error=0 then tH_oz.max:=input;
    if tH_oz.max<tH_oz.min then tH_oz.max:=tH_oz.min;
    end;

procedure TPopup_Fitparameters.WV_fitClick(Sender: TObject);
begin
    if WV_fit.checked then tWV.fit:=1 else tWV.fit:=0;
    end;

procedure TPopup_Fitparameters.WV_0Change(Sender: TObject);
begin
    val(WV_0.Text, input, error);
    if error=0 then tWV.actual:=input;
    if tWV.actual<tWV.min then tWV.actual:=tWV.min;
    end;

procedure TPopup_Fitparameters.WV_minChange(Sender: TObject);
begin
    val(WV_min.Text, input, error);
    if error=0 then tWV.min:=input;
    if tWV.min>tWV.max then tWV.min:=tWV.max;
    end;

procedure TPopup_Fitparameters.WV_maxChange(Sender: TObject);
begin
    val(WV_max.Text, input, error);
    if error=0 then tWV.max:=input;
    if tWV.max<tWV.min then tWV.max:=tWV.min;
    end;

procedure TPopup_Fitparameters.beta_fitClick(Sender: TObject);
begin
    if beta_fit.checked then tbeta.fit:=1 else tbeta.fit:=0;
    end;

procedure TPopup_Fitparameters.beta_0Change(Sender: TObject);
begin
    val(beta_0.Text, input, error);
    if error=0 then tbeta.actual:=input;
    if tbeta.actual<tbeta.min then tbeta.actual:=tbeta.min;
    end;

procedure TPopup_Fitparameters.beta_minChange(Sender: TObject);
begin
    val(beta_min.Text, input, error);
    if error=0 then tbeta.min:=input;
    if tbeta.min>tbeta.max then tbeta.min:=tbeta.max;
    end;

procedure TPopup_Fitparameters.beta_maxChange(Sender: TObject);
begin
    val(beta_max.Text, input, error);
    if error=0 then tbeta.max:=input;
    if tbeta.max<tbeta.min then tbeta.max:=tbeta.min;
    end;

procedure TPopup_Fitparameters.z_fitClick(Sender: TObject);
begin
    if z_fit.checked then tz.fit:=1 else tz.fit:=0;
    end;

procedure TPopup_Fitparameters.z_0Change(Sender: TObject);
begin
    val(z_0.Text, input, error);
    if error=0 then tz.actual:=input;
    if tz.actual<tz.min then tz.actual:=tz.min;
    end;

procedure TPopup_Fitparameters.z_minChange(Sender: TObject);
begin
    val(z_min.Text, input, error);
    if error=0 then tz.min:=input;
    if tz.min>z.max then tz.min:=tz.max;
    end;

procedure TPopup_Fitparameters.z_maxChange(Sender: TObject);
begin
    val(z_max.Text, input, error);
    if error=0 then tz.max:=input;
    if tz.max<tz.min then tz.max:=tz.min;
    end;

procedure TPopup_Fitparameters.Button_Default_IlluminationClick(Sender: TObject);
begin
    tf_dd.actual:=tf_dd.default;
    tf_ds.actual:=tf_ds.default;
    tH_oz.actual:=tH_oz.default;
    tWV.actual:=tWV.default;
    tbeta.actual:=tbeta.default;
    talpha.actual:=talpha.default;
    update_parameterlist(Sender);
    end;

procedure TPopup_Fitparameters.view_fitClick(Sender: TObject);
begin
    if view_fit.checked then tview.fit:=1 else tview.fit:=0;
    end;

procedure TPopup_Fitparameters.view_0Change(Sender: TObject);
begin
    val(view_0.Text, input, error);
    if error=0 then tview.actual:=input;
    if tview.actual<tview.min then tview.actual:=tview.min;
    end;

procedure TPopup_Fitparameters.view_minChange(Sender: TObject);
begin
    val(view_min.Text, input, error);
    if error=0 then tview.min:=input;
    if tview.min>tview.max then tview.min:=tview.max;
    end;

procedure TPopup_Fitparameters.view_maxChange(Sender: TObject);
begin
    val(view_max.Text, input, error);
    if error=0 then tview.max:=input;
    if tview.max<tview.min then tview.max:=tview.min;
    end;

procedure TPopup_Fitparameters.Button_Default_GeometryClick(
  Sender: TObject);
begin
    tsun.actual:=tsun.default;
    tview.actual:=tview.default;
    tz.actual:=tz.default;
    tzB.actual:=tzB.default;
    tf.actual:=tf.default;       
    tQ.actual:=tQ.default;
    update_parameterlist(Sender); 
    end;

procedure TPopup_Fitparameters.C_D_fitClick(Sender: TObject);
begin
    if C_D_fit.checked then tC_NAP.fit:=1 else tC_NAP.fit:=0;
    end;

procedure TPopup_Fitparameters.C_D_0Change(Sender: TObject);
begin
    val(C_D_0.Text, input, error);
    if error=0 then tC_NAP.actual:=input;
    if tC_NAP.actual<tC_NAP.min then tC_NAP.actual:=tC_NAP.min;
    end;

procedure TPopup_Fitparameters.C_D_minChange(Sender: TObject);
begin
    val(C_D_min.Text, input, error);
    if error=0 then tC_NAP.min:=input;
    if tC_NAP.min>tC_NAP.max then tC_NAP.min:=tC_NAP.max;
    end;



procedure TPopup_Fitparameters.C_D_maxChange(Sender: TObject);
begin
    val(C_D_max.Text, input, error);
    if error=0 then tC_NAP.max:=input;
    if tC_NAP.max<tC_NAP.min then tC_NAP.max:=tC_NAP.min;
    end;

procedure TPopup_Fitparameters.rho_ds_fitClick(Sender: TObject);
begin
    if rho_ds_fit.checked then trho_ds.fit:=1 else trho_ds.fit:=0;
    end;

procedure TPopup_Fitparameters.rho_ds_0Change(Sender: TObject);
begin
    val(rho_ds_0.Text, input, error);
    if error=0 then trho_ds.actual:=input;
    if trho_ds.actual<tdelta_r.min then tdelta_r.actual:=tdelta_r.min;
    end;

procedure TPopup_Fitparameters.rho_ds_minChange(Sender: TObject);
begin
    val(rho_ds_min.Text, input, error);
    if error=0 then trho_ds.min:=input;
    if trho_ds.min>trho_ds.max then trho_ds.min:=trho_ds.max;
    end;

procedure TPopup_Fitparameters.rho_ds_maxChange(Sender: TObject);
begin
    val(rho_ds_max.Text, input, error);
    if error=0 then trho_ds.max:=input;
    if trho_ds.max<trho_ds.min then trho_ds.max:=trho_ds.min;
    end;

procedure TPopup_Fitparameters.rho_L_fitClick(Sender: TObject);
begin
    if rho_L_fit.checked then trho_L.fit:=1 else trho_L.fit:=0;
    end;

procedure TPopup_Fitparameters.rho_L_0Change(Sender: TObject);
begin
    val(rho_L_0.Text, input, error);
    if error=0 then trho_L.actual:=input;
    if trho_L.actual<trho_L.min then trho_L.actual:=trho_L.min;
    end;


procedure TPopup_Fitparameters.rho_L_minChange(Sender: TObject);
begin
    val(rho_L_min.Text, input, error);
    if error=0 then trho_L.min:=input;
    if trho_L.min>trho_L.max then trho_L.min:=trho_L.max;
    end;

procedure TPopup_Fitparameters.rho_L_maxChange(Sender: TObject);
begin
    val(rho_L_max.Text, input, error);
    if error=0 then trho_L.max:=input;
    if trho_L.max<trho_L.min then trho_L.max:=trho_L.min;
    end;

procedure TPopup_Fitparameters.g_dd_fitClick(Sender: TObject);
begin
    if g_dd_fit.checked then tg_dd.fit:=1 else tg_dd.fit:=0;
    end;

procedure TPopup_Fitparameters.g_dd_0Change(Sender: TObject);
begin
    val(g_dd_0.Text, input, error);
    if error=0 then tg_dd.actual:=input;
    if tg_dd.actual<tg_dd.min then tg_dd.actual:=tg_dd.min;
    end;

procedure TPopup_Fitparameters.g_dd_minChange(Sender: TObject);
begin
    val(g_dd_min.Text, input, error);
    if error=0 then tg_dd.min:=input;
    if tg_dd.min>tg_dd.max then tg_dd.min:=tg_dd.max;
    end;

procedure TPopup_Fitparameters.g_dd_maxChange(Sender: TObject);
begin
    val(g_dd_max.Text, input, error);
    if error=0 then tg_dd.max:=input;
    if tg_dd.max<tg_dd.min then tg_dd.max:=tg_dd.min;
    end;

procedure TPopup_Fitparameters.g_dsr_fitClick(Sender: TObject);
begin
    if g_dsr_fit.checked then tg_dsr.fit:=1 else tg_dsr.fit:=0;
    end;

procedure TPopup_Fitparameters.g_dsr_0Change(Sender: TObject);
begin
    val(g_dsr_0.Text, input, error);
    if error=0 then tg_dsr.actual:=input;
    if tg_dsr.actual<tg_dsr.min then tg_dsr.actual:=tg_dsr.min;
    end;

procedure TPopup_Fitparameters.g_dsr_minChange(Sender: TObject);
begin
    val(g_dsr_min.Text, input, error);
    if error=0 then tg_dsr.min:=input;
    if tg_dsr.min>tg_dsr.max then tg_dsr.min:=tg_dsr.max;
    end;

procedure TPopup_Fitparameters.g_dsr_maxChange(Sender: TObject);
begin
    val(g_dsr_max.Text, input, error);
    if error=0 then tg_dsr.max:=input;
    if tg_dsr.max<tg_dsr.min then tg_dsr.max:=tg_dsr.min;
    end;

procedure TPopup_Fitparameters.g_dsa_fitClick(Sender: TObject);
begin
    if g_dsa_fit.checked then tg_dsa.fit:=1 else tg_dsa.fit:=0;
    end;

procedure TPopup_Fitparameters.g_dsa_0Change(Sender: TObject);
begin
    val(g_dsa_0.Text, input, error);
    if error=0 then tg_dsa.actual:=input;
    if tg_dsa.actual<tg_dsa.min then tg_dsa.actual:=tg_dsa.min;
    end;

procedure TPopup_Fitparameters.g_dsa_minChange(Sender: TObject);
begin
    val(g_dsa_min.Text, input, error);
    if error=0 then tg_dsa.min:=input;
    if tg_dsa.min>tg_dsa.max then tg_dsa.min:=tg_dsa.max;
    end;

procedure TPopup_Fitparameters.g_dsa_maxChange(Sender: TObject);
begin
    val(g_dsa_max.Text, input, error);
    if error=0 then tg_dsa.max:=input;
    if tg_dsa.max<tg_dsa.min then tg_dsa.max:=tg_dsa.min;
    end;

end.
