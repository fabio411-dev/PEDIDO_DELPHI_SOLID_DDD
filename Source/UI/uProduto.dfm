object FProduto: TFProduto
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = 'Produtos'
  ClientHeight = 385
  ClientWidth = 779
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
    Width = 779
    Height = 385
    ActivePage = pgDetalhe
    Align = alClient
    TabOrder = 0
    object pgLista: TTabSheet
      Caption = 'Lista de Produtos'
      object lbProdutoNome: TLabel
        Left = 3
        Top = 5
        Width = 102
        Height = 13
        Caption = 'Descri'#231#227'o do Produto'
      end
      object GradeProduto: TDBGrid
        Left = 0
        Top = 64
        Width = 771
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
            FieldName = 'IDPRODUTO'
            Title.Caption = 'C'#243'digo'
            Width = 58
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DESCRICAO'
            Title.Caption = 'Descri'#231#227'o'
            Width = 352
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SIGLA'
            Title.Caption = 'Un.'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'PRECO_VENDA'
            Title.Caption = 'Pre'#231'o'
            Width = 88
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
      Caption = 'Detalhe do Produto'
      ImageIndex = 1
      OnShow = pgDetalheShow
      object lbDetDescricao: TLabel
        Left = 3
        Top = 67
        Width = 46
        Height = 13
        Caption = 'Descri'#231#227'o'
      end
      object lbDetPreco: TLabel
        Left = 3
        Top = 107
        Width = 75
        Height = 13
        Caption = 'Pre'#231'o de Venda'
      end
      object lbDetUnMed: TLabel
        Left = 3
        Top = 148
        Width = 54
        Height = 13
        Caption = 'Un. Medida'
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
      object edDetDescricao: TDBEdit
        Left = 96
        Top = 64
        Width = 313
        Height = 21
        DataField = 'DESCRICAO'
        TabOrder = 1
      end
      object lkUnidadeMedida: TDBLookupComboBox
        Left = 96
        Top = 144
        Width = 145
        Height = 21
        DataField = 'IDUNIDADE'
        KeyField = 'IDUNIDADE'
        ListField = 'SIGLA'
        TabOrder = 2
      end
      object edDetPrecoVenda: TDBEdit
        Left = 96
        Top = 104
        Width = 121
        Height = 21
        DataField = 'PRECO_VENDA'
        TabOrder = 3
      end
      object btnEditar: TButton
        Left = 67
        Top = 3
        Width = 49
        Height = 25
        Caption = 'Editar'
        TabOrder = 4
        OnClick = btnEditarClick
      end
      object btnGravar: TButton
        Left = 192
        Top = 3
        Width = 49
        Height = 25
        Caption = 'Gravar'
        TabOrder = 5
        OnClick = btnGravarClick
      end
      object btnCancelar: TButton
        Left = 247
        Top = 3
        Width = 50
        Height = 25
        Caption = 'Cancelar'
        TabOrder = 6
        OnClick = btnCancelarClick
      end
    end
  end
end
