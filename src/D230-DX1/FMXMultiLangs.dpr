program FMXMultiLangs;

uses
  System.StartUpCopy,
  FMX.Forms,
  App.View.Main in '..\App\App.View.Main.pas' {frmMainForm},
  Comun.Utils.Langs in '..\App\Comun.Utils.Langs.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;

  Application.Initialize;
  Application.CreateForm(TfrmMainForm, frmMainForm);
  Application.Run;
end.
