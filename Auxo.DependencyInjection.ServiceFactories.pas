unit Auxo.DependencyInjection.ServiceFactories;

interface

uses
  System.SysUtils, System.Generics.Collections, Auxo.DependencyInjection, System.Rtti;

type
  TFunctionFactory<I> = class(TInterfacedObject, IObjectFactory)
  private
    FConstructor: TFunc<TServiceProvider, I>;
  public
    procedure GetObject(var obj);
    constructor Create(AConstructor: TFunc<TServiceProvider, I>);
  end;

  TReflectionFactory = class(TInterfacedObject, IObjectFactory)
  private
    FType: TRttiType;
  public
    procedure GetObject(var obj);
    constructor Create(AType: TRttiType);
  end;

implementation


{ TReflectionFactory }

constructor TReflectionFactory.Create(AType: TRttiType);
begin
  FType := AType;
end;

procedure TReflectionFactory.GetObject(var obj);
begin
  TObject(obj) := FType.AsInstance.GetMethod('Create').Invoke(FType.AsInstance.MetaclassType, []).AsObject;
end;

{ TFunctionFactory<I> }

constructor TFunctionFactory<I>.Create(AConstructor: TFunc<TServiceProvider, I>);
begin
  FConstructor := AConstructor;
end;

procedure TFunctionFactory<I>.GetObject(var obj);
begin
  I(obj) := FConstructor(nil);
end;

end.
