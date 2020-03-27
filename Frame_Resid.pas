unit Frame_Resid;

{$MODE Delphi}

{ Version vom 20.11.2000 }

interface

uses
  LCLIntf, LCLType, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, SCHOEN_, defaults;

type
  TFrame_Res = class(TFrame)
    Text_Iter: TStaticText;
    Iterations: TEdit;
    Text_Res: TStaticText;
    Residuum: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure update_parameterlist(Sender: TObject);

  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

implementation

{$R *.lfm}

procedure TFrame_Res.FormCreate(Sender: TObject);
begin
    update_parameterlist(Sender);
    end;

procedure TFrame_Res.update_parameterlist(Sender: TObject);
begin
    Iterations.Text:=schoen(NIter, 1);
    Residuum.Text:=schoen(Resid, 3);
    end;

end.
