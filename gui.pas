unit gui;

{$MODE Delphi}

{ Main unit of program WASI. }
{ Version vom 23.4.2020 }

interface

uses
  Windows, LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, StdCtrls, ExtCtrls, DateUtils, defaults, misc, fw_calc,
  meltpond, privates, Farbe, ActnList, Frame_Resid, Frame_Batch, Frame_par,
  ExtDlgs, FileUtil;

type

  { TForm1 }

  TForm1 = class(TForm)
    alpha_0: TEdit;
    alpha_d_0: TEdit;
    alpha_d_fit: TCheckBox;
    alpha_fit: TCheckBox;
    beta_0: TEdit;
    beta_d_0: TEdit;
    beta_d_fit: TCheckBox;
    beta_fit: TCheckBox;
    C1_0: TEdit;
    C1_fit: TCheckBox;
    C2_0: TEdit;
    C2_fit: TCheckBox;
    C3_0: TEdit;
    C3_fit: TCheckBox;
    C4_0: TEdit;
    C4_fit: TCheckBox;
    C5_0: TEdit;
    C5_fit: TCheckBox;
    CheckBatch: TCheckBox;
    CheckInvert: TCheckBox;
    CheckReadFile: TCheckBox;
    CL_0: TEdit;
    CL_fit: TCheckBox;
    CMie_0: TEdit;
    CMie_fit: TCheckBox;
    ComboSensor: TComboBox;
    ComboPar1: TComboBox;
    ComboPar2: TComboBox;
    ComboPar3: TComboBox;
    CP_0: TEdit;
    Cp_fit: TCheckBox;
    CY_0: TEdit;
    CY_fit: TCheckBox;
    delta_d_0: TEdit;
    delta_d_fit: TCheckBox;
    delta_r_0: TEdit;
    delta_r_fit: TCheckBox;
    dphi_0: TEdit;
    dphi_fit: TCheckBox;
    dummy_0: TEdit;
    dummy_fit: TCheckBox;
    End1: TEdit;
    End2: TEdit;
    End3: TEdit;
    fa0_0: TEdit;
    fa0_fit: TCheckBox;
    fa1_0: TEdit;
    fa1_fit: TCheckBox;
    fa2_0: TEdit;
    fa2_fit: TCheckBox;
    fa3_0: TEdit;
    fa3_fit: TCheckBox;
    fa4_0: TEdit;
    fa4_fit: TCheckBox;
    fa5_0: TEdit;
    fa5_fit: TCheckBox;
    fluo_0: TEdit;
    fluo_fit: TCheckBox;
    f_0: TEdit;
    f_dd_0: TEdit;
    f_dd_fit: TCheckBox;
    f_ds_0: TEdit;
    f_ds_fit: TCheckBox;
    f_fit: TCheckBox;
    f_nw_0: TEdit;
    f_nw_fit: TCheckBox;
    gamma_d_0: TEdit;
    gamma_d_fit: TCheckBox;
    g_dd_0: TEdit;
    g_dd_fit: TCheckBox;
    g_dsa_0: TEdit;
    g_dsa_fit: TCheckBox;
    g_dsr_0: TEdit;
    g_dsr_fit: TCheckBox;
    H_oz_0: TEdit;
    H_oz_fit: TCheckBox;
    Iterations: TEdit;
    Log1: TCheckBox;
    Log2: TCheckBox;
    Log3: TCheckBox;
    MainMenu1: TMainMenu;
    Datei1: TMenuItem;
    aIce1: TMenuItem;
    LTOA1: TMenuItem;
    BOA_TOA_1: TMenuItem;
    aCDOM1: TMenuItem;
    a_NAP1: TMenuItem;
    aNAPs: TMenuItem;
    bbPh1: TMenuItem;
    bbNAP1: TMenuItem;
    medianimages1: TMenuItem;
    MenuItem1: TMenuItem;
    cor1: TMenuItem;
    corDES: TMenuItem;
    LoadINIfileAny: TMenuItem;
    MenuTrueColor: TMenuItem;
    Rrs1: TMenuItem;
    MenuNoise: TMenuItem;
    SNR_BOA1: TMenuItem;
    SNR_TOA1: TMenuItem;
    NEL1: TMenuItem;
    Response1: TMenuItem;
    Signal1: TMenuItem;
    Memory: TMenuItem;
    Lpath1: TMenuItem;
    MPQ_i: TMenuItem;
    MPu_i: TMenuItem;
    MPa_i: TMenuItem;
    MPtau_ap: TMenuItem;
    MPrp: TMenuItem;
    MPrp_inf: TMenuItem;
    MPtu_p: TMenuItem;
    MPTd_p: TMenuItem;
    MPku_p: TMenuItem;
    MPKd_p: TMenuItem;
    MPRRi: TMenuItem;
    MPtau_pi: TMenuItem;
    MPri: TMenuItem;
    MPri_inf: TMenuItem;
    MPtu_i: TMenuItem;
    MPku_i: TMenuItem;
    MPbb_i: TMenuItem;
    MPTd_i: TMenuItem;
    MPKd_i: TMenuItem;
    MPlds_ice: TMenuItem;
    MPp_ice: TMenuItem;
    MPtau_io: TMenuItem;
    MPRRo: TMenuItem;
    MP: TMenuItem;
    MPro: TMenuItem;
    n_0: TEdit;
    n_fit: TCheckBox;
    Q_0: TEdit;
    Q_fit: TCheckBox;
    RangeText3: TStaticText;
    Residuum: TEdit;
    bbs_phy1: TCheckBox;
    bbs_phy_0: TEdit;
    rho_dd_0: TEdit;
    rho_dd_fit: TCheckBox;
    rho_ds_0: TEdit;
    rho_ds_fit: TCheckBox;
    rho_L_0: TEdit;
    rho_L_fit: TCheckBox;
    Speichern2: TMenuItem;
    Beenden1: TMenuItem;
    Bearbeiten1: TMenuItem;
    Display1: TMenuItem;
    Display2: TMenuItem;
    aw1: TMenuItem;
    dawdT1: TMenuItem;
    ap1: TMenuItem;
    E01: TMenuItem;
    aY1: TMenuItem;
    bbW1: TMenuItem;
    Data1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    bbS1: TMenuItem;
    mean1: TMenuItem;
    cryptol1: TMenuItem;
    cryptoh1: TMenuItem;
    diatoms1: TMenuItem;
    dino1: TMenuItem;
    green1: TMenuItem;
    ImageBackground: TImage;
    SaveINIfile1: TMenuItem;
    SaveDialog1: TSaveDialog;
    Start1: TEdit;
    Start2: TEdit;
    Start3: TEdit;
    StaticText1: TStaticText;
    StaticText11: TStaticText;
    StaticText12: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    StaticText7: TStaticText;
    Steps1: TEdit;
    Steps2: TEdit;
    Steps3: TEdit;
    sun_0: TEdit;
    sun_fit: TCheckBox;
    S_0: TEdit;
    S_fit: TCheckBox;
    test_0: TEdit;
    test_fit: TCheckBox;
    Text_Iter: TStaticText;
    Text_Res: TStaticText;
    ToolbarList: TImageList;
    OpenDialog_Spec: TOpenDialog;
    Lu1: TMenuItem;
    Ed1: TMenuItem;
    DispLine1: TMenuItem;
    General1: TMenuItem;
    Inverscalculation1: TMenuItem;
    Definefitparameters1: TMenuItem;
    N1: TMenuItem;
    ComboBox: TComboBox;
    LuEd1: TMenuItem;
    Frame_r1: TFrame_p;
    Frame_Res1: TFrame_Res;
    Frame_Batch1: TFrameBatch;
    tA2: TMenuItem;
    tR1: TMenuItem;
    tM2: TMenuItem;
    tC1: TMenuItem;
    aPhcalc: TMenuItem;
    acalc: TMenuItem;
    LoadINIfileLast: TMenuItem;
    N2: TMenuItem;
    Counter: TEdit;
    gew1: TMenuItem;
    a1: TMenuItem;
    R1: TMenuItem;
    Rsurf1: TMenuItem;
    CheckAbove: TCheckBox;
    CheckSurface: TCheckBox;
    CheckShallow: TCheckBox;
    CheckFresnel: TCheckBox;
    Anleitung1: TMenuItem;
    Manual: TMenuItem;
    Reconstructionmode1: TMenuItem;
    albedo1: TMenuItem;
    surface01: TMenuItem;
    surface11: TMenuItem;
    surface21: TMenuItem;
    surface31: TMenuItem;
    surface41: TMenuItem;
    surface51: TMenuItem;
    Directories1: TMenuItem;
    Fittuning1: TMenuItem;
    Models1: TMenuItem;
    CheckBoxaW: TCheckBox;
    bbL1: TMenuItem;
    f1: TMenuItem;
    bbcalc: TMenuItem;
    StartButton: TButton;
    LoadSpec: TMenuItem;
    KEuW: TMenuItem;
    KEuB: TMenuItem;
    kLuW: TMenuItem;
    kLuB: TMenuItem;
    Kd1: TMenuItem;
    CheckBoxL: TCheckBox;
    Edsr1: TMenuItem;
    Edsa1: TMenuItem;
    r_d1: TMenuItem;
    TW_0: TEdit;
    TW_fit: TCheckBox;
    T_r1: TMenuItem;
    T_as1: TMenuItem;
    T_aa1: TMenuItem;
    taua1: TMenuItem;
    TO2: TMenuItem;
    T_wv1: TMenuItem;
    atmosphere1: TMenuItem;
    view_0: TEdit;
    view_fit: TCheckBox;
    water1: TMenuItem;
    SPM1: TMenuItem;
    WV_0: TEdit;
    WV_fit: TCheckBox;
    Y1: TMenuItem;
    irradiance1: TMenuItem;
    TO3: TMenuItem;
    Edd1: TMenuItem;
    Eds1: TMenuItem;
    Lf1: TMenuItem;
    N3: TMenuItem;
    Rrsf1: TMenuItem;
    aO31: TMenuItem;
    aO21: TMenuItem;
    awv1: TMenuItem;
    N4: TMenuItem;
    Ed01: TMenuItem;
    ToolBar1: TToolBar;
    Stest1: TMenuItem;
    Dataformatnew1: TMenuItem;
    Kdd1: TMenuItem;
    Kds1: TMenuItem;
    attenuation1: TMenuItem;
    IOP1: TMenuItem;
    Reflectance1: TMenuItem;
    radiance1: TMenuItem;
    Lr1: TMenuItem;
    frs1: TMenuItem;
    Ls1: TMenuItem;
    OpenPictureDialog: TOpenPictureDialog;
    ProgressBar1: TProgressBar;
    OpenDialog_HSI: TOpenDialog;
    Load_img: TMenuItem;
    Opt_2D: TMenuItem;
    Save_Img: TMenuItem;
    SavePictureDialog1: TSavePictureDialog;
    Tools: TMenuItem;
    BSQBIL1: TMenuItem;
    regression1: TMenuItem;
    omegab1: TMenuItem;
    bb1: TMenuItem;
    bMie1: TMenuItem;
    b1: TMenuItem;
    bottom1: TMenuItem;
    N5: TMenuItem;
    bcalc1: TMenuItem;
    FWHM1: TMenuItem;
    kz90: TMenuItem;
    private1: TMenuItem;
    PopupMenu1: TPopupMenu;
    sigmac1: TMenuItem;
    sigmat1: TMenuItem;
    sigmap1: TMenuItem;
    sigman1: TMenuItem;
    Rnw: TMenuItem;
    noise1: TMenuItem;
    offset1: TMenuItem;
    Val1: TMenuItem;
    OpenDialog_CalVal: TOpenDialog;
    Subtract1: TMenuItem;
    averagespectra1: TMenuItem;
    heatmap1: TMenuItem;
    statistics1: TMenuItem;
    banddemo1: TMenuItem;
    CMFL1: TMenuItem;
    CMFM1: TMenuItem;
    CMFS1: TMenuItem;
    Rbottom: TMenuItem;
    Label_calc_Rbottom: TLabel;
    scale1: TMenuItem;
    EEM_phy: TMenuItem;
    EEM_Y: TMenuItem;
    Q1: TMenuItem;
    bb01: TMenuItem;
    averageimages1: TMenuItem;
    zB_0: TEdit;
    zB_fit: TCheckBox;
    z_0: TEdit;
    z_fit: TCheckBox;

    { Procedures of the Graphical User Interface }
    procedure aCDOM1Click(Sender: TObject);
    procedure aIce1Click(Sender: TObject);
    procedure aNAP2Click(Sender: TObject);
    procedure aNAPsClick(Sender: TObject);
    procedure aY2Click(Sender: TObject);
    procedure a_NAP1Click(Sender: TObject);
    procedure bbNAP1Click(Sender: TObject);
    procedure bbPh1Click(Sender: TObject);
    procedure bb_phy1Click(Sender: TObject);
    procedure CheckBatchChange(Sender: TObject);
    procedure ComboPar1Change(Sender: TObject);
    procedure ComboPar2Change(Sender: TObject);
    procedure ComboPar3Change(Sender: TObject);
    procedure ComboSensorChange(Sender: TObject);
    procedure cor1Click(Sender: TObject);
    procedure corDESClick(Sender: TObject);
    procedure End2Change(Sender: TObject);
    procedure End3Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DefineAreas;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure LoadINIfileAnyClick(Sender: TObject);
    procedure medianimages1Click(Sender: TObject);
    procedure MemoryClick(Sender: TObject);
    procedure LTOA1Click(Sender: TObject);
    procedure BOA_TOA_1Click(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuTrueColorClick(Sender: TObject);
    procedure Rrs1Click(Sender: TObject);
    procedure MenuNoiseClick(Sender: TObject);
    procedure NEL1Click(Sender: TObject);
    procedure Response1Click(Sender: TObject);
    procedure Signal1Click(Sender: TObject);
    procedure Lpath1Click(Sender: TObject);
    procedure MPa_iClick(Sender: TObject);
    procedure MPbb_iClick(Sender: TObject);
    procedure MPKd_iClick(Sender: TObject);
    procedure MPKd_pClick(Sender: TObject);
    procedure MPku_iClick(Sender: TObject);
    procedure MPku_pClick(Sender: TObject);
    procedure MPlds_iceClick(Sender: TObject);
    procedure MPp_iceClick(Sender: TObject);
    procedure MPQ_iClick(Sender: TObject);
    procedure MPriClick(Sender: TObject);
    procedure MPri_infClick(Sender: TObject);
    procedure MProClick(Sender: TObject);
    procedure MPrpClick(Sender: TObject);
    procedure MPrp_infClick(Sender: TObject);
    procedure MPRRiClick(Sender: TObject);
    procedure MPRRoClick(Sender: TObject);
    procedure MPtau_apClick(Sender: TObject);
    procedure MPtau_ioClick(Sender: TObject);
    procedure MPtau_piClick(Sender: TObject);
    procedure MPTd_iClick(Sender: TObject);
    procedure MPTd_pClick(Sender: TObject);
    procedure MPtu_iClick(Sender: TObject);
    procedure MPtu_pClick(Sender: TObject);
    procedure MPu_iClick(Sender: TObject);
    procedure SNR_BOA1Click(Sender: TObject);
    procedure SNR_TOA1Click(Sender: TObject);
    procedure Start3Change(Sender: TObject);
    procedure Steps1Change(Sender: TObject);
    procedure view_fitChange(Sender: TObject);
    procedure XGrid;
    procedure YGrid;
    procedure Legende;
    procedure Legend_par(c:integer; text:string; yofs: integer);
    procedure Inactivate_Background;
    procedure Farben1;
    procedure Farben2;
    procedure FarbenSucc;
    procedure Zeichne_Kurve(nr: word; out dots: word);
    procedure Zeichne(Sender:TObject; flag_screenshot: boolean);
    procedure Zeichne_Punkte(nr: word);
//    procedure Zeichne(Sender: TObject);
    procedure FrameGroesse(Sender: TObject);
    procedure update_GUI(Sender: TObject);
    procedure ComboBoxChange(Sender: TObject);
    procedure CheckBoxaWClick(Sender: TObject);
    procedure CheckFresnelClick(Sender: TObject);
    procedure Frame_Batch1CheckInvertClick(Sender: TObject);
    procedure Frame_Batch1CheckBatchClick(Sender: TObject);
    procedure Frame_Batch1CheckReadFileClick(Sender: TObject);
    procedure CheckBoxLClick(Sender: TObject);
    procedure CheckAboveClick(Sender: TObject);
    procedure CheckSurfaceClick(Sender: TObject);
    procedure CheckShallowClick(Sender: TObject);

    { Procedures for program execution }
    function  SavePlotWindow(Sender: TObject; FileName: String): Boolean;
    procedure StartButtonClick(Sender: TObject);
    procedure Prepare_Invers(Sender:TObject);
    procedure Finalize_Invers(Sender:TObject);
    procedure Run_Invers(Sender:TObject);
    procedure Forward_Mode(Sender:TObject);
    procedure Invert_Files(Sender: TObject);
    procedure Invert_2D(Sender: TObject);
    procedure Run_Batch(Sender:TObject);

    { Procedures of the Menu Bar }
    procedure update_Menu(Sender: TObject);
//    procedure Plot_Spectrum(S: Attr_spec; Sender: TObject);
    procedure Plot_Spectrum(S: Attr_spec; flag_screenshot: boolean; Sender: TObject);
    procedure LoadSpecClick(Sender: TObject);
    procedure Load_imgClick(Sender: TObject);
    procedure Speichern2Click(Sender: TObject);
    procedure Save_ImgClick(Sender: TObject);
    procedure LoadINIfileLastClick(Sender: TObject);
    procedure SaveINIfile1Click(Sender: TObject);
    procedure Beenden1Click(Sender: TObject);
    procedure Display2Click(Sender: TObject);
    procedure aw1Click(Sender: TObject);
    procedure dawdT1Click(Sender: TObject);
    procedure bbW1Click(Sender: TObject);
    procedure mean1Click(Sender: TObject);
    procedure cryptol1Click(Sender: TObject);
    procedure cryptoh1Click(Sender: TObject);
    procedure diatoms1Click(Sender: TObject);
    procedure dino1Click(Sender: TObject);
    procedure green1Click(Sender: TObject);
    procedure bbL1Click(Sender: TObject);
    procedure bMie1Click(Sender: TObject);
    procedure bbS1Click(Sender: TObject);
    procedure aY1Click(Sender: TObject);
    procedure aNAP1Click(Sender: TObject);
    procedure surface01Click(Sender: TObject);
    procedure surface11Click(Sender: TObject);
    procedure surface21Click(Sender: TObject);
    procedure surface31Click(Sender: TObject);
    procedure surface41Click(Sender: TObject);
    procedure surface51Click(Sender: TObject);
    procedure aO21Click(Sender: TObject);
    procedure aO31Click(Sender: TObject);
    procedure awv1Click(Sender: TObject);
    procedure TO2Click(Sender: TObject);
    procedure TO3Click(Sender: TObject);
    procedure T_wv1Click(Sender: TObject);
    procedure taua1Click(Sender: TObject);
    procedure T_r1Click(Sender: TObject);
    procedure T_as1Click(Sender: TObject);
    procedure T_aa1Click(Sender: TObject);
    procedure tAClick(Sender: TObject);
    procedure tRClick(Sender: TObject);
    procedure tMClick(Sender: TObject);
    procedure tCClick(Sender: TObject);
    procedure E01Click(Sender: TObject);
    procedure Ed01Click(Sender: TObject);
    procedure Ed1Click(Sender: TObject);
    procedure Edd1Click(Sender: TObject);
    procedure Eds1Click(Sender: TObject);
    procedure Edsr1Click(Sender: TObject);
    procedure Edsa1Click(Sender: TObject);
    procedure r_d1Click(Sender: TObject);
    procedure Lu1Click(Sender: TObject);
    procedure Lr1Click(Sender: TObject);
    procedure Ls1Click(Sender: TObject);
    procedure Lf1Click(Sender: TObject);
    procedure Kd1Click(Sender: TObject);
    procedure Kdd1Click(Sender: TObject);
    procedure Kds1Click(Sender: TObject);
    procedure KEuWClick(Sender: TObject);
    procedure KEuBClick(Sender: TObject);
    procedure kLuWClick(Sender: TObject);
    procedure kLuBClick(Sender: TObject);
    procedure R1Click(Sender: TObject);
    procedure LuEd1Click(Sender: TObject);
    procedure Rsurf1Click(Sender: TObject);
    procedure Rrsf1Click(Sender: TObject);
    procedure f1Click(Sender: TObject);
    procedure frs1Click(Sender: TObject);
    procedure bottom1Click(Sender: TObject);
    procedure a1Click(Sender: TObject);
    procedure b1Click(Sender: TObject);
    procedure bb1Click(Sender: TObject);
    procedure acalcClick(Sender: TObject);
    procedure aPhcalcClick(Sender: TObject);
    procedure bcalc1Click(Sender: TObject);
    procedure bbcalcClick(Sender: TObject);
    procedure omegab1Click(Sender: TObject);
    procedure FWHM1Click(Sender: TObject);
    procedure gew1Click(Sender: TObject);
    procedure kz90Click(Sender: TObject);
    procedure offset1Click(Sender: TObject);
    procedure noise1Click(Sender: TObject);
    procedure Stest1Click(Sender: TObject);
    procedure sigmac1Click(Sender: TObject);
    procedure sigmat1Click(Sender: TObject);
    procedure sigmap1Click(Sender: TObject);
    procedure sigman1Click(Sender: TObject);
    procedure RnwClick(Sender: TObject);
    procedure Models1Click(Sender: TObject);
    procedure Data1Click(Sender: TObject);
    procedure Fittuning1Click(Sender: TObject);
    procedure Definefitparameters1Click(Sender: TObject);
    procedure Reconstructionmode1Click(Sender: TObject);
    procedure Dataformatnew1Click(Sender: TObject);
    procedure Directories1Click(Sender: TObject);
    procedure Display1Click(Sender: TObject);
    procedure General1Click(Sender: TObject);
    procedure Opt_2DClick(Sender: TObject);
    procedure BSQBIL1Click(Sender: TObject);
    procedure regression1Click(Sender: TObject);
    procedure Val1Click(Sender: TObject);
    procedure Subtract1Click(Sender: TObject);
    procedure ManualClick(Sender: TObject);
    procedure Anleitung1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure averagespectra1Click(Sender: TObject);
    procedure heatmap1Click(Sender: TObject);
    procedure statistics1Click(Sender: TObject);
    procedure banddemo1Click(Sender: TObject);
    procedure CMFL1Click(Sender: TObject);
    procedure CMFM1Click(Sender: TObject);
    procedure CMFS1Click(Sender: TObject);
    procedure Frame_r1CL_fitClick(Sender: TObject);
    procedure RbottomClick(Sender: TObject);
    procedure scale1Click(Sender: TObject);
    procedure Frame_r1g_dd_fitClick(Sender: TObject);
    procedure Frame_Batch1Start1Change(Sender: TObject);
    procedure Frame_Batch1End1Change(Sender: TObject);
    procedure display_EEM(E: EEMatrix; Sender: TObject);
    procedure EEM_phyClick(Sender: TObject);
    procedure EEM_YClick(Sender: TObject);
    procedure Q1Click(Sender: TObject);
    procedure Frame_r1beta_fitClick(Sender: TObject);
    procedure bb01Click(Sender: TObject);
    procedure averageimages1Click(Sender: TObject);
    procedure Update_DPI(Sender:TObject);
    procedure WMQueryEndSession(var AMsg: TWMQueryEndSession);

  private
      DrawArea     : TRect;
      RectArea     : TRect;
      ClearArea    : TRect;
      show_bkgrd   : boolean;
      flag_aW_merk : boolean;
    public
    end;

var   Form1    : TForm1;
      SpekName : TStrings;             { List of spectra to be inverted }
      DY_par_dpi: Integer; //RR
      dy_gege_dpi: Integer;   //RR
      dy_bottom_dpi: Integer; //RR
      dy_leg_dpi: Integer; //RR
      DY_top_dpi : Integer; //RR
      DY_modes_dpi : Integer; //RR
      DY_batch_dpi: Integer; //RR
      DX_par_dpi  : Integer; //RR
      DX_leg_dpi : Integer; //RR
      dx_right_dpi: Integer;    //RR
      scale_gui : Double;// RR
      tu_ofs_dpi : Double; // RR
      to_ofs_dpi : Double; // RR
      tl_ofs_dpi : Double; // RR

implementation

uses SCHOEN_, Popup_Display, popup_forward, Popup_General, About, math,
  invers, CEOS, Popup_Fitparameter, Popup_Directories, Popup_Reconstruction,
  Popup_Tuning, Popup_Models, Popup_Dataformat, Popup_2D_Format, Popup_2D_Options,
  Popup_2D_Info, Popup_Rbottom, popup_info, Types;

{$R *.lfm}


{ **************************************************************************** }
{ ***********               Graphical User Interface               *********** }
{ **************************************************************************** }

procedure TFOrm1.Update_DPI(Sender:TObject);
begin
   //RR
   if ((Form1.Height/GUI_Height) <>  Scale_gui) then
       begin
       Scale_gui := Form1.Height/GUI_Height ;
        DY_par:=round(scale_gui*DY_par_dpi);
        dy_gege := round(scale_gui*Dy_gege_dpi);
        dy_bottom := round(scale_gui*dy_bottom_dpi);
        dx_right := round(scale_gui*dx_right_dpi);
        dy_leg :=  round(scale_gui*dy_leg_dpi);
        DY_top :=   round(scale_gui*DY_top_dpi);
        DY_batch :=  round(scale_gui*DY_batch_dpi);
        DX_par :=  round(scale_gui*DX_par_dpi);
        DX_leg :=  round(scale_gui*DX_leg_dpi);
        dx_right :=  round(scale_gui*dx_right_dpi);
        tu_ofs :=  round(scale_gui*tu_ofs_dpi);
        to_ofs :=  round(scale_gui*to_ofs_dpi);
        tl_ofs :=  round(scale_gui*tl_ofs_dpi);
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
{ Create main window of GUI. }
var i : integer;
begin
    if flag_background then if flag_bk_2D then Load_imgClick(Sender);
    if flag_background then StartButtonClick(Sender);
//    GUI_scale:=font.PixelsPerInch/96;
    if flag_public then i:=0 else i:=100;
    Height:=Scale96ToForm(GUI_Height+i);   //RR
    Width:=Scale96ToForm(GUI_Width);       //RR

    Top := 10;  //RR
    Left :=10;  //RR
    { Netbooks: decrease height }
    if (Screen.Height-28<GUI_Height) then begin
        Align:=alTop;
        Height:=Screen.Height-28;
        end;
    Constraints.MinWidth:=Scale96ToForm(GUI_Width); //RR
    Constraints.MinHeight:=Scale96ToForm(704); //RR

    //{ Adapt GUI layout to user-defined text size }
    //if GUI_scale>1 then begin
    //    Height:=round(Height*GUI_scale);
    //    Width:=round(Width*GUI_scale);
    //    DX_par:=round(DX_par*GUI_scale);
    //    DY_Gege:=round(DY_Gege*GUI_scale);
    //    DY_par:=round(DY_par*GUI_scale);
    //    DX_leg:=round(DX_leg*GUI_scale);
    //    DY_leg:=round(DY_leg*GUI_scale);
    //    DX_right:=round(DX_right*GUI_scale);
    //    DY_top:=round(DY_top*GUI_scale);
    //    DY_bottom:=round(DY_bottom*GUI_scale);
    //    DY_modes:=round(DY_modes*GUI_scale);
    //    DY_batch:=round(DY_batch*GUI_scale);
    //    tu_ofs:=round(tu_ofs*GUI_scale);
    //    to_ofs:=round(to_ofs*GUI_scale);
    //    tl_ofs:=round(tl_ofs*GUI_scale);
    //    end;

    //RR begin
     DY_par_dpi := DY_Par;
     dy_gege_dpi:= DY_gege;
     dy_bottom_dpi:= dy_bottom;
     dy_leg_dpi:= dy_leg;
     DY_top_dpi := dy_top;
     DY_modes_dpi := dy_modes;
     DY_batch_dpi:= dy_batch;
     DX_par_dpi  := dx_par;
     DX_leg_dpi := dx_leg;
     dx_right_dpi:=dx_right;
     tu_ofs_dpi := tu_ofs;
     to_ofs_dpi := to_ofs;
     tl_ofs_dpi := tl_ofs;
     //RR end

    BorderStyle:=bsSingle; { fixed screen size }
    for i:=0 to N_spectypes-1 do
        if spec_types(i)=spec_type then
        ComboBox.ItemIndex:=i;
    ProgressBar1.visible:=FALSE;
    set_parameter_names;
    if flag_MP then begin
        ComboBox.Items[8]:='Melt pond reflectance';
        par.name[30]:='z_ice';
        par.name[31]:='f_wi';
        par.name[32]:='f_air';
        par.name[33]:='C_Y_ice';
        par.name[34]:='g_dsc';
        par.desc[9] :='Concentration of CDOM in melt pond [1/m]';
        par.desc[30]:='Ice layer thickness';
        par.desc[31]:='Fraction of water in the ice layer';
        par.desc[32]:='Fraction of air bubbles in the ice layer';
        par.desc[33]:='Concentration of CDOM in ice [1/m]';
        par.desc[34]:='Fraction of cloud reflection at pond surface';
        end;

    Frame_Batch1.FormCreate(Sender);
    Frame_Res1.FormCreate(Sender);
    Frame_r1.FormCreate(Sender);         // Parameter list
    Save_img.visible:=flag_preview;
    Tools.visible:=not flag_public;
    ComboSensor.visible:=not flag_public;
    for i:=1 to Sensor_N do ComboSensor.Items[i]:=Sensor_name[i];
    MP.visible:=flag_MP;
    aIce1.visible:=flag_MP;
    EEM_phy.visible:=not flag_public;
    EEM_Y.visible:=not flag_public;
    if flag_public then flag_Ed_Gege:=FALSE;
    Frame_Res1.Visible:=flag_b_invert and (not flag_batch) and flag_b_LoadAll;
    CheckAbove.Checked:=flag_above;
    CheckAbove.Visible:=FALSE;
    CheckFresnel.Checked:=flag_Fresnel_view;
    CheckFresnel.Visible:=FALSE;
    CheckSurface.Visible:=FALSE;
    CheckBoxaW.Checked:=flag_aW;
    CheckBoxaW.Visible:=FALSE;
    CheckBoxL.Checked:=flag_L;
    CheckBoxL.Visible:=FALSE;
    if flag_b_invert then flag_panel_fw:=FALSE
                     else flag_panel_fw:=TRUE;
    show_bkgrd:=TRUE;
    Counter.hide;
    Counter.color:=clPlotBk;
    if not flag_fluo then begin
        set_zero(Lf^);
        set_zero(RrsF^);
        end;
    averageimages1.visible:=flag_CEOS;
    medianimages1.visible:=flag_CEOS;
    if flag_public then begin { public version of WASI }
        Anleitung1.Visible:=FALSE;
        Manual.Visible:=FALSE;
        Memory.Visible:=FALSE;
        ComboBox.Items.delete(9); { Ed model of Gege }
        if not flag_MP then ComboBox.Items.delete(8); { Test spectrum }
        if (spec_type=S_test) and not flag_MP then begin
            ComboBox.ItemIndex:=3;
            spec_type:=S_R;
            end;
        for i:=51 downto 40 do begin
            Frame_Batch1.ComboPar1.Items.delete(i);
            Frame_Batch1.ComboPar2.Items.delete(i);
            Frame_Batch1.ComboPar3.Items.delete(i);
            end;
        tA2.Visible:=FALSE;
        tR1.Visible:=FALSE;
        tM2.Visible:=FALSE;
        tC1.Visible:=FALSE;
        end;
    ImageBackground.align:=alClient;
    ImageBackground.stretch:=TRUE;
    ImageBackground.Constraints.MaxWidth:=Width-Frame_r1.width-4*DX_right;
    ImageBackground.BorderSpacing.Left:=Frame_r1.width+2*DX_right;
    update_GUI(Sender);
    end;

procedure TForm1.ComboPar1Change(Sender: TObject);
begin
    Frame_Batch1.ComboPar1Change(Sender);
    end;

procedure TForm1.ComboPar2Change(Sender: TObject);
begin
    Frame_Batch1.ComboPar2Change(Sender);
    end;

procedure TForm1.ComboPar3Change(Sender: TObject);
begin
    Frame_Batch1.ComboPar3Change(Sender);
    end;

procedure TForm1.ComboSensorChange(Sender: TObject);
begin
    Sensor_act:=ComboSensor.ItemIndex;
    set_sensor;
    end;


procedure TForm1.cor1Click(Sender: TObject);
{ Correct HSI image based on image of fit paramters. }         // --> private
var   old_extension    : String;
      img_m, img_f     : String;
      p, f, c          : longInt;
      ch_fit, ch_img   : integer;
      ch_out           : integer;     // number of bands of output image
      ilv_fit, ilv_img : byte;        // interleave
      dty_fit, dty_img : byte;        // data type
      ysc_img          : double;      // y_scale
      fp               : Attr_spec;   // fit parameters
      ms               : Attr_spec;   // measurements
      HSI_in           : cube_single; // input HSI image
      HSI_rec          : cube_single; // reconstructed HSI image

const Acr_rec_water    = '_rec_w';    // Acronym for reconstructed image; only water
      Acr_rec_all      = '_rec_a';    // Acronym for reconstructed image; all pixels
      Acr_delta        = '_delta';    // Acronym for ratio -1 between fitted and measured HSI
      Thresh_SAngle    = 0.3;         // Threshold for spectral angle
      Thresh_Rmeas     = 1E-5;        // Threshold for measured reflectance

begin
    old_extension:='*'+ExtractFileExt(HSI_img^.FName);

    // Select image
    OpenDialog_HSI.FileName:=HSI_img^.FName;
    OpenDialog_HSI.Filter := 'Previous image (' +old_extension+')|' + old_extension+'|'+
        'HSI files (*.dat;*.bil;*.bsq)|*.dat;*.bil;*.bsq|'
        + 'All files (*.*)|*.*';
    OpenDialog_HSI.FilterIndex := 1;
    OpenDialog_HSI.Title := 'Select image for correction';
    if OpenDialog_HSI.Execute then img_m:=OpenDialog_HSI.Filename else img_m:='';


    // Select fit parameter image
    Output_HSI:=ChangeFileExt(img_m, '.fit');
    OpenDialog_HSI.FileName:=Output_HSI;
    OpenDialog_HSI.Filter := 'Fit parameter image (*.fit)|*.fit|'
        + 'All files (*.*)|*.*';
    OpenDialog_HSI.Title := 'Select corresponding fit parameter image';
    if OpenDialog_HSI.Execute then img_f:=OpenDialog_HSI.Filename else img_f:='';

    // Read ENVI header files
    if flag_ENVI then begin
        Format_2D:= TFormat_2D.Create(Application);
        Format_2D.Read_Envi_Header(img_f);
        ch_fit:=Channels_in;
        ilv_fit:=interleave_in;
        dty_fit:=Datentyp;
        Format_2D.Read_Envi_Header(img_m);
        ch_img:=Channels_in;
        ilv_img:=interleave_in;
        dty_img:=Datentyp;
        ysc_img:=y_scale;
        end;

    // TO DO: prüfe Konsistenz

    // Set model parameters
    LoadINI_public(ChangeFileExt(img_f,'.WASI5_1.par'));

    // TO DO: Identifiziere Fitparameter-Nr. anhand par.name
    //     siehe unit misc, procedure set_parameter_names
    //     sowie unit Popup_2D_Format, procedure Write_Envi_Fitp_Names

    TimeStartCalc:=Now;
    Screen.Cursor:=crHourGlass;
    ABBRUCH:=FALSE;

    // Import HSI image
    HSI_img^.FName:=img_m;
    Channels_in:=ch_img;
    interleave_in:=ilv_img;
    Datentyp:=dty_img;
    y_scale:=ysc_img;
    Format_2D.import_HSI(Sender);
    SetLength(HSI_in, Width_in, Height_in, ch_img);

    f:=0;                                      // Set f to first image line
    repeat
        p:=0;                                  // Set x to first image column
        repeat
            Format_2D.extract_spektrum_new(ms, p, f, Sender);    // import spectrum
            for c:=1 to ch_img do HSI_in[p,f,c-1]:=ms.y[c];
            inc(p);
        until (p>=Width_in) or ABBRUCH;
        inc(f);
    until (f>=Height_in) or ABBRUCH;
    Format_2D.HSI_free_memory(Sender);
(*
    par.c[37]:=0;    // g_dd
    par.c[38]:=0;    // g_dsr
    par.c[39]:=0;    // g_dsa
*)
    // Import fit image
    for c:=1 to ch_img do ms.y[c]:=0;
    Np_masked:=0;
    Np_water:=0;
    HSI_img^.FName:=img_f;
    Channels_in:=ch_fit;
    interleave_in:=ilv_fit;
    Datentyp:=dty_fit;
    y_scale:=1;
    Format_2D.import_HSI(Sender);

    ch_out:=0;
    for c:=1 to ch_img do if x^.y[c]<=fit_max[4] then inc(ch_out);

    Channels_out:=ch_out+1;
    SetLength(HSI_rec, Width_in, Height_in, Channels_out);

    f:=0;                                      // Set f to first image line
    repeat
        p:=0;                                  // Set x to first image column
        repeat
            Format_2D.extract_spektrum_new(fp, p, f, Sender);    // import spectrum

            // Simulate spectrum based on fit parameters
            // TO DO: Replace manual assignment by automatic assignment
            // Bands of fit image: C_phyto, C_X, C_Y, g_dd, Resid, SAngle, NIter
            par.c[1]:=fp.y[1];     // C_phyto
            par.c[7]:=fp.y[2];     // C_X
            par.c[9]:=fp.y[3];     // C_Y
            par.c[37]:=fp.y[4];    // g_dd

            if (fp.y[7]>0) and (fp.y[6]<Thresh_SAngle) then begin // water
                for c:=1 to ch_out do HSI_rec[p,f,c-1]:=kurve(c);
                HSI_rec[p,f,ch_out]:=1;
                inc(Np_water);
                end
            else begin  // no water
                for c:=1 to ch_out do HSI_rec[p,f,c-1]:=HSI_in[p,f,c-1];
                HSI_rec[p,f,ch_out]:=0;
                inc(Np_masked);
                end;
            inc(p);
        until (p>=Width_in) or ABBRUCH;
        inc(f);
    until (f>=Height_in) or ABBRUCH;
    Format_2D.HSI_free_memory(Sender);

    flag_use_ROI:=FALSE;
    interleave_out:=ilv_fit;
    Datentyp:=4;
    y_scale:=1;
    Channel_Number:=Channels_out;

    // Save reconstructed image; all pixels
    SetLength(cube_fitpar,   Width_in, Height_in, Channels_out);
    Output_HSI:=ExtractFilePath(img_m) + ExtractFileName(ChangeFileExt(img_m,''))+
         Acr_rec_all+ExtractFileExt(img_m);
    cube_fitpar:=HSI_rec;
    Format_2D.Write_Fitresult(Height_in-1);
    TimeCalc  :=MilliSecondsBetween(Now, TimeStartCalc)/1000;
    Format_2D.Write_Envi_Header_spec(Output_HSI,Channels_out);

    // Save reconstructed image; only water
    Output_HSI:=ExtractFilePath(img_m) + ExtractFileName(ChangeFileExt(img_m,''))+
         Acr_rec_water+ExtractFileExt(img_m);
    for f:=0 to Height_in-1 do
        for p:=0 to Width_in-1 do
            for c:=1 to ch_out do
                if HSI_rec[p,f,ch_out]=0 then cube_fitpar[p,f,c-1]:=0;
    Format_2D.Write_Fitresult(Height_in-1);
    TimeCalc  :=MilliSecondsBetween(Now, TimeStartCalc)/1000;
    Format_2D.Write_Envi_Header_spec(Output_HSI,ch_img);

    // Save difference between measured and fitted HSI
    Output_HSI:=ExtractFilePath(img_m) + ExtractFileName(ChangeFileExt(img_m,''))+
         Acr_delta+ExtractFileExt(img_m);
    for f:=0 to Height_in-1 do
        for p:=0 to Width_in-1 do
            for c:=1 to ch_out do
                if (HSI_rec[p,f,ch_out]=1) and (HSI_in[p,f,c-1]>Thresh_Rmeas) then   // water
                    cube_fitpar[p,f,c-1]:=HSI_rec[p,f,c-1]/HSI_in[p,f,c-1]-1
                else cube_fitpar[p,f,c-1]:=0;   // no water
    Format_2D.Write_Fitresult(Height_in-1);
    TimeCalc  :=MilliSecondsBetween(Now, TimeStartCalc)/1000;
    Format_2D.Write_Envi_Header_spec(Output_HSI,Channels_out);

    SetLength(cube_fitpar, 0, 0, 0);    // free memory
    SetLength(HSI_rec,     0, 0, 0);    // free memory
    Screen.Cursor:=crDefault;
    Save_img.visible:=flag_preview;
    end;

procedure TForm1.corDESClick(Sender: TObject);
{ Correct DESIS image based on image of fit paramters. }         // --> private
    var   old_extension    : String;
          img_m, img_f     : String;
          x, f, c          : longInt;
          ch_fit, ch_img   : integer;
          ilv_fit, ilv_img : byte;        // interleave
          dty_fit, dty_img : byte;        // data type
          ysc_img          : double;      // y_scale
          fp               : Attr_spec;   // fit parameters
          ms               : Attr_spec;   // measurements

          HSI_in           : cube_single; // input HSI image
          HSI_rec_water    : cube_single; // reconstructed image; water pixels
          HSI_rec_all      : cube_single; // reconstructed image; all pixels
          HSI_cor          : cube_single; // corrected image
          HSI_delta        : cube_single; // difference between measured and fitted HSI
          HSI_frame        : cube_single; // frame in detector coordinate system
          HSI_edge         : line_int32;  // artificial pixels at left edge

    const Acr_rec_water    = '_rec_w';    // Acronym for reconstructed image; only water
          Acr_rec_all      = '_rec_a';    // Acronym for reconstructed image; all pixels
          Acr_cor          = '_cor';      // Acronym for corrected image
          Acr_delta        = '_delta';    // Acronym for ratio -1 between fitted and measured HSI
          Acr_frame        = '_frame';    // Acronym for frame in detector coordinate system
          Thresh_SAngle    = 0.3;         // Threshold for spectral angle

    begin
        old_extension:='*'+ExtractFileExt(HSI_img^.FName);

        // Select image
        OpenDialog_HSI.FileName:=HSI_img^.FName;
        OpenDialog_HSI.Filter := 'Previous image (' +old_extension+')|' + old_extension+'|'+
            'HSI files (*.dat;*.bil;*.bsq)|*.dat;*.bil;*.bsq|'
            + 'All files (*.*)|*.*';
        OpenDialog_HSI.FilterIndex := 1;
        OpenDialog_HSI.Title := 'Select image for correction';
        if OpenDialog_HSI.Execute then img_m:=OpenDialog_HSI.Filename else img_m:='';


        // Select fit parameter image
        Output_HSI:=ChangeFileExt(img_m, '.fit');
        OpenDialog_HSI.FileName:=Output_HSI;
        OpenDialog_HSI.Filter := 'Fit parameter image (*.fit)|*.fit|'
            + 'All files (*.*)|*.*';
        OpenDialog_HSI.Title := 'Select corresponding fit parameter image';
        if OpenDialog_HSI.Execute then img_f:=OpenDialog_HSI.Filename else img_f:='';

        // Read ENVI header files
        if flag_ENVI then begin
            Format_2D:= TFormat_2D.Create(Application);
            Format_2D.Read_Envi_Header(img_f);
            ch_fit:=Channels_in;
            ilv_fit:=interleave_in;
            dty_fit:=Datentyp;
            Format_2D.Read_Envi_Header(img_m);
            ch_img:=Channels_in;
            ilv_img:=interleave_in;
            dty_img:=Datentyp;
            ysc_img:=y_scale;
            end;

        // TO DO: prüfe Konsistenz

        // Set model parameters
        LoadINI_public(ChangeFileExt(img_f,'.WASI5_1.par'));

        // TO DO: Identifiziere Fitparameter-Nr. anhand par.name
        //     siehe unit misc, procedure set_parameter_names
        //     sowie unit Popup_2D_Format, procedure Write_Envi_Fitp_Names

        TimeStartCalc:=Now;
        Screen.Cursor:=crHourGlass;

        ABBRUCH:=FALSE;
        SetLength(HSI_in,   Width_in, Height_in, ch_img); // NOTE: may require much memory
        SetLength(HSI_edge, Height_in);

        // Import HSI image and
        // determine shift of each image line
        HSI_img^.FName:=img_m;
        Channels_in:=ch_img;
        interleave_in:=ilv_img;
        Datentyp:=dty_img;
        y_scale:=ysc_img;
        Lmin:=500;           // used for averaging spectrum
        Lmax:=550;           // used for averaging spectrum
        for f:=0 to Height_in-1 do HSI_edge[f]:=0;
        f:=0;                                      // Set f to first image line
        repeat
            x:=0;                                  // Set x to first image column
            repeat
                Format_2D.extract_spektrum_new(ms, x, f, Sender);    // import spectrum
                for c:=1 to ch_img do HSI_in[x,f,c-1]:=ms.y[c];
                average(ms);
                if abs(ms.avg)>nenner_min then inc(HSI_edge[f]);
                inc(x);
            until (x>=Width_in) or ABBRUCH;
            inc(f);
        until (f>=Height_in) or ABBRUCH;

        par.c[37]:=0;    // g_dd
        par.c[38]:=0;    // g_dsr
        par.c[39]:=0;    // g_dsa


        SetLength(HSI_rec_water, Width_in, Height_in, ch_img);
        SetLength(HSI_rec_all,   Width_in, Height_in, ch_img);
        SetLength(HSI_delta,     Width_in, Height_in, ch_img);
        SetLength(HSI_frame,     Width_in, ch_img, 3);


        { loop over frames = image lines }
        for c:=1 to ch_img do ms.y[c]:=0;
        Np_masked:=0;
        Np_water:=0;
        HSI_img^.FName:=img_f;
        Channels_in:=ch_fit;
        interleave_in:=ilv_fit;
        Datentyp:=dty_fit;
        y_scale:=1;
        f:=0;                                      // Set f to first image line
        repeat
            x:=0;                                  // Set x to first image column
            { loop over pixels = image columns }
            repeat
                (*
                // Read measured spectrum
                HSI_img^.FName:=img_m;
                Channels_in:=ch_img;
                interleave_in:=ilv_img;
                Datentyp:=dty_img;
                y_scale:=ysc_img;
                Format_2D.extract_spektrum(ms, x, f, Sender);


                // Read fit parameters
                HSI_img^.FName:=img_f;
                Channels_in:=ch_fit;
                interleave_in:=ilv_fit;
                Datentyp:=dty_fit;
                y_scale:=1;
                *)
                Format_2D.extract_spektrum_new(fp, x, f, Sender);

                // Simulate spectrum based on fit parameters
                // TO DO: Replace manual assignment by automatic assignment
                // Bands of fit image: C_phyto, C_X, C_Y, g_dd, Resid, SAngle, NIter
                par.c[1]:=fp.y[1];     // C_phyto
                par.c[7]:=fp.y[2];     // C_X
                par.c[9]:=fp.y[3];     // C_Y

                if (fp.y[7]>0) and (fp.y[6]<Thresh_SAngle) then begin // water
                    for c:=1 to ch_img do begin
                        HSI_rec_water[x,f,c-1]:=kurve(c);
                        HSI_rec_all[x,f,c-1]:=HSI_rec_water[x,f,c-1];
                        HSI_delta[x,f,c-1]:=HSI_in[x,f,c-1]-HSI_rec_water[x,f,c-1];
                        HSI_frame[x,c-1,0]:=HSI_frame[x,c-1,0]+HSI_delta[HSI_edge[f]+x,f,c-1];
                        HSI_frame[x,c-1,2]:=HSI_frame[x,c-1,2]+1;  // N
                        end;
                    inc(Np_water);
                    end
                else begin  // no water
                    for c:=1 to ch_img do begin
                        HSI_rec_water[x,f,c-1]:=0;
                        HSI_rec_all[x,f,c-1]:=HSI_in[x,f,c-1];
                        HSI_delta[x,f,c-1]:=0;
                        end;
                    inc(Np_masked);
                    end;
                inc(x);
            until (x>=Width_in) or ABBRUCH;
            inc(f);
        until (f>=Height_in) or ABBRUCH;

        // Average HSI_frame
        for x:=0 to Width_in-1 do
            for c:=1 to ch_img do
                if HSI_frame[x,c-1,2]>1 then
                    HSI_frame[x,c-1,0]:=HSI_frame[x,c-1,0]/HSI_frame[x,c-1,2];

        flag_use_ROI:=FALSE;
        interleave_out:=ilv_fit;
        Datentyp:=4;
        y_scale:=1;
        Channels_out:=ch_img;
        Channel_Number:=ch_img;

        // Save reconstructed image; only water
        SetLength(cube_fitpar,   Width_in, Height_in, ch_fit);
        Output_HSI:=ExtractFilePath(img_m) + ExtractFileName(ChangeFileExt(img_m,''))+
             Acr_rec_water+ExtractFileExt(img_m);
        cube_fitpar:=HSI_rec_water;
        Format_2D.Write_Fitresult(Height_in-1);
        TimeCalc  :=MilliSecondsBetween(Now, TimeStartCalc)/1000;
        Format_2D.Write_Envi_Header_spec(Output_HSI,ch_img);

        // Save reconstructed image; all pixels
        Output_HSI:=ExtractFilePath(img_m) + ExtractFileName(ChangeFileExt(img_m,''))+
             Acr_rec_all+ExtractFileExt(img_m);
        cube_fitpar:=HSI_rec_all;
        Format_2D.Write_Fitresult(Height_in-1);
        TimeCalc  :=MilliSecondsBetween(Now, TimeStartCalc)/1000;
        Format_2D.Write_Envi_Header_spec(Output_HSI,ch_img);

        // Save ratio -1 between fitted and measured HSI
        Output_HSI:=ExtractFilePath(img_m) + ExtractFileName(ChangeFileExt(img_m,''))+
             Acr_delta+ExtractFileExt(img_m);
        cube_fitpar:=HSI_delta;
        Format_2D.Write_Fitresult(Height_in-1);
        TimeCalc  :=MilliSecondsBetween(Now, TimeStartCalc)/1000;
        Format_2D.Write_Envi_Header_spec(Output_HSI,ch_img);

        // save frame in detector coordinate system
        Channels_out:=3;
        Height_in:=ch_img;
        SetLength(cube_fitpar,   Width_in, Height_in, Channels_out);
        Output_HSI:=ExtractFilePath(img_m) + ExtractFileName(ChangeFileExt(img_m,''))+
             Acr_frame+ExtractFileExt(img_m);
        cube_fitpar:=HSI_frame;
        Format_2D.Write_Fitresult(ch_img-1);
        TimeCalc  :=MilliSecondsBetween(Now, TimeStartCalc)/1000;
        Format_2D.Write_Envi_Header_spec(Output_HSI,Channels_out);

        SetLength(cube_fitpar,   0, 0, 0);    // free memory
        SetLength(HSI_rec_water, 0, 0, 0);    // free memory
        SetLength(HSI_rec_all,   0, 0, 0);    // free memory
        SetLength(HSI_delta,     0, 0, 0);    // free memory

        // Correct HSI image
        HSI_img^.FName:=img_m;
        Channels_in:=ch_img;
        interleave_in:=ilv_img;
        Datentyp:=dty_img;
        y_scale:=ysc_img;
        SetLength(HSI_cor, Width_in, Height_in, ch_img);
        f:=0;                                      // Set f to first image line
        repeat
            x:=0;                                  // Set x to first image column
            repeat
     //           Format_2D.extract_spektrum(ms, x, f, Sender);
                if (x-HSI_edge[f])>=0 then for c:=1 to ch_img do
                    HSI_cor[x,f,c-1]:=HSI_in[x,f,c-1]*(1+HSI_frame[x-HSI_edge[f],c-1,0]);
                inc(x);
            until (x>=Width_in) or ABBRUCH;
            inc(f);
        until (f>=Height_in) or ABBRUCH;


        // Save corrected image; all pixels
        Output_HSI:=ExtractFilePath(img_m) + ExtractFileName(ChangeFileExt(img_m,''))+
             Acr_cor+ExtractFileExt(img_m);
        cube_fitpar:=HSI_cor;
        Format_2D.Write_Fitresult(Height_in-1);
        TimeCalc  :=MilliSecondsBetween(Now, TimeStartCalc)/1000;
        Format_2D.Write_Envi_Header_spec(Output_HSI,ch_img);

        SetLength(HSI_in,        0, 0, 0);    // free memory
        SetLength(HSI_cor,       0, 0, 0);    // free memory
        SetLength(HSI_frame,     0, 0, 0);    // free memory
        SetLength(HSI_edge,      0);          // free memory

        Screen.Cursor:=crDefault;
        Save_img.visible:=flag_preview;
        end;

procedure TForm1.End2Change(Sender: TObject);
begin
   Frame_Batch1.End2Change(Sender);
   end;


procedure TForm1.End3Change(Sender: TObject);
begin
    Frame_Batch1.End3Change(Sender);
    end;


procedure TForm1.DefineAreas;
{ Define coordinates of plot window. }
begin
    DrawArea.Left   := xkoo(xu, ClientWidth);
    DrawArea.Right  := xkoo(xo, ClientWidth);
    DrawArea.Top    := ykoo(yo, ClientHeight);
    DrawArea.Bottom := ykoo(yu, ClientHeight);
    RectArea.Left   := DrawArea.Left;
    RectArea.Right  := DrawArea.Right+1;
    RectArea.Top    := DrawArea.Top;
    RectArea.Bottom := DrawArea.Bottom+1;
    ClearArea.Left   := 0;
    ClearArea.Right  := ClientWidth;
    ClearArea.Top    := 0;
    ClearArea.Bottom := ClientHeight;
    end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
{ Works only for KeyPreview = TRUE }
begin
    if (Shift = [ssCtrl]) and (Upcase(Char(Key)) = 'C') then
        if MessageDlg('Abort processing?', mtConfirmation, [mbYes,mbNo], 0) = mrYes then
            ABBRUCH:=TRUE;
    end;

procedure TForm1.Response1Click(Sender: TObject);
begin
    Plot_Spectrum(resp, TRUE, Sender);
    end;

procedure TForm1.Signal1Click(Sender: TObject);
begin
    calc_R_rs;
    simulate_sensor_signal(1);
    Plot_Spectrum(signal, TRUE, Sender);
    end;

procedure TForm1.Lpath1Click(Sender: TObject);
begin
    Plot_Spectrum(Lpath, TRUE, Sender);
    end;


procedure TForm1.MPa_iClick(Sender: TObject);
begin
    Plot_Spectrum(MP_a_i, TRUE, Sender);
    end;


procedure TForm1.aIce1Click(Sender: TObject);            // Display - Water - a_ice
begin                                                    // Input spectrum
    Plot_Spectrum(a_ice, TRUE, Sender);
    end;

procedure TForm1.aCDOM1Click(Sender: TObject);
begin
    Plot_Spectrum(aCDOM_calc^, TRUE, Sender);
    end;

procedure TForm1.CheckBatchChange(Sender: TObject);
begin

end;

procedure TForm1.MPbb_iClick(Sender: TObject);
begin
    Plot_Spectrum(MP_bb_i, TRUE, Sender);
    end;

procedure TForm1.MPKd_iClick(Sender: TObject);
begin
    Plot_Spectrum(MP_Kd_i, TRUE, Sender);
    end;

procedure TForm1.MPKd_pClick(Sender: TObject);
begin
    Plot_Spectrum(MP_Kd_p, TRUE, Sender);
    end;

procedure TForm1.MPku_iClick(Sender: TObject);
begin
    Plot_Spectrum(MP_ku_i, TRUE, Sender);
    end;

procedure TForm1.MPku_pClick(Sender: TObject);
begin
    Plot_Spectrum(MP_ku_p, TRUE, Sender);
    end;

procedure TForm1.MPlds_iceClick(Sender: TObject);
begin
    Plot_Spectrum(MP_lds_ice, TRUE, Sender);
    end;

procedure TForm1.MPp_iceClick(Sender: TObject);
begin
    Plot_Spectrum(MP_p_ice, TRUE, Sender);
    end;

procedure TForm1.MPQ_iClick(Sender: TObject);
begin
   Plot_Spectrum(MP_Qi, TRUE, Sender);
   end;

procedure TForm1.MPriClick(Sender: TObject);
begin
    Plot_Spectrum(MP_ri, TRUE, Sender);
    end;

procedure TForm1.MPri_infClick(Sender: TObject);
begin
    Plot_Spectrum(MP_ri_inf, TRUE, Sender);
    end;


procedure TForm1.XGrid;
{ Scale x-axis, plot x-axis and vertical lines. }
var VA,DV  : real;
    NV     : integer;
    j, n   : integer;
    XPos   : integer;
    TDim   : TSize;
    TextX  : String;
begin
    Auto_Scale(xu, xo, VA, DV, NV);
    if flag_grid then begin
        Canvas.Brush.Color:=clBtnFace; { Background colour }
        Canvas.Pen.Color := clBtnFace;
        if flag_Subgrid then begin
            for n:=-1 to NV do
            for j:=0 to ZwischenX do begin
                XPos:=xkoo(VA+(n + j/(1+ZwischenX))*DV, ClientWidth);
                Canvas.MoveTo(XPos, ykoo(yu, ClientHeight));
                Canvas.LineTo(XPos, ykoo(yo, ClientHeight));
                end;
            Canvas.Pen.Color := clBlack;
            end;
        for n:=0 to NV-1 do begin
            XPos:=xkoo(VA+n*DV, ClientWidth);
            Canvas.MoveTo(XPos, ykoo(yu, ClientHeight));
            Canvas.LineTo(XPos, ykoo(yo, ClientHeight));
            end;
        end;

    Canvas.Font.Charset:=GREEK_CHARSET;
    Canvas.Font.size:=10;
    Canvas.Font.Name := 'MS Sans Serif';

    Canvas.Pen.Color := clBlack;
    Canvas.Brush.Color:=clBtnFace; { Background colour }
    for n:=0 to NV-1 do begin
        XPos:=xkoo(VA + n*DV, ClientWidth);
        Canvas.MoveTo(XPos, ykoo(yu, ClientHeight));
        Canvas.LineTo(XPos, ykoo(yu, ClientHeight)+label_X);
        textX:=schoen(VA + n*DV, SIG);
        TDim:=Canvas.TextExtent(textX);
        Canvas.TextOut(XPos - TDim.cx div 2,
                       ykoo(yu, ClientHeight)+TDim.cy, textX);
        end;
    Canvas.Font.Style := [fsbold];
    textX:=XText;
    TDim:=Canvas.TextExtent(textX);
    Canvas.TextOut(xkoo(0.5*(xu+xo), ClientWidth) - TDim.cx div 2,
                       ykoo(yu, ClientHeight)+ tu_ofs + TDim.cy, textX);
    Canvas.Font.Style := [];
    end;

procedure TForm1.YGrid;
{ Scale y-axis, plot y-axis and horizontal lines. }
var VA,DV  : real;
    NV     : integer;
    j, n   : integer;
    TDim   : TSize;
    TextY  : String;

begin
    Auto_Scale(yu, yo, VA, DV, NV);

    if flag_grid then begin
        Canvas.Pen.Color := clBtnFace;

        if flag_Subgrid then begin
            for n:=-1 to NV do
            for j:=0 to ZwischenX do begin
                Canvas.MoveTo(xkoo(xu, ClientWidth), ykoo(VA+(n + j/(1+ZwischenX))*DV, ClientHeight));
                Canvas.LineTo(xkoo(xo, ClientWidth), ykoo(VA+(n + j/(1+ZwischenX))*DV, ClientHeight));
                end;
            Canvas.Pen.Color := clBlack;
            end;
        for n:=0 to NV-1 do begin
            Canvas.MoveTo(xkoo(xu, ClientWidth), ykoo(VA+n*DV, ClientHeight));
            Canvas.LineTo(xkoo(xo, ClientWidth), ykoo(VA+n*DV, ClientHeight));
            end;

        end;

    Canvas.Pen.Color := clBlack;
    Canvas.Brush.Color:=clBtnFace;
    for n:=0 to NV-1 do begin
        Canvas.MoveTo(xkoo(xu, ClientWidth)-Label_Y, ykoo(VA+n*DV, ClientHeight));
        Canvas.LineTo(xkoo(xu, ClientWidth), ykoo(VA+n*DV, ClientHeight));
        textY:=schoen(VA+n*DV, 2);
        TDim:=Canvas.TextExtent(textY);
        Canvas.TextOut(xkoo(xu, ClientWidth)-Text_Y-TDim.cx,
                       ykoo(VA+n*DV,ClientHeight)-TDim.cy div 2, textY);
        end;
    Canvas.Font.Style := [fsBold];
    textY:=YText;
    TDim:=Canvas.TextExtent(textY);
    Canvas.TextOut(xkoo(xu, ClientWidth) - tl_ofs,
                       ykoo(yo, ClientHeight)- to_ofs - TDim.cy, textY);
    Canvas.Font.Style := [];
    textY:=ActualFile;
    TDim:=Canvas.TextExtent(textY);
    Canvas.TextOut(xkoo(xo, ClientWidth) - TDim.cx,
                       ykoo(yo, ClientHeight)- to_ofs - TDim.cy, textY);
    end;

procedure TForm1.Legende;
{ When 2 spectra are shown in the forward mode, plot their legend. }
begin
    if {flag_batch and} (NSpectra=2) then begin
        Canvas.Pen.Color := farbS[1];
        Canvas.MoveTo(ClientWidth-DX_right-150, DY_top+32);
        Canvas.LineTo(ClientWidth-DX_right-100, DY_top+32);
        Canvas.Pen.Color := farbS[2];
        Canvas.MoveTo(ClientWidth-DX_right-150, DY_top+48);
        Canvas.LineTo(ClientWidth-DX_right-100, DY_top+48);
        Canvas.Pen.Color := clBlack;
        canvas.brush.style := bsClear;
        Canvas.TextOut(ClientWidth-DX_right-90, DY_top+26, spec[1]^.ParText);
        Canvas.TextOut(ClientWidth-DX_right-90, DY_top+42, spec[2]^.ParText);
        end;
    end;

procedure TForm1.Legend_par(c:integer; text:string; yofs: integer);
{ Create parameter legend in color 'c' with text 'text'.}
const len = 40;
      dx  = 10;
var   x0, y0 : integer;
      TDim   : TSize;
begin
    Canvas.Font.size:=9;
    Canvas.Font.Name := 'MS Sans Serif';
    Canvas.Font.Charset:=GREEK_CHARSET;
    TDim:=Canvas.TextExtent(text);
    if yofs>0 then yofs:=round(1.3*TDim.cy);
    if flag_leg_top then y0:=RectArea.Top+50+TDim.cy
                    else y0:=RectArea.Bottom-40-TDim.cy;

    Canvas.Pen.Color   := c;
    canvas.brush.style := bsClear;
    if flag_leg_left then begin     // align legend on right side
        x0:=RectArea.Left+dx;
        Canvas.MoveTo(x0+dx, y0+yofs);
        Canvas.LineTo(x0+dx+len, y0+yofs);
        // Make line 3 pixels thick
        Canvas.MoveTo(x0+dx, y0+yofs-1);
        Canvas.LineTo(x0+dx+len, y0+yofs-1);
        Canvas.MoveTo(x0+dx, y0+yofs+1);
        Canvas.LineTo(x0+dx+len, y0+yofs+1);
        Canvas.Pen.Color := clBlack;
        Canvas.TextOut(x0+2*dx+len, y0+yofs-TDim.cy div 2, text);
        end
    else begin                     // align legend on left side
        x0:=RectArea.Right-dx;
        Canvas.MoveTo(x0-TDim.cx-len-2*dx, y0+yofs);
        Canvas.LineTo(x0-TDim.cx-2*dx, y0+yofs);
        // Make line 3 pixels thick
        Canvas.MoveTo(x0-TDim.cx-len-2*dx, y0+yofs-1);
        Canvas.LineTo(x0-TDim.cx-2*dx, y0+yofs-1);
        Canvas.MoveTo(x0-TDim.cx-len-2*dx, y0+yofs+1);
        Canvas.LineTo(x0-TDim.cx-2*dx, y0+yofs+1);
        Canvas.Pen.Color := clBlack;
        Canvas.TextOut(x0-TDim.cx-dx, y0+yofs-TDim.cy div 2, text);
        end;
    end;

procedure TForm1.Inactivate_Background;
{ Delete background image (shown at program start) from RAM after the first plot. }
begin
    show_bkgrd:=FALSE;
    ImageBackground.Free;
    Update;
    end;

procedure TForm1.Farben1;
{ Define line colour for plotting 1 spectrum. }
begin
    farbS[1]:=clBlue;
    end;

procedure TForm1.Farben2;
{ Define line colours for plotting 2 spectra. }
begin
    farbS[1]:=clBlue;
    farbS[2]:=clRed;
    end;

procedure TForm1.FarbenSucc;
{ Define line colours for plotting an arbitrary number of spectra. }
var f : integer;
begin
    for f:=1 to MaxSpectra do farbS[f]:=clBlue;
    end;

procedure TForm1.Zeichne_Kurve(nr: word; out dots: word);
{ Plot spectrum number nr as solid line. }
var j : word;
begin
    dots:=0;
    Canvas.Pen.Color := farbS[nr];
    Canvas.MoveTo(xkoo(x.y[1], ClientWidth),
        ykoo(spec[nr]^.y[1], ClientHeight));
    for j:=2 to Channel_number do
        if (x.y[j]>=xu) and (x.y[j]<=xo) then begin
        Canvas.LineTo(xkoo(x.y[j], ClientWidth),
            ykoo(spec[nr]^.y[j], ClientHeight));
        inc(dots);
        end;

    // Increase line thickness for high-dpi monitors
    // Should be made optional
    Canvas.MoveTo(xkoo(x.y[1], ClientWidth),
        ykoo(spec[nr]^.y[1], ClientHeight)+1);
    for j:=2 to Channel_number do
        if (x.y[j]>=xu) and (x.y[j]<=xo) then begin
        Canvas.LineTo(xkoo(x.y[j], ClientWidth),
            ykoo(spec[nr]^.y[j], ClientHeight)+1);
        end;

    end;

procedure TForm1.Zeichne_Punkte(nr: word);
{ Plot spectrum number nr as dotted line. }
var j : word;
begin
    Canvas.Brush.Color:=clPlotBk;
    for j:=1 to Channel_number do
        if (x.y[j]>=xu) and (x.y[j]<=xo) then
            Canvas.Ellipse(xkoo(x.y[j], ClientWidth)-dotsize,
                ykoo(spec[nr]^.y[j], ClientHeight)-dotsize,
                xkoo(x.y[j], ClientWidth)+dotsize,
                ykoo(spec[nr]^.y[j], ClientHeight)+dotsize);
    end;


procedure TForm1.Zeichne(Sender:TObject; flag_screenshot: boolean);
{ Refresh plot window, then plot the actual spectra.
  flag_screenshot was added on 13 March 2020. }
var nr, dots : word;
begin
    if flag_clear then begin
        if show_bkgrd=TRUE then begin
            Inactivate_Background;
     //       OnPaint:=Zeichne;       deactivated 13.3.2020 as no longer working
            end;
        DefineAreas;
        Canvas.Brush.Color:=clBtnFace;
        Canvas.FillRect(ClearArea);
        Canvas.Brush.Color:=clPlotBk;
        Canvas.FillRect(DrawArea);
        xgrid;
        ygrid;
        if flag_legend then Legende;
        end;
    for nr:=1 to NSpectra do begin
        Zeichne_Kurve(nr, dots);
        if flag_dots and (dots<dotMaxN) then Zeichne_Punkte(nr);
        end;
    if flag_screenshot then SavePlotWindow(Sender, DIR_saveFwd + '\' + SCREENSHOT);
    if flag_clear then begin
        Canvas.Brush.Color := clBlack;
        Canvas.FrameRect(RectArea);
        end;

    end;

procedure TForm1.FrameGroesse(Sender: TObject);
{ Define position of the elements of the main window. }
const  dy = 20;
begin
    Update_DPI(Sender);   //RR

    if flag_Ed_Gege then Frame_r1.Height:=min(DY_par+dy_gege, Form1.ClientHeight)
                    else Frame_r1.Height:=min(DY_par, Form1.ClientHeight);
    Frame_r1.Top      :=Form1.ClientHeight-Frame_r1.Height;
    Frame_r1.Left     :=round(Scale_gui*4);                   //RR
    DY_modes          :=CheckShallow.Height+dy+CheckBoxL.Height+dy+
                        CheckSurface.Height+dy+CheckFresnel.Height;
    ComboBox.Top      :=Form1.ClientHeight-DY_modes-dy-StartButton.Height-DY_bottom-
                        ComboBox.Height-dY_bottom;
    ComboSensor.Top   :=ComboBox.Top;
    DY_leg            :=DY_modes+DY_bottom+StartButton.Height+DY_bottom;
                        {+ComboBox.Height+dy}
    StartButton.Top   :=ComboBox.Top+ComboBox.Height+DY_bottom;
    CheckShallow.Top  :=StartButton.Top+StartButton.Height+dy;
    CheckBoxaW.Top    :=CheckShallow.Top;
    CheckAbove.Top    :=CheckShallow.Top+CheckShallow.Height+dy;
    CheckBoxL.Top     :=CheckAbove.Top;
    CheckSurface.Top  :=CheckAbove.Top+CheckAbove.Height+dy;
    CheckFresnel.Top  :=CheckSurface.Top+CheckSurface.Height+dy;
    Frame_Batch1.Top  :=Form1.ClientHeight-Frame_Batch1.Height;
    Frame_Batch1.Left :=Form1.ClientWidth-DX_right-Frame_Batch1.width;
    Frame_Res1.Top    :=Form1.ClientHeight-Frame_Res1.Height-DY_bottom;
    Frame_Res1.Left   :=Form1.ClientWidth-DX_right-Frame_Res1.width;
    Counter.Top       :=RectArea.Top+20;
    Counter.Left      :=RectArea.Right-Counter.Width-20;
    if show_bkgrd=FALSE then zeichne(Sender, TRUE);
    end;

procedure TForm1.update_GUI(Sender: TObject);
{ Update the Graphical User Interface. }
begin
    Frame_Res1.Visible:=flag_b_invert and not flag_batch;
    Label_calc_Rbottom.Visible:=(not flag_public) and flag_b_invert and
        flag_Rbottom and ((spec_type=S_Rrs) or (spec_type=S_R));
    CheckAbove.visible:=FALSE;
    CheckSurface.visible:=FALSE;
    CheckShallow.visible:=FALSE;
    CheckBoxaW.visible:=FALSE;
    CheckBoxL.visible:=FALSE;
    CheckFresnel.visible:=FALSE;
    if flag_b_Invert then CheckSurface.checked:=flag_surf_inv
                     else CheckSurface.checked:=flag_surf_fw;
    CheckShallow.checked:=flag_shallow;
    if not flag_batch then counter.hide; { 1 file }
    if flag_b_Invert then Frame_Batch1.Panel2Hide.visible:=
                          flag_b_LoadAll or not flag_batch
                     else Frame_Batch1.Panel2Hide.visible:=FALSE;
    if flag_2D_inv then begin
        Frame_Batch1.Panel2Hide.visible:=TRUE;
        Frame_Res1.visible:=TRUE;
        end;
    Frame_Res1.update_parameterlist(Sender);
    FrameGroesse(Sender);
    case spec_type of
        S_Ed_GC : begin { downwelling irradiance }
                Active_Ed_GC;
                CheckAbove.visible:=TRUE;
                end;
        S_Lup : begin { upwelling radiance }
                Active_Lup;
                CheckAbove.visible:=TRUE;
                CheckSurface.visible:=flag_above;
                CheckFresnel.visible:=flag_above and not flag_2D_inv;
                CheckShallow.visible:=TRUE;
                end;
        S_Rrs: begin { radiance reflectance }
                Active_Rrs;
                CheckAbove.visible:=TRUE;
                CheckSurface.visible:=flag_above;
                CheckFresnel.visible:=flag_above and not flag_2D_inv;
                CheckShallow.visible:=TRUE;
                end;
       S_R : begin { irradiance reflectance }
                Active_R;
                CheckShallow.visible:=TRUE;
                end;
       S_Rsurf : begin { specular reflectance }
                Active_R_surf;
                CheckSurface.visible:=TRUE;
                CheckFresnel.visible:=flag_above and not flag_2D_inv;
                end;
        S_a : begin { absorption }
                Active_a;
                CheckBoxaW.visible:=TRUE;
                end;
        S_Kd : begin { diffuse attenuation }
                Active_K;
                end;
        S_Rbottom : begin { bottom reflectance }
                Active_Rbottom;
                CheckBoxL.visible:=TRUE;
                end;
        S_Ed_Gege : begin { downwelling irradiance }
                flag_Ed_Gege:=TRUE;
                FrameGroesse(Sender);
                Active_R_surf_Gege;
                CheckAbove.visible:=TRUE;
                end;
        S_test : begin { Test spectrum }
                if flag_MP then
                    ComboBox.Items[8]:='Melt pond reflectance';
                FrameGroesse(Sender);
                if flag_MP then Active_meltpond else Active_all;
                end;
        end;
    Frame_Batch1.update_parameterlist(Sender);
    Frame_r1.updte(Sender);
    end;

procedure TForm1.ComboBoxChange(Sender: TObject);
{ User clicks on the combo box 'spectrum type' . }
begin
    spec_type:=spec_types(ComboBox.ItemIndex);
    update_GUI(Sender);
    end;

procedure TForm1.CheckBoxaWClick(Sender: TObject);
{ User clicks on the selection box 'include pure water'. }
begin
    flag_aW:=CheckBoxaW.checked;
    Active_a;
    Frame_r1.updte(Sender);
    end;

procedure TForm1.CheckFresnelClick(Sender: TObject);
{ User clicks on the selection box 'calculate rho_L from viewing angle'. }
begin
    flag_Fresnel_view:=CheckFresnel.checked;
    update_GUI(Sender);
    end;

procedure TForm1.Frame_Batch1CheckInvertClick(Sender: TObject);
{ User clicks on the selection box 'invert spectra'. }
begin
  Frame_Batch1.CheckInvertClick(Sender);
  update_GUI(Sender);
  end;

procedure TForm1.Frame_Batch1CheckBatchClick(Sender: TObject);
{ User clicks on the selection box 'batch mode'. }
begin
  Frame_Batch1.CheckBatchClick(Sender);
  update_GUI(Sender);
  end;

procedure TForm1.Frame_Batch1CheckReadFileClick(Sender: TObject);
{ User clicks on the selection box 'read from file'. }
begin
  Frame_Batch1.CheckReadFileClick(Sender);
  update_GUI(Sender);
  end;

procedure TForm1.Frame_Batch1End1Change(Sender: TObject);
begin
  Frame_Batch1.End1Change(Sender);

end;

procedure TForm1.Frame_Batch1Start1Change(Sender: TObject);
begin
  Frame_Batch1.Start1Change(Sender);

end;

procedure TForm1.Frame_r1beta_fitClick(Sender: TObject);
begin
  Frame_r1.beta_fitClick(Sender);

end;

procedure TForm1.Frame_r1CL_fitClick(Sender: TObject);
begin
  Frame_r1.CL_fitClick(Sender);

end;

procedure TForm1.Frame_r1g_dd_fitClick(Sender: TObject);
begin
  Frame_r1.g_dd_fitClick(Sender);

end;

procedure TForm1.CheckBoxLClick(Sender: TObject);
{ User clicks on the selection box 'radiance sensor'. }
begin
    flag_L:=CheckBoxL.checked;
    end;

procedure TForm1.CheckAboveClick(Sender: TObject);
{ User clicks on the selection box 'above water'. }
begin
    flag_above:=CheckAbove.checked;
    if not flag_above then CheckSurface.visible:=FALSE;
    update_GUI(Sender);
    end;

procedure TForm1.CheckSurfaceClick(Sender: TObject);
{ User clicks on the selection box 'wavelength dependent surface reflections'. }
begin
    if flag_b_Invert then flag_surf_inv:=CheckSurface.checked
                     else flag_surf_fw :=CheckSurface.checked;
    update_GUI(Sender);
    end;

procedure TForm1.CheckShallowClick(Sender: TObject);
{ User clicks on the selection box 'shallow water'. }
begin
    flag_shallow:=CheckShallow.checked;
    update_GUI(Sender);
    end;

{ **************************************************************************** }
{ ****************               Execute Program               *************** }
{ **************************************************************************** }


function TForm1.SavePlotWindow(Sender: TObject; FileName: String): Boolean;
{ Save screenshot of the plot window to file.
  Note: The previous Delphi code (using BitBlt) produced a black image.
  Die SaveToFile Methode extrahiert die Extension und sucht sich dann die dazu registrierten
  TGraphic Typen. Alle TGraphic Typen sind in einer Liste zusammen mit ihrer Extension gespeichert.}
var bmp        : TBitmap;     // Bitmap of screenshot image
    pic        : TPicture;    // Picture of screenshot image; for conversion to PNG
    hnd        : hWnd;        // Window handle
    DC         : HDC;         // Handle of TForm1 window
    WinRect    : TRect;       // Rectangle of TForm1 window
    Ausschnitt : TRect;       // Selected area for screenshot
    W, H       : integer;     // Width and height of screenshot area
begin
    Ausschnitt := Rect(0,0,0,0);
    try
        hnd := self.handle;
        GetWindowRect(hnd, WinRect);
        DC := GetDC(hnd);
        Ausschnitt.Left   := DrawArea.Left - DX_leg;
        Ausschnitt.Right  := DrawArea.Right + DX_right;
        Ausschnitt.Top    := DrawArea.Top - DY_top + 10;
        Ausschnitt.Bottom := ComboBox.Top-2;
        W := Ausschnitt.Right  - Ausschnitt.Left;
        H := Ausschnitt.Bottom - Ausschnitt.Top;
        bmp := TBitmap.Create;
        bmp.Width  := W;
        bmp.Height := H;
        bmp.Canvas.CopyRect(Rect(0,0,W,H), Self.Canvas, Ausschnitt);
        Result := True;
        pic := TPicture.Create;
        pic.Bitmap.Assign(bmp);
        try pic.SaveToFile(Filename) except Result:=False end;
        finally
            ReleaseDC(hnd, DC);
            bmp.Free;
            pic.Free;
            end;
    end;

procedure TForm1.StartButtonClick(Sender: TObject);
{ User clicks on "Start" button. }
var temp_zBf    : double;  { Bottom depth in forward mode }
    temp_zBi    : double;  { Bottom depth in inverse mode }
    temp_zf     : double;  { Sensor depth in forward mode }
    temp_zi     : double;  { Sensor depth in inverse mode }
    temp_zB_fit : byte;
    temp_fA_fit : array[0..5]of byte;
    j           : integer;
begin
    TimeStartCalc:=Now;
    if not flag_fluo then begin
        set_zero(Lf^);
        set_zero(RrsF^);
        end;
    temp_zBf :=zB.fw;
    temp_zBi :=zB.actual;
    temp_zf  :=z.fw;
    temp_zi  :=z.actual;
    temp_zB_fit :=zB.fit;
    for j:=0 to 5 do temp_fA_fit[j]:=fA[j].fit;
    if not flag_shallow then begin     // optically deep water
        zB.fw     :=1000;              // set bottom depth = 1000 m
        zB.actual :=1000;              // set bottom depth = 1000 m
        zB.fit    :=0;                 // no fit of water depth
        for j:=0 to 5 do fA[j].fit:=0; // no fit of bottom parameters
        end;
    if NSpectra>1 then NSpectra:=1;  { new 2D }
    if (not flag_2D_inv) then begin  { 1D mode of WASI }
        if not flag_b_invert then Run_Batch(Sender)
        else if flag_batch then Run_Batch(Sender)
                           else Run_Invers(Sender);
        end
    else begin                       { 2D mode of WASI }
        if flag_b_invert then Run_Batch(Sender)         { invert image }
        else if flag_batch then Run_Batch(Sender)       { invert area }
        else if flag_b_loadAll then Run_Invers(Sender); { invert spectrum }
        end;

    { Refresh y-axis as it may be partly overwritten by lines from the plot }
    Canvas.Pen.Color := clBlack;
    Canvas.MoveTo(RectArea.Left, RectArea.Top);
    Canvas.LineTo(RectArea.Left, RectArea.Bottom);

    { Save plot window to file }
   { if not flag_public then }if not
        SavePlotWindow(Sender, DIR_saveFwd + '\' + SCREENSHOT) then
        MessageDlg('Could not save screenshot', mtWarning, [mbOK], 0);

    if flag_Background then Application.Terminate;
    { Note: 'close' doesn't terminate the 'WASI' process in background mode. }

    TimeCalc  :=MilliSecondsBetween(Now, TimeStartCalc)/1000;
    zB.fw     :=temp_zBf;
    zB.actual :=temp_zBi;
    z.fw      :=temp_zf;
    z.actual  :=temp_zi;
    zB.fit    :=temp_zB_fit;
    for j:=0 to 5 do fA[j].fit:=temp_fA_fit[j];
    end;


function ShutdownBlockReasonCreate(hWnd: hWnd; pwszReason: LPCWSTR): Bool;
  stdcall; external user32 name 'ShutdownBlockReasonCreate';

function ShutdownBlockReasonDestroy(hWnd: hWnd): Bool; stdcall;
  external user32 name 'ShutdownBlockReasonDestroy';


//procedure WMQueryEndSession(var AMsg : TWMQueryEndSession); message WM_QUERYENDSESSION;
procedure TForm1.WMQueryEndSession(var AMsg: TWMQueryEndSession);
{ Confirm that WASI wants to block shutdown. See:
  https://csharp.develop-bugs.com/article/25333640/Using+TEventLog+in+lazarus}
begin
    if flag_fit_running then AMsg.Result:=0 else inherited;
    end;

procedure TForm1.Run_Batch(Sender:TObject);
{ Depending on the flags, execute the apropriate batch mode. }
{ Comment from 23 April 2020:
  I added procedures which should disable Windows shutdown during data
  processing. This is described here:
  https://csharp.develop-bugs.com/article/25333640/Using+TEventLog+in+lazarus.
  Not sure if it really works. If not, the reason could be the registry entries
  ActiveHoursStart and ActiveHoursEnd. These should be changed to prohibit a
  reboot. However, elevated privilege is needed to change these registry
  settings. My philosophy is however not to touch the registry and operating
  WASI should not require  administrator rights.
  There are perhaps other programming options, but they are not clear to me:
  https://www.lazarusforum.de/viewtopic.php?f=55&t=8269#
  The safest way seems disabling shutdown directly in Windows:
  https://www.pc-magazin.de/ratgeber/windows-10-automatische-neustarts-deaktivieren-unterbinden-3197200.html
  }
var  LErr: Cardinal;
     warning : string;
begin
    merk_fit;                                            // Note which parameters are fit parameters
    merk_fw;                                             // Note parameters of forward mode
    if flag_2D_inv then begin                            // 2D mode
        // Disable computer shutdown
        if (not ShutdownBlockReasonCreate(Application.MainForm.Handle,
            'WASI image processing running')) then begin
            LErr := GetLastError;
            warning:=SysErrorMessage(LErr);
            MessageBox(0, PChar(warning), 'Warning: Disabling computer shutdown failed:',
                MB_ICONSTOP+MB_OK);
            end;

        // Invert image
        if (flag_b_Invert or flag_batch) then Invert_2D(Sender);

        // Enable computer shutdown
        if (not ShutdownBlockReasonDestroy(Application.MainForm.Handle)) then begin
            LErr := GetLastError;
            warning:=SysErrorMessage(LErr);
            MessageBox(0, PChar(warning), 'Warning: Enabling computer shutdown failed:',
                MB_ICONSTOP+MB_OK);
            end;
        end;
    if flag_CEOS and (not flag_public) and (Par3_Type<>0)then begin // simulations for CEOS study
        scenario:= Dialogs.InputBox('Add scenario description to file name', 'Scenario:', #0);
        run_CEOS_simulation(Sender)                      // in unit CEOS
        end
    else if not flag_2D_inv then begin                   // 1D mode
        if (flag_b_Invert and flag_b_LoadAll)
            then Invert_Files(Sender)                    // inverse mode
            else Forward_Mode(Sender);                   // forward mode
        end;
    restore_fit;                                         // Restore information which parameters are fit parameters
    restore_fw;                                          // Restore parameters of forward mode
    end;

procedure TForm1.Forward_Mode(Sender:TObject);
{ Execute Forward Mode and Reconstruction Mode. }
var d1, d2, d3 : double;          // Data intervals
    N, N_total : integer;         // Number of spectra
    NoX, NoY   : integer;
    dots       : word;            // Number of data points in plot range
    s_total    : String;
    i          : integer;
    N_file     : String;
    N_string   : String;
    fl_sv_tb   : boolean;
    fl_fw      : boolean;
begin
   flag_clear:=TRUE;
   set_YText;
   ActualFile:='Simulated spectra';
   if Par1_min>Par1_max then begin c1:=Par1_min; Par1_min:=Par1_max; Par1_max:=c1; end;
   if Par2_min>Par2_max then begin c2:=Par2_min; Par2_min:=Par2_max; Par2_max:=c2; end;
   if Par3_min>Par3_max then begin c3:=Par3_min; Par3_min:=Par3_max; Par3_max:=c3; end;

   { Prepare Forward Mode }
   if flag_b_invert=FALSE then begin
       merk_fw;                   // Store the actual parameter values of forward mode
       scale_plot_batch(r_rs^.y); // Determine ymin and ymax for scaling of plot
                                  // Argument is used only in private WASI mode
                                  // Argument must be set here

       FarbenSucc;                // Set colours of plot
       zeichne(Sender, FALSE);    // Draw coordinate system
       flag_clear:=FALSE;         // Don't refresh plot area
       for i:=1 to Channel_number do begin
           his_1st^.y[i]:=0;      // initialize histogram of 1st derivatives
           his_2nd^.y[i]:=0;      // initialize histogram of 2nd derivatives
           dold[i]:=0;
           dnew[i]:=0;
           end;
       end
    { Prepare Reconstruction Mode }
    else begin
       merk_actual;               // Store the actual parameter values of inverse mode
       end;

   { Determine data intervals and number of iterations }
   if Par1_N>1 then d1:=(Par1_Max-Par1_Min)/(Par1_N-1) else d1:=0;
   if Par2_N>1 then d2:=(Par2_Max-Par2_Min)/(Par2_N-1) else d2:=0;
   if Par3_N>1 then d3:=(Par3_Max-Par3_Min)/(Par3_N-1) else d3:=0;
   if Par1_type=0 then d1:=0;                      // Par1_type is set in Frame_Batch
   if Par2_type=0 then d2:=0;                      // Par2_type is set in Frame_Batch
   if Par3_type=0 then d3:=0;                      // Par3_type is set in Frame_Batch
   if Par1_Log and (d1>0) then                     // Par1_Log is set in Frame_Batch
       d1:=abs(ln(max(Par1_Max,nenner_min))-ln(max(Par1_Min,nenner_min)))/(Par1_N-1);
   if Par2_Log and (d2>0) then                     // Par2_Log is set in Frame_Batch
       d2:=abs(ln(max(Par2_Max,nenner_min))-ln(max(Par2_Min,nenner_min)))/(Par2_N-1);
   if Par3_Log and (d3>0) then                     // Par3_Log is set in Frame_Batch
       d3:=abs(ln(max(Par3_Max,nenner_min))-ln(max(Par3_Min,nenner_min)))/(Par3_N-1);
   N_total:=1;
   if d1<>0 then N_total:=N_total * Par1_N;
   if d2<>0 then N_total:=N_total * Par2_N;
   if d3<>0 then N_total:=N_total * Par3_N;
   s_total:=IntToStr(N_total);
   fl_fw:=flag_panel_fw;
   fl_sv_tb:=flag_sv_table;
   if N_total>MaxSpectra then flag_sv_table:=FALSE;
   S_actual:=1;
   Nspectra:=1;
   N:=0;
   NoX:=0; NoY:=0;
   Counter.color:=clPlotBk;
   Counter.show;
   flag_panel_fw:=TRUE;
   if flag_Y_exp then berechne_aY(S.fw);
   berechne_bbMie;
   if flag_b_SaveFwd then openCHANGES(DIR_saveFwd+'\');
   ABBRUCH:=FALSE;

   if flag_MP then set_global_parameters_fw_MP;

   if (not flag_public) and flag_truecolor_2D then begin
   { Set background colors of parameter names.
     Note: There is a strange effect which I couldn't resolve:
     Changing the font color of a dropdown list sets the focus to that list.
     Changing the background color has no such effect. }
   Frame_Batch1.ComboPar1.Color:=clDefault;
   Frame_Batch1.ComboPar2.Color:=clDefault;
   if Frame_Batch1.ComboPar3.Font.Color<>clDefault then
       Frame_Batch1.ComboPar3.Font.Color:=clDefault;
   Frame_Batch1.ComboPar3.Color:=clDefault;
   if (d1>0) and ((d2>0) or (d3>0)) then begin
        Frame_Batch1.ComboPar1.Color:=clSilver;
        if d2>0 then Frame_Batch1.ComboPar2.Color:=clGreen;
 //       if d3>0 then Frame_Batch1.ComboPar3.Font.Color:=clWhite;
        if d3>0 then Frame_Batch1.ComboPar3.Color:=clRed;
        end;
   end;

   if (not flag_public) and flag_truecolor_2D then begin
       RGB:= TRGB.Create(Application);
       RGB.FormCreate(Sender, Par1_N, Par2_N, TRUE);
       if flag_CIE_calc_locus then RGB.calcShoeEdge;
 //      RGB.PlotHorseshoeColors;
 //      RGB.PlotShoeEdge;
       end;

   c1:=Par1_Min;
   repeat
       iter_type:=Par1_type;
       determine_concentration_fw(c1);

       c2:=Par2_Min;
       repeat
           iter_type:=Par2_type;
           determine_concentration_fw(c2);
           for i:=1 to Channel_number do begin dold[i]:=0; dnew[i]:=0; end;

           c3:=Par3_Min;
           repeat
               iter_type:=Par3_type;
               determine_concentration_fw(c3);
               if NSpectra=0 then set_borders;
               case spec_type of
               S_Ed_GC: begin
                      calc_Ed_GreggCarder;
                      spec[S_actual]^:=Ed^;
                      Ed^.sim:=TRUE;
                      if (not flag_public) and flag_truecolor_2D then begin
                          Lu^:=Ed^;
                          chroma(FALSE,FALSE,1);
                          RGB.Preview(NoX,NoY,chroma_R,chroma_G,chroma_B);
                          end;
                      end;
               S_Lup: begin
                      flag_L:=TRUE;
                      calc_Lu;
                      if not flag_public and flag_sim_NEL then simulate_sensor_signal(1);
                      spec[S_actual]^:=Lu^;
                      Lu^.sim:=TRUE;

                      if (not flag_public) and flag_truecolor_2D then begin
                          chroma(TRUE,TRUE,1);
                          RGB.Preview(NoX,NoY,chroma_R,chroma_G,chroma_B);
                          end;
                      end;
               S_Rrs: begin
                      flag_L:=TRUE;
                      calc_R_rs;
                      spec[S_actual]^:=r_rs^;
                      r_rs^.sim:=TRUE;
                      if not flag_public and flag_sim_NEL then simulate_sensor_signal(1);
                      if (not flag_public) and flag_truecolor_2D then begin
                          calc_Ed_GreggCarder;
                          for i:=1 to Channel_number do
                              Lu^.y[i]:=spec[1]^.y[i]*Ed^.y[i];
                          chroma(TRUE,TRUE,1);
                          RGB.Preview(NoX,NoY,chroma_R,chroma_G,chroma_B);
                          end;

                      end;
               S_R: begin
                      flag_L:=FALSE;
                      calc_R;
                      spec[S_actual]^:=R^;
                      R^.sim:=TRUE;
                      end;
               S_Rsurf: begin
                      calc_Rrs_surface;
                      spec[S_actual]^:=Rrs_surf^;
                      Rrs_surf^.sim:=TRUE;
                      end;
               S_a: begin
                      calc_a;
                      spec[S_actual]^:=a^;
                      a^.sim:=TRUE;
                      end;
               S_Kd: begin
                      calc_Kd;
                      spec[S_actual]^:=Kd^;
                      Kd^.sim:=TRUE;
                      end;
               S_Rbottom: begin
                      calc_R_bottom;
                      spec[S_actual]^:=bottom^;
                      bottom^.sim:=TRUE;
                      end;
               S_Ed_Gege: begin
                      calc_Ed_Gege;
                      spec[S_actual]^:=Ed^;
                      Ed^.sim:=TRUE;
                      end;
               S_test: begin { test spectrum }
                      if flag_MP then calc_meltpond
                                 else calc_test;
                      spec[S_actual]^:=Stest^;
                      Stest^.sim:=TRUE;
                      end;

               end;

               { Private WASI version: Calculate derivative of actual spectrum }
               if not flag_public and flag_CEOS then begin
                   if flag_drel then Rrs_N(FALSE);
                   if flag_1st_dp and (d3>0) then dRrs_par(N, c3, CEOS_dp, FALSE);
                   if flag_1st_dl and (d3>0) then derivate_lambda(c3, FALSE);
                   if flag_dL and (d3>0) then calc_NEdR(merkS, Norm_min, Norm_max, FALSE);
                   if flag_dL and (d3>0) then calc_spectral_resolution(20);
                   end;

               { Private WASI version: Save internal spectra }
               if not flag_public then if flag_fw_intern then
                   spec[S_actual]^:=r_d^; { selection must be done here in source code }

               { Introduce artificial errors, if requested }
(*               rescale_measurement(spec[S_actual]^.y);   // rescale measurement *)
               if flag_radiom or flag_noise then add_noise(spec[S_actual]^.y);             // add noise

               if flag_bunt then begin                     // set plot color using LUT[1]
                   farbS[S_actual]:=bunt(1, N, N_total-1);
                   if (c3=Par3_Min) and (d3>0) and (Par1_type=0) and (Par2_type=0) then   // create legend for c3
                       Legend_par(farbS[S_actual], par.name[Par3_type]+' = '+schoen(c3,0), 0);
                   if (c1=Par1_Min) and (d1>0) and (Par2_type=0) and (Par3_type=0) then   // create legend for c1
                       Legend_par(farbS[S_actual], par.name[Par1_type]+' = '+schoen(c1,2), 0);
                   end;
               {
               if flag_bunt and (d1>0) and ((d2>0) or (d3>0)) then begin
                   farbS[S_actual]:=clBlack;
                   if (d1>0) then farbS[S_actual]:=clSilver;
                   if (d2>0) and (c1=Par1_min) then farbS[S_actual]:=clGreen;
                   if (d3>0) and (c1=Par1_min) then farbS[S_actual]:=clRed;
                   if (d2>0) and (d3>0) and (c1=Par1_min) and (c2>Par2_min) then farbS[S_actual]:=clGreen;
                   if (d2>0) and (d3>0) and (c1>Par1_min) and (c2>Par2_min) then farbS[S_actual]:=clSilver;
                   end;
                   }
               if (not flag_public) and flag_truecolor_2D then
                   farbS[S_actual]:=chroma_R + chroma_G shl 8 + chroma_B shl 16;

 (*
               { calculate plot color }
               if ((d1>0) and (d2>0)) or ((d1>0) and (d3>0)) or ((d2>0) and (d3>0)) then begin
                   if d1>0 then cr:=lo(round(240/Par1_N*(c1-Par1_Min)/d1)) else cr:=50;
                   if (d1>0) and Par1_Log then cr:=lo(round(240/Par1_N*ln(c1/Par1_Min)/d1));
                   if d2>0 then cb:=lo(round(240/Par2_N*(c2-Par2_Min)/d2)) else cb:=50;
                   if (d2>0) and Par2_Log then cb:=lo(round(240/Par2_N*ln(c2/Par2_Min)/d2));
                   if d3>0 then cg:=lo(round(240/Par3_N*(c3-Par3_Min)/d3)) else cg:=50;
                   if (d3>0) and Par3_Log then cg:=lo(round(240/Par3_N*ln(c3/Par3_Min)/d3));
                   farbS[S_actual]:=cr + cg shl 8 + cb shl 16;
                   end;
 *)
               (*
               if N<=Channel_number then
               for i:=1 to Channel_number do
                   EEM_ph.frame_EEM[N,i]:=spec[S_actual]^.y[i];   *)

               average(spec[S_actual]^);                 // average the spectrum
               inc(N);

               if (flag_b_invert=FALSE) and (S_actual=1) then begin
                   zeichne_kurve(1, dots);
                   if flag_dots and (dots<dotMaxN) then Zeichne_Punkte(1);
                   end;

               N_string:=IntToStr(N);
               N_file:='';
               for i:=1 to length(s_total)-length(N_string) do N_file:=N_file+'0';
               if flag_CEOS and (not flag_public) and (Par3_Type<>0)then
                   N_file:=CEOS_spc + '_'+ N_file + N_string
                   else N_file:='B' + N_file + N_string;
               if flag_b_SaveFwd then begin
                   if flag_sv_table and not flag_b_Invert then begin
                       inc(S_actual);
                       NSpectra:=N;
                       end
                   else begin
                       NSpectra:=1;
                       saveSpecFw(DIR_saveFwd+'\'+N_file+'.'+EXT_FWD);
                       end;
                   if NSpectra>0 then saveCHANGES(N_file+'.'+EXT_FWD, c1, c2, c3);
                   end;

               if flag_b_Invert then begin         // Reconstruction mode
                   flag_clear:=TRUE;
                   flag_panel_fw:=FALSE;
                   if flag_Y_exp then berechne_aY(S.actual);
                   berechne_bbMie;
                   if flag_b_Reset then merk_actual;
                   Run_Invers(Sender);
                   if N=1 then openFITPARS(DIR_saveInv+'\');
                   saveFITPARS(N_file, 0, c1, c2, c3);
                   if flag_b_SaveInv then
                       saveSpecInv(DIR_saveInv+'\'+N_file+'.'+EXT_INV);
                   flag_panel_fw:=TRUE;
                   if flag_Y_exp then berechne_aY(S.fw);
                   berechne_bbMie;
                   if flag_b_Reset then restore_actual;
                   end;

               if Par3_Log then c3:=c3*exp(d3) else c3:=c3 + d3;
               Counter.Text:=N_string+'/'+s_total;
               if N_total>1 then Counter.refresh else Counter.hide;
           until (c3<Par3_Min) or (c3>Par3_Max+d3/10) or (d3=0) or (N>N_total)
           or ABBRUCH;
           inc(NoY);

           if (c3>=Par3_Max) and (d3>0) then begin
               if Par3_Log then c3:=c3*exp(-d3) else c3:=c3 - d3;
               // create legend for c3
               if S_actual<=1 then i:=1 else i:=S_actual-1;
               if (Par1_type=0) and (Par2_type=0) then
                   Legend_par(farbS[i], par.name[Par3_type]+' = '+schoen(c3,0), 20);
               end;

           if Par2_Log then c2:=c2*exp(d2) else c2:=c2 + d2;

       until (c2<Par2_Min) or (c2>Par2_Max+d2/10) or (d2=0) or (N>N_total) or ABBRUCH;
       if Par1_Log then c1:=c1*exp(d1) else c1:=c1 + d1;
       NoY:=0;
       inc(NoX);
   until (c1<Par1_Min) or (c1>Par1_Max+d1/10) or (d1=0) or (N>N_total) or ABBRUCH;

   // create legend for c1
   if (d1>0) and (Par2_type=0) and (Par3_type=0) then begin
       if S_actual<=1 then i:=1 else i:=S_actual-1;
       if Par1_Log then Legend_par(farbS[i], par.name[Par1_type]+' = '+schoen(c1/exp(d1),2), 20)
           else Legend_par(farbS[i], par.name[Par1_type]+' = '+schoen(c1-d1,2), 20);
       end;

   if flag_b_SaveFwd then begin
       TimeCalc:=MilliSecondsBetween(Now, TimeStartCalc)/1000;
       if flag_save_t then begin
           writeln(FileChanges);
           writeln(FileChanges, 'Calculation time = ', schoen(TimeCalc,3), ' sec');
           end;
       closeFile(FileChanges);
       SavePAR_public(path_exe + INI_public, DIR_saveFwd + '\' + INI_public);
       end;
   if flag_b_Invert then begin
       if flag_avg_err then closeFITPARS
                       else {if acc_N>0 then} closeFile(FileFitpars);
       SavePAR_public(path_exe + INI_public, DIR_saveFwd + '\' + INI_public);
       end;
   if not flag_b_Invert then restore_fw;
   if (not flag_public) and flag_truecolor_2D then begin    // Create chromaticity diagram
       RGB_FileText:='';
       if (Par1_N>1) and (Par1_Type>0) then
           RGB_FileText:=par.name[Par1_Type]+'='+
                     schoen(Par1_Min,2)+'-'+schoen(Par1_Max,2);
       if (Par2_N>1) and (Par2_Type>0) then
           RGB_FileText:=RGB_FileText+'__'+
                     par.name[Par2_Type]+'='+schoen(Par2_Min,2)+'-'+
                     schoen(Par2_Max,2);
       RGB.ScaleColorXY(Par1_N, Par2_N);
       RGB.Repaint;
       RGB.SavePanel;
       RGB.SaveShoe;
       RGB.SaveWindow;
       end;
   Counter.Text:='N = '+IntToStr(N);
   if N>1 then Counter.refresh else Counter.hide;
   if NSpectra>2 then begin { earlier versions: >0 }
       saveSpecFw(DIR_saveFwd +'\'+FW_TABLE+'.'+EXT_FWD);
       zeichne(Sender, TRUE);     { earlier versions: deactivated }
       end;
//   if (spec_type=S_Test) and flag_MP then reset_parameters_before_MP;
   flag_sv_table:=fl_sv_tb;
   flag_panel_fw:=fl_fw;
   flag_loadFile:=FALSE;
   flag_clear:=TRUE;
   end;


procedure TForm1.Prepare_Invers(Sender:TObject);
{ Prepare Inverse Mode. }
begin
    Screen.Cursor:=crHourGlass;
    merk_fw;
    if flag_above then z.actual:=0;    { above water: set sensor depth z=0 }
    set_c(25, z);                      { update sensor depth for current model }
    exclude_fit;                       { exclude certain parameters from fit }
    if flag_loadFile or not flag_b_loadAll then set_YFilename;
    set_YText;
    define_curves;
    flag_aW_merk:=flag_aW;
    Frame_Res1.visible:=TRUE;
    flag_fit_running:=TRUE;
    end;

procedure TForm1.Q1Click(Sender: TObject);
begin
    Plot_Spectrum(Q_f^, TRUE, Sender);
    end;


procedure TForm1.Finalize_Invers(Sender:TObject);
{ Finalize Inverse Mode. }
var svFile    : String;
begin
if not flag_background then begin
   calculate_Fitfunction;
   NSpectra:=2;
   spec[1]^.ParText:='Measurement';
   spec[2]^.ParText:='Fit';
   if flag_autoscale then scale;
   farben2;
   if flag_Plot2D then zeichne(Sender,TRUE);
   Frame_r1.update_actual(Sender);
   if flag_2D_inv and flag_batch then begin
       Frame_Batch1.Panel2Hide.visible:=TRUE;
       Frame_Res1.update_parameterlist(Sender);
       Frame_Res1.Iterations.Refresh;
       Frame_Res1.Residuum.Refresh;
       Frame_Res1.visible:=TRUE;
       end
   else begin
       Screen.Cursor:=crDefault;
       flag_aW:=flag_aW_merk;
       activate_calculated_spectra;
       restore_fw;
       Update_GUI(Sender);
       end;
       if flag_b_SaveInv then begin
           svFile:=ChangeFileExt(ExtractFileName(meas^.FName), '');
           svFile:=svFile+'_col'+schoen(meas^.YColumn,0);
           svFile:=DIR_saveInv+'\'+svFile;
           saveSpecInv(svFile+'.'+EXT_INV);
           end;
   flag_fit_running:=FALSE;
   Application.ProcessMessages;     // refresh the GUI
   end;
   end;

procedure TForm1.Run_Invers(Sender:TObject);
{ Execute Inverse Mode. }
var  k, kzB1, kzB2  : integer;
begin
   if (not flag_2D_inv) or (not flag_batch) then Prepare_Invers(Sender);
   NIter := 0;
   case spec_type of
   S_Ed_GC: begin  { E_down }
        //   if par.fit[25]=1 then calc_initial_z_Ed; { determine z analytically }
           perform_fit_Ed_GC(2, Sender);   { estimate f_dd }
           perform_fit_Ed_GC(4, Sender);   { fit all parameters }
           average(GC_Edd^);
           average(GC_Eds^);
           end;
   S_Lup:  begin  { L_up }
           if flag_use_Ed then if MaxIter[1]>1 then begin
               spec[1]^:=Ed^;              { Fit of spectrum Ed }
               if MaxIter[2]>1 then perform_fit_Ed_GC(2, Sender);
               if MaxIter[4]>1 then perform_fit_Ed_GC(4, Sender);
               spec[1]^:=Lu^;              { Fit of spectrum Lu }
               end
           else if flag_fluo then begin
               calculate_K_function;       { calculate Kd and kL_uW }
               calculate_Ed0_function;     { calculate Ed0 }
               end;
           flag_aW:=TRUE;
           flag_L:=TRUE;
           { calculate chlorophyll-a fluorescence }
           if flag_fluo then calc_Rrs_F(z.actual, zB.actual, fluo.actual,
               dummy.actual, test.actual );
           if MaxIter[2]>1 then perform_fit_Lup(2, Sender);
           if MaxIter[3]>1 then perform_fit_Lup(3, Sender);
           if MaxIter[4]>1 then perform_fit_Lup(4, Sender);
           actual_to_fw;
           calc_R;
           calc_R_rs;
           end;
   S_Rrs:  begin  { R_rs }
           if (not flag_public) and flag_Rbottom then begin
               flag_above:=FALSE;
               perform_fit_waterlayer(Sender);
               end
           else begin
           if (NSpectra<2) and flag_b_Reset then begin
           { Determine start values for first spectrum.
             'flag_b_reset' necessary because 2D module sets NSpectra=1
             for each pixel. }
               if flag_use_Ed then if MaxIter[1]>1 then begin
                   spec[1]^:=Ed^;       { Fit of spectrum Ed }
                   if MaxIter[2]>1 then perform_fit_Ed_GC(2, Sender);
                   if MaxIter[4]>1 then perform_fit_Ed_GC(4, Sender);
                   spec[1]^:=r_rs^;     { Fit of spectrum r_rs }
                   end
               else begin
                   calculate_K_function;   { calculate Kd and kL_uW }
                   calculate_Ed0_function; { calculate Ed0 }
                   end;
               end;

           flag_aW:=TRUE;
           flag_L:=TRUE;
           FIT:=1;
           { Chlorophyll-a fluorescence }
           if flag_fluo then calc_Rrs_F(z.actual, zB.actual, fluo.actual,
               dummy.actual, test.actual);

           (*
           if flag_shallow {and (not flag_2D_inv)} then begin
              if flag_Simpl_ini then begin    // 29.8.2018: funktioniert nicht
                 { analytical estimation of start values in shallow water }
                  if (zB.fit=1) then begin  { zB is fit parameter }
                      kzB1:=Nachbar(LambdazB-dLambdazB);
                      kzB2:=Nachbar(LambdazB+dLambdazB);
                      if C_X.fit=1 then calc_initial_zB(0, kzB1, kzB2);
                      calc_initial_zB(1, kzB1, kzB2);
                      end;
 //                 if (C_X.fit=1) and (MaxIter[2]>1) then calc_initial_X_shallow;
//                  if MaxIter[3]>1 then calc_initial_Y_C_shallow(Sender);
//                  calc_initial_fa;
                  end;
              end;
              *)
           if flag_surf_inv then begin { wavelength dependent surface reflections }
               for k:=1 to Channel_number do kurve_Ed_GC(k);  // initialize Ed spectra
               if flag_Simpl_ini then if MaxIter[2]>1 then perform_fit_Rrs(2, Sender);
               if flag_Simpl_ini then if MaxIter[3]>1 then perform_fit_Rrs(3, Sender);
               if MaxIter[4]>1 then perform_fit_Rrs(4, Sender);
               end
           else begin { constant surface reflections }
               if MaxIter[2]>1 then perform_fit_Rrs0(2, Sender);
               if MaxIter[3]>1 then perform_fit_Rrs0(3, Sender);
               if MaxIter[4]>1 then perform_fit_Rrs0(4, Sender);
               end;

           calc_R_Rrs;  // Subtract surface reflections from measurement
   {        actual_to_fw;  }
   {        calc_R;        }
           end;
           end;
   S_R:  begin  { R }
           flag_aW:=TRUE;
           flag_L:=FALSE;
           if (not flag_public) and flag_Rbottom then begin
               flag_above:=FALSE;
               perform_fit_waterlayer(Sender);
               end

           { analytical estimation of start values }
           else if flag_shallow then begin  { shallow water (Andreas Albert 2003) }
               if (zB.fit=1) and flag_anzB then begin  { zB is fit parameter }
                   kzB1:=Nachbar(LambdazB-dLambdazB);
                   kzB2:=Nachbar(LambdazB+dLambdazB);
                   if C_X.fit=1 then calc_initial_zB(0, kzB1, kzB2); { C_L is fit parameter }
                   calc_initial_zB(1, kzB1, kzB2);
                   end;
               if (C_X.fit=1) and flag_anX_Rsh then begin { C_L is fit parameter }
                   calc_initial_X_shallow;
                   calc_initial_X_shallow;
                   end;
              calc_initial_Y_C_shallow(Sender);
            //  calc_initial_fa;
              end
           else if (not flag_b_Reset) then begin { deep water }
               if flag_anX_R then if ((model_f>0) or (f.fit=0)) then
                   calc_initial_X else { start values of SPM }
                   calc_initial_X_f;   { start values of SPM and f }
               if ((model_f=2) or (model_f=4)) and flag_anX_R then calc_initial_X; { play it again, Sam }
               if flag_anCY_R then calc_initial_Y_C;  { start values of Y, C}
               end;

           { 3-steps-fit }
           { calculate chlorophyll-a fluorescence }
           if flag_fluo then calc_Rrs_F(z.actual, zB.actual, fluo.actual, dummy.actual, test.actual);
           if MaxIter[2]>1 then perform_fit_R(2, Sender);
           if MaxIter[3]>1 then perform_fit_R(3, Sender);
           if MaxIter[4]>1 then perform_fit_R(4, Sender);
           end;
   S_Rsurf: begin { R_surf }
           perform_fit_Rsurf(Sender);
           end;
   S_a: begin { a }
           perform_fit_a(Sender);
           end;
   S_Kd:  begin  { Kd }
           flag_aW:=TRUE;
           perform_fit_Kd(Sender);
           end;
   S_Rbottom: begin { R_bottom }
           perform_fit_Rbottom(Sender);
           end;
   S_test:  begin  { Test spectrum }
           if flag_MP then {calc_meltpond; }
           perform_fit_meltpond(Sender);
           end;
   S_Ed_Gege:  begin  { E_down OLD}
           perform_fit_Ed_Gege(Sender);
           end;

      end;
   Finalize_Invers(Sender);
   end;

procedure TForm1.Invert_Files(Sender:TObject);
{ Invert a series of spectra imported from file. }
var FileAttrs : Integer;
    ch, N, c  : word;
    sp        : integer;
    sr        : TSearchRec;
    Pfad      : String;
    svFile    : String;
    p1,p2,p3  : integer;
    tmp       : textFile;
begin
   FileAttrs := faAnyFile;
   Pfad:=ExtractFilePath(Name_LdBatch);
   N:=0;
   p1:=Par1_type; p2:=Par2_type; p3:=Par3_type;
   Par1_type:=0;  Par2_type:=0;  Par3_type:=0;
   merk_actual;
   if (spec_type=S_Ed_GC) and flag_trenn_Ed then prepare_Ed_temp(tmp);
   ABBRUCH:=FALSE;
   begin
       if FindFirst(Name_LdBatch, FileAttrs, sr) = 0 then begin
           REPEAT
               sp:=0;
               actualFile:=Pfad+sr.Name;
               if flag_read_day then lies_day(actualFile);
               if flag_read_sun then lies_sun(actualFile);
               if flag_read_view then lies_view(actualFile);
               if flag_read_dphi then lies_dphi(actualFile);
               while (lies_spektrum(spec[1]^, actualFile, meas^.XColumn,
                        meas^.YColumn+sp, meas^.Header, ch, flag_tab)=0) and (sp<ycol_max) do begin
                   x_anpassen(spec[1]^.y, ch, error_x);
                   if (spec_type=S_Rrs) and flag_mult_Rrs then
                       for c:=1 to ch do spec[1]^.y[c]:=Rrs_factor * spec[1]^.y[c];
                   if flag_scale then rescale_measurement(spec[1]^.y);
                   Run_Invers(Sender);  { Inversion }
                   svFile:=ChangeFileExt(ExtractFileName(sr.Name), '');
                   if N=0 then openFITPARS(DIR_saveInv+'\');
                   saveFITPARS(svFile, meas^.YColumn+sp, 0, 0, 0);     
                   if flag_b_SaveInv then begin
                       svFile:=DIR_saveInv+'\'+svFile;
                       if flag_multi then begin { multiple columns }
                           if meas^.YColumn+sp<=9 then
                               svFile:=svFile+'_0'+inttostr(meas^.YColumn+sp)
                               else svFile:=svFile+'_'+inttostr(meas^.YColumn+sp)
                           end;
                       saveSpecInv(svFile+'.'+EXT_INV);
                       end;
                   if (spec_type=S_Ed_GC) and flag_trenn_Ed then
                       save_Ed_temp(tmp, actualFile, meas^.YColumn+sp, par.c[20], par.c[21]);
                   inc(sp);
                   if not flag_multi then sp:=ycol_max;
                   inc(N);
                   if flag_b_Reset then restore_actual;
                   end;
           UNTIL (FindNext(sr)<>0) or ABBRUCH;
           FindClose(sr);
           if (spec_type=S_Ed_GC) and flag_trenn_Ed then separate_Edd_Eds(tmp, actualFile);
           end;
        if N>0 then begin
            if flag_avg_err then closeFITPARS
                            else closeFile(FileFitpars);
            end;
        Par1_type:=p1;  Par2_type:=p2;  Par3_type:=p3;
        if N>0 then begin
           SavePAR_public(path_exe+INI_public, DIR_saveInv + '\' + INI_public);
(*           if flag_multi and not flag_public then mittle_Fitparameter(DIR_saveInv+'\'); *)
           end;
        end;
    restore_actual;
    end;

function IsFileOpen(const FileName: string): Boolean;
{ gefunden hier: https://www.delphipraxis.net/93414-datei-geoeffnet.html }
var Stream: TFileStream;
begin
   Result := false;
   if not FileExists(FileName) then exit;
   try
     Stream := TFileStream.Create(FileName,fmOpenRead or fmShareExclusive);
   except
     Result := true;
     exit;
   end;
   Stream.Free;
end;

procedure TForm1.Invert_2D(Sender:TObject);
{ Inverse modeling of hyperspectral image. }
var p1,p2,p3  : integer;
    p, x, f   : word;
    i         : qword;
    kzB1,kzB2 : word;
    farbe     : integer;
    merk_flag : boolean;
    dp        : double;
    pixmin    : qword;                       // first pixel used for averaging
    pixmax    : qword;                       // last  pixel used for averaging }
    merk_pmin, merk_pmax,
    merk_fmin, merk_fmax : qword;
    merk      : qword;
    progress  : TStringList;
    pPercent  : double;                        // progress: percentage of processed pixels
    pPermille : integer;                       // progress: permille of processed pixels
    pTimeDone : double;                        // progress: elapsed time [sec]
    pTimeEst  : double;                        // progress: estimate of remaining time [sec]
    pNdone    : qword;                         // number of processed pixels
{ It would be nice to have separate progress files for each WASI instance in case WASI is
  started several times. Is not implemented because it is not trivial and requires book-keeping
  of the WASI instances. This website might be helpful: https://www.tek-tips.com/faqs.cfm?fid=7523 }
begin
    p1:=Par1_type; p2:=Par2_type; p3:=Par3_type;
    Par1_type:=0;  Par2_type:=0;  Par3_type:=0;
    dpX:=0;        dpF:=0;
    pNdone:=0;

    FIT:=1;
    merk_flag:=flag_simpl_ini;
    merk_actual;                                // Store the actual model parameters
    Prepare_Invers(Sender);                     // Prepare inverse modeling
    set_parameters_inverse;                     // Set model parameters for inverse mode
    GetData_2D(1);                              // Transfer fit parameters to Simplex
    Channels_out:=Em+3;                         // Set number of channels of output image
    kzB1:=Nachbar(LambdazB-dLambdazB);          // Set channel 1 for analytic zB estimate
    kzB2:=Nachbar(LambdazB+dLambdazB);          // Set channel 2 for analytic zB estimate

    if Format_2D.Select_Filename_Output_HSI(Sender) then begin
    spec[1]^.FName:=OpenDialog_HSI.FileName;    // Use input file name for spectrum name
    if flag_progress then begin
        try
            progress:= TStringList.Create;
            progress.Add(spec[1]^.FName);
            progress.Add('Fit running');
            progress.Add('-999 non-masked pixels');
            progress.Add('0 % processed');
            progress.Add('0 sec elapsed');
            progress.Add('-999 sec remaining');
            if not IsFileOpen(DIR_saveInv + name_progress) then
                progress.SaveToFile(DIR_saveInv + name_progress);  // Log progress info
        finally
            progress.Free;
        end;
        end;
    ABBRUCH:=FALSE;                             // Reset flag used for break

    merk_pmin:=pixel_min;
    merk_pmax:=pixel_max;
    merk_fmin:=frame_min;
    merk_fmax:=frame_max;

    if frame_min>frame_max then begin
        merk:=frame_min;
        frame_min:=frame_max;
        frame_max:=merk;
        end;
    if pixel_min>pixel_max then begin
        merk:=pixel_min;
        pixel_min:=pixel_max;
        pixel_max:=merk;
        end;

    if (not flag_background) and flag_use_ROI then  { mark the selected image area }
       Format_2D.draw_rectangle(Sender, pixel_min,pixel_max-1,frame_min,frame_max, clRed)
    else if flag_b_invert and (not flag_use_ROI) then begin { process entire image }
        pixel_min:=0;
        pixel_max:=0;
        frame_min:=0;
        frame_max:=0;
        end;
    if (frame_max=0) or (frame_max>Height_in-1) then frame_max:=Height_in-1; // Set last processed image line
    if (pixel_max=0) or (pixel_max>Width_in-1) then pixel_max:=Width_in-1;  // Set last processed image column

    if flag_use_ROI and flag_cut_ROI then begin
        dpX:=pixel_max-pixel_min+1;
        dpF:=frame_max-frame_min+1;
        if dpX<0 then dpX:=0;
        if dpF<0 then dpF:=0;
        Format_2D.exchange_ENVI_coordinates;
        { Update number of masked and unmasked pixels }
        Np_masked:=0;    // Number of masked pixels (no water)
        Np_water:=0;     // Number of pixels to be processed
        for f:=frame_min to frame_max do
        for x:=pixel_min to pixel_max do
            if WaterMask[x,f] then inc(Np_water)
            else inc(Np_masked);
        end;

    if (flag_use_ROI and flag_cut_ROI) then     // Define size of HSI data cube
        SetLength(cube_fitpar, dpX, dpF, Channels_out) else
        SetLength(cube_fitpar, Width_in, Height_in, Channels_out);

    ProgressBar1.visible:=TRUE;                 // Display progress bar
    ProgressBar1.min:=0;                        // Define lower border of progress bar
    ProgressBar1.max:=1000;                     // Define upper border of progress bar

    { loop over frames = image lines }
    f:=frame_min;                               // Set f to first processed image line
    TimeStartCalc:=Now;
    if Em>0 then repeat
        x:=pixel_min;                           // Set x to first processed image column

        { loop over pixels = image columns }
        repeat
            pPercent:=100*pNdone/Np_water;
            pPermille:=round(10*pPercent);
            pTimeDone:=MilliSecondsBetween(Now, TimeStartCalc)/1000;
            Progressbar1.Position:=pPermille;
            if pPercent>nenner_min then pTimeEst:=100*pTimeDone/pPercent-pTimeDone;
            if flag_progress then begin
                try
                    progress:= TStringList.Create;
                    progress.Add(spec[1]^.FName);
                    progress.Add('Fit running');
                    progress.Add(IntToStr(Np_water) + ' non-masked pixels');
                    progress.Add(schoen(pPercent, 3) + ' % processed');
                    progress.Add(schoen(pTimeDone, 3) + ' sec elapsed');
                    progress.Add(schoen(pTimeEst, 3) + ' sec remaining');
                    if not IsFileOpen(DIR_saveInv + name_progress) then
                        progress.SaveToFile(DIR_saveInv + name_progress);  // Log progress info
                finally
                    progress.Free;
                end;
                end;

            Format_2D.set_ranges_avg_2D         // Set pixmin, pixmax
                (f, x, pixmin, pixmax);

            { Initialize Simplex }
            if WaterMask[x,f] then begin            // TRUE = water
                inc(pNdone);
                Format_2D.extract_spektrum_new     // Read spectrum
                    (spec[1]^, x, f, Sender);

                if (f>frame_min) then begin    // Process all image lines except first one
                if not flag_b_Reset then begin // Use results of previous pixels
                    Format_2D.                 // Average fit results of previously processed pixels
                        average_fitparameters_2D(f, x, pixmin, pixmax);
                    GetData_2D(1);             // Copy averaged parameters to Simplex vertex #1
                    if (x=pixmin) or (NIter>0.9*Maxiter[FIT]) then begin
                        restore_actual;            // Read initial values
                        if flag_above then z.actual:=0; // above water: set sensor depth z=0
                        set_c(25, z);              // update sensor depth
                        if (zB.fit=1) and flag_anzB then
                            Format_2D.zB_analytical_2D // Determine zB start value analytically
                            (f, kzB1, kzB2, x, x, Sender);

                        set_parameters_inverse;    // Copy initial values to inverse parameters
                        GetData_2D(2);             // Copy inverse parameters to Simplex vertex #2
                        if flag_shallow then GetData_2D(3);         // new 27.4.2020
                        end;
                    end

                else begin                     // Don't use results of previous pixels
                    flag_simpl_ini:=TRUE;
                    restore_actual;
                    set_parameters_inverse;    // Set model parameters for inverse mode
                    if (zB.fit=1) and flag_anzB then
     (*               Format_2D.zB_analytical_2D // Determine zB start value analytically
                        (f, x, kzB1, kzB2, pixmin, pixmax, Sender);    *)
                    Format_2D.zB_analytical_2D // Determine zB start value analytically
                        (f, kzB1, kzB2, x, x, Sender);

                    end;
                    end

                else begin                     // Process first image line
                    if x<=N_avg then begin     // ... first pixels of first line
                        { Initialize fitparameters with user-defined values }
                        flag_simpl_ini:=TRUE;
                        restore_actual;
                        set_parameters_inverse;
                        end
                    else                       // ... remaining pixels of first line
                        Format_2D.             // Average fit results of previously processed pixels }
                            average_fitparameters_2D(f, x, pixmin, pixmax);
                    if (zB.fit=1) and flag_anzB then
                        Format_2D.zB_analytical_2D // Determine zB start value analytically
                        (f, kzB1, kzB2, x, x, Sender);
                    end;

                Run_Invers(Sender);            // Perform inverse modeling }

                { Copy fit results to output image }
                i:=0;
                for p:=1 to M1 do if (par.fit[p]=1) then begin
                    cube_fitpar[x-pixel_min,f-frame_min,i]:=par.c[p];
                    inc(i);
                    end;
                cube_fitpar[x-pixel_min,f-frame_min,i]:=Resid;
                cube_fitpar[x-pixel_min,f-frame_min,i+1]:=SAngle;
                cube_fitpar[x-pixel_min,f-frame_min,i+2]:=NIter;

                { Mark processed pixel }
                dp:=abs(Par0_Max-Par0_Min);
                if dp>nenner_min then begin
                    if Par0_Min<Par0_Max then begin
                        farbe:=round(255*(par.c[Par0_Type]-Par0_Min)/dp);
                        if farbe>255 then farbe:=255;
                        end
                    else begin
                        farbe:=255-round(255*(par.c[Par0_Type]-Par0_Max)/dp);
                        if farbe<0 then farbe:=0;
                        end;
                    end
                else begin
                    farbe:=0;
                    end;
                if not flag_background then Format_2D.mark_as_processed(x,f,farbe, Sender);
                Application.ProcessMessages;     // refresh the GUI
                end;

            { Finalize inner loop }
            flag_Plot2D:=((x mod Plot2D_delta)=0) and WaterMask[x,f];
            inc(x);
        until (x>pixel_max) or ABBRUCH;
        inc(f);
    until (f>frame_max) or ABBRUCH;

    Finalize_Invers(Sender);
    Format_2D.Write_Fitresult(Height_in-1);
    TimeCalc  :=MilliSecondsBetween(Now, TimeStartCalc)/1000;
    Format_2D.Write_Envi_Header_fit(Output_HSI);
    restore_actual;    // Replace actual model parameters with the stored ones
    SavePAR_public(path_exe + INI_public,
        ChangeFileExt(ChangeFileExt(Output_HSI, '.' + INI_public), '.par'));
    if not flag_public then begin { Private WASI version }
        SavePAR_private(path_exe + INI_private,
            ChangeFileExt(ChangeFileExt(Output_HSI, '.' + INI_public), '-2D.par'));
            if flag_2D_ASCII then Save_Fitresults_as_ASCII(ChangeFileExt(Output_HSI, '.txt'));
        end;
    Par1_type:=p1;  Par2_type:=p2;  Par3_type:=p3;
    pixel_min:=merk_pmin;
    pixel_max:=merk_pmax;
    frame_min:=merk_fmin;
    frame_max:=merk_fmax;
    Screen.Cursor:=crDefault;
    flag_aW:=flag_aW_merk;
    flag_Plot2D:=TRUE;
    flag_simpl_ini:=merk_flag;
    end;
    Screen.Cursor:=crDefault;

    if flag_progress then begin
        try
            progress:= TStringList.Create;
            progress.Add(spec[1]^.FName);
            progress.Add('Fit finished');
            progress.Add('100 % processed');
            progress.Add('0 sec remaining');
            if not IsFileOpen(DIR_saveInv + name_progress) then
                progress.SaveToFile(DIR_saveInv + name_progress);  // Log progress info
        finally
            progress.Free;
        end;
        end;

    end;


{ **************************************************************************** }
{ ********************               Menu Bar               ****************** }
{ **************************************************************************** }

procedure TForm1.update_menu(Sender: TObject);
{ Activate and deactivate menu items for plotting calculated spectra. }
begin
    { Display - water }
    bbW1.visible    :=bbW^.ParText<>'';

    { Display - suspended matter }
    bbL1.visible    :=bXN^.ParText<>'';
    bMie1.visible   :=bMie^.ParText<>'';
    bbS1.visible    :=bbMie^.ParText<>'';
    SPM1.Visible    :=bbL1.visible or bMie1.visible or bbS1.visible;

    { Display - CDOM }
    aY1.visible     :=aY^.ParText<>'';
    Y1.visible      :=aY1.visible;

    { Display - atmosphere }
    TO2.visible     :=GC_T_O2^.ParText<>'';
    TO3.visible     :=GC_T_O3^.ParText<>'';
    T_wv1.visible   :=GC_T_wv^.ParText<>'';
    taua1.visible   :=GC_tau_a^.ParText<>'';
    T_r1.visible    :=GC_T_r^.ParText<>'';
    T_as1.visible   :=GC_T_as^.ParText<>'';
    T_aa1.visible   :=GC_T_aa^.ParText<>'';

    { Display - irradiance }
    Ed01.visible    :=Ed0^.ParText<>'';
    Ed1.visible     :=Ed^.ParText<>'';
    Edd1.visible    :=GC_Edd^.ParText<>'';
    Eds1.visible    :=GC_Eds^.ParText<>'';
    Edsr1.visible   :=GC_Edsr^.ParText<>'';
    Edsa1.visible   :=GC_Edsa^.ParText<>'';
    r_d1.visible    :=r_d^.ParText<>'';

    { Display - radiance }
    Lu1.visible     :=Lu^.ParText<>'';
    Lr1.visible     :=Lr^.ParText<>'';
    Ls1.visible     :=Ls^.ParText<>'';
    Lf1.visible     :=Lf^.ParText<>'';
    radiance1.visible := Lu1.visible or Lr1.visible or
                         Ls1.visible or Lf1.visible;

    { Display - attenuation }
    Kd1.visible     :=Kd^.ParText<>'';
    Kdd1.visible    :=Kdd^.ParText<>'';
    Kds1.visible    :=Kds^.ParText<>'';
    KEuW.visible    :=KE_uW^.ParText<>'';
    KEuB.visible    :=KE_uB^.ParText<>'';
    kLuW.visible    :=kL_uW^.ParText<>'';
    kLuB.visible    :=KL_uB^.ParText<>'';
    attenuation1.visible :=  Kd1.visible or Kdd1.visible or Kds1.visible or
                      KEuW.visible or KEuB.visible or kLuW.visible or kLuB.visible;

    { Display - reflectance }
    R1.visible      :=R^.ParText<>'';
    LuEd1.visible   :=r_rs^.ParText<>'';
    Rsurf1.visible  :=Rrs^.ParText<>'';
    Rrs1.visible    :=Rrs_surf^.ParText<>'';
    Rrsf1.visible   :=RrsF^.ParText<>'';
    f1.visible      :=f_R^.ParText<>'';
    frs1.visible    :=f_rs^.ParText<>'';
    Q1.visible      :=Q_f^.ParText<>'';
    bottom1.visible :=bottom^.ParText<>'';
    reflectance1.visible := R1.visible or LuEd1.visible or Rsurf1.visible or
                      Rrsf1.visible or f1.visible or frs1.visible or bottom1.visible;

    { Display - IOP }
    a1.visible      :=a^.ParText<>'';
    b1.visible      :=b^.ParText<>'';
    bb1.visible     :=bb^.ParText<>'';
    acalc.visible   :=a_calc^.ParText<>'';  { calculated only in inverse mode }
    aPhcalc.visible :=aP_calc^.ParText<>'';
    bcalc1.visible  :=b_calc^.ParText<>'';  { calculated only in inverse mode }
    bbcalc.visible  :=bb_calc^.ParText<>''; { calculated only in inverse mode }
    omegab1.visible :=omega_b^.ParText<>'';
    IOP1.visible    :=a1.visible or b1.visible or bb1.visible or acalc.visible or
                      aPhcalc.visible or bcalc1.visible or bbcalc.visible or omegab1.visible;

    { Display }
    FWHM1.visible   :=flag_FWHM;
    kz90.Caption    :=inttostr(p_Ed) + ' % depth';
    kz90.visible    :=z_Ed^.ParText<>'';

    { Hide some spectra in public mode }
    if flag_public then begin
        tA2.visible      :=FALSE;
        tR1.visible      :=FALSE;
        tM2.visible      :=FALSE;
        tC1.visible      :=FALSE;
        Stest1.visible   :=FALSE;
        private1.visible :=FALSE;
        end;
    end;

procedure TForm1.Plot_Spectrum(S: Attr_spec; flag_screenshot: boolean; Sender: TObject);
begin
    S_actual:=1; NSpectra:=1;
    YText:=S.ParText;
    if S.sim then ActualFile:='Calculated spectrum'
             else ActualFile:=YFilename(S.FName);
    spec[S_actual]^:=S;
    if flag_autoscale then scale;
    farben1;
    zeichne(Sender, flag_screenshot);
    end;

{ ********************           Menu Item 'File'           ****************** }

procedure TForm1.LoadSpecClick(Sender: TObject);         // File - Load
var old_extension : String;
    ch            : word;
begin
    old_extension:='*'+ExtractFileExt(meas^.FName);
    OpenDialog_Spec.FileName:=meas^.FName;
    OpenDialog_Spec.Title := 'Load spectrum';
    OpenDialog_Spec.InitialDir:=ExtractFileDir(meas^.FName);    { Name_LdBatch; }
    OpenDialog_Spec.Filter:='Previous spectrum ('+old_extension+')|' + old_extension
                        +'|'+ 'All files (*.*)|*.*|';
    if OpenDialog_Spec.Execute then begin
        meas^.FName:=OpenDialog_Spec.FileName;
        Name_LdBatch:=meas^.FName;
        lies_spektrum(meas^, meas^.FName, meas^.XColumn, meas^.YColumn, meas^.Header, ch, flag_tab);
        x_anpassen(meas^.y, ch, error_x);

        Channels_in:=Channel_number+1;
        if flag_scale then rescale_measurement(meas^.y);
        (*
        if flag_offset then for ch := 1 to Channels_in do   // subtract offset
            meas^.y[ch]:= meas^.y[ch] - offsetS^.y[ch];
        if flag_scale then for ch := 1 to Channels_in do   // multiply scale factor
            meas^.y[ch]:=xscaleS^.y[ch]*meas^.y[ch];
        *)
        ActualFile:=YFilename(meas^.FName);
        if flag_read_day then lies_day(meas^.FName);
        if flag_read_sun then lies_sun(meas^.FName);
//        if not flag_public then begin
            if flag_read_view then lies_view(meas^.FName);
            if flag_read_dphi then lies_dphi(meas^.FName);
//            end;
        S_actual:=1;
        NSpectra:=1;
        flag_batch:=FALSE;      { invert 1 file }
        flag_b_Invert:=TRUE;
        flag_loadFile:=TRUE;
        flag_b_loadAll:=FALSE;
        flag_panel_fw:=FALSE;   { set inverse mode }
        set_YText;
        case spec_type of
            S_Ed_GC,
            S_Ed_Gege : begin
                            Ed^:=meas^;
                            Ed^.ParText:=YText;
                            if flag_mult_Ed then for ch:=1 to Channel_number do
                                 Ed^.y[ch]:=Ed_factor * Ed^.y[ch];
                            end;
            S_Lup:      begin Lu^:=meas^; Lu^.ParText:=YText; end;
            S_rrs:      begin
                            if flag_mult_Rrs then for ch:=1 to Channel_number do
                                meas^.y[ch]:=Rrs_factor * meas^.y[ch];
                            r_rs^:=meas^;
                            r_rs^.ParText:=YText;
                            end;
            S_R:        begin R^:=meas^; R^.ParText:=YText; end;
            S_Rsurf:    begin Rrs_surf^:=meas^; Rrs_surf^.ParText:=YText; end;
            S_a:        begin a^:=meas^; a^.ParText:=YText; end;
            S_Kd:       begin Kd^:=meas^; Kd^.ParText:=YText; end;
            S_Rbottom:  begin bottom^:=meas^; bottom^.ParText:=YText; end;
            S_test:     begin Stest^:=meas^; Stest^.ParText:=YText; end;
            end;
        (*
        if flag_FWHM then begin  // temporary
            resample_Gauss(meas^, path_exe + path_resampl);
            load_single_resampled_file(path_exe + path_resampl, meas^, 3, Channel_number);
            end;    *)
        spec[S_actual]^:=meas^;
        if flag_autoscale then scale;
        RGB_FileText:=ExtractFileName(meas^.FName)+'_'+schoen(meas^.YColumn,0);
        farben1;
        zeichne(Sender, TRUE);
        update_GUI(Sender); { maybe not necessary }
        end;
    end;

procedure TForm1.Load_imgClick(Sender: TObject);         // File - Load Image
{ Load graphic file or hyperspectral image from file for preview. }
var   FileExt       : string[4];
      old_extension : String;
      temp_Ascaled  : boolean;
      pic           : TPicture;
begin
    if flag_preview then begin   // Only 1 preview permitted
        Format_2D.close;
        Form_2D_Info.close;
        end;
    old_extension:='*'+ExtractFileExt(HSI_img^.FName);
    OpenDialog_HSI.FileName:=HSI_img^.FName;
    OpenDialog_HSI.InitialDir:=ExtractFileDir(HSI_img^.FName);
    OpenDialog_HSI.Filter := 'Previous image type (' +old_extension+')|' + old_extension+'|'+
        'HSI files (*.bil;*.bsq;*.dat)|*.bil;*.bsq;*.dat|' +
        'Fit results (*.fit)|*.fit|' +
        'Grafik files (*.jpg;*.png;*.bmp;*.ico;*.emf;*.wmf)|*.jpg;*.png;*.bmp;*.ico;*.emf;*.wmf|'
        + 'All files (*.*)|*.*';
    OpenDialog_HSI.FilterIndex := 1;
    OpenDialog_HSI.Title := 'Load image';
    if flag_background or OpenDialog_HSI.Execute then begin
        Screen.Cursor:=crHourGlass;
        YText:='';
        x_flag    := flag_x_file;
        fwhm_flag := flag_fwhm;
        x_FName   := x^.FName;
        x_Header  := x^.Header;
        x_Xcol    := x^.XColumn;
        x_Ycol    := x^.YColumn;
        HSI_img^.FName:=OpenDialog_HSI.Filename;
        FileExt:=AnsiUpperCase(ExtractFileExt(HSI_img^.FName));
        Format_2D:= TFormat_2D.Create(Application);   { Ausgabefenster erzeugen }
        Format_2D.Caption:=ExtractFilename(HSI_img^.FName);
        Form_2D_Info:=TForm_2D_Info.Create(Application);

        flag_map:=FALSE;
        if flag_ENVI then Format_2D.Read_Envi_Header(HSI_img^.FName);
        if (frame_max>=Height_in) or (pixel_max>=Width_in) then begin
            frame_min:=0; frame_max:=0;
            pixel_min:=0; pixel_max:=0;
            flag_use_ROI:=FALSE;
            end;
        Format_2D.FormCreate(Sender);
        Form_2D_Info.FormCreate(Sender);
        if (FileExt='.JPG') or (FileExt='.PNG') or (FileExt='.BMP') or (FileExt='.ICO')
                            or (FileExt='.EMF') or (FileExt='.WMF')
        then begin { standard graphic format }
            Format_2D.Image_in.Picture.LoadFromFile(HSI_img^.FName);
            Width_in :=Format_2D.Image_in.Picture.Width;
            Height_in:=Format_2D.Image_in.Picture.Height;
            SetLength(cube_HSI4, Width_in, Height_in, 4);
            end
        else begin { hyperspectral image }
            if (FileExt='.FIT') then y_scale:=1;
            Format_2D.import_HSI(Sender);
            if flag_truecolor_2D then
                Format_2D.create_truecolor(Sender)
            else begin
                Format_2D.load_RGB(Sender);
                Format_2D.create_RGB(0, Height_in-1);
                end;
            Format_2D.PreviewHSI(Width_in, Height_in);
            if flag_use_ROI and (FileExt<>'.FIT') then begin
                lox:=pixel_min;
                loy:=frame_min;
                rux:=pixel_max;
                ruy:=frame_max;
                Format_2D.draw_rectangle(Sender, pixel_min,pixel_max-1,frame_min,frame_max, clWhite);
                Frame_Batch1.CheckBatch.Enabled:=TRUE;
                Frame_Batch1.CheckBatch.checked:=TRUE;
                flag_b_invert:=FALSE;
                flag_batch:=TRUE;
                flag_b_loadAll:=FALSE;
                Frame_Batch1.update_parameterlist(Sender);
                end;
            flag_panel_fw:=FALSE;                         { activate inverse mode }
            end;
        if not flag_background then begin
            temp_Ascaled:=Application.Scaled;
            Application.Scaled:=FALSE;
            Format_2D.Show;            // ERROR: Lazarus changes here window size
            flag_preview:=TRUE;
            Save_img.visible:=flag_preview;
            update_GUI(Sender);
            Format_2D.visible:=TRUE;
            Screen.Cursor:=crDefault;
            Application.Scaled:=temp_Ascaled;
            pic:= TPicture.Create;
            pic.Bitmap.Assign(Format_2D.TheGraphic);
            pic.SaveToFile(DIR_saveFwd + '\' + WASI_IMG);
            pic.Free;
            end;
        end;
    end;

procedure TForm1.Speichern2Click(Sender: TObject);       // File - Save
begin
    SaveDialog1.Title := 'Save spectrum';
    SaveDialog1.InitialDir:=DIR_saveFwd;
    if SaveDialog1.Execute then begin
        saveSpecFw(SaveDialog1.FileName);
        Dir_saveFwd:=ExtractFileDir(SaveDialog1.FileName);
        end;
    end;

procedure TForm1.Save_ImgClick(Sender: TObject);         // File - Save Image
var s        : string;
    min, max : integer;
    pic      : TPicture;
begin
    SavePictureDialog1.Title := 'Save image';
    s:=ChangeFileExt(ExtractFileName(HSI_img^.FName), '_');
    min:=round(x^.y[1]);
    max:=round(x^.y[channel_number]);
    if flag_3bands then s:=s+'ch_'+IntToStr(band_B)+'-'+IntToStr(band_G)+
        '-'+IntToStr(band_R)
    else if flag_show_EEM then s:=s+IntToStr(min)+'-'+IntToStr(max)+'nm'
    else s:=s+'_'+bandname[band_B]+'_'+schoen(Par0_Min,1)+'-'+schoen(Par0_Max,1);
    s:=s+'.png';
    SavePictureDialog1.Filename:=s;
    SavePictureDialog1.InitialDir:=DIR_saveFit;
    if SavePictureDialog1.Execute then begin
        pic:=TPicture.Create;
        pic.Bitmap.Assign(Format_2D.TheGraphic);
        pic.SaveToFile(SavePictureDialog1.FileName);
        pic.Free;
        end;
    end;

procedure TForm1.LoadINIfileLastClick(Sender: TObject);     // File - Load last INI-file
var FName : string;
begin
   if Application.MessageBox('Load parameters from last INI file?',
        '', MB_OKCANCEL) = IDOK then begin
        if flag_background then FName:=path_exe + ParamStr(1)
                           else FName:=path_exe + INI_public;
        LoadINI_public(FName);
        if not flag_public then LoadINI_private;
        update_GUI(Sender);
        end;
   end;

procedure TForm1.LoadINIfileAnyClick(Sender: TObject);      // File - Load any INI-file
begin
   OpenDialog_HSI.FileName:=HSI_img^.FName;
   OpenDialog_HSI.InitialDir:=ExtractFileDir(HSI_img^.FName);
   OpenDialog_HSI.Filter :=
       'INI files, fit results (*.ini;*.par)|*.ini;*.par|' +
       'All files (*.*)|*.*|';
   OpenDialog_HSI.FilterIndex := 1;
   OpenDialog_HSI.Title := 'Load INI-file';
   if OpenDialog_HSI.Execute then begin
        LoadINI_public(OpenDialog_HSI.Filename);
        read_spectra;
        update_GUI(Sender);
        end;
    end;


procedure TForm1.SaveINIfile1Click(Sender: TObject);     // File - Save INI-file
begin
   if Application.MessageBox('Save actual parameters as default values?',
        '', MB_OKCANCEL) = IDOK then begin
            SaveINI(TRUE);
            if not flag_public then SaveINI(FALSE);
            end;
   end;

procedure TForm1.Beenden1Click(Sender: TObject);         // File - Exit
begin
    Close;
    end;


{ *******************          Menu Item 'Display'           ***************** }

procedure TForm1.Display2Click(Sender: TObject);         // Display
begin
    update_menu(Sender);
    end;

procedure TForm1.aw1Click(Sender: TObject);              // Display - Water - aW
begin                                                    // Input spectrum
    Plot_Spectrum(aW^, TRUE, Sender);
    end;

procedure TForm1.dawdT1Click(Sender: TObject);           // Display - Water - daW/dT
begin                                                    // Input spectrum
    Plot_Spectrum(dadT^, TRUE, Sender);
    end;

procedure TForm1.bbW1Click(Sender: TObject);             // Display - Water - bbW
begin                                                    // Calculated spectrum
    Plot_Spectrum(bbW^, TRUE, Sender);
    end;

procedure TForm1.mean1Click(Sender: TObject);            // Display - Phytoplankton - aP[0]
begin                                                    // Input spectrum
    Plot_Spectrum(aP[0]^, TRUE, Sender);
    end;

procedure TForm1.cryptol1Click(Sender: TObject);         // Display - Phytoplankton - aP[1]
begin                                                    // Input spectrum
    Plot_Spectrum(aP[1]^, TRUE, Sender);
    end;

procedure TForm1.cryptoh1Click(Sender: TObject);         // Display - Phytoplankton - aP[2]
begin                                                    // Input spectrum
    Plot_Spectrum(aP[2]^, TRUE, Sender);
    end;

procedure TForm1.diatoms1Click(Sender: TObject);         // Display - Phytoplankton - aP[3]
begin                                                    // Input spectrum
    Plot_Spectrum(aP[3]^, TRUE, Sender);
    end;

procedure TForm1.dino1Click(Sender: TObject);            // Display - Phytoplankton - aP[4]
begin                                                    // Input spectrum
    Plot_Spectrum(aP[4]^, TRUE, Sender);
    end;

procedure TForm1.green1Click(Sender: TObject);           // Display - Phytoplankton - aP[5]
begin                                                    // Input spectrum
    Plot_Spectrum(aP[5]^, TRUE, Sender);
    end;

procedure TForm1.bbL1Click(Sender: TObject);             // Display - Suspended matter - bX
begin                                                    // Input spectrum
    Plot_Spectrum(bXN^, TRUE, Sender);
    end;

procedure TForm1.bMie1Click(Sender: TObject);            // Display - Suspended matter - b_Mie
begin                                                    // Calculated spectrum
    Plot_Spectrum(bMie^, TRUE, Sender);
    end;

procedure TForm1.bbS1Click(Sender: TObject);             // Display - Suspended matter - bb_Mie
begin                                                    // Calculated spectrum
    Plot_Spectrum(bbMie^, TRUE, Sender);
    end;

procedure TForm1.aY1Click(Sender: TObject);              // Display - CDOM - aY*
begin                                                    // Input or calculated spectrum
    Plot_Spectrum(aY^, TRUE, Sender);
    end;

procedure TForm1.aY2Click(Sender: TObject);              // Display - CDOM - aCDOM
begin                                                    // Calculated spectrum
    Plot_Spectrum(aCDOM_calc^, TRUE, Sender);
    end;

procedure TForm1.a_NAP1Click(Sender: TObject);           // Display - IOP - aNAP
begin                                                    // Calculated spectrum
    Plot_Spectrum(aNAP_calc^, TRUE, Sender);
    end;

procedure TForm1.bbNAP1Click(Sender: TObject);           // Display - IOP - bb_NAP
begin                                                    // Calculated spectrum
   Plot_Spectrum(bb_NAP^, TRUE, Sender);
   end;


procedure TForm1.bbPh1Click(Sender: TObject);           // Display - IOP - bb_phy
begin                                                   // Calculated spectrum
   Plot_Spectrum(bb_phy^, TRUE, Sender);
   end;


procedure TForm1.bb_phy1Click(Sender: TObject);          // Display - IOP - bb*_phy
begin                                                    // Input spectrum
    Plot_Spectrum(bPhyN^, TRUE, Sender);
    end;

procedure TForm1.aNAP1Click(Sender: TObject);            // Display - NAP - aNAP*
begin                                                    // Input spectrum
    Plot_Spectrum(aNAP^, TRUE, Sender);
    end;

procedure TForm1.aNAP2Click(Sender: TObject);           // Display - NAP - aNAP*
begin                                                   // Calculated spectrum
    Plot_Spectrum(aNAP_calc^, TRUE, Sender);
    end;

procedure TForm1.aNAPsClick(Sender: TObject);            // Display - NAP - aNAP*
begin                                                    // Calculated spectrum
    Plot_Spectrum(aNAP^, TRUE, Sender);
    end;

procedure TForm1.surface01Click(Sender: TObject);        // Display - Bottom - albedo[0]
begin                                                    // Input spectrum
    Plot_Spectrum(albedo[0]^, TRUE, Sender);
    end;

procedure TForm1.surface11Click(Sender: TObject);        // Display - Bottom - albedo[1]
begin                                                    // Input spectrum
    Plot_Spectrum(albedo[1]^, TRUE, Sender);
    end;

procedure TForm1.surface21Click(Sender: TObject);        // Display - Bottom - albedo[2]
begin                                                    // Input spectrum
    Plot_Spectrum(albedo[2]^, TRUE, Sender);
    end;

procedure TForm1.surface31Click(Sender: TObject);        // Display - Bottom - albedo[3]
begin                                                    // Input spectrum
    Plot_Spectrum(albedo[3]^, TRUE, Sender);
    end;

procedure TForm1.surface41Click(Sender: TObject);        // Display - Bottom - albedo[4]
begin                                                    // Input spectrum
    Plot_Spectrum(albedo[4]^, TRUE, Sender);
    end;

procedure TForm1.surface51Click(Sender: TObject);        // Display - Bottom - albedo[5]
begin                                                    // Input spectrum
    Plot_Spectrum(albedo[5]^, TRUE, Sender);
    end;

procedure TForm1.aO21Click(Sender: TObject);             // Display - Atmosphere - a_O2
begin                                                    // Input spectrum
    Plot_Spectrum(aO2^, TRUE, Sender);
    end;

procedure TForm1.aO31Click(Sender: TObject);             // Display - Atmosphere - a_O3
begin                                                    // Input spectrum
    Plot_Spectrum(aO3^, TRUE, Sender);
    end;

procedure TForm1.awv1Click(Sender: TObject);             // Display - Atmosphere - a_wv
begin                                                    // Input spectrum
    Plot_Spectrum(aWV^, TRUE, Sender);
    end;

procedure TForm1.TO2Click(Sender: TObject);              // Display - Atmosphere - T_O2
begin                                                    // Calculated spectrum
    Plot_Spectrum(GC_T_o2^, TRUE, Sender);
    end;

procedure TForm1.TO3Click(Sender: TObject);              // Display - Atmosphere - T_O3
begin                                                    // Calculated spectrum
    Plot_Spectrum(GC_T_o3^, TRUE, Sender);
    end;

procedure TForm1.T_wv1Click(Sender: TObject);            // Display - Atmosphere - T_wv
begin                                                    // Calculated spectrum
    Plot_Spectrum(GC_T_wv^, TRUE, Sender);
    end;

procedure TForm1.taua1Click(Sender: TObject);            // Display - Atmosphere - tau_a
begin                                                    // Calculated spectrum
    Plot_Spectrum(GC_tau_a^, TRUE, Sender);
    end;

procedure TForm1.T_r1Click(Sender: TObject);             // Display - Atmosphere - T_r
begin                                                    // Calculated spectrum
    Plot_Spectrum(GC_T_r^, TRUE, Sender);
    end;

procedure TForm1.T_as1Click(Sender: TObject);            // Display - Atmosphere - T_as
begin                                                    // Calculated spectrum
    Plot_Spectrum(GC_T_as^, TRUE, Sender);
    end;

procedure TForm1.T_aa1Click(Sender: TObject);           // Display - Atmosphere - T_aa
begin                                                   // Calculated spectrum
    Plot_Spectrum(GC_T_aa^, TRUE, Sender);
    end;

procedure TForm1.tAClick(Sender: TObject);               // Display - Atmosphere - tA
begin                                                    // Input spectrum - private
    Plot_Spectrum(tA^, TRUE, Sender);
    end;

procedure TForm1.tRClick(Sender: TObject);               // Display - Atmosphere - tR
begin                                                    // Calculated spectrum - private
    Plot_Spectrum(Rayleigh^, TRUE, Sender);
    end;

procedure TForm1.tMClick(Sender: TObject);               // Display - Atmosphere - tM
begin                                                    // Calculated spectrum - private
    Plot_Spectrum(Mie^, TRUE, Sender);
    end;

procedure TForm1.tCClick(Sender: TObject);               // Display - Atmosphere - tC
begin                                                    // Input spectrum - private
    Plot_Spectrum(tC^, TRUE, Sender);
    end;

procedure TForm1.E01Click(Sender: TObject);              // Display - Irradiance - E0
begin                                                    // Input spectrum
    Plot_Spectrum(E0^, TRUE, Sender);
    end;

procedure TForm1.Ed01Click(Sender: TObject);             // Display - Irradiance - Ed0
begin
    Plot_Spectrum(Ed0^, TRUE, Sender);
    end;

procedure TForm1.Ed1Click(Sender: TObject);              // Display - Irradiance - Ed
begin
    Plot_Spectrum(Ed^, TRUE, Sender);
    end;

procedure TForm1.Edd1Click(Sender: TObject);             // Display - Irradiance - f_dd*E_dd
begin
    Plot_Spectrum(GC_Edd^, TRUE, Sender);
    end;

procedure TForm1.Eds1Click(Sender: TObject);             // Display - Irradiance - f_ds*E_ds
begin
    Plot_Spectrum(GC_Eds^, TRUE, Sender);
    end;

procedure TForm1.Edsr1Click(Sender: TObject);            // Display - Irradiance - E_dsr
begin
    Plot_Spectrum(GC_Edsr^, TRUE, Sender);
    end;

procedure TForm1.display_EEM(E: EEMatrix; Sender: TObject);
begin
    if flag_preview then Format_2D.close;         { Only 1 preview permitted }
    EEM_to_image(E);
    flag_show_EEM:=TRUE;
    HSI_img^.Fname:=E.Fname;
    Format_2D:= TFormat_2D.Create(Application);   { Ausgabefenster erzeugen }
    Format_2D.Caption:=ExtractFilename(HSI_img^.FName);
    Format_2D.create_RGB(0, Height_in-1);
    Format_2D.FormCreate(Sender);
    Format_2D.PreviewHSI(Width_in, Height_in);
    Format_2D.Show;
    flag_preview:=TRUE;
    Save_img.visible:=TRUE;
    end;

procedure TForm1.EEM_phyClick(Sender: TObject);
begin
    display_EEM(EEM_ph, Sender);
    end;

procedure TForm1.EEM_YClick(Sender: TObject);
begin
    display_EEM(EEM_DOM, Sender);
    end;

procedure TForm1.Edsa1Click(Sender: TObject);            // Display - Irradiance - E_dsa
begin
    Plot_Spectrum(GC_Edsa^, TRUE, Sender);
    end;

procedure TForm1.r_d1Click(Sender: TObject);             // Display - Irradiance - r_d
begin
    Plot_Spectrum(r_d^, TRUE, Sender);
    end;

procedure TForm1.Lu1Click(Sender: TObject);              // Display - Radiance - Lu
begin
    Plot_Spectrum(Lu^, TRUE, Sender);
    end;

procedure TForm1.Lr1Click(Sender: TObject);              // Display - Radiance - Lr
begin
    Plot_Spectrum(Lr^, TRUE, Sender);
    end;

procedure TForm1.Ls1Click(Sender: TObject);              // Display - Radiance - Ls
begin
    Plot_Spectrum(Ls^, TRUE, Sender);
    end;

procedure TForm1.Lf1Click(Sender: TObject);              // Display - Radiance - Lf
begin
    Plot_Spectrum(Lf^, TRUE, Sender);
    end;

procedure TForm1.Kd1Click(Sender: TObject);              // Display - Attenuation - Kd
begin
    Plot_Spectrum(Kd^, TRUE, Sender);
    end;

procedure TForm1.Kdd1Click(Sender: TObject);             // Display - Attenuation - Kdd
begin
    Plot_Spectrum(Kdd^, TRUE, Sender);
    end;
                                                         // Display - Attenuation - Kds
procedure TForm1.Kds1Click(Sender: TObject);
begin
    Plot_Spectrum(Kds^, TRUE, Sender);
    end;

procedure TForm1.KEuWClick(Sender: TObject);             // Display - Attenuation - K_uW
begin
    Plot_Spectrum(KE_uW^, TRUE, Sender);
    end;

procedure TForm1.KEuBClick(Sender: TObject);             // Display - Attenuation - K_uB
begin
    Plot_Spectrum(KE_uB^, TRUE, Sender);
    end;

procedure TForm1.kLuWClick(Sender: TObject);             // Display - Attenuation - k_uW
begin
    Plot_Spectrum(kL_uW^, TRUE, Sender);
    end;

procedure TForm1.kLuBClick(Sender: TObject);             // Display - Attenuation - k_uB
begin
    Plot_Spectrum(KL_uB^, TRUE, Sender);
    end;

procedure TForm1.R1Click(Sender: TObject);               // Display - Reflectance - R
begin
    Plot_Spectrum(R^, TRUE, Sender);
    end;

procedure TForm1.LuEd1Click(Sender: TObject);            // Display - Reflectance - r_rs
begin
    Plot_Spectrum(r_rs^, TRUE, Sender);
    end;

procedure TForm1.Rrs1Click(Sender: TObject);       // Display - Reflectance - Rrs
begin
   Plot_Spectrum(Rrs^, TRUE, Sender);
   end;

procedure TForm1.Rsurf1Click(Sender: TObject);           // Display - Reflectance - Rrs_surf
begin
    Plot_Spectrum(Rrs_surf^, TRUE, Sender);
    end;

procedure TForm1.Rrsf1Click(Sender: TObject);            // Display - Reflectance - rrs_f
begin
    Plot_Spectrum(RrsF^, TRUE, Sender);
    end;

procedure TForm1.RnwClick(Sender: TObject);               // Display - Reflectance - R_foam
begin
    Plot_Spectrum(a_nw^, TRUE, Sender);
    end;

procedure TForm1.f1Click(Sender: TObject);               // Display - Reflectance - f
begin
    Plot_Spectrum(f_R^, TRUE, Sender);
    end;

procedure TForm1.frs1Click(Sender: TObject);             // Display - Reflectance - frs
begin
    Plot_Spectrum(f_rs^, TRUE, Sender);
    end;

procedure TForm1.bottom1Click(Sender: TObject);          // Display - Reflectance - bottom
begin
    Plot_Spectrum(bottom^, TRUE, Sender);
    end;

procedure TForm1.a1Click(Sender: TObject);               // Display - IOP - a
begin
    Plot_Spectrum(a^, TRUE, Sender);
    end;

procedure TForm1.b1Click(Sender: TObject);               // Display - IOP - b
begin
    Plot_Spectrum(b^, TRUE, Sender);
    end;

procedure TForm1.bb01Click(Sender: TObject);
begin
    Plot_Spectrum(bPhyN^, TRUE, Sender);                     // Display - IOP - bb*_phy
    end;

procedure TForm1.bb1Click(Sender: TObject);              // Display - IOP - bb
begin
    Plot_Spectrum(bb^, TRUE, Sender);
    end;

procedure TForm1.acalcClick(Sender: TObject);            // Display - IOP - a_calc
begin
    Plot_Spectrum(a_calc^, TRUE, Sender);
    end;

procedure TForm1.aPhcalcClick(Sender: TObject);          // Display - IOP - aPh_calc
begin
    Plot_Spectrum(aP_calc^, TRUE, Sender);
    end;

procedure TForm1.bcalc1Click(Sender: TObject);           // Display - IOP - b_calc
begin
    Plot_Spectrum(b_calc^, TRUE, Sender);
    end;

procedure TForm1.bbcalcClick(Sender: TObject);           // Display - IOP - bb_calc
begin                                                    // calculated spectrum
    Plot_Spectrum(bb_calc^, TRUE, Sender);
    end;

procedure TForm1.omegab1Click(Sender: TObject);          // Display - IOP - omega_b
begin
    Plot_Spectrum(omega_b^, TRUE, Sender);
    end;

procedure TForm1.FWHM1Click(Sender: TObject);            // Display - FWHM
begin
    Plot_Spectrum(FWHM^, TRUE, Sender);
    end;

procedure TForm1.gew1Click(Sender: TObject);             // Display - weight
begin
    Plot_Spectrum(gew^, TRUE, Sender);
    end;

procedure TForm1.kz90Click(Sender: TObject);             // Display - 1 % depth
begin
    Plot_Spectrum(z_Ed^, TRUE, Sender);
    end;

procedure TForm1.offset1Click(Sender: TObject);          // Display - offset
begin
    Plot_Spectrum(offsetS^, TRUE, Sender);
    end;

procedure TForm1.noise1Click(Sender: TObject);           // Display - noise
begin
    Plot_Spectrum(noiseS^, TRUE, Sender);
    end;

procedure TForm1.Stest1Click(Sender: TObject);           // Display - Private - Stest
begin
    Plot_Spectrum(Stest^, TRUE, Sender);
    end;

procedure TForm1.scale1Click(Sender: TObject);
begin
    Plot_Spectrum(scaleS^, TRUE, Sender);
    end;

procedure TForm1.sigmac1Click(Sender: TObject);          // Display - Private - u_c
begin
    Plot_Spectrum(u_c^, TRUE, Sender);
    end;

procedure TForm1.sigmat1Click(Sender: TObject);          // Display - Private - u_t
begin
    Plot_Spectrum(u_t^, TRUE, Sender);
    end;

procedure TForm1.sigmap1Click(Sender: TObject);          // Display - Private - u_p
begin
    Plot_Spectrum(u_p^, TRUE, Sender);
    end;

procedure TForm1.sigman1Click(Sender: TObject);          // Display - Private - u_n
begin
    Plot_Spectrum(u_n^, TRUE, Sender);
    end;


procedure TForm1.RbottomClick(Sender: TObject);
var result : boolean;
begin
    FormRbottom:= TFormRbottom.Create(Application); { Unit Popup_Rbottom }
     try
      Result := (FormRbottom.ShowModal = mrOK); { ausführen; Ergebnis basierend auf
                                                der Art des Schließens setzen }
      if result then begin
          dz_Ed:=FormRbottom.dzEd;
          dz_Eu:=FormRbottom.dzEu;
          dz_Lu:=FormRbottom.dzLu;
          flag_Rbottom:=FormRbottom.fl_Rbottom;
          Counter.color:=clPlotBk;
          update_GUI(Sender);
          end;
    finally
      FormRbottom.Free;                         { Formular freigeben }
      if show_bkgrd=FALSE then zeichne(Sender, TRUE);
    end;
    end;


{ *******************          Menu Item 'Options'           ***************** }

procedure TForm1.Models1Click(Sender: TObject);          // Options - Models
var result : boolean;
begin
    Form_Models:=TForm_Models.Create(Application);
    try
      result := (Form_Models.ShowModal = mrOK);
      if result then begin
          Form_Models.set_temp_parameters(Sender);
          set_borders;
          update_GUI(Sender);
          end;
    finally
      Form_Models.Free;
    end;
    end;

procedure TForm1.Data1Click(Sender: TObject);            // Options - Forward calculation
var result : boolean;
begin
    FormData:= TFormData.Create(Application); { Unit Popup_forward }
    try
        result := (FormData.ShowModal = mrOK);
        if result then FormData.set_temp_parameters(Sender);
    finally
    FormData.Free;
    end;
    end;

procedure TForm1.Fittuning1Click(Sender: TObject);       // Options - Invers calculation - Fit tuning
var result      : boolean;
    ch          : word;
    flag_weight : boolean;
begin
    Popup_FitTuning:=TPopup_Fittuning.Create(Application);
    try
      result := (Popup_FitTuning.ShowModal = mrOK);
      if result then begin
          flag_weight:=(Gew^.Fname<>Popup_FitTuning.t_Name_gew);
          Popup_FitTuning.set_temp_parameters(Sender);
          if flag_weight then begin
              lies_spektrum(gew^, Gew^.FName, Gew^.XColumn, Gew^.YColumn, Gew^.Header, ch, false);
              x_anpassen(gew^.y, ch, 0);
              end;
          set_borders;
          end;
    finally
    Popup_FitTuning.Free;
    end;
    end;

procedure TForm1.Definefitparameters1Click(Sender: TObject); // Options - Invers calculation - Fit parameters
var result : boolean;
begin
    Popup_Fitparameters:=TPopup_Fitparameters.Create(Application);
    try
      result := (Popup_Fitparameters.ShowModal = mrOK);
      if result then begin
          Popup_Fitparameters.set_temp_parameters(Sender);
          Frame_r1.FormCreate(Sender);
          end;
    finally
      Popup_Fitparameters.Free;
    end;
    end;

procedure TForm1.Reconstructionmode1Click(Sender: TObject); // Options - Reconstruction mode
var result : boolean;
begin
    Popup_Reconstruct:=TPopup_Reconstruct.Create(Application);
    try
      result := (Popup_Reconstruct.ShowModal = mrOK);
      if result then Popup_Reconstruct.set_temp_parameters(Sender);
      update_GUI(Sender);
    finally
      Popup_Reconstruct.Free;
    end;
end;

procedure TForm1.Dataformatnew1Click(Sender: TObject);   // Options - Data format
var result : boolean;
begin
    FormDataFormat:= TFormDataFormat.Create(Application);
    try
      result := (FormDataFormat.ShowModal = mrOK);
      if result then begin
          FormDataFormat.set_temp_parameters(Sender);
          if FormDataFormat.xmode_change then with FormDataFormat do begin
              xub:=xxu;
              xob:=xxo;
              dxb:=dxx;
              FWHM0:=t_FWHM0;
              flag_x_file:=fl_x_file;
              flag_FWHM:=fl_fwhm;
              x^.Fname:=t_name_x;
              x^.Header:=Header_x;
              x^.XColumn:=Xcol_x;
              x^.YColumn:=Ycol_x;
              delete_calculated_spectra;
              read_spectra;
              if flag_FWHM then resample;
           {   set_borders; }
              if error_msg<>'' then MessageDlg(error_msg, mtWarning, [mbOK], 0);
              Nspectra:=0;
              end;
          end;
    finally
    FormDataFormat.Free;
    end;
    end;

procedure TForm1.Directories1Click(Sender: TObject);     // Options - Directories
var result : boolean;
begin
    FormDir:= TFormDir.Create(Application);
    try
      result := (FormDir.ShowModal = mrOK);
      if result then FormDir.set_temp_parameters(Sender);
      if FormDir.tSpekName<>nil then SpekName:=FormDir.tSpekName;
    finally
      FormDir.Free;
    end;
    end;

procedure TForm1.Display1Click(Sender: TObject);         // Options - Display
var Result : boolean;
begin
    FormDisplay:= TFormDisplay.Create(Application);  { Formular erzeugen }
    try
      Result := (FormDisplay.ShowModal = mrOK); { ausführen; Ergebnis basierend auf
                                                der Art des Schließens setzen }
      if result then begin
          xu:=FormDisplay.xxu;
          xo:=FormDisplay.xxo;
          yu:=FormDisplay.yyu;
          yo:=FormDisplay.yyo;
          dotsize:=FormDisplay.tdotsize;
          dotMaxN:=FormDisplay.tdotMaxN;
          flag_grid:=FormDisplay.fl_grid;
          flag_dots:=FormDisplay.fl_dots;
          flag_Subgrid:=FormDisplay.fl_subgrid;
          flag_Autoscale:=FormDisplay.fl_autoscale;
          flag_ShowFile:=FormDisplay.fl_ShowFilename;
          flag_ShowPath:=FormDisplay.fl_path;
          Counter.color:=clPlotBk;
          end;
    finally
      FormDisplay.Free;                         { Formular freigeben }
      if show_bkgrd=FALSE then zeichne(Sender, TRUE);
    end;
    end;

procedure TForm1.General1Click(Sender: TObject);         // Options - General
var result : boolean;
begin
    FormGeneral:= TFormGeneral.Create(Application);
    try
      result := (FormGeneral.ShowModal = mrOK);
      if result then begin
          flag_INI:=FormGeneral.fl_ini;
          flag_mult_Ed:=FormGeneral.fl_Ed;
          flag_mult_E0:=FormGeneral.fl_E0;
          flag_mult_Rrs:=FormGeneral.fl_Rrs;
          Ed_factor:=FormGeneral.mult_Ed;
          E0_factor:=FormGeneral.mult_E0;
          Rrs_factor:=FormGeneral.mult_Rrs;
          read_spectra;
          set_borders;
          if error_msg<>'' then MessageDlg(error_msg, mtWarning, [mbOK], 0);
          Nspectra:=0;
          update_GUI(Sender);
          end;
    finally
        FormGeneral.Free;
    end;
    end;

procedure TForm1.Opt_2DClick(Sender: TObject);           // Options - 2D
var result : boolean;
begin
    Options_2D:= TOptions_2D.Create(Application); { Unit Popup_2D_Options}
    try
      result := (Options_2D.ShowModal = mrOK);
      if result then begin
          Options_2D.set_temp_parameters(Sender);
          if flag_update_prv then begin
              Screen.Cursor:=crHourGlass;
              if flag_truecolor_2D then
                  Format_2D.create_truecolor(Sender)
              else begin
                  Format_2D.load_RGB(Sender);
                  Format_2D.create_RGB(0, Height_in-1);
                  end;
              Format_2D.PreviewHSI(Width_in, Height_in);
              Format_2D.FormPaint(Sender);
              Screen.Cursor:=crDefault;
              end;
          end;
      finally
          Options_2D.Free;
          end;
    end;

procedure TForm1.MemoryClick(Sender: TObject);
var result : boolean;
begin
    Mem_Info:=TMem_Info.Create(Application);
    try
      result := (Mem_Info.ShowModal = mrOK);
      finally
          Mem_Info.Free;
          end;
    end;

procedure TForm1.LTOA1Click(Sender: TObject);
begin
    Plot_Spectrum(L_TOA, TRUE, Sender);
    end;

procedure TForm1.BOA_TOA_1Click(Sender: TObject);
begin
    Plot_Spectrum(BOA_TOA, TRUE, Sender);
    end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
   Plot_Spectrum(Q_f^, TRUE, Sender);
   end;

procedure TForm1.MenuTrueColorClick(Sender: TObject);
begin
    RGB:= TRGB.Create(Application);
    RGB.FormCreate(Sender, 100, 100, FALSE);
    RGB.TruecolorPanel_fromRrs(100, 100);
    if RGB_FileText='' then RGB_FileText:='color';
    end;

procedure TForm1.MenuNoiseClick(Sender: TObject);
begin
    calc_R_rs;
    simulate_sensor_signal(1);
    Plot_Spectrum(NEL, TRUE, Sender);
    end;

procedure TForm1.NEL1Click(Sender: TObject);
begin
    Plot_Spectrum(NEL, TRUE, Sender);
    end;


{ ********************          Menu Item 'Tools'           ****************** }

procedure TForm1.BSQBIL1Click(Sender: TObject);          // Tools - BSQ > BIL
begin                                                    // private
    Format_2D.BSQtoBIL(HSI_img^.Fname);
    end;

procedure TForm1.regression1Click(Sender: TObject);      // Tools - regression
begin                                                    // private
    Screen.Cursor:=crHourGlass;
    regression_3bands;
    Screen.Cursor:=crDefault;
    end;

procedure TForm1.Val1Click(Sender: TObject);             // Tools - Validation
var   old_extension : String;
      pic           : TPicture;
begin                                                    // private
    OpenDialog_CalVal.Title := 'Load data set';
    old_extension:='*'+ExtractFileExt(ValSet.FName);
    OpenDialog_CalVal.FileName:=ValSet.FName;
    OpenDialog_CalVal.Filter:=
        'Previous file (' +old_extension+')|' + old_extension+'|'+
        '|'+ 'All files (*.*)|*.*|';
    if OpenDialog_CalVal.Execute then begin
        ValSet.FName:=OpenDialog_CalVal.FileName;
        read_CalVal(false);   { unit fw_private }
        end;
    if flag_preview then begin
        Format_2D.plot_CalVal_data(Sender);
        Format_2D.Validate_data(Sender);     // only for extension .FIT or <= 3 bands
        SavePlotWindow(Sender, DIR_saveFwd + '\' + SCREENSHOT);
        pic:= TPicture.Create;
        pic.Bitmap.Assign(Format_2D.TheGraphic);
        pic.SaveToFile(DIR_saveFwd + '\' + WASI_IMG);
        pic.Free;
        end;
    end;

procedure TForm1.Subtract1Click(Sender: TObject);        // Tools - Subtract HSI
{ Subtract 2 HSI images from each other. }               // private
var   old_extension : String;
      First, Second : String;
      x, f, c       : longInt;
begin
    old_extension:='*'+ExtractFileExt(HSI_img^.FName);
    OpenDialog_HSI.FileName:=HSI_img^.FName;
    OpenDialog_HSI.Filter := 'Previous image (' +old_extension+')|' + old_extension+'|'+
        'Fit results (*.fit)|*.fit|' +
        'Grafik files (*.jpg;*.png;*.bmp;*.ico;*.emf;*.wmf)|*.jpg;*.png;*.bmp;*.ico;*.emf;*.wmf|'
        + 'All files (*.*)|*.*';
    OpenDialog_HSI.FilterIndex := 1;
    OpenDialog_HSI.Title := 'First image';
    if OpenDialog_HSI.Execute then First:=OpenDialog_HSI.Filename else First:='';
    OpenDialog_HSI.Title := 'Second image';
    if OpenDialog_HSI.Execute then Second:=OpenDialog_HSI.Filename else Second:='';
    TimeStartCalc:=Now;
    Screen.Cursor:=crHourGlass;

    if flag_ENVI then begin
        Format_2D:= TFormat_2D.Create(Application);
        Format_2D.Read_Envi_Header(First);
        end;

    ABBRUCH:=FALSE;
    Output_HSI:=ChangeFileExt(First, '') + '-' +
                ChangeFileExt(ExtractFileName(Second), '') + '.DIF';
    Channels_out:=Channels_in;
    SetLength(cube_fitpar, Width_in, Height_in, Channels_out);

    { loop over frames = image lines }
    f:=1;                                      // Set f to first processed image line
    repeat
        x:=1;                                  // Set x to first processed image column
        { loop over pixels = image columns }
        repeat
            HSI_img^.FName:=First;
            Format_2D.extract_spektrum_new(spec[1]^, x, f, Sender);  // Read first spectrum
            HSI_img^.FName:=Second;
            Format_2D.extract_spektrum_new(spec[2]^, x, f, Sender);  // Read second spectrum
            for c:=1 to Channels_out do cube_fitpar[x,f,c-1]:=spec[2]^.y[c]-spec[1]^.y[c]; 
            (* ratio of two images
            for c:=1 to Channels_out do
                if abs(spec[2]^.y[c])>nenner_min then
                    cube_fitpar[x,f,c-1]:=spec[1]^.y[c] / spec[2]^.y[c]
                else cube_fitpar[x,f,c-1]:=1;   *)
            inc(x);
        until (x>=Width_in) or ABBRUCH;
        inc(f);
    until (f>=Height_in) or ABBRUCH;

    Format_2D.Write_Fitresult(Height_in-1);
    TimeCalc  :=MilliSecondsBetween(Now, TimeStartCalc)/1000;
    Format_2D.Write_Envi_Header_fit(Output_HSI);
    Screen.Cursor:=crDefault;
    end;


{ ********************          Menu Item 'Help'           ******************* }

procedure TForm1.ManualClick(Sender: TObject);           // Help - Manual
begin
    Application.HelpFile := path_exe+'WASIManual.hlp';
  //  Application.HelpCommand(HELP_FINDER, 0);
{    WinHelp(Form1.Handle, PChar(Application.HelpFile), Help_Finder, 0); }
    end;

procedure TForm1.Anleitung1Click(Sender: TObject);       // Help - Anleitung
begin
    Application.HelpFile := path_exe+'ANLEITUNG.HLP';
    //Application.HelpCommand(HELP_FINDER, 0);
{    WinHelp(Form1.Handle, PChar(Application.HelpFile), Help_Finder, 0); }
    end;

procedure TForm1.About1Click(Sender: TObject);           // Help - About
begin
    About.ShowAboutBox;
    end;


{ **************************************************************************** }

procedure TForm1.averageimages1Click(Sender: TObject);
begin
    Screen.Cursor:=crHourGlass;
    CEOS_Average_images(Sender);      { in unit CEOS }
    Screen.Cursor:=crDefault;
    end;


procedure TForm1.medianimages1Click(Sender: TObject);
begin
    Screen.Cursor:=crHourGlass;
    Quantile_images(quantile, Sender);   { in unit privates }
    Screen.Cursor:=crDefault;
    end;

procedure TForm1.averagespectra1Click(Sender: TObject);
begin
    Screen.Cursor:=crHourGlass;
    if flag_CEOS then CEOS_Median_max(quantile, Sender)   { in unit CEOS }
                 else Average_spectra(TRUE);          { in unit privates }
    Screen.Cursor:=crDefault;
    end;

procedure TForm1.heatmap1Click(Sender: TObject);
begin                                                    // private
    OpenDialog_CalVal.Title := 'Load data set';
    OpenDialog_CalVal.Filter:='Text files (*.txt)|*.txt' +
                        '|'+ 'All files (*.*)|*.*|';
    if OpenDialog_CalVal.Execute then begin
        HM.FName:=OpenDialog_CalVal.FileName;
        read_XYdata;            { in unit privates }
        create_heatmap;         { in unit privates }
        end;
    end;


procedure TForm1.statistics1Click(Sender: TObject);
begin                                                    // private
    OpenDialog_CalVal.Title := 'Load data set';
    OpenDialog_CalVal.Filter:='Text files (*.txt)|*.txt' +
                        '|'+ 'All files (*.*)|*.*|';
    if OpenDialog_CalVal.Execute then begin
        HM.FName:=OpenDialog_CalVal.FileName;
        read_XYdata;                       { in unit privates }
        calculate_statistics(5,10,5,2);    { in unit privates }
        end;
    end;

procedure TForm1.banddemo1Click(Sender: TObject);
begin
    Format_2D.Explore_bands(Sender);
    end;

procedure TForm1.CMFL1Click(Sender: TObject);
begin
    Plot_Spectrum(CMF_r^, TRUE, Sender);
    end;

procedure TForm1.CMFM1Click(Sender: TObject);
begin
    Plot_Spectrum(CMF_g^, TRUE, Sender);
    end;


procedure TForm1.CMFS1Click(Sender: TObject);
begin
    Plot_Spectrum(CMF_b^, TRUE, Sender);
    end;

procedure TForm1.MProClick(Sender: TObject);
begin
    Plot_Spectrum(MP_ro, TRUE, Sender);
    end;

procedure TForm1.MPrpClick(Sender: TObject);
begin
    Plot_Spectrum(MP_rp, TRUE, Sender);
    end;

procedure TForm1.MPrp_infClick(Sender: TObject);
begin
    Plot_Spectrum(MP_rp_inf, TRUE, Sender);
    end;

procedure TForm1.MPRRiClick(Sender: TObject);
begin
    Plot_Spectrum(MP_RRi, TRUE, Sender);
    end;

procedure TForm1.MPRRoClick(Sender: TObject);
begin
    Plot_Spectrum(MP_RRo, TRUE, Sender);
    end;

procedure TForm1.MPtau_apClick(Sender: TObject);
begin
    Plot_Spectrum(MP_tau_ap, TRUE, Sender);
    end;

procedure TForm1.MPtau_ioClick(Sender: TObject);
begin
    Plot_Spectrum(MP_tau_io, TRUE, Sender);
    end;

procedure TForm1.MPtau_piClick(Sender: TObject);
begin
    Plot_Spectrum(MP_tau_pi, TRUE, Sender);
    end;

procedure TForm1.MPTd_iClick(Sender: TObject);
begin
    Plot_Spectrum(MP_Td_i, TRUE, Sender);
    end;

procedure TForm1.MPTd_pClick(Sender: TObject);
begin
    Plot_Spectrum(MP_Td_p, TRUE, Sender);
    end;

procedure TForm1.MPtu_iClick(Sender: TObject);
begin
    Plot_Spectrum(MP_tu_i, TRUE, Sender);
    end;

procedure TForm1.MPtu_pClick(Sender: TObject);
begin
    Plot_Spectrum(MP_tu_p, TRUE, Sender);
    end;

procedure TForm1.MPu_iClick(Sender: TObject);
begin
   Plot_Spectrum(MP_ui, TRUE, Sender);
   end;

procedure TForm1.SNR_BOA1Click(Sender: TObject);
begin
   Plot_Spectrum(SNR_BOA, TRUE, Sender);
   end;

procedure TForm1.SNR_TOA1Click(Sender: TObject);
begin
   Plot_Spectrum(SNR_TOA, TRUE, Sender);
   end;

procedure TForm1.Start3Change(Sender: TObject);
begin
    Frame_Batch1.Start3Change(Sender);
    end;

procedure TForm1.Steps1Change(Sender: TObject);
begin
    Frame_Batch1.Steps1Change(Sender);
    end;

procedure TForm1.view_fitChange(Sender: TObject);
begin

end;




initialization

begin
    path_exe:= ExtractFilePath(Application.ExeName);
    ReserveMemory;
    complete_vers;
    flag_Background:=ParamCount<>0;
    if flag_background then LoadINI_public(path_exe + ParamStr(1))
                       else LoadINI_public(path_exe + INI_public);
    if not flag_public then LoadINI_private;
    delete_calculated_spectra;
    define_curves;
    read_spectra;
    if error_msg<>'' then begin
        MessageBox(0, PChar(error_msg), 'Failed to start WASI', MB_ICONSTOP+MB_OK);
        halt;
        end;
    if flag_FWHM then resample;
    if error_msg<>'' then begin
        MessageBox(0, PChar(error_msg), 'Failed to start WASI', MB_ICONSTOP+MB_OK);
        halt;
        end;
    set_borders;                       // Define borders of fit interval
    set_parameters_inverse;            // Set model parameters for inverse mode
    if flag_MP then begin              // Melt pond mode
        note_parameters_before_MP;
        MP_Rrs_ocean;
        calc_p_ice;
        reset_parameters_before_MP;
        set_global_parameters_fw_MP;
        set_global_parameters_inv_MP;
        end;
    if not flag_public then set_mXYZ;
    Application.HintHidePause:=-1000;  // Display hints until mouse movement
    end;

finalization

begin
    if flag_ini then saveINI(TRUE);
    if flag_ini and not flag_public then saveINI(FALSE);
    if flag_MP then reset_parameters_before_MP;
    DisposeMemory;
    end;

end.
