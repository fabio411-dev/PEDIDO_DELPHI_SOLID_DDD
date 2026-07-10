unit Infra.Data.Repositories.ProdutoRepository;

interface

uses
  System.SysUtils,
  Generics.Collections,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  Domain.Interfaces.IProdutoRepository,
  Domain.Entities.Produto,
  Domain.ValueObjects.UnidadeMedida;

type
  TProdutoRepository = class(TInterfacedObject, IProdutoRepository)
  private
    FConnection: TFDConnection;
    function GetUnidadeMedida(AId: Integer): TUnidadeMedida;
  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;
    function FindById(AId: Integer): TProduto;
    function FindAll(APartialDesc : String): TObjectList<TProduto>;
    procedure Add(const AProduto: TProduto);
    procedure Update(const AProduto: TProduto);
    procedure Delete(AId: Integer);
  end;

implementation

constructor TProdutoRepository.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

destructor TProdutoRepository.Destroy;
begin
  inherited Destroy;
end;

function TProdutoRepository.GetUnidadeMedida(AId: Integer): TUnidadeMedida;
var
  qryAux : TFDQuery;
begin
  Result := nil;
  if AId = 0 then
    Exit;

  qryAux := TFDQuery.Create(nil);
  try
    qryAux.Connection := FConnection;
    qryAux.SQL.Text := 'SELECT IDUNIDADE, DESCRICAO, SIGLA ' +
                       '  FROM UNIDADE_MEDIDA              ' +
                       ' WHERE IDUNIDADE = :ID             ';
    qryAux.Params.ParamByName('ID').AsInteger := AId;
    qryAux.Open;

    if not qryAux.IsEmpty then
    begin
      Result := TUnidadeMedida.Create(
        qryAux.FieldByName('IDUNIDADE').AsInteger,
        qryAux.FieldByName('DESCRICAO').AsString,
        qryAux.FieldByName('SIGLA').AsString);
    end;
  finally
    qryAux.Free;
  end;
end;

function TProdutoRepository.FindById(AId: Integer): TProduto;
var
  qryAux: TFDQuery;
begin
  Result := nil;
  qryAux := TFDQuery.Create(nil);
  try
    qryAux.Connection := FConnection;
    qryAux.SQL.Text := 'SELECT IDPRODUTO, IDUNIDADE, DESCRICAO, PRECO_VENDA '+
                       '  FROM PRODUTO                                      '+
                       ' WHERE IDPRODUTO = :ID                              ';
    qryAux.Params.ParamByName('ID').AsInteger := AId;
    qryAux.Open;

    if not qryAux.IsEmpty then
    begin
      Result := TProduto.Create(
        qryAux.FieldByName('IDPRODUTO').AsInteger,
        qryAux.FieldByName('DESCRICAO').AsString,
        qryAux.FieldByName('PRECO_VENDA').AsCurrency);

      if not qryAux.FieldByName('IDUNIDADE').IsNull then
        Result.UnidadeMedida := GetUnidadeMedida(qryAux.FieldByName('IDUNIDADE').AsInteger);
    end;
  finally
    qryAux.Free;
  end;
end;

function TProdutoRepository.FindAll(APartialDesc : String): TObjectList<TProduto>;
var
  qryAux: TFDQuery;
  objProduto : TProduto;
begin
  Result := TObjectList<TProduto>.Create(True);
  qryAux := TFDQuery.Create(nil);
  try
    qryAux.Connection := FConnection;
    qryAux.SQL.Text := 'SELECT IDPRODUTO, IDUNIDADE, DESCRICAO, PRECO_VENDA '+
                       '  FROM PRODUTO                                      '+
                       ' WHERE DESCRICAO LIKE ''%' + APartialDesc + '%''';
    qryAux.Open;

    while not qryAux.Eof do
    begin
      objProduto := TProduto.Create(
        qryAux.FieldByName('IDPRODUTO').AsInteger,
        qryAux.FieldByName('DESCRICAO').AsString,
        qryAux.FieldByName('PRECO_VENDA').AsCurrency);

      if not qryAux.FieldByName('IDUNIDADE').IsNull then
        objProduto.UnidadeMedida := GetUnidadeMedida(qryAux.FieldByName('IDUNIDADE').AsInteger);

      Result.Add(objProduto);
      qryAux.Next;
    end;
  finally
    qryAux.Free;
  end;
end;

procedure TProdutoRepository.Add(const AProduto: TProduto);
var
  qryAux: TFDQuery;
begin
  qryAux := TFDQuery.Create(nil);
  try
    qryAux.Connection := FConnection;
    qryAux.SQL.Text := 'INSERT INTO PRODUTO                       '+
                       '      (IDUNIDADE, DESCRICAO, PRECO_VENDA) '+
                       ' VALUES (:IDUN, :DESC, :PRECO)            ';

    if Assigned(APRODUTO.UnidadeMedida) then
      qryAux.Params.ParamByName('IDUN').AsInteger := APRODUTO.UnidadeMedida.IdUnidadeMedida
    else
      qryAux.Params.ParamByName('IDUN').Clear;

    qryAux.Params.ParamByName('DESC').AsString  := AProduto.Descricao;
    qryAux.Params.ParamByName('PRECO').AsCurrency := AProduto.Precovenda;
    qryAux.ExecSQL;
  finally
    qryAux.Free;
  end;
end;

procedure TProdutoRepository.Update(const AProduto: TProduto);
var
  qryAux: TFDQuery;
begin
  qryAux := TFDQuery.Create(nil);
  try
    qryAux.Connection := FConnection;
    qryAux.SQL.Text := 'UPDATE PRODUTO                                                         '+
                       '   SET IDUNIDADE = :IDUNIDADE, DESCRICAO = :DESC, PRECO_VENDA = :PRECO '+
                       ' WHERE IDPRODUTO = :IDPRODUTO                                          ';

    if Assigned(APRODUTO.UnidadeMedida) then
      qryAux.Params.ParamByName('IDUNIDADE').AsInteger := APRODUTO.UnidadeMedida.IdUnidadeMedida
    else
      qryAux.Params.ParamByName('IDUNIDADE').Clear;

    qryAux.Params.ParamByName('DESC').AsString  := AProduto.Descricao;
    qryAux.Params.ParamByName('PRECO').AsCurrency := AProduto.Precovenda;
    qryAux.Params.ParamByName('IDPRODUTO').AsInteger := AProduto.IdProduto;
    qryAux.ExecSQL;
  finally
    qryAux.Free;
  end;
end;

procedure TProdutoRepository.Delete(AId: Integer);
var
  qryAux: TFDQuery;
begin
  qryAux := TFDQuery.Create(nil);
  try
    qryAux.Connection := FConnection;
    qryAux.SQL.Text := 'DELETE                         '+
                       '  FROM PRODUTO                '+
                       ' WHERE IDPRODUTO = :IDPRODUTO ';
    qryAux.Params.ParamByName('IDPRODUTO').AsInteger := AId;
    qryAux.ExecSQL;
  finally
    qryAux.Free;
  end;
end;

end.

