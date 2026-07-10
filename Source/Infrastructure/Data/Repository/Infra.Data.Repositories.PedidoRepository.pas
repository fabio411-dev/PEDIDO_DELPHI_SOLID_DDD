unit Infra.Data.Repositories.PedidoRepository;

interface

uses
  System.SysUtils,
  Generics.Collections,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  Domain.Interfaces.IPedidoRepository,
  Infra.Data.Repositories.ClienteRepository,
  Domain.Entities.Pedido,
  Domain.Entities.PedidoItem,
  Domain.Entities.Produto,
  Domain.Entities.Cliente;

type
  TPedidoRepository = class(TInterfacedObject, IPedidoRepository)
  private
    FConnection: TFDConnection;
    objClienteRepo : TClienteRepository;
    function GetNextId(const AGenName: string): Integer;
    function GetProductById(AId: Integer): TProduto;
  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;
    function FindById(AId: Integer): TPedido;
    function FindAll(APartialDesc : String): TObjectList<TPedido>;
    procedure Add(const APedido: TPedido);
    procedure Update(const APedido: TPedido);
    procedure Delete(AId: Integer);
  end;

implementation

constructor TPedidoRepository.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;

  objClienteRepo := TClienteRepository.Create(FConnection);
end;

destructor TPedidoRepository.Destroy;
begin
  inherited Destroy;
end;

function TPedidoRepository.GetNextId(const AGenName: string): Integer;
var
  qryAux: TFDQuery;
begin
  qryAux := TFDQuery.Create(nil);
  try
    qryAux.Connection := FConnection;
    qryAux.SQL.Text := Format('SELECT GEN_ID(%s,1) AS NEXT FROM RDB$DATABASE', [AGenName]);
    qryAux.Open;
    Result := qryAux.FieldByName('NEXT').AsInteger;
  finally
    qryAux.Free;
  end;
end;

function TPedidoRepository.GetProductById(AId: Integer): TProduto;
var
  qryAux: TFDQuery;
begin
  Result := nil;
  qryAux := TFDQuery.Create(nil);
  try
    qryAux.Connection := FConnection;
    qryAux.SQL.Text := 'SELECT IDPRODUTO, DESCRICAO, PRECO_VENDA '+
                       '  FROM PRODUTO                           '+
                       ' WHERE IDPRODUTO = :ID                   ';
    qryAux.Params.ParamByName('ID').AsInteger := AId;
    qryAux.Open;

    if not qryAux.IsEmpty then
    begin
      Result := TProduto.Create(
        qryAux.FieldByName('IDPRODUTO').AsInteger,
        qryAux.FieldByName('DESCRICAO').AsString,
        qryAux.FieldByName('PRECO_VENDA').AsCurrency);
    end;
  finally
    qryAux.Free;
  end;
end;

function TPedidoRepository.FindById(AId: Integer): TPedido;
var
  qryAux, qryAuxItem: TFDQuery;
  objPedido : TPedido;
  objPedidoItem : TPedidoItem;
  objProduto : TProduto;
begin
  Result := nil;
  qryAux := TFDQuery.Create(nil);
  try
    qryAux.Connection := FConnection;
    qryAux.SQL.Text := 'SELECT IDPEDIDO, IDPESSOA, DATA_PEDIDO, VALOR_TOTAL '+
                       '  FROM PEDIDO                                       '+
                       ' WHERE IDPEDIDO = :ID                               ';
    qryAux.Params.ParamByName('ID').AsInteger := AId;
    qryAux.Open;

    if not qryAux.IsEmpty then
    begin
      objPedido := TPedido.Create(qryAux.FieldByName('IDPEDIDO').AsInteger, nil);

      objPedido.DataPedido  := qryAux.FieldByName('DATA_PEDIDO').AsDateTime;

      if qryAux.FieldByName('IDPESSOA').AsInteger > 0 then
      begin
        objPedido.Cliente  := objClienteRepo.FindById( qryAux.FieldByName('IDPESSOA').AsInteger);
      end;

      qryAuxItem := TFDQuery.Create(nil);
      try
        qryAuxItem.Connection := FConnection;
        qryAuxItem.SQL.Text := ' SELECT IDPEDIDOITEM, IDPRODUTO, QTDE, VALOR_UNIT '+
                               '   FROM PEDIDO_ITEM                               '+
                               '  WHERE IDPEDIDO = :ID                            ';
        qryAuxItem.Params.ParamByName('ID').AsInteger := AId;
        qryAuxItem.Open;

        while not qryAuxItem.Eof do
        begin
          objProduto := GetProductById(qryAuxItem.FieldByName('IDPRODUTO').AsInteger);

          if Assigned(objProduto) then
          begin
            objPedidoItem := TPedidoItem.Create(
              qryAuxItem.FieldByName('IDPEDIDOITEM').AsInteger,
              AId,
              objProduto,
              qryAuxItem.FieldByName('QTDE').AsFloat,
              qryAuxItem.FieldByName('VALOR_UNIT').AsCurrency);

            objPedido.AddItem(objPedidoItem);
          end;
          qryAuxItem.Next;
        end;
      finally
        qryAuxItem.Free;
      end;

      Result := objPedido;
    end;
  finally
    qryAux.Free;
  end;
