unit Domain.Entities.Pedido;

interface

uses
  System.SysUtils,
  Generics.Collections,
  Domain.Entities.Cliente,
  Domain.Entities.PedidoItem;

type
  TPedido = class(TObject)
  private
    FIdPedido: Integer;
    FCliente: TCliente;
    FDataPedido: TDateTime;
    FValorTotal: Currency;
    FItems: TObjectList<TPedidoItem>;
  public
    constructor Create(AIdPedido: Integer; ACliente: TCliente);
    destructor Destroy; override;
    procedure AddItem(APedidoItem: TPedidoItem);

    property IdPedido  : Integer   read FIdPedido   write FIdPedido;
    property Cliente   : TCliente  read FCliente    write FCliente;
    property DataPedido: TDateTime read FDataPedido write FDataPedido;
    property ValorTotal: Currency  read FValorTotal;
    property Items     : TObjectList<TPedidoItem> read FItems;
  end;

implementation

constructor TPedido.Create(AIdPedido: Integer; ACliente: TCliente);
begin
  inherited Create();

  FIdPedido   := AIdPedido;
  FCliente    := ACliente;
  FDataPedido := Now;
  FValorTotal := 0;
  FItems      := TObjectList<TPedidoItem>.Create(True);
end;

destructor TPedido.Destroy;
begin
  FItems.Free;
  inherited Destroy;
end;

procedure TPedido.AddItem(APedidoItem: TPedidoItem);
begin
  if not Assigned(FItems) then
    FItems := TObjectList<TPedidoItem>.Create(True);

  FItems.Add(APedidoItem);

  FValorTotal := FValorTotal + APedidoItem.Total;
end;

end.

