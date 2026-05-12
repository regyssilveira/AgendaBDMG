object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Agenda Montreal - Gerenciamento de Tarefas'
  ClientHeight = 561
  ClientWidth = 884
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
    Width = 884
    Height = 65
    Align = alTop
    TabOrder = 0
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
    object btnAdicionar: TButton
      Left = 440
      Top = 26
      Width = 97
      Height = 25
      Caption = 'Nova Tarefa'
      TabOrder = 3
      OnClick = btnAdicionarClick
    end
    object btnAtualizar: TButton
      Left = 792
      Top = 26
      Width = 75
      Height = 25
      Caption = 'Atualizar'
      TabOrder = 4
      OnClick = btnAtualizarClick
    end
  end
  object pnlEstatisticas: TPanel
    Left = 0
    Top = 65
    Width = 884
    Height = 41
    Align = alTop
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object lblTotalTarefas: TLabel
      Left = 16
      Top = 13
      Width = 150
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
      Left = 240
      Top = 13
      Width = 180
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
      Left = 480
      Top = 13
      Width = 150
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
  object pnlClient: TPanel
    Left = 0
    Top = 106
    Width = 884
    Height = 414
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 10
    TabOrder = 2
    object DBGridTarefas: TDBGrid
      Left = 10
      Top = 10
      Width = 864
      Height = 353
      Align = alClient
      DataSource = dsTarefas
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -12
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'Id'
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Titulo'
          Width = 350
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Prioridade'
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Status'
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'DataCriacao'
          Title.Caption = 'Criada Em'
          Width = 150
          Visible = True
        end>
    end
    object pnlPaginacao: TPanel
      Left = 10
      Top = 363
      Width = 864
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      object lblPaginaInfo: TLabel
        Left = 112
        Top = 13
        Width = 139
        Height = 15
        Caption = 'P'#225'gina 1 de 1 (Total: 0 itens)'
      end
      object btnAnterior: TButton
        Left = 0
        Top = 8
        Width = 97
        Height = 25
        Caption = '< Anterior'
        TabOrder = 0
        OnClick = btnAnteriorClick
      end
      object btnProximo: TButton
        Left = 272
        Top = 8
        Width = 97
        Height = 25
        Caption = 'Pr'#243'ximo >'
        TabOrder = 1
        OnClick = btnProximoClick
      end
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 520
    Width = 884
    Height = 41
    Align = alBottom
    TabOrder = 3
    object btnEditar: TButton
      Left = 16
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Editar'
      TabOrder = 0
      OnClick = btnEditarClick
    end
    object btnExcluir: TButton
      Left = 97
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Excluir'
      TabOrder = 1
      OnClick = btnExcluirClick
    end
    object btnAlterarStatus: TButton
      Left = 178
      Top = 8
      Width = 103
      Height = 25
      Caption = 'Alterar Status'
      TabOrder = 2
      OnClick = btnAlterarStatusClick
    end
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
