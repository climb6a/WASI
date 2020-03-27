unit Frame_Batch;

{$MODE Delphi}

{ Version vom 16.5.2019 }

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, SCHOEN_, defaults;

type

  { TFrameBatch }

  TFrameBatch = class(TFrame)
    Panel2Hide: TPanel;
    RangeText3: TStaticText;
    StaticText3: TStaticText;
    ComboPar1: TComboBox;     // The actual values are in gui.lfm
    ComboPar2: TComboBox;     // The actual values are in gui.lfm
    ComboPar3: TComboBox;     // The actual values are in gui.lfm
    StaticText7: TStaticText;
    StaticText11: TStaticText;
    StaticText12: TStaticText;
    Log1: TCheckBox;
    Log2: TCheckBox;
    Log3: TCheckBox;
    Start2: TEdit;
    Start1: TEdit;
    Start3: TEdit;
    End1: TEdit;
    End2: TEdit;
    End3: TEdit;
    Steps1: TEdit;
    Steps2: TEdit;
    Steps3: TEdit;
    CheckInvert: TCheckBox;
    CheckBatch: TCheckBox;
    CheckReadFile: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure update_parameterlist(Sender: TObject);
    procedure ComboPar1Change(Sender: TObject);
    procedure ComboPar2Change(Sender: TObject);
    procedure ComboPar3Change(Sender: TObject);
    procedure Start1Change(Sender: TObject);
    procedure Start2Change(Sender: TObject);
    procedure Start3Change(Sender: TObject);
    procedure End1Change(Sender: TObject);
    procedure End2Change(Sender: TObject);
    procedure End3Change(Sender: TObject);
    procedure Steps1Change(Sender: TObject);
    procedure Steps2Change(Sender: TObject);
    procedure Steps3Change(Sender: TObject);
    procedure Log1Click(Sender: TObject);
    procedure Log2Click(Sender: TObject);
    procedure Log3Click(Sender: TObject);
    procedure CheckInvertClick(Sender: TObject);
    procedure CheckBatchClick(Sender: TObject);
    procedure CheckReadFileClick(Sender: TObject);
  private
    input : single;
    error : integer;
  public
    { Public-Deklarationen }
  end;


implementation

{$R *.lfm}

procedure TFrameBatch.FormCreate(Sender: TObject);
var i : integer;
begin
    Panel2Hide.Left:=ComboPar1.Left;
    Panel2Hide.Width:=Log1.Left+Log1.Width-ComboPar1.Left;
    Panel2Hide.Top:=0;
    Panel2Hide.Height:=Height;
    Panel2Hide.Color:=clDefault;
    for i:=1 to M1 do begin
        ComboPar1.items[i]:=par.name[i];
        ComboPar2.items[i]:=par.name[i];
        ComboPar3.items[i]:=par.name[i];
        end;
    update_parameterlist(Sender);
    end;


procedure TFrameBatch.update_parameterlist(Sender: TObject);
begin
    Height:=DY_batch;
    ComboPar1.ItemIndex:=Par1_Type;
    ComboPar2.ItemIndex:=Par2_Type;
    ComboPar3.ItemIndex:=Par3_Type;
    Start1.Text:=schoen(Par1_Min, 3);
    Start2.Text:=schoen(Par2_Min, 3);
    Start3.Text:=schoen(Par3_Min, 3);
    End1.Text  :=schoen(Par1_Max, 3);
    End2.Text  :=schoen(Par2_Max, 3);
    End3.Text  :=schoen(Par3_Max, 3);
    Steps1.Text:=schoen(Par1_N,   0);
    Steps2.Text:=schoen(Par2_N,   0);
    Steps3.Text:=schoen(Par3_N,   0);
    Log1.checked:=Par1_log=TRUE;
    Log2.checked:=Par2_log=TRUE;
    Log3.checked:=Par3_log=TRUE;
    if not flag_2D_inv then begin  // 1D mode
        CheckInvert.checked:=flag_b_Invert;
        CheckReadFile.checked:=flag_b_LoadAll or flag_loadFile;
        CheckBatch.checked:=flag_batch;
        CheckBatch.visible:=flag_b_Invert;
        CheckReadFile.visible:=flag_b_Invert;
        if flag_b_Invert then Panel2Hide.visible:=
                              flag_b_LoadAll or not flag_batch
                         else Panel2Hide.visible:=FALSE;
        end
    else begin  // 2D mode
        CheckInvert.visible:=TRUE;
        CheckBatch.visible:=TRUE;
        CheckReadFile.visible:=TRUE;

        CheckInvert.checked:=flag_b_invert;
        CheckBatch.checked:=flag_batch;
        CheckReadFile.checked:=flag_b_loadAll;

        CheckInvert.refresh;
        CheckBatch.refresh;
        CheckReadFile.refresh;
        Panel2Hide.visible:=TRUE;
        end;
    end;

procedure TFrameBatch.ComboPar1Change(Sender: TObject);
begin
    Par1_Type:=ComboPar1.ItemIndex;
    end;

procedure TFrameBatch.ComboPar2Change(Sender: TObject);
begin
    Par2_Type:=ComboPar2.ItemIndex;
    end;

procedure TFrameBatch.ComboPar3Change(Sender: TObject);
begin
    Par3_Type:=ComboPar3.ItemIndex;
    end;

procedure TFrameBatch.Start1Change(Sender: TObject);
begin
    val(Start1.Text, input, error);
    if error=0 then Par1_Min:=input;
    end;

procedure TFrameBatch.Start2Change(Sender: TObject);
begin
    val(Start2.Text, input, error);
    if error=0 then Par2_Min:=input;
    end;

procedure TFrameBatch.Start3Change(Sender: TObject);
begin
    val(Start3.Text, input, error);
    if error=0 then Par3_Min:=input;
    end;

