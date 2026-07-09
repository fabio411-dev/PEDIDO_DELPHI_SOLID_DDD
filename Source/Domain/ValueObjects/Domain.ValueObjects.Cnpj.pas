unit Domain.ValueObjects.Cnpj;

interface

uses System.SysUtils, Domain.ValueObjects.IDocumento;

type
  TCNPJ = class(TInterfacedObject, IDocumento)
    FNumero: string;
  private
    class function IsValid(const AValue: string): Boolean; static;
    procedure DoValidate;
  public
    constructor Create(const ANumero: string);
    function Numero: string;
    function ToString: string; overload;
    procedure Validate; overload;
  end;

implementation

constructor TCNPJ.Create(const ANumero: string);
begin
  inherited Create();

  FNumero := ANumero;

  FNumero := StringReplace(FNumero, '.', '', [rfReplaceAll]);
  FNumero := StringReplace(FNumero, '/', '', [rfReplaceAll]);
  FNumero := StringReplace(FNumero, '-', '', [rfReplaceAll]);
  DoValidate;
end;

procedure TCNPJ.DoValidate;
begin
  if not IsValid(FNumero) then
    raise Exception.CreateFmt('CNPJ "%s" inválido.', [FNumero]);
end;

class function TCNPJ.IsValid(const AValue: string): Boolean;
begin
  Result := Length(AValue) = 14;

  //todo: adicionar outras validacoes abaixo
end;

function TCNPJ.Numero: string;
begin
  result := FNumero;
end;

function TCNPJ.ToString: string;
var
  LNumeroFormatado : string;
begin
  LNumeroFormatado := Numero;
  Result := Copy(LNumeroFormatado,1,2) + '.' +
            Copy(LNumeroFormatado,3,3) + '.' +
            Copy(LNumeroFormatado,6,3) + '/' +
            Copy(LNumeroFormatado,9,4) + '-' +
            Copy(LNumeroFormatado,13,2);
end;

procedure TCNPJ.Validate;
begin
  DoValidate;
end;

end.
