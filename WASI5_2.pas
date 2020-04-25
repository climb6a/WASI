program WASI5_2;

{$MODE Delphi}

uses  Forms, Interfaces, gui, defaults, { uscaledpi,  new 25.4.2020 }
      Popup_Dataformat_Advanced in 'Popup_Dataformat_Advanced.pas' {FormDataFormatAdvanced};

{$R *.res}

begin
//  RequireDerivedFormResource := True; // new 25.4.2020
  Application.Initialize;
  Application.Title := 'WASI5.2';
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TFormDataFormatAdvanced, FormDataFormatAdvanced);
  if flag_background then begin
      Application.ShowMainForm := false;
      Form1.visible:=FALSE;
      end;
//  HighDPI(96);      // High DPI for all forms at once
                    // new 25.4.2020
  if error_INI=0 then Application.Run;
  end.
