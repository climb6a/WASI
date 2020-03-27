unit Frame_par;

{$MODE Delphi}

{ Version vom 31.1.2020 }

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, defaults, misc, fw_calc, ExtCtrls;

procedure Active_Ed_GC;
procedure Active_Lup;
procedure Active_R;
procedure Active_Rrs;
procedure Active_R_surf;
procedure Active_R_surf_Gege;
procedure Active_a;
procedure Active_K;
procedure Active_Rbottom;
procedure Active_all;

type

  { TFrame_p }

  TFrame_p = class(TFrame)
    Cp_fit: TCheckBox;
    CP_0: TEdit;
    C1_fit: TCheckBox;
    C1_0: TEdit;
    C2_fit: TCheckBox;
    C2_0: TEdit;
    C3_fit: TCheckBox;
    C3_0: TEdit;
    C4_fit: TCheckBox;
    C4_0: TEdit;
    C5_fit: TCheckBox;
    C5_0: TEdit;
    CY_fit: TCheckBox;
    CY_0: TEdit;
    PanelGray1: TPanel;
    S_fit: TCheckBox;
    S_0: TEdit;
    CL_fit: TCheckBox;
    CL_0: TEdit;
    CMie_fit: TCheckBox;
    CMie_0: TEdit;
    TW_fit: TCheckBox;
    TW_0: TEdit;
    g_dd_fit: TCheckBox;
    g_dd_0: TEdit;
    g_dsr_fit: TCheckBox;
    g_dsr_0: TEdit;
    g_dsa_fit: TCheckBox;
    g_dsa_0: TEdit;
    delta_r_fit: TCheckBox;
    delta_r_0: TEdit;
    alpha_fit: TCheckBox;
    alpha_0: TEdit;
    Q_0: TEdit;
    rho_dd_fit: TCheckBox;
    rho_dd_0: TEdit;
    n_fit: TCheckBox;
    n_0: TEdit;
    StaticText2: TStaticText;
    Q_fit: TCheckBox;
    alpha_d_fit: TCheckBox;
    alpha_d_0: TEdit;
    beta_d_fit: TCheckBox;
    beta_d_0: TEdit;
    gamma_d_fit: TCheckBox;
    gamma_d_0: TEdit;
    delta_d_fit: TCheckBox;
    delta_d_0: TEdit;
    PanelGray: TPanel;
    f_fit: TCheckBox;
    f_0: TEdit;
    bbs_phy_0: TEdit;
    bbs_phy1: TCheckBox;
    z_fit: TCheckBox;
    z_0: TEdit;
    zB_fit: TCheckBox;
    zB_0: TEdit;
    sun_fit: TCheckBox;
    sun_0: TEdit;
    view_fit: TCheckBox;
    view_0: TEdit;
    dphi_fit: TCheckBox;
    dphi_0: TEdit;
    fa0_fit: TCheckBox;
    fa1_fit: TCheckBox;
    fa2_fit: TCheckBox;
    fa3_fit: TCheckBox;
    fa4_fit: TCheckBox;
    fa5_fit: TCheckBox;
    fa0_0: TEdit;
    fa1_0: TEdit;
    fa2_0: TEdit;
    fa3_0: TEdit;
    fa4_0: TEdit;
    fa5_0: TEdit;
    PanelGray2: TPanel;
    StaticText1: TStaticText;
    beta_fit: TCheckBox;
    beta_0: TEdit;
    f_dd_fit: TCheckBox;
    f_dd_0: TEdit;
    f_ds_fit: TCheckBox;
    f_ds_0: TEdit;
    H_oz_0: TEdit;
    H_oz_fit: TCheckBox;
    WV_fit: TCheckBox;
    WV_0: TEdit;
    fluo_fit: TCheckBox;
    fluo_0: TEdit;
    rho_ds_fit: TCheckBox;
    rho_ds_0: TEdit;
    dummy_fit: TCheckBox;
    dummy_0: TEdit;
    rho_L_fit: TCheckBox;
    rho_L_0: TEdit;
    test_fit: TCheckBox;
    test_0: TEdit;
    f_nw_fit: TCheckBox;
    f_nw_0: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure sun_fitChange(Sender: TObject);
    procedure updte(Sender: TObject);
    procedure Parameter_enable(Sender: TObject);
    procedure update_actual(Sender: TObject);
    procedure update_fw(Sender: TObject);
    procedure handle_private(Sender: TObject);
    procedure show_Gege(Sender: TObject);
    procedure hide_Gege(Sender: TObject);
    procedure CP_0Change(Sender: TObject);
    procedure C1_0Change(Sender: TObject);
    procedure C2_0Change(Sender: TObject);
    procedure C3_0Change(Sender: TObject);
    procedure C4_0Change(Sender: TObject);
    procedure C5_0Change(Sender: TObject);
    procedure CL_0Change(Sender: TObject);
    procedure CMie_0Change(Sender: TObject);
    procedure CY_0Change(Sender: TObject);
    procedure S_0Change(Sender: TObject);
    procedure TW_0Change(Sender: TObject);
    procedure g_dd_0Change(Sender: TObject);
    procedure g_dsr_0Change(Sender: TObject);
    procedure g_dsa_0Change(Sender: TObject);
    procedure delta_r_0Change(Sender: TObject);
    procedure alpha_0Change(Sender: TObject);
    procedure n_0Change(Sender: TObject);
    procedure Q_0Change(Sender: TObject);
    procedure rho_dd_0Change(Sender: TObject);
    procedure Cp_fitClick(Sender: TObject);
    procedure C1_fitClick(Sender: TObject);
    procedure C2_fitClick(Sender: TObject);
    procedure C3_fitClick(Sender: TObject);
    procedure C4_fitClick(Sender: TObject);
    procedure C5_fitClick(Sender: TObject);
    procedure CL_fitClick(Sender: TObject);
    procedure CMie_fitClick(Sender: TObject);
    procedure CY_fitClick(Sender: TObject);
    procedure S_fitClick(Sender: TObject);
    procedure TW_fitClick(Sender: TObject);
    procedure alpha_d_fitClick(Sender: TObject);
    procedure delta_d_fitClick(Sender: TObject);
    procedure beta_d_fitClick(Sender: TObject);
    procedure gamma_d_fitClick(Sender: TObject);
    procedure alpha_fitClick(Sender: TObject);
    procedure Q_fitClick(Sender: TObject);
    procedure rho_dd_fitClick(Sender: TObject);
    procedure alpha_d_0Change(Sender: TObject);
    procedure beta_d_0Change(Sender: TObject);
    procedure gamma_d_0Change(Sender: TObject);
    procedure delta_d_0Change(Sender: TObject);
    procedure g_dd_fitClick(Sender: TObject);
    procedure g_dsr_fitClick(Sender: TObject);
    procedure g_dsa_fitClick(Sender: TObject);
    procedure delta_r_fitClick(Sender: TObject);
    procedure n_fitClick(Sender: TObject);
    procedure f_0Change(Sender: TObject);
    procedure view_fitChange(Sender: TObject);
    procedure z_0Change(Sender: TObject);
    procedure zB_0Change(Sender: TObject);
    procedure sun_0Change(Sender: TObject);
    procedure fa0_0Change(Sender: TObject);
    procedure fa1_0Change(Sender: TObject);
    procedure fa2_0Change(Sender: TObject);
    procedure fa3_0Change(Sender: TObject);
    procedure fa4_0Change(Sender: TObject);
    procedure fa5_0Change(Sender: TObject);
    procedure f_fitClick(Sender: TObject);
    procedure z_fitClick(Sender: TObject);
    procedure zB_fitClick(Sender: TObject);
    procedure sun_fitClick(Sender: TObject);
    procedure view_fitClick(Sender: TObject);
    procedure dphi_fitClick(Sender: TObject);
    procedure bbs_phyClick(Sender: TObject);
    procedure fa0_fitClick(Sender: TObject);
    procedure fa1_fitClick(Sender: TObject);
    procedure fa2_fitClick(Sender: TObject);
    procedure fa3_fitClick(Sender: TObject);
    procedure fa4_fitClick(Sender: TObject);
    procedure fa5_fitClick(Sender: TObject);
    procedure view_0Change(Sender: TObject);
    procedure dphi_0Change(Sender: TObject);
    procedure bbs_phy_0Change(Sender: TObject);
    procedure f_dd_fitClick(Sender: TObject);
    procedure f_ds_fitClick(Sender: TObject);
    procedure H_oz_fitClick(Sender: TObject);
    procedure beta_fitClick(Sender: TObject);
    procedure WV_fitClick(Sender: TObject);
    procedure f_dd_0Change(Sender: TObject);
    procedure f_ds_0Change(Sender: TObject);
    procedure H_oz_0Change(Sender: TObject);
    procedure beta_0Change(Sender: TObject);
    procedure WV_0Change(Sender: TObject);
    procedure fluo_fitClick(Sender: TObject);
    procedure fluo_0Change(Sender: TObject);
    procedure rho_L_fitClick(Sender: TObject);
    procedure dummy_fitClick(Sender: TObject);
    procedure rho_ds_fitClick(Sender: TObject);
    procedure rho_L_0Change(Sender: TObject);
    procedure dummy_0Change(Sender: TObject);
    procedure rho_ds_0Change(Sender: TObject);
    procedure test_fitClick(Sender: TObject);
    procedure test_0Change(Sender: TObject);
    procedure FrameEnter(Sender: TObject);
    procedure f_nw_fitClick(Sender: TObject);
    procedure f_nw_0Change(Sender: TObject);
  private
  public
  end;


