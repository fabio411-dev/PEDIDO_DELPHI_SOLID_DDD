unit uCliente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  FireDAC.Comp.Client,
  Infra.Data.Control.ClienteControl,
  Infra.Data.Control.CidadeControl,
  Infra.Data.Repositories.ClienteRepository, Data.DB, Vcl.DBCtrls, Vcl.Mask, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ComCtrls;

type
  TFCliente = class(TForm)
    Paginas: TPageControl;
    pgLista: TTabSheet;
    lbClienteNome: TLabel;
    GradeCliente: TDBGrid;
    edPesquisa: TEdit;
    btnPesquisar: TButton;
    pgDetalhe: TTabSheet;
    lbDetNome: TLabel;
    lbDocumento: TLabel;
    lbCidade: TLabel;
    btnNovo: TButton;
    edDetNOME: TDBEdit;
    lkCidade: TDBLookupComboBox;
    edDocumento: TDBEdit;
    btnEditar: TButton;
    btnGravar: TButton;
    btnCancelar: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
    procedure btnNovoClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
  private
    FConnection : TFDConnection;
    objClienteControl : TClienteControl;
    objCidadeControl : TCidadeControl;
    procedure HabilitarEdicao(ALigar : Boolean);
  public
    constructor Create(AOwner : TComponent; AConnection : TFDConnection); overload;
  end;

implementation

{$R *.dfm}

{ TFCliente }

procedure TFCliente.btnCancelarClick(Sender: TObject);
begin
  objClienteControl.Cancelar;

  HabilitarEdicao(False);
end;

procedure TFCliente.btnEditarClick(Sender: TObject);
begin
  objClienteControl.PrepararEdicao;

  HabilitarEdicao(True);
end;

procedure TFCliente.btnGravarClick(Sender: TObject);
begin
  objClienteControl.Gravar;

  HabilitarEdicao(False);
end;

procedure TFCliente.btnNovoClick(Sender: TObject);
begin
  objClienteControl.PrepararInclusao;

  HabilitarEdicao(True);
end;

procedure TFCliente.btnPesquisarClick(Sender: TObject);
begin
  objClienteControl.CarregarClientePartial(edPesquisa.Text);
end;

constructor TFCliente.Create(AOwner: TComponent; AConnection: TFDConnection);
begin
  inherited Create(AOwner);

  FConnection := AConnection;

  objClienteControl := TClienteControl.Create(Self, FConnection);
  GradeCliente.DataSource := objClienteControl.DSCliente;
  edDetNOME.DataSource    := objClienteControl.DSCliente;
  edDocumento.DataSource  := objClienteControl.DSCliente;
  lkCidade.DataSource     := objClienteControl.DSCliente;

  objCidadeControl := TCidadeControl.Create(Self, FConnection);
  lkCidade.ListSource := objCidadeControl.DSCidade;
  objCidadeControl.Carregar;
end;

procedure TFCliente.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(objClienteControl) then
    objClienteControl.Free;

  if Assigned(objCidadeControl) then
    objCidadeControl.Free;

  Action := caFree;
end;

procedure TFCliente.FormShow(Sender: TObject);
begin
  Paginas.ActivePage := pgLista;
end;

procedure TFCliente.HabilitarEdicao(ALigar: Boolean);
begin
  edDetNOME.Enabled   := ALigar;
  edDocumento.Enabled := ALigar;
  lkCidade.Enabled    := ALigar;

  btnNovo.Enabled     := not ALigar;
  btnEditar.Enabled   := not ALigar;
  btnGravar.Enabled   := ALigar;
  btnCancelar.Enabled := ALigar;
end;

end.
