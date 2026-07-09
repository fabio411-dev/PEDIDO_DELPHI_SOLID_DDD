unit App.Services.PedidoService;

interface

uses
  System.SysUtils,
  Domain.Interfaces.IClienteRepository,
  Domain.Interfaces.IProdutoRepository,
  Domain.Interfaces.IPedidoRepository,
  Domain.Entities.Pedido,
  Domain.Entities.PedidoItem,
  Domain.Entities.Produto,
  Domain.Entities.Cliente;

type
  TPedidoItemInput = record
    IdProduto   : Integer;
    Quantidade  : Double;
  end;

  TPedidoService = class
  private
    FClientRepo : IClienteRepository;
    FProdutoRepo: IProdutoRepository;
    FPedidoRepo : IPedidoRepository;
  public
    constructor Create(AClientRepo: IClienteRepository; AProdutoRepo: IProdutoRepository; APedidoRepo: IPedidoRepository);
    procedure CreatePedido(AIdCliente: Integer; const AItems: array of TPedidoItemInput);
  end;

implementation

constructor TPedidoService.Create(AClientRepo: IClienteRepository; AProdutoRepo: IProdutoRepository; APedidoRepo: IPedidoRepository);
begin
  inherited Create();

  FClientRepo  := AClientRepo;
  FProdutoRepo := AProdutoRepo;
  FPedidoRepo  := APedidoRepo;
end;

procedure TPedidoService.CreatePedido(AIdCliente: Integer; const AItems: array of TPedidoItemInput);
var
  i : Integer;
  objCliente    : TCliente;
  objPedido     : TPedido;
  objProduto    : TProduto;
  objPedidoItem : TPedidoItem;
begin
  objCliente := FClientRepo.FindById(AIdCliente);
  if not Assigned(objCliente) then
    raise Exception.CreateFmt('Cliente com id %d não encontrado', [AIdCliente]);

  objPedido := TPedido.Create(0, objCliente);

  for i := 0 to High(AItems) do
  begin
    objProduto := FProdutoRepo.FindById(AItems[i].IdProduto);
    if not Assigned(objProduto) then
      raise Exception.CreateFmt('Produto com id %d não encontrado', [AItems[i].IdProduto]);

    objPedidoItem := TPedidoItem.Create(
      0,
      objPedido.IdPedido,
      objProduto,
      AItems[i].Quantidade,
      objProduto.Precovenda);

    objPedido.AddItem(objPedidoItem);
  end;

  FPedidoRepo.Add(objPedido);
end;

end.

