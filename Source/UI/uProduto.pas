unit uProduto;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Comp.Client,
  Infra.Data.Control.ProdutoControl,
  Infra.Data.Control.UnidadeMedidaControl,
  Vcl.ComCtrls, Data.DB, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient, Vcl.Mask, Vcl.DBCtrls;

type
  TFProduto = class(TForm)
    Paginas: TPageControl;
    pgLista: TTabSheet;
    pgDetalhe: TTabSheet;
    GradeProduto: TDBGrid;
    edPesquisa: TEdit;
    lbProdutoNome: TLabel;
    btnPesquisar: TButton;
    btnNovo: TButton;
    edDetDescricao: TDBEdit;
    lkUnidadeMedida: TDBLookupComboBox;
    edDetPrecoVenda: TDBEdit;
    lbDetDescricao: TLabel;
    lbDetPreco: TLabel;
    lbDetUnMed: TLabel;
    btnEditar: TButton;
    btnGravar: TButton;
    btnCancelar: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure pgDetalheShow(Sender: TObject);
  private
    FConnection : TFDConnection;
    objProdutoControl : TProdutoControl;
    objUnidadeMedidaControl : TUnidadeMedidaControl;
    procedure HabilitarEdicao(ALigar : Boolean);
  public
    constructor Create(AOwner : TComponent; AConnection : TFDConnection); overload;
  end;

implementation

{$R *.dfm}

{ TFProduto }

procedure TFProduto.btnCancelarClick(Sender: TObject);
begin
  objProdutoControl.Cancelar;

  HabilitarEdicao(False);
end;

procedure TFProduto.btnEditarClick(Sender: TObject);
begin
  objProdutoControl.PrepararEdicao;

  HabilitarEdicao(True);
end;

procedure TFProduto.btnGravarClick(Sender: TObject);
begin
  objProdutoControl.Gravar;

  HabilitarEdicao(False);
end;

procedure TFProduto.btnNovoClick(Sender: TObject);
begin
  objProdutoControl.PrepararInclusao;

  HabilitarEdicao(True);
end;

procedure TFProduto.btnPesquisarClick(Sender: TObject);
begin
  objProdutoControl.CarregarProdutoPartial(edPesquisa.Text);
end;

constructor TFProduto.Create(AOwner: TComponent; AConnection: TFDConnection);
begin
  inherited Create(AOwner);

  FConnection := AConnection;

  objProdutoControl := TProdutoControl.Create(Self, FConnection);
  GradeProduto.DataSource := objProdutoControl.DSProduto;
  edDetDescricao.DataSource := objProdutoControl.DSProduto;
  edDetPrecoVenda.DataSource := objProdutoControl.DSProduto;
  lkUnidadeMedida.DataSource := objProdutoControl.DSProduto;

  objUnidadeMedidaControl := TUnidadeMedidaControl.Create(Self, FConnection);
  lkUnidadeMedida.ListSource := objUnidadeMedidaControl.DSUnidadeMedida;
  objUnidadeMedidaControl.Carregar;
end;

procedure TFProduto.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(objProdutoControl) then
    objProdutoControl.Free;

  if Assigned(objUnidadeMedidaControl) then
    objUnidadeMedidaControl.Free;

  Action := caFree;
end;

procedure TFProduto.FormShow(Sender: TObject);
begin
  Paginas.ActivePage := pgLista;
end;

procedure TFProduto.HabilitarEdicao(ALigar: Boolean);
begin
  edDetDescricao.Enabled  := ALigar;
  edDetPrecoVenda.Enabled := ALigar;
  lkUnidadeMedida.Enabled := ALigar;

  btnNovo.Enabled     := not ALigar;
  btnEditar.Enabled   := not ALigar;
  btnGravar.Enabled   := ALigar;
  btnCancelar.Enabled := ALigar;
end;

procedure TFProduto.pgDetalheShow(Sender: TObject);
begin
  HabilitarEdicao(False);
end;

end.