implementation
uses privates, meltpond;

{$R *.lfm}

procedure Active_Ed_GC;
{ Activate / deactivate parameters of downwelling irradiance (model of Gregg & Carder). }
var i : integer;
begin
    for i:=0 to 5 do C[i].active:=not flag_above;
    C_X.active       :=(not flag_CXisC0) and not flag_above;
    C_Mie.active     :=not flag_above;
    bbs_phy.active   :=not flag_above;
    C_Y.active       :=not flag_above;
    S.active         :=not flag_above and flag_Y_exp;
    n.active         :=not flag_above;
    T_W.active       :=not flag_above;
    Q.active         :=FALSE;
    rho_dd.active    :=not flag_above and not flag_Fresnel_sun;
    rho_ds.active    :=not flag_above and not flag_calc_rho_ds;
    rho_L.active     :=FALSE;
    f_dd.active      :=model_Ed=1;
    f_ds.active      :=model_Ed=1;
    H_oz.active      :=TRUE;
    WV.active        :=TRUE;
    alpha.active     :=TRUE;
    beta.active      :=TRUE;
    f.active         :=(model_f=0) and not flag_above;
    z.active         :=not flag_above;
    zB.active        :=(not flag_above) and flag_shallow;
    sun.active       :=TRUE;
    view.active      :=not flag_above and Flag_fresnel_view;
    dphi.active      :=FALSE;
    f_nw.active      :=FALSE;
    for i:=0 to 5 do fA[i].active:=(not flag_above) and flag_shallow;
    fluo.active      :=FALSE;
    alpha_d.active   :=FALSE;
    beta_d.active    :=FALSE;
    gamma_d.active   :=FALSE;
    delta_d.active   :=FALSE;
    g_dd.active      :=FALSE;
    g_dsr.active     :=FALSE;
    g_dsa.active     :=FALSE;
    alpha_r.active   :=FALSE;
    beta_r.active    :=FALSE;
    gamma_r.active   :=FALSE;
    delta_r.active   :=FALSE;
    dummy.active     :=flag_Ed_Gege;
    test.active      :=not flag_above;
    end;

procedure Active_Lup;
{ Activate / deactivate parameters of upwelling radiance. }
var i : integer;
begin
    for i:=0 to 5 do C[i].active:=TRUE;
    C_X.active       :=not flag_CXisC0;
    C_Mie.active     :=TRUE;
    bbs_phy.active   :=TRUE;
    C_Y.active       :=TRUE;
    S.active         :=flag_Y_exp;
    n.active         :=TRUE;
    T_W.active       :=TRUE; //not flag_2D_inv;
    Q.active         :=TRUE;
    rho_L.active     :=flag_above and not Flag_fresnel_view;
    rho_dd.active    :=not flag_above and not flag_Fresnel_sun;
    rho_ds.active    :=not flag_above and not flag_calc_rho_ds;
    f_dd.active      :=model_Ed=1;
    f_ds.active      :=model_Ed=1;
    H_oz.active      :=TRUE;
    WV.active        :=TRUE;
    alpha.active     :=TRUE;
    beta.active      :=TRUE;
    f.active         :=(model_f=0);
    z.active         :=not flag_above;
    zB.active        :=flag_shallow;
    sun.active       :=TRUE;
    view.active      :=not flag_2D_inv;
    dphi.active      :=FALSE;
    f_nw.active      :=flag_above;
    for i:=0 to 5 do fA[i].active:=flag_shallow;
    fluo.active      :=flag_fluo;
    alpha_d.active   :=FALSE;
    beta_d.active    :=FALSE;
    gamma_d.active   :=FALSE;
    delta_d.active   :=FALSE;
    g_dd.active      :=flag_above and (((flag_b_invert and flag_surf_inv)
                       or (not flag_b_invert and flag_surf_fw)));
    g_dsr.active     :=flag_above and (((flag_b_invert and flag_surf_inv)
                       or (not flag_b_invert and flag_surf_fw)));
    g_dsa.active     :=flag_above and (((flag_b_invert and flag_surf_inv)
                       or (not flag_b_invert and flag_surf_fw)));
    alpha_r.active   :=FALSE;
    beta_r.active    :=FALSE;
    gamma_r.active   :=FALSE;
    delta_r.active   :=FALSE;
    dummy.active     :=flag_Ed_Gege;
    test.active      :=TRUE;
    end;

procedure Active_R;
{ Activate / deactivate parameters of irradiance reflectance. }
var i : integer;
begin
    for i:=0 to 5 do C[i].active:=TRUE;
    C_X.active       :=not flag_CXisC0;
    C_Mie.active     :=TRUE;
    bbs_phy.active   :=TRUE;
    C_Y.active       :=TRUE;
    S.active         :=flag_Y_exp;
    n.active         :=TRUE;
    T_W.active       :=TRUE; //not flag_2D_inv;
    Q.active         :=TRUE;
    rho_L.active     :=flag_above and not Flag_fresnel_view;
    rho_dd.active    :=not flag_above and not flag_Fresnel_sun;
    rho_ds.active    :=not flag_above and not flag_calc_rho_ds;
    f_dd.active      :=FALSE;
    f_ds.active      :=FALSE;
    H_oz.active      :=FALSE;
    WV.active        :=FALSE;
    alpha.active     :=FALSE;
    beta.active      :=FALSE;
    f.active         :=(model_f=0);
    z.active         :=FALSE;
    zB.active        :=flag_shallow;
    sun.active       :=TRUE;
    view.active      :=FALSE;
    dphi.active      :=FALSE;
    f_nw.active      :=flag_above;
    for i:=0 to 5 do fA[i].active:=flag_shallow;
    fluo.active      :=flag_fluo;
    alpha_d.active   :=FALSE;
    beta_d.active    :=FALSE;
    gamma_d.active   :=FALSE;
    delta_d.active   :=FALSE;
    g_dd.active      :=FALSE;
    g_dsr.active     :=FALSE;
    g_dsa.active     :=FALSE;
    alpha_r.active   :=FALSE;
    beta_r.active    :=FALSE;
    gamma_r.active   :=FALSE;
    delta_r.active   :=FALSE;
    dummy.active     :=FALSE;
    test.active      :=TRUE;
    end;

procedure Active_Rrs;
{ Activate / deactivate parameters of remote sensing reflectance. }
var i : integer;
begin
    for i:=0 to 5 do C[i].active:=TRUE;
    C_X.active       :=not flag_CXisC0;
    C_Mie.active     :=TRUE;
    bbs_phy.active   :=TRUE;
    C_Y.active       :=TRUE;
    S.active         :=flag_Y_exp;
    n.active         :=TRUE;
    T_W.active       :=TRUE; // not flag_2D_inv;
    Q.active         :=TRUE;
    rho_L.active     :=flag_above and not Flag_fresnel_view;
    rho_dd.active    :=(flag_above and not flag_Fresnel_sun) or flag_fluo;
    rho_ds.active    :=(flag_above and not flag_calc_rho_ds) or flag_fluo;
    f_dd.active      :=(flag_above and (model_Ed=1)) or flag_fluo;
    f_ds.active      :=(flag_above and (model_Ed=1)) or flag_fluo;
    H_oz.active      :=flag_above or flag_fluo;
    WV.active        :=flag_above or flag_fluo;
    alpha.active     :=flag_above or flag_fluo;
    beta.active      :=flag_above or flag_fluo;
    f.active         :=(model_f=0);
    z.active         :=not flag_above;;
    zB.active        :=flag_shallow;
    sun.active       :=TRUE;
    view.active      :=not flag_2D_inv;
    dphi.active      :=FALSE;
    f_nw.active      :=flag_above;
    for i:=0 to 5 do fA[i].active:=flag_shallow;
    fluo.active      :=flag_fluo;
    alpha_d.active   :=FALSE;
    beta_d.active    :=FALSE;
    gamma_d.active   :=FALSE;
    delta_d.active   :=FALSE;
    g_dd.active      :=flag_above and (((flag_b_invert and flag_surf_inv)
                       or (not flag_b_invert and flag_surf_fw)));
    g_dsr.active     :=flag_above and (((flag_b_invert and flag_surf_inv)
                       or (not flag_b_invert and flag_surf_fw)));
    g_dsa.active     :=flag_above and (((flag_b_invert and flag_surf_inv)
                       or (not flag_b_invert and flag_surf_fw)));
    alpha_r.active   :=FALSE;
    beta_r.active    :=FALSE;
    gamma_r.active   :=FALSE;
    delta_r.active   :=not flag_public;     // temporary for Anna
    dummy.active     :=flag_Ed_Gege;
    test.active      :=TRUE;
    end;

