object FPedido: TFPedido
  Left = 0
  Top = 0
  Caption = 'Pedidos'
  ClientHeight = 482
  ClientWidth = 773
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poMainFormCenter
  Visible = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Paginas: TPageControl
    Left = 0
    Top = 0
    Width = 773
    Height = 482
    ActivePage = pgDetalhe
    Align = alClient
    TabOrder = 0
    object pgLista: TTabSheet
      Caption = 'Lista de Pedidos'
      ExplicitWidth = 708
      ExplicitHeight = 359
      object lbClienteNome: TLabel
        Left = 3
        Top = 5
        Width = 78
        Height = 13
        Caption = 'Nome do Cliente'
      end
      object GradePedido: TDBGrid
        Left = 0
        Top = 161
        Width = 765
        Height = 293
        Align = alBottom
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'IDPEDIDO'
            Title.Caption = 'Pedido'
            Width = 58
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NOME'
            Title.Caption = 'Cliente'
            Width = 352
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DATA_PEDIDO'
            Title.Caption = 'Data'
            Width = 125
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'VALOR_TOTAL'
            Title.Caption = 'Total'
            Width = 106
            Visible = True
          end>
      end
      object edPesquisa: TEdit
        Left = 3
        Top = 24
        Width = 278
        Height = 21
        TabOrder = 1
      end
      object btnPesquisar: TButton
        Left = 336
        Top = 20
        Width = 75
        Height = 25
        Caption = 'Pesquisar'
        TabOrder = 2
        OnClick = btnPesquisarClick
      end
    end
    object pgDetalhe: TTabSheet
      Caption = 'Detalhe do Pedido'
      ImageIndex = 1
      OnShow = pgDetalheShow
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lbDetNome: TLabel
        Left = 3
        Top = 67
        Width = 33
        Height = 13
        Caption = 'Cliente'
      end
      object lbDocumento: TLabel
        Left = 3
        Top = 90
        Width = 69
        Height = 13
        Caption = 'N'#186' Documento'
      end
      object lbCidade: TLabel
        Left = 299
        Top = 90
        Width = 33
        Height = 13
        Caption = 'Cidade'
      end
      object lbProduto: TLabel
        Left = 3
        Top = 204
        Width = 38
        Height = 13
        Caption = 'Produto'
      end
      object lbQtde: TLabel
        Left = 3
        Top = 231
        Width = 34
        Height = 13
        Caption = 'Quant.'
      end
      object lbVrUnit: TLabel
        Left = 235
        Top = 231
        Width = 42
        Height = 13
        Caption = 'Vlr. Unit.'
      end
      object btnNovo: TButton
        Left = 3
        Top = 3
        Width = 49
        Height = 25
        Caption = 'Novo'
        TabOrder = 0
        OnClick = btnNovoClick
      end
      object lkCidade: TDBLookupComboBox
        Left = 338
        Top = 87
        Width = 175
        Height = 21
        DataField = 'IDCIDADE'
        KeyField = 'IDCIDADE'
        ListField = 'CIDADE;SIGLA'
        TabOrder = 1
      end
      object edDocumento: TDBEdit
        Left = 79
        Top = 87
        Width = 121
        Height = 21
        DataField = 'DOCCLIENTE'
        TabOrder = 2
      end
      object btnEditar: TButton
        Left = 67
        Top = 3
        Width = 49
        Height = 25
        Caption = 'Editar'
        TabOrder = 3
        OnClick = btnEditarClick
      end
      object btnGravar: TButton
        Left = 192
        Top = 3
        Width = 49
        Height = 25
        Caption = 'Gravar'
        TabOrder = 4
        OnClick = btnGravarClick
      end
      object btnCancelar: TButton
        Left = 247
        Top = 3
        Width = 50
        Height = 25
        Caption = 'Cancelar'
        TabOrder = 5
        OnClick = btnCancelarClick
      end
      object lkCliente: TDBLookupComboBox
        Left = 79
        Top = 60
        Width = 434
        Height = 21
        DataField = 'IDCLIENTE'
        KeyField = 'IDCLIENTE'
        ListField = 'NOME'
        TabOrder = 6
      end
      object GradePedidoItem: TDBGrid
        Left = 0
        Top = 272
        Width = 765
        Height = 182
        Align = alBottom
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 7
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'IDPRODUTO'
            Title.Caption = 'C'#243'digo'
            Width = 58
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DESCPRODUTO'
            Title.Caption = 'Produto'
            Width = 334
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'QTDE'
            Title.Caption = 'Qtde.'
            Width = 106
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'VALOR_UNIT'
            Title.Caption = 'Vr. Un.'
            Width = 106
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'VALOR_TOTAL'
            Title.Caption = 'Total'
            Width = 112
            Visible = True
          end>
      end
      object lkProduto: TDBLookupComboBox
        Left = 79
        Top = 201
        Width = 325
        Height = 21
        DataField = 'IDPRODUTO'
        KeyField = 'IDPRODUTO'
        ListField = 'DESCRICAO'
        TabOrder = 8
      end
      object edQuant: TDBEdit
        Left = 79
        Top = 228
        Width = 121
        Height = 21
        DataField = 'QTDE'
        TabOrder = 9
      end
      object edVrUnit: TDBEdit
        Left = 283
        Top = 228
        Width = 121
        Height = 21
        DataField = 'VALOR_UNIT'
        TabOrder = 10
      end
      object btnNovoItem: TButton
        Left = 451
        Top = 224
        Width = 49
        Height = 25
        Caption = 'Novo'
        TabOrder = 11
        OnClick = btnNovoItemClick
      end
      object btnGravarItem: TButton
        Left = 506
        Top = 224
        Width = 79
        Height = 25
        Caption = 'Gravar Prod.'
        TabOrder = 12
        OnClick = btnGravarItemClick
      end
    end
  end
end
