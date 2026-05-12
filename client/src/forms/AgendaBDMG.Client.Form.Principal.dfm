object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Agenda BDMG - Gerenciamento de Tarefas'
  ClientHeight = 561
  ClientWidth = 974
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 974
    Height = 65
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitTop = -3
    object lblFiltroStatus: TLabel
      Left = 16
      Top = 8
      Width = 32
      Height = 15
      Caption = 'Status'
    end
    object lblFiltroPrioridade: TLabel
      Left = 168
      Top = 8
      Width = 54
      Height = 15
      Caption = 'Prioridade'
    end
    object cbbFiltroStatus: TComboBox
      Left = 16
      Top = 27
      Width = 129
      Height = 23
      Style = csDropDownList
      TabOrder = 0
      Items.Strings = (
        'Todos'
        'Pendente'
        'Em Andamento'
        'Conclu'#237'da'
        'Cancelada')
    end
    object cbbFiltroPrioridade: TComboBox
      Left = 168
      Top = 27
      Width = 145
      Height = 23
      Style = csDropDownList
      TabOrder = 1
      Items.Strings = (
        'Todas'
        '1 - Muito Baixa'
        '2 - Baixa'
        '3 - Normal'
        '4 - Alta'
        '5 - Cr'#237'tica')
    end
    object btnPesquisar: TButton
      Left = 336
      Top = 26
      Width = 75
      Height = 25
      Caption = 'Pesquisar'
      TabOrder = 2
      OnClick = btnPesquisarClick
    end
    object btnAtualizar: TButton
      Left = 417
      Top = 26
      Width = 75
      Height = 25
      Caption = 'Atualizar'
      TabOrder = 3
      OnClick = btnAtualizarClick
    end
  end
  object pnlEstatisticas: TPanel
    Left = 0
    Top = 425
    Width = 974
    Height = 95
    Align = alBottom
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    ExplicitWidth = 980
    object lblTotalTarefas: TLabel
      Left = 16
      Top = 13
      Width = 137
      Height = 15
      Caption = 'Total de Tarefas Ativas: 0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblMediaPrioridade: TLabel
      Left = 16
      Top = 34
      Width = 186
      Height = 15
      Caption = 'M'#233'dia Prioridade Pendentes: 0.00'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblConcluidas7Dias: TLabel
      Left = 16
      Top = 55
      Width = 113
      Height = 15
      Caption = 'Conclu'#237'das (7 dias): 0'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Segoe UI'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 520
    Width = 974
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitTop = 526
    ExplicitWidth = 980
    object lblPaginaInfo: TLabel
      AlignWithMargins = True
      Left = 109
      Top = 8
      Width = 200
      Height = 30
      Margins.Top = 8
      Align = alLeft
      Alignment = taCenter
      AutoSize = False
      Caption = 'P'#225'gina 1 de 1 (Total: 0 itens)'
      Layout = tlCenter
      ExplicitTop = 3
      ExplicitHeight = 35
    end
    object btnEditar: TButton
      AlignWithMargins = True
      Left = 659
      Top = 8
      Width = 100
      Height = 30
      Margins.Top = 8
      Align = alRight
      Caption = 'Editar'
      TabOrder = 1
      OnClick = btnEditarClick
      ExplicitLeft = 666
      ExplicitTop = 11
    end
    object btnExcluir: TButton
      AlignWithMargins = True
      Left = 765
      Top = 8
      Width = 100
      Height = 30
      Margins.Top = 8
      Align = alRight
      Caption = 'Excluir'
      TabOrder = 2
      OnClick = btnExcluirClick
      ExplicitLeft = 831
      ExplicitTop = 11
    end
    object btnAlterarStatus: TButton
      AlignWithMargins = True
      Left = 871
      Top = 8
      Width = 100
      Height = 30
      Margins.Top = 8
      Align = alRight
      Caption = 'Alterar Status'
      TabOrder = 3
      OnClick = btnAlterarStatusClick
      ExplicitLeft = 919
      ExplicitTop = 11
    end
    object btnAdicionar: TButton
      AlignWithMargins = True
      Left = 553
      Top = 8
      Width = 100
      Height = 30
      Margins.Top = 8
      Align = alRight
      Caption = 'Nova Tarefa'
      TabOrder = 0
      OnClick = btnAdicionarClick
      ExplicitLeft = 531
      ExplicitTop = 11
    end
    object btnAnterior: TButton
      AlignWithMargins = True
      Left = 3
      Top = 8
      Width = 100
      Height = 30
      Margins.Top = 8
      Align = alLeft
      Caption = '< Anterior'
      TabOrder = 4
      OnClick = btnAnteriorClick
      ExplicitTop = 3
      ExplicitHeight = 35
    end
    object btnProximo: TButton
      AlignWithMargins = True
      Left = 315
      Top = 8
      Width = 100
      Height = 30
      Margins.Top = 8
      Align = alLeft
      Caption = 'Pr'#243'ximo >'
      TabOrder = 5
      OnClick = btnProximoClick
      ExplicitTop = 3
      ExplicitHeight = 35
    end
  end
  object DBGridTarefas: TDBGrid
    AlignWithMargins = True
    Left = 3
    Top = 68
    Width = 968
    Height = 354
    Align = alClient
    DataSource = dsTarefas
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Id'
        Width = 67
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Titulo'
        Width = 386
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Prioridade'
        Width = 142
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Status'
        Width = 141
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DataCriacao'
        Title.Caption = 'Criada Em'
        Width = 179
        Visible = True
      end>
  end
  object mtTarefas: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 400
    Top = 232
    object mtTarefasId: TIntegerField
      FieldName = 'Id'
    end
    object mtTarefasTitulo: TStringField
      FieldName = 'Titulo'
      Size = 150
    end
    object mtTarefasPrioridade: TStringField
      FieldName = 'Prioridade'
      Size = 50
    end
    object mtTarefasStatus: TStringField
      FieldName = 'Status'
      Size = 50
    end
    object mtTarefasDataCriacao: TStringField
      FieldName = 'DataCriacao'
      Size = 50
    end
  end
  object dsTarefas: TDataSource
    DataSet = mtTarefas
    Left = 480
    Top = 232
  end
end
