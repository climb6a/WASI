unit Popup_Tuning;

{$MODE Delphi}

{ Version vom 7.9.2019 }

interface

uses
  LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, SCHOEN_, defaults, misc, ExtCtrls;

type

  { TPopup_FitTuning }

  TPopup_FitTuning = class(TForm)
    GroupPreCYSsh: TGroupBox;
    GroupPreXYsh: TGroupBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    StaticText10: TStaticText;
    StaticText12: TStaticText;
    StaticText13: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    TabSheetInitial: TTabSheet;
    TabSheetFinal: TTabSheet;
    TabSheetResidual: TTabSheet;
    TabSheetWeight: TTabSheet;
    TabSheetEd: TTabSheet;
    TabSheetR: TTabSheet;
    TabSheetRsh: TTabSheet;
    TabSheetRrs: TTabSheet;
    RegTuning: TPageControl;
    ButtonOK: TButton;
    ButtonCancel: TButton;
    PageControl1: TPageControl;
    Residuum: TRadioGroup;
    StaticText3: TStaticText;
    CheckLn: TCheckBox;
    Iter_all: TEdit;
    fmax_4: TEdit;
    StaticText4: TStaticText;
    dk_4: TEdit;
    StaticText5: TStaticText;
    fmin_4: TEdit;
    EditWeight: TEdit;
    ButtonGewFile: TButton;
    EditHeaderGew: TEdit;
    EditXColGew: TEdit;
    EditYColGew: TEdit;
    StaticText2: TStaticText;
    StaticText6: TStaticText;
    StaticText9: TStaticText;
    StaticText11: TStaticText;
    TextHeaderEd1: TStaticText;
    TextHeaderEd3: TStaticText;
    TextHeadIndiv: TStaticText;
    TextHeadAll: TStaticText;
    OpenDialog1: TOpenDialog;
    CheckINI: TCheckBox;
    fmax_2: TEdit;
    fmin_2: TEdit;
    dk_2: TEdit;
    Iter_2: TEdit;
    fmin_3: TEdit;
    fmax_3: TEdit;
    dk_3: TEdit;
    Iter_3: TEdit;
    TextRrsEd10: TStaticText;
    TextRrsEd11: TStaticText;
    TextRrsBlue1: TStaticText;
    TextRrsBlue: TStaticText;
    TextRrsBlue5: TStaticText;
    TextRrsBlue4: TStaticText;
    TextRrsBlue3: TStaticText;
    TextRrsBlue2: TStaticText;
    TextRrsEd2: TStaticText;
    TextRrsEd1: TStaticText;
    TextRrsEd: TStaticText;
    TextRrsEd5: TStaticText;
    TextRrsEd4: TStaticText;
    TextRrsEd3: TStaticText;
    TextRPreCYSsh2: TStaticText;
    TextRPreCYSsh1: TStaticText;
    TextRPreXYsh2: TStaticText;
    TextRPreXYsh1: TStaticText;
    TextRPreXYsh: TStaticText;
    TextRPreXYsh5: TStaticText;
    TextRPreXYsh4: TStaticText;
    TextRPreXYsh3: TStaticText;
    TextRAnCY1sh1: TStaticText;
    TextRAnCY1sh2: TStaticText;
    TextRAnCY3: TStaticText;
    TextRAnCY4: TStaticText;
    TextRAnCY5: TStaticText;
    TextRAnCY6: TStaticText;
    TextRAnX1: TStaticText;
    TextRAnX2: TStaticText;
    TextRAnXf1: TStaticText;
    TextRAnXf2: TStaticText;
    TextRAnXsh1: TStaticText;
    TextRAnXsh2: TStaticText;
    TextRPreCYS3: TStaticText;
    TextRPreCYS: TStaticText;
    TextRPreCYS5: TStaticText;
    TextRPreCYS1: TStaticText;
    TextRPreCYS2: TStaticText;
    TextRPreCYS4: TStaticText;
    TextRPreCYSsh: TStaticText;
    TextRPreCYSsh5: TStaticText;
    TextRPreCYSsh4: TStaticText;
    TextRPreCYSsh3: TStaticText;
    fmin_1: TEdit;
    fmax_1: TEdit;
    dk_1: TEdit;
    Iter_1: TEdit;
    CheckRrsUseEd: TCheckBox;
    GroupPreEd: TGroupBox;
    GroupPreIR: TGroupBox;
    TextRrsEd6: TStaticText;
    TextRrsEd7: TStaticText;
    TextRrsEd8: TStaticText;
    TextRrsEd9: TStaticText;
    GroupPreBlue: TGroupBox;
    TextFileEd: TStaticText;
    EditEdFile: TEdit;
    ButtonEdFile: TButton;
    TextHeaderEd: TStaticText;
    EditHeaderEd: TEdit;
    EditXColEd: TEdit;
    EditYColEd: TEdit;
    CheckEdUseEd: TCheckBox;
    TextFileEd2: TStaticText;
    EditEdFile2: TEdit;
    ButtonEdFile2: TButton;
    TextHeaderEd2: TStaticText;
    EditHeaderEd2: TEdit;
    EditXColEd2: TEdit;
    EditYColEd2: TEdit;
    GroupEdMinus: TGroupBox;
    GroupPreXY: TGroupBox;
    fmin_XY: TEdit;
    fmin_XYsh: TEdit;
    fmax_XY: TEdit;
    fmax_XYsh: TEdit;
    df_XY: TEdit;
    df_XYsh: TEdit;
    Iter_XY: TEdit;
    Iter_XYsh: TEdit;
    GroupPreCYS: TGroupBox;
    fmin_CYS: TEdit;
    fmin_CYSsh: TEdit;
    fmax_CYS: TEdit;
    fmax_CYSsh: TEdit;
    df_CYS: TEdit;
    df_CYSsh: TEdit;
    Iter_CYS: TEdit;
    Iter_CYSsh: TEdit;
    TextRAnX: TStaticText;
    TextRAnXsh: TStaticText;
    LambdaIR: TEdit;
    LambdaIRsh: TEdit;
    dLambdaIR: TEdit;
    dLambdaIRsh: TEdit;
    TextRAnXf: TStaticText;
    LambdaIR2: TEdit;
    dLambdaIR2: TEdit;
    TextRAnCY1: TStaticText;
    TextRAnCY1sh: TStaticText;
    LambdaCY_1: TEdit;
    Edit_LambdazB: TEdit;
    dLambdaCY_1: TEdit;
    Edit_dLambdazB: TEdit;
    TextRAnCY2: TStaticText;
    LambdaCY_2: TEdit;
    dLambdaCY_2: TEdit;
    CheckAnX: TCheckBox;
    CheckAnXsh: TCheckBox;
    CheckAnCY: TCheckBox;
    CheckAnzB: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    GroupPreNestSh: TGroupBox;
    nest_minSh: TEdit;
    nest_maxSh: TEdit;
    dnest_sh: TEdit;
    Iter_nest: TEdit;
    GroupBox_z: TGroupBox;
    TextXColEd2: TStaticText;
    TextYColEd2: TStaticText;
    Text_z: TStaticText;
    Editz_Lmin: TEdit;
    Editz_Lmax: TEdit;
    Editz_dL: TEdit;
    Editz_Iter: TEdit;
    Text_res_max: TStaticText;
    Edit_res_max: TEdit;
    Static_no_check: TStaticText;
    Text_z1: TStaticText;
    TextRPreXY3: TStaticText;
    TextRPreXY5: TStaticText;
    TextNestSh2: TStaticText;
    TextNestSh1: TStaticText;
    Text_z2: TStaticText;
    Text_z3: TStaticText;
    Text_z4: TStaticText;
    Text_z5: TStaticText;
    TextRPreXY: TStaticText;
    TextRPreXY1: TStaticText;
    TextRPreXY2: TStaticText;
    TextRPreXY4: TStaticText;
    TextNestSh: TStaticText;
    TextNestSh5: TStaticText;
    TextNestSh4: TStaticText;
    TextNestSh3: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure define_temp_parameters(Sender: TObject);
    procedure RegTuningChange(Sender: TObject);
    procedure set_temp_parameters(Sender: TObject);
    procedure TextRPreXYshClick(Sender: TObject);
    procedure update_parameterlist(Sender: TObject);
    procedure InActivateLambdas(Sender: TObject);
    procedure InActivateEd(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure Iter_allChange(Sender: TObject);
    procedure CheckINIClick(Sender: TObject);
    procedure fmin_4Change(Sender: TObject);
    procedure fmax_4Change(Sender: TObject);
    procedure dk_4Change(Sender: TObject);
    procedure ResiduumClick(Sender: TObject);
    procedure CheckLnClick(Sender: TObject);
    procedure ButtonGewFileClick(Sender: TObject);
    procedure EditHeaderGewChange(Sender: TObject);
    procedure EditXColGewChange(Sender: TObject);
    procedure EditYColGewChange(Sender: TObject);
    procedure fmin_2Change(Sender: TObject);
    procedure fmin_3Change(Sender: TObject);
    procedure fmax_2Change(Sender: TObject);
    procedure fmax_3Change(Sender: TObject);
    procedure dk_2Change(Sender: TObject);
    procedure dk_3Change(Sender: TObject);
    procedure Iter_2Change(Sender: TObject);
    procedure Iter_3Change(Sender: TObject);
    procedure CheckAutoRrsClick(Sender: TObject);
    procedure fmin_1Change(Sender: TObject);
    procedure fmax_1Change(Sender: TObject);
    procedure dk_1Change(Sender: TObject);
    procedure Iter_1Change(Sender: TObject);
    procedure CheckRrsUseEdClick(Sender: TObject);
    procedure ButtonEdFileClick(Sender: TObject);
    procedure CheckEdUseEdClick(Sender: TObject);
    procedure LambdaIRChange(Sender: TObject);
    procedure dLambdaIRChange(Sender: TObject);
    procedure LambdaIR2Change(Sender: TObject);
    procedure dLambdaIR2Change(Sender: TObject);
    procedure LambdaCY_1Change(Sender: TObject);
    procedure dLambdaCY_1Change(Sender: TObject);
    procedure LambdaCY_2Change(Sender: TObject);
    procedure dLambdaCY_2Change(Sender: TObject);
    procedure fmin_XYChange(Sender: TObject);
    procedure fmax_XYChange(Sender: TObject);
    procedure df_XYChange(Sender: TObject);
    procedure Iter_XYChange(Sender: TObject);
    procedure fmin_CYSChange(Sender: TObject);
    procedure fmax_CYSChange(Sender: TObject);
    procedure df_CYSChange(Sender: TObject);
    procedure Iter_CYSChange(Sender: TObject);
    procedure CheckAnXClick(Sender: TObject);
    procedure CheckAnCYClick(Sender: TObject);
    procedure EditHeaderEd2Change(Sender: TObject);
    procedure EditXColEd2Change(Sender: TObject);
    procedure EditYColEd2Change(Sender: TObject);
    procedure CheckAnXshClick(Sender: TObject);
    procedure CheckAnzBClick(Sender: TObject);
    procedure LambdaIRshChange(Sender: TObject);
    procedure dLambdaIRshChange(Sender: TObject);
    procedure Edit_LambdazBChange(Sender: TObject);
    procedure Edit_dLambdazBChange(Sender: TObject);
    procedure fmin_XYshChange(Sender: TObject);
    procedure fmax_XYshChange(Sender: TObject);
    procedure df_XYshChange(Sender: TObject);
    procedure Iter_XYshChange(Sender: TObject);
    procedure fmin_CYSshChange(Sender: TObject);
    procedure fmax_CYSshChange(Sender: TObject);
    procedure df_CYSshChange(Sender: TObject);
    procedure Iter_CYSshChange(Sender: TObject);
    procedure nest_minShChange(Sender: TObject);
    procedure nest_maxShChange(Sender: TObject);
    procedure dnest_shChange(Sender: TObject);
    procedure Iter_nestChange(Sender: TObject);
    procedure Editz_LminChange(Sender: TObject);
    procedure Editz_LmaxChange(Sender: TObject);
    procedure Editz_dLChange(Sender: TObject);
    procedure Editz_IterChange(Sender: TObject);
    procedure Edit_res_maxChange(Sender: TObject);
  private
    input : single;
    error : integer;
  public
    tfit_min    : array[1..FC]of double;
    tfit_max    : array[1..FC]of double;
    tfit_dL     : array[1..FC]of byte;
    tfitsh_min  : array[1..FC]of double;
    tfitsh_max  : array[1..FC]of double;
    tfitsh_dL   : array[1..FC]of byte;
    tLambdaPY   : array[1..3]of double;
    tdLambdaPY  : array[1..2]of double;
    tLambdaLf   : array[1..2]of double;
    tdLambdaLf  : array[1..2]of double;
    tLambdaLfsh : double;
    tdLambdaLfsh: double;
    tMaxIter    : array[1..FC]of integer;
    tMaxItersh  : array[1..FC]of integer;
    tLambdazB   : double;
    tdLambdazB  : double;
    tres_max    : double;
    fl_autoiniRx : boolean;
    fl_anX_R    : boolean;
    fl_anX_Rsh  : boolean;
    fl_anCY_R   : boolean;
    fl_anzB     : boolean;
    fl_b_Reset  : boolean;
    fl_Res_log  : boolean;
    fl_use_Ed   : boolean;
    tres_mode   : byte;
    GewHeader   : word;
    GewXCol     : word;
    GewYCol     : word;
    EdHeader    : word;
    EdXCol      : word;
    EdYCol      : word;
    t_Name_gew  : ShortString;
    t_Name_Ed   : ShortString;
  end;

var
  Popup_FitTuning: TPopup_FitTuning;

implementation

{$R *.lfm}

procedure TPopup_FitTuning.FormCreate(Sender: TObject);
begin
    define_temp_parameters(Sender);
    update_parameterlist(Sender);
    TabSheetR.TabVisible:=not flag_shallow;
    TabSheetRsh.TabVisible:=flag_shallow;
    end;

procedure TPopup_FitTuning.define_temp_parameters(Sender: TObject);
var i : integer;
begin
    for i:=1 to FC do begin
        tfit_min[i]:=fit_min[i];
        tfit_max[i]:=fit_max[i];
        tfit_dL[i] :=fit_dL[i];
        tMaxIter[i]:=MaxIter[i];
        end;
    for i:=1 to FC do begin
        tfitsh_min[i]:=fitsh_min[i];
        tfitsh_max[i]:=fitsh_max[i];
        tfitsh_dL[i] :=fitsh_dL[i];
        tMaxItersh[i]:=MaxItersh[i];
        end;
    for i:=1 to 3 do tLambdaPY[i]  :=LambdaCY[i];
    for i:=1 to 2 do tdLambdaPY[i] :=dLambdaCY[i];
    for i:=1 to 2 do tLambdaLf[i]  :=LambdaLf[i];
    for i:=1 to 2 do tdLambdaLf[i] :=dLambdaLf[i];
    tres_max    :=res_max;
    tLambdaLfsh :=LambdaLsh;
    tdLambdaLfsh:=dLambdaLsh;
    tLambdazB  :=LambdazB;
    tdLambdazB :=dLambdazB;
    fl_anX_R   :=flag_anX_R;
    fl_anX_Rsh :=flag_anX_Rsh;
    fl_anCY_R  :=flag_anCY_R;
    fl_anzB    :=flag_anzB;
    fl_b_Reset :=flag_b_Reset;
    fl_Res_log :=flag_Res_log;
    fl_use_Ed  :=flag_use_Ed;
    tres_mode  :=res_mode;
    t_Name_gew :=Gew^.FName;
    t_Name_Ed  :=Ed^.FName;
    GewHeader  :=Gew^.Header;
    GewXCol    :=Gew^.XColumn;
    GewYCol    :=Gew^.YColumn;
    EdHeader   :=Ed^.Header;
    EdXCol     :=Ed^.XColumn;
    EdYCol     :=Ed^.YColumn;
    end;

procedure TPopup_FitTuning.RegTuningChange(Sender: TObject);
begin

end;

procedure TPopup_FitTuning.set_temp_parameters(Sender: TObject);
var i, k, ch : word;
    ok       : byte;      {0: ok, 1: file not found, 2: y=constant }
begin
    for i:=1 to FC do begin
        fit_min[i]:=tfit_min[i];
        fit_max[i]:=tfit_max[i];
        fit_dL[i] :=tfit_dL[i];
        MaxIter[i]:=tMaxIter[i];
        end;
    for i:=1 to FC do begin
        fitsh_min[i]:=tfitsh_min[i];
        fitsh_max[i]:=tfitsh_max[i];
        fitsh_dL[i] :=tfitsh_dL[i];
        MaxItersh[i]:=tMaxItersh[i];
        end;
    for i:=1 to 3 do LambdaCY[i] :=tLambdaPY[i];
    for i:=1 to 2 do dLambdaCY[i]:=tdLambdaPY[i];
    for i:=1 to 2 do LambdaLf[i] :=tLambdaLf[i];
    for i:=1 to 2 do dLambdaLf[i]:=tdLambdaLf[i];

    res_max   :=tres_max;
    LambdaLsh :=tLambdaLfsh;
    dLambdaLsh:=tdLambdaLfsh;
    LambdazB :=tLambdazB;
    dLambdazB:=tdLambdazB;

    flag_anX_R   :=fl_anX_R;
    flag_anX_Rsh :=fl_anX_Rsh;
    flag_anCY_R  :=fl_anCY_R;
    flag_anzB    :=fl_anzB;
    flag_b_Reset :=fl_b_Reset;
    flag_Res_log :=fl_Res_log;
    flag_use_Ed  :=fl_use_Ed;
    res_mode:=tres_mode;
    Gew^.Header :=GewHeader;
    Gew^.XColumn:=GewXCol;
    Gew^.YColumn:=GewYCol;
    Gew^.FName  :=t_Name_gew;
    Ed^.Header :=EdHeader;
    Ed^.XColumn:=EdXCol;
    Ed^.YColumn:=EdYCol;
    Ed^.FName  :=t_Name_Ed;
    if flag_use_Ed then begin
        ok:=lies_spektrum(Ed^, Ed^.FName, Ed^.XColumn, Ed^.YColumn, Ed^.Header, ch, false);
        if ok<>1 then x_anpassen(Ed^.y, ch, 0);
        if ok<>1 then if flag_mult_Ed then
            for k:=1 to Channel_number do Ed^.y[k]:=Ed_factor * Ed^.y[k];
        end;
    end;

procedure TPopup_FitTuning.TextRPreXYshClick(Sender: TObject);
begin

end;

procedure TPopup_FitTuning.update_parameterlist(Sender: TObject);
const SIG = 3;
var   ss : ShortString;
      Pfit : boolean;
begin
    LambdaIR.Text    :=schoen(tLambdaLf[1], SIG);
    LambdaIR2.Text   :=schoen(tLambdaLf[2], SIG);
    dLambdaIR.Text   :=schoen(tdLambdaLf[1], SIG-1);
    dLambdaIR2.Text  :=schoen(tdLambdaLf[2], SIG-1);
    LambdaCY_1.Text  :=schoen(tLambdaPY[1], SIG);
    dLambdaCY_1.Text :=schoen(tdLambdaPY[1], SIG-1);
    LambdaCY_2.Text  :=schoen(tLambdaPY[2], SIG);
    dLambdaCY_2.Text :=schoen(tdLambdaPY[2], SIG-1);
    fmin_1.Text :=schoen(tfit_min[1], SIG);
    fmax_1.Text :=schoen(tfit_max[1], SIG);
    dk_1.Text   :=schoen(tfit_dL[1], 0);
    Iter_1.Text :=schoen(tMaxIter[1], 1);
    fmin_2.Text :=schoen(tfit_min[2], SIG);
    fmin_XY.Text:=fmin_2.Text;
    fmax_2.Text :=schoen(tfit_max[2], SIG);
    fmax_XY.Text:=fmax_2.Text;
    dk_2.Text   :=schoen(tfit_dL[2], 0);
    df_XY.Text  :=dk_2.Text;
    Iter_2.Text :=schoen(tMaxIter[2], 1);
    Iter_XY.Text:=Iter_2.Text;
    fmin_3.Text :=schoen(tfit_min[3], SIG);
    fmin_CYS.Text:=fmin_3.Text;
    fmax_3.Text :=schoen(tfit_max[3], SIG);
    fmax_CYS.Text:=fmax_3.Text;
    Iter_3.Text :=schoen(tMaxIter[3], 1);
    Iter_CYS.Text:=Iter_3.Text;
    dk_3.Text   :=schoen(tfit_dL[3], 0);
    df_CYS.Text :=dk_3.Text;
    fmin_4.Text :=schoen(tfit_min[4], SIG);
    fmax_4.Text :=schoen(tfit_max[4], SIG);
    dk_4.Text   :=schoen(tfit_dL[4], 0);
    Iter_all.Text:=schoen(tMaxIter[4], 1);

    Editz_Lmin.Text :=schoen(tfit_min[2], SIG);
    Editz_Lmax.Text :=schoen(tfit_max[2], SIG);
    Editz_dL.Text   :=dk_2.Text;
    Editz_Iter.Text :=schoen(tMaxIter[2], 1);
    Edit_res_max.Text:=schoen(tres_max, 2);

    { Shallow water parameters for R }
    LambdaIRsh.Text    :=schoen(tLambdaLfsh, SIG);
    dLambdaIRsh.Text   :=schoen(tdLambdaLfsh, SIG);
    Edit_LambdazB.Text :=schoen(tLambdazB, SIG);
    Edit_dLambdazB.Text:=schoen(tdLambdazB, SIG-1);

    nest_minSh.Text:=schoen(tfitsh_min[1], SIG);
    nest_maxSh.Text:=schoen(tfitsh_max[1], SIG);
    dnest_sh.Text  :=schoen(tfitsh_dL[1], 0);
    Iter_nest.Text :=schoen(tMaxItersh[1], 1);

    fmin_XYsh.Text:=schoen(tfitsh_min[2], SIG);
    fmax_XYsh.Text:=schoen(tfitsh_max[2], SIG);
    df_XYsh.Text  :=schoen(tfitsh_dL[2], 0);
    Iter_XYsh.Text:=schoen(tMaxItersh[2], 1);

    fmin_CYSsh.Text:=schoen(tfitsh_min[3], SIG);
    fmax_CYSsh.Text:=schoen(tfitsh_max[3], SIG);
    df_CYSsh.Text :=schoen(tfitsh_dL[3], 0);
    Iter_CYSsh.Text:=schoen(tMaxItersh[3], 1);

    CheckAnX.Checked     :=fl_anX_R;
    CheckAnXsh.Checked   :=fl_anX_Rsh;
    CheckAnCY.Checked    :=fl_anCY_R;
    CheckAnzB.Checked    :=fl_anzB;
    CheckRrsUseEd.checked:=fl_use_Ed;
    CheckEdUseEd.checked :=fl_use_Ed;
    CheckINI.checked     :=fl_b_Reset;
    CheckLn.checked      :=fl_Res_log;
    Residuum.ItemIndex   :=tres_mode;
    str(GewHeader, ss); EditHeaderGew.Text:=ss;
    str(GewXCol, ss);   EditXColGew.Text:=ss;
    str(GewYCol, ss);   EditYColGew.Text:=ss;
    str(EdHeader, ss);  EditHeaderEd.Text:=ss; EditHeaderEd2.Text:=ss;
    str(EdXCol, ss);    EditXColEd.Text:=ss;   EditXColEd2.Text:=ss;
    str(EdYCol, ss);    EditYColEd.Text:=ss;   EditYColEd2.Text:=ss;
    EditWeight.Text:=t_Name_gew;
    EditEdFile.Text:=t_Name_Ed;
    EditEdFile2.Text:=t_Name_Ed;
    InActivateLambdas(Sender);
    InActivateEd(Sender);

    if ((C_X.fit=1) and (C_Mie.fit=0)) then begin
        CheckAnX.caption:='Analytic estimate of C_X ';
        CheckAnXsh.caption:='Analytic estimate of C_X ';
        end
    else if ((C_X.fit=1) and (C_Mie.fit=1)) then begin
        CheckAnX.caption:='Analytic estimate of C_X and C_Mie';
        CheckAnXsh.caption:='Analytic estimate of C_X and C_Mie';
        end
    else if ((C_X.fit=0) and (C_Mie.fit=1)) then begin
        CheckAnX.caption:='Analytic estimate of C_Mie';
        CheckAnXsh.caption:='Analytic estimate of C_Mie';
        end;
    if ((f.fit=1) and (model_f=0)) then CheckAnX.caption:=CheckAnX.caption+' and f';
    LambdaIR2.visible :=((f.fit=1) and (model_f=0));
    dLambdaIR2.visible:=((f.fit=1) and (model_f=0));
    TextRAnXf.visible :=((f.fit=1) and (model_f=0));
    Pfit:=(C[0].fit + C[1].fit + C[2].fit + C[3].fit + C[4].fit + C[5].fit > 0);
    if (Pfit and (C_Y.fit=0)) then CheckAnCY.caption:='Analytic estimate of C[0] ' else
    if (Pfit and (C_Y.fit=1)) then CheckAnCY.caption:='Analytic estimate of C[0] and C_Y' else
    if (not Pfit and (C_Y.fit=1)) then CheckAnCY.caption:='Analytic estimate of C_Y';
    ss:='';
    if C_X.fit=1 then ss:='C_X';
    if C_Mie.fit=1 then if length(ss)=0 then ss:='C_Mie' else ss:=ss + ', C_Mie';
    if C_Y.fit=1 then if length(ss)=0 then ss:='C_Y' else ss:=ss + ', C_Y';
    GroupPreXY.caption:='Pre-fit of ' + ss;
    GroupPreXY.Visible:=length(ss)>1;
    ss:='';
    if (C[0].fit=1) or (C[1].fit=1) or (C[2].fit=1) or (C[3].fit=1)
                    or (C[4].fit=1) or (C[5].fit=1) then ss:='C[0]';
    if C_Y.fit=1  then if length(ss)=0 then ss:='C_Y' else ss:=ss + ', C_Y';
    if S.fit=1    then if length(ss)=0 then ss:='S' else ss:=ss + ', S';
    GroupPreCYS.caption:='Pre-fit of ' + ss;
    GroupPreCYS.Visible:=length(ss)>1;
    end;

procedure TPopup_FitTuning.InActivateLambdas(Sender: TObject);
begin
    TextRrsEd.Enabled:=fl_use_Ed;
    fmin_1.Enabled:=fl_use_Ed;
    fmax_1.Enabled:=fl_use_Ed;
    dk_1.Enabled  :=fl_use_Ed;
    Iter_1.Enabled:=fl_use_Ed;
    if fl_use_Ed then GroupPreEd.Font.Color:=clWindowText
                 else GroupPreEd.Font.Color:=clInactiveCaption;

    LambdaIR.Enabled  :=fl_anX_R;
    dLambdaIR.Enabled :=fl_anX_R;
    TextRAnX.Enabled  :=fl_anX_R;
    LambdaIR2.Enabled :=fl_anX_R;
    dLambdaIR2.Enabled:=fl_anX_R;
    TextRAnXf.Enabled :=fl_anX_R;
    LambdaIRsh.Enabled  :=fl_anX_Rsh;
    dLambdaIRsh.Enabled :=fl_anX_Rsh;
    TextRAnXsh.Enabled  :=fl_anX_Rsh;
    LambdaCY_1.Enabled  :=fl_anCY_R;
    dLambdaCY_1.Enabled :=fl_anCY_R;
    TextRAnCY1.Enabled  :=fl_anCY_R;
    LambdaCY_2.Enabled  :=fl_anCY_R;
    dLambdaCY_2.Enabled :=fl_anCY_R;
    TextRAnCY2.Enabled  :=fl_anCY_R;
    Edit_LambdazB.Enabled :=fl_anzB;
    Edit_dLambdazB.Enabled :=fl_anzB;
    TextRAnCY1sh.Enabled:=fl_anzB;
    end;

procedure TPopup_FitTuning.InActivateEd(Sender: TObject);
begin
    TextFileEd.Enabled:=fl_use_Ed;
    //EditEdFile.Enabled:=fl_use_Ed;
    ButtonEdFile.Enabled:=fl_use_Ed;
    TextHeaderEd.Enabled:=fl_use_Ed;
    EditHeaderEd.Enabled:=fl_use_Ed;
    EditXColEd.Enabled:=fl_use_Ed;
    EditYColEd.Enabled:=fl_use_Ed;
    CheckRrsUseEd.checked:=fl_use_Ed;

    TextFileEd2.Enabled:=fl_use_Ed;
    //EditEdFile2.Enabled:=fl_use_Ed;
    ButtonEdFile2.Enabled:=fl_use_Ed;
    TextHeaderEd2.Enabled:=fl_use_Ed;
    EditHeaderEd2.Enabled:=fl_use_Ed;
    EditXColEd2.Enabled:=fl_use_Ed;
    EditYColEd2.Enabled:=fl_use_Ed;
    CheckEdUseEd.checked:=fl_use_Ed;
    end;


procedure TPopup_FitTuning.ButtonOKClick(Sender: TObject);
begin
    ModalResult := mrOK;
    end;

procedure TPopup_FitTuning.ButtonCancelClick(Sender: TObject);
begin
    ModalResult := mrCancel;
    end;

procedure TPopup_FitTuning.Iter_allChange(Sender: TObject);
begin
    val(Iter_all.Text, input, error);
    if (error=0) then tMaxIter[4]:=round(input);
    if tMaxIter[4]<0 then tMaxIter[4]:=0;
    end;


procedure TPopup_FitTuning.CheckINIClick(Sender: TObject);
begin
    fl_b_Reset:=CheckINI.checked;
    end;

procedure TPopup_FitTuning.fmin_4Change(Sender: TObject);
begin
    val(fmin_4.Text, input, error);
    if error=0 then tfit_min[4]:=input;
    if tfit_min[4]>tfit_max[4] then tfit_min[4]:=tfit_max[4];
    end;

procedure TPopup_FitTuning.fmax_4Change(Sender: TObject);
begin
    val(fmax_4.Text, input, error);
    if error=0 then tfit_max[4]:=input;
    if tfit_max[4]<tfit_min[4] then tfit_max[4]:=tfit_min[4];
    end;

procedure TPopup_FitTuning.dk_4Change(Sender: TObject);
begin
    val(dk_4.Text, input, error);
    if error=0 then if input>0.9 then tfit_dL[4]:=round(input);
    end;

procedure TPopup_FitTuning.ResiduumClick(Sender: TObject);
begin
    tres_mode:=Residuum.ItemIndex;
    end;

procedure TPopup_FitTuning.CheckLnClick(Sender: TObject);
begin
    fl_Res_log:=CheckLn.Checked;
    end;

procedure TPopup_FitTuning.ButtonGewFileClick(Sender: TObject);
var old_extension : ShortString;
begin
    old_extension:='*'+ExtractFileExt(Gew^.FName);
    OpenDialog1.FileName:=Gew^.FName;
    OpenDialog1.InitialDir := ExtractFilePath(Gew^.FName);
    OpenDialog1.Title := 'Load file with weighting factors';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';
    if OpenDialog1.Execute then
        t_Name_gew:=OpenDialog1.FileName;
    EditWeight.text:=t_Name_gew;
    EditWeight.refresh;
    end;

procedure TPopup_FitTuning.EditHeaderGewChange(Sender: TObject);
begin
    val(EditHeaderGew.Text, input, error);
    if error=0 then GewHeader:=round(input);
    end;

procedure TPopup_FitTuning.EditXColGewChange(Sender: TObject);
begin
    val(EditXColGew.Text, input, error);
    if error=0 then GewXcol:=round(input);
    end;

procedure TPopup_FitTuning.EditYColGewChange(Sender: TObject);
begin
    val(EditYColGew.Text, input, error);
    if error=0 then GewYcol:=round(input);
    end;

procedure TPopup_FitTuning.fmin_2Change(Sender: TObject);
begin
    val(fmin_2.Text, input, error);
    if error=0 then tfit_min[2]:=input;
    if tfit_min[2]>tfit_max[2] then tfit_min[2]:=tfit_max[2];
    end;

procedure TPopup_FitTuning.fmin_3Change(Sender: TObject);
begin
    val(fmin_3.Text, input, error);
    if error=0 then tfit_min[3]:=input;
    if tfit_min[3]>tfit_max[3] then tfit_min[3]:=tfit_max[3];
    end;


procedure TPopup_FitTuning.fmax_2Change(Sender: TObject);
begin
    val(fmax_2.Text, input, error);
    if error=0 then tfit_max[2]:=input;
    if tfit_max[2]<tfit_min[2] then tfit_max[2]:=tfit_min[2];
    end;

procedure TPopup_FitTuning.fmax_3Change(Sender: TObject);
begin
    val(fmax_3.Text, input, error);
    if error=0 then tfit_max[3]:=input;
    if tfit_max[3]<tfit_min[3] then tfit_max[3]:=tfit_min[3];
    end;

procedure TPopup_FitTuning.dk_2Change(Sender: TObject);
begin
    val(dk_2.Text, input, error);
    if error=0 then if input>0.9 then tfit_dL[2]:=round(input);
    end;

procedure TPopup_FitTuning.dk_3Change(Sender: TObject);
begin
    val(dk_3.Text, input, error);
    if error=0 then if input>0.9 then tfit_dL[3]:=round(input);
    end;

procedure TPopup_FitTuning.Iter_2Change(Sender: TObject);
begin
    val(Iter_2.Text, input, error);
    if (error=0) then tMaxIter[2]:=round(input);
    if tMaxIter[2]<0 then tMaxIter[2]:=0;
    end;

procedure TPopup_FitTuning.Iter_3Change(Sender: TObject);
begin
    val(Iter_3.Text, input, error);
    if (error=0) then tMaxIter[3]:=round(input);
    if tMaxIter[3]<0 then tMaxIter[3]:=0;
    end;

procedure TPopup_FitTuning.CheckAutoRrsClick(Sender: TObject);
begin
    InActivateLambdas(Sender);
    end;

procedure TPopup_FitTuning.fmin_1Change(Sender: TObject);
begin
    val(fmin_1.Text, input, error);
    if error=0 then tfit_min[1]:=input;
    if tfit_min[1]>tfit_max[1] then tfit_min[1]:=tfit_max[1];
    end;

procedure TPopup_FitTuning.fmax_1Change(Sender: TObject);
begin
    val(fmax_1.Text, input, error);
    if error=0 then tfit_max[1]:=input;
    if tfit_max[1]<tfit_min[1] then tfit_max[1]:=tfit_min[1];
    end;

procedure TPopup_FitTuning.dk_1Change(Sender: TObject);
begin
    val(dk_1.Text, input, error);
    if error=0 then if input>0.9 then tfit_dL[1]:=round(input);
    end;

procedure TPopup_FitTuning.Iter_1Change(Sender: TObject);
begin
    val(Iter_1.Text, input, error);
    if (error=0) then tMaxIter[1]:=round(input);
    if tMaxIter[1]<0 then tMaxIter[1]:=0;
    end;

procedure TPopup_FitTuning.CheckRrsUseEdClick(Sender: TObject);
begin
    fl_use_Ed:=CheckRrsUseEd.checked;
    InActivateLambdas(Sender);
    InActivateEd(Sender);
    end;

procedure TPopup_FitTuning.ButtonEdFileClick(Sender: TObject);
var old_extension : ShortString;
begin
    old_extension:='*'+ExtractFileExt(Ed^.FName);
    OpenDialog1.FileName:=Ed^.FName;
    OpenDialog1.InitialDir := ExtractFilePath(Ed^.FName);
    OpenDialog1.Title := 'Load downwelling irradiance spectrum';
    OpenDialog1.Filter:=old_extension+'|' + old_extension +'|'+
                        '*.* |*.*|';
    if OpenDialog1.Execute then
        t_Name_Ed:=OpenDialog1.FileName;
    EditWeight.text:=t_Name_Ed;
    EditEdFile.refresh;
    end;

procedure TPopup_FitTuning.CheckEdUseEdClick(Sender: TObject);
begin
    fl_use_Ed:=CheckEdUseEd.checked;
    InActivateLambdas(Sender);
    InActivateEd(Sender);
    end;

procedure TPopup_FitTuning.LambdaIRChange(Sender: TObject);
begin
    val(LambdaIR.Text, input, error);
    if (input<xub) or (input>xob) then error:=1;
    if error=0 then tLambdaLf[1]:=input;
    end;

procedure TPopup_FitTuning.dLambdaIRChange(Sender: TObject);
begin
    val(dLambdaIR.Text, input, error);
    if error=0 then tdLambdaLf[1]:=abs(input);
    end;

procedure TPopup_FitTuning.LambdaIR2Change(Sender: TObject);
begin
    val(LambdaIR2.Text, input, error);
    if (input<xub) or (input>xob) then error:=1;
    if error=0 then tLambdaLf[2]:=input;
    end;

procedure TPopup_FitTuning.dLambdaIR2Change(Sender: TObject);
begin
    val(dLambdaIR2.Text, input, error);
    if error=0 then tdLambdaLf[2]:=abs(input);
    end;

procedure TPopup_FitTuning.LambdaCY_1Change(Sender: TObject);
begin
    val(LambdaCY_1.Text, input, error);
    if (input<xub) or (input>xob) then error:=1;
    if error=0 then tLambdaPY[1]:=input;
    end;

procedure TPopup_FitTuning.dLambdaCY_1Change(Sender: TObject);
begin
    val(dLambdaCY_1.Text, input, error);
    if error=0 then tdLambdaPY[1]:=abs(input);
    end;

procedure TPopup_FitTuning.LambdaCY_2Change(Sender: TObject);
begin
    val(LambdaCY_2.Text, input, error);
    if (input<xub) or (input>xob) then error:=1;
    if error=0 then tLambdaPY[2]:=input;
    end;

procedure TPopup_FitTuning.dLambdaCY_2Change(Sender: TObject);
begin
    val(dLambdaCY_2.Text, input, error);
    if error=0 then tdLambdaPY[2]:=abs(input);
    end;

procedure TPopup_FitTuning.fmin_XYChange(Sender: TObject);
begin
    val(fmin_XY.Text, input, error);
    if error=0 then tfit_min[2]:=input;
    if tfit_min[2]>tfit_max[2] then tfit_min[2]:=tfit_max[2];
    end;

procedure TPopup_FitTuning.fmax_XYChange(Sender: TObject);
begin
    val(fmax_XY.Text, input, error);
    if error=0 then tfit_max[2]:=input;
    if tfit_max[2]<tfit_min[2] then tfit_max[2]:=tfit_min[2];
    end;

procedure TPopup_FitTuning.df_XYChange(Sender: TObject);
begin
    val(df_XY.Text, input, error);
    if error=0 then if input>0.9 then tfit_dL[2]:=round(input);  {stimmt das?}
    end;

procedure TPopup_FitTuning.Iter_XYChange(Sender: TObject);
begin
    val(Iter_XY.Text, input, error);
    if (error=0) then tMaxIter[2]:=round(input);
    if tMaxIter[2]<0 then tMaxIter[2]:=0;
    end;

procedure TPopup_FitTuning.fmin_CYSChange(Sender: TObject);
begin
    val(fmin_CYS.Text, input, error);
    if error=0 then tfit_min[3]:=input;
    if tfit_min[3]>tfit_max[3] then tfit_min[3]:=tfit_max[3];
    end;

procedure TPopup_FitTuning.fmax_CYSChange(Sender: TObject);
begin
    val(fmax_CYS.Text, input, error);
    if error=0 then tfit_max[3]:=input;
    if tfit_max[3]<tfit_min[3] then tfit_max[3]:=tfit_min[3];
    end;

procedure TPopup_FitTuning.df_CYSChange(Sender: TObject);
begin
    val(df_CYS.Text, input, error);
    if error=0 then if input>0.9 then tfit_dL[3]:=round(input);
    end;

procedure TPopup_FitTuning.Iter_CYSChange(Sender: TObject);
begin
    val(Iter_CYS.Text, input, error);
    if (error=0) then tMaxIter[3]:=round(input);
    if tMaxIter[3]<0 then tMaxIter[3]:=0;
    end;

procedure TPopup_FitTuning.CheckAnXClick(Sender: TObject);
begin
    fl_anX_R:=CheckAnX.checked;
{    CheckAutoRrs.checked:=fl_anX_R; }
    InActivateLambdas(Sender);
    end;

procedure TPopup_FitTuning.CheckAnCYClick(Sender: TObject);
begin
    fl_anCY_R:=CheckAnCY.checked;
    InActivateLambdas(Sender);
    end;

procedure TPopup_FitTuning.EditHeaderEd2Change(Sender: TObject);
begin
    val(EditHeaderEd2.Text, input, error);
    if error=0 then EdHeader:=round(input);
    end;

procedure TPopup_FitTuning.EditXColEd2Change(Sender: TObject);
begin
    val(EditXColEd2.Text, input, error);
    if error=0 then EdXcol:=round(input);
    end;

procedure TPopup_FitTuning.EditYColEd2Change(Sender: TObject);
begin
    val(EditYColEd2.Text, input, error);
    if error=0 then EdYcol:=round(input);
    end;

procedure TPopup_FitTuning.CheckAnXshClick(Sender: TObject);
begin
    fl_anX_Rsh:=CheckAnXsh.checked;
{    CheckAutoRrs.checked:=fl_anX_Rsh; }
    InActivateLambdas(Sender);
    end;

procedure TPopup_FitTuning.CheckAnzBClick(Sender: TObject);
begin
    fl_anzB:=CheckAnzB.checked;
    InActivateLambdas(Sender);
    end;

procedure TPopup_FitTuning.LambdaIRshChange(Sender: TObject);
begin
    val(LambdaIRsh.Text, input, error);
    if (input<xub) or (input>xob) then error:=1;
    if error=0 then tLambdaLfsh:=input;
    end;

procedure TPopup_FitTuning.dLambdaIRshChange(Sender: TObject);
begin
    val(dLambdaIRsh.Text, input, error);
    if error=0 then tdLambdaLfsh:=abs(input);
    end;

procedure TPopup_FitTuning.Edit_LambdazBChange(Sender: TObject);
begin
    val(Edit_LambdazB.Text, input, error);
    if (input<xub) or (input>xob) then error:=1;
    if error=0 then tLambdazB:=input;
    end;

procedure TPopup_FitTuning.Edit_dLambdazBChange(Sender: TObject);
begin
    val(Edit_dLambdazB.Text, input, error);
    if error=0 then tdLambdazB:=abs(input);
    end;

procedure TPopup_FitTuning.nest_minShChange(Sender: TObject);
begin
    val(nest_minSh.Text, input, error);
    if error=0 then tfitsh_min[1]:=input;
    if tfitsh_min[1]>tfitsh_max[1] then tfitsh_min[1]:=tfitsh_max[1];
    end;

procedure TPopup_FitTuning.nest_maxShChange(Sender: TObject);
begin
    val(nest_maxSh.Text, input, error);
    if error=0 then tfitsh_max[1]:=input;
    if tfitsh_max[1]<tfitsh_min[1] then tfitsh_max[1]:=tfitsh_min[1];
    end;

procedure TPopup_FitTuning.dnest_shChange(Sender: TObject);
begin
    val(dnest_sh.Text, input, error);
    if error=0 then if input>0.9 then tfitsh_dL[1]:=round(input);
    end;

procedure TPopup_FitTuning.Iter_nestChange(Sender: TObject);
begin
    val(Iter_nest.Text, input, error);
    if (error=0) then tMaxItersh[1]:=round(input);
    if tMaxItersh[1]<0 then tMaxItersh[1]:=0;
    end;

procedure TPopup_FitTuning.fmin_XYshChange(Sender: TObject);
begin
    val(fmin_XYsh.Text, input, error);
    if error=0 then tfitsh_min[2]:=input;
    if tfitsh_min[2]>tfitsh_max[2] then tfitsh_min[2]:=tfitsh_max[2];
    end;

procedure TPopup_FitTuning.fmax_XYshChange(Sender: TObject);
begin
    val(fmax_XYsh.Text, input, error);
    if error=0 then tfitsh_max[2]:=input;
    if tfitsh_max[2]<tfitsh_min[2] then tfitsh_max[2]:=tfitsh_min[2];
    end;

procedure TPopup_FitTuning.df_XYshChange(Sender: TObject);
begin
    val(df_XYsh.Text, input, error);
    if error=0 then if input>0.9 then tfitsh_dL[2]:=round(input);
    end;

procedure TPopup_FitTuning.Iter_XYshChange(Sender: TObject);
begin
    val(Iter_XYsh.Text, input, error);
    if (error=0) then tMaxItersh[2]:=round(input);
    if tMaxItersh[2]<0 then tMaxItersh[2]:=0;
    end;

procedure TPopup_FitTuning.fmin_CYSshChange(Sender: TObject);
begin
    val(fmin_CYSsh.Text, input, error);
    if error=0 then tfitsh_min[3]:=input;
    if tfitsh_min[3]>tfitsh_max[3] then tfitsh_min[3]:=tfitsh_max[3];
    end;

procedure TPopup_FitTuning.fmax_CYSshChange(Sender: TObject);
begin
    val(fmax_CYSsh.Text, input, error);
    if error=0 then tfitsh_max[3]:=input;
    if tfitsh_max[3]<tfitsh_min[3] then tfitsh_max[3]:=tfitsh_min[3];
    end;

procedure TPopup_FitTuning.df_CYSshChange(Sender: TObject);
begin
    val(df_CYSsh.Text, input, error);
    if error=0 then if input>0.9 then tfitsh_dL[3]:=round(input);
    end;

procedure TPopup_FitTuning.Iter_CYSshChange(Sender: TObject);
begin
    val(Iter_CYSsh.Text, input, error);
    if (error=0) then tMaxItersh[3]:=round(input);
    if tMaxItersh[3]<0 then tMaxItersh[3]:=0;
    end;

procedure TPopup_FitTuning.Editz_LminChange(Sender: TObject);
begin
    val(Editz_Lmin.Text, input, error);
    if error=0 then tfit_min[2]:=input;
    if tfit_min[2]>tfit_max[2] then tfit_min[2]:=tfit_max[2];
    end;

procedure TPopup_FitTuning.Editz_LmaxChange(Sender: TObject);
begin
    val(Editz_Lmax.Text, input, error);
    if error=0 then tfit_max[2]:=input;
    if tfit_max[2]<tfit_min[2] then tfit_max[2]:=tfit_min[2];
    end;

procedure TPopup_FitTuning.Editz_dLChange(Sender: TObject);
begin
    val(Editz_dL.Text, input, error);
    if error=0 then if input>0.9 then tfit_dL[2]:=round(input);
    end;

procedure TPopup_FitTuning.Editz_IterChange(Sender: TObject);
begin
    val(Editz_Iter.Text, input, error);
    if (error=0) then tMaxIter[2]:=round(input);
    if tMaxIter[2]<0 then tMaxIter[2]:=0;
    end;

procedure TPopup_FitTuning.Edit_res_maxChange(Sender: TObject);
begin
    val(Edit_res_max.Text, input, error);
    tres_max:=input;
    end;

end.