end;

function TPedidoRepository.FindAll(APartialDesc : String): TObjectList<TPedido>;
var
  qryAux: TFDQuery;
begin
  Result := TObjectList<TPedido>.Create(True);
  qryAux := TFDQuery.Create(nil);
  try
    qryAux.Connection := FConnection;
    qryAux.SQL.Text := 'SELECT IDPEDIDO                                         '+
                       '  FROM PEDIDO                                           '+
                       ' INNER JOIN PESSOA ON PESSOA.IDPESSOA = PEDIDO.IDPESSOA '+
                       ' WHERE NOME LIKE ''%' + APartialDesc + '%''             ';
    qryAux.Open;

    while not qryAux.Eof do
    begin
      Result.Add(FindById(qryAux.FieldByName('IDPEDIDO').AsInteger));
      qryAux.Next;
    end;
  finally
    qryAux.Free;
  end;
end;

procedure TPedidoRepository.Add(const APedido: TPedido);
var
  qryAux: TFDQuery;
  IdPedidoNovo: Integer;
  ObjPedidoItem : TPedidoItem;
  SomaTotal : Currency;
begin
  IdPedidoNovo := GetNextId('GEN_PEDIDO_ID');
  APedido.IdPedido := IdPedidoNovo;

  qryAux := TFDQuery.Create(nil);
  try
    qryAux.Connection := FConnection;
    qryAux.SQL.Text := 'INSERT INTO PEDIDO                                        '+
                       '        (IDPEDIDO, IDPESSOA, DATA_PEDIDO, VALOR_TOTAL)    '+
                       ' VALUES (:IDPEDIDO, :IDPESSOA, :DATA_PEDIDO, :VALOR_TOTAL)';
    qryAux.Params.ParamByName('IDPEDIDO').AsInteger := APedido.IdPedido;
    if Assigned(APedido.Cliente) then
      qryAux.Params.ParamByName('IDPESSOA').AsInteger := APedido.Cliente.IdCliente
    else
      qryAux.Params.ParamByName('IDPESSOA').Clear;

    qryAux.Params.ParamByName('DATA_PEDIDO').AsDateTime  := APedido.DataPedido;
    qryAux.Params.ParamByName('VALOR_TOTAL').AsCurrency := 0;
    qryAux.ExecSQL;

    for ObjPedidoItem in APedido.Items do
    begin
      qryAux.SQL.Text := 'INSERT INTO PEDIDO_ITEM                             '+
                         '        (IDPEDIDO, IDPRODUTO, QTDE, VALOR_UNIT)     '+
                         ' VALUES (:IDPEDIDO, :IDPRODUTO, :QTDE, :VALOR_UNIT) ';
      qryAux.Params.ParamByName('IDPEDIDO').AsInteger    := APedido.IdPedido;
      qryAux.Params.ParamByName('IDPRODUTO').AsInteger   := ObjPedidoItem.Produto.IdProduto;
      qryAux.Params.ParamByName('QTDE').AsFloat          := ObjPedidoItem.Qtde;
      qryAux.Params.ParamByName('VALOR_UNIT').AsCurrency := ObjPedidoItem.ValorUnit;
      qryAux.ExecSQL;
    end;

    qryAux.SQL.Text := 'SELECT SUM(QTDE * VALOR_UNIT) AS TOTAL  '+
                       '  FROM PEDIDO_ITEM                      '+
                       ' WHERE IDPEDIDO = :IDPEDIDO             ';
    qryAux.Params.ParamByName('IDPEDIDO').AsInteger := APedido.IdPedido;
    qryAux.Open;

    SomaTotal := 0;
    if not qryAux.IsEmpty then
      SomaTotal := qryAux.FieldByName('TOTAL').AsCurrency;

    qryAux.SQL.Text := 'UPDATE PEDIDO                     '+
                       '   SET VALOR_TOTAL = :VALOR_TOTAL '+
                       ' WHERE IDPEDIDO = :IDPEDIDO       ';
    qryAux.Params.ParamByName('VALOR_TOTAL').AsCurrency := SomaTotal;
    qryAux.Params.ParamByName('IDPEDIDO').AsInteger  := APedido.IdPedido;
    qryAux.ExecSQL;

  finally
    qryAux.Free;
  end;