procedure Active_R_surf;
{ Activate / deactivate parameters of surface reflectance. }
var i : integer;
begin
    for i:=0 to 5 do C[i].active:=FALSE;
    C_X.active       :=FALSE;
    C_Mie.active     :=FALSE;
    bbs_phy.active   :=FALSE;
    C_Y.active       :=FALSE;
    S.active         :=FALSE;
    n.active         :=FALSE;
    T_W.active       :=FALSE;
    Q.active         :=FALSE;
    rho_L.active     :=(spec_type=S_Rsurf) and (not Flag_fresnel_view);
    rho_dd.active    :=TRUE;
    rho_ds.active    :=TRUE;
    dummy.active     :=FALSE;
    f_dd.active      :=TRUE;
    f_ds.active      :=TRUE;
    H_oz.active      :=TRUE;
    WV.active        :=TRUE;
    alpha.active     :=TRUE;
    beta.active      :=TRUE;
    f.active         :=FALSE;
    z.active         :=FALSE;
    zB.active        :=FALSE;
    sun.active       :=TRUE;
    view.active      :=flag_above and Flag_fresnel_view;
    dphi.active      :=FALSE;
    f_nw.active      :=TRUE;
    for i:=0 to 5 do fA[i].active:=FALSE;
    fluo.active      :=FALSE;
    alpha_d.active   :=FALSE;
    beta_d.active    :=FALSE;
    gamma_d.active   :=FALSE;
    delta_d.active   :=FALSE;
    g_dd.active      :=TRUE;
    g_dsr.active     :=TRUE;
    g_dsa.active     :=TRUE;
    alpha_r.active   :=FALSE;
    beta_r.active    :=FALSE;
    gamma_r.active   :=FALSE;
    delta_r.active   :=FALSE;
    test.active      :=FALSE;
    end;

procedure Active_R_surf_Gege;
{ Activate / deactivate parameters of surface reflectance (model of Gege). }
var i : integer;
begin
    for i:=0 to 5 do C[i].active:=FALSE;
    C_X.active       :=FALSE;
    C_Mie.active     :=FALSE;
    bbs_phy.active   :=FALSE;
    C_Y.active       :=FALSE;
    S.active         :=flag_Y_exp;
    n.active         :=FALSE;
    T_W.active       :=FALSE;
    Q.active         :=FALSE;
    rho_L.active     :=((spec_type=S_Rsurf) and (not Flag_fresnel_view)) or
                       ((spec_type=S_Ed_Gege) and (not flag_above));
    rho_dd.active    :=FALSE;
    rho_ds.active    :=FALSE;
    dummy.active     :=flag_Ed_Gege;
    f_dd.active      :=FALSE;
    f_ds.active      :=FALSE;
    H_oz.active      :=FALSE;
    WV.active        :=FALSE;
    alpha.active     :=FALSE;
    beta.active      :=FALSE;
    f.active         :=FALSE;
    z.active         :=FALSE;
    zB.active        :=FALSE;
    sun.active       :=FALSE;
    view.active      :=flag_above and Flag_fresnel_view;
    dphi.active      :=FALSE;
    f_nw.active      :=TRUE;
    for i:=0 to 5 do fA[i].active:=flag_shallow;
    fluo.active      :=FALSE;
    alpha_d.active   :=TRUE;
    beta_d.active    :=TRUE;
    gamma_d.active   :=TRUE;
    delta_d.active   :=TRUE;
    g_dd.active      :=TRUE;
    g_dsr.active     :=TRUE;
    g_dsa.active     :=TRUE;
    alpha_r.active   :=FALSE;
    beta_r.active    :=FALSE;
    gamma_r.active   :=FALSE;
    delta_r.active   :=TRUE;
    test.active      :=TRUE;
    end;


procedure Active_a;
{ Activate / deactivate parameters of absorption. }
var i : integer;
begin
    for i:=0 to 5 do C[i].active:=TRUE;
    C_X.active       :=TRUE; {flag_CXisC0; }
    C_Mie.active     :=FALSE;
    bbs_phy.active   :=FALSE;
    C_Y.active       :=TRUE;
    S.active         :=flag_Y_exp;
    n.active         :=FALSE;
    T_W.active       :=flag_aW;
    Q.active         :=FALSE;
    rho_L.active     :=FALSE;
    rho_dd.active    :=FALSE;
    rho_ds.active    :=FALSE;
    f_dd.active      :=FALSE;
    f_ds.active      :=FALSE;
    H_oz.active      :=FALSE;
    WV.active        :=FALSE;
    alpha.active     :=FALSE;
    beta.active      :=FALSE;
    f.active         :=FALSE;
    z.active         :=FALSE;
    zB.active        :=FALSE;
    sun.active       :=FALSE;
    view.active      :=FALSE;
    dphi.active      :=FALSE;
    f_nw.active      :=FALSE;
    for i:=0 to 5 do fA[i].active:=FALSE;
    fluo.active      :=FALSE;
    alpha_d.active   :=FALSE;
    beta_d.active    :=FALSE;
    gamma_d.active   :=FALSE;
    delta_d.active   :=FALSE;
    g_dd.active      :=FALSE;
    g_dsr.active     :=FALSE;
    g_dsa.active     :=FALSE;
    alpha_r.active   :=FALSE;
    beta_r.active    :=FALSE;
    gamma_r.active   :=FALSE;
    delta_r.active   :=FALSE;
    dummy.active     :=FALSE;
    test.active      :=FALSE;
    end;

procedure Active_K;
{ Activate / deactivate parameters of attenuation. }
var i : integer;
begin
    for i:=0 to 5 do C[i].active:=TRUE;
    C_X.active       :=not flag_CXisC0;
    C_Mie.active     :=TRUE;
    bbs_phy.active   :=TRUE;
    C_Y.active       :=TRUE;
    S.active         :=flag_Y_exp;
    n.active         :=TRUE;
    T_W.active       :=TRUE;
    Q.active         :=FALSE;
    rho_L.active     :=FALSE;
    rho_dd.active    :=FALSE;
    rho_ds.active    :=FALSE;
    f_dd.active      :=FALSE;
    f_ds.active      :=FALSE;
    H_oz.active      :=FALSE;
    WV.active        :=FALSE;
    alpha.active     :=FALSE;
    beta.active      :=FALSE;
    f.active         :=FALSE;
    z.active         :=FALSE;
    zB.active        :=FALSE;
    sun.active       :=TRUE;
    view.active      :=FALSE;
    dphi.active      :=FALSE;
    f_nw.active      :=FALSE;
    for i:=0 to 5 do fA[i].active:=FALSE;
    fluo.active      :=FALSE;
    alpha_d.active   :=FALSE;
    beta_d.active    :=FALSE;
    gamma_d.active   :=FALSE;
    delta_d.active   :=FALSE;
    g_dd.active      :=FALSE;
    g_dsr.active     :=FALSE;
    g_dsa.active     :=FALSE;
    alpha_r.active   :=FALSE;
    beta_r.active    :=FALSE;
    gamma_r.active   :=FALSE;
    delta_r.active   :=FALSE;
    dummy.active     :=FALSE;
    test.active      :=FALSE;
    end;


procedure Active_Rbottom;
{ Activate / deactivate parameters of bottom reflectance. }
var i : integer;
begin
    for i:=0 to 5 do C[i].active:=FALSE;
    C_X.active       :=FALSE;
    C_Mie.active     :=FALSE;
    bbs_phy.active   :=FALSE;
    C_Y.active       :=FALSE;
    S.active         :=FALSE;
    n.active         :=FALSE;
    T_W.active       :=FALSE;
    Q.active         :=FALSE;
    rho_L.active     :=FALSE;
    rho_dd.active    :=FALSE;
    rho_ds.active    :=FALSE;
    f_dd.active      :=FALSE;
    f_ds.active      :=FALSE;
    H_oz.active      :=FALSE;
    WV.active        :=FALSE;
    alpha.active     :=FALSE;
    beta.active      :=FALSE;
    f.active         :=FALSE;
    z.active         :=FALSE;
    zB.active        :=FALSE;
    sun.active       :=FALSE;
    view.active      :=FALSE;
    dphi.active      :=FALSE;
    f_nw.active      :=FALSE;
    for i:=0 to 5 do fA[i].active:=TRUE;
    fluo.active      :=FALSE;
    alpha_d.active   :=FALSE;
    beta_d.active    :=FALSE;
    gamma_d.active   :=FALSE;
    delta_d.active   :=FALSE;
    g_dd.active      :=FALSE;
    g_dsr.active     :=FALSE;
    g_dsa.active     :=FALSE;
    alpha_r.active   :=FALSE;
    beta_r.active    :=FALSE;
    gamma_r.active   :=FALSE;
    delta_r.active   :=FALSE;
    dummy.active     :=FALSE;
    test.active      :=FALSE;
    end;

