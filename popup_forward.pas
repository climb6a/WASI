unit popup_forward;

{$MODE Delphi}

{ Version vom 7.2.2020 }

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type

  { TFormData }

  TFormData = class(TForm)
    ButtonCancel: TButton;
    ButtonOK: TButton;
    GroupBox2: TGroupBox;
    CheckSvFw: TCheckBox;
    CheckSvTable: TCheckBox;
    GroupBoxNoise: TGroupBox;
    Check_Noise: TCheckBox;
    Check_Radiom: TCheckBox;
    EditRadiom: TEdit;
    EditNoise: TEdit;
    TextStdDev: TStaticText;
    Radio_noise_constant: TRadioButton;
    Radio_noise_from_file: TRadioButton;
    Edit_noise_file: TEdit;
    Button_set_noisefile: TButton;
    Text_noisefile: TStaticText;
    Edit_Header_noisefile: TEdit;
    Edit_X_noisefile: TEdit;
    Edit_Y_noisefile: TEdit;
    OpenDialog1: TOpenDialog;
    Check_offset: TCheckBox;
    Radio_offset_constant: TRadioButton;
    Text_offset: TStaticText;
    Edit_offset: TEdit;
    Radio_offset_from_file: TRadioButton;
    Edit_offset_file: TEdit;
    Button_set_offsetfile: TButton;
    Edit_Header_offsetfile: TEdit;
    Text_offsetfile: TStaticText;
    Edit_X_offsetfile: TEdit;
    Edit_Y_offsetfile: TEdit;
    Group_noise: TGroupBox;
    Group_offset: TGroupBox;
    Group_scale: TGroupBox;
    Radio_scale_constant: TRadioButton;
    Text_scale: TStaticText;
    Edit_scale: TEdit;
    Radio_scale_from_file: TRadioButton;
    Edit_scale_file: TEdit;
    Button_set_scalefile: TButton;
    Text_scalefile: TStaticText;
    Edit_Header_scalefile: TEdit;
    Edit_X_scalefile: TEdit;
    Edit_Y_scalefile: TEdit;
    Check_scale: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure Group_offsetClick(Sender: TObject);
    procedure Update_OffsetDialog(Sender: TObject);
    procedure Update_ScaleDialog(Sender: TObject);
    procedure Update_NoiseDialog(Sender: TObject);
    procedure set_temp_parameters(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure CheckSvFwClick(Sender: TObject);
    procedure CheckSvTableClick(Sender: TObject);
    procedure Check_NoiseClick(Sender: TObject);
    procedure Check_RadiomClick(Sender: TObject);
    procedure EditNoiseChange(Sender: TObject);
    procedure EditRadiomChange(Sender: TObject);
    procedure Radio_noise_constantClick(Sender: TObject);
    procedure Radio_noise_from_fileClick(Sender: TObject);
    procedure Button_set_noisefileClick(Sender: TObject);
    procedure Edit_Header_noisefileChange(Sender: TObject);
    procedure Edit_X_noisefileChange(Sender: TObject);
    procedure Edit_Y_noisefileChange(Sender: TObject);
    procedure Check_offsetClick(Sender: TObject);
    procedure Radio_offset_constantClick(Sender: TObject);
    procedure Edit_offsetChange(Sender: TObject);
    procedure Radio_offset_from_fileClick(Sender: TObject);
    procedure Edit_Header_offsetfileChange(Sender: TObject);
    procedure Edit_X_offsetfileChange(Sender: TObject);
    procedure Edit_Y_offsetfileChange(Sender: TObject);
    procedure Button_set_offsetfileClick(Sender: TObject);
    procedure Check_scaleClick(Sender: TObject);
    procedure Button_set_scalefileClick(Sender: TObject);
    procedure Radio_scale_constantClick(Sender: TObject);
    procedure Edit_scaleChange(Sender: TObject);
    procedure Radio_scale_from_fileClick(Sender: TObject);
    procedure Edit_Header_scalefileChange(Sender: TObject);
    procedure Edit_X_scalefileChange(Sender: TObject);
    procedure Edit_Y_scalefileChange(Sender: TObject);
  private
    input          : single;
    error          : integer;
    fl_b_SaveFwd   : boolean;
    fl_sv_table    : boolean;
    fl_surf        : boolean;
    fl_radiom      : boolean;
    fl_offset      : boolean;
    fl_offset_c    : boolean;
    fl_scale       : boolean;
    fl_scale_c     : boolean;
    fl_noise       : boolean;
    fl_noise_c     : boolean;
    tbottom_fill   : shortInt;
    t_ofs          : double;
    t_scale        : double;
    t_noise        : double;
    t_dynamics     : double;
  public
    Header_noise   : word;
    Xcol_noise     : word;
    Ycol_noise     : word;
    Header_offset  : word;
    Xcol_offset    : word;
    Ycol_offset    : word;
    Header_scale   : word;
    Xcol_scale     : word;
    Ycol_scale     : word;
    t_Name_offset  : String;
    t_Name_scale   : String;
    t_Name_noise   : String;
  end;

var
  FormData: TFormData;

implementation

uses defaults, misc, SCHOEN_;

{$R *.lfm}

procedure TFormData.Update_OffsetDialog(Sender: TObject);
begin
    Text_offset.enabled:=fl_offset and fl_offset_c;
    Edit_offset.enabled:=fl_offset and fl_offset_c;
    Radio_offset_constant.enabled:=fl_offset;
    Radio_offset_from_file.enabled:=fl_offset;
    //Edit_offset_file.enabled:=fl_offset and not fl_offset_c;
    Button_set_offsetfile.enabled:=fl_offset and not fl_offset_c;
    Text_offsetfile.enabled:=fl_offset and not fl_offset_c;
    Edit_Header_offsetfile.enabled:=fl_offset and not fl_offset_c;
    Edit_X_offsetfile.enabled:=fl_offset and not fl_offset_c;
    Edit_Y_offsetfile.enabled:=fl_offset and not fl_offset_c;
    end;

procedure TFormData.Update_ScaleDialog(Sender: TObject);
begin
    Text_scale.enabled:=fl_scale and fl_scale_c;
    Edit_scale.enabled:=fl_scale and fl_scale_c;
    Radio_scale_constant.enabled:=fl_scale;
    Radio_scale_from_file.enabled:=fl_scale;
    //Edit_scale_file.enabled:=fl_scale and not fl_scale_c;
    Button_set_scalefile.enabled:=fl_scale and not fl_scale_c;
    Text_scalefile.enabled:=fl_scale and not fl_scale_c;
    Edit_Header_scalefile.enabled:=fl_scale and not fl_scale_c;
    Edit_X_scalefile.enabled:=fl_scale and not fl_scale_c;
    Edit_Y_scalefile.enabled:=fl_scale and not fl_scale_c;
    end;

procedure TFormData.Update_NoiseDialog(Sender: TObject);
begin
    TextStdDev.enabled:=fl_noise and fl_noise_c;
    EditNoise.enabled:=fl_noise and fl_noise_c;
    Radio_noise_constant.enabled:=fl_noise;
    Radio_noise_from_file.enabled:=fl_noise;
    //Edit_noise_file.enabled:=fl_noise and not fl_noise_c;
    Button_set_noisefile.enabled:=fl_noise and not fl_noise_c;
    Text_noisefile.enabled:=fl_noise and not fl_noise_c;
    Edit_Header_noisefile.enabled:=fl_noise and not fl_noise_c;
    Edit_X_noisefile.enabled:=fl_noise and not fl_noise_c;
    Edit_Y_noisefile.enabled:=fl_noise and not fl_noise_c;
    end;

procedure TFormData.FormCreate(Sender: TObject);
var S : shortString;
begin
    t_Name_offset  :=offsetS^.FName;
    Header_offset  :=offsetS^.Header;
    Xcol_offset    :=offsetS^.XColumn;
    Ycol_offset    :=offsetS^.YColumn;
    t_Name_scale   :=scaleS^.FName;
    Header_scale   :=scaleS^.Header;
    Xcol_scale     :=scaleS^.XColumn;
    Ycol_scale     :=scaleS^.YColumn;
    t_Name_noise   :=noiseS^.FName;
    Header_noise   :=noiseS^.Header;
    Xcol_noise     :=noiseS^.XColumn;
    Ycol_noise     :=noiseS^.YColumn;
    fl_surf        :=flag_surf_fw;
    fl_b_SaveFwd   :=flag_b_SaveFwd;
    fl_sv_table    :=flag_sv_table;
    fl_radiom      :=flag_radiom;
    fl_offset      :=flag_offset;
    fl_offset_c    :=flag_offset_c;
    fl_scale       :=flag_scale;
    fl_scale_c     :=flag_scale_c;
    fl_noise       :=flag_noise;
    fl_noise_c     :=flag_noise_c;
    tbottom_fill   :=bottom_fill;
    t_ofs          :=offset_c;
    t_scale        :=scale_c;
    t_noise        :=noise_std;
    t_dynamics     :=dynamics;
    Edit_Offset.Text :=schoen(t_ofs, 2);
    Edit_Scale.Text  :=schoen(t_scale, 2);
    EditNoise.Text :=schoen(t_noise, 2);
    EditRadiom.Text:=schoen(t_dynamics, 2);
    Edit_offset_file.Text:=t_Name_offset;
    Edit_scale_file.Text:=t_Name_scale;
    str(Header_offset, S); Edit_Header_offsetfile.Text:=S;
    str(Xcol_offset, S);   Edit_X_offsetfile.Text:=S;
    str(Ycol_offset, S);   Edit_Y_offsetfile.Text:=S;
    str(Header_scale, S);  Edit_Header_scalefile.Text:=S;
    str(Xcol_scale, S);    Edit_X_scalefile.Text:=S;
    str(Ycol_scale, S);    Edit_Y_scalefile.Text:=S;
    Edit_noise_file.Text:=t_Name_noise;
    str(Header_noise, S); Edit_Header_noisefile.Text:=S;
    str(Xcol_noise, S);   Edit_X_noisefile.Text:=S;
    str(Ycol_noise, S);   Edit_Y_noisefile.Text:=S;
    CheckSvFw.checked:=fl_b_SaveFwd;
    CheckSvTable.Caption:='if N < ' + IntToStr(MaxSpectra+1) +
                          ', save all spectra in a single table';
    CheckSvTable.checked:=fl_sv_table;
    Check_Offset.checked:=fl_offset;
    Check_Scale.checked:=fl_scale;
    Check_Noise.checked:=fl_noise;
    Radio_offset_constant.checked:=fl_offset_c;
    Radio_offset_from_file.checked:=not fl_offset_c;
    Radio_scale_constant.checked:=fl_scale_c;
    Radio_scale_from_file.checked:=not fl_scale_c;
    Radio_noise_constant.checked:=fl_noise_c;
    Radio_noise_from_file.checked:=not fl_noise_c;
    Check_Radiom.checked:=fl_radiom;
    EditRadiom.enabled:=fl_radiom;
    Update_NoiseDialog(Sender);
    Update_OffsetDialog(Sender);
    Update_ScaleDialog(Sender);
    end;

procedure TFormData.Group_offsetClick(Sender: TObject);
begin

end;

procedure TFormData.set_temp_parameters(Sender: TObject);
{ Copy temporary parameter set to the valid parameter set. }
var flag_import : boolean;
begin
    flag_b_SaveFwd  := FormData.fl_b_SaveFwd;
    flag_sv_table   := FormData.fl_sv_Table;
    flag_surf_fw    := FormData.fl_surf;
    bottom_fill     := FormData.tbottom_fill;
    flag_offset     := fl_offset;
    flag_offset_c   := fl_offset_c;
    flag_scale      := fl_scale;
    flag_scale_c    := fl_scale_c;
    flag_noise      := fl_noise;
    flag_noise_c    := fl_noise_c;
    flag_radiom     := fl_radiom;
    offset_c        := t_ofs;
    scale_c         := t_scale;
    noise_std       := t_noise;
    dynamics        := t_dynamics;

    flag_import:=noiseS^.FName<>t_Name_noise;
    noiseS^.FName    := t_Name_noise;
    noiseS^.Header   := Header_noise;
    noiseS^.XColumn  := Xcol_noise;
    noiseS^.YColumn  := Ycol_noise;
    if flag_import then import_spectrum(noiseS^);

    flag_import:=offsetS^.FName<>t_Name_offset;
    offsetS^.FName   := t_Name_offset;
    offsetS^.Header  := Header_offset;
    offsetS^.XColumn := Xcol_offset;
    offsetS.YColumn  := Ycol_offset;
    if flag_import then import_spectrum(offsetS^);

    flag_import:=scaleS^.FName<>t_Name_scale;
    scaleS^.FName   := t_Name_scale;
    scaleS^.Header  := Header_scale;
    scaleS^.XColumn := Xcol_scale;
    scaleS.YColumn  := Ycol_scale;
    if flag_import then import_spectrum(scaleS^);
    end;


procedure TFormData.ButtonCancelClick(Sender: TObject);
begin
    Close;
    end;

procedure TFormData.ButtonOKClick(Sender: TObject);
begin
    ModalResult := mrOK;
    end;

procedure TFormData.CheckSvFwClick(Sender: TObject);
begin
    fl_b_SaveFwd:=CheckSvFw.checked;
    end;

procedure TFormData.CheckSvTableClick(Sender: TObject);
begin
    fl_sv_Table:=CheckSvTable.checked;
    end;

procedure TFormData.Check_NoiseClick(Sender: TObject);
begin
    fl_noise:=Check_Noise.checked;
    Update_NoiseDialog(Sender);
    end;

procedure TFormData.Check_RadiomClick(Sender: TObject);
begin
    fl_radiom:=Check_Radiom.checked;
    EditRadiom.enabled:=fl_radiom;
    end;

procedure TFormData.Check_scaleClick(Sender: TObject);
begin
    fl_scale:=Check_scale.checked;
    Update_ScaleDialog(Sender);
    end;

procedure TFormData.EditNoiseChange(Sender: TObject);
begin
    val(EditNoise.Text, input, error);
    if error=0 then t_noise:=input;
    end;

procedure TFormData.EditRadiomChange(Sender: TObject);
begin
    val(EditRadiom.Text, input, error);
    if error=0 then t_dynamics:=input;
    if t_dynamics<nenner_min then t_dynamics:=nenner_min;
    end;

procedure TFormData.Radio_noise_constantClick(Sender: TObject);
begin
    fl_noise_c:=Radio_noise_constant.checked;
    Update_NoiseDialog(Sender);
    end;

procedure TFormData.Radio_noise_from_fileClick(Sender: TObject);
begin
    fl_noise_c:=not Radio_noise_from_file.checked;
    Update_NoiseDialog(Sender);
    end;

procedure TFormData.Button_set_noisefileClick(Sender: TObject);
var old_extension : ShortString;
begin
    old_extension:='*'+ExtractFileExt(noiseS^.FName);
    OpenDialog1.FileName:=noiseS^.FName;
    OpenDialog1.Title := 'Load noise file';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';
    if OpenDialog1.Execute then
        t_Name_noise:=OpenDialog1.FileName;
    Edit_noise_file.text:=t_Name_noise;
    Edit_noise_file.refresh;
    end;

procedure TFormData.Edit_Header_noisefileChange(Sender: TObject);
begin
    val(Edit_Header_noisefile.Text, input, error);
    if error=0 then Header_noise:=round(input);
    end;

procedure TFormData.Edit_X_noisefileChange(Sender: TObject);
begin
    val(Edit_X_noisefile.Text, input, error);
    if error=0 then Xcol_noise:=round(input);
    end;

procedure TFormData.Edit_Y_noisefileChange(Sender: TObject);
begin
    val(Edit_Y_noisefile.Text, input, error);
    if error=0 then Ycol_noise:=round(input);
    end;

procedure TFormData.Check_offsetClick(Sender: TObject);
begin
    fl_offset:=Check_offset.checked;
    Update_OffsetDialog(Sender);
    end;

procedure TFormData.Radio_offset_constantClick(Sender: TObject);
begin
    fl_offset_c:=Radio_offset_constant.checked;
    Update_OffsetDialog(Sender);
    end;

procedure TFormData.Edit_offsetChange(Sender: TObject);
begin
    val(Edit_Offset.Text, input, error);
    if error=0 then t_ofs:=input;
    end;

procedure TFormData.Edit_scaleChange(Sender: TObject);
begin
    val(Edit_scale.Text, input, error);
    if error=0 then t_scale:=input;
    end;

procedure TFormData.Radio_offset_from_fileClick(Sender: TObject);
begin
    fl_offset_c:=not Radio_offset_from_file.checked;
    Update_OffsetDialog(Sender);
    end;

procedure TFormData.Radio_scale_constantClick(Sender: TObject);
begin
    fl_scale_c:=Radio_scale_constant.checked;
    Update_ScaleDialog(Sender);
    end;

procedure TFormData.Radio_scale_from_fileClick(Sender: TObject);
begin
    fl_scale_c:=not Radio_scale_from_file.checked;
    Update_ScaleDialog(Sender);
    end;

procedure TFormData.Edit_Header_offsetfileChange(Sender: TObject);
begin
    val(Edit_Header_offsetfile.Text, input, error);
    if error=0 then Header_offset:=round(input);
    end;

procedure TFormData.Edit_Header_scalefileChange(Sender: TObject);
begin
    val(Edit_Header_scalefile.Text, input, error);
    if error=0 then Header_scale:=round(input);
    end;

procedure TFormData.Edit_X_offsetfileChange(Sender: TObject);
begin
    val(Edit_X_offsetfile.Text, input, error);
    if error=0 then Xcol_offset:=round(input);
    end;

procedure TFormData.Edit_X_scalefileChange(Sender: TObject);
begin
    val(Edit_X_scalefile.Text, input, error);
    if error=0 then Xcol_scale:=round(input);
    end;

procedure TFormData.Edit_Y_offsetfileChange(Sender: TObject);
begin
    val(Edit_Y_offsetfile.Text, input, error);
    if error=0 then Ycol_offset:=round(input);
    end;

procedure TFormData.Edit_Y_scalefileChange(Sender: TObject);
begin
    val(Edit_Y_scalefile.Text, input, error);
    if error=0 then Ycol_scale:=round(input);
    end;

procedure TFormData.Button_set_offsetfileClick(Sender: TObject);
var old_extension : ShortString;
begin
    old_extension:='*'+ExtractFileExt(offsetS^.FName);
    OpenDialog1.FileName:=offsetS^.FName;
    OpenDialog1.Title := 'Load offset file';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';
    if OpenDialog1.Execute then
        t_Name_offset:=OpenDialog1.FileName;
    Edit_offset_file.text:=t_Name_offset;
    Edit_offset_file.refresh;
    end;

procedure TFormData.Button_set_scalefileClick(Sender: TObject);
var old_extension : ShortString;
begin
    old_extension:='*'+ExtractFileExt(scaleS^.FName);
    OpenDialog1.FileName:=scaleS^.FName;
    OpenDialog1.Title := 'Load scale file';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';
    if OpenDialog1.Execute then
        t_Name_scale:=OpenDialog1.FileName;
    Edit_scale_file.text:=t_Name_scale;
    Edit_scale_file.refresh;
    end;

end.
