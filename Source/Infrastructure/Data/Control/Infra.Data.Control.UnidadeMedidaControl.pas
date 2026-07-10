unit Infra.Data.Control.UnidadeMedidaControl;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  Datasnap.DBClient,
  Generics.Collections,
  Domain.Entities.Produto,
  Infra.Data.Repositories.UnidadeMedidaRepository,
  Domain.ValueObjects.UnidadeMedida,
  FireDAC.Comp.Client;

type
  TUnidadeMedidaControl = class( TObject )
    private
      FConnection : TFDConnection;
      FDSUnidadeMedida  : TDataSource;
      FTabUnidadeMedida : TClientDataSet;
      objUnidadeMedidaRepo : TUnidadeMedidaRepository;
      objUnidade : TUnidadeMedida;

      procedure CriarDataSetFields;
    public
      constructor Create(AOwner : TComponent; AConnection : TFDConnection); overload;

      procedure Carregar;

      property DSUnidadeMedida : TDataSource read FDSUnidadeMedida;
  end;

implementation

{ TUnidadeMedidaControl }

procedure TUnidadeMedidaControl.Carregar;
var Lista : TObjectList<TUnidadeMedida>;
    objUnidadeMedida : TUnidadeMedida;
begin
  Lista := objUnidadeMedidaRepo.GetAll;

  FTabUnidadeMedida.EmptyDataSet;

  for objUnidadeMedida in Lista do
  begin
    FTabUnidadeMedida.Append;

    FTabUnidadeMedida.FieldByName('IDUNIDADE').AsInteger    := objUnidadeMedida.IdUnidadeMedida;
    FTabUnidadeMedida.FieldByName('DESCRICAO').AsString     := objUnidadeMedida.Descricao;
    FTabUnidadeMedida.FieldByName('SIGLA').AsString         := objUnidadeMedida.Sigla;

    FTabUnidadeMedida.Post;
  end;
end;

constructor TUnidadeMedidaControl.Create(AOwner: TComponent; AConnection: TFDConnection);
begin
  inherited Create;

  FConnection := AConnection;

  FTabUnidadeMedida := TClientDataSet.Create(nil);
  FDSUnidadeMedida := TDataSource.Create(nil);
  FDSUnidadeMedida.DataSet := FTabUnidadeMedida;
  objUnidadeMedidaRepo := TUnidadeMedidaRepository.Create(FConnection);

  CriarDataSetFields;
end;

procedure TUnidadeMedidaControl.CriarDataSetFields;
begin
  FTabUnidadeMedida.FieldDefs.Clear;
  FTabUnidadeMedida.FieldDefs.Add('IDUNIDADE', ftInteger);
  FTabUnidadeMedida.FieldDefs.Add('DESCRICAO', ftString, 50);
  FTabUnidadeMedida.FieldDefs.Add('SIGLA', ftString, 4);

  FTabUnidadeMedida.CreateDataSet;
end;

end.
