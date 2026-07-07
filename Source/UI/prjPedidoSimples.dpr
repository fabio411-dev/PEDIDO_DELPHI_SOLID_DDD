program prjPedidoSimples;

uses
  Vcl.Forms,
  uPrincipal in 'uPrincipal.pas' {Form1},
  uDMConexao in '..\Infrastructure\Persistence\Firebird\uDMConexao.pas' {DMConexao: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDMConexao, DMConexao);
  Application.Run;
end.
