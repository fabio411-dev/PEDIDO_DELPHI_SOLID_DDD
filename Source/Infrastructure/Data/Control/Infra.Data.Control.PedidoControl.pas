unit Infra.Data.Control.PedidoControl;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  Datasnap.DBClient,
  Generics.Collections,
  Domain.Entities.Cliente,
  Domain.ValueObjects.Cidade,
  Domain.ValueObjects.IDocumento,
  Domain.Entities.Pedido,
  Domain.Entities.PedidoItem,
  App.Services.ClienteService,
  Domain.Entities.Produto,
  Infra.Data.Repositories.CidadeRepository,
  Infra.Data.Repositories.ClienteRepository,
  Infra.Data.Repositories.ProdutoRepository,
  Infra.Data.Repositories.PedidoRepository,
  App.Services.PedidoService,
  FireDAC.Comp.Client;

type
  TPedidoControl = class( TObject )
    private
      FConnection : TFDConnection;
      FDSPedido  : TDataSource;
      FDSPedidoItem : TDataSource;
      FDSCliente  : TDataSource;
      FDSProduto  : TDataSource;
      FTabCliente : TClientDataSet;
      FTabProduto : TClientDataSet;
      FTabPedido  : TClientDataSet;
      FTabPedidoItem   : TClientDataSet;
      objClienteRepo   : TClienteRepository;
      objClienteServ   : TClienteService;
      objCidadeRepo    : TCidadeRepository;
      objPedidoRepo    : TPedidoRepository;
      objProdutoRepo   : TProdutoRepository;
      objPedidoService : TPedidoService;

      procedure CriarDataSetFields;
      procedure CarregarClientePartial( ADescricao : String );
      procedure CarregarProdutoPartial( ADescricao : String );
    public
      constructor Create(AOwner : TComponent; AConnection : TFDConnection); overload;

      procedure CarregarPedidoPartial( ADescricao : String );
      procedure ShowPedidoItens( AIdPedido : Integer );
      procedure PrepararInclusao;
      procedure PrepararInclusaoItem;
      procedure PrepararEdicao;
      procedure Cancelar;
      procedure Gravar;
      procedure GravarItem;

      property DSCliente    : TDataSource read FDSCliente;
      property DSPedido     : TDataSource read FDSPedido;
      property DSPedidoItem : TDataSource read FDSPedidoItem;
      property DSProduto    : TDataSource read FDSProduto;
  end;

implementation

{ TPedidoControl }

procedure TPedidoControl.Cancelar;
begin
  FTabPedido.Cancel;
end;

procedure TPedidoControl.CarregarClientePartial(ADescricao: String);
var Lista : TObjectList<TCliente>;
    objCliente : TCliente;
    objCidade : TCidade;
begin
  Lista := objClienteRepo.FindAll( ADescricao );

  FTabCliente.EmptyDataSet;

  for objCliente in Lista do
  begin
    FTabCliente.Append;

    FTabCliente.FieldByName('IDCLIENTE').AsInteger   := objCliente.IdCliente;
    FTabCliente.FieldByName('NOME').AsString         := objCliente.Nome;
    FTabCliente.FieldByName('DOCUMENTO').AsString    := objCliente.Documento.ToString;
    FTabCliente.FieldByName('IDCIDADE').AsInteger    := objCliente.IdCidade;

    if (objCliente.IdCidade > 0) then
    begin
      objCidade := objCidadeRepo.FindById(objCliente.IdCidade);

      if Assigned(objCidade) then
      begin
        FTabCliente.FieldByName('CIDADE').AsString    := objCidade.Nome;

        if Assigned(objCidade.UF) then
          FTabCliente.FieldByName('SIGLA').AsString     := objCidade.UF.Sigla;
      end;
    end;
    FTabCliente.Post;
  end;

end;

procedure TPedidoControl.CarregarPedidoPartial(ADescricao: String);
var Lista : TObjectList<TPedido>;
    objPedido : TPedido;
    objPedidoItem : TPedidoItem;
