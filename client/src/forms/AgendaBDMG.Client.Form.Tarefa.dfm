object frmTarefa: TfrmTarefa
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Tarefa'
  ClientHeight = 311
  ClientWidth = 434
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnShow = FormShow
  TextHeight = 15
  object lblTitulo: TLabel
    Left = 16
    Top = 16
    Width = 33
    Height = 15
    Caption = 'T'#237'tulo'
  end
  object lblDescricao: TLabel
    Left = 16
    Top = 64
    Width = 51
    Height = 15
    Caption = 'Descri'#231#227'o'
  end
  object lblPrioridade: TLabel
    Left = 16
    Top = 224
    Width = 54
    Height = 15
    Caption = 'Prioridade'
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 270
    Width = 434
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 3
    ExplicitTop = 269
    ExplicitWidth = 430
    object btnSalvar: TButton
      Left = 256
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Salvar'
      Default = True
      TabOrder = 0
      OnClick = btnSalvarClick
    end
    object btnCancelar: TButton
      Left = 344
      Top = 8
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancelar'
      TabOrder = 1
      OnClick = btnCancelarClick
    end
  end
  object edtTitulo: TEdit
    Left = 16
    Top = 32
    Width = 393
    Height = 23
    MaxLength = 150
    TabOrder = 0
  end
  object memDescricao: TMemo
    Left = 16
    Top = 80
    Width = 393
    Height = 129
    MaxLength = 1000
    TabOrder = 1
  end
  object cbbPrioridade: TComboBox
    Left = 16
    Top = 240
    Width = 145
    Height = 23
    Style = csDropDownList
    TabOrder = 2
    Items.Strings = (
      '1 - Muito Baixa'
      '2 - Baixa'
      '3 - Normal'
      '4 - Alta'
      '5 - Cr'#237'tica')
  end
end