procedure Active_all;
{ Activate all parameters. }
var i : integer;
begin
    for i:=0 to 5 do C[i].active:=TRUE;
    C_X.active       :=TRUE;
    C_Mie.active     :=TRUE;
    bbs_phy.active   :=TRUE;
    C_Y.active       :=TRUE;
    S.active         :=TRUE;
    n.active         :=TRUE;
    T_W.active       :=TRUE;
    Q.active         :=TRUE;
    rho_L.active     :=TRUE;
    rho_dd.active    :=TRUE;
    rho_ds.active    :=TRUE;
    f_dd.active      :=TRUE;
    f_ds.active      :=TRUE;
    H_oz.active      :=TRUE;
    WV.active        :=TRUE;
    alpha.active     :=TRUE;
    beta.active      :=TRUE;
    f.active         :=(model_f=0);
    z.active         :=TRUE;
    zB.active        :=TRUE;
    sun.active       :=TRUE;
    view.active      :=TRUE;
    dphi.active      :=TRUE;
    f_nw.active      :=TRUE;
    for i:=0 to 5 do fA[i].active:=TRUE;
    fluo.active      :=TRUE;
    alpha_d.active   :=TRUE;
    beta_d.active    :=TRUE;
    gamma_d.active   :=TRUE;
    delta_d.active   :=TRUE;
    g_dd.active      :=TRUE;
    g_dsr.active     :=TRUE;
    g_dsa.active     :=TRUE;
    alpha_r.active   :=TRUE;
    beta_r.active    :=TRUE;
    gamma_r.active   :=TRUE;
    delta_r.active   :=TRUE;
    dummy.active     :=TRUE;
    test.active      :=TRUE;
    end;


procedure TFrame_p.Parameter_enable(Sender: TObject);
begin
    { Public parameters }
    CP_0.enabled   :=C[0].active;
    C1_0.enabled   :=C[1].active;
    C2_0.enabled   :=C[2].active;
    C3_0.enabled   :=C[3].active;
    C4_0.enabled   :=C[4].active;
    C5_0.enabled   :=C[5].active;
    fluo_0.enabled :=fluo.active;
    CL_0.enabled   :=C_X.active;
    CMie_0.enabled :=C_Mie.active;
    CY_0.enabled   :=C_Y.active;
    S_0.enabled    :=S.active;
    n_0.enabled    :=n.active;
    TW_0.enabled   :=T_W.active;
    Q_0.enabled    :=Q.active;
    rho_dd_0.enabled    :=rho_dd.active;
    rho_ds_0.enabled :=rho_ds.active;
    rho_L_0.enabled  :=rho_L.active;
    dummy_0.enabled :=dummy.active;
    view_0.enabled :=view.active;
    bbs_phy_0.enabled :=bbs_phy.active;
    sun_0.enabled  :=sun.active;
    f_nw_0.enabled :=f_nw.active;
    dphi_0.enabled :=dphi.active;
    f_dd_0.enabled :=f_dd.active;
    f_ds_0.enabled :=f_ds.active;
    H_oz_0.enabled :=H_oz.active;
    WV_0.enabled   :=WV.active;
    alpha_0.enabled:=alpha.active;
    beta_0.enabled :=beta.active;
    f_0.enabled    :=f.active;
    z_0.enabled    :=z.active;
    test_0.Enabled :=test.active;
    zB_0.enabled   :=zB.active;
    fa0_0.enabled  :=fA[0].active;
    fa1_0.enabled  :=fA[1].active;
    fa2_0.enabled  :=fA[2].active;
    fa3_0.enabled  :=fA[3].active;
    fa4_0.enabled  :=fA[4].active;
    fa5_0.enabled  :=fA[5].active;
    g_dd_0.enabled    :=g_dd.active;
    g_dsr_0.enabled   :=g_dsr.active;
    g_dsa_0.enabled   :=g_dsa.active;
    { Private parameters }
    delta_r_0.enabled :=delta_r.active;
    alpha_d_0.enabled :=alpha_d.active;
    beta_d_0.enabled  :=beta_d.active;
    gamma_d_0.enabled :=gamma_d.active;
    delta_d_0.enabled :=delta_d.active;

    { Public parameters }
    CP_fit.enabled   :=C[0].active;
    C1_fit.enabled   :=C[1].active;
    C2_fit.enabled   :=C[2].active;
    C3_fit.enabled   :=C[3].active;
    C4_fit.enabled   :=C[4].active;
    C5_fit.enabled   :=C[5].active;
    CL_fit.enabled   :=C_X.active;
    CMie_fit.enabled :=C_Mie.active;
    CY_fit.enabled   :=C_Y.active;
    S_fit.enabled    :=S.active;
    n_fit.enabled    :=n.active;
    TW_fit.enabled   :=T_W.active;
    Q_fit.enabled    :=Q.active;
    rho_dd_fit.enabled   :=rho_dd.active;
    rho_ds_fit.enabled :=rho_ds.active;
    rho_L_fit.enabled :=rho_L.active;
    dummy_fit.enabled :=dummy.active;
    view_fit.enabled :=view.active;
    bbs_phy1.enabled :=bbs_phy.active;
    sun_fit.enabled  :=sun.active;
    dphi_fit.enabled :=dphi.active;
    f_dd_fit.enabled :=f_dd.active;
    f_ds_fit.enabled :=f_ds.active;
    H_oz_fit.enabled :=H_oz.active;
    WV_fit.enabled   :=WV.active;
    alpha_fit.enabled  :=alpha.active;
    beta_fit.enabled :=beta.active;
    f_fit.enabled    :=f.active;
    z_fit.enabled    :=z.active;
    test_fit.enabled :=test.active;
    zB_fit.enabled   :=zB.active;
    fa0_fit.enabled  :=fA[0].active;
    fa1_fit.enabled  :=fA[1].active;
    fa2_fit.enabled  :=fA[2].active;
    fa3_fit.enabled  :=fA[3].active;
    fa4_fit.enabled  :=fA[4].active;
    fa5_fit.enabled  :=fA[5].active;
    fluo_fit.enabled :=fluo.active;
    f_nw_fit.enabled    :=f_nw.active;
    g_dd_fit.enabled    :=g_dd.active;
    g_dsr_fit.enabled   :=g_dsr.active;
    g_dsa_fit.enabled   :=g_dsa.active;
    { Private parameters }
    delta_r_fit.enabled :=delta_r.active;
    alpha_d_fit.enabled :=alpha_d.active;
    beta_d_fit.enabled  :=beta_d.active;
    gamma_d_fit.enabled :=gamma_d.active;
    delta_d_fit.enabled :=delta_d.active;
    end;

