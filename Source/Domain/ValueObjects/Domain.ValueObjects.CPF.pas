unit Domain.ValueObjects.CPF;

interface

uses System.SysUtils, Domain.ValueObjects.IDocumento;

type
  TCPF = class(TInterfacedObject, IDocumento)
    FNumero: string;
  strict private
    class function IsValid(const AValue: string): Boolean; static;
    procedure DoValidate;
  public
    constructor Create(const ANumero: string);
    function Numero : string;
    function ToString: string; overload;
    procedure Validate; overload;
  end;

implementation

constructor TCPF.Create(const ANumero: string);
begin
  inherited Create();
  FNumero := ANumero;

  FNumero := StringReplace(FNumero, '.', '', [rfReplaceAll]);
  FNumero := StringReplace(FNumero, '-', '', [rfReplaceAll]);
  DoValidate;
end;

procedure TCPF.DoValidate;
begin
  if not IsValid(FNumero) then
    raise Exception.CreateFmt('CPF "%s" inválido.', [FNumero]);
end;

class function TCPF.IsValid(const AValue: string): Boolean;
begin
  Result := Length(AValue) = 11;

  //todo: adicionar outras validacoes abaixo
end;

function TCPF.Numero: string;
begin
  Result := FNumero;
end;

function TCPF.ToString: string;
var
  LNumeroFormatado: string;
begin
  LNumeroFormatado := Numero;
  Result := Copy(LNumeroFormatado,1,3) + '.' +
            Copy(LNumeroFormatado,4,3) + '.' +
            Copy(LNumeroFormatado,7,3) + '-' +
            Copy(LNumeroFormatado,10,2);
end;

procedure TCPF.Validate;
begin
  DoValidate;
end;

end.
