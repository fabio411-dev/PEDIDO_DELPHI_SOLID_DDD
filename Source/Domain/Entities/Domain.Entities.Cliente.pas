unit Domain.Entities.Cliente;

interface

uses
  System.SysUtils,
  Domain.ValueObjects.IDocumento;

type
  TCliente = class(TObject)
  private
    FIdCliente: Integer;
    FNome: string;
    FDocumento: IDocumento;
    FIdCidade: Integer;
  public
    constructor Create(AIdCliente: Integer; const ANome: string; ADocumento: IDocumento; AIdCidade: Integer);
    property IdCliente: Integer    read FIdCliente write FIdCliente;
    property Nome     : string     read FNOME      write FNOME;
    property Documento: IDocumento read FDocumento write FDocumento;
    property IdCidade : Integer    read FIdCidade  write FIdCidade;
  end;

implementation

constructor TCliente.Create(AIdCliente: Integer; const ANome: string; ADocumento: IDocumento; AIdCidade: Integer);
begin
  inherited Create();

  FIdCliente := AIdCliente;
  FNome      := ANome;
  FDocumento := ADocumento;
  FIdCidade  := AIdCidade;
end;

end.

