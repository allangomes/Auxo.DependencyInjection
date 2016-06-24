unit Auxo.Sample.Basic;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  IFoo = interface
    function Hello: string;
  end;

  TBar = class(TInterfacedObject, IFoo)
  private
    function Hello: string;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var

begin

end;

{ TBar }

function TBar.Hello: string;
begin
  result := 'Hello World';
end;

end.
