unit Auxo.Sample.Basic;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Auxo.DependencyInjection;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    Services: TServiceProvider;
    ServicesCollection: TServiceCollection;
  public
    { Public declarations }
  end;

  IFoo = interface
    function Hello: string;
  end;

  TBar = class(TInterfacedObject, IFoo)
  public
    function Hello: string;
    constructor Create;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  foo: IFoo;
  Hello: string;
begin
  foo := Services.GetService<IFoo>;
  Hello := foo.Hello;
  ShowMessage(Hello);

  foo := Services.GetService<IFoo>;
  Hello := foo.Hello;
  ShowMessage(Hello);
end;

{ TBar }

constructor TBar.Create;
begin
  ShowMessage('')
end;

function TBar.Hello: string;
begin
  result := 'Pointer ';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ServicesCollection := TServiceCollection.Create;
  Services := ServicesCollection.Build;
  ServicesCollection.Singleton<IFoo, TBar>;
end;

end.
