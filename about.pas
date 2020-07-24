unit About;

{$MODE Delphi}

{ Version vom 4.1.2010 }

interface

uses LCLIntf, LCLType, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, SysUtils, defaults;

type

  { TAboutBox }

  TAboutBox = class(TForm)
    OKButton: TButton;
    Panel1: TPanel;
    ProgramName: TLabel;
    Copyright: TLabel;
    LabelVersion: TLabel;
    Label1: TLabel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure OKButtonClick(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

procedure ShowAboutBox;

implementation

{$R *.lfm}


procedure ShowAboutBox;
begin
  with TAboutBox.Create(Application) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TAboutBox.FormCreate(Sender: TObject);
begin
    ProgramName.Caption :=ProgramInfo;
    LabelVersion.Caption:=vers;
    end;

procedure TAboutBox.OKButtonClick(Sender: TObject);
begin

end;

procedure TAboutBox.Panel1Click(Sender: TObject);
begin

end;

end.