procedure TFrameBatch.End1Change(Sender: TObject);
begin
    val(End1.Text, input, error);
    if error=0 then Par1_Max:=input;
    end;

procedure TFrameBatch.End2Change(Sender: TObject);
begin
    val(End2.Text, input, error);
    if error=0 then Par2_Max:=input;
    end;

procedure TFrameBatch.End3Change(Sender: TObject);
begin
    val(End3.Text, input, error);
    if error=0 then Par3_Max:=input;
    end;

procedure TFrameBatch.Steps1Change(Sender: TObject);
begin
    val(Steps1.Text, input, error);
    if error=0 then Par1_N:=round(input);
    end;

procedure TFrameBatch.Steps2Change(Sender: TObject);
begin
    val(Steps2.Text, input, error);
    if error=0 then Par2_N:=round(input);
    end;

procedure TFrameBatch.Steps3Change(Sender: TObject);
begin
    val(Steps3.Text, input, error);
    if error=0 then Par3_N:=round(input);
    end;

procedure TFrameBatch.Log1Click(Sender: TObject);
begin
    if Log1.checked then begin
        Par1_Log:=TRUE;
        if Par1_Min<nenner_min then begin
            Par1_min:=nenner_Min;
            Start1.Text:=schoen(Par1_Min, 3);
            Start1.refresh;
            end;
        if Par1_Max<nenner_min then begin
            Par1_max:=2*nenner_min;
            End1.Text:=schoen(Par1_max, 3);
            End1.refresh;
            end;
        end
    else Par1_Log:=FALSE;
    end;

procedure TFrameBatch.Log2Click(Sender: TObject);
begin
    if Log2.checked then begin
        Par2_Log:=TRUE;
        if Par2_Min<nenner_min then begin
            Par2_min:=nenner_Min;
            Start2.Text:=schoen(Par2_Min, 3);
            Start2.refresh;
            end;
        if Par2_Max<nenner_min then begin
            Par2_max:=2*nenner_min;
            End2.Text:=schoen(Par2_max, 3);
            End2.refresh;
            end;
        end
    else Par2_Log:=FALSE;
    end;

procedure TFrameBatch.Log3Click(Sender: TObject);
begin
    if Log3.checked then begin
        Par3_Log:=TRUE;
        if Par3_Min<nenner_min then begin
            Par3_min:=nenner_Min;
            Start3.Text:=schoen(Par3_Min, 3);
            Start3.refresh;
            end;
        if Par3_Max<nenner_min then begin
            Par3_max:=2*nenner_min;
            End3.Text:=schoen(Par3_max, 3);
            End3.refresh;
            end;
        end
    else Par3_Log:=FALSE;
    end;


procedure TFrameBatch.CheckInvertClick(Sender: TObject);
{ The check box named "CheckInvert" sets the flag "flag_b_Invert".
  Its caption is "invert spectra" in the 1D mode and "invert image" in the 2D mode.
  In the 1D mode, the check box switches between forward simulation
  (flag_b_Invert = FALSE) and inversion (flag_b_Invert = TRUE).
  In the 2D mode, flag_b_Invert determines if all image pixels are fitted (TRUE)
  or only a selected number of pixels is fitted (FALSE). }
begin
    flag_b_Invert:=CheckInvert.checked;
    flag_panel_fw:=not flag_b_invert;
    if flag_b_Invert and flag_2D_inv then begin     // 2D mode
        flag_batch:=FALSE;
        flag_b_loadAll:=FALSE;
        flag_use_ROI:=FALSE;
        // delete ROI selection
        frame_min:=0; frame_max:=0;
        pixel_min:=0; pixel_max:=0;
        end
    else begin                                      // 1D mode
        if not flag_b_Invert then flag_batch:=TRUE; // 1D forward mode
        end;
    end;

procedure TFrameBatch.CheckBatchClick(Sender: TObject);
{ The check box named "CheckBatch" sets the flag "flag_batch".
  It is not visible in the 1D forward mode.
  Its caption is "batch mode" in the 1D mode and "invert area" in the 2D mode.
  In the 1D mode, flag_batch = TRUE initializes processing of a series of spectra.
  In the 2D mode, flag_batch = TRUE initializes processing of a subset of image
  pixels (defined by a rectangle with coordinates frame_min, frame_max, pixel_min,
  pixel_max). }
begin
    flag_batch:=CheckBatch.checked;
    if flag_batch and flag_2D_inv then begin        // 2D mode
        flag_use_ROI:=TRUE;
        flag_b_invert:=FALSE;
        flag_b_loadAll:=FALSE;
        flag_panel_fw:=FALSE;
        end;
    end;

procedure TFrameBatch.CheckReadFileClick(Sender: TObject);
{ The check box named "CheckReadFile" sets the flag "flag_b_LoadAll".
  It is not visible in the 1D forward mode.
  Its caption is "read from file" in the 1D mode and "invert spectrum" in the 2D mode.
  In the 1D mode, flag_b_LoadAll = TRUE specifies that the processed spectra are
  imported from file, otherwise they are simulated in the forward mode. The first
  case usually represents analysis of measurements, while the second case is
  intended for sensitivity analysis.
  In the 2D mode, flag_b_LoadAll = TRUE specifies that only a single spectrum
  will be inverted, which can be either from a single pixel or an average of
  several pixels. }
begin
    flag_b_LoadAll:=CheckReadFile.checked;
    if flag_b_LoadAll and flag_2D_inv then begin    // 2D mode
        flag_b_invert:=FALSE;
        flag_batch:=FALSE;
        flag_use_ROI:=FALSE;
        flag_panel_fw:=FALSE;
        end;
    end;

end.
