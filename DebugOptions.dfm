object fmDebugOptions: TfmDebugOptions
  Left = 357
  Top = 224
  BorderStyle = bsDialog
  Caption = 'Baz Debug Window Options'
  ClientHeight = 177
  ClientWidth = 312
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    312
    177)
  TextHeight = 13
  object gbxView: TGroupBox
    Left = 8
    Top = 8
    Width = 294
    Height = 65
    Anchors = [akLeft, akTop, akRight]
    Caption = 'View Options'
    TabOrder = 0
    DesignSize = (
      294
      65)
    object chkShowOnStartup: TCheckBox
      Left = 8
      Top = 21
      Width = 274
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Show on startup'
      TabOrder = 0
    end
    object chkShowOnMessage: TCheckBox
      Left = 8
      Top = 40
      Width = 274
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Show on message received'
      TabOrder = 1
    end
  end
  object gbxMessages: TGroupBox
    Left = 8
    Top = 80
    Width = 294
    Height = 49
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Message Options'
    TabOrder = 1
    DesignSize = (
      294
      49)
    object chkNewAtBottom: TCheckBox
      Left = 8
      Top = 23
      Width = 274
      Height = 17
      Anchors = [akLeft, akTop, akRight]
      Caption = 'New messages added to the bottom'
      TabOrder = 0
    end
  end
  object btnOK: TButton
    Left = 140
    Top = 140
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 228
    Top = 140
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end
