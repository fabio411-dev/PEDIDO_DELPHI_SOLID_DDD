unit Domain.ValueObjects.Cidade;

interface

uses
  System.SysUtils,
  Domain.ValueObjects.UnidadeFederativa;

type
  TCidade = class(TObject)
  private
    FIdCidade: Integer;
    FNOME: string;
    FUF: TUnidadeFederativa;
  public
    constructor Create(AIdCidade: Integer; const ANome: string; AUF: TUnidadeFederativa);

    property IdCidade: Integer             read FIdCidade write FIdCidade;
    property Nome    : string              read FNOME     write FNOME;
    property UF      : TUnidadeFederativa  read FUF       write FUF;
  end;

implementation

constructor TCidade.Create(AIdCidade: Integer; const ANome: string; AUF: TUnidadeFederativa);
begin
  inherited Create();

  FIdCidade := AIdCidade;
  FNOME     := ANome;
  FUF       := AUF;
end;

end.

