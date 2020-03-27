unit Popup_General;

{$MODE Delphi}

{ Version vom 7.2.2020 }

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, SCHOEN_, defaults;

type
  TFormGeneral = class(TForm)
    CheckBoxSaveINI: TCheckBox;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    CheckBox_E_factor: TCheckBox;
    CheckBox_Rrs: TCheckBox;
    Edit_Ed_factor:  TEdit;
    Edit_Rrs_factor: TEdit;
    CheckBox_E0_factor: TCheckBox;
    Edit_E0_factor: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure CheckBoxSaveINIClick(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure Rrs_factorClick(Sender: TObject);
    procedure Edit_Ed_factorChange(Sender: TObject);
    procedure Edit_Rrs_factorChange(Sender: TObject);
    procedure CheckBox_E_factorClick(Sender: TObject);
    procedure CheckBox_E0_factorClick(Sender: TObject);
    procedure Edit_E0_factorChange(Sender: TObject);
  private
    input   : single;
    error   : integer;
  public
    fl_ini   : boolean;
    fl_Ed    : boolean;
    fl_E0    : boolean;
    fl_Rrs   : boolean;
    mult_Ed  : double;
    mult_E0  : double;
    mult_Rrs : double;
  end;

var
  FormGeneral: TFormGeneral;

implementation

{$R *.lfm}

procedure TFormGeneral.FormCreate(Sender: TObject);
begin
    if GUI_scale>1 then begin
        Height:=round(Height*GUI_scale);
        Width:=round(Width*GUI_scale);
        end;

    fl_ini :=flag_INI;
    fl_Ed  :=flag_mult_Ed;
    fl_E0  :=flag_mult_E0;
    mult_Ed:=Ed_factor;
    mult_E0:=E0_factor;
    fl_Rrs :=flag_mult_Rrs;
    mult_Rrs:=Rrs_factor;
    CheckBoxSaveINI.checked:=fl_ini;
    CheckBox_E_factor.checked:=fl_Ed;
    CheckBox_E0_factor.checked:=fl_E0;
    CheckBox_Rrs.checked:=fl_Rrs;
    Edit_Ed_factor.Text:=schoen(mult_Ed, 5);
    Edit_E0_factor.Text:=schoen(mult_E0, 5);
    Edit_Rrs_factor.Text:=schoen(mult_Rrs, 5);
    end;

procedure TFormGeneral.CheckBoxSaveINIClick(Sender: TObject);
begin
    fl_ini:=CheckBoxSaveINI.checked;
    end;

procedure TFormGeneral.Rrs_factorClick(Sender: TObject);
begin
    fl_Rrs:=CheckBox_Rrs.checked;
    end;

procedure TFormGeneral.CheckBox_E_factorClick(Sender: TObject);
begin
    fl_Ed :=CheckBox_E_factor.checked;
    end;

procedure TFormGeneral.ButtonOKClick(Sender: TObject);
begin
    ModalResult := mrOK;
    end;

procedure TFormGeneral.ButtonCancelClick(Sender: TObject);
begin
    ModalResult := mrCancel;
    end;

procedure TFormGeneral.Edit_Ed_factorChange(Sender: TObject);
begin
    val(Edit_Ed_factor.Text, input, error);
    if error=0 then mult_Ed:=input;
    end;

procedure TFormGeneral.Edit_Rrs_factorChange(Sender: TObject);
begin
    val(Edit_Rrs_factor.Text, input, error);
    if error=0 then mult_Rrs:=input;
    end;


procedure TFormGeneral.CheckBox_E0_factorClick(Sender: TObject);
begin
    fl_E0 :=CheckBox_E0_factor.checked;
    end;

procedure TFormGeneral.Edit_E0_factorChange(Sender: TObject);
begin
    val(Edit_E0_factor.Text, input, error);
    if error=0 then mult_E0:=input;
    end;

end.
