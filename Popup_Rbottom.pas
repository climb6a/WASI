unit Popup_Rbottom;

{$MODE Delphi}

{ Version vom 10.4.2015 }

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, defaults, ExtCtrls, privates;

type

  { TFormRbottom }

  TFormRbottom = class(TForm)
    Edit_dz_Ed: TEdit;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    Edit_dz_Lu: TEdit;
    Label_dz_Ed: TLabel;
    Label_dz_Ed1: TLabel;
    Label_dz_Eu1: TLabel;
    Label_dz_Lu: TLabel;
    Edit_dz_Eu: TEdit;
    Label_dz_Eu: TLabel;
    CheckBoxCalcRbottom: TCheckBox;
    Label_dz_Lu1: TLabel;
    Text_dz: TStaticText;
    LabelInfo: TLabel;
    LabelInfoSign: TLabel;
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure Edit_dz_EdChange(Sender: TObject);
    procedure Edit_dz_LuChange(Sender: TObject);
    procedure Edit_dz_EuChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CheckBoxCalcRbottomClick(Sender: TObject);
  private
    input : double;
    error : integer;
  public
    dzEd       : double;
    dzLu       : double;
    dzEu       : double;
    fl_Rbottom : boolean;
  end;

var
  FormRbottom: TFormRbottom;

implementation

uses SCHOEN_;
{$R *.lfm}

procedure TFormRbottom.ButtonOKClick(Sender: TObject);
begin
    ModalResult := mrOK;
end;

procedure TFormRbottom.ButtonCancelClick(Sender: TObject);
begin
    ModalResult := mrCancel;
    end;

procedure TFormRbottom.Edit_dz_EdChange(Sender: TObject);
begin
    val(Edit_dz_Ed.Text, input, error);
    if error=0 then dzEd:=input;
    end;

procedure TFormRbottom.Edit_dz_LuChange(Sender: TObject);
begin
    val(Edit_dz_Lu.Text, input, error);
    if error=0 then dzLu:=input;
    end;

procedure TFormRbottom.Edit_dz_EuChange(Sender: TObject);
begin
    val(Edit_dz_Eu.Text, input, error);
    if error=0 then dzEu:=input;
    end;

procedure TFormRbottom.FormCreate(Sender: TObject);
begin
    dzEd:=dz_Ed;
    dzLu:=dz_Lu;
    dzEu:=dz_Eu;
    fl_Rbottom:=flag_Rbottom;
    Edit_dz_Ed.Text:=schoen(dz_Ed, SIG);
    Edit_dz_Eu.Text:=schoen(dz_Eu, SIG);
    Edit_dz_Lu.Text:=schoen(dz_Lu, SIG);
    CheckBoxCalcRbottom.checked:=fl_Rbottom;
    end;

procedure TFormRbottom.CheckBoxCalcRbottomClick(Sender: TObject);
begin
    fl_Rbottom:=CheckBoxCalcRbottom.checked;
    end;

end.
