object FCliente: TFCliente
  Left = 0
  Top = 0
  Caption = 'Clientes'
  ClientHeight = 387
  ClientWidth = 716
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
    Width = 716
    Height = 387
    ActivePage = pgLista
    Align = alClient
    TabOrder = 0
    object pgLista: TTabSheet
      Caption = 'Lista de Clientes'
      ExplicitLeft = 8
      ExplicitTop = 28
      object lbClienteNome: TLabel
        Left = 3
        Top = 5
        Width = 78
        Height = 13
        Caption = 'Nome do Cliente'
      end
      object GradeCliente: TDBGrid
        Left = 0
        Top = 66
        Width = 708
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
            FieldName = 'IDCLIENTE'
            Title.Caption = 'C'#243'digo'
            Width = 58
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'NOME'
            Title.Caption = 'Nome'
            Width = 352
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DOCUMENTO'
            Title.Caption = 'Documento'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'CIDADE'
            Title.Caption = 'Cidade'
            Width = 88
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'SIGLA'
            Title.Caption = 'UF'
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
      Caption = 'Detalhe do Cliente'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lbDetNome: TLabel
        Left = 3
        Top = 67
        Width = 27
        Height = 13
        Caption = 'Nome'
      end
      object lbDocumento: TLabel
        Left = 3
        Top = 107
        Width = 69
        Height = 13
        Caption = 'N'#186' Documento'
      end
      object lbCidade: TLabel
        Left = 3
        Top = 148
        Width = 33
        Height = 13
        Caption = 'Cidade'
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
      object edDetNOME: TDBEdit
        Left = 96
        Top = 64
        Width = 313
        Height = 21
        DataField = 'NOME'
        TabOrder = 1
      end
      object lkCidade: TDBLookupComboBox
        Left = 96
        Top = 144
        Width = 145
        Height = 21
        DataField = 'IDCIDADE'
        KeyField = 'IDCIDADE'
        ListField = 'CIDADE;SIGLA'
        TabOrder = 2
      end
      object edDocumento: TDBEdit
        Left = 96
        Top = 104
        Width = 121
        Height = 21
        DataField = 'DOCUMENTO'
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
