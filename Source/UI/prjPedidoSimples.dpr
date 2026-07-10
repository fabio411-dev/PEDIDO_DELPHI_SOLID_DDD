program prjPedidoSimples;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {FPrincipal},
  uDMConexao in '..\Infrastructure\Persistence\Firebird\uDMConexao.pas' {DMConexao: TDataModule},
  Domain.ValueObjects.CPF in '..\Domain\ValueObjects\Domain.ValueObjects.CPF.pas',
  Domain.ValueObjects.Cnpj in '..\Domain\ValueObjects\Domain.ValueObjects.Cnpj.pas',
  Domain.Entities.Produto in '..\Domain\Entities\Domain.Entities.Produto.pas',
  Domain.ValueObjects.UnidadeMedida in '..\Domain\ValueObjects\Domain.ValueObjects.UnidadeMedida.pas',
  Domain.ValueObjects.IDocumento in '..\Domain\ValueObjects\Domain.ValueObjects.IDocumento.pas',
  uProduto in 'uProduto.pas' {FProduto},
  uCliente in 'uCliente.pas' {FCliente},
  uPedido in 'uPedido.pas' {FPedido},
  Domain.ValueObjects.UnidadeFederativa in '..\Domain\ValueObjects\Domain.ValueObjects.UnidadeFederativa.pas',
  Domain.ValueObjects.Cidade in '..\Domain\ValueObjects\Domain.ValueObjects.Cidade.pas',
  Domain.Entities.Cliente in '..\Domain\Entities\Domain.Entities.Cliente.pas',
  Domain.Entities.PedidoItem in '..\Domain\Entities\Domain.Entities.PedidoItem.pas',
  Domain.Entities.Pedido in '..\Domain\Entities\Domain.Entities.Pedido.pas',
  Domain.Interfaces.IClienteRepository in '..\Domain\Interfaces\Domain.Interfaces.IClienteRepository.pas',
  Domain.Interfaces.IProdutoRepository in '..\Domain\Interfaces\Domain.Interfaces.IProdutoRepository.pas',
  Domain.Interfaces.IPedidoRepository in '..\Domain\Interfaces\Domain.Interfaces.IPedidoRepository.pas',
  Infra.Data.Repositories.ClienteRepository in '..\Infrastructure\Data\Repository\Infra.Data.Repositories.ClienteRepository.pas',
  Infra.Data.Repositories.ProdutoRepository in '..\Infrastructure\Data\Repository\Infra.Data.Repositories.ProdutoRepository.pas',
  Infra.Data.Repositories.PedidoRepository in '..\Infrastructure\Data\Repository\Infra.Data.Repositories.PedidoRepository.pas',
  App.Services.ClienteService in '..\Application\Service\App.Services.ClienteService.pas',
  App.Services.PedidoService in '..\Application\Service\App.Services.PedidoService.pas',
  Infra.Data.Control.ProdutoControl in '..\Infrastructure\Data\Control\Infra.Data.Control.ProdutoControl.pas',
  Domain.Interfaces.IUnidadeMedidaRepository in '..\Domain\Interfaces\Domain.Interfaces.IUnidadeMedidaRepository.pas',
  Infra.Data.Repositories.UnidadeMedidaRepository in '..\Infrastructure\Data\Repository\Infra.Data.Repositories.UnidadeMedidaRepository.pas',
  App.Services.UnidadeMedidaService in '..\Application\Service\App.Services.UnidadeMedidaService.pas',
  Infra.Data.Control.UnidadeMedidaControl in '..\Infrastructure\Data\Control\Infra.Data.Control.UnidadeMedidaControl.pas',
  Infra.Data.Control.ClienteControl in '..\Infrastructure\Data\Control\Infra.Data.Control.ClienteControl.pas',
  Domain.Interfaces.ICidadeRepository in '..\Domain\Interfaces\Domain.Interfaces.ICidadeRepository.pas',
  Infra.Data.Repositories.CidadeRepository in '..\Infrastructure\Data\Repository\Infra.Data.Repositories.CidadeRepository.pas',
  Infra.Data.Control.CidadeControl in '..\Infrastructure\Data\Control\Infra.Data.Control.CidadeControl.pas',
  Infra.Data.Control.PedidoControl in '..\Infrastructure\Data\Control\Infra.Data.Control.PedidoControl.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDMConexao, DMConexao);
  Application.CreateForm(TFPrincipal, FPrincipal);
  Application.Run;
end.
