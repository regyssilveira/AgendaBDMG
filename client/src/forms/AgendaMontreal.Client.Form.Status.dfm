object frmStatus: TfrmStatus
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Alterar Status'
  ClientHeight = 153
  ClientWidth = 359
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object lblTarefaInfo: TLabel
    Left = 16
    Top = 16
    Width = 329
    Height = 15
    AutoSize = False
    Caption = 'Tarefa #1: Titulo'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblNovoStatus: TLabel
    Left = 16
    Top = 56
    Width = 67
    Height = 15
    Caption = 'Novo Status:'
  end
  object cbbStatus: TComboBox
    Left = 89
    Top = 53
    Width = 145
    Height = 23
    Style = csDropDownList
    TabOrder = 0
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 112
    Width = 359
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 111
    ExplicitWidth = 355
    object btnSalvar: TButton
      Left = 184
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Salvar'
      Default = True
      TabOrder = 0
      OnClick = btnSalvarClick
    end
    object btnCancelar: TButton
      Left = 272
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancelar'
      TabOrder = 1
      OnClick = btnCancelarClick
    end
  end
end