procedure TFrame_p.FormCreate(Sender: TObject);
begin
    Cp_fit.Caption      :=par.name[1];
    C1_fit.Caption      :=par.name[2];
    C2_fit.Caption      :=par.name[3];
    C3_fit.Caption      :=par.name[4];
    C4_fit.Caption      :=par.name[5];
    C5_fit.Caption      :=par.name[6];
    CL_fit.Caption      :=par.name[7];
    fluo_fit.Caption    :=par.name[14];
    CMie_fit.Caption    :=par.name[8];
    CY_fit.Caption      :=par.name[9];
    S_fit.Caption       :=par.name[10];
    n_fit.Caption       :=par.name[11];
    TW_fit.Caption      :=par.name[12];
    f_fit.Caption       :=par.name[24];
    Q_fit.Caption       :=par.name[13];
    z_fit.Caption       :=par.name[25];
    sun_fit.Caption     :=par.name[27];
    view_fit.Caption    :=par.name[28];
    bbs_phy1.Caption    :=par.name[36];
    alpha_d_fit.Caption :=par.name[41];
    beta_d_fit.Caption  :=par.name[42];
    gamma_d_fit.Caption :=par.name[43];
    delta_d_fit.Caption :=par.name[44];
    zB_fit.Caption      :=par.name[26];
    fa0_fit.Caption     :=par.name[30];
    fa1_fit.Caption     :=par.name[31];
    fa2_fit.Caption     :=par.name[32];
    fa3_fit.Caption     :=par.name[33];
    fa4_fit.Caption     :=par.name[34];
    fa5_fit.Caption     :=par.name[35];
    f_dd_fit.Caption    :=par.name[20];
    f_ds_fit.Caption    :=par.name[21];
    H_oz_fit.Caption    :=par.name[22];
    alpha_fit.Caption   :=par.name[19];
    beta_fit.Caption    :=par.name[18];
    WV_fit.Caption      :=par.name[23];
    rho_L_fit.Caption   :=par.name[15];
    rho_dd_fit.Caption  :=par.name[16];
    rho_ds_fit.Caption  :=par.name[17];
    g_dd_fit.Caption    :=par.name[37];
    g_dsr_fit.Caption   :=par.name[38];
    g_dsa_fit.Caption   :=par.name[39];
    dphi_fit.Caption    :=par.name[29];
    delta_r_fit.Caption :=par.name[40];
    dummy_fit.Caption   :=par.name[45];
    test_fit.Caption    :=par.name[46];
    f_nw_fit.Caption    :=par.name[50];

    Cp_fit.Hint         :=par.desc[1];
    C1_fit.Hint         :=par.desc[2];
    C2_fit.Hint         :=par.desc[3];
    C3_fit.Hint         :=par.desc[4];
    C4_fit.Hint         :=par.desc[5];
    C5_fit.Hint         :=par.desc[6];
    CL_fit.Hint         :=par.desc[7];
    fluo_fit.Hint       :=par.desc[14];
    CMie_fit.Hint       :=par.desc[8];
    CY_fit.Hint         :=par.desc[9];
    S_fit.Hint          :=par.desc[10];
    n_fit.Hint          :=par.desc[11];
    TW_fit.Hint         :=par.desc[12];
    f_fit.Hint          :=par.desc[24];
    Q_fit.Hint          :=par.desc[13];
    z_fit.Hint          :=par.desc[25];
    sun_fit.Hint        :=par.desc[27];
    view_fit.Hint       :=par.desc[28];
    bbs_phy1.Hint       :=par.desc[36];
    alpha_d_fit.hint    :=par.desc[41];
    beta_d_fit.hint     :=par.desc[42];
    gamma_d_fit.hint    :=par.desc[43];
    delta_d_fit.hint    :=par.desc[44];
    zB_fit.hint         :=par.desc[26];
    fa0_fit.hint        :=par.desc[30];
    fa1_fit.hint        :=par.desc[31];
    fa2_fit.hint        :=par.desc[32];
    fa3_fit.hint        :=par.desc[33];
    fa4_fit.hint        :=par.desc[34];
    fa5_fit.hint        :=par.desc[35];
    f_dd_fit.hint       :=par.desc[20];
    f_ds_fit.hint       :=par.desc[21];
    H_oz_fit.hint       :=par.desc[22];
    alpha_fit.hint      :=par.desc[19];
    beta_fit.hint       :=par.desc[18];
    WV_fit.hint         :=par.desc[23];
    rho_L_fit.hint      :=par.desc[15];
    rho_dd_fit.hint     :=par.desc[16];
    rho_ds_fit.hint     :=par.desc[17];
    g_dd_fit.hint       :=par.desc[37];
    g_dsr_fit.hint      :=par.desc[38];
    g_dsa_fit.hint      :=par.desc[39];
    dphi_fit.hint       :=par.desc[29];
    delta_r_fit.hint    :=par.desc[40];
    dummy_fit.hint      :=par.desc[45];
    test_fit.hint       :=par.desc[46];
    f_nw_fit.hint       :=par.desc[50];

    updte(Sender);
    end;

procedure TFrame_p.sun_fitChange(Sender: TObject);
begin

end;


procedure TFrame_p.updte(Sender: TObject);
begin
    Width :=DX_par;
    if flag_Ed_Gege then begin
        Height:=DY_par+DY_Gege;
        show_Gege(Sender);
        end
    else begin
        Height:=DY_par;
        hide_Gege(Sender);
        end;

    handle_private(Sender);
{    InActive_surf_param(Sender);
    if (spec_type=S_Lup) and (not flag_above) then DisableLds(Sender);  }
    PanelGray1.Top:=StaticText2.Top; //Cp_fit.Top;
    PanelGray1.Width:=CP_0.Left-Cp_fit.Width+Cp_fit.Height-6;
    PanelGray1.Left:=CP_0.Left-PanelGray1.Width-2;
    PanelGray1.Height:=Height;
    PanelGray1.Visible:=flag_panel_fw;
    PanelGray1.Color:=clDefault;
    PanelGray2.Color:=clDefault;

    PanelGray2.Width:=PanelGray1.Width;
    PanelGray2.Top:=StaticText2.Top;
    PanelGray2.Left:=f_nw_0.Left-PanelGray2.Width-2;
    PanelGray2.Height:=Height;
    PanelGray2.Visible:=flag_panel_fw;

    StaticText1.Top:=14;
    StaticText2.Top:=14;
    if flag_panel_fw then update_fw(Sender) else update_actual(Sender);
    Parameter_enable(Sender);
 (*
    // Use parameter f_nw to show parameter value
    f_nw_fit.Caption:='DY_leg';
    f_nw.fw:=DY_leg;  // ATTENTION: ONLY FOR TEST PURPOSES
    *)
    end;

procedure TFrame_p.handle_private(Sender: TObject);
{ Show private parameters in private version, hide them in public version. }
begin
    alpha_d_0.Visible   :=not flag_public;
    alpha_d_fit.Visible :=not flag_public;
    beta_d_0.Visible    :=not flag_public;
    beta_d_fit.Visible  :=not flag_public;
    gamma_d_0.Visible   :=not flag_public;
    gamma_d_fit.Visible :=not flag_public;
    delta_d_0.Visible   :=not flag_public;
    delta_d_fit.Visible :=not flag_public;
    dphi_0.Visible      :=not flag_public;
    dphi_fit.Visible    :=not flag_public;
    delta_r_0.visible   :=not flag_public;
    delta_r_fit.visible :=not flag_public;
    dummy_0.Visible     :=not flag_public;
    dummy_fit.Visible   :=not flag_public;
    test_0.Visible      :=not flag_public;
    test_fit.Visible    :=not flag_public;
    end;

procedure TFrame_p.hide_Gege(Sender: TObject);
{ Hide parameters of Ed model of Gege. }
begin
    dummy_fit.Visible   :=FALSE;
    dummy_0.Visible     :=FALSE;
    dphi_fit.Visible    :=FALSE;
    dphi_0.Visible      :=FALSE;

    alpha_d_fit.visible :=FALSE;
    beta_d_fit.visible  :=FALSE;
    gamma_d_fit.visible :=FALSE;
    delta_d_fit.visible :=FALSE;
    delta_r_0.visible   :=FALSE;
    alpha_d_0.visible   :=FALSE;
    beta_d_0.visible    :=FALSE;
    gamma_d_0.visible   :=FALSE;
    delta_d_0.visible   :=FALSE;
    delta_r_fit.visible :=FALSE;
    end;

procedure TFrame_p.show_Gege(Sender: TObject);
{ Show parameters of Ed model of Gege. }
begin
    dummy_fit.Visible   :=TRUE;
    dummy_0.Visible     :=TRUE;
    dphi_fit.Visible    :=TRUE;
    dphi_0.Visible      :=TRUE;

    alpha_d_fit.visible :=TRUE;
    beta_d_fit.visible  :=TRUE;
    gamma_d_fit.visible :=TRUE;
    delta_d_fit.visible :=TRUE;
    alpha_d_0.visible   :=TRUE;
    beta_d_0.visible    :=TRUE;
    gamma_d_0.visible   :=TRUE;
    delta_d_0.visible   :=TRUE;
    delta_r_fit.visible :=TRUE;
    delta_r_0.visible   :=TRUE;
    end;

