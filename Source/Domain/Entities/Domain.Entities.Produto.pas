unit Domain.Entities.Produto;

interface

uses System.SysUtils, Domain.ValueObjects.UnidadeMedida;

type
  TProduto = class(TObject)
  private
    FIdProduto: Integer;
    FDescricao: string;
    FPrecoVenda: Currency;
    FUnidadeMedida: TUnidadeMedida;
  public
    constructor Create( AIdProduto: Integer; const ADescricao: string; APrecoVenda: Currency);
    property IdProduto    : Integer        read FIdProduto     write FIdProduto;
    property Descricao    : string         read FDescricao     write FDescricao;
    property PrecoVenda   : Currency       read FPrecoVenda    write FPrecoVenda;
    property UnidadeMedida: TUnidadeMedida read FUnidadeMedida write FUnidadeMedida;
  end;

implementation

constructor TProduto.Create(AIdProduto: Integer; const ADescricao: string; APrecoVenda: Currency);
begin
  inherited Create();

  FIdProduto  := AIdProduto;
  FDescricao  := ADescricao;
  FPrecoVenda := APrecoVenda;
end;

end.
