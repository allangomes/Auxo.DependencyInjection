unit Auxo.DependencyInjection;

interface

uses
  System.SysUtils, System.Generics.Collections, System.Rtti, Auxo.Core.Reflection;

type
  IObjectFactory = interface
    procedure GetObject(var obj);
  end;

  TServiceProvider = class
  private
    FObjects: TDictionary<TRttiType, IObjectFactory>;
    constructor Create; reintroduce;
    procedure Add(AType: TRttiType; AStorage: IObjectFactory);
  public
    function GetService<I: IInterface>: I;
    destructor Destroy; override;
  end;

  TServiceCollection = class
  private
    FProvider: TServiceProvider;
  public
    procedure Singleton<I: IInterface; T: I>; overload;
    procedure Transient<I: IInterface; T: I>; overload;
    procedure Threading<I: IInterface; T: I>; overload;
    procedure Singleton<I: IInterface>(Factory: TFunc<TServiceProvider, I>); overload;
    procedure Transient<I: IInterface>(Factory: TFunc<TServiceProvider, I>); overload;
    procedure Threading<I: IInterface>(Factory: TFunc<TServiceProvider, I>); overload;
    function Build: TServiceProvider;
    constructor Create;
    destructor Destroy; override;
  end;


implementation

uses
  Auxo.DependencyInjection.ServiceFactories, Auxo.DependencyInjection.ServiceStorage;

{ TServiceProvider }

procedure TServiceProvider.Add(AType: TRttiType; AStorage: IObjectFactory);
begin
  FObjects.Add(AType, AStorage)
end;

constructor TServiceProvider.Create;
begin
  FObjects := TDictionary<TRttiType, IObjectFactory>.Create;
end;

destructor TServiceProvider.Destroy;
begin
  FObjects.Free;
  inherited;
end;

function TServiceProvider.GetService<I>: I;
var
  obj: TObject;
  guid: TGuid;
begin
  guid := TRttiInterfaceType(TReflection.GetType<I>).GUID;
  FObjects[TReflection.GetType<I>].GetObject(obj);
  obj.GetInterface(Guid, Result);
end;

{ TServiceCollection }

function TServiceCollection.Build: TServiceProvider;
begin
  Result := FProvider;
end;

constructor TServiceCollection.Create;
begin
  FProvider := TServiceProvider.Create;
end;

destructor TServiceCollection.Destroy;
begin
  FProvider.Free;
  inherited;
end;

procedure TServiceCollection.Singleton<I, T>;
begin
  FProvider.Add(TReflection.GetType<I>, TSingletonStorage.Create(TReflectionFactory.Create(TReflection.GetType<T>)));
end;

procedure TServiceCollection.Singleton<I>(Factory: TFunc<TServiceProvider, I>);
begin
  FProvider.Add(TReflection.GetType<I>, TSingletonStorage.Create(TFunctionFactory<I>.Create(Factory)));
end;

procedure TServiceCollection.Threading<I, T>;
begin
  FProvider.Add(TReflection.GetType<I>, TThreadingStorage.Create(TReflectionFactory.Create(TReflection.GetType<T>)));
end;


procedure TServiceCollection.Threading<I>(Factory: TFunc<TServiceProvider, I>);
begin
  FProvider.Add(TReflection.GetType<I>, TThreadingStorage.Create(TFunctionFactory<I>.Create(Factory)));
end;


procedure TServiceCollection.Transient<I, T>;
begin
  FProvider.Add(TReflection.GetType<I>, TReflectionFactory.Create(TReflection.GetType<T>));
end;


procedure TServiceCollection.Transient<I>(Factory: TFunc<TServiceProvider, I>);
begin
  FProvider.Add(TReflection.GetType<I>, TFunctionFactory<I>.Create(Factory));
end;

end.
