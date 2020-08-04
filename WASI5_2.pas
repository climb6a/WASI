program WASI5_2;

{$MODE Delphi}

uses  Forms, Interfaces, gui, defaults,
      Popup_Dataformat_Advanced in 'Popup_Dataformat_Advanced.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'WASI5.2';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormDataFormatAdvanced, FormDataFormatAdvanced);
  Application.Scaled:=TRUE;
  if flag_background then begin
      Application.ShowMainForm := false;
      Form1.visible:=FALSE;
      end;
  if error_INI=0 then Application.Run;
  end.
