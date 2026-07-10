unit uPedido;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Comp.Client,
  App.Services.ClienteService,
  Infra.Data.Control.CidadeControl,
  Infra.Data.Control.PedidoControl,
  App.Services.PedidoService, Data.DB, Vcl.DBCtrls, Vcl.Mask, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls;

type
  TFPedido = class(TForm)
    Paginas: TPageControl;
    pgLista: TTabSheet;
    lbClienteNome: TLabel;
    GradePedido: TDBGrid;
    edPesquisa: TEdit;
    btnPesquisar: TButton;
    pgDetalhe: TTabSheet;
    lbDetNome: TLabel;
    lbDocumento: TLabel;
    lbCidade: TLabel;
    btnNovo: TButton;
    lkCidade: TDBLookupComboBox;
    edDocumento: TDBEdit;
    btnEditar: TButton;
    btnGravar: TButton;
    btnCancelar: TButton;
    lkCliente: TDBLookupComboBox;
    GradePedidoItem: TDBGrid;
    lkProduto: TDBLookupComboBox;
    lbProduto: TLabel;
    edQuant: TDBEdit;
    lbQtde: TLabel;
    lbVrUnit: TLabel;
    edVrUnit: TDBEdit;
    btnNovoItem: TButton;
    btnGravarItem: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnNovoItemClick(Sender: TObject);
    procedure btnGravarItemClick(Sender: TObject);
    procedure pgDetalheShow(Sender: TObject);
  private
    FConnection : TFDConnection;
    objCidadeControl : TCidadeControl;
    objPedidoControl : TPedidoControl;

    procedure HabilitarEdicao(ALigar : Boolean);
  public
    constructor Create(AOwner : TComponent; AConnection : TFDConnection); overload;
  end;

implementation

{$R *.dfm}

{ TFPedido }

procedure TFPedido.btnCancelarClick(Sender: TObject);
begin
  objPedidoControl.Cancelar;

  HabilitarEdicao(False);
end;

procedure TFPedido.btnEditarClick(Sender: TObject);
begin
  objPedidoControl.PrepararEdicao;

  HabilitarEdicao(True);
end;

procedure TFPedido.btnGravarClick(Sender: TObject);
begin
  objPedidoControl.Gravar;

  HabilitarEdicao(False);
end;

procedure TFPedido.btnNovoClick(Sender: TObject);
begin
  objPedidoControl.PrepararInclusao;

  HabilitarEdicao(True);
end;

procedure TFPedido.btnNovoItemClick(Sender: TObject);
begin
  objPedidoControl.PrepararInclusaoItem;
end;

procedure TFPedido.btnPesquisarClick(Sender: TObject);
begin
  objPedidoControl.CarregarPedidoPartial(edPesquisa.Text);
end;

procedure TFPedido.btnGravarItemClick(Sender: TObject);
begin
  objPedidoControl.GravarItem;
end;

constructor TFPedido.Create(AOwner: TComponent; AConnection: TFDConnection);
begin
  inherited Create(AOwner);

  FConnection := AConnection;

  objPedidoControl := TPedidoControl.Create(Self, FConnection);
  GradePedido.DataSource     := objPedidoControl.DSPedido;
  edDocumento.DataSource     := objPedidoControl.DSPedido;
  lkCidade.DataSource        := objPedidoControl.DSPedido;
  lkCliente.DataSource       := objPedidoControl.DSPedido;
  lkCliente.ListSource       := objPedidoControl.DSCliente;
  GradePedidoItem.DataSource := objPedidoControl.DSPedidoItem;
  lkProduto.DataSource       := objPedidoControl.DSPedidoItem;
  lkProduto.ListSource       := objPedidoControl.DSProduto;
  edQuant.DataSource         := objPedidoControl.DSPedidoItem;
  edVrUnit.DataSource        := objPedidoControl.DSPedidoItem;

  objCidadeControl := TCidadeControl.Create(Self, FConnection);
  lkCidade.ListSource := objCidadeControl.DSCidade;
  objCidadeControl.Carregar;
end;

procedure TFPedido.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TFPedido.FormShow(Sender: TObject);
begin
  Paginas.ActivePage := pgLista;
end;

procedure TFPedido.HabilitarEdicao(ALigar: Boolean);
begin
  lkCliente.Enabled   := ALigar;
  edDocumento.Enabled := False;
  lkCidade.Enabled    := False;

  lkProduto.Enabled   := ALigar;
  edQuant.Enabled     := ALigar;
  edVrUnit.Enabled    := ALigar;

  btnNovo.Enabled     := not ALigar;
  btnEditar.Enabled   := not ALigar;
  btnGravar.Enabled   := ALigar;
  btnCancelar.Enabled := ALigar;
end;

procedure TFPedido.pgDetalheShow(Sender: TObject);
begin
  objPedidoControl.ShowPedidoItens( objPedidoControl.DSPedido.DataSet.FieldByName('IDPEDIDO').AsInteger);
end;

end.
