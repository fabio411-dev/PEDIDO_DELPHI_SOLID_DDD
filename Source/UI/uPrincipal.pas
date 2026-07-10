unit uPrincipal;

interface

uses
  Winapi.Windows,
  FireDAC.Comp.Client,
  Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.Actions, Vcl.ActnList, Vcl.PlatformDefaultStyleActnCtrls, Vcl.ActnMan, Vcl.Menus;

type
  TFPrincipal = class(TForm)
    MenuPrincipal: TMainMenu;
    Cadastro1: TMenuItem;
    Movimento1: TMenuItem;
    Pedidos1: TMenuItem;
    Produto1: TMenuItem;
    ActionPrincipal: TActionManager;
    acProduto: TAction;
    acCliente: TAction;
    Clientes1: TMenuItem;
    acPedido: TAction;
    procedure acProdutoExecute(Sender: TObject);
    procedure acClienteExecute(Sender: TObject);
    procedure acPedidoExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FConnection : TFDConnection;
  public
    { Public declarations }
  end;

var
  FPrincipal: TFPrincipal;

implementation

{$R *.dfm}

uses uProduto, uCliente, uPedido, uDMConexao;

procedure TFPrincipal.acClienteExecute(Sender: TObject);
var
  FCliente: TFCliente;
begin
  FCliente := TFCliente.Create(Self, FConnection);

  FCliente.Show;
end;

procedure TFPrincipal.acPedidoExecute(Sender: TObject);
var
  FPedido: TFPedido;
begin
  FPedido := TFPedido.Create(Self, FConnection);

  FPedido.Show;
end;

procedure TFPrincipal.acProdutoExecute(Sender: TObject);
var
  FProduto: TFProduto;
begin
  FProduto := TFProduto.Create(Self, FConnection);

  FProduto.Show;
end;

procedure TFPrincipal.FormCreate(Sender: TObject);
begin
  FConnection := DMConexao.FDConexao;
end;

end.
