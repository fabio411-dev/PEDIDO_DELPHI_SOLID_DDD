object FPrincipal: TFPrincipal
  Left = 0
  Top = 0
  Caption = 'Pedidos Simples'
  ClientHeight = 709
  ClientWidth = 1014
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MenuPrincipal
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MenuPrincipal: TMainMenu
    Left = 304
    Top = 88
    object Cadastro1: TMenuItem
      Caption = 'Cadastro'
      object Produto1: TMenuItem
        Action = acProduto
      end
      object Clientes1: TMenuItem
        Action = acCliente
      end
    end
    object Movimento1: TMenuItem
      Caption = 'Movimento'
      object Pedidos1: TMenuItem
        Action = acPedido
      end
    end
  end
  object ActionPrincipal: TActionManager
    Left = 304
    Top = 24
    StyleName = 'Platform Default'
    object acProduto: TAction
      Category = 'Cadastro'
      Caption = 'Produtos'
      OnExecute = acProdutoExecute
    end
    object acCliente: TAction
      Category = 'Cadastro'
      Caption = 'Clientes'
      OnExecute = acClienteExecute
    end
    object acPedido: TAction
      Category = 'Movimento'
      Caption = 'Pedidos'
      OnExecute = acPedidoExecute
    end
  end
end
