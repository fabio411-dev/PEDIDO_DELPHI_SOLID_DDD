unit Infra.Data.Repositories.UnidadeMedidaRepository;

interface

uses
  System.SysUtils,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Comp.Client,
  Domain.ValueObjects.UnidadeMedida,
  Domain.Interfaces.IUnidadeMedidaRepository,
  System.Generics.Collections;

type
  TUnidadeMedidaRepository = class(TInterfacedObject, IUnidadeMedidaRepository)
  private
    FConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);
    function GetAll: TObjectList<TUnidadeMedida>;
  end;

implementation

{ TUnidadeMedidaRepository }

constructor TUnidadeMedidaRepository.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

function TUnidadeMedidaRepository.GetAll: TObjectList<TUnidadeMedida>;
var
  qryAux : TFDQuery;
begin
  Result := TObjectList<TUnidadeMedida>.Create(True);
  qryAux := TFDQuery.Create(nil);
  try
    qryAux.Connection := FConnection;
    qryAux.SQL.Text :=
      'SELECT IDUNIDADE, DESCRICAO, SIGLA '+
      '  FROM UNIDADE_MEDIDA              '+
      ' ORDER BY DESCRICAO                ';
    qryAux.Open;

    while not qryAux.Eof do
    begin
      Result.Add(
        TUnidadeMedida.Create(
          qryAux.FieldByName('IDUNIDADE').AsInteger,
          qryAux.FieldByName('DESCRICAO').AsString,
          qryAux.FieldByName('SIGLA').AsString));
      qryAux.Next;
    end;
  finally
    qryAux.Free;
  end;
end;

end.

