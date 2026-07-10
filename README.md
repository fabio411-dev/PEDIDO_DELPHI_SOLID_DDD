# PEDIDO_DELPHI_SOLID_DDD
Pedidos simples em Delphi utilizando SOLID + DDD

# Sistema Simples de Pedido de Vendas – Delphi

## Visão geral

- **Domínio**: Entidades : Cliente, Produto, Pedido e ItemPedido.
- **VOs** : Cidade, CNPJ, CPF, Unidade Federativa, Unidade de Medida
- **Infraestrutura**: Persistência em Firebird (FireDAC).  
- **UI Demo**: Demonstra a criação de cliente, produto e pedido, com componentes visuais default. 

## Requisitos

| Item | Versão |
|------|--------|
| Delphi | XE7 ou superior |
| FireDAC | incluído no IDE |

## Config. Inicial
- Criar um novo banco do Firebird
- Executar os Scripts de Criação de DOMAINS e TABLES da Pasta DB deste projeto
- Opcional : Script de dados default V00003
- Configurar conexão no arquivo de exemplo **config.ini** na raiz do projeto.


## Compilação / Execução

# Clonar este repositório
# Abra o projeto no Delphi (prjPedidoSimples.dproj)
# Compilar/Build
# Execute : ./prjPedidoSimples.exe
