program Basic;

uses
  Vcl.Forms,
  Auxo.Sample.Basic in 'Auxo.Sample.Basic.pas' {Form1},
  Auxo.DependencyInjection in '..\..\Auxo.DependencyInjection.pas',
  Auxo.DependencyInjection.ServiceFactories in '..\..\Auxo.DependencyInjection.ServiceFactories.pas',
  Auxo.DependencyInjection.ServiceStorage in '..\..\Auxo.DependencyInjection.ServiceStorage.pas',
  Auxo.Core.Enumerator in '..\..\..\Core\Auxo.Core.Enumerator.pas',
  Auxo.Core.Message in '..\..\..\Core\Auxo.Core.Message.pas',
  Auxo.Core.Observer in '..\..\..\Core\Auxo.Core.Observer.pas',
  Auxo.Core.PleaseWait in '..\..\..\Core\Auxo.Core.PleaseWait.pas',
  Auxo.Core.Reflection in '..\..\..\Core\Auxo.Core.Reflection.pas',
  Auxo.Core.Strings in '..\..\..\Core\Auxo.Core.Strings.pas',
  Auxo.Core.Threading in '..\..\..\Core\Auxo.Core.Threading.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
