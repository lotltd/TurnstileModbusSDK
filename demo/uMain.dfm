object fmMain: TfmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Demo'
  ClientHeight = 411
  ClientWidth = 415
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 29
    Height = 13
    Caption = #1055#1086#1088#1090':'
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 32
    Width = 193
    Height = 313
    Caption = #1058#1091#1088#1085#1080#1082#1077#1090#1099
    TabOrder = 0
    object lbTurn: TListBox
      Left = 13
      Top = 16
      Width = 169
      Height = 281
      ItemHeight = 13
      PopupMenu = PopupMenu1
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 207
    Top = 32
    Width = 193
    Height = 313
    Caption = #1050#1086#1076#1099
    TabOrder = 1
    object lbCode: TListBox
      Left = 13
      Top = 16
      Width = 169
      Height = 281
      ItemHeight = 13
      PopupMenu = PopupMenu2
      TabOrder = 0
    end
  end
  object btnStart: TBitBtn
    Left = 152
    Top = 359
    Width = 105
    Height = 25
    Caption = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100#1089#1103
    TabOrder = 2
    OnClick = btnStartClick
  end
  object cbPort: TComboBox
    Left = 75
    Top = 8
    Width = 83
    Height = 21
    Style = csDropDownList
    ItemIndex = 3
    TabOrder = 3
    Text = 'COM4'
    Items.Strings = (
      'COM1'
      'COM2'
      'COM3'
      'COM4'
      'COM5'
      'COM6'
      'COM7'
      'COM8'
      'COM9'
      'COM10'
      'COM11'
      'COM12'
      'COM13'
      'COM14'
      'COM15'
      'COM16')
  end
  object PopupMenu1: TPopupMenu
    Left = 48
    Top = 104
    object btnTurnAdd: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnClick = btnTurnAddClick
    end
    object btnTurnDel: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = btnTurnDelClick
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 280
    Top = 80
    object btnCodeAdd: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      OnClick = btnCodeAddClick
    end
    object btnCodeDel: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100
      OnClick = btnCodeDelClick
    end
  end
end