procedure TFrame_p.update_actual(Sender: TObject);
const SIG = 4;
begin
    if flag_Fresnel_view then rho_L.actual:=Fresnel(view.actual);
    if flag_Fresnel_sun  then rho_dd.actual  :=Fresnel(sun.actual);
    updt(CP_0,  C[0].actual, SIG);
    updt(C1_0,  C[1].actual, SIG);
    updt(C2_0,  C[2].actual, SIG);
    updt(C3_0,  C[3].actual, SIG);
    updt(C4_0,  C[4].actual, SIG);
    updt(C5_0,  C[5].actual, SIG);
    if flag_fluo then updt(fluo_0,  fluo.actual, SIG) else fluo_0.text:='0';
    if flag_CXisC0 then CL_0.text:='= C[0]' else updt(CL_0,  C_X.actual, SIG);
    updt(CMie_0, C_Mie.actual, SIG);
    updt(CY_0,  C_Y.actual, SIG);
    if flag_Y_exp then updt(S_0, S.actual, SIG) else S_0.Text:='aY* = file';
    updt(TW_0,  T_W.actual, SIG);
    updt(alpha_d_0, alpha_d.actual, SIG);
    updt(beta_d_0, beta_d.actual, SIG);
    updt(gamma_d_0, gamma_d.actual, SIG);
    updt(delta_d_0, delta_d.actual, SIG);
    updt(n_0, n.actual, SIG);
    updt(Q_0, Q.actual, SIG);
    updt(rho_dd_0, rho_dd.actual, SIG);
    updt(rho_ds_0, rho_ds.actual, SIG);
    updt(rho_L_0, rho_L.actual, 5);
    updt(dummy_0, dummy.actual, SIG);
    updt(g_dd_0, g_dd.actual, SIG);
    updt(g_dsr_0,  g_dsr.actual, SIG);
    updt(g_dsa_0, g_dsa.actual, SIG);
    updt(delta_r_0, delta_r.actual, SIG);
    updt(alpha_0,   alpha.actual, SIG);
    updt(f_0, f.actual, SIG);
    if flag_above then z_0.Text:='0+' else updt(z_0, z.actual, SIG);
    if spec_type=S_R then z_0.Text:='0-';
    updt(test_0, test.actual, 5);
    updt(zB_0, zB.actual, SIG);
    updt(sun_0, sun.actual, SIG);
    updt(view_0, view.actual, SIG);
    updt(bbs_phy_0, bbs_phy.actual, SIG);
    updt(dphi_0, dphi.actual, SIG);
    updt(f_nw_0, f_nw.actual, SIG);
    updt(fA0_0, fA[0].actual, 3);
    updt(fA1_0, fA[1].actual, 3);
    updt(fA2_0, fA[2].actual, 3);
    updt(fA3_0, fA[3].actual, 3);
    updt(fA4_0, fA[4].actual, 3);
    updt(fA5_0, fA[5].actual, 3);
    updt(f_dd_0,  f_dd.actual, 3);
    updt(f_ds_0,  f_ds.actual, 3);
    updt(H_oz_0,  H_oz.actual, SIG);
    updt(beta_0,  beta.actual, SIG);
    updt(WV_0,    WV.actual, SIG);

    if not flag_surf_inv and (spec_type=S_Rrs) then begin
        updt(g_dd_0,  g_dd.actual, SIG);
        updt(g_dsr_0, g_dsr.actual, SIG);
        updt(g_dsa_0, g_dsa.actual, SIG);
        updt(delta_r_0, delta_d.actual, SIG);
        updt(alpha_0, alpha.actual, SIG);
        end;

    CP_fit.checked :=C[0].fit=1;
    C1_fit.checked :=C[1].fit=1;
    C2_fit.checked :=C[2].fit=1;
    C3_fit.checked :=C[3].fit=1;
    C4_fit.checked :=C[4].fit=1;
    C5_fit.checked :=C[5].fit=1;
    CL_fit.checked :=C_X.fit=1;
    CMie_fit.checked :=C_Mie.fit=1;
    CY_fit.checked :=C_Y.fit=1;
    S_fit.checked  :=S.fit=1;
    TW_fit.checked :=T_W.fit=1;
    g_dd_fit.checked   :=g_dd.fit=1;
    g_dsr_fit.checked  :=g_dsr.fit=1;
    g_dsa_fit.checked  :=g_dsa.fit=1;
    delta_r_fit.checked:=delta_r.fit=1;
    alpha_d_fit.checked:=alpha_d.fit=1;
    beta_d_fit.checked :=beta_d.fit=1;
    gamma_d_fit.checked:=gamma_d.fit=1;
    delta_d_fit.checked:=delta_d.fit=1;
    alpha_fit.checked:=alpha.fit=1;
    n_fit.checked:=n.fit=1;
    rho_dd_fit.checked:=rho_dd.fit=1;
    rho_ds_fit.checked:=rho_ds.fit=1;
    rho_L_fit.checked:=rho_L.fit=1;
    dummy_fit.checked:=dummy.fit=1;
    f_fit.checked:=f.fit=1;
    z_fit.checked:=z.fit=1;
    test_fit.checked:=test.fit=1;
    zB_fit.checked:=zB.fit=1;
    sun_fit.checked:=sun.fit=1;
    view_fit.checked:=view.fit=1;
    bbs_phy1.checked:=bbs_phy.fit=1;
    dphi_fit.checked:=dphi.fit=1;
    f_nw_fit.checked:=f_nw.fit=1;
    fA0_fit.checked:=fA[0].fit=1;
    fA1_fit.checked:=fA[1].fit=1;
    fA2_fit.checked:=fA[2].fit=1;
    fA3_fit.checked:=fA[3].fit=1;
    fA4_fit.checked:=fA[4].fit=1;
    fA5_fit.checked:=fA[5].fit=1;
    f_dd_fit.checked:=(f_dd.fit=1) and (model_Ed=1);
    f_ds_fit.checked:=(f_ds.fit=1) and (model_Ed=1);
    H_oz_fit.checked:=H_oz.fit=1;
    beta_fit.checked:=beta.fit=1;
    alpha_fit.checked:=alpha.fit=1;
    WV_fit.checked:=WV.fit=1;
    fluo_fit.Checked:=fluo.fit=1;
(*
    view_fit.Enabled    :=flag_Fresnel_view or (model_f_rs=0);
    view_0.Enabled      :=flag_Fresnel_view or (model_f_rs=0);
    rho_dd_fit.Enabled :=not flag_Fresnel_view;
    rho_dd_0.Enabled   :=not flag_Fresnel_view;      *)
    end;

procedure TFrame_p.update_fw(Sender: TObject);
const SIG = 4;
begin
    if flag_Fresnel_view then rho_L.fw:=Fresnel(view.fw);
    if flag_Fresnel_sun  then rho_dd.fw:=Fresnel(sun.fw);
    updt(CP_0,  C[0].fw, SIG);
    updt(C1_0,  C[1].fw, SIG);
    updt(C2_0,  C[2].fw, SIG);
    updt(C3_0,  C[3].fw, SIG);
    updt(C4_0,  C[4].fw, SIG);
    updt(C5_0,  C[5].fw, SIG);
    if flag_fluo then updt(fluo_0,  fluo.fw, SIG) else fluo_0.text:='0';
    if flag_CXisC0 then CL_0.text:='= C_P' else updt(CL_0,  C_X.fw, SIG);
    updt(CMie_0, C_Mie.fw, SIG);
    updt(CY_0,  C_Y.fw, SIG);
    if flag_Y_exp then updt(S_0, S.fw, SIG) else S_0.Text:='aY* = file';
    updt(TW_0,  T_W.fw, SIG);
    updt(alpha_d_0, alpha_d.fw, SIG);
    updt(beta_d_0, beta_d.fw, SIG);
    updt(gamma_d_0, gamma_d.fw, SIG);
    updt(delta_d_0, delta_d.fw, SIG);
    updt(n_0, n.fw, SIG);
    updt(Q_0, Q.fw, SIG);
    updt(rho_dd_0,  rho_dd.fw, SIG);
    updt(rho_ds_0, rho_ds.fw, SIG);
    updt(rho_L_0, rho_L.fw, SIG);
    updt(dummy_0, dummy.fw, SIG);

    updt(g_dd_0, g_dd.fw, SIG);
    updt(g_dsr_0, g_dsr.fw, SIG);
    updt(g_dsa_0, g_dsa.fw, SIG);
    updt(delta_r_0, delta_r.fw, SIG);
    updt(alpha_0,   alpha.fw, SIG);
    if not flag_surf_fw then begin
        updt(g_dd_0,  g_dd.fw,  SIG);
        updt(g_dsr_0, g_dsr.fw, SIG);
        updt(g_dsa_0, g_dsa.fw, SIG);
        updt(delta_r_0, delta_d.fw, SIG);
        end;
    updt(f_0,    f.fw, SIG);
    if flag_above then z_0.Text:='0+' else updt(z_0, z.fw, SIG);
    if spec_type=S_R then z_0.Text:='0-';
    updt(test_0, test.fw, 5);
    updt(zB_0,   zB.fw, SIG);
    updt(sun_0,  sun.fw, SIG);
    updt(view_0, view.fw, SIG);
    updt(bbs_phy_0, bbs_phy.fw, SIG);
    updt(dphi_0, dphi.fw, SIG);
    updt(f_nw_0, f_nw.fw, SIG);
    updt(fA0_0,  fA[0].fw, SIG);
    updt(fA1_0,  fA[1].fw, SIG);
    updt(fA2_0,  fA[2].fw, SIG);
    updt(fA3_0,  fA[3].fw, SIG);
    updt(fA4_0,  fA[4].fw, SIG);
    updt(fA5_0,  fA[5].fw, SIG);

    updt(f_dd_0,  f_dd.fw, SIG);
    updt(f_ds_0,  f_ds.fw, SIG);
    updt(H_oz_0,  H_oz.fw, SIG);
    updt(beta_0,  beta.fw, SIG);
    updt(WV_0,    WV.fw, SIG);

    view_fit.Enabled    :=flag_Fresnel_view or (model_f_rs=0);
    view_0.Enabled      :=flag_Fresnel_view or (model_f_rs=0);
    rho_dd_fit.Enabled :=not flag_Fresnel_view;
    rho_dd_0.Enabled   :=not flag_Fresnel_view;
    end;

