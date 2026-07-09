unit Domain.ValueObjects.UnidadeFederativa;

interface

uses
  System.SysUtils;

type
  TUnidadeFederativa = class(TObject)
  private
    FIdUF: Integer;
    FNOME: string;
    FSIGLA: string;
  public
    constructor Create(AIdUF: Integer; const ANome, ASigla: string);

    property IdUF : Integer read FIdUF  write FIdUF;
    property Nome : string  read FNOME  write FNOME;
    property Sigla: string  read FSIGLA write FSIGLA;
  end;

implementation

constructor TUnidadeFederativa.Create(AIdUF: Integer; const ANome, ASigla: string);
begin
  inherited Create();

  FIdUF  := AIdUF;
  FNOME  := ANome;
  FSIGLA := ASigla;
end;

end.