begin
  Lista := objPedidoRepo.FindAll( ADescricao );

  FTabPedido.EmptyDataSet;
  FTabPedidoItem.EmptyDataSet;

  for objPedido in Lista do
  begin
    FTabPedido.Append;

    FTabPedido.FieldByName('IDPEDIDO').AsInteger     := objPedido.IdPedido;
    if Assigned(objPedido.Cliente) then
    begin
      FTabPedido.FieldByName('IDCLIENTE').AsInteger  := objPedido.Cliente.IdCliente;
      FTabPedido.FieldByName('IDCIDADE').AsInteger   := objPedido.Cliente.IdCidade;
      FTabPedido.FieldByName('NOME').AsString        := objPedido.Cliente.Nome;
      FTabPedido.FieldByName('DOCCLIENTE').AsString  := objPedido.Cliente.Documento.ToString;
    end;

    FTabPedido.FieldByName('DATA_PEDIDO').AsDateTime := objPedido.DataPedido;
    FTabPedido.FieldByName('VALOR_TOTAL').AsCurrency := objPedido.ValorTotal;

    FTabPedido.Post;

    for objPedidoItem in objPedido.Items do
    begin
      FTabPedidoItem.Append;
      FTabPedidoItem.FieldByName('IDPEDIDO').AsInteger      := objPedido.IdPedido;
      FTabPedidoItem.FieldByName('IDPEDIDOITEM').AsInteger  := objPedidoItem.IdPedidoItem;
      if Assigned(objPedidoItem.Produto) then
      begin
        FTabPedidoItem.FieldByName('IDPRODUTO').AsInteger   := objPedidoItem.Produto.IdProduto;
        FTabPedidoItem.FieldByName('DESCPRODUTO').AsString  := objPedidoItem.Produto.Descricao;
      end;
      FTabPedidoItem.FieldByName('QTDE').AsFloat            := objPedidoItem.Qtde;
      FTabPedidoItem.FieldByName('VALOR_UNIT').AsCurrency   := objPedidoItem.ValorUnit;
      FTabPedidoItem.FieldByName('VALOR_TOTAL').AsCurrency  := objPedidoItem.Total;

      FTabPedidoItem.Post;
    end;
  end;

end;

procedure TPedidoControl.CarregarProdutoPartial(ADescricao: String);
var Lista : TObjectList<TProduto>;
    objProduto : TProduto;
begin
  Lista := objProdutoRepo.FindAll( ADescricao );

  FTabProduto.EmptyDataSet;

  for objProduto in Lista do
  begin
    FTabProduto.Append;

    FTabProduto.FieldByName('IDPRODUTO').AsInteger    := objProduto.IdProduto;
    FTabProduto.FieldByName('DESCRICAO').AsString     := objProduto.Descricao;
    FTabProduto.FieldByName('PRECO_VENDA').AsCurrency := objProduto.PrecoVenda;

    if Assigned(objProduto.UnidadeMedida) then
    begin
      FTabProduto.FieldByName('IDUNIDADE').AsInteger    := objProduto.UnidadeMedida.IdUnidadeMedida;
      FTabProduto.FieldByName('SIGLA').AsString         := objProduto.UnidadeMedida.Sigla;
    end;
    FTabProduto.Post;
  end;

end;

constructor TPedidoControl.Create(AOwner: TComponent; AConnection: TFDConnection);
begin
  inherited Create;

  FConnection := AConnection;

  FTabCliente := TClientDataSet.Create(nil);
  FDSCliente := TDataSource.Create(nil);
  FDSCliente.DataSet := FTabCliente;

  FTabProduto := TClientDataSet.Create(nil);
  FDSProduto := TDataSource.Create(nil);
  FDSProduto.DataSet := FTabProduto;

  FTabPedido := TClientDataSet.Create(nil);
  FDSPedido := TDataSource.Create(nil);
  FDSPedido.DataSet := FTabPedido;

  FTabPedidoItem := TClientDataSet.Create(nil);
  FDSPedidoItem := TDataSource.Create(nil);
  FDSPedidoItem.DataSet := FTabPedidoItem;

  objPedidoRepo  := TPedidoRepository.Create(FConnection);
  objClienteRepo := TClienteRepository.Create(FConnection);
  objProdutoRepo := TProdutoRepository.Create(FConnection);
  objClienteServ := TClienteService.Create(objClienteRepo);
  objCidadeRepo  := TCidadeRepository.Create(FConnection);

  CriarDataSetFields;

  CarregarClientePartial('');
  CarregarProdutoPartial('');
end;

