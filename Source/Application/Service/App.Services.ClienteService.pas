unit App.Services.ClienteService;

interface

uses
  System.SysUtils,
  Domain.Interfaces.IClienteRepository,
  Domain.Entities.Cliente,
  Domain.ValueObjects.IDocumento,
  Domain.ValueObjects.CPF,
  Domain.ValueObjects.CNPJ;

type
  TClienteService = class
  private
    FClientRepo: IClienteRepository;
  public
    constructor Create(AClientRepo: IClienteRepository);
    function CreateDocumento(const ADocStr: string): IDocumento; overload;
    procedure AddCliente(const ANome: string; const ADocStr: string; AIdCidade: Integer);
  end;

implementation

constructor TClienteService.Create(AClientRepo: IClienteRepository);
begin
  inherited Create;
  FClientRepo := AClientRepo;
end;

function TClienteService.CreateDocumento(const ADocStr: string): IDocumento;
var
  LNumeroClean: string;
begin
  LNumeroClean := StringReplace(ADocStr, '.', '', [rfReplaceAll]);
  LNumeroClean := StringReplace(LNumeroClean, '-', '', [rfReplaceAll]);
  LNumeroClean := StringReplace(LNumeroClean, '/', '', [rfReplaceAll]);

  if Length(LNumeroClean) = 11 then
    Result := TCPF.Create(LNumeroClean)
  else if Length(LNumeroClean) = 14 then
    Result := TCNPJ.Create(LNumeroClean)
  else
    raise Exception.CreateFmt('Documento "%s" inválido', [ADocStr]);
end;

procedure TClienteService.AddCliente(const ANome: string; const ADocStr: string; AIdCidade: Integer);
var
  DocObj   : IDocumento;
  Cliente : TCliente;
begin
  DocObj := CreateDocumento(ADocStr);

  Cliente := TCliente.Create(0, ANome, DocObj, AIdCidade);
  FClientRepo.Add(Cliente);
end;

end.

