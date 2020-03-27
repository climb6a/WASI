unit Popup_Display;

{$MODE Delphi}

{ Version vom 7.2.2020 }

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, defaults, ExtCtrls;

type
  TFormDisplay = class(TForm)
    Edit_xmin: TEdit;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    Edit_xmax: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit_ymin: TEdit;
    Edit_ymax: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    CheckBoxGrid: TCheckBox;
    CheckBoxSubgrid: TCheckBox;
    CheckBoxAutoscale: TCheckBox;
    CheckBoxPath: TCheckBox;
    CheckBoxFileName: TCheckBox;
    ColorDialogBk: TColorDialog;
    ShapeBk: TShape;
    StaticText1: TStaticText;
    ButtonBk: TButton;
    CheckBoxDots: TCheckBox;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    EditNmax: TEdit;
    EditDotSize: TEdit;
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure Edit_xminChange(Sender: TObject);
    procedure Edit_xmaxChange(Sender: TObject);
    procedure Edit_yminChange(Sender: TObject);
    procedure Edit_ymaxChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBoxGridClick(Sender: TObject);
    procedure CheckBoxSubgridClick(Sender: TObject);
    procedure CheckBoxAutoscaleClick(Sender: TObject);
    procedure CheckBoxPathClick(Sender: TObject);
    procedure CheckBoxFileNameClick(Sender: TObject);
    procedure ButtonBkClick(Sender: TObject);
    procedure YGray(Sender: TObject);
    procedure CheckBoxDotsClick(Sender: TObject);
    procedure EditNmaxChange(Sender: TObject);
    procedure EditDotSizeChange(Sender: TObject);
  private
    input : single;
    error : integer;
  public
    xxu, xxo : single;
    tdotsize : word;
    tdotMaxN : word;
    yyu, yyo : single;
    fl_grid  : boolean;
    fl_dots  : boolean;
    fl_subgrid : boolean;
    fl_autoscale : boolean;
    fl_ShowFilename : boolean;
    fl_path      : boolean;
  end;

var
  FormDisplay: TFormDisplay;

implementation

uses SCHOEN_;
{$R *.lfm}

procedure TFormDisplay.ButtonOKClick(Sender: TObject);
begin
    ModalResult := mrOK;
end;

procedure TFormDisplay.ButtonCancelClick(Sender: TObject);
begin
    ModalResult := mrCancel;
    end;

procedure TFormDisplay.Edit_xminChange(Sender: TObject);
begin
    val(Edit_xmin.Text, input, error);
    if error=0 then xxu:=input;
    if xxu<MinX then xxu:=MinX;
    end;

procedure TFormDisplay.Edit_xmaxChange(Sender: TObject);
begin
    val(Edit_xmax.Text, input, error);
    if error=0 then xxo:=input;
    if xxo>MaxX then xxo:=MaxX;
    end;

procedure TFormDisplay.Edit_yminChange(Sender: TObject);
begin
    val(Edit_ymin.Text, input, error);
    if error=0 then yyu:=input;
    if yyu<MinY then yyu:=MinY;
    end;

procedure TFormDisplay.Edit_ymaxChange(Sender: TObject);
begin
    val(Edit_ymax.Text, input, error);
    if error=0 then yyo:=input;
    if yyo>MaxY then yyo:=MaxY;
    end;


procedure TFormDisplay.FormCreate(Sender: TObject);
begin
    xxu:=xu; xxo:=xo;
    yyu:=yu; yyo:=xo;
    tdotsize:=dotsize;
    tdotMaxN:=dotMaxN;
    fl_grid:=flag_grid;
    fl_dots:=flag_dots;
    fl_subgrid:=flag_subgrid;
    fl_autoscale:=flag_autoscale;
    fl_ShowFilename:=flag_ShowFile;
    fl_path:=flag_ShowPath;
    Edit_xmin.Text:=schoen(xu, SIG);
    Edit_xmax.Text:=schoen(xo, SIG);
    Edit_ymin.Text:=schoen(yu, SIG);
    Edit_ymax.Text:=schoen(yo, SIG);
    EditDotSize.Text:=inttostr(tDotSize);
    EditNmax.Text:=inttostr(tdotMaxN);
    CheckBoxGrid.checked:=fl_grid;
    CheckBoxDots.checked:=fl_dots;
    CheckBoxSubgrid.checked:=fl_subgrid;
    CheckBoxAutoscale.checked:=fl_autoscale;
    CheckBoxFileName.checked:=fl_ShowFilename;
    CheckBoxPath.checked:=fl_path;
    ShapeBk.Brush.Color:=ClPlotBk;
    YGray(Sender);
    end;

procedure TFormDisplay.YGray(Sender: TObject);
begin
    Label3.enabled:=not fl_autoscale;
    Label4.enabled:=not fl_autoscale;
    Edit_ymin.enabled:=not fl_autoscale;
    Edit_ymax.enabled:=not fl_autoscale;
    StaticText2.enabled:=fl_dots;
    StaticText3.enabled:=fl_dots;
    EditNMax.enabled:=fl_dots;
    EditDotSize.enabled:=fl_dots;
    end;

procedure TFormDisplay.CheckBoxGridClick(Sender: TObject);
begin
    fl_grid:=CheckBoxGrid.checked;
    if fl_grid=FALSE then fl_subgrid:=FALSE;
    end;

procedure TFormDisplay.CheckBoxSubgridClick(Sender: TObject);
begin
    fl_subgrid:=CheckBoxSubGrid.checked;
    end;

procedure TFormDisplay.CheckBoxAutoscaleClick(Sender: TObject);
begin
    fl_autoscale:=CheckBoxAutoscale.checked;
    YGray(Sender);
    end;

procedure TFormDisplay.CheckBoxPathClick(Sender: TObject);
begin
    fl_path:=CheckBoxPath.checked;
    end;

procedure TFormDisplay.CheckBoxFileNameClick(Sender: TObject);
begin
    fl_ShowFilename:=CheckBoxFilename.checked;
    end;

procedure TFormDisplay.ButtonBkClick(Sender: TObject);
begin
    ColorDialogBk.color:=ClPlotBk;
    //ColorDialogBk.options:=[cdFullOpen];
    if ColorDialogBk.Execute then begin
        clPlotBk:=ColorDialogBk.Color;
        ShapeBk.Brush.Color:=ClPlotBk;
        ShapeBk.Repaint;
        end;
    end;

procedure TFormDisplay.CheckBoxDotsClick(Sender: TObject);
begin
    fl_dots:=CheckBoxDots.checked;
    YGray(Sender);
    end;

procedure TFormDisplay.EditNmaxChange(Sender: TObject);
begin
    val(EditNmax.Text, input, error);
    if error=0 then tdotMaxN:=round(input);
    end;

procedure TFormDisplay.EditDotSizeChange(Sender: TObject);
begin
    val(EditDotSize.Text, input, error);
    if error=0 then tdotsize:=round(input);
    if tdotsize>100 then tdotsize:=100;
    end;

end.
