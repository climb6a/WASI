unit popup_info;
{ Version vom 25.10.2018 }

{$mode delphi}

interface

uses
{  FileUtil, Graphics, windows;  }
LCLIntf, LCLType, SysUtils, Variants, Classes, Graphics, Controls, Forms,
Dialogs, StdCtrls, ExtCtrls, ValEdit, windows;

type

  { TMem_Info }

  TMem_Info = class(TForm)
    OKButton: TButton;
    MemoryList: TValueListEditor;
    procedure FormCreate(Sender: TObject);
    procedure MemoryListClick(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure ShowMemory(Sender: TObject);
  private
  public

  end;

var   Mem_Info: TMem_Info;


implementation

type
  TMemoryStatusEx = packed record
    dwLength: DWORD;
    dwMemoryLoad: DWORD;
    ullTotalPhys: Int64;
    ullAvailPhys: Int64;
    ullTotalPageFile: Int64;
    ullAvailPageFile: Int64;
    ullTotalVirtual: Int64;
    ullAvailVirtual: Int64;
    ullAvailExtendedVirtual: Int64;
  end;

{$R *.lfm}

procedure TMem_Info.OKButtonClick(Sender: TObject);
begin
  ModalResult := mrOK;
  end;

procedure TMem_Info.FormCreate(Sender: TObject);
begin
    ShowMemory(Sender);
    end;

procedure TMem_Info.MemoryListClick(Sender: TObject);
begin

end;

function GlobalMemoryStatusEx(var lpBuffer: TMemoryStatusEx): BOOL; stdcall; external kernel32;

procedure TMem_Info.ShowMemory(Sender: TObject);
var  Status: TMemoryStatusEx;
begin
    ZeroMemory(@Status, SizeOf(TMemoryStatusEx));
    Status.dwLength := SizeOf(TMemoryStatusEx);
    GlobalMemoryStatusEx(Status);
    MemoryList.Rows[1].CommaText := '"RAM total"' + IntToStr(Status.ullTotalPhys div (1024*1024))+' MB';
    MemoryList.Rows[2].CommaText := '"RAM free"' + IntToStr(Status.ullAvailPhys div (1024*1024))+' MB';
    MemoryList.Rows[3].CommaText := '"Pagefile total"' + IntToStr(Status.ullTotalPageFile div (1024*1024))+' MB';
    MemoryList.Rows[4].CommaText := '"Pagefile free"' + IntToStr(Status.ullAvailPageFile div (1024*1024))+' MB';
    MemoryList.Rows[5].CommaText := '"Virtual total"' + IntToStr(Status.ullTotalVirtual div (1024*1024))+' MB';
    MemoryList.Rows[6].CommaText := '"Virtual free"' + IntToStr(Status.ullAvailVirtual div (1024*1024))+' MB';
    MemoryList.AutoAdjustColumns;
    end;

end.

