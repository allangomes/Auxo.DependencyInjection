unit Auxo.DependencyInjection.ServiceStorage;

interface

uses
  Auxo.DependencyInjection,
  System.Generics.Collections;

type
  TThreadingStorage = class(TInterfacedObject, IObjectFactory)
  private
    FFactory: IObjectFactory;
    FObjects: TDictionary<Integer, TObject>;
  public
    constructor Create(AFactory: IObjectFactory);
    procedure GetObject(var obj);
  end;

  TSingletonStorage = class(TInterfacedObject, IObjectFactory)
  private
    FFactory: IObjectFactory;
    FObject: TObject;
  public
    constructor Create(AFactory: IObjectFactory);
    destructor Destroy;
    procedure GetObject(var obj);
  end;

implementation

uses
  System.Classes;

{ TThreadingStorage }

constructor TThreadingStorage.Create(AFactory: IObjectFactory);
begin
  FFactory := AFactory;
end;

procedure TThreadingStorage.GetObject(var obj);
begin
  if FObjects.ContainsKey(TThread.CurrentThread.ThreadId) then
  begin
    TObject(obj) := FObjects[TThread.CurrentThread.ThreadId];
    Exit;
  end;
  FFactory.GetObject(obj);
  FObjects.Add(TThread.CurrentThread.ThreadId, TObject(obj));
end;

{ TSingletonStorage }

constructor TSingletonStorage.Create(AFactory: IObjectFactory);
begin
  FFactory := AFactory;
end;

destructor TSingletonStorage.Destroy;
begin
  FObject := nil;
end;

procedure TSingletonStorage.GetObject(var obj);
var
  I: IInterface;
begin
  if Assigned(FObject) then
  begin
    TObject(obj) := FObject;
    Exit;
  end;
  FFactory.GetObject(FObject);
  FObject.GetInterface(TGuid.Empty, I);
  I._AddRef;
  TObject(obj) := FObject;
end;

end.
