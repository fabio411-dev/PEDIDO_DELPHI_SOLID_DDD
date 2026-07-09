unit Domain.ValueObjects.UnidadeMedida;

interface

uses System.SysUtils;

type
  TUnidadeMedida = class(TObject)
  private
    FIdUnidadeMedida: Integer;
    FDescricao : string;
    FSigla     : string;
  public
    constructor Create(const AIdUnidadeMedida: Integer; ADescricao, ASigla: string);

    property IdUnidadeMedida: Integer read FIdUnidadeMedida write FIdUnidadeMedida;
    property Descricao      : string  read FDescricao       write FDescricao;
    property Sigla          : string  read FSigla           write FSigla;
  end;

implementation

constructor TUnidadeMedida.Create(const AIdUnidadeMedida: Integer; ADescricao, ASigla: string);
begin
  inherited Create();

  FIdUnidadeMedida := AIdUnidadeMedida;
  FDescricao := ADescricao;
  FSigla := ASigla;
end;

end.
