unit Infra.Data.Control.ProdutoControl;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  Datasnap.DBClient,
  Generics.Collections,
  Domain.Entities.Produto,
  Infra.Data.Repositories.ProdutoRepository,
  Domain.ValueObjects.UnidadeMedida,
  FireDAC.Comp.Client;

type
  TProdutoControl = class( TObject )
    private
      FConnection : TFDConnection;
      FDSProduto  : TDataSource;
      FTabProduto : TClientDataSet;
      objProdutoRepo : TProdutoRepository;
      objUnidade : TUnidadeMedida;

      procedure CriarDataSetFields;
    public
      constructor Create(AOwner : TComponent; AConnection : TFDConnection); overload;

      procedure CarregarProdutoPartial( ADescricao : String );
      procedure PrepararInclusao;
      procedure PrepararEdicao;
      procedure Cancelar;
      procedure Gravar;

      property DSProduto : TDataSource read FDSProduto;
  end;

implementation

{ TProdutoControl }

procedure TProdutoControl.Cancelar;
begin
  FTabProduto.Cancel;
end;

procedure TProdutoControl.CarregarProdutoPartial(ADescricao: String);
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

constructor TProdutoControl.Create(AOwner: TComponent; AConnection: TFDConnection);
begin
  inherited Create;

  FConnection := AConnection;

  FTabProduto := TClientDataSet.Create(nil);
  FDSProduto := TDataSource.Create(nil);
  FDSProduto.DataSet := FTabProduto;
  objProdutoRepo := TProdutoRepository.Create(FConnection);

  CriarDataSetFields;
end;

procedure TProdutoControl.CriarDataSetFields;
begin
  FTabProduto.FieldDefs.Clear;
  FTabProduto.FieldDefs.Add('IDPRODUTO', ftInteger);
  FTabProduto.FieldDefs.Add('IDUNIDADE', ftInteger);
  FTabProduto.FieldDefs.Add('DESCRICAO', ftString, 150);
  FTabProduto.FieldDefs.Add('PRECO_VENDA', ftCurrency);
  FTabProduto.FieldDefs.Add('SIGLA', ftString, 4);

  FTabProduto.CreateDataSet;
end;

procedure TProdutoControl.Gravar;
var objProduto : TProduto;
begin
  if FTabProduto.State in [dsInsert, dsEdit] then
    FTabProduto.Post;

  objProduto := TProduto.Create(FTabProduto.FieldByName('IDPRODUTO').AsInteger,
                                FTabProduto.FieldByName('DESCRICAO').AsString,
                                FTabProduto.FieldByName('PRECO_VENDA').AsCurrency);

  if FTabProduto.FieldByName('IDUNIDADE').AsInteger > 0 then
    objProduto.UnidadeMedida := TUnidadeMedida.Create( FTabProduto.FieldByName('IDUNIDADE').AsInteger, '',
                                                       FTabProduto.FieldByName('SIGLA').AsString);

  if not FConnection.InTransaction then
    FConnection.StartTransaction;

  if objProduto.IdProduto > 0 then
    objProdutoRepo.Update(objProduto)
  else
    objProdutoRepo.Add(objProduto);

  FConnection.Commit;
end;

procedure TProdutoControl.PrepararEdicao;
begin
  FTabProduto.Edit;
end;

procedure TProdutoControl.PrepararInclusao;
begin
  FTabProduto.Append;
end;

end.
