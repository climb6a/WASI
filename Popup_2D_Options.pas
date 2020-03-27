unit Popup_2D_Options;

{$MODE Delphi}

{ Version vom 10.2.2020 }

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, SCHOEN_, ExtCtrls;

type

  { TOptions_2D }

  TOptions_2D = class(TForm)
    ButtonOK: TButton;
    ButtonCancel: TButton;
    Label_Width: TLabel;
    Label_Height: TLabel;
    Label_Channels: TLabel;
    Edit_Width: TEdit;
    Edit_Height: TEdit;
    Edit_Channels: TEdit;
    Label_Header: TLabel;
    Label_Interleave: TLabel;
    Edit_B: TEdit;
    Edit_G: TEdit;
    Edit_R: TEdit;                         
    Label_R: TLabel;
    Label_G: TLabel;
    LabelB: TLabel;
    GroupBox_HSI: TGroupBox;
    GroupBox_Preview: TGroupBox;
    ComboBox_interleave: TComboBox;
    Label_Contrast: TLabel;
    Edit_Contrast: TEdit;
    ComboBox_DataType: TComboBox;
    Label_DataType: TLabel;
    CheckBox_JoinBands: TCheckBox;
    Edit_Header: TEdit;
    CheckBox_ENVI: TCheckBox;
    Label_y_scale: TLabel;
    Edit_yscale: TEdit;
    GroupBox_Mask: TGroupBox;
    Label_Land_channel: TLabel;
    Edit_Land_channel: TEdit;
    Label_Thresh_above: TLabel;
    Edit_Thresh_above: TEdit;
    ColorDialogMask: TColorDialog;
    Label_Color: TLabel;
    Button_Color: TButton;
    Show_max: TEdit;
    Show_min: TEdit;
    Show_range: TLabel;
    ShapeMask: TShape;
    GroupBox1: TGroupBox;
    ComboPrv: TComboBox;
    Prv_Min: TEdit;
    Prv_Max: TEdit;
    Label_Prv_Par: TLabel;
    Prv_Par_Min: TLabel;
    Prv_Par_Max: TLabel;
    Label_x_scale: TLabel;
    Edit_xscale: TEdit;
    Edit_LUT: TEdit;
    Button_LUT: TButton;
    OpenDialog_LUT: TOpenDialog;
    CheckBox_3bands: TCheckBox;
    CheckBox_LUT: TCheckBox;
    Label_Thresh_below: TLabel;
    Edit_Thresh_below: TEdit;
    Label_updt: TLabel;
    Edit_updt: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure ShapeMaskChangeBounds(Sender: TObject);
    procedure Show_maxChange(Sender: TObject);
    procedure Show_minChange(Sender: TObject);
    procedure update_parameters(Sender: TObject);
    procedure define_temp_parameters(Sender: TObject);
    procedure set_temp_parameters(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure Edit_WidthChange(Sender: TObject);
    procedure Edit_HeightChange(Sender: TObject);
    procedure Edit_ChannelsChange(Sender: TObject);
    procedure Edit_RChange(Sender: TObject);
    procedure Edit_GChange(Sender: TObject);
    procedure Edit_BChange(Sender: TObject);
    procedure ComboBox_interleaveChange(Sender: TObject);
    procedure Edit_ContrastChange(Sender: TObject);
    procedure ComboBox_DataTypeChange(Sender: TObject);
    procedure CheckBox_JoinBandsClick(Sender: TObject);
    procedure Edit_HeaderChange(Sender: TObject);
    procedure CheckBox_ENVIClick(Sender: TObject);
    procedure Edit_yscaleChange(Sender: TObject);
    procedure Edit_Thresh_aboveChange(Sender: TObject);
    procedure Edit_Land_channelChange(Sender: TObject);
    procedure Button_ColorClick(Sender: TObject);
    procedure ComboPrvChange(Sender: TObject);
    procedure Prv_MinChange(Sender: TObject);
    procedure Prv_MaxChange(Sender: TObject);
    procedure Edit_xscaleChange(Sender: TObject);
    procedure Button_LUTClick(Sender: TObject);
    procedure CheckBox_3bandsClick(Sender: TObject);
    procedure CheckBox_LUTClick(Sender: TObject);
    procedure Edit_Thresh_belowChange(Sender: TObject);
    procedure Edit_updtChange(Sender: TObject);
  private
    input_single  : single;
    input_integer : integer;
    error         : integer;
  public
    { Public-Deklarationen }
  end;

var   Options_2D  : TOptions_2D;


implementation

uses  defaults, misc;

var   tWidth_in      : integer;
      tHeight_in     : integer;
      tChannels_in   : integer;
      tHeader        : integer;
      tband_R        : integer;
      tband_G        : integer;
      tband_B        : integer;
      tInterleave_in : byte;
      tDatentyp      : byte;
      tContrast      : single;
      tJoinBands     : boolean;
      t3Bands        : boolean;
      tLUT           : boolean;
      tENVIHeader    : boolean;
      tx_scale       : single;
      ty_scale       : single;
      tMask_ch_land  : integer;
      tThresh_above  : single;
      tThresh_below  : single;
      tPlot2D_delta  : integer;

{$R *.lfm}


procedure TOptions_2D.define_temp_parameters(Sender: TObject);
begin
    tWidth_in     := Width_in;
    tHeight_in    := Height_in;
    tChannels_in  := Channels_in;
    tHeader       := HSI_header;
    tband_B       := band_B;
    if flag_3bands then tband_G:=band_G else tband_G:=band_B;
    if flag_3bands then tband_R:=band_R else tband_R:=band_B;
    tInterleave_in := interleave_in;
    tDatentyp     := Datentyp;
    tContrast     := contrast;
    tJoinBands    := flag_JoinBands;
    t3Bands       := flag_3bands;
    tLUT          := flag_LUT;
    tENVIHeader   := flag_ENVI;
    tx_scale      := x_scale;
    ty_scale      := y_scale;
    tMask_ch_land := band_mask;
    tThresh_above := thresh_above;
    tThresh_below := thresh_below;
    tPlot2D_delta := Plot2D_delta;
    end;

procedure TOptions_2D.set_temp_parameters(Sender: TObject);
begin
    if flag_preview then flag_update_prv:=TRUE;
    if Width_in<>tWidth_in       then flag_update_prv:=FALSE;
    if Height_in<>tHeight_in     then flag_update_prv:=FALSE;
    if Channels_in<>tChannels_in then flag_update_prv:=FALSE;
    if HSI_header<>tHeader       then flag_update_prv:=FALSE;
(*    if band_R<>tband_R           then flag_update_prv:=FALSE;
    if band_G<>tband_G           then flag_update_prv:=FALSE;
    if band_B<>tband_B           then flag_update_prv:=FALSE;   *)
    Width_in      := tWidth_in;
    Height_in     := tHeight_in;
    Channels_in   := tChannels_in;
    HSI_header    := tHeader;
    band_R        := tband_R;
    band_G        := tband_G;
    band_B        := tband_B;
    interleave_in := tInterleave_in;
    Datentyp      := tDatentyp;
    contrast      := tContrast;
    flag_JoinBands := tJoinBands;
    flag_3Bands   := t3Bands;
    flag_LUT      := tLUT;
    flag_ENVI     := tENVIHeader;
    x_scale       := tx_scale;
    y_scale       := ty_scale;
    band_mask     := tMask_ch_land;
    thresh_above  := tThresh_above;
    thresh_below  := tThresh_below;
    Plot2D_delta  := tPlot2D_delta;
    end;

procedure TOptions_2D.FormCreate(Sender: TObject);
var i : integer;
begin
    for i:=1 to M1 do ComboPrv.items[i-1]:=par.name[i];
    if flag_public then ComboBox_DataType.Items.delete(5); { ASCII text }
    ShapeMask.Brush.color:=clMaskImg;
    define_temp_parameters(Sender);
    update_parameters(Sender);
    end;

procedure TOptions_2D.ShapeMaskChangeBounds(Sender: TObject);
begin

end;

procedure TOptions_2D.Show_maxChange(Sender: TObject);
begin
    val(Show_Max.Text, input_single, error);
    if error=0 then Par0_Max:=input_single;
    end;


procedure TOptions_2D.Show_minChange(Sender: TObject);
begin
    val(Show_min.Text, input_single, error);
    if error=0 then Par0_Min:=input_single;
    end;

procedure TOptions_2D.update_parameters(Sender: TObject);
begin
    if t3bands then tband_G:=band_G else tband_G:=band_B;
    if t3bands then tband_R:=band_R else tband_R:=band_B;
    ComboPrv.ItemIndex  := Par0_Type-1;
    Prv_Min.Text        := schoen(Par0_Min, 2);
    Prv_Max.Text        := schoen(Par0_Max, 2);
    Show_Min.Text       := schoen(Par0_Min, 2);
    Show_Max.Text       := schoen(Par0_Max, 2);
    Edit_Width.Text     := IntToStr(tWidth_in);
    Edit_Height.Text    := IntToStr(tHeight_in);
    Edit_Channels.Text  := IntToStr(tChannels_in);
    Edit_Header.Text    := IntToStr(tHeader);
    Edit_R.Text         := IntToStr(tband_R);
    Edit_G.Text         := IntToStr(tband_G);
    Edit_B.Text         := IntToStr(tband_B);
    Edit_xscale.Text    := schoen(x_scale, 3);
    Edit_yscale.Text    := schoen(y_scale, 3);
    Edit_LUT.Text       := ExtractFileName(file_LUT[2]);
    CheckBox_LUT.Enabled := not t3bands;
    Button_LUT.Enabled := not t3bands;
    Show_range.Enabled := not t3bands;
    Show_min.Enabled   := not t3bands;
    Show_max.Enabled   := not t3bands;
    Edit_G.Enabled     := t3bands;
    Edit_R.Enabled     := t3bands;
    CheckBox_JoinBands.Enabled := t3bands;
    ComboBox_interleave.ItemIndex:=tInterleave_in;
    if tDatentyp<=4 then
        ComboBox_DataType.ItemIndex:=tDatentyp-1 { Zählung beginnt bei 0 }
    else if tDatentyp=7 then ComboBox_DataType.ItemIndex:=5 { data type 7: text }
    else ComboBox_DataType.ItemIndex:=4; { data type 12: 16-bit unsigned integer }
    Edit_Contrast.Text := schoen(tContrast, 3);
    CheckBox_JoinBands.checked := tJoinBands;
    CheckBox_3bands.Checked    := t3bands;
    CheckBox_LUT.Checked       := tLUT;
    CheckBox_ENVI.Checked      := tENVIHeader;
    Edit_Land_channel.Text     := IntToStr(tMask_ch_land);
    Edit_Thresh_above.Text     := schoen(tThresh_above, 2);
    Edit_Thresh_below.Text     := schoen(tThresh_below, 2);
    Edit_updt.Text             := IntToStr(tPlot2D_delta);
    end;

procedure TOptions_2D.ButtonOKClick(Sender: TObject);
begin
    ModalResult := mrOK;
    end;

procedure TOptions_2D.ButtonCancelClick(Sender: TObject);
begin
    Close;
    end;

procedure TOptions_2D.Edit_WidthChange(Sender: TObject);
begin
    val(Edit_Width.Text, input_integer, error);
    if error=0 then tWidth_in:=input_integer;
    end;

procedure TOptions_2D.Edit_HeightChange(Sender: TObject);
begin
    val(Edit_Height.Text, input_integer, error);
    if error=0 then tHeight_in:=input_integer;
    end;

procedure TOptions_2D.Edit_ChannelsChange(Sender: TObject);
begin
    val(Edit_Channels.Text, input_integer, error);
    if error=0 then tChannels_in:=input_integer;
    end;


procedure TOptions_2D.Edit_RChange(Sender: TObject);
begin
    val(Edit_R.Text, input_integer, error);
    if error=0 then tband_R:=input_integer;
    end;

procedure TOptions_2D.Edit_GChange(Sender: TObject);
begin
    val(Edit_G.Text, input_integer, error);
    if error=0 then tband_G:=input_integer;
    end;

procedure TOptions_2D.Edit_BChange(Sender: TObject);
begin
    val(Edit_B.Text, input_integer, error);
    if error=0 then tband_B:=input_integer;
    end;

procedure TOptions_2D.ComboBox_interleaveChange(Sender: TObject);
begin
    tInterleave_in:=ComboBox_interleave.ItemIndex;
    end;

procedure TOptions_2D.Edit_ContrastChange(Sender: TObject);
begin
    val(Edit_Contrast.Text, input_single, error);
    if error=0 then tContrast:=input_single;
    end;

procedure TOptions_2D.ComboBox_DataTypeChange(Sender: TObject);
begin
    tDatentyp:=ComboBox_DataType.ItemIndex+1;
    if tDatentyp=5 then tDatentyp:=12;    // 16-bit unsigned integer
    if tDatentyp=6 then begin             // text
        tDatentyp:=7;
        tENVIHeader:=FALSE;
        end;
    end;

procedure TOptions_2D.CheckBox_JoinBandsClick(Sender: TObject);
begin
    tJoinBands:=CheckBox_JoinBands.checked;
    end;

procedure TOptions_2D.Edit_HeaderChange(Sender: TObject);
begin
    val(Edit_Header.Text, input_integer, error);
    if error=0 then tHeader:=input_integer;
    end;

procedure TOptions_2D.CheckBox_ENVIClick(Sender: TObject);
begin
    tENVIHeader:=CheckBox_ENVI.checked;
    end;

procedure TOptions_2D.Edit_xscaleChange(Sender: TObject);
begin
    val(Edit_xscale.Text, input_single, error);
    if error=0 then if input_single>nenner_min then tx_scale:=input_single;
    end;

procedure TOptions_2D.Edit_yscaleChange(Sender: TObject);
begin
    val(Edit_yscale.Text, input_single, error);
    if error=0 then if input_single>nenner_min then ty_scale:=input_single;
    end;

procedure TOptions_2D.Edit_Land_channelChange(Sender: TObject);
begin
    val(Edit_Land_channel.Text, input_integer, error);
    if error=0 then tMask_ch_land:=input_integer;
    end;

procedure TOptions_2D.Edit_Thresh_aboveChange(Sender: TObject);
begin
    val(Edit_Thresh_above.Text, input_single, error);
    if error=0 then tThresh_above:=input_single;
    end;

procedure TOptions_2D.Button_ColorClick(Sender: TObject);
begin
    ColorDialogMask.color:=ClMaskImg;
    //ColorDialogMask.options:=[cdFullOpen];
    if ColorDialogMask.Execute then begin
        clMaskImg:=ColorDialogMask.Color;
        ShapeMask.Brush.Color:=ClMaskImg;
        ShapeMask.Repaint;
        end;
    end;

procedure TOptions_2D.ComboPrvChange(Sender: TObject);
begin
    Par0_Type:=ComboPrv.ItemIndex+1;
    end;

procedure TOptions_2D.Prv_MinChange(Sender: TObject);
begin
    val(Prv_Min.Text, input_single, error);
    if error=0 then Par0_Min:=input_single;
    end;

procedure TOptions_2D.Prv_MaxChange(Sender: TObject);
begin
    val(Prv_Max.Text, input_single, error);
    if error=0 then Par0_Max:=input_single;
    end;

procedure TOptions_2D.Button_LUTClick(Sender: TObject);
begin
    OpenDialog_LUT.Title := 'Load LUT';
    OpenDialog_LUT.FileName:=file_LUT[2];
    OpenDialog_LUT.InitialDir:=ExtractFilePath(file_LUT[2])+'\';
    OpenDialog_LUT.Filter:='*.lut|*.lut'+'|all files (*.*)|*.*|';
    if OpenDialog_LUT.Execute then begin
        file_LUT[2]:=OpenDialog_LUT.FileName;
        Edit_LUT.Text:= ExtractFileName(file_LUT[2]);
        import_LUT(2);
        end;
    end;


procedure TOptions_2D.CheckBox_3bandsClick(Sender: TObject);
begin
    t3bands:=CheckBox_3bands.checked;
    update_parameters(Sender);
    end;

procedure TOptions_2D.CheckBox_LUTClick(Sender: TObject);
begin
    tLUT:=CheckBox_LUT.checked;
    end;


procedure TOptions_2D.Edit_Thresh_belowChange(Sender: TObject);
begin
    val(Edit_Thresh_below.Text, input_single, error);
    if error=0 then tThresh_below:=input_single;
    end;

procedure TOptions_2D.Edit_updtChange(Sender: TObject);
begin
    val(Edit_updt.Text, input_integer, error);
    if error=0 then tPlot2D_delta:=input_integer;
    end;

end.