procedure TFrame_p.CP_0Change(Sender: TObject);
begin
    change(CP_0, C[0]);
    end;

procedure TFrame_p.C1_0Change(Sender: TObject);
begin
    change(C1_0, C[1]);
    end;

procedure TFrame_p.C2_0Change(Sender: TObject);
begin
    change(C2_0, C[2]);
    end;

procedure TFrame_p.C3_0Change(Sender: TObject);
begin
    change(C3_0, C[3]);
    end;

procedure TFrame_p.C4_0Change(Sender: TObject);
begin
    change(C4_0, C[4]);
    end;

procedure TFrame_p.C5_0Change(Sender: TObject);
begin
    change(C5_0, C[5]);
    end;

procedure TFrame_p.CL_0Change(Sender: TObject);
begin
    change(CL_0, C_X);
    end;

procedure TFrame_p.CMie_0Change(Sender: TObject);
begin
    change(CMie_0, C_Mie);
    end;

procedure TFrame_p.CY_0Change(Sender: TObject);
begin
    change(CY_0, C_Y);
    end;

procedure TFrame_p.S_0Change(Sender: TObject);
var SS : double;
begin
    change(S_0, S);
    if flag_panel_fw then SS:=S.fw else SS:=S.actual;
    if flag_Y_exp then berechne_aY(SS);
    end;

procedure TFrame_p.TW_0Change(Sender: TObject);
begin
    change(TW_0, T_W);
    end;

procedure TFrame_p.g_dd_0Change(Sender: TObject);
begin
    change(g_dd_0, g_dd);
    end;

procedure TFrame_p.g_dsr_0Change(Sender: TObject);
begin
    change(g_dsr_0, g_dsr);
    end;

procedure TFrame_p.g_dsa_0Change(Sender: TObject);
begin
    change(g_dsa_0, g_dsa);
    end;

procedure TFrame_p.delta_r_0Change(Sender: TObject);
begin
    change(delta_r_0, delta_r);
    end;

procedure TFrame_p.alpha_0Change(Sender: TObject);
begin
    change(alpha_0, alpha);
    berechne_Mie;
    calc_Ed_GreggCarder;
    end;

procedure TFrame_p.n_0Change(Sender: TObject);
begin
    change(n_0, n);
    end;

procedure TFrame_p.Q_0Change(Sender: TObject);
begin
    change(Q_0, Q);
    end;

procedure TFrame_p.rho_dd_0Change(Sender: TObject);
begin
    change(rho_dd_0, rho_dd);
    end;

procedure TFrame_p.alpha_d_0Change(Sender: TObject);
begin
    change(alpha_d_0, alpha_d);
    end;

procedure TFrame_p.beta_d_0Change(Sender: TObject);
begin
    change(beta_d_0, beta_d);
    end;

procedure TFrame_p.gamma_d_0Change(Sender: TObject);
begin
    change(gamma_d_0, gamma_d);
    end;

procedure TFrame_p.delta_d_0Change(Sender: TObject);
begin
    change(delta_d_0, delta_d);
    end;

procedure TFrame_p.Cp_fitClick(Sender: TObject);
begin
    if CP_fit.checked then C[0].fit:=1 else C[0].fit:=0;
    end;

procedure TFrame_p.C1_fitClick(Sender: TObject);
begin
    if C1_fit.checked then C[1].fit:=1 else C[1].fit:=0;
    end;

procedure TFrame_p.C2_fitClick(Sender: TObject);
begin
    if C2_fit.checked then C[2].fit:=1 else C[2].fit:=0;
    end;

procedure TFrame_p.C3_fitClick(Sender: TObject);
begin
    if C3_fit.checked then C[3].fit:=1 else C[3].fit:=0;
    end;

procedure TFrame_p.C4_fitClick(Sender: TObject);
begin
    if C4_fit.checked then C[4].fit:=1 else C[4].fit:=0;
    end;

procedure TFrame_p.C5_fitClick(Sender: TObject);
begin
    if C5_fit.checked then C[5].fit:=1 else C[5].fit:=0;
    end;

procedure TFrame_p.CL_fitClick(Sender: TObject);
begin
    if CL_fit.checked then C_X.fit:=1 else C_X.fit:=0;
    end;

procedure TFrame_p.CMie_fitClick(Sender: TObject);
begin
    if CMie_fit.checked then C_Mie.fit:=1 else C_Mie.fit:=0;
    end;

procedure TFrame_p.CY_fitClick(Sender: TObject);
begin
    if CY_fit.checked then C_Y.fit:=1 else C_Y.fit:=0;
    end;

procedure TFrame_p.S_fitClick(Sender: TObject);
begin
    if S_fit.checked then S.fit:=1 else S.fit:=0;
    end;

procedure TFrame_p.TW_fitClick(Sender: TObject);
begin
    if TW_fit.checked then T_W.fit:=1 else T_W.fit:=0;
    end;

procedure TFrame_p.alpha_d_fitClick(Sender: TObject);
begin
    if alpha_d_fit.checked then alpha_d.fit:=1 else alpha_d.fit:=0;
    end;

procedure TFrame_p.beta_d_fitClick(Sender: TObject);
begin
    if beta_d_fit.checked then beta_d.fit:=1 else beta_d.fit:=0;
    end;

procedure TFrame_p.gamma_d_fitClick(Sender: TObject);
begin
    if gamma_d_fit.checked then gamma_d.fit:=1 else gamma_d.fit:=0;
    end;

procedure TFrame_p.delta_d_fitClick(Sender: TObject);
begin
    if delta_d_fit.checked then delta_d.fit:=1 else delta_d.fit:=0;
    end;

procedure TFrame_p.alpha_fitClick(Sender: TObject);
begin
    if alpha_fit.checked then alpha.fit:=1 else alpha.fit:=0;
    end;


procedure TFrame_p.g_dd_fitClick(Sender: TObject);
begin
    if g_dd_fit.checked then g_dd.fit:=1 else g_dd.fit:=0;
    end;

procedure TFrame_p.g_dsr_fitClick(Sender: TObject);
begin
    if g_dsr_fit.checked then g_dsr.fit:=1 else g_dsr.fit:=0;
    end;

procedure TFrame_p.g_dsa_fitClick(Sender: TObject);
begin
    if g_dsa_fit.checked then g_dsa.fit:=1 else g_dsa.fit:=0;
    end;

procedure TFrame_p.delta_r_fitClick(Sender: TObject);
begin
    if delta_r_fit.checked then delta_r.fit:=1 else delta_r.fit:=0;
    end;

procedure TFrame_p.Q_fitClick(Sender: TObject);
begin
    if Q_fit.checked then Q.fit:=1 else Q.fit:=0;
    end;

procedure TFrame_p.rho_dd_fitClick(Sender: TObject);
begin
    if rho_dd_fit.checked then rho_dd.fit:=1 else rho_dd.fit:=0;
    end;

procedure TFrame_p.n_fitClick(Sender: TObject);
begin
    if n_fit.checked then n.fit:=1 else n.fit:=0;
    end;

procedure TFrame_p.f_0Change(Sender: TObject);
begin
    change(f_0, f);
    end;

procedure TFrame_p.view_fitChange(Sender: TObject);
begin

end;

procedure TFrame_p.z_0Change(Sender: TObject);
begin
    if not flag_above then change(z_0, z);
    end;

procedure TFrame_p.zB_0Change(Sender: TObject);
begin
    change(zB_0, zB);
    end;

