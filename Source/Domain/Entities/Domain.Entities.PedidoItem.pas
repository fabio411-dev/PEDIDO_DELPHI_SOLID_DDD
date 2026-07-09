unit Domain.Entities.PedidoItem;

interface

uses
  System.SysUtils,
  Domain.Entities.Produto;

type
  TPedidoItem = class(TObject)
  private
    FIdPedidoItem: Integer;
    FIdPedido: Integer;
    FProduto: TProduto;
    FQtde: Double;
    FValorUnit: Currency;
  public
    constructor Create(AIdPedidoItem, AIdPedido: Integer; AProduto: TProduto; const AQtde: Double; const AValorUnit: Currency);
    property IdPedidoItem : Integer  read FIdPedidoItem write FIdPedidoItem;
    property IdPedido     : Integer  read FIdPedido     write FIdPedido;
    property Produto      : TProduto read FProduto      write FProduto;
    property Qtde         : Double   read FQtde         write FQtde;
    property ValorUnit    : Currency read FValorUnit    write FValorUnit;
    function Total        : Currency; inline;
  end;

implementation

constructor TPedidoItem.Create(AIdPedidoItem, AIdPedido: Integer; AProduto: TProduto; const AQtde: Double; const AValorUnit: Currency);
begin
  inherited Create();

  FIdPedidoItem := AIdPedidoItem;
  FIdPedido     := AIdPedido;
  FProduto      := AProduto;
  FQtde         := AQtde;
  FValorUnit    := AValorUnit;
end;

function TPedidoItem.Total: Currency;
begin
  Result := FQtde * FValorUnit;
end;

end.

