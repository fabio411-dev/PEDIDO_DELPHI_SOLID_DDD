unit Infra.Data.Repositories.CidadeRepository;

interface

uses
  System.SysUtils,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Comp.Client,
  Domain.ValueObjects.UnidadeFederativa,
  Domain.ValueObjects.Cidade,
  Domain.Interfaces.ICidadeRepository,
  System.Generics.Collections;

type
  TCidadeRepository = class(TInterfacedObject, ICidadeRepository)
  private
    FConnection: TFDConnection;
    function CreateUf(const AIdUF: Integer; const ANome, ASigla: string): TUnidadeFederativa;
  public
    constructor Create(AConnection: TFDConnection);
    function GetAll: TObjectList<TCidade>;
    function FindById(AId: Integer): TCidade;
  end;

implementation

{ TCidadeRepository }

constructor TCidadeRepository.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

function TCidadeRepository.CreateUf(const AIdUF: Integer; const ANome, ASigla: string): TUnidadeFederativa;
begin
  Result := TUnidadeFederativa.Create(AIdUF, ANome, ASigla);
end;

function TCidadeRepository.FindById(AId: Integer): TCidade;
var
  qryAux : TFDQuery;
  objUF  : TUnidadeFederativa;
begin
  Result := nil;
  qryAux := TFDQuery.Create(nil);
  try
    qryAux.Connection := FConnection;
    qryAux.SQL.Text := 'SELECT C.IDCIDADE,                                  '+
                       '       C.NOME AS CIDADE,                            '+
                       '       U.IDUF,                                      '+
                       '       U.NOME AS ESTADO,                            '+
                       '       U.SIGLA                                      '+
                       '  FROM CIDADE C                                     '+
                       '  LEFT JOIN UNIDADE_FEDERATIVA U ON C.IDUF = U.IDUF '+
                       ' WHERE C.IDCIDADE = :ID                             ';

    qryAux.Params.ParamByName('ID').AsInteger := AId;
    qryAux.Open;

    if not qryAux.IsEmpty then
    begin
      objUF := CreateUf(
        qryAux.FieldByName('IDUF').AsInteger,
        qryAux.FieldByName('ESTADO').AsString,
        qryAux.FieldByName('SIGLA').AsString);

      Result := TCidade.Create(
        qryAux.FieldByName('IDCIDADE').AsInteger,
        qryAux.FieldByName('CIDADE').AsString,
        objUF );
    end;
  finally
    qryAux.Free;
  end;
end;

function TCidadeRepository.GetAll: TObjectList<TCidade>;
var
  qryAux : TFDQuery;
  objCidade : TCidade;
  objUF     : TUnidadeFederativa;
begin
  Result := TObjectList<TCidade>.Create(True);

  qryAux := TFDQuery.Create(nil);
  try
    qryAux.Connection := FConnection;

    qryAux.SQL.Text := 'SELECT C.IDCIDADE,                                  '+
                       '       C.NOME AS CIDADE,                            '+
                       '       U.IDUF,                                      '+
                       '       U.NOME AS ESTADO,                            '+
                       '       U.SIGLA                                      '+
                       '  FROM CIDADE C                                     '+
                       '  LEFT JOIN UNIDADE_FEDERATIVA U ON C.IDUF = U.IDUF '+
                       ' ORDER BY C.NOME                                    ';
    qryAux.Open;

    while not qryAux.Eof do
    begin
      objUF := CreateUf(
        qryAux.FieldByName('IDUF').AsInteger,
        qryAux.FieldByName('ESTADO').AsString,
        qryAux.FieldByName('SIGLA').AsString);

      objCidade := TCidade.Create(
        qryAux.FieldByName('IDCIDADE').AsInteger,
        qryAux.FieldByName('CIDADE').AsString,
        objUF );

      Result.Add( objCidade );

      qryAux.Next;
    end;
  finally
    qryAux.Free;
  end;
end;

end.

