unit Popup_Directories;

{$MODE Delphi}

{ Version vom 7.2.2020 }

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, defaults, ComCtrls;

type
  TFormDir = class(TForm)
    ButtonOK:  TButton;
    ButtonCancel: TButton;
    EditDirSaveFw: TEdit;
    ButtonDirSaveFw: TButton;
    GroupBoxSave: TGroupBox;
    GroupBoxRead: TGroupBox;
    EditFilesLoad: TEdit;
    ButtonDirLoad: TButton;
    Text_Save_Fwd: TStaticText;
    EditDirSaveInv: TEdit;
    ButtonDirSaveInv: TButton;
    StaticText3: TStaticText;
    Text_Save_Inv: TStaticText;
    Text_Save_Fit: TStaticText;
    EditDirSaveFit: TEdit;
    ButtonDirSaveFit: TButton;
    procedure FormCreate(Sender: TObject);
//    procedure ChangeSize(Sender: TObject);
    procedure set_temp_parameters(Sender: TObject);
    procedure ButtonOKClick(Sender: TObject);
    procedure ButtonCancelClick(Sender: TObject);
    procedure ButtonDirSaveFwClick(Sender: TObject);
    procedure ButtonDirLoadClick(Sender: TObject);
    procedure ButtonDirSaveInvClick(Sender: TObject);
    procedure ButtonDirSaveFitClick(Sender: TObject);
  private
    fl_b_SaveFwd : boolean;
    fl_b_SaveInv : boolean;
    fl_b_LoadAll : boolean;
    fl_sv_table  : boolean;
    fl_b_Reset   : boolean;
    dir_svFwd    : String;
    dir_svInv    : String;
    dir_svFit    : String;
    dir_ldBatch  : String;
    ext_ldBatch  : String;
    Header_b     : integer;
    XColumn_b    : byte;
    YColumn_b    : byte;
  public
    tSpekName    : TStrings;
  end;

var
  FormDir: TFormDir;

implementation

{$R *.lfm}

procedure TFormDir.FormCreate(Sender: TObject);
begin
//    ClientWidth:=PopupDirW;
    fl_b_SaveFwd:=flag_b_SaveFwd;
    fl_b_SaveInv:=flag_b_SaveInv;
    fl_b_LoadAll:=flag_b_LoadAll;
    fl_b_Reset  :=flag_b_Reset;
    fl_sv_table :=flag_sv_table;
    Header_b    :=meas^.Header;
    XColumn_b   :=meas^.XColumn;
    YColumn_b   :=meas^.YColumn;
    ext_ldBatch:=ExtractFileExt(Name_LdBatch);
    dir_svFwd:=DIR_saveFwd;
    dir_svInv:=DIR_saveInv;
    dir_svFit:=DIR_saveFit;
    dir_ldBatch:=ExtractFileDir(Name_LdBatch);
    EditDirSaveFw.text:=DIR_svFwd;
    EditDirSaveInv.text:=DIR_svInv;
    EditDirSaveFit.text:=DIR_svFit;
    EditFilesLoad.text:=DIR_LdBatch;
    tSpekName:=nil;
    (*
    if ClientWidth<500 then ClientWidth:=500;
    GroupBoxRead.ClientWidth:=ClientWidth-2*GroupBoxRead.left;
    GroupBoxSave.ClientWidth:=ClientWidth-2*GroupBoxRead.left;
    ButtonDirLoad.Left:=ClientWidth-48;
    ButtonDirSaveFw.Left:=ClientWidth-48;
    ButtonDirSaveInv.Left:=ClientWidth-48;
    ButtonDirSaveFit.Left:=ClientWidth-48;
    EditFilesLoad.Width:=ClientWidth-191;
    EditDirSaveFw.Width:=ClientWidth-191;
    EditDirSaveInv.Width:=ClientWidth-191;
    EditDirSaveFit.Width:=ClientWidth-191;
    *)
    end;

(*
procedure TFormDir.ChangeSize(Sender: TObject);
begin
    if ClientWidth<500 then ClientWidth:=500;
    GroupBoxRead.ClientWidth:=ClientWidth-2*GroupBoxRead.left;
    GroupBoxSave.ClientWidth:=ClientWidth-2*GroupBoxRead.left;
    ButtonDirLoad.Left:=ClientWidth-48;
    ButtonDirSaveFw.Left:=ClientWidth-48;
    ButtonDirSaveInv.Left:=ClientWidth-48;
    ButtonDirSaveFit.Left:=ClientWidth-48;
    EditFilesLoad.Width:=ClientWidth-191;
    EditDirSaveFw.Width:=ClientWidth-191;
    EditDirSaveInv.Width:=ClientWidth-191;
    EditDirSaveFit.Width:=ClientWidth-191;
    PopupDirW:=ClientWidth;
    end;
*)

procedure TFormDir.set_temp_parameters(Sender: TObject);
begin
    flag_b_SaveFwd:=FormDir.fl_b_SaveFwd;
    flag_b_SaveInv:=FormDir.fl_b_SaveInv;
    flag_b_LoadAll:=FormDir.fl_b_LoadAll;
    flag_b_Reset  :=FormDir.fl_b_Reset;
    flag_sv_table :=FormDir.fl_sv_Table;
    DIR_saveFwd   :=FormDir.DIR_svFwd;
    DIR_saveInv   :=FormDir.DIR_svInv;
    DIR_saveFit   :=FormDir.DIR_svFit;
    meas^.Header  :=Header_b;
    meas^.XColumn :=XColumn_b;
    meas^.YColumn :=YColumn_b;
    Name_LdBatch  :=dir_ldBatch + '\*' + ext_ldBatch;
    end;


procedure TFormDir.ButtonOKClick(Sender: TObject);
begin
    ModalResult := mrOK;
    end;

procedure TFormDir.ButtonCancelClick(Sender: TObject);
begin
    ModalResult := mrCancel;
    end;


procedure TFormDir.ButtonDirSaveFitClick(Sender: TObject);
var S : string;
begin
    S:=dir_svFit;
    if SelectDirectory(S, [sdAllowCreate, sdPerformCreate, sdPrompt], 0)
        then begin
        dir_svFit:=S;
        EditDirSaveFit.Text:=S;
        EditDirSaveFit.refresh;
        end;
    end;

procedure TFormDir.ButtonDirSaveFwClick(Sender: TObject);
var S : String;
begin
    S:=dir_svFwd;
    if SelectDirectory(S, [sdAllowCreate, sdPerformCreate, sdPrompt], 0)
        then begin
        dir_svFwd:=S;
        EditDirSaveFw.Text:=S;
        EditDirSaveFw.refresh;
        end;
    end;

procedure TFormDir.ButtonDirLoadClick(Sender: TObject);
var S : String;
begin
    S:=dir_ldBatch;
    if SelectDirectory(S, [sdAllowCreate, sdPerformCreate, sdPrompt], 0)
        then begin
        dir_ldBatch:=S;
        EditFilesLoad.Text:=S;
        EditFilesLoad.refresh;
        end;
    end;

procedure TFormDir.ButtonDirSaveInvClick(Sender: TObject);
var S : String;
begin
    S:=dir_svInv;
    if SelectDirectory(S, [sdAllowCreate, sdPerformCreate, sdPrompt], 0)
        then begin
        dir_svInv:=S;
        EditDirSaveInv.Text:=S;
        EditDirSaveInv.refresh;
        end;
    end;

end.
