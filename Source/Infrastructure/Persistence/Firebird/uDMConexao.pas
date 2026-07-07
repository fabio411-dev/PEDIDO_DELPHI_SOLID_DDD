unit uDMConexao;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, Data.DB, IniFiles, Vcl.Dialogs, FireDAC.Phys.IBDef,
  FireDAC.Phys.IBBase, FireDAC.Phys.IB;

type
  TDMConexao = class(TDataModule)
    FDConexao: TFDConnection;
    FDTrans: TFDTransaction;
    FDPhysIBDriverLink1: TFDPhysIBDriverLink;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure LoadConnectionFromIni;
  public
    { Public declarations }
  end;

var
  DMConexao: TDMConexao;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TDMConexao }

procedure TDMConexao.DataModuleCreate(Sender: TObject);
begin
  LoadConnectionFromIni;
end;

procedure TDMConexao.LoadConnectionFromIni;
var
  LIni: TIniFile;
  LSection: string ;
begin
  LSection := 'Database';
  LIni := TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'config.ini');
  try
    try
      FDConexao.Params.Clear;
      FDConexao.Params.Add('Database=' + LIni.ReadString(LSection, 'Database', ''));
      FDConexao.Params.Add('User_Name=' + LIni.ReadString(LSection, 'Username', ''));
      FDConexao.Params.Add('Password=' + LIni.ReadString(LSection, 'Password', ''));
      FDConexao.Params.Add('Server=' + LIni.ReadString(LSection, 'Server', ''));
      FDConexao.Params.Add('Port=' + IntToStr( LIni.ReadInteger(LSection, 'Port', 3050) ) );
      FDConexao.Params.Add('ClientLibrary=' + LIni.ReadString(LSection, 'ClientLibrary', '') );
      FDConexao.Params.Add('DriverID=IB');
      FDConexao.LoginPrompt := False;

      FDConexao.Open;
      FDTrans.Connection := FDConexao;
    finally
      LIni.Free;
    end;
  except on E : Exception do
    begin
      ShowMessage('Não foi possível conectar ao banco de dados : ' + #13 + E.Message);
    end;
  end;
end;

end.
