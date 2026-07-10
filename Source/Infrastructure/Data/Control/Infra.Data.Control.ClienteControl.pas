unit Infra.Data.Control.ClienteControl;

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
  Infra.Data.Repositories.ClienteRepository,
  App.Services.ClienteService,
  Infra.Data.Repositories.CidadeRepository,
  FireDAC.Comp.Client;

type
  TClienteControl = class( TObject )
    private
      FConnection : TFDConnection;
      FDSCliente  : TDataSource;
      FTabCliente : TClientDataSet;
      objClienteRepo : TClienteRepository;
      objClienteServ : TClienteService;
      objCidadeRepo : TCidadeRepository;


      procedure CriarDataSetFields;
    public
      constructor Create(AOwner : TComponent; AConnection : TFDConnection); overload;

      procedure CarregarClientePartial( ADescricao : String );
      procedure PrepararInclusao;
      procedure PrepararEdicao;
      procedure Cancelar;
      procedure Gravar;

      property DSCliente : TDataSource read FDSCliente;
  end;

implementation

{ TClienteControl }

procedure TClienteControl.Cancelar;
begin
  FTabCliente.Cancel;
end;

procedure TClienteControl.CarregarClientePartial(ADescricao: String);
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

constructor TClienteControl.Create(AOwner: TComponent; AConnection: TFDConnection);
begin
  inherited Create;

  FConnection := AConnection;

  FTabCliente := TClientDataSet.Create(nil);
  FDSCliente := TDataSource.Create(nil);
  FDSCliente.DataSet := FTabCliente;
  objClienteRepo := TClienteRepository.Create(FConnection);
  objClienteServ := TClienteService.Create(objClienteRepo);
  objCidadeRepo := TCidadeRepository.Create(FConnection);

  CriarDataSetFields;
end;

procedure TClienteControl.CriarDataSetFields;
begin
  FTabCliente.FieldDefs.Clear;
  FTabCliente.FieldDefs.Add('IDCLIENTE', ftInteger);
  FTabCliente.FieldDefs.Add('IDCIDADE', ftInteger);
  FTabCliente.FieldDefs.Add('NOME', ftString, 150);
  FTabCliente.FieldDefs.Add('DOCUMENTO', ftString, 20);
  FTabCliente.FieldDefs.Add('CIDADE', ftString, 50);
  FTabCliente.FieldDefs.Add('SIGLA', ftString, 4);

  FTabCliente.CreateDataSet;
end;

procedure TClienteControl.Gravar;
var objCliente : TCliente;
    objDoc : IDocumento;
begin
  if FTabCliente.State in [dsInsert, dsEdit] then
    FTabCliente.Post;

  objDoc := objClienteServ.CreateDocumento( FTabCliente.FieldByName('DOCUMENTO').AsString );

  objCliente := TCliente.Create(FTabCliente.FieldByName('IDCLIENTE').AsInteger,
                                FTabCliente.FieldByName('NOME').AsString,
                                objDoc,
                                FTabCliente.FieldByName('IDCIDADE').AsInteger);

  if not FConnection.InTransaction then
    FConnection.StartTransaction;

  if objCliente.IdCliente > 0 then
    objClienteRepo.Update(objCliente)
  else
    objClienteRepo.Add(objCliente);

  FConnection.Commit;
end;

procedure TClienteControl.PrepararEdicao;
begin
  FTabCliente.Edit;
end;

procedure TClienteControl.PrepararInclusao;
begin
  FTabCliente.Append;
end;

end.
