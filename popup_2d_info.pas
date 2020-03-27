unit Popup_2D_Info;
{ Version vom 15.9.2018 }

{$mode delphi}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  ValEdit, StdCtrls, defaults;

type

  { TForm_2D_Info }

  TForm_2D_Info = class(TForm)
    List_PixInfo: TValueListEditor;
    List_ParNames: TValueListEditor;
    List_LatLong: TValueListEditor;
    List_Statistics: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure ShowPixInfo(Sender: TObject);
    procedure ShowStatistics(Sender: TObject);
  private
    procedure ShowBandInfo(Sender: TObject);
  public

  end;

var
  Form_2D_Info: TForm_2D_Info;

implementation

{$R *.lfm}

procedure TForm_2D_Info.FormCreate(Sender: TObject);
begin
    ShowPixInfo(Sender);
    ShowStatistics(Sender);
    List_ParNames.visible:=FALSE;
    List_Statistics.visible:=FALSE;
    if AnsiUpperCase(ExtractFileExt(HSI_img^.FName))='.FIT' then begin
        List_ParNames.visible:=TRUE;
        ShowBandInfo(Sender);
        end;
    end;

procedure TForm_2D_Info.ShowPixInfo(Sender: TObject);
{ Show pixel values at cursor position. }
begin
with List_PixInfo do begin
    Top:=List_LatLong.Top + List_LatLong.Height + 8;
    if flag_3bands then RowCount:=4 else RowCount:=2;
    Height:=RowCount*DefaultRowHeight+4;
    AutoAdjustColumns;
    end;
    end;

procedure TForm_2D_Info.ShowBandInfo(Sender: TObject);
{ Display parameter names of files *.FIT. }
var b : integer;
begin
with List_ParNames do begin
    Left:=List_LatLong.Left + List_LatLong.width + 8;
    if List_PixInfo.width > List_LatLong.width then
        Left:=List_PixInfo.Left + List_PixInfo.width + 8;
    RowCount:=1;
    for b:=1 to Channel_number do
        InsertRow(inttostr(b), bandname[b], TRUE);
    Height:=RowCount*DefaultRowHeight+4;
    AutoAdjustColumns;
    end;
    end;

procedure TForm_2D_Info.ShowStatistics(Sender: TObject);
{ Show mean and standard deviation of selected area. }
{ Handling of StringGrids is described here:
  http://wiki.lazarus.freepascal.org/Grids_Reference_Page#procedure_AutoSizeColumn.28aCol:_Integer.29.3B }
var i, w : integer;
begin
with List_Statistics do begin
    if flag_3bands then RowCount:=4 else RowCount:=2;
    Height:=RowCount*DefaultRowHeight+4;
    AutoAdjustColumns;
    w:=0;
    for i:=0 to ColCount-1 do
        w:=w+columns[i].Width;
    Width:=w+4;
    Top:=List_PixInfo.Top + List_PixInfo.Height + 8;
    end;
    end;



end.

