unit Popup_Models;

{$MODE Delphi}

{ Version vom 10.2.2020 }

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, SCHOEN_, defaults, misc, ExtCtrls, privates;

type

  { TForm_Models }

  TForm_Models = class(TForm)
    ButtonbPhy: TButton;
    EditbPhyFile: TEdit;
    EditHeaderbPhy: TEdit;
    EditXColbPhy: TEdit;
    EditYColbPhy: TEdit;
    GroupBoxPhy: TGroupBox;
    PageControll: TPageControl;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    StaticText10: TStaticText;
    StaticText11: TStaticText;
    StaticText15: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    StaticText9: TStaticText;
    Static_day1: TStaticText;
    Static_dsmpl1: TStaticText;
    Static_dsmpl2: TStaticText;
    Static_ld1: TStaticText;
    Static_ldd1: TStaticText;
    Static_pEd1: TStaticText;
    Static_pEd2: TStaticText;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    CheckExp: TCheckBox;
    CheckYFile: TCheckBox;
    GroupY: TGroupBox;
    Text2Header1: TStaticText;
    Text2Header2: TStaticText;
    TextAheader1: TStaticText;
    TextAheader2: TStaticText;
    TextBheader1: TStaticText;
    TextBheader2: TStaticText;
    TextHeaderEd1: TStaticText;
    TextHeaderEd2: TStaticText;
    TextHeaderE_d1: TStaticText;
    TextHeaderE_d2: TStaticText;
    TextHeaderLs1: TStaticText;
    TextHeaderLs2: TStaticText;
    TextHeaderR2: TStaticText;
    TextHeaderR3: TStaticText;
    TextLambdaL1: TStaticText;
    TextNormY1: TStaticText;
    TextPhyHeader: TStaticText;
    TextHeadingFilePhy: TStaticText;
    TextFilename_bPhy: TStaticText;
    TextPhyHeader1: TStaticText;
    TextPhyHeader2: TStaticText;
    Text_AlbedoHeader1: TStaticText;
    Text_AlbedoHeader2: TStaticText;
    Text_BRDF10: TStaticText;
    Text_BRDF11: TStaticText;
    Text_BRDF6: TStaticText;
    Text_BRDF7: TStaticText;
    Text_BRDF8: TStaticText;
    Text_BRDF9: TStaticText;
    Text_DHeader1: TStaticText;
    Text_DHeader2: TStaticText;
    Text_FileY: TStaticText;
    EditYfile: TEdit;
    EditDFile: TEdit;
    ButtonYFile: TButton;
    Text_Integral_Ed1: TStaticText;
    Text_Integral_Edd1: TStaticText;
    Text_Integral_Eds1: TStaticText;
    Text_Integral_range1: TStaticText;
    Text_Integral_range2: TStaticText;
    Text_P1: TStaticText;
    Text_PAR1: TStaticText;
    Text_PAR2: TStaticText;
    Text_PAR3: TStaticText;
    Text_PAR4: TStaticText;
    Text_RH1: TStaticText;
    Text_rho_Ed1: TStaticText;
    Text_sum_fA_max1: TStaticText;
    Text_sum_fA_min1: TStaticText;
    Text_V1: TStaticText;
    Text_Water1: TStaticText;
    Text_width1: TStaticText;
    Text_width2: TStaticText;
    Text_width3: TStaticText;
    Text_width4: TStaticText;
    Text_YHeader: TStaticText;
    EditHeaderY: TEdit;
    EditXColY: TEdit;
    EditYColY: TEdit;
    OpenDialog1: TOpenDialog;
    GroupD: TGroupBox;
    CheckNormD: TCheckBox;
    RadioGroupR: TRadioGroup;
    Check_bFile: TCheckBox;
    Check_b_aP: TCheckBox;
    GroupBoxTypeI: TGroupBox;
    Text2Filename: TStaticText;
    EditbLFile: TEdit;
    ButtonbLFile: TButton;
    Text2Header: TStaticText;
    EditHeaderbL: TEdit;
    EditXColbL: TEdit;
    EditYColbL: TEdit;
    EditLambdaL: TEdit;
    StaticText1: TStaticText;
    EditbbX: TEdit;
    GroupBoxTypeII: TGroupBox;
    StaticText4: TStaticText;
    EditLambdaS: TEdit;
    EditbbMie: TEdit;
    TextPower: TStaticText;
    Check_Nonlinear: TCheckBox;
    EditPower: TEdit;
    EditYLambda0: TEdit;
    TextNormY: TStaticText;
    Text_DHeader: TStaticText;
    EditHeaderD: TEdit;
    EditXColD: TEdit;
    EditYColD: TEdit;
    TextDFile: TStaticText;
    ButtonDFile: TButton;
    TextD: TStaticText;
    TabSheet4: TTabSheet;
    RadioGroupBottom: TRadioGroup;
    Text_BRDF0: TStaticText;
    Edit_BRDF0: TEdit;
    Text_BRDF1: TStaticText;
    Edit_BRDF1: TEdit;
    Text_BRDF2: TStaticText;
    Edit_BRDF2: TEdit;
    Text_BRDF3: TStaticText;
    Edit_BRDF3: TEdit;
    Text_BRDF4: TStaticText;
    Edit_BRDF4: TEdit;
    Text_BRDF5: TStaticText;
    Edit_BRDF5: TEdit;
    GroupBoxWater: TGroupBox;
    Text_Water: TStaticText;
    Editbb1: TEdit;
    TextDLambda0: TStaticText;
    EditDLambda0: TEdit;
    RadioGroupf: TRadioGroup;
    TabSheet5: TTabSheet;
    GroupEdMinus: TGroupBox;
    CheckEdUseEd: TCheckBox;
    TextFileEd: TStaticText;
    TextHeaderEd: TStaticText;
    EditHeaderEd: TEdit;
    EditXColEd: TEdit;
    EditYColEd: TEdit;
    EditEdFile: TEdit;
    ButtonEdFile: TButton;
    TabSheet6: TTabSheet;
    GroupBox2: TGroupBox;
    CheckUseLs: TCheckBox;
    TextFileLs: TStaticText;
    TextHeaderLs: TStaticText;
    EditHeaderLs: TEdit;
    EditXColLs: TEdit;
    EditYColLs: TEdit;
    EditLsFile: TEdit;
    ButtonLsFile: TButton;
    TabSheet7: TTabSheet;
    RadioGroupRrsB: TRadioGroup;
    RadioGroupfrs: TRadioGroup;
    StaticText6: TStaticText;
    Label1: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    GroupR: TGroupBox;
    CheckUseR: TCheckBox;
    TextFileR: TStaticText;
    TextHeaderR: TStaticText;
    EditHeaderR: TEdit;
    EditXColR: TEdit;
    EditYColR: TEdit;
    EditRfile: TEdit;
    ButtonRfile: TButton;
    RadioGroupRrsA: TRadioGroup;
    Memo4: TMemo;
    TextLambdaL: TStaticText;
    CheckUseEd: TCheckBox;
    TextFileE_d: TStaticText;
    EditE_dFile: TEdit;
    ButtonE_dFile: TButton;
    EditHeaderE_d: TEdit;
    TextHeaderE_d: TStaticText;
    EditXColE_d: TEdit;
    EditYColE_d: TEdit;
    CheckWvDependent: TCheckBox;
    TabSheet8: TTabSheet;
    Edit_RH: TEdit;
    Text_RH: TStaticText;
    Text_AM: TStaticText;
    Edit_AM: TEdit;
    Text_P: TStaticText;
    Edit_P: TEdit;
    Text_MM: TStaticText;
    Edit_MM: TEdit;
    Text_M: TStaticText;
    Edit_M: TEdit;
    Text_Moz: TStaticText;
    Edit_Moz: TEdit;
    GroupAtmCalc: TGroupBox;
    GroupAtmos: TGroupBox;
    TabSheet9: TTabSheet;
    GroupChl_a: TGroupBox;
    Text_center: TStaticText;
    Edit_chl_0: TEdit;
    Text_width: TStaticText;
    Edit_chl_sig: TEdit;
    Edit_chl_FWHM: TEdit;
    Text_PAR: TStaticText;
    Edit_PAR_min: TEdit;
    Edit_PAR_max: TEdit;
    Static_day: TStaticText;
    Edit_day: TEdit;
    Text_rho_Ed: TStaticText;
    Edit_rho_Ed: TEdit;
    StaticText2: TStaticText;
    EditbX: TEdit;
    EditbMie: TEdit;
    StaticText5: TStaticText;
    StaticText3: TStaticText;
    RadioGroupEd: TRadioGroup;
    Text_V: TStaticText;
    Edit_V: TEdit;
    Check_rho_dd_Fresnel: TCheckBox;
    Static_rho_dd: TStaticText;
    Edit_rho_dd: TEdit;
    Static_rho_ds: TStaticText;
    Edit_rho_ds: TEdit;
    Group_par: TGroupBox;
    Static_lds: TStaticText;
    Edit_lds0: TEdit;
    Check_rho_ds: TCheckBox;
    Group_rho_d: TGroupBox;
    Group_rho_u: TGroupBox;
    Static_ldd: TStaticText;
    Edit_ldd: TEdit;
    Static_ld: TStaticText;
    Edit_ld: TEdit;
    Text_Integral_range: TStaticText;
    Edit_Integral_min: TEdit;
    Edit_Integral_max: TEdit;
    Text_Integral_Ed: TStaticText;
    Edit_Integral_Ed: TEdit;
    Text_Integral_Edd: TStaticText;
    Edit_Integral_Edd: TEdit;
    Text_Integral_Eds: TStaticText;
    Edit_Integral_Eds: TEdit;
    Static_dsmpl: TStaticText;
    Edit_dsmpl: TEdit;
    Edit_lds1: TEdit;
    Edit_lddb: TEdit;
    TabSheet10: TTabSheet;
    Group_Kds: TGroupBox;
    Group_Kd: TGroupBox;
    Static_Kd: TStaticText;
    Group_Kdd: TGroupBox;
    RadioGroup_Kdd: TRadioGroup;
    Edit_ldda: TEdit;
    StaticText14: TStaticText;
    Memo5: TMemo;
    Memo6: TMemo;
    StaticText_lds0: TStaticText;
    Memo7: TMemo;
    Static_rho_u: TStaticText;
    Edit_rho_u: TEdit;
    Memo_rho_ds: TMemo;
    CheckFluo: TCheckBox;
    Text_sum_fA_min: TStaticText;
    Edit_sum_min: TEdit;
    Edit_sum_max: TEdit;
    Group_BRDF: TGroupBox;
    Group_fA: TGroupBox;
    Text_sum_fA_max: TStaticText;
    Static_pEd: TStaticText;
    Edit_pEd: TEdit;
    GroupC: TGroupBox;
    CheckCaph: TCheckBox;
    TextABfiles: TStaticText;
    TextAfile: TStaticText;
    EditAfile: TEdit;
    ButtonAfile: TButton;
    TextAheader: TStaticText;
    EditHeaderA: TEdit;
    EditXColA: TEdit;
    EditYColA: TEdit;
    TextBfile: TStaticText;
    EditBfile: TEdit;
    ButtonBfile: TButton;
    Text_eq_a: TStaticText;
    TextBheader: TStaticText;
    EditHeaderB: TEdit;
    EditXColB: TEdit;
    EditYColB: TEdit;
    Memo_Kds: TMemo;
    Memo_Kds_Lit: TMemo;
    StaticText_lds1: TStaticText;
    Edit_FnBottom0: TEdit;
    ButtonAlbedo0: TButton;
    Group_filenames_albedo: TGroupBox;
    Text_FnBottom0: TStaticText;
    Edit_FnBottom1: TEdit;
    ButtonAlbedo1: TButton;
    Edit_FnBottom2: TEdit;
    ButtonAlbedo2: TButton;
    Edit_FnBottom3: TEdit;
    ButtonAlbedo3: TButton;
    Edit_FnBottom4: TEdit;
    ButtonAlbedo4: TButton;
    Edit_FnBottom5: TEdit;
    ButtonAlbedo5: TButton;
    Text_FnBottom1: TStaticText;
    Text_FnBottom2: TStaticText;
    Text_FnBottom3: TStaticText;
    Text_FnBottom4: TStaticText;
    Text_FnBottom5: TStaticText;
    Text_AlbedoHeader: TStaticText;
    EditHeaderA0: TEdit;
    EditXColA0: TEdit;
    EditYColA0: TEdit;
    EditHeaderA1: TEdit;
    EditXColA1: TEdit;
    EditYColA1: TEdit;
    EditHeaderA2: TEdit;
    EditXColA2: TEdit;
    EditYColA2: TEdit;
    EditHeaderA3: TEdit;
    EditXColA3: TEdit;
    EditYColA3: TEdit;
    EditHeaderA4: TEdit;
    EditXColA4: TEdit;
    EditYColA4: TEdit;
    EditHeaderA5: TEdit;
    EditXColA5: TEdit;
    EditYColA5: TEdit;
    Text_YHeader1: TStaticText;
    Text_YHeader2: TStaticText;
    procedure EditHeaderbLChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GroupAtmosClick(Sender: TObject);
    procedure GroupBoxPhyClick(Sender: TObject);
    procedure GroupYClick(Sender: TObject);
    procedure Group_KdClick(Sender: TObject);
    procedure PageControllChange(Sender: TObject);
    procedure Static_ldClick(Sender: TObject);
    procedure TextFilename_bPhyClick(Sender: TObject);
    procedure TextLambdaLClick(Sender: TObject);
    procedure update_E_texts(Sender: TObject);
    procedure update_rho_dd(Sender: TObject);
    procedure update_rho_ds(Sender: TObject);
    procedure define_temp_parameters(Sender: TObject);
    procedure set_temp_parameters(Sender: TObject);
    procedure update_parameterlist(Sender: TObject);
    procedure active_aph(Sender: TObject);
    procedure inactive_aph(Sender: TObject);
    procedure inactive_FilePar(Sender: TObject);
    procedure active_FilebLPar(Sender: TObject);
    procedure inactive_FilebLPar(Sender: TObject);
    procedure active_FilePar(Sender: TObject);
    procedure active_Linear(Sender: TObject);
    procedure inactive_Linear(Sender: TObject);
    procedure InActivateEd(Sender: TObject);
    procedure InActivateE_d(Sender: TObject);
    procedure InActivateLs(Sender: TObject);
    procedure InActivateR(Sender: TObject);
    procedure InActivate_ld(Sender: TObject);
    procedure InActivateFluo(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure CheckExpClick(Sender: TObject);
    procedure CheckYFileClick(Sender: TObject);
    procedure ButtonYFileClick(Sender: TObject);
    procedure EditHeaderYChange(Sender: TObject);
    procedure EditXColYChange(Sender: TObject);
    procedure EditYColYChange(Sender: TObject);
    procedure CheckNormDClick(Sender: TObject);
    procedure RadioGroupRClick(Sender: TObject);
    procedure EditLambdaLChange(Sender: TObject);
    procedure Check_bFileClick(Sender: TObject);
    procedure Check_b_aPClick(Sender: TObject);
    procedure EditbbXChange(Sender: TObject);
    procedure EditLambdaSChange(Sender: TObject);
    procedure EditbbMieChange(Sender: TObject);
    procedure Check_NonlinearClick(Sender: TObject);
    procedure EditPowerChange(Sender: TObject);
    procedure Check_CLisCPClick(Sender: TObject);
    procedure EditYLambda0Change(Sender: TObject);
    procedure EditHeaderDChange(Sender: TObject);
    procedure EditXColDChange(Sender: TObject);
    procedure EditYColDChange(Sender: TObject);
    procedure RadioGroupBottomClick(Sender: TObject);
    procedure Edit_BRDF0Change(Sender: TObject);
    procedure Edit_BRDF1Change(Sender: TObject);
    procedure Edit_BRDF2Change(Sender: TObject);
    procedure Edit_BRDF3Change(Sender: TObject);
    procedure Edit_BRDF4Change(Sender: TObject);
    procedure Edit_BRDF5Change(Sender: TObject);
    procedure Editbb1Change(Sender: TObject);
    procedure EditDLambda0Change(Sender: TObject);
    procedure RadioGroupfClick(Sender: TObject);
    procedure CheckEdUseEdClick(Sender: TObject);
    procedure EditHeaderEdChange(Sender: TObject);
    procedure EditXColEdChange(Sender: TObject);
    procedure EditYColEdChange(Sender: TObject);
    procedure ButtonEdFileClick(Sender: TObject);
    procedure CheckUseLsClick(Sender: TObject);
    procedure ButtonLsFileClick(Sender: TObject);
    procedure EditHeaderLsChange(Sender: TObject);
    procedure EditXColLsChange(Sender: TObject);
    procedure EditYColLsChange(Sender: TObject);
    procedure RadioGroupRrsBClick(Sender: TObject);
    procedure RadioGroupfrsClick(Sender: TObject);
    procedure CheckUseRClick(Sender: TObject);
    procedure EditHeaderRChange(Sender: TObject);
    procedure ButtonRfileClick(Sender: TObject);
    procedure RadioGroupRrsAClick(Sender: TObject);
    procedure CheckUseEdClick(Sender: TObject);
    procedure CheckWvDependentClick(Sender: TObject);
    procedure EditHeaderE_dChange(Sender: TObject);
    procedure EditXColE_dChange(Sender: TObject);
    procedure EditYColE_dChange(Sender: TObject);
    procedure ButtonE_dFileClick(Sender: TObject);
    procedure Edit_RHChange(Sender: TObject);
    procedure Edit_AMChange(Sender: TObject);
    procedure Edit_PChange(Sender: TObject);
    procedure Edit_chl_0Change(Sender: TObject);
    procedure Edit_chl_sigChange(Sender: TObject);
    procedure Edit_chl_FWHMChange(Sender: TObject);
    procedure Edit_PAR_minChange(Sender: TObject);
    procedure Edit_PAR_maxChange(Sender: TObject);
    procedure Edit_dayChange(Sender: TObject);
    procedure Edit_rho_EdChange(Sender: TObject);
    procedure EditbXChange(Sender: TObject);
    procedure EditbMieChange(Sender: TObject);
    procedure RadioGroupEdClick(Sender: TObject);
    procedure Check_rho_dd_FresnelClick(Sender: TObject);
    procedure Edit_rho_ddChange(Sender: TObject);
    procedure Edit_rho_dsChange(Sender: TObject);
    procedure Edit_lds0Change(Sender: TObject);
    procedure Check_rho_dsClick(Sender: TObject);
    procedure Edit_lddChange(Sender: TObject);
    procedure Edit_ldChange(Sender: TObject);
    procedure Edit_Integral_minChange(Sender: TObject);
    procedure Edit_Integral_maxChange(Sender: TObject);
    procedure Edit_dsmplChange(Sender: TObject);
    procedure Edit_lds1Change(Sender: TObject);
    procedure Edit_lddbChange(Sender: TObject);
    procedure RadioGroup_KddClick(Sender: TObject);
    procedure Edit_lddaChange(Sender: TObject);
    procedure Edit_rho_uChange(Sender: TObject);
    procedure CheckFluoClick(Sender: TObject);
    procedure Edit_sum_minChange(Sender: TObject);
    procedure Edit_sum_maxChange(Sender: TObject);
    procedure Edit_pEdChange(Sender: TObject);
    procedure CheckCaphClick(Sender: TObject);
    procedure ButtonDFileClick(Sender: TObject);
    procedure ButtonbLFileClick(Sender: TObject);
    procedure ButtonAfileClick(Sender: TObject);
    procedure ButtonBfileClick(Sender: TObject);
    procedure ButtonAlbedo0Click(Sender: TObject);
    procedure ButtonAlbedo1Click(Sender: TObject);
    procedure ButtonAlbedo2Click(Sender: TObject);
    procedure ButtonAlbedo3Click(Sender: TObject);
    procedure ButtonAlbedo4Click(Sender: TObject);
    procedure ButtonAlbedo5Click(Sender: TObject);
    procedure EditHeaderA0Change(Sender: TObject);
    procedure EditXColA0Change(Sender: TObject);
    procedure EditYColA0Change(Sender: TObject);
    procedure EditHeaderA1Change(Sender: TObject);
    procedure EditXColA1Change(Sender: TObject);
    procedure EditYColA1Change(Sender: TObject);
    procedure EditHeaderA5Change(Sender: TObject);
    procedure EditHeaderA2Change(Sender: TObject);
    procedure EditHeaderA3Change(Sender: TObject);
    procedure EditHeaderA4Change(Sender: TObject);
    procedure EditXColA2Change(Sender: TObject);
    procedure EditXColA3Change(Sender: TObject);
    procedure EditXColA4Change(Sender: TObject);
    procedure EditXColA5Change(Sender: TObject);
    procedure EditYColA2Change(Sender: TObject);
    procedure EditYColA3Change(Sender: TObject);
    procedure EditYColA4Change(Sender: TObject);
    procedure EditYColA5Change(Sender: TObject);
  private
    input         : single;
    error         : integer;
    fl_aph_C      : boolean;
    fl_Y_exp      : boolean;
    fl_bX_file    : boolean;
    fl_bX_linear  : boolean;
    fl_CLisCP     : boolean;
    fl_norm_NAP   : boolean;
    fl_norm_Y     : boolean;
    fl_calc_rho_ds : boolean;
    fl_fresnel_sun : boolean;
    fl_use_Ed     : boolean;
    fl_use_E_d    : boolean;
    fl_use_Ls     : boolean;
    fl_use_R      : boolean;
    fl_wv_Surf    : boolean;
    fl_fluo       : boolean;
    AFileHeader   : word;
    AFileXCol     : word;
    AFileYCol     : word;
    BFileHeader   : word;
    BFileXCol     : word;
    BFileYCol     : word;
    YFileHeader   : word;
    YFileXCol     : word;
    YFileYCol     : word;
    DFileHeader   : word;
    DFileXCol     : word;
    DFileYCol     : word;
    EdHeader      : word;
    EdXCol        : word;
    EdYCol        : word;
    LsHeader      : word;
    LsXCol        : word;
    LsYCol        : word;
    RHeader       : word;
    RXCol         : word;
    RYCol         : word;
    bLFileHeader  : word;
    bLFileXCol    : word;
    bLFileYCol    : word;
    bPhyFileHeader: word;
    bPhyFileXCol  : word;
    bPhyFileYCol  : word;
    albedoHeader  : array[0..5]of word;
    albedoXCol    : array[0..5]of word;
    albedoYCol    : array[0..5]of word;
    t_Name_YFile  : String;
    t_Name_AFile  : String;
    t_Name_BFile  : String;
    t_Name_DFile  : String;
    t_Name_Ed     : String;
    t_Name_Ls     : String;
    t_Name_R      : String;
    t_Name_bLFile : String;
    t_Name_bPhyFile : String;
    t_Name_albedo : array[0..5]of string;
    t_Model_Ed    : byte;
    t_Model_R     : byte;
    t_Model_f     : byte;
    t_Model_R_rsB : byte;
    t_Model_R_rsA : byte;
    t_Model_f_rs  : byte;
    t_Model_Kdd   : byte;
    t_Lambda_L    : integer;
    t_Lambda_S    : integer;
    t_bbL_A       : double;
    t_bbL_B       : double;
    t_bX          : double;
    t_bbX         : double;
    t_bMie        : double;
    t_bbMie       : double;
    t_bbW500      : double;
    t_Lambda_0    : integer;
    t_bottom_fill : shortInt;
    t_BRDF        : array[0..5]of double;
    t_SfA_min     : double;
    t_SfA_max     : double;
    t_RH          : double;
    t_AM          : double;
    t_P           : double;
    t_chl_0       : double;
    t_chl_sig     : double;
    t_PAR_min     : integer;
    t_PAR_max     : integer;
    t_day         : integer;
    t_pEd         : integer;
    t_ld          : double;
    t_ldd         : double;
    t_ldda        : double;
    t_lddb        : double;
    t_lds0        : double;
    t_lds1        : double;
    t_rho_dd      : double;
    t_rho_ds      : double;
    t_rho_u       : double;
    t_rho_Ed      : double;
    t_E_min       : integer;
    t_E_max       : integer;
    t_dsmpl       : integer;
  public
  end;

var
  Form_Models: TForm_Models;

implementation

{$R *.lfm}

procedure TForm_Models.FormCreate(Sender: TObject);
begin
    Font.Height:=round(Font.Height/GUI_scale);
    Font.Size:=round(Font.Size/GUI_scale);
(*    Height:=746;
    Width:=753;
    if GUI_scale>1 then begin
        width:=round(width*GUI_scale);
        height:=round(height*GUI_scale);
        ClientWidth:=round(ClientWidth*GUI_scale);
        ClientHeight:=round(ClientHeight*GUI_scale);
        end;      *)
    define_temp_parameters(Sender);
    update_parameterlist(Sender);
    end;

procedure TForm_Models.GroupAtmosClick(Sender: TObject);
begin

end;

procedure TForm_Models.EditHeaderbLChange(Sender: TObject);
begin

end;

procedure TForm_Models.GroupBoxPhyClick(Sender: TObject);
begin

end;

procedure TForm_Models.GroupYClick(Sender: TObject);
begin

end;

procedure TForm_Models.Group_KdClick(Sender: TObject);
begin

end;

procedure TForm_Models.PageControllChange(Sender: TObject);
begin

end;

procedure TForm_Models.Static_ldClick(Sender: TObject);
begin

end;

procedure TForm_Models.TextFilename_bPhyClick(Sender: TObject);
begin

end;

procedure TForm_Models.TextLambdaLClick(Sender: TObject);
begin

end;

procedure TForm_Models.update_rho_dd(Sender: TObject);
begin
    if flag_panel_fw then begin
        if fl_fresnel_sun then t_rho_dd:=Fresnel(sun.fw)
                          else t_rho_dd:=rho_dd.fw;
        end
    else begin
        if fl_fresnel_sun then t_rho_dd:=Fresnel(sun.actual)
                          else t_rho_dd:=rho_dd.actual;
        end;
    end;

procedure TForm_Models.update_rho_ds(Sender: TObject);
begin
    if flag_panel_fw then begin
        if fl_calc_rho_ds then t_rho_ds:=rho_diffuse(sun.fw*pi/180)
                          else t_rho_ds:=rho_ds.fw;
        end
    else begin
        if fl_calc_rho_ds then t_rho_ds:=rho_diffuse(sun.actual*pi/180)
                          else t_rho_ds:=rho_ds.actual;
        end;
    end;

procedure TForm_Models.define_temp_parameters(Sender: TObject);
var i : integer;
begin
    fl_Y_exp      :=flag_Y_exp;
    fl_aph_C      :=flag_aph_C;
    fl_bX_file    :=flag_bX_file;
    fl_bX_linear  :=flag_bX_linear;
    fl_CLisCP     :=flag_CXisC0;
    fl_norm_NAP   :=flag_norm_NAP;
    fl_norm_Y     :=flag_norm_Y;
    if flag_b_Invert then fl_wv_Surf:=flag_surf_inv
                     else fl_wv_Surf:=flag_surf_fw;
    fl_fluo       :=flag_fluo;
    fl_calc_rho_ds:=flag_calc_rho_ds;
    fl_Fresnel_sun:=flag_Fresnel_sun;
    fl_use_Ed     :=flag_use_Ed;
    fl_use_E_d    :=flag_use_Ls and not fl_wv_Surf;
    fl_use_Ls     :=flag_use_Ls and fl_wv_Surf;;
    fl_use_R      :=flag_use_R;
    t_Model_R     :=Model_R;
    t_Model_Ed    :=Model_Ed;
    t_Model_f     :=Model_f;
    t_Model_R_rsB :=Model_R_rsB;
    t_Model_R_rsA :=Model_R_rsA;
    t_Model_f_rs  :=Model_f_rs;
    t_Model_Kdd   :=Model_Kdd;
    t_Name_YFile  :=aY^.FName;
    t_Name_AFile  :=aphA^.FName;
    t_Name_BFile  :=aphB^.FName;
    t_Name_DFile  :=aNAP^.FName;
    t_Name_Ed     :=Ed^.FName;
    t_Name_Ls     :=Ls^.FName;
    t_Name_R      :=R^.FName;
    t_Name_bLFile :=bXN^.FName;
    t_Name_bPhyFile :=bPhyN^.FName;
    for i:=0 to 5 do begin
        t_Name_albedo[i]:=albedo[i]^.FName;
        albedoHeader[i] :=albedo[i]^.Header;
        albedoXCol[i]   :=albedo[i]^.XColumn;
        albedoYCol[i]   :=albedo[i]^.YColumn;
        end;
    t_Lambda_L    :=round(Lambda_L);
    t_Lambda_S    :=round(Lambda_S);
    t_Lambda_0    :=round(Lambda_0);
    t_bbL_A       :=bbX_A;
    t_bbL_B       :=bbX_B;
    t_bbX         :=bb_X;
    t_bbMie       :=bb_Mie;
    t_bX          :=b_X;
    t_bMie        :=b_Mie;
    t_bbW500      :=bbW500;
    t_rho_Ed      :=rho_Ed;
    t_bottom_fill :=bottom_fill;
    YFileHeader   :=aY^.Header;
    YFileXCol     :=aY^.XColumn;
    YFileYCol     :=aY^.YColumn;
    AFileHeader   :=aphA^.Header;
    AFileXCol     :=aphA^.XColumn;
    AFileYCol     :=aphA^.YColumn;
    BFileHeader   :=aphB^.Header;
    BFileXCol     :=aphB^.XColumn;
    BFileYCol     :=aphB^.YColumn;
    DFileHeader   :=aNAP^.Header;
    DFileXCol     :=aNAP^.XColumn;
    DFileYCol     :=aNAP^.YColumn;
    EdHeader      :=Ed^.Header;
    EdXCol        :=Ed^.XColumn;
    EdYCol        :=Ed^.YColumn;
    LsHeader      :=Ls^.Header;
    LsXCol        :=Ls^.XColumn;
    LsYCol        :=Ls^.YColumn;
    RHeader       :=R^.Header;
    RXCol         :=R^.XColumn;
    RYCol         :=R^.YColumn;
    bLFileHeader  :=bXN^.Header;
    bLFileXCol    :=bXN^.XColumn;
    bLFileYCol    :=bXN^.YColumn;
    bPhyFileHeader:=bPhyN^.Header;
    bPhyFileXCol  :=bPhyN^.XColumn;
    bPhyFileYCol  :=bPhyN^.YColumn;
    EditAFile.Text:=t_Name_AFile;
    EditBFile.Text:=t_Name_BFile;
    EditYFile.Text:=t_Name_YFile;
    EditDFile.Text:=t_Name_DFile;
    EditbLFile.Text:=t_Name_bLFile;
    EditbPhyFile.Text:=t_Name_bPhyFile;
    Edit_FnBottom0.Text:=t_Name_albedo[0];
    Edit_FnBottom1.Text:=t_Name_albedo[1];
    Edit_FnBottom2.Text:=t_Name_albedo[2];
    Edit_FnBottom3.Text:=t_Name_albedo[3];
    Edit_FnBottom4.Text:=t_Name_albedo[4];
    Edit_FnBottom5.Text:=t_Name_albedo[5];
    for i:=0 to 5 do t_BRDF[i]:=BRDF[i];
    t_SfA_min      :=SfA_min;
    t_SfA_max      :=SfA_max;
    t_RH           :=RH;
    t_AM           :=AM;
    t_P            :=GC_P;
    t_chl_0        :=Lambda_f0;
    t_chl_sig      :=Sigma_f0;
    t_PAR_min      :=PAR_min;
    t_PAR_max      :=PAR_max;
    t_ld           :=ld;
    t_ldd          :=ldd;
    t_ldda         :=ldda;
    t_lddb         :=lddb;
    t_lds0         :=lds0;
    t_lds1         :=lds1;
    t_day          :=day;
    t_pEd          :=p_Ed;
    t_E_min        :=Lmin;
    t_E_max        :=Lmax;
    t_dsmpl        :=dsmpl;
    t_rho_u        :=rho_Eu;
    if t_E_min<MinX then t_E_min:=MinX;
    if t_E_max>MaxX then t_E_max:=MaxX;
    update_rho_dd(Sender);
    update_rho_ds(Sender);
    Edit_rho_dd.Enabled:=not fl_fresnel_sun;
    Edit_rho_ds.enabled:=not fl_calc_rho_ds;
    Static_rho_ds.Enabled:=fl_calc_rho_ds;
    RadioGroupfrs.Visible:=t_Model_R_rsB<2;
    GroupR.Visible:=(t_Model_R_rsA>0) or (t_Model_R_rsB=2);
    end;

procedure TForm_Models.set_temp_parameters(Sender: TObject);
var ok       : byte;    {0: ok, 1: file not found, 2: y=constant }
    ch, i, k : word;
    SS       : double;
begin
    if flag_b_Invert then flag_surf_inv:=fl_wv_Surf
                     else flag_surf_fw:=fl_wv_Surf;
    flag_fluo      :=fl_fluo;
    flag_Y_exp     :=fl_Y_exp;
    flag_aph_C     :=fl_aph_C;
    flag_bX_file   :=fl_bX_file;
    flag_bX_linear :=fl_bX_linear;
    flag_CXisC0    :=fl_CLisCP;
    flag_norm_NAP  :=fl_norm_NAP;
    flag_norm_Y    :=fl_norm_Y;
    flag_Fresnel_sun :=fl_Fresnel_sun;
    flag_calc_rho_ds :=fl_calc_rho_ds;
    flag_use_Ed    :=fl_use_Ed;
    flag_use_Ls    :=fl_use_Ls or fl_use_E_d;
    flag_use_R     :=fl_use_R;
    Model_Ed       :=t_Model_Ed;
    Model_R        :=t_Model_R;
    Model_f        :=t_Model_f;
    Model_R_rsB    :=t_Model_R_rsB;
    Model_R_rsA    :=t_Model_R_rsA;
    Model_f_rs     :=t_Model_f_rs;
    Model_Kdd      :=t_Model_Kdd;
    aY^.FName      :=t_Name_YFile;
    aY^.Header     :=YFileHeader;
    aY^.XColumn    :=YFileXCol;
    aY^.YColumn    :=YFileYCol;
    aphA^.FName    :=t_Name_AFile;
    aphA^.Header   :=AFileHeader;
    aphA^.XColumn  :=AFileXCol;
    aphA^.YColumn  :=AFileYCol;
    aphB^.FName    :=t_Name_BFile;
    aphB^.Header   :=BFileHeader;
    aphB^.XColumn  :=BFileXCol;
    aphB^.YColumn  :=BFileYCol;
    aNAP^.FName    :=t_Name_DFile;
    aNAP^.Header   :=DFileHeader;
    aNAP^.XColumn  :=DFileXCol;
    aNAP^.YColumn  :=DFileYCol;
    Ed^.Header     :=EdHeader;
    Ed^.XColumn    :=EdXCol;
    Ed^.YColumn    :=EdYCol;
    Ed^.FName      :=t_Name_Ed;
    Ls^.Header     :=LsHeader;
    Ls^.XColumn    :=LsXCol;
    Ls^.YColumn    :=LsYCol;
    Ls^.FName      :=t_Name_Ls;
    R^.Header      :=RHeader;
    R^.XColumn     :=RXCol;
    R^.YColumn     :=RYCol;
    R^.FName       :=t_Name_R;
    bXN^.FName     :=t_Name_bLFile;
    bXN^.Header    :=bLFileHeader;
    bXN^.XColumn   :=bLFileXCol;
    bXN^.YColumn   :=bLFileYCol;
    Lambda_L       :=t_Lambda_L;
    Lambda_S       :=t_Lambda_S;
    Lambda_0       :=t_Lambda_0;
    bbX_A          :=t_bbL_A;
    bbX_B          :=t_bbL_B;
    bb_X           :=t_bbX;
    bb_Mie         :=t_bbMie;
    b_X            :=t_bX;
    b_Mie          :=t_bMie;
    bbW500         :=t_bbW500;
    rho_Ed         :=t_rho_Ed;
    bottom_fill    :=t_bottom_fill;
    for i:=0 to 5 do begin
        BRDF[i]:=t_BRDF[i];
        albedo[i]^.FName:=t_Name_albedo[i];
        albedo[i]^.Header:=albedoHeader[i];
        albedo[i]^.XColumn:=albedoXCol[i];
        albedo[i]^.YColumn:=albedoYCol[i];;
        end;
    SfA_min        :=t_SfA_min;
    SfA_max        :=t_SfA_max;
    RH             :=round(t_RH);
    AM             :=round(t_AM);
    GC_P           :=t_P;
    Lambda_f0      :=t_chl_0;
    Sigma_f0       :=t_chl_sig;
    PAR_min        :=t_PAR_min;
    PAR_max        :=t_PAR_max;
    if t_E_min<MinX then t_E_min:=MinX;
    if t_E_max>MaxX then t_E_max:=MaxX;
    Lmin           :=t_E_min;
    Lmax           :=t_E_max;
    dsmpl          :=t_dsmpl;
    rho_Eu         :=t_rho_u;

    if flag_panel_fw then begin
        rho_dd.fw :=t_rho_dd;
        rho_ds.fw  :=t_rho_ds;
        end
    else begin
        rho_dd.actual :=t_rho_dd;
        rho_ds.actual  :=t_rho_ds;
        end;
    ld   :=t_ld;
    ldd  :=t_ldd;
    ldda :=t_ldda;
    lddb :=t_lddb;
    lds0 :=t_lds0;
    lds1 :=t_lds1;
    p_Ed :=t_pEd;

    if (t_day>0) and (t_day<=365) then begin
        day := t_day;
        sun_earth:=sqr(1+0.0167*cos(2*pi*(day-3)/365));
        end;

    if flag_panel_fw then SS:=S.fw else SS:=S.actual;
    if flag_Y_exp then berechne_aY(SS) else begin
        ok:=lies_spektrum(aY^, aY^.FName, aY^.XColumn, aY^.YColumn, aY^.Header, ch, false);
        if ok<>1 then x_anpassen(aY^.y, ch, 0);
        if flag_norm_Y then normalize(aY^, Lambda_0);
        end;
    if flag_norm_NAP then normalize(aNAP^, Lambda_0) else begin
        ok:=lies_spektrum(aNAP^, aNAP^.FName, aNAP^.XColumn, aNAP^.YColumn, aNAP^.Header, ch, false);
        if ok<>1 then x_anpassen(aNAP^.y, ch, 0);
        end;
    if flag_bX_file then begin
        ok:=lies_spektrum(bXN^, bXN^.FName, bXN^.XColumn, bXN^.YColumn, bXN^.Header, ch, false);
        if ok<>1 then x_anpassen(bXN^.y, ch, 0);
        end;
    if flag_use_Ed then begin
        ok:=lies_spektrum(Ed^, Ed^.FName, Ed^.XColumn, Ed^.YColumn, Ed^.Header, ch, false);
        if ok<>1 then x_anpassen(Ed^.y, ch, 0);
        if ok<>1 then if flag_mult_Ed then
            for k:=1 to Channel_number do Ed^.y[k]:=Ed_factor * Ed^.y[k];
        end;
    if flag_use_R then begin
        ok:=lies_spektrum(R^, R^.FName, R^.XColumn, R^.YColumn, R^.Header, ch, false);
        if ok<>1 then x_anpassen(R^.y, ch, 0);
        end;
    for i:=0 to 5 do begin
        ok:=lies_spektrum(albedo[i]^, albedo[i]^.FName, albedo[i]^.XColumn,
            albedo[i]^.YColumn, albedo[i]^.Header, ch, false);
        if ok<>1 then x_anpassen(albedo[i]^.y, ch, 0);
        end;
    berechne_bX;
    end;

procedure TForm_Models.update_parameterlist(Sender: TObject);
var S : String;
begin
    GroupC.visible       :=not flag_public;
    CheckCaph.checked    :=fl_aph_C;
    CheckFluo.checked    :=fl_fluo;
    CheckExp.checked     :=fl_Y_exp;
    CheckYFile.checked   :=not fl_Y_exp;
    Check_bFile.checked  :=flag_bX_file;
    Check_Nonlinear.checked:=not fl_bX_linear;
    Check_b_aP.Checked   :=not flag_bX_file;
    CheckNormD.checked   :=fl_norm_NAP;
    Check_rho_dd_Fresnel.checked:=fl_Fresnel_sun;
    Check_rho_ds.checked :=fl_calc_rho_ds;
    CheckEdUseEd.checked :=fl_use_Ed;
    CheckUseLs.Checked   :=fl_use_Ls;
    CheckUseR.Checked    :=fl_use_R;
    CheckWvDependent.Checked:=fl_wv_Surf;
    RadioGroupEd.ItemIndex:=t_Model_Ed;
    RadioGroupR.ItemIndex:=t_Model_R;
    RadioGroupf.ItemIndex:=t_Model_f;
    RadioGroupRrsB.ItemIndex:=t_Model_R_rsB;
    RadioGroupRrsA.ItemIndex:=t_Model_R_rsA;
    RadioGroupfrs.ItemIndex:=t_Model_f_rs;
    RadioGroup_Kdd.ItemIndex:=t_Model_Kdd;
    RadioGroupBottom.ItemIndex:=t_bottom_fill+1;
    str(AFileHeader, S);    EditHeaderA.Text:=S;
    str(AFileXCol, S);      EditXColA.Text:=S;
    str(AFileYCol, S);      EditYColA.Text:=S;
    str(BFileHeader, S);    EditHeaderB.Text:=S;
    str(BFileXCol, S);      EditXColB.Text:=S;
    str(BFileYCol, S);      EditYColB.Text:=S;
    str(YFileHeader, S);    EditHeaderY.Text:=S;
    str(YFileXCol, S);      EditXColY.Text:=S;
    str(YFileYCol, S);      EditYColY.Text:=S;
    str(DFileHeader, S);    EditHeaderD.Text:=S;
    str(DFileXCol, S);      EditXColD.Text:=S;
    str(DFileYCol, S);      EditYColD.Text:=S;
    str(bLFileHeader, S);   EditHeaderbL.Text:=S;
    str(bLFileXCol, S);     EditXColbL.Text:=S;
    str(bLFileYCol, S);     EditYColbL.Text:=S;
    str(bPhyFileHeader, S); EditHeaderbPhy.Text:=S;
    str(bPhyFileXCol, S);   EditXColbPhy.Text:=S;
    str(bPhyFileYCol, S);   EditYColbPhy.Text:=S;
    str(EdHeader, S);       EditHeaderEd.Text:=S;
                            EditHeaderE_d.Text:=S;
    str(EdXCol, S);         EditXColEd.Text:=S;
                            EditXColE_d.Text:=S;
    str(EdYCol, S);         EditYColEd.Text:=S;
                            EditYColE_d.Text:=S;
    str(LsHeader, S);       EditHeaderLs.Text:=S;
    str(LsXCol, S);         EditXColLs.Text:=S;
    str(LsYCol, S);         EditYColLs.Text:=S;
    str(RHeader, S);        EditHeaderR.Text:=S;
    str(RXCol, S);          EditXColR.Text:=S;
    str(RYCol, S);          EditYColR.Text:=S;

    str(albedoHeader[0], S);  EditHeaderA0.Text:=S;
    str(albedoXCol[0], S);    EditXColA0.Text:=S;
    str(albedoYCol[0], S);    EditYColA0.Text:=S;
    str(albedoHeader[1], S);  EditHeaderA1.Text:=S;
    str(albedoXCol[1], S);    EditXColA1.Text:=S;
    str(albedoYCol[1], S);    EditYColA1.Text:=S;
    str(albedoHeader[2], S);  EditHeaderA2.Text:=S;
    str(albedoXCol[2], S);    EditXColA2.Text:=S;
    str(albedoYCol[2], S);    EditYColA2.Text:=S;
    str(albedoHeader[3], S);  EditHeaderA3.Text:=S;
    str(albedoXCol[3], S);    EditXColA3.Text:=S;
    str(albedoYCol[3], S);    EditYColA3.Text:=S;
    str(albedoHeader[4], S);  EditHeaderA4.Text:=S;
    str(albedoXCol[4], S);    EditXColA4.Text:=S;
    str(albedoYCol[4], S);    EditYColA4.Text:=S;
    str(albedoHeader[5], S);  EditHeaderA5.Text:=S;
    str(albedoXCol[5], S);    EditXColA5.Text:=S;
    str(albedoYCol[5], S);    EditYColA5.Text:=S;


    Edit_rho_Ed.Text:=schoen(t_rho_Ed, 3);
    if CheckCaph.checked then active_aph(Sender)
                         else inactive_aph(Sender);
    if CheckYFile.checked then active_FilePar(Sender)
                          else inactive_FilePar(Sender);
    if Check_bFile.checked then active_FilebLPar(Sender)
                           else inactive_FilebLPar(Sender);
    if Check_Nonlinear.Checked then active_Linear(Sender)
                           else inactive_Linear(Sender);
    EditLambdaL.Text:=IntToStr(round(Lambda_L));
    EditLambdaS.Text:=IntToStr(round(Lambda_S));
    EditDLambda0.Text:=IntToStr(t_Lambda_0);
    EditYLambda0.Text:=IntToStr(t_Lambda_0);
    EditPower.Text  :=schoen(t_bbL_B, 3);
    if fl_bX_linear then
        EditbbX.Text :=schoen(t_bbX, 3) else
        EditbbX.Text :=schoen(t_bbL_A, 3);
    EditbX.Text  :=schoen(t_bX, 3);
    EditbbMie.Text  :=schoen(t_bbMie, 3);
    EditbMie.Text   :=schoen(t_bMie, 3);
    Editbb1.Text    :=schoen(t_bbW500, 3);
    Edit_BRDF0.Text :=schoen(BRDF[0], 3);
    Edit_BRDF1.Text :=schoen(BRDF[1], 3);
    Edit_BRDF2.Text :=schoen(BRDF[2], 3);
    Edit_BRDF3.Text :=schoen(BRDF[3], 3);
    Edit_BRDF4.Text :=schoen(BRDF[4], 3);
    Edit_BRDF5.Text :=schoen(BRDF[5], 3);
    Edit_sum_min.Text:=schoen(t_SfA_min, 3);
    Edit_sum_max.Text:=schoen(t_SfA_max, 3);
    EditEdFile.Text :=t_Name_Ed;
    EditE_dFile.Text:=t_Name_Ed;
    EditLsFile.Text :=t_Name_Ls;
    EditRFile.Text  :=t_Name_R;
    Edit_Integral_min.Text:=IntToStr(t_E_min);
    Edit_Integral_max.Text:=IntToStr(t_E_max);
    Edit_dsmpl.Text :=IntToStr(t_dsmpl);
    update_E_texts(Sender);
    Edit_RH.Text    :=schoen(t_RH, 0);
    Edit_AM.Text    :=schoen(t_AM, 0);
    Edit_P.Text     :=schoen(t_P,  6);
    Edit_M.Text     :=schoen(GC_M,6);
    Edit_MM.Text    :=schoen(GC_M*GC_P/1013.25,6);
    Edit_Moz.Text   :=schoen(M_oz,6);
    Edit_V.Text     :=schoen(3.91*H_a/rel_max(beta.fw,nenner_min),3);
    Edit_chl_0.Text :=schoen(t_chl_0, 4);
    Edit_chl_sig.Text :=schoen(t_chl_sig, 4);
    Edit_PAR_min.Text :=schoen(t_PAR_min, 0);
    Edit_PAR_max.Text :=schoen(t_PAR_max,0 );
    Edit_ld.Text      :=schoen(t_ld, 5);
    Edit_ldd.Text    :=schoen(t_ldd, 5);
    Edit_ldda.Text    :=schoen(t_ldda, 5);
    Edit_lddb.Text    :=schoen(t_lddb, 5);
    Edit_lds0.Text    :=schoen(t_lds0, 5);
    Edit_lds1.Text    :=schoen(t_lds1, 4);
    Edit_day.Text     :=IntToStr(t_day);
    Edit_pEd.Text     :=IntToStr(t_pEd);
    Edit_rho_dd.Text  :=schoen(t_rho_dd, 4);
    Edit_rho_ds.Text  :=schoen(t_rho_ds, 4);
    Edit_rho_u.Text   :=schoen(t_rho_u, 4);
    Edit_chl_FWHM.Text:=schoen(t_chl_sig*FWHM_sigma, 3);
    TextDLambda0.visible:=fl_norm_NAP;
    EditDLambda0.visible:=fl_norm_NAP;
    InActivateEd(Sender);
    InActivateE_d(Sender);
    InActivateLs(Sender);
    InActivateR(Sender);
    InActivate_ld(Sender);
    InActivateFluo(Sender);
    end;

procedure TForm_Models.update_E_texts(Sender: TObject);
begin
    Edit_Integral_Ed.Text:=schoen(Integral(Ed^, t_E_min, t_E_max)/1000,3);
    Edit_Integral_Edd.Text:=schoen(Integral(GC_Edd^, t_E_min, t_E_max)/1000,3);
    Edit_Integral_Eds.Text:=schoen(Integral(GC_Eds^, t_E_min, t_E_max)/1000,3);
    end;

procedure TForm_Models.active_aph(Sender: TObject);
begin
    Text_eq_a.visible:=TRUE;
    TextABfiles.enabled:=TRUE;
    TextAfile.enabled:=TRUE;
    TextBfile.enabled:=TRUE;
    TextAheader.enabled:=TRUE;
    TextBheader.enabled:=TRUE;
    ButtonAfile.enabled:=TRUE;
    ButtonBfile.enabled:=TRUE;
    end;

procedure TForm_Models.inactive_aph(Sender: TObject);
begin
    Text_eq_a.visible:=FALSE;
    TextABfiles.enabled:=FALSE;
    TextAfile.enabled:=FALSE;
    TextBfile.enabled:=FALSE;
    TextAheader.enabled:=FALSE;
    TextBheader.enabled:=FALSE;
    ButtonAfile.enabled:=FALSE;
    ButtonBfile.enabled:=FALSE;
    end;

procedure TForm_Models.inactive_FilePar(Sender: TObject);
begin
    Text_FileY.enabled:=FALSE;
    Text_YHeader.enabled:=FALSE;
    ButtonYFile.enabled:=FALSE;
    EditHeaderY.enabled:=FALSE;
    EditXColY.enabled:=FALSE;
    EditYColY.enabled:=FALSE;
    end;

procedure TForm_Models.active_FilePar(Sender: TObject);
begin
    Text_FileY.enabled:=TRUE;
    Text_YHeader.enabled:=TRUE;
    ButtonYFile.enabled:=TRUE;
    EditHeaderY.enabled:=TRUE;
    EditXColY.enabled:=TRUE;
    EditYColY.enabled:=TRUE;
    end;

procedure TForm_Models.active_FilebLPar(Sender: TObject);
begin
    Text2Filename.enabled:=TRUE;
    Text2Header.enabled:=TRUE;
    ButtonbLFile.enabled:=TRUE;
    end;

procedure TForm_Models.inactive_FilebLPar(Sender: TObject);
begin
    Text2Filename.enabled:=FALSE;
    Text2Header.enabled:=FALSE;
    ButtonbLFile.enabled:=FALSE;
    end;

procedure TForm_Models.active_Linear(Sender: TObject);
begin
    TextPower.visible:=TRUE;
    EditPower.visible:=TRUE;
    end;

procedure TForm_Models.inactive_Linear(Sender: TObject);
begin
    TextPower.visible:=FALSE;
    EditPower.visible:=FALSE;
    TextLambdaL.visible:=TRUE;
    EditLambdaL.visible:=TRUE;
    end;

procedure TForm_Models.InActivateE_d(Sender: TObject);
begin
    TextFileE_d.Enabled:=fl_use_E_d;
    ButtonE_dFile.Enabled:=fl_use_E_d;
    TextHeaderE_d.Enabled:=fl_use_E_d;
    EditHeaderE_d.Enabled:=fl_use_E_d;
    EditXColE_d.Enabled:=fl_use_E_d;
    EditYColE_d.Enabled:=fl_use_E_d;
    CheckUseEd.checked:=fl_use_E_d;
    end;

procedure TForm_Models.InActivateEd(Sender: TObject);
begin
    TextFileEd.Enabled:=fl_use_Ed;
    ButtonEdFile.Enabled:=fl_use_Ed;
    TextHeaderEd.Enabled:=fl_use_Ed;
    EditHeaderEd.Enabled:=fl_use_Ed;
    EditXColEd.Enabled:=fl_use_Ed;
    EditYColEd.Enabled:=fl_use_Ed;
    CheckEdUseEd.checked:=fl_use_Ed;
    end;

procedure TForm_Models.InActivateLs(Sender: TObject);
begin
    TextFileLs.Enabled:=fl_use_Ls;
    ButtonLsFile.Enabled:=fl_use_Ls;
    TextHeaderLs.Enabled:=fl_use_Ls;
    EditHeaderLs.Enabled:=fl_use_Ls;
    EditXColLs.Enabled:=fl_use_Ls;
    EditYColLs.Enabled:=fl_use_Ls;
    CheckUseLs.checked:=fl_use_Ls;
    end;

procedure TForm_Models.InActivateR(Sender: TObject);
begin
    TextFileR.Enabled:=fl_use_R;
    ButtonRFile.Enabled:=fl_use_R;
    TextHeaderR.Enabled:=fl_use_R;
    EditHeaderR.Enabled:=fl_use_R;
    EditXColR.Enabled:=fl_use_R;
    EditYColR.Enabled:=fl_use_R;
    CheckUseR.checked:=fl_use_R;
    end;

procedure TForm_Models.InActivate_ld(Sender: TObject);
begin
    //Group_Kd.Enabled  :=RadioGroupEd.ItemIndex=0;
    Static_ld.Enabled :=FALSE;
    Edit_ld.Enabled :=FALSE;
    Group_Kdd.Enabled :=RadioGroupEd.ItemIndex=1;
    Group_Kds.Enabled :=RadioGroupEd.ItemIndex=1;
    end;

procedure TForm_Models.InActivateFluo(Sender: TObject);
begin
    Text_center.Enabled   := fl_fluo;
    Text_width.Enabled    := fl_fluo;
    Text_PAR.Enabled      := fl_fluo;
    Edit_chl_0.Enabled    := fl_fluo;
    Edit_chl_sig.Enabled  := fl_fluo;
    Edit_chl_FWHM.Enabled := fl_fluo;
    Edit_PAR_min.Enabled  := fl_fluo;
    Edit_PAR_max.Enabled  := fl_fluo;
    end;

procedure TForm_Models.ButtonOKClick(Sender: TObject);
begin
    ModalResult := mrOK;
    end;

procedure TForm_Models.ButtonCancelClick(Sender: TObject);
begin
    ModalResult := mrCancel;
    end;

procedure TForm_Models.CheckExpClick(Sender: TObject);
begin
    fl_Y_exp:=CheckExp.checked;
    CheckYFile.checked:=not fl_Y_exp;
    if CheckYFile.checked then active_FilePar(Sender)
                          else inactive_FilePar(Sender);
    end;

procedure TForm_Models.CheckYFileClick(Sender: TObject);
begin
    fl_Y_exp:=not CheckYFile.checked;
    CheckExp.checked:=fl_Y_exp;
    if CheckYFile.checked then active_FilePar(Sender)
                          else inactive_FilePar(Sender);
    end;

procedure TForm_Models.ButtonYFileClick(Sender: TObject);
var old_extension : String;
begin
    old_extension:='*'+ExtractFileExt(aY^.FName);
    OpenDialog1.InitialDir := ExtractFilePath(aY^.FName);
    OpenDialog1.FileName:=aY^.FName;
    OpenDialog1.Title := 'Load Gelbstoff file';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';
    if OpenDialog1.Execute then
        t_Name_YFile:=OpenDialog1.FileName;
    EditYFile.text:=t_Name_YFile;
    EditYFile.refresh;
    end;

procedure TForm_Models.ButtonDFileClick(Sender: TObject);
var old_extension : String;
begin
    old_extension:='*'+ExtractFileExt(aNAP^.FName);
    OpenDialog1.InitialDir := ExtractFilePath(aNAP^.FName);
    OpenDialog1.FileName:=aNAP^.FName;
    OpenDialog1.Title := 'Load NAP file';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';
    if OpenDialog1.Execute then
        t_Name_DFile:=OpenDialog1.FileName;
    EditDFile.text:=t_Name_DFile;
    EditDFile.refresh;
    end;

procedure TForm_Models.EditHeaderYChange(Sender: TObject);
begin
    val(EditHeaderY.Text, input, error);
    if error=0 then YFileHeader:=round(input);
    end;

procedure TForm_Models.EditXColYChange(Sender: TObject);
begin
    val(EditXColY.Text, input, error);
    if error=0 then YFileXcol:=round(input);
    end;

procedure TForm_Models.EditYColYChange(Sender: TObject);
begin
    val(EditYColY.Text, input, error);
    if error=0 then YFileYcol:=round(input);
    end;

procedure TForm_Models.CheckNormDClick(Sender: TObject);
begin
    fl_norm_NAP:=CheckNormD.checked;
    TextDLambda0.visible:=fl_norm_NAP;
    EditDLambda0.visible:=fl_norm_NAP;
    end;

procedure TForm_Models.RadioGroupRClick(Sender: TObject);
begin
    t_Model_R:=RadioGroupR.ItemIndex;
    if t_Model_R_rsB<2 then begin
        t_Model_R_rsB:=t_Model_R;
        RadioGroupRrsB.ItemIndex:=t_Model_R_rsB;
        end;
    end;

procedure TForm_Models.RadioGroupfClick(Sender: TObject);
begin
    t_Model_f:=RadioGroupf.ItemIndex;
    end;

procedure TForm_Models.EditLambdaLChange(Sender: TObject);
begin
    val(EditLambdaL.Text, input, error);
    if error=0 then t_Lambda_L:=round(input);
    end;

procedure TForm_Models.Check_bFileClick(Sender: TObject);
begin
    fl_bX_file:=Check_bFile.checked;
    Check_b_aP.checked:=not fl_bX_file;
    if Check_bFile.checked then active_FilebLPar(Sender)
                           else inactive_FilebLPar(Sender);
    end;

procedure TForm_Models.Check_b_aPClick(Sender: TObject);
begin
    fl_bX_file:=not Check_b_aP.checked;
    Check_bFile.checked:=fl_bX_file;
    if Check_bFile.checked then active_FilebLPar(Sender)
                           else inactive_FilebLPar(Sender);
    end;

procedure TForm_Models.EditbbXChange(Sender: TObject);
begin
    val(EditbbX.Text, input, error);
    if error=0 then begin
        if fl_bX_linear then t_bbX:=input
                        else t_bbL_A:=input;
        end;
    end;

procedure TForm_Models.EditLambdaSChange(Sender: TObject);
begin
    val(EditLambdaS.Text, input, error);
    if error=0 then t_Lambda_S:=round(input);
    end;

procedure TForm_Models.EditbbMieChange(Sender: TObject);
begin
    val(EditbbMie.Text, input, error);
    if error=0 then t_bbMie:=input;
    end;

procedure TForm_Models.Check_NonlinearClick(Sender: TObject);
begin
    fl_bX_linear:=not Check_Nonlinear.checked;
    if fl_bX_linear then
        EditbbX.Text :=schoen(t_bbX, 3) else
        EditbbX.Text :=schoen(t_bbL_A, 3);
    if Check_Nonlinear.Checked then active_Linear(Sender)
                               else inactive_Linear(Sender);
    end;

procedure TForm_Models.EditPowerChange(Sender: TObject);
begin
    val(EditPower.Text, input, error);
    if error=0 then t_bbL_B:=input;
    end;

procedure TForm_Models.Check_CLisCPClick(Sender: TObject);
begin
    end;

procedure TForm_Models.EditDLambda0Change(Sender: TObject);
begin
    val(EditDLambda0.Text, input, error);
    if error=0 then t_Lambda_0:=round(input);
    EditYLambda0.Text:=IntToStr(t_Lambda_0);
    end;

procedure TForm_Models.EditYLambda0Change(Sender: TObject);
begin
    val(EditYLambda0.Text, input, error);
    if error=0 then t_Lambda_0:=round(input);
    EditDLambda0.Text:=IntToStr(t_Lambda_0);
    end;

procedure TForm_Models.EditHeaderA0Change(Sender: TObject);
begin
    val(EditHeaderA0.Text, input, error);
    if error=0 then albedoHeader[0]:=round(input);
    end;

procedure TForm_Models.EditHeaderA1Change(Sender: TObject);
begin
    val(EditHeaderA1.Text, input, error);
    if error=0 then albedoHeader[1]:=round(input);
    end;

procedure TForm_Models.EditHeaderA2Change(Sender: TObject);
begin
    val(EditHeaderA2.Text, input, error);
    if error=0 then albedoHeader[2]:=round(input);
    end;

procedure TForm_Models.EditHeaderA3Change(Sender: TObject);
begin
    val(EditHeaderA3.Text, input, error);
    if error=0 then albedoHeader[3]:=round(input);
    end;

procedure TForm_Models.EditHeaderA4Change(Sender: TObject);
begin
    val(EditHeaderA4.Text, input, error);
    if error=0 then albedoHeader[4]:=round(input);
    end;

procedure TForm_Models.EditHeaderA5Change(Sender: TObject);
begin
    val(EditHeaderA5.Text, input, error);
    if error=0 then albedoHeader[5]:=round(input);
    end;

procedure TForm_Models.EditHeaderDChange(Sender: TObject);
begin
    val(EditHeaderD.Text, input, error);
    if error=0 then DFileHeader:=round(input);
    end;

procedure TForm_Models.EditXColA0Change(Sender: TObject);
begin
    val(EditXColA0.Text, input, error);
    if error=0 then albedoXCol[0]:=round(input);
    end;

procedure TForm_Models.EditXColA1Change(Sender: TObject);
begin
    val(EditXColA1.Text, input, error);
    if error=0 then albedoXCol[1]:=round(input);
    end;

procedure TForm_Models.EditXColA2Change(Sender: TObject);
begin
    val(EditXColA2.Text, input, error);
    if error=0 then albedoXCol[2]:=round(input);
    end;

procedure TForm_Models.EditXColA3Change(Sender: TObject);
begin
    val(EditXColA3.Text, input, error);
    if error=0 then albedoXCol[3]:=round(input);
    end;

procedure TForm_Models.EditXColA4Change(Sender: TObject);
begin
    val(EditXColA4.Text, input, error);
    if error=0 then albedoXCol[4]:=round(input);
    end;

procedure TForm_Models.EditXColA5Change(Sender: TObject);
begin
    val(EditXColA5.Text, input, error);
    if error=0 then albedoXCol[5]:=round(input);
    end;

procedure TForm_Models.EditXColDChange(Sender: TObject);
begin
    val(EditXColD.Text, input, error);
    if error=0 then DFileXcol:=round(input);
    end;

procedure TForm_Models.EditYColA0Change(Sender: TObject);
begin
    val(EditYColA0.Text, input, error);
    if error=0 then albedoYCol[0]:=round(input);
    end;

procedure TForm_Models.EditYColA1Change(Sender: TObject);
begin
    val(EditYColA1.Text, input, error);
    if error=0 then albedoYCol[1]:=round(input);
    end;

procedure TForm_Models.EditYColA2Change(Sender: TObject);
begin
    val(EditYColA2.Text, input, error);
    if error=0 then albedoYCol[2]:=round(input);
    end;

procedure TForm_Models.EditYColA3Change(Sender: TObject);
begin
    val(EditYColA3.Text, input, error);
    if error=0 then albedoYCol[3]:=round(input);
    end;

procedure TForm_Models.EditYColA4Change(Sender: TObject);
begin
    val(EditYColA4.Text, input, error);
    if error=0 then albedoYCol[4]:=round(input);
    end;

procedure TForm_Models.EditYColA5Change(Sender: TObject);
begin
    val(EditYColA5.Text, input, error);
    if error=0 then albedoYCol[5]:=round(input);
    end;

procedure TForm_Models.EditYColDChange(Sender: TObject);
begin
    val(EditYColD.Text, input, error);
    if error=0 then DFileYcol:=round(input);
    end;

procedure TForm_Models.RadioGroupBottomClick(Sender: TObject);
begin
    t_bottom_fill:=RadioGroupBottom.ItemIndex-1;
    end;

procedure TForm_Models.Edit_BRDF0Change(Sender: TObject);
begin
    val(Edit_BRDF0.Text, input, error);
    if error=0 then t_BRDF[0]:=input;
    end;

procedure TForm_Models.Edit_BRDF1Change(Sender: TObject);
begin
    val(Edit_BRDF1.Text, input, error);
    if error=0 then t_BRDF[1]:=input;
    end;

procedure TForm_Models.Edit_BRDF2Change(Sender: TObject);
begin
    val(Edit_BRDF2.Text, input, error);
    if error=0 then t_BRDF[2]:=input;
    end;

procedure TForm_Models.Edit_BRDF3Change(Sender: TObject);
begin
    val(Edit_BRDF3.Text, input, error);
    if error=0 then t_BRDF[3]:=input;
    end;

procedure TForm_Models.Edit_BRDF4Change(Sender: TObject);
begin
    val(Edit_BRDF4.Text, input, error);
    if error=0 then t_BRDF[4]:=input;
    end;

procedure TForm_Models.Edit_BRDF5Change(Sender: TObject);
begin
    val(Edit_BRDF5.Text, input, error);
    if error=0 then t_BRDF[5]:=input;
    end;

procedure TForm_Models.Editbb1Change(Sender: TObject);
begin
    val(Editbb1.Text, input, error);
    if error=0 then begin
        t_bbW500:=input;
        bbW500:=t_bbW500;
        berechne_bbW;
        end;
    end;


procedure TForm_Models.CheckEdUseEdClick(Sender: TObject);
begin
    fl_use_Ed:=CheckEdUseEd.checked;
    InActivateEd(Sender);
    end;

procedure TForm_Models.EditHeaderEdChange(Sender: TObject);
begin
    val(EditHeaderEd.Text, input, error);
    if error=0 then EdHeader:=round(input);
    end;

procedure TForm_Models.EditXColEdChange(Sender: TObject);
begin
    val(EditXColEd.Text, input, error);
    if error=0 then EdXcol:=round(input);
    end;

procedure TForm_Models.EditYColEdChange(Sender: TObject);
begin
    val(EditYColEd.Text, input, error);
    if error=0 then EdYcol:=round(input);
    end;

procedure TForm_Models.ButtonEdFileClick(Sender: TObject);
var old_extension : String;
begin
    old_extension:='*'+ExtractFileExt(Ed^.FName);
    OpenDialog1.FileName:=Ed^.FName;
    OpenDialog1.InitialDir := ExtractFilePath(Ed^.FName);
    OpenDialog1.Title := 'Load downwelling irradiance spectrum';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';
    if OpenDialog1.Execute then
        t_Name_Ed:=OpenDialog1.FileName;
    EditE_dFile.text:=t_Name_Ed;
    EditEdFile.text :=t_Name_Ed;
    end;

procedure TForm_Models.CheckUseLsClick(Sender: TObject);
begin
    fl_use_Ls:=CheckUseLs.checked;
    if fl_use_Ls then begin
        fl_wv_Surf:=TRUE;
        CheckWvDependent.checked:=TRUE;
        CheckUseLs.checked:=TRUE;
        CheckUseEd.checked:=FALSE;
        end;
    InActivateLs(Sender);
    end;

procedure TForm_Models.ButtonLsFileClick(Sender: TObject);
var old_extension : String;
begin
    old_extension:='*'+ExtractFileExt(Ls^.FName);
    OpenDialog1.FileName:=Ls^.FName;
    OpenDialog1.InitialDir := ExtractFilePath(Ls^.FName);
    OpenDialog1.Title := 'Load sky radiance spectrum';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';
    if OpenDialog1.Execute then
        t_Name_Ls:=OpenDialog1.FileName;
    EditLsFile.text:=t_Name_Ls;
    end;

procedure TForm_Models.EditHeaderLsChange(Sender: TObject);
begin
    val(EditHeaderLs.Text, input, error);
    if error=0 then LsHeader:=round(input);
    end;

procedure TForm_Models.EditXColLsChange(Sender: TObject);
begin
    val(EditXColLs.Text, input, error);
    if error=0 then LsXcol:=round(input);
    end;

procedure TForm_Models.EditYColLsChange(Sender: TObject);
begin
    val(EditYColLs.Text, input, error);
    if error=0 then LsYcol:=round(input);
    end;

procedure TForm_Models.RadioGroupRrsBClick(Sender: TObject);
begin
    t_Model_R_rsB:=RadioGroupRrsB.ItemIndex;
    if t_Model_R_rsB<2 then begin
        t_Model_R:=t_Model_R_rsB;
        RadioGroupR.ItemIndex:=t_Model_R;
        end;
    RadioGroupfrs.Visible:=t_Model_R_rsB<2;
    GroupR.Visible:=(t_Model_R_rsA>0) or (t_Model_R_rsB=2);
    end;

procedure TForm_Models.RadioGroupfrsClick(Sender: TObject);
begin
    t_Model_f_rs:=RadioGroupfrs.ItemIndex;
    end;

procedure TForm_Models.CheckUseRClick(Sender: TObject);
begin
    fl_use_R:=CheckUseR.checked;
    InActivateR(Sender);
    end;

procedure TForm_Models.EditHeaderRChange(Sender: TObject);
begin
    val(EditHeaderR.Text, input, error);
    if error=0 then RHeader:=round(input);
    end;

procedure TForm_Models.ButtonRfileClick(Sender: TObject);
var old_extension : String;
begin
    old_extension:='*'+ExtractFileExt(R^.FName);
    OpenDialog1.FileName:=R^.FName;
    OpenDialog1.InitialDir := ExtractFilePath(R^.FName);
    OpenDialog1.Title := 'Load irradiance reflectance spectrum';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';
    if OpenDialog1.Execute then
        t_Name_R:=OpenDialog1.FileName;
    EditRFile.text:=t_Name_R;
    end;

procedure TForm_Models.RadioGroupRrsAClick(Sender: TObject);
begin
    t_Model_R_rsA:=RadioGroupRrsA.ItemIndex;
    GroupR.Visible:=(t_Model_R_rsA>0) or (t_Model_R_rsB=2);
    end;

procedure TForm_Models.CheckUseEdClick(Sender: TObject);
begin
    fl_use_E_d:=CheckUseEd.checked;
    if fl_use_E_d then begin
        fl_wv_Surf:=FALSE;
        CheckWvDependent.checked:=FALSE;
        CheckUseEd.checked:=TRUE;
        CheckUseLs.checked:=FALSE;
        end;
    InActivateE_d(Sender);
    end;

procedure TForm_Models.CheckWvDependentClick(Sender: TObject);
var flag_merk : boolean;
begin
    fl_wv_Surf:=CheckWvDependent.checked;
    flag_merk:=fl_use_Ls or fl_use_E_d;
    fl_use_Ls:=fl_wv_Surf and flag_merk;
    fl_use_E_d:=(not fl_wv_Surf) and flag_merk;
    InActivateLs(Sender);
    InActivateE_d(Sender);
    end;

procedure TForm_Models.EditHeaderE_dChange(Sender: TObject);
begin
    val(EditHeaderE_d.Text, input, error);
    if error=0 then EdHeader:=round(input);
    end;

procedure TForm_Models.EditXColE_dChange(Sender: TObject);
begin
    val(EditXColE_d.Text, input, error);
    if error=0 then EdXcol:=round(input);
    end;

procedure TForm_Models.EditYColE_dChange(Sender: TObject);
begin
    val(EditYColE_d.Text, input, error);
    if error=0 then EdYcol:=round(input);
    end;

procedure TForm_Models.ButtonE_dFileClick(Sender: TObject);
var old_extension : String;
begin
    old_extension:='*'+ExtractFileExt(Ed^.FName);
    OpenDialog1.FileName:=Ed^.FName;
    OpenDialog1.InitialDir := ExtractFilePath(Ed^.FName);
    OpenDialog1.Title := 'Load downwelling irradiance spectrum';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';
    if OpenDialog1.Execute then
        t_Name_Ed:=OpenDialog1.FileName;
    EditE_dFile.text:=t_Name_Ed;
    EditEdFile.text :=t_Name_Ed;
    end;

procedure TForm_Models.Edit_RHChange(Sender: TObject);
begin
    val(Edit_RH.Text, input, error);
    if error=0 then t_RH:=input;
    end;

procedure TForm_Models.Edit_AMChange(Sender: TObject);
begin
    val(Edit_AM.Text, input, error);
    if error=0 then t_AM:=input;
    end;

procedure TForm_Models.Edit_PChange(Sender: TObject);
begin
    val(Edit_P.Text, input, error);
    if error=0 then t_P:=input;
    end;

procedure TForm_Models.Edit_chl_0Change(Sender: TObject);
begin
    val(Edit_chl_0.Text, input, error);
    if error=0 then t_chl_0:=input;
    end;

procedure TForm_Models.Edit_chl_sigChange(Sender: TObject);
begin
    val(Edit_chl_sig.Text, input, error);
    if error=0 then begin
        t_chl_sig:=input;
        Edit_chl_FWHM.Text :=schoen(t_chl_sig*FWHM_sigma, 3);
        Edit_chl_FWHM.update;
        end;
    end;

procedure TForm_Models.Edit_chl_FWHMChange(Sender: TObject);
begin
    val(Edit_chl_FWHM.Text, input, error);
    if error=0 then begin
        t_chl_sig:=input/FWHM_sigma;
        Edit_chl_sig.Text :=schoen(t_chl_sig, 4);
        Edit_chl_sig.update;
        end;
    end;

procedure TForm_Models.Edit_PAR_minChange(Sender: TObject);
begin
    val(Edit_PAR_min.Text, input, error);
    if error=0 then t_PAR_min:=round(input);
    end;

procedure TForm_Models.Edit_PAR_maxChange(Sender: TObject);
begin
    val(Edit_PAR_max.Text, input, error);
    if error=0 then t_PAR_max:=round(input);
    end;

procedure TForm_Models.Edit_dayChange(Sender: TObject);
begin
    val(Edit_day.Text, input, error);
    if error=0 then t_day:=round(input);
    end;

procedure TForm_Models.Edit_rho_EdChange(Sender: TObject);
begin
    val(Edit_rho_Ed.Text, input, error);
    if error=0 then t_rho_Ed:=input;
    end;

procedure TForm_Models.EditbXChange(Sender: TObject);
begin
    val(EditbX.Text, input, error);
    t_bX:=input;
    end;

procedure TForm_Models.EditbMieChange(Sender: TObject);
begin
    val(EditbMie.Text, input, error);
    if error=0 then t_bMie:=input;
    end;

procedure TForm_Models.RadioGroupEdClick(Sender: TObject);
begin
    t_Model_Ed:=RadioGroupEd.ItemIndex;
    InActivate_ld(Sender);
    end;

procedure TForm_Models.Check_rho_dd_FresnelClick(Sender: TObject);
begin
    fl_Fresnel_sun:=Check_rho_dd_Fresnel.checked;
    update_rho_dd(Sender);
    Edit_rho_dd.Enabled:=not fl_fresnel_sun;
    (*
    if fl_fresnel_sun then t_rho_dd:=Fresnel(sun.fw)else t_rho_dd:=rho_dd.fw;
    *)
    Edit_rho_dd.Text  :=schoen(t_rho_dd, 4);
{    Edit_rho_dd.update; }
    end;

procedure TForm_Models.Edit_rho_ddChange(Sender: TObject);
begin
{    change(Edit_rho_dd, rho_dd); }
    val(Edit_rho_dd.Text, input, error);
    if error=0 then t_rho_dd:=input;
    end;

procedure TForm_Models.Edit_rho_dsChange(Sender: TObject);
begin
    val(Edit_rho_ds.Text, input, error);
    if error=0 then t_rho_ds:=input;
    end;

procedure TForm_Models.Edit_lds0Change(Sender: TObject);
begin
    val(Edit_lds0.Text, input, error);
    if error=0 then t_lds0:=input;
    end;

procedure TForm_Models.Check_rho_dsClick(Sender: TObject);
begin
    fl_calc_rho_ds:=Check_rho_ds.checked;
    Edit_rho_ds.enabled:=not fl_calc_rho_ds;
    update_rho_ds(Sender);
    Edit_rho_ds.Text  :=schoen(t_rho_ds, 4);
    Edit_rho_ds.update;
    end;

procedure TForm_Models.Edit_lddChange(Sender: TObject);
begin
    val(Edit_ldd.Text, input, error);
    if error=0 then t_ldd:=input;
    end;

procedure TForm_Models.Edit_ldChange(Sender: TObject);
begin
    val(Edit_ld.Text, input, error);
    if error=0 then t_ld:=input;
    end;

procedure TForm_Models.Edit_Integral_minChange(Sender: TObject);
begin
    val(Edit_Integral_min.Text, input, error);
    if error=0 then t_E_min:=round(input);
    update_E_texts(Sender);
    end;

procedure TForm_Models.Edit_Integral_maxChange(Sender: TObject);
begin
    val(Edit_Integral_max.Text, input, error);
    if error=0 then t_E_max:=round(input);
    update_E_texts(Sender);
    end;

procedure TForm_Models.Edit_dsmplChange(Sender: TObject);
begin
    val(Edit_dsmpl.Text, input, error);
    if error=0 then t_dsmpl:=round(input);
    end;

procedure TForm_Models.Edit_lds1Change(Sender: TObject);
begin
    val(Edit_lds1.Text, input, error);
    if error=0 then t_lds1:=input;
    end;

procedure TForm_Models.Edit_lddbChange(Sender: TObject);
begin
    val(Edit_lddb.Text, input, error);
    if error=0 then t_lddb:=input;
    end;

procedure TForm_Models.RadioGroup_KddClick(Sender: TObject);
begin
    t_Model_Kdd:=RadioGroup_Kdd.ItemIndex;
    end;

procedure TForm_Models.Edit_lddaChange(Sender: TObject);
begin
    val(Edit_ldda.Text, input, error);
    if error=0 then t_ldda:=input;
    end;

procedure TForm_Models.Edit_rho_uChange(Sender: TObject);
begin
    val(Edit_rho_u.Text, input, error);
    if error=0 then t_rho_u:=input;
    end;

procedure TForm_Models.CheckFluoClick(Sender: TObject);
begin
    fl_fluo:=CheckFluo.checked;
    set_zero(Lf^);
    InActivateFluo(Sender);
    end;

procedure TForm_Models.Edit_sum_minChange(Sender: TObject);
begin
    val(Edit_sum_min.Text, input, error);
    if error=0 then t_SfA_min:=input;
    end;

procedure TForm_Models.Edit_sum_maxChange(Sender: TObject);
begin
    val(Edit_sum_max.Text, input, error);
    if error=0 then t_SfA_max:=input;
    end;

procedure TForm_Models.Edit_pEdChange(Sender: TObject);
begin
    val(Edit_pEd.Text, input, error);
    if error=0 then t_pEd:=round(input);
    end;

procedure TForm_Models.CheckCaphClick(Sender: TObject);
begin
    fl_aph_C:=CheckCaph.checked;
    if CheckCaph.checked then active_aph(Sender)
                         else inactive_aph(Sender);
    end;

procedure TForm_Models.ButtonbLFileClick(Sender: TObject);
var old_extension : String;
begin
    old_extension:='*'+ExtractFileExt(bPhyN^.FName);
    OpenDialog1.FileName:=bPhyN^.FName;
    OpenDialog1.InitialDir := ExtractFilePath(bPhyN^.FName);
    OpenDialog1.Title := 'Load phytoplankton scattering file';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';
    if OpenDialog1.Execute then
        t_Name_bPhyFile:=OpenDialog1.FileName;
    EditbPhyFile.text:=t_Name_bPhyFile;
    EditbPhyFile.refresh;
    end;

procedure TForm_Models.ButtonAfileClick(Sender: TObject);
var old_extension : String;
begin
    old_extension:='*'+ExtractFileExt(aphA^.FName);
    OpenDialog1.InitialDir := ExtractFilePath(aphA^.FName);
    OpenDialog1.FileName:=aphA^.FName;
    OpenDialog1.Title := 'Load coefficient A of a*_ph';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';
    if OpenDialog1.Execute then
        t_Name_AFile:=OpenDialog1.FileName;
    EditAFile.text:=t_Name_AFile;
    EditAFile.refresh;
    end;

procedure TForm_Models.ButtonAlbedo0Click(Sender: TObject);
var old_extension : String;
begin
    old_extension:='*'+ExtractFileExt(albedo[0]^.FName);
    OpenDialog1.InitialDir := ExtractFilePath(albedo[0]^.FName);
    OpenDialog1.FileName:=albedo[0]^.FName;
    OpenDialog1.Title := 'Load file of bottom albedo #0';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';
    if OpenDialog1.Execute then
        t_Name_albedo[0]:=OpenDialog1.FileName;
    Edit_FnBottom0.text:=t_Name_albedo[0];
    Edit_FnBottom0.refresh;
    end;

procedure TForm_Models.ButtonAlbedo1Click(Sender: TObject);
var old_extension : String;
begin
    old_extension:='*'+ExtractFileExt(albedo[1]^.FName);
    OpenDialog1.InitialDir := ExtractFilePath(albedo[1]^.FName);
    OpenDialog1.FileName:=albedo[1]^.FName;
    OpenDialog1.Title := 'Load file of bottom albedo #1';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';
    if OpenDialog1.Execute then
        t_Name_albedo[1]:=OpenDialog1.FileName;
    Edit_FnBottom1.text:=t_Name_albedo[1];
    Edit_FnBottom1.refresh;
    end;

procedure TForm_Models.ButtonAlbedo2Click(Sender: TObject);
var old_extension : String;
begin
    old_extension:='*'+ExtractFileExt(albedo[2]^.FName);
    OpenDialog1.InitialDir := ExtractFilePath(albedo[2]^.FName);
    OpenDialog1.FileName:=albedo[2]^.FName;
    OpenDialog1.Title := 'Load file of bottom albedo #2';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';
    if OpenDialog1.Execute then
        t_Name_albedo[2]:=OpenDialog1.FileName;
    Edit_FnBottom2.text:=t_Name_albedo[2];
    Edit_FnBottom2.refresh;
    end;

procedure TForm_Models.ButtonAlbedo3Click(Sender: TObject);
var old_extension : String;
begin
    old_extension:='*'+ExtractFileExt(albedo[3]^.FName);
    OpenDialog1.InitialDir := ExtractFilePath(albedo[3]^.FName);
    OpenDialog1.FileName:=albedo[3]^.FName;
    OpenDialog1.Title := 'Load file of bottom albedo #3';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';
    if OpenDialog1.Execute then
        t_Name_albedo[3]:=OpenDialog1.FileName;
    Edit_FnBottom3.text:=t_Name_albedo[3];
    Edit_FnBottom3.refresh;
    end;

procedure TForm_Models.ButtonAlbedo4Click(Sender: TObject);
var old_extension : String;
begin
    old_extension:='*'+ExtractFileExt(albedo[4]^.FName);
    OpenDialog1.InitialDir := ExtractFilePath(albedo[4]^.FName);
    OpenDialog1.FileName:=albedo[4]^.FName;
    OpenDialog1.Title := 'Load file of bottom albedo #4';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';
    if OpenDialog1.Execute then
        t_Name_albedo[4]:=OpenDialog1.FileName;
    Edit_FnBottom4.text:=t_Name_albedo[4];
    Edit_FnBottom4.refresh;
    end;

procedure TForm_Models.ButtonAlbedo5Click(Sender: TObject);
var old_extension : String;
begin
    old_extension:='*'+ExtractFileExt(albedo[5]^.FName);
    OpenDialog1.InitialDir := ExtractFilePath(albedo[5]^.FName);
    OpenDialog1.FileName:=albedo[0]^.FName;
    OpenDialog1.Title := 'Load file of bottom albedo #5';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';
    if OpenDialog1.Execute then
        t_Name_albedo[5]:=OpenDialog1.FileName;
    Edit_FnBottom5.text:=t_Name_albedo[5];
    Edit_FnBottom5.refresh;
    end;

procedure TForm_Models.ButtonBfileClick(Sender: TObject);
var old_extension : String;
begin
    old_extension:='*'+ExtractFileExt(aphB^.FName);
    OpenDialog1.InitialDir := ExtractFilePath(aphB^.FName);
    OpenDialog1.FileName:=aphB^.FName;
    OpenDialog1.Title := 'Load coefficient B of a*_ph';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';
    if OpenDialog1.Execute then
        t_Name_BFile:=OpenDialog1.FileName;
    EditBFile.text:=t_Name_BFile;
    EditBFile.refresh;
    end;

end.