procedure TFrame_p.sun_0Change(Sender: TObject);
begin
    change(sun_0, sun);
    if flag_Fresnel_sun then begin
        if flag_panel_fw then begin
            rho_dd.fw:=Fresnel(sun.fw);
            updt(rho_dd_0, rho_dd.fw, SIG);
            end
        else begin
            rho_dd.actual:=Fresnel(sun.actual);
            updt(rho_dd_0, rho_dd.actual, SIG);
            end;
        end;
    if flag_calc_rho_ds then begin
        if flag_panel_fw then begin
            rho_ds.fw:=rho_diffuse(sun.fw*pi/180);
            updt(rho_ds_0, rho_ds.fw, SIG);
            end
        else begin
            rho_ds.actual:=rho_diffuse(sun.fw*pi/180);
            updt(rho_ds_0, rho_ds.actual, SIG);
            end;
        end;
    if flag_MP then begin
        if flag_panel_fw then tsun_fw:=sun.fw
                         else tsun_inv:=sun.actual;
        end;
    end;

procedure TFrame_p.view_0Change(Sender: TObject);
begin
    change(view_0, view);
    if flag_Fresnel_view then begin
        if flag_panel_fw then begin
            rho_L.fw:=Fresnel(view.fw);
            updt(rho_L_0, rho_L.fw, SIG);
            end
        else begin
            rho_L.actual:=Fresnel(view.actual);
            updt(rho_L_0, rho_L.actual, SIG);
            end;
        end;
    if flag_MP then begin
        if flag_panel_fw then tview_fw:=view.fw
                         else tview_inv:=view.actual;
        end;
    end;

procedure TFrame_p.dphi_0Change(Sender: TObject);
begin
    change(dphi_0, dphi);
    end;

procedure TFrame_p.bbs_phy_0Change(Sender: TObject);
begin
    change(bbs_phy_0, bbs_phy);
    end;

procedure TFrame_p.fa0_0Change(Sender: TObject);
begin
    change(fa0_0, fA[0]);
    end;

procedure TFrame_p.fa1_0Change(Sender: TObject);
begin
    change(fa1_0, fA[1]);
    end;

procedure TFrame_p.fa2_0Change(Sender: TObject);
begin
    change(fa2_0, fA[2]);
    end;

procedure TFrame_p.fa3_0Change(Sender: TObject);
begin
    change(fa3_0, fA[3]);
    end;

procedure TFrame_p.fa4_0Change(Sender: TObject);
begin
    change(fa4_0, fA[4]);
    end;

procedure TFrame_p.fa5_0Change(Sender: TObject);
begin
    change(fa5_0, fA[5]);
    end;


procedure TFrame_p.f_fitClick(Sender: TObject);
begin
    if f_fit.checked then f.fit:=1 else f.fit:=0;
    end;

procedure TFrame_p.f_nw_0Change(Sender: TObject);
begin
    change(f_nw_0, f_nw);
    end;

procedure TFrame_p.f_nw_fitClick(Sender: TObject);
begin
    if f_nw_fit.checked then f_nw.fit:=1 else f_nw.fit:=0;
    end;

procedure TFrame_p.z_fitClick(Sender: TObject);
begin
    if z_fit.checked then z.fit:=1 else z.fit:=0;
    end;

procedure TFrame_p.zB_fitClick(Sender: TObject);
begin
    if zB_fit.checked then zB.fit:=1 else zB.fit:=0;
    end;

procedure TFrame_p.sun_fitClick(Sender: TObject);
begin
    if sun_fit.checked then sun.fit:=1 else sun.fit:=0;
    end;

procedure TFrame_p.view_fitClick(Sender: TObject);
begin
    if view_fit.checked then view.fit:=1 else view.fit:=0;
    end;

procedure TFrame_p.dphi_fitClick(Sender: TObject);
begin
    if dphi_fit.checked then dphi.fit:=1 else dphi.fit:=0;
    end;

procedure TFrame_p.bbs_phyClick(Sender: TObject);
begin
    if bbs_phy1.checked then bbs_phy.fit:=1 else bbs_phy.fit:=0;
    end;

procedure TFrame_p.fa0_fitClick(Sender: TObject);
begin
    if fA0_fit.checked then fA[0].fit:=1 else fA[0].fit:=0;
    end;

procedure TFrame_p.fa1_fitClick(Sender: TObject);
begin
    if fA1_fit.checked then fA[1].fit:=1 else fA[1].fit:=0;
    end;

procedure TFrame_p.fa2_fitClick(Sender: TObject);
begin
    if fA2_fit.checked then fA[2].fit:=1 else fA[2].fit:=0;
    end;

procedure TFrame_p.fa3_fitClick(Sender: TObject);
begin
    if fA3_fit.checked then fA[3].fit:=1 else fA[3].fit:=0;
    end;

procedure TFrame_p.fa4_fitClick(Sender: TObject);
begin
    if fA4_fit.checked then fA[4].fit:=1 else fA[4].fit:=0;
    end;

procedure TFrame_p.fa5_fitClick(Sender: TObject);
begin
    if fA5_fit.checked then fA[5].fit:=1 else fA[5].fit:=0;
    end;

procedure TFrame_p.f_dd_fitClick(Sender: TObject);
begin
    if f_dd_fit.checked then f_dd.fit:=1 else f_dd.fit:=0;
    end;

procedure TFrame_p.f_ds_fitClick(Sender: TObject);
begin
    if f_ds_fit.checked then f_ds.fit:=1 else f_ds.fit:=0;
    end;

procedure TFrame_p.H_oz_fitClick(Sender: TObject);
begin
    if H_oz_fit.checked then H_oz.fit:=1 else H_oz.fit:=0;
    end;

procedure TFrame_p.beta_fitClick(Sender: TObject);
begin
    if beta_fit.checked then beta.fit:=1 else beta.fit:=0;
    end;

procedure TFrame_p.WV_fitClick(Sender: TObject);
begin
    if WV_fit.checked then WV.fit:=1 else WV.fit:=0;
    end;

procedure TFrame_p.f_dd_0Change(Sender: TObject);
begin
    change(f_dd_0, f_dd);
    if flag_MP and (not flag_b_invert) then begin // melt ponds, forward mode
        set_global_parameters_fw_MP; // Set global parameters of forward mode
        updt(sun_0, sun.fw, SIG);
        updt(g_dd_0, g_dd.fw, SIG);
        updt(g_dsr_0, g_dsr.fw, SIG);
        updt(g_dsa_0, g_dsa.fw, SIG);
        updt(fA4_0, fA[4].fw, SIG);
        end;
    if flag_MP and flag_b_invert then begin // melt ponds, inverse mode
        set_global_parameters_inv_MP; // Set global parameters of inverse mode
        updt(sun_0, sun.actual, SIG);
        updt(g_dd_0, g_dd.actual, SIG);
        updt(g_dsr_0, g_dsr.actual, SIG);
        updt(g_dsa_0, g_dsa.actual, SIG);
        updt(fA4_0, fA[4].actual, SIG);
        end;

    end;

procedure TFrame_p.f_ds_0Change(Sender: TObject);
begin
    change(f_ds_0, f_ds);
    end;

procedure TFrame_p.H_oz_0Change(Sender: TObject);
begin
    change(H_oz_0, H_oz);
    end;

procedure TFrame_p.beta_0Change(Sender: TObject);
begin
    change(beta_0, beta);
    berechne_Mie;
    calc_Ed_GreggCarder;
    end;

procedure TFrame_p.WV_0Change(Sender: TObject);
begin
    change(WV_0, WV);
    end;

procedure TFrame_p.fluo_fitClick(Sender: TObject);
begin
    if fluo_fit.checked then fluo.fit:=1 else fluo.fit:=0;
    end;

procedure TFrame_p.fluo_0Change(Sender: TObject);
begin
    if flag_fluo then change(fluo_0, fluo);
    end;

procedure TFrame_p.rho_L_fitClick(Sender: TObject);
begin
    if rho_L_fit.checked then rho_L.fit:=1 else rho_L.fit:=0;
    end;

procedure TFrame_p.dummy_fitClick(Sender: TObject);
begin
    if dummy_fit.checked then dummy.fit:=1 else dummy.fit:=0;
    end;

procedure TFrame_p.rho_ds_fitClick(Sender: TObject);
begin
    if rho_ds_fit.checked then rho_ds.fit:=1 else rho_ds.fit:=0;
    end;

procedure TFrame_p.rho_L_0Change(Sender: TObject);
begin
    change(rho_L_0, rho_L);
    end;

procedure TFrame_p.dummy_0Change(Sender: TObject);
begin
    change(dummy_0, dummy);
    end;

procedure TFrame_p.rho_ds_0Change(Sender: TObject);
begin
    change(rho_ds_0, rho_ds);
    end;

procedure TFrame_p.test_fitClick(Sender: TObject);
begin
    if test_fit.checked then test.fit:=1 else test.fit:=0;
    end;

procedure TFrame_p.test_0Change(Sender: TObject);
begin
    change(test_0, test);
    end;

procedure TFrame_p.FrameEnter(Sender: TObject);
begin
    delete_calculated_spectra;
    end;

end.
