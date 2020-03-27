unit Popup_Dataformat;

{$MODE Delphi}

{ Version vom 10.2.2020 }

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, defaults, SCHOEN_;

type

  { TFormDataFormat }

  TFormDataFormat = class(TForm)
    ButtonOK:  TButton;
    ButtonCancel: TButton;
    CheckLoad: TCheckBox;
    Check_read_view: TCheckBox;
    Edit_column_view: TEdit;
    Edit_line_view: TEdit;
    GroupBoxBatch: TGroupBox;
    EditFilesLoad: TEdit;
    ButtonDirLoad: TButton;
    OpenDialog1: TOpenDialog;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    EditHeaderRd: TEdit;
    EditXRd: TEdit;
    EditYRd: TEdit;
    EditXfile: TEdit;
    CheckSaveInv: TCheckBox;
    StaticText4: TStaticText;
    GroupBoxFileFormat: TGroupBox;
    Check_multi: TCheckBox;
    Static_column_view: TStaticText;
    Static_line_view: TStaticText;
    Text_max_col: TStaticText;
    Edit_max_col: TEdit;
    Check_read_sun: TCheckBox;
    Static_column_sun: TStaticText;
    Edit_column_sun: TEdit;
    Static_line_sun: TStaticText;
    Edit_line_sun: TEdit;
    Static_units: TStaticText;
    Radio_deg: TRadioButton;
    Radio_sr: TRadioButton;
    ButtonDirSave: TButton;
    Check_read_day: TCheckBox;
    Static_line_day: TStaticText;
    Edit_line_day: TEdit;
    Static_column_day: TStaticText;
    Edit_column_day: TEdit;
    Static_day: TStaticText;
    Edit_day: TEdit;
    GroupBoxWv: TGroupBox;
    TextXmin: TStaticText;
    TextXmax: TStaticText;
    Textdx: TStaticText;
    TextHeader: TStaticText;
    TextX: TStaticText;
    CheckBoxFile: TCheckBox;
    ButtonXfile: TButton;
    EditHeader: TEdit;
    EditXColumn: TEdit;
    EditXmin: TEdit;
    EditXmax: TEdit;
    EditDx: TEdit;
    Static_dxs: TStaticText;
    Edit_dxs: TEdit;
    Static_tab: TStaticText;
    Radio_tab_yes: TRadioButton;
    Radio_tab_no: TRadioButton;
    CheckBoxFWHM: TCheckBox;
    Static_FWHM: TStaticText;
    EditFWHM: TEdit;
    Text_FWHM: TStaticText;
    EditFWHMcolumn: TEdit;
    EditDirSave: TEdit;
    EditDirRead: TEdit;
    ButtonManipulate: TButton;
    CheckManipulate: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure set_temp_parameters(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonDirLoadClick(Sender: TObject);
    procedure CheckLoadClick(Sender: TObject);
    procedure CheckSaveInvClick(Sender: TObject);
    procedure EditHeaderRdChange(Sender: TObject);
    procedure EditXRdChange(Sender: TObject);
    procedure EditYRdChange(Sender: TObject);
    procedure Check_multiClick(Sender: TObject);
    procedure Edit_max_colChange(Sender: TObject);
    procedure Check_read_sunClick(Sender: TObject);
    procedure Check_read_viewClick(Sender: TObject);
    procedure Edit_line_sunChange(Sender: TObject);
    procedure Edit_column_sunChange(Sender: TObject);
    procedure Edit_line_viewChange(Sender: TObject);
    procedure Edit_column_viewChange(Sender: TObject);
    procedure Radio_degClick(Sender: TObject);
    procedure Radio_srClick(Sender: TObject);
    procedure ButtonDirSaveClick(Sender: TObject);
    procedure Edit_line_dayChange(Sender: TObject);
    procedure Edit_column_dayChange(Sender: TObject);
    procedure Edit_dayChange(Sender: TObject);
    procedure Check_read_dayClick(Sender: TObject);
    procedure CheckBoxFileClick(Sender: TObject);
    procedure EditXminChange(Sender: TObject);
    procedure EditXmaxChange(Sender: TObject);
    procedure EditDxChange(Sender: TObject);
    procedure ButtonXfileClick(Sender: TObject);
    procedure EditHeaderChange(Sender: TObject);
    procedure EditXColumnChange(Sender: TObject);
    procedure Edit_dxsChange(Sender: TObject);
    procedure Radio_tab_yesClick(Sender: TObject);
    procedure Radio_tab_noClick(Sender: TObject);
    procedure CheckBoxFWHMClick(Sender: TObject);
    procedure EditFWHMChange(Sender: TObject);
    procedure EditFWHMcolumnChange(Sender: TObject);
    function  xmode_change:boolean;
    procedure ButtonManipulateClick(Sender: TObject);
    procedure CheckManipulateClick(Sender: TObject);
  private
    fl_b_SaveFwd : boolean;
    fl_b_SaveInv : boolean;
    fl_b_LoadAll : boolean;
    fl_sv_table  : boolean;
    fl_b_Reset   : boolean;
    fl_multi     : boolean;
    fl_read_day  : boolean;
    fl_read_sun  : boolean;
    fl_read_view : boolean;
    fl_sun_unit  : boolean;
    fl_tab       : boolean;
    dir_svFwd    : String;
    dir_svInv    : String;
    dir_ldBatch  : String;
    ext_ldBatch  : String;
    Header_m     : integer;
    XColumn_m    : byte;
    YColumn_m    : byte;
    YColMax_m    : integer;
    Xsun_b       : byte;
    Ysun_b       : byte;
    Xview_b      : byte;
    Yview_b      : byte;
    Xday_b       : byte;
    Yday_b       : byte;
    Day_b        : integer;
    input        : single;
    error        : integer;
  public
    tSpekName      : TStrings;
    header_x       : word;
    Xcol_x         : word;
    Ycol_x         : word;
    header_ofs     : word;
    fl_x_file      : boolean;
    fl_fwhm        : boolean;
    fl_manipulate  : boolean;
    xxu, xxo, dxx  : single;
    t_fwhm0        : single;
    t_dxs          : integer;
    t_Name_x       : String;
  end;

var
  FormDataFormat: TFormDataFormat;

implementation

uses Popup_Dataformat_Advanced;

{$R *.lfm}

procedure TFormDataFormat.FormCreate(Sender: TObject);
var s : ShortString;
begin
    xxu:=xub;
    xxo:=xob;
    dxx:=dxb;
    t_fwhm0:=fwhm0;
    t_dxs:=dxs;
    fl_x_file   :=flag_x_file;
    fl_fwhm     :=flag_fwhm;
    fl_manipulate:=flag_offset or flag_scale;
    fl_b_SaveFwd:=flag_b_SaveFwd;
    fl_b_SaveInv:=flag_b_SaveInv;
    fl_b_LoadAll:=flag_b_LoadAll;
    fl_b_Reset  :=flag_b_Reset;
    fl_sv_table :=flag_sv_table;
    fl_multi    :=flag_multi;
    fl_read_day :=flag_read_day;
    fl_read_sun :=flag_read_sun;
    fl_read_view :=flag_read_view;
    fl_sun_unit :=flag_sun_unit;
    fl_tab      :=flag_tab;
    Header_x    :=x^.Header;
    Xcol_x      :=x^.XColumn;
    Ycol_x      :=x^.YColumn;
    t_Name_x    :=x^.FName;
    Header_ofs  :=offsetS^.Header;
    Header_m    :=meas^.Header;
    XColumn_m   :=meas^.XColumn;
    YColumn_m   :=meas^.YColumn;
    YColMax_m   :=ycol_max;
    XSun_b      :=line_sun;
    YSun_b      :=col_sun;
    XView_b     :=line_view;
    YView_b     :=col_view;
    XDay_b      :=line_day;
    YDay_b      :=col_day;
    Day_b       :=day;
    CheckBoxFile.checked   :=fl_x_file;
    CheckBoxFWHM.checked   :=fl_fwhm;
    CheckSaveInv.checked   :=fl_b_SaveInv;
    CheckLoad.checked      :=fl_b_LoadAll;
    Check_multi.checked    :=fl_multi;
    Check_read_day.Checked :=fl_read_day;
    Check_read_sun.Checked :=fl_read_sun;
    Check_read_view.Checked :=fl_read_view;
    CheckManipulate.checked:=fl_manipulate;
    Radio_deg.Checked      :=fl_sun_unit;
    Radio_sr.Checked       :=not fl_sun_unit;
    Radio_tab_yes.checked  :=fl_tab;
    Radio_tab_no.checked   :=not fl_tab;
    ext_ldBatch:=ExtractFileExt(Name_LdBatch);
    dir_svFwd:=DIR_saveFwd;
    dir_svInv:=DIR_saveInv;
    dir_ldBatch:=ExtractFileDir(Name_LdBatch);
    if dir_ldBatch[length(dir_ldBatch)]<>'\' then dir_ldBatch:=dir_ldBatch+'\';
    str(Header_x, S); EditHeader.Text:=S;
    str(XCol_x, S);   EditXColumn.Text:=S;
    str(YCol_x, S);   EditFWHMColumn.Text:=S;
    EditXfile.Text:=t_Name_x;
    EditXmin.Text:=schoen(xxu, 3);
    EditXmax.Text:=schoen(xxo, 3);
    EditdX.Text  :=schoen(dxx, 3);
    EditFWHM.Text:=schoen(t_fwhm0, 2);
    EditFWHM.visible:=fl_fwhm;
    Static_FWHM.visible:=fl_fwhm;
    Edit_dxs.Text:=schoen(t_dxs,0);
    EditFilesLoad.text:='*'+ext_LdBatch;
    EditHeaderRd.text:=IntToStr(Header_m);
    EditXRd.text:=IntToStr(XColumn_m);
    EditYRd.text:=IntToStr(YColumn_m);
    Edit_max_col.text:=IntToStr(YColMax_m);
    Edit_line_day.text:=IntToStr(Xday_b);
    Edit_column_day.text:=IntToStr(Yday_b);
    Edit_line_sun.text:=IntToStr(XSun_b);
    Edit_column_sun.text:=IntToStr(YSun_b);
    Edit_line_view.text:=IntToStr(XView_b);
    Edit_column_view.text:=IntToStr(YView_b);
    Edit_day.text:=IntToStr(Day_b);
    tSpekName:=nil;
    EditDirSave.Text:=dir_svInv;
    EditDirRead.Text:=dir_ldBatch;
    Text_max_col.enabled:=fl_multi and fl_b_LoadAll;
    Edit_max_col.enabled:=fl_multi and fl_b_LoadAll;
    Static_line_day.enabled:=fl_read_day;
    Static_column_day.enabled:=fl_read_day;
    Edit_line_day.enabled:=fl_read_day;
    Edit_column_day.enabled:=fl_read_day;
    Static_day.Enabled:=not fl_read_day;
    Edit_day.Enabled:=not fl_read_day;
    Static_line_sun.enabled:=fl_read_sun;
    Static_column_sun.enabled:=fl_read_sun;
    Edit_line_sun.enabled:=fl_read_sun;
    Edit_column_sun.enabled:=fl_read_sun;
    Static_line_view.enabled:=fl_read_view;
    Static_column_view.enabled:=fl_read_view;
    Edit_line_view.enabled:=fl_read_view;
    Edit_column_view.enabled:=fl_read_view;
    Static_units.enabled:=fl_read_sun or fl_read_view;
    Radio_deg.enabled:=fl_read_sun or fl_read_view;
    Radio_sr.enabled :=fl_read_sun or fl_read_view;
    StaticText4.enabled:=fl_b_LoadAll;
    EditFilesLoad.enabled:=fl_b_LoadAll;
    Check_multi.enabled:=fl_b_LoadAll;
    ButtonDirLoad.enabled:=fl_b_LoadAll;
    ButtonDirSave.enabled:=fl_b_SaveInv;
    if fl_x_file=FALSE then begin
        EditHeader.Enabled:=FALSE;
        EditXColumn.Enabled:=FALSE;
        EditFWHMColumn.Enabled:=FALSE;
        end;
    end;


procedure TFormDataFormat.set_temp_parameters(Sender: TObject);
{ Copy temporary parameter set to the valid parameter set. }
begin
    x^.Header     := FormDataFormat.Header_x;
    x^.XColumn    := FormDataFormat.Xcol_x;
    x^.YColumn    := FormDataFormat.Ycol_x;
    flag_b_SaveFwd:= fl_b_SaveFwd;
    flag_b_SaveInv:= fl_b_SaveInv;
    flag_b_LoadAll:= fl_b_LoadAll;
    flag_b_Reset  := fl_b_Reset;
    flag_sv_table := fl_sv_Table;
    flag_read_day := fl_read_day;
    flag_read_sun := fl_read_sun;
    flag_read_view := fl_read_view;
    flag_sun_unit := fl_sun_unit;
    flag_tab      := fl_tab;
    flag_multi    := fl_multi;
    DIR_saveFwd   := DIR_svFwd;
    DIR_saveInv   := DIR_svInv;
    meas^.Header  := Header_m;
    meas^.XColumn := XColumn_m;
    meas^.YColumn := YColumn_m;
    ycol_max      := YColMax_m;
    line_sun      := Xsun_b;
    col_sun       := Ysun_b;
    line_view     := Xview_b;
    col_view      := Yview_b;
    line_day      := Xday_b;
    col_day       := Yday_b;
    if (Day_b>0) and (Day_b<=365) then begin
        day := Day_b;
        sun_earth:=sqr(1+0.0167*cos(2*pi*(day-3)/365));
        end;
    Name_LdBatch  := dir_ldBatch + '*' + ext_ldBatch;
    dir_svInv     := EditDirSave.Text;
    dxs:=t_dxs;
    end;

procedure TFormDataFormat.CheckSaveInvClick(Sender: TObject);
begin
    fl_b_SaveInv:=CheckSaveInv.checked;
    ButtonDirSave.enabled:=fl_b_SaveInv;
    end;

procedure TFormDataFormat.ButtonOKClick(Sender: TObject);
begin
    ModalResult := mrOK;
    end;

procedure TFormDataFormat.ButtonManipulateClick(Sender: TObject);
var result : boolean;
begin
    FormDataFormatAdvanced:= TFormDataFormatAdvanced.Create(Application);
    try
      result := (FormDataFormatAdvanced.ShowModal = mrOK);
      if result then begin
          FormDataFormatAdvanced.set_temp_parameters(Sender);
          end;
    finally
    FormDataFormatAdvanced.Free;
    end;
    end;

procedure TFormDataFormat.ButtonCancelClick(Sender: TObject);
begin
    ModalResult := mrCancel;
    end;


procedure TFormDataFormat.ButtonDirLoadClick(Sender: TObject);
begin
    OpenDialog1.Title:='Invert files';
    OpenDialog1.InitialDir:=dir_ldBatch;
    OpenDialog1.Filter:='(*'+ext_ldBatch+') |*' + ext_ldBatch+
        '|forward calculation (*.'+EXT_FWD+')|*.'+EXT_FWD+
        '|all files (*.*)|*.*|';
    if OpenDialog1.Execute then begin
        dir_ldBatch:=ExtractFileDir(OpenDialog1.FileName)+'\';
        ext_ldBatch:=ExtractFileExt(OpenDialog1.FileName);
        tSpekName:=OpenDialog1.Files;
        EditFilesLoad.text:='*'+ext_LdBatch;
        EditFilesLoad.refresh;
        EditDirRead.Text:=dir_ldBatch;
        end;
    end;

procedure TFormDataFormat.CheckLoadClick(Sender: TObject);
begin
    fl_b_LoadAll:=CheckLoad.checked;
    StaticText4.enabled:=fl_b_LoadAll;
    EditFilesLoad.enabled:=fl_b_LoadAll;
    Check_multi.enabled:=fl_b_LoadAll;
    Text_max_col.enabled:=fl_multi and fl_b_LoadAll;
    Edit_max_col.enabled:=fl_multi and fl_b_LoadAll;
    ButtonDirLoad.enabled:=fl_b_LoadAll;
    end;

procedure TFormDataFormat.CheckManipulateClick(Sender: TObject);
begin
    fl_manipulate:=flag_offset or flag_scale;
    CheckManipulate.checked:=fl_manipulate;
    end;

procedure TFormDataFormat.EditHeaderRdChange(Sender: TObject);
begin
    val(EditHeaderRd.Text, input, error);
    if error=0 then Header_m:=round(input);
    end;

procedure TFormDataFormat.EditXRdChange(Sender: TObject);
begin
    val(EditXRd.Text, input, error);
    if error=0 then XColumn_m:=round(input);
    end;

procedure TFormDataFormat.EditYRdChange(Sender: TObject);
begin
    val(EditYRd.Text, input, error);
    if error=0 then YColumn_m:=round(input);
    end;

procedure TFormDataFormat.Check_multiClick(Sender: TObject);
begin
    fl_multi:=Check_multi.checked;
    Text_max_col.enabled:=fl_multi and fl_b_LoadAll;
    Edit_max_col.enabled:=fl_multi and fl_b_LoadAll;
    end;

procedure TFormDataFormat.Edit_max_colChange(Sender: TObject);
begin
    val(Edit_max_col.Text, input, error);
    if error=0 then YColMax_m:=round(input);
    end;

procedure TFormDataFormat.Check_read_sunClick(Sender: TObject);
begin
    fl_read_sun:=Check_read_sun.checked;
    Static_line_sun.enabled:=fl_read_sun;
    Static_column_sun.enabled:=fl_read_sun;
    Edit_line_sun.enabled:=fl_read_sun;
    Edit_column_sun.enabled:=fl_read_sun;
    Static_units.enabled:=fl_read_sun;
    Radio_deg.enabled:=fl_read_sun;
    Radio_sr.enabled :=fl_read_sun;
    end;

procedure TFormDataFormat.Check_read_viewClick(Sender: TObject);
begin
    fl_read_view:=Check_read_view.checked;
    Static_line_view.enabled:=fl_read_view;
    Static_column_view.enabled:=fl_read_view;
    Edit_line_view.enabled:=fl_read_view;
    Edit_column_view.enabled:=fl_read_view;
    Static_units.enabled:=fl_read_view;
    Radio_deg.enabled:=fl_read_view;
    Radio_sr.enabled :=fl_read_view;
    end;

procedure TFormDataFormat.Edit_line_sunChange(Sender: TObject);
begin
    val(Edit_line_sun.Text, input, error);
    if error=0 then Xsun_b:=round(input);
    end;

procedure TFormDataFormat.Edit_column_sunChange(Sender: TObject);
begin
    val(Edit_column_sun.Text, input, error);
    if error=0 then Ysun_b:=round(input);
    end;

procedure TFormDataFormat.Edit_line_viewChange(Sender: TObject);
begin
    val(Edit_line_view.Text, input, error);
    if error=0 then Xview_b:=round(input);
    end;

procedure TFormDataFormat.Edit_column_viewChange(Sender: TObject);
begin
    val(Edit_column_view.Text, input, error);
    if error=0 then Yview_b:=round(input);
    end;

procedure TFormDataFormat.Radio_degClick(Sender: TObject);
begin
    fl_sun_unit:=TRUE;
    Radio_deg.Checked      :=fl_sun_unit;
    Radio_sr.Checked       :=not fl_sun_unit;
    end;

procedure TFormDataFormat.Radio_srClick(Sender: TObject);
begin
    fl_sun_unit:=FALSE;
    Radio_deg.Checked      :=fl_sun_unit;
    Radio_sr.Checked       :=not fl_sun_unit;
    end;

procedure TFormDataFormat.ButtonDirSaveClick(Sender: TObject);
var S : String;
begin
    S:=dir_svInv;
    if SelectDirectory('Select directory to save calculated spectra', '', S) then begin
        dir_svInv:=S;
        EditDirSave.Text:=S;
        end;
    end;

procedure TFormDataFormat.Edit_line_dayChange(Sender: TObject);
begin
    val(Edit_line_day.Text, input, error);
    if error=0 then Xday_b:=round(input);
    end;

procedure TFormDataFormat.Edit_column_dayChange(Sender: TObject);
begin
    val(Edit_column_day.Text, input, error);
    if error=0 then Yday_b:=round(input);
    end;

procedure TFormDataFormat.Edit_dayChange(Sender: TObject);
begin
    val(Edit_day.Text, input, error);
    if error=0 then Day_b:=round(input);
    end;

procedure TFormDataFormat.Check_read_dayClick(Sender: TObject);
begin
    fl_read_day:=Check_read_day.checked;
    Static_line_day.enabled:=fl_read_day;
    Static_column_day.enabled:=fl_read_day;
    Edit_line_day.enabled:=fl_read_day;
    Edit_column_day.enabled:=fl_read_day;
    Static_day.Enabled:=not fl_read_day;
    Edit_day.Enabled:=not fl_read_day;
    end;

procedure TFormDataFormat.CheckBoxFileClick(Sender: TObject);
begin
    if CheckBoxFile.checked then begin
        EditHeader.Enabled:=TRUE;
        EditXColumn.Enabled:=TRUE;
        EditFWHMColumn.Enabled:=TRUE;
        EditXmin.Enabled:=FALSE;
        EditXmax.Enabled:=FALSE;
        EditDX.Enabled:=FALSE;
        EditFWHM.Enabled:=FALSE;
        EditXmin.Text  :=schoen(xfile_xu, 3);
        EditXmax.Text  :=schoen(xfile_xo, 3);
        fl_x_file:=TRUE;
        xxu:=xfile_xu;
        xxo:=xfile_xo;
        end
    else begin
        EditXmin.Text:=schoen(xub, 3);
        EditXmax.Text:=schoen(xob, 3);
        EditdX.Text  :=schoen(dxb, 3);
        EditXmin.Enabled:=TRUE;
        EditXmax.Enabled:=TRUE;
        EditDX.Enabled:=TRUE;
        EditFWHM.Enabled:=TRUE;
        EditHeader.Enabled:=FALSE;
        EditXColumn.Enabled:=FALSE;
        EditFWHMColumn.Enabled:=FALSE;
        fl_x_file:=FALSE;
        EditXMinChange(Sender);
        EditXMaxChange(Sender);
        end;
    end;

procedure TFormDataFormat.EditXminChange(Sender: TObject);
begin
    val(EditXmin.Text, input, error);
    if error=0 then xxu:=input;
    if xxu<MinX then xxu:=MinX;
    end;

procedure TFormDataFormat.EditXmaxChange(Sender: TObject);
begin
    val(EditXmax.Text, input, error);
    if error=0 then xxo:=input;
    if xxo>MaxX then xxo:=MaxX;
    end;

procedure TFormDataFormat.EditDxChange(Sender: TObject);
begin
    val(EditDX.Text, input, error);
    if error=0 then dxx:=input;
    if dxx<MinDX then dxx:=MinDX;
    end;

procedure TFormDataFormat.ButtonXfileClick(Sender: TObject);
var old_extension : String;
begin
if CheckBoxFile.checked then begin
    old_extension:='*'+ExtractFileExt(x^.FName);
    OpenDialog1.FileName:=x^.FName;
    OpenDialog1.InitialDir := ExtractFilePath(x^.FName);
    OpenDialog1.Title := 'Load file with x-values';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';

    if OpenDialog1.Execute then
        t_Name_x:=OpenDialog1.FileName;
    EditXfile.text:=t_Name_x;
    EditXfile.refresh;
    end;
    end;

procedure TFormDataFormat.EditHeaderChange(Sender: TObject);
begin
    val(EditHeader.Text, input, error);
    if error=0 then Header_x:=round(input);
    end;


procedure TFormDataFormat.EditXColumnChange(Sender: TObject);
begin
    val(EditXColumn.Text, input, error);
    if error=0 then Xcol_x:=round(input);
    end;

procedure TFormDataFormat.Edit_dxsChange(Sender: TObject);
begin
    val(Edit_dxs.Text, input, error);
    if error=0 then t_dxs:=round(input);
    if t_dxs<1 then t_dxs:=1;
    end;

procedure TFormDataFormat.Radio_tab_yesClick(Sender: TObject);
begin
    fl_tab:=TRUE;
    Radio_tab_yes.checked  :=fl_tab;
    Radio_tab_no.checked   :=not fl_tab;
    end;

procedure TFormDataFormat.Radio_tab_noClick(Sender: TObject);
begin
    fl_tab:=FALSE;
    Radio_tab_yes.checked  :=fl_tab;
    Radio_tab_no.checked   :=not fl_tab;
    end;

procedure TFormDataFormat.CheckBoxFWHMClick(Sender: TObject);
begin
    fl_fwhm:=CheckBoxFWHM.checked;
    EditFWHM.visible:=fl_fwhm;
    Static_FWHM.visible:=fl_fwhm;
    end;


procedure TFormDataFormat.EditFWHMChange(Sender: TObject);
begin
    val(EditFWHM.Text, input, error);
    if error=0 then t_FWHM0:=input;
    if t_FWHM0<FWHM0_min then t_FWHM0:=FWHM0_min
    else if t_FWHM0>FWHM0_max then t_FWHM0:=FWHM0_max
    end;

procedure TFormDataFormat.EditFWHMcolumnChange(Sender: TObject);
begin
    val(EditFWHMColumn.Text, input, error);
    if error=0 then Ycol_x:=round(input);
    end;

function TFormDataFormat.xmode_change:boolean;
begin
    xmode_change:=FALSE;
    if xxu<>xub then xmode_change:=TRUE
    else if xxo<>xob then xmode_change:=TRUE
    else if dxx<>dxb then xmode_change:=TRUE
    else if fl_x_file<>flag_x_file then xmode_change:=TRUE
    else if fl_fwhm<>flag_fwhm then xmode_change:=TRUE
    else if t_fwhm0<>fwhm0 then xmode_change:=TRUE;
    end;

end.


