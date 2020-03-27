unit Popup_Dataformat_Advanced;

{$MODE Delphi}

{ Version vom 10.2.2020 }

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, defaults, misc;

type
  TFormDataFormatAdvanced = class(TForm)
    ButtonOK:  TButton;
    ButtonCancel: TButton;
    OpenDialog1: TOpenDialog;
    GroupBoxManipulate: TGroupBox;
    TextScaleHeader: TStaticText;
    TextScaleX: TStaticText;
    CheckBoxMultiply: TCheckBox;
    EditScaleFile: TEdit;
    ButtonScaleFile: TButton;
    EditScaleHeader: TEdit;
    EditScaleX: TEdit;
    TextScaleY: TStaticText;
    EditScaleY: TEdit;
    TextOffsetX: TStaticText;
    CheckBoxAdd: TCheckBox;
    ButtonOffsetFile: TButton;
    TextOffsetHeader: TStaticText;
    EditOffsetHeader: TEdit;
    EditOffsetX: TEdit;
    TextOffsetY: TStaticText;
    EditOffsetY: TEdit;
    EditOffsetFile: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure set_temp_parameters(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonDirSaveClick(Sender: TObject);
    procedure ButtonScaleFileClick(Sender: TObject);
    procedure EditScaleHeaderChange(Sender: TObject);
    procedure EditScaleXChange(Sender: TObject);
    procedure EditScaleYChange(Sender: TObject);
    procedure CheckBoxMultiplyClick(Sender: TObject);
    procedure CheckBoxAddClick(Sender: TObject);
    procedure ButtonOffsetFileClick(Sender: TObject);
    procedure EditOffsetHeaderChange(Sender: TObject);
    procedure EditOffsetXChange(Sender: TObject);
    procedure EditOffsetYChange(Sender: TObject);
  private
    Header_m     : integer;
    XColumn_m    : byte;
    YColumn_m    : byte;
    YColMax_m    : integer;
    input        : single;
    error        : integer;
  public
    header_ofs     : word;
    Xcol_ofs       : word;
    Ycol_ofs     : word;
    header_scale   : word;
    Xcol_scale     : word;
    Ycol_scale     : word;
    fl_scale       : boolean;
    fl_ofs         : boolean;
    t_Name_ofs     : String;
    t_Name_scale   : String;
  end;

var
  FormDataFormatAdvanced: TFormDataFormatAdvanced;

implementation

{$R *.lfm}

procedure TFormDataFormatAdvanced.FormCreate(Sender: TObject);
var s : ShortString;
begin
    fl_ofs      :=flag_offset;
    fl_scale    :=flag_scale;
    Header_ofs  :=offsetS^.Header;
    Xcol_ofs    :=offsetS^.XColumn;
    Ycol_ofs    :=offsetS^.YColumn;
    t_Name_ofs  :=offsetS^.FName;
    Header_scale:=scaleS^.Header;
    Xcol_scale  :=scaleS^.XColumn;
    Ycol_scale  :=scaleS^.YColumn;
    t_Name_scale:=scaleS^.FName;
    Header_m    :=meas^.Header;
    XColumn_m   :=meas^.XColumn;
    YColumn_m   :=meas^.YColumn;
    YColMax_m   :=ycol_max;
    CheckBoxAdd.checked    :=fl_ofs;
    CheckBoxMultiply.Checked:=fl_scale;
    str(Header_scale, S); EditScaleHeader.Text:=S;
    str(XCol_scale, S);   EditScaleX.Text:=S;
    str(YCol_scale, S);   EditScaleY.Text:=S;
    EditScaleFile.Text:=t_Name_scale;
    str(Header_ofs, S); EditOffsetHeader.Text:=S;
    str(XCol_ofs, S);   EditOffsetX.Text:=S;
    str(YCol_ofs, S);   EditOffsetY.Text:=S;
    EditOffsetFile.Text:=t_Name_ofs;
    ButtonOffsetFile.enabled:=fl_ofs;
    ButtonScaleFile.enabled:=fl_scale;
    if fl_scale=FALSE then begin
        EditScaleHeader.Enabled:=FALSE;
        EditScaleX.Enabled:=FALSE;
        EditScaleY.Enabled:=FALSE;
        end;
    end;

procedure TFormDataFormatAdvanced.set_temp_parameters(Sender: TObject);
{ Copy temporary parameter set to the valid parameter set. }
var flag_import : boolean;
begin
    flag_import:=offsetS^.FName<>t_Name_ofs;
    offsetS^.FName  := t_Name_ofs;
    offsetS^.Header := Header_ofs;
    offsetS^.XColumn:= Xcol_ofs;
    offsetS^.YColumn:= Ycol_ofs;
    if flag_import then import_spectrum(offsetS^);

    flag_import:=scaleS^.FName<>t_Name_scale;
    scaleS^.FName   := t_Name_scale;
    scaleS^.Header  := Header_scale;
    scaleS^.XColumn := Xcol_scale;
    scaleS^.YColumn := Ycol_scale;
    if flag_import then import_spectrum(scaleS^);

    flag_scale    := fl_scale;
    flag_offset   := fl_ofs;
    meas^.Header  := Header_m;
    meas^.XColumn := XColumn_m;
    meas^.YColumn := YColumn_m;
    ycol_max      := YColMax_m;
    end;

procedure TFormDataFormatAdvanced.ButtonOffsetFileClick(Sender: TObject);
var old_extension : ShortString;
begin
if CheckBoxAdd.checked then begin
    old_extension:='*'+ExtractFileExt(offsetS^.FName);
    OpenDialog1.FileName:=offsetS^.FName;
    OpenDialog1.InitialDir := ExtractFilePath(offsetS^.FName);
    OpenDialog1.Title := 'Load offset spectrum';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';

    if OpenDialog1.Execute then
        t_Name_ofs:=OpenDialog1.FileName;
    EditOffsetfile.text:=t_Name_ofs;
    EditOffsetfile.refresh;
    end;
    end;

procedure TFormDataFormatAdvanced.ButtonOKClick(Sender: TObject);
begin
    ModalResult := mrOK;
    end;

procedure TFormDataFormatAdvanced.ButtonScaleFileClick(Sender: TObject);
var old_extension : ShortString;
begin
if CheckBoxMultiply.checked then begin
    old_extension:='*'+ExtractFileExt(scaleS^.FName);
    OpenDialog1.FileName:=scaleS^.FName;
    OpenDialog1.InitialDir := ExtractFilePath(scaleS^.FName);
    OpenDialog1.Title := 'Load scaling spectrum';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';

    if OpenDialog1.Execute then
        t_Name_scale:=OpenDialog1.FileName;
    EditScalefile.text:=t_Name_scale;
    EditScalefile.refresh;
    end;
    end;

procedure TFormDataFormatAdvanced.ButtonCancelClick(Sender: TObject);
begin
    ModalResult := mrCancel;
    end;


procedure TFormDataFormatAdvanced.EditOffsetHeaderChange(Sender: TObject);
begin
    val(EditOffsetHeader.Text, input, error);
    if error=0 then Header_ofs:=round(input);
    end;

procedure TFormDataFormatAdvanced.EditScaleHeaderChange(Sender: TObject);
begin
    val(EditScaleHeader.Text, input, error);
    if error=0 then Header_scale:=round(input);
    end;

procedure TFormDataFormatAdvanced.EditScaleXChange(Sender: TObject);
begin
    val(EditScaleX.Text, input, error);
    if error=0 then Xcol_scale:=round(input);
    end;

procedure TFormDataFormatAdvanced.EditScaleYChange(Sender: TObject);
begin
    val(EditScaleY.Text, input, error);
    if error=0 then Ycol_scale:=round(input);
    end;

procedure TFormDataFormatAdvanced.ButtonDirSaveClick(Sender: TObject);
begin
    end;

procedure TFormDataFormatAdvanced.CheckBoxAddClick(Sender: TObject);
begin
    fl_ofs:=CheckBoxAdd.checked;
    EditOffsetHeader.Enabled:=fl_ofs;
    EditOffsetX.Enabled:=fl_ofs;
    EditOffsetY.Enabled:=fl_ofs;
    ButtonOffsetFile.enabled:=fl_ofs;
    end;

procedure TFormDataFormatAdvanced.CheckBoxMultiplyClick(Sender: TObject);
begin
    fl_scale:=CheckBoxMultiply.checked;
    EditScaleHeader.Enabled:=fl_scale;
    EditScaleX.Enabled:=fl_scale;
    EditScaleY.Enabled:=fl_scale;
    ButtonScaleFile.enabled:=fl_scale;
    end;

procedure TFormDataFormatAdvanced.EditOffsetXChange(Sender: TObject);
begin
    val(EditOffsetX.Text, input, error);
    if error=0 then Xcol_ofs:=round(input);
    end;

procedure TFormDataFormatAdvanced.EditOffsetYChange(Sender: TObject);
begin
    val(EditOffsetY.Text, input, error);
    if error=0 then Ycol_ofs:=round(input);
    end;

end.


