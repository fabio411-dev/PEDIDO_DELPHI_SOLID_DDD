unit Infra.Data.Repositories.ClienteRepository;

interface

uses
  System.SysUtils,
  Generics.Collections,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Comp.Client,
  FireDAC.Comp.DataSet,
  Domain.Interfaces.IClienteRepository,
  Domain.Entities.Cliente,
  Domain.ValueObjects.IDocumento,
  Domain.ValueObjects.CPF,
  Domain.ValueObjects.CNPJ;

type
  TClienteRepository = class(TInterfacedObject, IClienteRepository)
  private
    FConnection: TFDConnection;
    function ParseDocumento(const ARecord: TFDDataSet): IDocumento;
  public
    constructor Create(AConnection: TFDConnection);
    destructor Destroy; override;
    function FindById(AId: Integer): TCliente;
    function FindAll: TObjectList<TCliente>;
    procedure Add(const ACliente: TCliente);
    procedure Update(const ACliente: TCliente);
    procedure Delete(AId: Integer);
  end;

implementation

constructor TClienteRepository.Create(AConnection: TFDConnection);
begin
  inherited Create;
  FConnection := AConnection;
end;

destructor TClienteRepository.Destroy;
begin
  inherited Destroy;
end;

function TClienteRepository.ParseDocumento(const ARecord: TFDDataSet): IDocumento;
var
  sCPF, sCNPJ: string;
begin
  Result := nil;
  sCPF   := Trim(ARecord.FieldByName('CPF').AsString);
  sCNPJ  := Trim(ARecord.FieldByName('CNPJ').AsString);

  if (sCPF <> '') then
    Result := TCPF.Create(sCPF)
  else if (sCNPJ <> '') then
    Result := TCNPJ.Create(sCNPJ);
end;

function TClienteRepository.FindById(AId: Integer): TCliente;
var
  qryAux : TFDQuery;
begin
  Result := nil;
  qryAux := TFDQuery.Create(nil);
  try
    qryAux.Connection := FConnection;
    qryAux.SQL.Text := 'SELECT IDPESSOA, IDCIDADE, NOME, CPF, CNPJ '+
                       '  FROM PESSOA WHERE IDPESSOA = :ID         ';
    qryAux.Params.ParamByName('ID').AsInteger := AId;
    qryAux.Open;

    if not qryAux.IsEmpty then
    begin
      Result := TCliente.Create(
        qryAux.FieldByName('IDPESSOA').AsInteger,
        qryAux.FieldByName('NOME').AsString,
        ParseDocumento(qryAux),
        qryAux.FieldByName('IDCIDADE').AsInteger);
    end;
  finally
    qryAux.Free;
  end;
end;

function TClienteRepository.FindAll: TObjectList<TCliente>;
var
  qryAux: TFDQuery;
begin
  Result := TObjectList<TCliente>.Create(True);
  qryAux := TFDQuery.Create(nil);
  try
    qryAux.Connection := FConnection;
    qryAux.SQL.Text := 'SELECT IDPESSOA, IDCIDADE, NOME, CPF, CNPJ '+
                       '  FROM PESSOA                              ';
    qryAux.Open;

    while not qryAux.Eof do
    begin
      Result.Add(
        TCliente.Create(
          qryAux.FieldByName('IDPESSOA').AsInteger,
          qryAux.FieldByName('NOME').AsString,
          ParseDocumento(qryAux),
          qryAux.FieldByName('IDCIDADE').AsInteger));
      qryAux.Next;
    end;
  finally
    qryAux.Free;
  end;
end;

procedure TClienteRepository.Add(const ACliente: TCliente);
var
  qryAux: TFDQuery;
begin
  qryAux := TFDQuery.Create(nil);
  try
    qryAux.Connection := FConnection;
    qryAux.SQL.Text := 'INSERT INTO PESSOA                      '+
                       '        (IDCIDADE, NOME, CPF, CNPJ)     '+
                       ' VALUES (:IDCIDADE, :NOME, :CPF, :CNPJ) ';
    qryAux.Params.ParamByName('IDCIDADE').AsInteger := ACliente.IdCidade;
    qryAux.Params.ParamByName('NOME').AsString  := ACliente.Nome;

    if ACliente.Documento is TCPF then
    begin
      qryAux.Params.ParamByName('CPF').AsString := (ACliente.Documento as TCPF).Numero;
      qryAux.Params.ParamByName('CNPJ').Clear;
    end
    else
    if ACliente.Documento is TCNPJ then
    begin
      qryAux.Params.ParamByName('CNPJ').AsString := (ACliente.Documento as TCNPJ).Numero;
      qryAux.Params.ParamByName('CPF').Clear;
    end;

    qryAux.ExecSQL;
  finally
    qryAux.Free;
  end;
end;

procedure TClienteRepository.Update(const ACliente: TCliente);
var
  qryAux: TFDQuery;
begin
  qryAux := TFDQuery.Create(nil);
  try
    qryAux.Connection := FConnection;
    qryAux.SQL.Text := 'UPDATE PESSOA                 '+
                       '   SET IDCIDADE = :IDCIDADE,  '+
                       '       NOME = :NOME,          '+
                       '       CPF = :CPF,            '+
                       '       CNPJ = :CNPJ           '+
                       ' WHERE IDPESSOA = :IDPESSOA   ';
    qryAux.Params.ParamByName('IDPESSOA').AsInteger   := ACliente.IdCliente;
    qryAux.Params.ParamByName('IDCIDADE').AsInteger:= ACliente.IdCidade;
    qryAux.Params.ParamByName('NOME').AsString  := ACliente.Nome;

    if ACliente.Documento is TCPF then
    begin
      qryAux.Params.ParamByName('CPF').AsString := (ACliente.Documento as TCPF).Numero;
      qryAux.Params.ParamByName('CNPJ').Clear;
    end
    else if ACliente.Documento is TCNPJ then
    begin
      qryAux.Params.ParamByName('CNPJ').AsString := (ACliente.Documento as TCNPJ).Numero;
      qryAux.Params.ParamByName('CPF').Clear;
    end;

    qryAux.ExecSQL;
  finally
    qryAux.Free;
  end;
end;

procedure TClienteRepository.Delete(AId: Integer);
var
  qryAux: TFDQuery;
begin
  qryAux := TFDQuery.Create(nil);
  try
    qryAux.Connection := FConnection;
    qryAux.SQL.Text := 'DELETE FROM PESSOA '+
                       ' WHERE IDPESSOA = :ID';
    qryAux.Params.ParamByName('ID').AsInteger := AId;
    qryAux.ExecSQL;
  finally
    qryAux.Free;
  end;
end;

end.

