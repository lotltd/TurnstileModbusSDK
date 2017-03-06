object fmMain: TfmMain
  Left = 261
  Top = 191
  Caption = #1069#1084#1091#1083#1103#1090#1086#1088' '#1090#1091#1088#1085#1080#1082#1077#1090#1086#1074' Modbus ver.1.0'
  ClientHeight = 683
  ClientWidth = 932
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 520
    Top = 137
    Height = 546
    Align = alRight
    ExplicitLeft = 251
    ExplicitTop = 47
    ExplicitHeight = 476
  end
  object pnlMenu: TPanel
    Left = 0
    Top = 0
    Width = 932
    Height = 137
    Align = alTop
    TabOrder = 0
    object btnNew: TSpeedButton
      Left = 8
      Top = 10
      Width = 23
      Height = 22
      Hint = #1053#1086#1074#1072#1103' '#1089#1093#1077#1084#1072
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000939393F9939393F9939393F9939393F9939393F9939393F9939393F99393
        93F9939393F9939393F9939393F9939393F90000000000000000000000000000
        0000939393F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFF939393F90000000000000000000000000000
        0000939393F9FFFFFFFFEFEFEFFFEEEEEEFFEDEDEDFFECECECFFEBEBEBFFEAEA
        EAFFE9E9E9FFE8E8E8FFFFFFFFFF939393F90000000000000000000000000000
        0000939393F9FFFFFFFFF1F1F1FFF0F0F0FFEFEFEFFFEEEEEEFFEDEDEDFFECEC
        ECFFEBEBEBFFEAEAEAFFFFFFFFFF939393F90000000000000000000000000000
        0000939393F9FFFFFFFFF2F2F2FFF1F1F1FFF1F1F1FFF0F0F0FFEFEFEFFFEEEE
        EEFFEDEDEDFFECECECFFFFFFFFFF939393F90000000000000000000000000000
        0000939393F9FFFFFFFFF4F4F4FFF3F3F3FFF2F2F2FFF1F1F1FFF1F1F1FFF0F0
        F0FFEFEFEFFFEEEEEEFFFFFFFFFF939393F90000000000000000000000000000
        0000939393F9FFFFFFFFF6F6F6FFF5F5F5FFF4F4F4FFF3F3F3FFF2F2F2FFF1F1
        F1FFF1F1F1FFF0F0F0FFFFFFFFFF939393F90000000000000000000000000000
        0000939393F9FFFFFFFFF8F8F8FFF7F7F7FFF6F6F6FFF5F5F5FFF4F4F4FFF3F3
        F3FFF2F2F2FFF1F1F1FFFFFFFFFF939393F90000000000000000000000000000
        0000939393F9FFFFFFFFFAFAFAFFF9F9F9FFF8F8F8FFF7F7F7FFF6F6F6FFF5F5
        F5FFF4F4F4FFF3F3F3FFF5F5F5FF939393F90000000000000000000000000000
        0000939393F9FFFFFFFFFBFBFBFFFAFAFAFFFAFAFAFFF9F9F9FFF8F8F8FF9393
        93F9939393F9939393F9939393F9939393F90000000000000000000000000000
        0000939393F9FFFFFFFFFDFDFDFFFCFCFCFFFBFBFBFFFAFAFAFFFAFAFAFF9393
        93F9E1E1E1FFE1E1E1FFB5B5B5F9939393F90000000000000000000000000000
        0000939393F9FFFFFFFFFFFFFFFFFEFEFEFFFDFDFDFFFCFCFCFFFBFBFBFF9393
        93F9E1E1E1FFB5B5B5F9939393F9000000000000000000000000000000000000
        0000939393F9FFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFFEFEFEFFFDFDFDFF9393
        93F9B5B5B5F9939393F900000000000000000000000000000000000000000000
        0000939393F9939393F9939393F9939393F9939393F9939393F9939393F99393
        93F9939393F90000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000}
      ParentShowHint = False
      ShowHint = True
      OnClick = btnNewClick
    end
    object btnNewTurn: TSpeedButton
      Left = 37
      Top = 10
      Width = 23
      Height = 22
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1091#1088#1085#1080#1082#1077#1090
      Enabled = False
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000939393F9939393F9939393F9939393F9939393F9939393F9939393F99393
        93F9939393F9939393F9939393F9939393F90000000000000000000000000000
        0000939393F9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFF939393F90000000000000000000000000000
        000007812EFF07812EFF07812EFF07812EFFEDEDEDFFECECECFFEBEBEBFFEAEA
        EAFFE9E9E9FFE8E8E8FFFFFFFFFF939393F90000000000000000000000000000
        000007812EFF66F19BFF99F6BDFF07812EFFEFEFEFFFEEEEEEFFEDEDEDFFECEC
        ECFFEBEBEBFFEAEAEAFFFFFFFFFF939393F9000000000000000007812EFF0781
        2EFF07812EFF38EB7EFF99F6BDFF07812EFF07812EFF07812EFFEFEFEFFFEEEE
        EEFFEDEDEDFFECECECFFFFFFFFFF939393F9000000000000000007812EFF76F1
        A6FF6AF09EFF38EB7EFF53EE8FFF6DF1A0FF99F6BDFF07812EFFF1F1F1FFF0F0
        F0FFEFEFEFFFEEEEEEFFFFFFFFFF939393F9000000000000000007812EFF7AF1
        A9FF6FF0A1FF38EB7EFF58EE93FF77F1A7FF99F6BDFF07812EFFF2F2F2FFF1F1
        F1FFF1F1F1FFF0F0F0FFFFFFFFFF939393F9000000000000000007812EFF0781
        2EFF07812EFF3DEB81FF99F6BDFF07812EFF07812EFF07812EFFF4F4F4FFF3F3
        F3FFF2F2F2FFF1F1F1FFFFFFFFFF939393F90000000000000000000000000000
        000007812EFF99F6BDFF99F6BDFF07812EFFF8F8F8FFF7F7F7FFF6F6F6FFF5F5
        F5FFF4F4F4FFF3F3F3FFF5F5F5FF939393F90000000000000000000000000000
        000007812EFF07812EFF07812EFF07812EFFFAFAFAFFF9F9F9FFF8F8F8FF9393
        93F9939393F9939393F9939393F9939393F90000000000000000000000000000
        0000939393F9FFFFFFFFFDFDFDFFFCFCFCFFFBFBFBFFFAFAFAFFFAFAFAFF9393
        93F9E1E1E1FFE1E1E1FFB5B5B5F9939393F90000000000000000000000000000
        0000939393F9FFFFFFFFFFFFFFFFFEFEFEFFFDFDFDFFFCFCFCFFFBFBFBFF9393
        93F9E1E1E1FFB5B5B5F9939393F9000000000000000000000000000000000000
        0000939393F9FFFFFFFFFFFFFFFFFFFFFFFFFEFEFEFFFEFEFEFFFDFDFDFF9393
        93F9B5B5B5F9939393F900000000000000000000000000000000000000000000
        0000939393F9939393F9939393F9939393F9939393F9939393F9939393F99393
        93F9939393F90000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000}
      ParentShowHint = False
      ShowHint = True
      OnClick = btnNewTurnClick
    end
    object btnGo: TSpeedButton
      Left = 240
      Top = 10
      Width = 68
      Height = 25
      GroupIndex = 1
      Caption = #1057#1090#1072#1088#1090
      Enabled = False
      ParentShowHint = False
      ShowHint = True
      OnClick = btnGoClick
    end
    object cbLog: TCheckBox
      Left = 323
      Top = 15
      Width = 97
      Height = 17
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1083#1086#1075
      TabOrder = 0
    end
    object rgConnect: TRadioGroup
      Left = 120
      Top = 3
      Width = 114
      Height = 37
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'COM'
        'TCP')
      TabOrder = 1
    end
    object gbTCP: TGroupBox
      Left = 176
      Top = 46
      Width = 153
      Height = 81
      Caption = 'TCP'
      Enabled = False
      TabOrder = 2
      object Label29: TLabel
        Left = 8
        Top = 21
        Width = 25
        Height = 13
        Caption = 'Host:'
      end
      object Label30: TLabel
        Left = 10
        Top = 48
        Width = 22
        Height = 13
        Caption = 'Port:'
      end
      object edHost: TMaskEdit
        Left = 40
        Top = 21
        Width = 106
        Height = 21
        EditMask = '!099.099.099.099;1; '
        MaxLength = 15
        TabOrder = 0
        Text = '127.0  .0  .1  '
      end
      object edTCPPort: TEdit
        Left = 40
        Top = 48
        Width = 92
        Height = 21
        TabOrder = 1
        Text = '502'
      end
      object UpDown17: TUpDown
        Left = 132
        Top = 48
        Width = 16
        Height = 21
        Associate = edTCPPort
        Max = 65535
        Position = 502
        TabOrder = 2
      end
    end
    object gbCom: TGroupBox
      Left = 8
      Top = 46
      Width = 162
      Height = 81
      Caption = 'COM'
      TabOrder = 3
      object Label2: TLabel
        Left = 8
        Top = 21
        Width = 28
        Height = 13
        Caption = #1055#1086#1088#1090':'
      end
      object Label3: TLabel
        Left = 8
        Top = 48
        Width = 51
        Height = 13
        Caption = #1057#1082#1086#1088#1086#1089#1090#1100':'
      end
      object cbPort: TComboBox
        Left = 67
        Top = 21
        Width = 83
        Height = 21
        Style = csDropDownList
        ItemIndex = 9
        TabOrder = 0
        Text = 'COM10'
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
      object cbSpeed: TComboBox
        Left = 67
        Top = 48
        Width = 83
        Height = 21
        Style = csDropDownList
        ItemIndex = 10
        TabOrder = 1
        Text = '115200'
        Items.Strings = (
          '1200'
          '1800'
          '2400'
          '4800'
          '7200'
          '9600'
          '14400'
          '19200'
          '38400'
          '57600'
          '115200')
      end
    end
  end
  object ScrollBox1: TScrollBox
    Left = 0
    Top = 137
    Width = 520
    Height = 546
    Align = alClient
    TabOrder = 1
    object FlowPanel1: TFlowPanel
      Left = 0
      Top = 0
      Width = 516
      Height = 542
      Align = alClient
      ShowCaption = False
      TabOrder = 0
    end
  end
  object Panel1: TPanel
    Left = 523
    Top = 137
    Width = 409
    Height = 546
    Align = alRight
    Caption = 'Panel1'
    TabOrder = 2
    object Splitter2: TSplitter
      Left = 1
      Top = 337
      Width = 407
      Height = 3
      Cursor = crVSplit
      Align = alTop
      ExplicitTop = 241
      ExplicitWidth = 234
    end
    object mLog: TMemo
      Left = 1
      Top = 1
      Width = 407
      Height = 336
      Align = alTop
      PopupMenu = PopupMenu1
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object GroupBox1: TGroupBox
      Left = 1
      Top = 340
      Width = 407
      Height = 205
      Align = alClient
      Caption = #1069#1084#1091#1083#1103#1094#1080#1103' '#1087#1088#1086#1093#1086#1076#1086#1074
      TabOrder = 1
      DesignSize = (
        407
        205)
      object lbCode: TListBox
        Left = 2
        Top = 49
        Width = 164
        Height = 154
        Anchors = [akLeft, akTop, akBottom]
        ItemHeight = 13
        PopupMenu = PopupMenu2
        TabOrder = 0
      end
      object btnGenerator: TBitBtn
        Left = 5
        Top = 18
        Width = 75
        Height = 25
        Caption = #1057#1090#1072#1088#1090
        Enabled = False
        TabOrder = 1
        OnClick = btnGeneratorClick
      end
      object meGeneratorLog: TMemo
        Left = 167
        Top = 49
        Width = 237
        Height = 154
        Anchors = [akLeft, akTop, akRight, akBottom]
        ScrollBars = ssVertical
        TabOrder = 2
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 704
    Top = 216
    object btnLogClear: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1083#1086#1075
      OnClick = btnLogClearClick
    end
  end
  object PopupMenu2: TPopupMenu
    Left = 520
    Top = 528
    object btnAddCode: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1082#1086#1076
      OnClick = btnAddCodeClick
    end
    object btnDelCode: TMenuItem
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1082#1086#1076
      OnClick = btnDelCodeClick
    end
  end
  object Timer1: TTimer
    Interval = 1500
    OnTimer = Timer1Timer
    Left = 688
    Top = 504
  end
end