procedure TPedidoControl.CriarDataSetFields;
begin
  FTabCliente.FieldDefs.Clear;
  FTabCliente.FieldDefs.Add('IDCLIENTE', ftInteger);
  FTabCliente.FieldDefs.Add('IDCIDADE', ftInteger);
  FTabCliente.FieldDefs.Add('NOME', ftString, 150);
  FTabCliente.FieldDefs.Add('DOCUMENTO', ftString, 20);
  FTabCliente.FieldDefs.Add('CIDADE', ftString, 50);
  FTabCliente.FieldDefs.Add('SIGLA', ftString, 4);
  FTabCliente.CreateDataSet;

  FTabProduto.FieldDefs.Clear;
  FTabProduto.FieldDefs.Add('IDPRODUTO', ftInteger);
  FTabProduto.FieldDefs.Add('IDUNIDADE', ftInteger);
  FTabProduto.FieldDefs.Add('DESCRICAO', ftString, 150);
  FTabProduto.FieldDefs.Add('PRECO_VENDA', ftCurrency);
  FTabProduto.FieldDefs.Add('SIGLA', ftString, 4);
  FTabProduto.CreateDataSet;

  FTabPedido.FieldDefs.Clear;
  FTabPedido.FieldDefs.Add('IDPEDIDO', ftInteger);
  FTabPedido.FieldDefs.Add('IDCLIENTE', ftInteger);
  FTabPedido.FieldDefs.Add('IDCIDADE', ftInteger);
  FTabPedido.FieldDefs.Add('NOME', ftString, 150);
  FTabPedido.FieldDefs.Add('DOCCLIENTE', ftString, 20);
  FTabPedido.FieldDefs.Add('DATA_PEDIDO', ftDateTime);
  FTabPedido.FieldDefs.Add('VALOR_TOTAL', ftCurrency);
  FTabPedido.CreateDataSet;

  FTabPedidoItem.FieldDefs.Clear;
  FTabPedidoItem.FieldDefs.Add('IDPEDIDOITEM', ftInteger);
  FTabPedidoItem.FieldDefs.Add('IDPEDIDO', ftInteger);
  FTabPedidoItem.FieldDefs.Add('IDPRODUTO', ftInteger);
  FTabPedidoItem.FieldDefs.Add('DESCPRODUTO', ftString, 150);
  FTabPedidoItem.FieldDefs.Add('QTDE', ftFloat);
  FTabPedidoItem.FieldDefs.Add('VALOR_UNIT', ftCurrency);
  FTabPedidoItem.FieldDefs.Add('VALOR_TOTAL', ftCurrency);
  FTabPedidoItem.CreateDataSet;
end;

procedure TPedidoControl.Gravar;
var
  i : Integer;
  objCliente    : TCliente;
  objPedido     : TPedido;
  objProduto    : TProduto;
  objPedidoItem : TPedidoItem;
begin
  if FTabPedido.State in [dsInsert, dsEdit] then
    FTabPedido.Post;

  if FTabPedidoItem.State in [dsInsert, dsEdit] then
    FTabPedidoItem.Post;

  objCliente := objClienteRepo.FindById(FTabPedido.FieldByName('IDCLIENTE').AsInteger);
  if not Assigned(objCliente) then
    raise Exception.CreateFmt('Cliente com id %d não encontrado', [FTabPedido.FieldByName('IDCLIENTE').AsInteger]);

  objPedido := TPedido.Create(FTabPedido.FieldByName('IDPEDIDO').AsInteger, objCliente);

  FTabPedidoItem.First;
  while not FTabPedidoItem.Eof do
  begin
    objProduto := objProdutoRepo.FindById(FTabPedidoItem.FieldByName('IDPRODUTO').AsInteger);
    if not Assigned(objProduto) then
      raise Exception.CreateFmt('Produto com id %d não encontrado', [FTabPedidoItem.FieldByName('IDPRODUTO').AsInteger]);

    objPedidoItem := TPedidoItem.Create(
      0,
      objPedido.IdPedido,
      objProduto,
      FTabPedidoItem.FieldByName('QTDE').AsFloat,
      FTabPedidoItem.FieldByName('VALOR_UNIT').AsFloat);

    objPedido.AddItem(objPedidoItem);

    FTabPedidoItem.Next;
  end;

  if not FConnection.InTransaction then
    FConnection.StartTransaction;

  if objPedido.IdPedido > 0 then
    objPedidoRepo.Update(objPedido)
  else
    objPedidoRepo.Add(objPedido);

  FConnection.Commit;
end;

procedure TPedidoControl.GravarItem;
begin
  if FTabPedidoItem.State in [dsInsert, dsEdit] then
  begin
    FTabPedidoItem.FieldByName('IDPEDIDO').AsInteger := FTabPedido.FieldByName('IDPEDIDO').AsInteger;
    FTabPedidoItem.Post;
  end;
end;

procedure TPedidoControl.PrepararEdicao;
begin
  FTabPedido.Edit;
end;

procedure TPedidoControl.PrepararInclusao;
begin
  FTabPedido.Append;

  ShowPedidoItens( 0 );
end;

procedure TPedidoControl.PrepararInclusaoItem;
begin
  FTabPedidoItem.Append;
  FTabPedidoItem.FieldByName('IDPEDIDO').AsInteger := FTabPedido.FieldByName('IDPEDIDO').AsInteger;
end;

procedure TPedidoControl.ShowPedidoItens(AIdPedido: Integer);
begin
  FTabPedidoItem.Filtered := False;
  FTabPedidoItem.Filter := 'IDPEDIDO  = ' + IntToStr( AIdPedido );
  FTabPedidoItem.Filtered := True;
end;

end.
