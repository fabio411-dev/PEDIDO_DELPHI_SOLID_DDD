unit Infra.Data.Control.CidadeControl;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  Datasnap.DBClient,
  Generics.Collections,
  Infra.Data.Repositories.CidadeRepository,
  Domain.ValueObjects.Cidade,
  FireDAC.Comp.Client;

type
  TCidadeControl = class( TObject )
    private
      FConnection : TFDConnection;
      FDSCidade  : TDataSource;
      FTabCidade : TClientDataSet;
      objCidadeRepo : TCidadeRepository;

      procedure CriarDataSetFields;
    public
      constructor Create(AOwner : TComponent; AConnection : TFDConnection); overload;

      procedure Carregar;

      property DSCidade : TDataSource read FDSCidade;
  end;

implementation

{ TCidadeControl }

procedure TCidadeControl.Carregar;
var Lista : TObjectList<TCidade>;
    objCidade : TCidade;
begin
  Lista := objCidadeRepo.GetAll;

  FTabCidade.EmptyDataSet;

  for objCidade in Lista do
  begin
    FTabCidade.Append;

    FTabCidade.FieldByName('IDCIDADE').AsInteger := objCidade.IdCidade;
    FTabCidade.FieldByName('CIDADE').AsString := objCidade.Nome;

    if Assigned(objCidade.UF) then
      FTabCidade.FieldByName('SIGLA').AsString   := objCidade.UF.Sigla;

    FTabCidade.Post;
  end;
end;

constructor TCidadeControl.Create(AOwner: TComponent; AConnection: TFDConnection);
begin
  inherited Create;

  FConnection := AConnection;

  FTabCidade := TClientDataSet.Create(nil);
  FDSCidade := TDataSource.Create(nil);
  FDSCidade.DataSet := FTabCidade;
  objCidadeRepo := TCidadeRepository.Create(FConnection);

  CriarDataSetFields;
end;

procedure TCidadeControl.CriarDataSetFields;
begin
  FTabCidade.FieldDefs.Clear;
  FTabCidade.FieldDefs.Add('IDCIDADE', ftInteger);
  FTabCidade.FieldDefs.Add('CIDADE', ftString, 50);
  FTabCidade.FieldDefs.Add('SIGLA', ftString, 4);

  FTabCidade.CreateDataSet;
end;

end.