end;

procedure TPedidoRepository.Update(const APedido: TPedido);
var
  qryAux: TFDQuery;
  ObjPedidoItem : TPedidoItem;
begin
  qryAux := TFDQuery.Create(nil);

  try
    qryAux.Connection := FConnection;
    qryAux.SQL.Text   := 'UPDATE PEDIDO                      '+
                         '   SET IDPESSOA = :IDPESSOA,       '+
                         '       DATA_PEDIDO = :DATA_PEDIDO, '+
                         '       VALOR_TOTAL = :VALOR_TOTAL  '+
                         ' WHERE IDPEDIDO = :ID              ';
    if Assigned(APedido.Cliente) then
      qryAux.Params.ParamByName('IDPESSOA').AsInteger := APedido.Cliente.IdCliente
    else
      qryAux.Params.ParamByName('IDPESSOA').Clear;

    qryAux.Params.ParamByName('DATA_PEDIDO').AsDateTime  := APedido.DataPedido;
    qryAux.Params.ParamByName('VALOR_TOTAL').AsCurrency  := APedido.ValorTotal;
    qryAux.Params.ParamByName('ID').AsInteger            := APedido.IdPedido;
    qryAux.ExecSQL;

    qryAux.SQL.Text := 'DELETE FROM PEDIDO_ITEM   '+
                       'WHERE IDPEDIDO = :IDPEDIDO';
    qryAux.Params.ParamByName('IDPEDIDO').AsInteger := APedido.IdPedido;
    qryAux.ExecSQL;

    for ObjPedidoItem in APedido.Items do
    begin
      qryAux.SQL.Text := 'INSERT INTO PEDIDO_ITEM                           '+
                         '       (IDPEDIDO, IDPRODUTO, QTDE, VALOR_UNIT)    '+
                         'VALUES (:IDPEDIDO, :IDPRODUTO, :QTDE, :VALOR_UNIT)';
      qryAux.Params.ParamByName('IDPEDIDO').AsInteger    := APedido.IdPedido;
      qryAux.Params.ParamByName('IDPRODUTO').AsInteger   := ObjPedidoItem.Produto.IdProduto;
      qryAux.Params.ParamByName('QTDE').AsFloat          := ObjPedidoItem.Qtde;
      qryAux.Params.ParamByName('VALOR_UNIT').AsCurrency := ObjPedidoItem.ValorUnit;
      qryAux.ExecSQL;
    end;

  finally
    qryAux.Free;
  end;
end;

procedure TPedidoRepository.Delete(AId: Integer);
var
  qryAux: TFDQuery;
begin
  qryAux := TFDQuery.Create(nil);
  try
    qryAux.Connection := FConnection;
    qryAux.SQL.Text := 'DELETE FROM PEDIDO   '+
                       ' WHERE IDPEDIDO = :ID';
    qryAux.Params.ParamByName('ID').AsInteger := AId;
    qryAux.ExecSQL;
  finally
    qryAux.Free;
  end;
end;

end.

