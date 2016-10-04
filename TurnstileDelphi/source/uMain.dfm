object fmMain: TfmMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Modbus demo'
  ClientHeight = 765
  ClientWidth = 1143
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox7: TGroupBox
    Left = 8
    Top = 8
    Width = 1129
    Height = 145
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
    TabOrder = 0
    object GroupBox4: TGroupBox
      Left = 8
      Top = 14
      Width = 306
      Height = 44
      Caption = #1040#1076#1088#1077#1089':'
      TabOrder = 0
      object edAddr: TEdit
        Left = 11
        Top = 18
        Width = 78
        Height = 21
        TabOrder = 0
        Text = '1'
      end
      object UpDown1: TUpDown
        Left = 89
        Top = 18
        Width = 16
        Height = 21
        Associate = edAddr
        Min = 1
        Position = 1
        TabOrder = 1
      end
    end
    object gbCom: TGroupBox
      Left = 320
      Top = 59
      Width = 302
      Height = 81
      Caption = 'COM'
      TabOrder = 1
      object Label1: TLabel
        Left = 8
        Top = 21
        Width = 29
        Height = 13
        Caption = #1055#1086#1088#1090':'
      end
      object Label2: TLabel
        Left = 8
        Top = 48
        Width = 52
        Height = 13
        Caption = #1057#1082#1086#1088#1086#1089#1090#1100':'
      end
      object cbPort: TComboBox
        Left = 67
        Top = 21
        Width = 83
        Height = 21
        Style = csDropDownList
        ItemIndex = 3
        TabOrder = 0
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
      object btnSetSpeed: TBitBtn
        Left = 160
        Top = 45
        Width = 125
        Height = 25
        Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1082#1086#1088#1086#1089#1090#1100
        TabOrder = 2
        OnClick = btnSetSpeedClick
      end
    end
    object GroupBox15: TGroupBox
      Left = 8
      Top = 59
      Width = 306
      Height = 81
      Caption = #1057#1082#1086#1088#1086#1089#1090#1100' '#1086#1073#1084#1077#1085#1072' '#1089#1086' '#1089#1082#1072#1085#1077#1088#1086#1084
      TabOrder = 2
      object Label25: TLabel
        Left = 8
        Top = 19
        Width = 52
        Height = 13
        Caption = #1057#1082#1086#1088#1086#1089#1090#1100':'
      end
      object cbScannerSpeed: TComboBox
        Left = 67
        Top = 19
        Width = 83
        Height = 21
        Style = csDropDownList
        ItemIndex = 2
        TabOrder = 0
        Text = '9600'
        Items.Strings = (
          '2400'
          '4800'
          '9600')
      end
      object btnSepScannerSpeed: TBitBtn
        Left = 178
        Top = 19
        Width = 125
        Height = 25
        Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1082#1086#1088#1086#1089#1090#1100
        TabOrder = 1
        OnClick = btnSepScannerSpeedClick
      end
    end
    object gbTCP: TGroupBox
      Left = 628
      Top = 59
      Width = 168
      Height = 81
      Caption = 'TCP'
      Enabled = False
      TabOrder = 3
      object Label29: TLabel
        Left = 8
        Top = 19
        Width = 26
        Height = 13
        Caption = 'Host:'
      end
      object Label30: TLabel
        Left = 10
        Top = 48
        Width = 24
        Height = 13
        Caption = 'Port:'
      end
      object edHost: TMaskEdit
        Left = 40
        Top = 16
        Width = 106
        Height = 21
        EditMask = '!099.099.099.099;1; '
        MaxLength = 15
        TabOrder = 0
        Text = '18 .0  .0  .254'
      end
      object edTCPPort: TEdit
        Left = 40
        Top = 43
        Width = 92
        Height = 21
        TabOrder = 1
        Text = '502'
      end
      object UpDown17: TUpDown
        Left = 132
        Top = 43
        Width = 16
        Height = 21
        Associate = edTCPPort
        Max = 65535
        Position = 502
        TabOrder = 2
      end
    end
    object rgConnect: TRadioGroup
      Left = 320
      Top = 20
      Width = 114
      Height = 38
      Columns = 2
      ItemIndex = 0
      Items.Strings = (
        'COM'
        'TCP')
      TabOrder = 4
      OnClick = rgConnectClick
    end
    object btnStart: TBitBtn
      Left = 628
      Top = 28
      Width = 125
      Height = 25
      Caption = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100#1089#1103
      TabOrder = 5
      OnClick = btnStartClick
    end
    object GroupBox16: TGroupBox
      Left = 872
      Top = 14
      Width = 254
      Height = 126
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103
      TabOrder = 6
      object Label26: TLabel
        Left = 16
        Top = 24
        Width = 53
        Height = 13
        Caption = #1050#1086#1084#1087#1072#1085#1080#1103':'
      end
      object Label27: TLabel
        Left = 16
        Top = 48
        Width = 52
        Height = 13
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077':'
      end
      object Label28: TLabel
        Left = 16
        Top = 75
        Width = 39
        Height = 13
        Caption = #1042#1077#1088#1089#1080#1103':'
      end
      object edCompany: TEdit
        Left = 80
        Top = 21
        Width = 161
        Height = 21
        ReadOnly = True
        TabOrder = 0
      end
      object edProduct: TEdit
        Left = 80
        Top = 48
        Width = 161
        Height = 21
        ReadOnly = True
        TabOrder = 1
      end
      object edVer: TEdit
        Left = 80
        Top = 75
        Width = 161
        Height = 21
        ReadOnly = True
        TabOrder = 2
      end
    end
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 159
    Width = 1129
    Height = 594
    ActivePage = TabSheet1
    TabOrder = 1
    OnChanging = PageControl1Changing
    object TabSheet1: TTabSheet
      Caption = #1058#1091#1088#1085#1080#1082#1077#1090
      object GroupBox2: TGroupBox
        Left = 3
        Top = 3
        Width = 1113
        Height = 298
        Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1080#1077
        TabOrder = 0
        object Label12: TLabel
          Left = 770
          Top = 216
          Width = 225
          Height = 13
          Caption = #1042#1088#1077#1084#1103' '#1076#1083#1103' '#1087#1088#1086#1093#1086#1076#1072' '#1087#1086#1089#1083#1077' '#1088#1072#1079#1088#1077#1096#1077#1085#1080#1103',  '#1089#1077#1082':'
        end
        object Label13: TLabel
          Left = 770
          Top = 240
          Width = 187
          Height = 13
          Caption = #1042#1088#1077#1084#1103' '#1085#1072' '#1087#1088#1086#1093#1086#1076' '#1087#1086#1089#1083#1077' '#1085#1072#1095#1072#1083#1072',  '#1089#1077#1082':'
        end
        object btnAfterPermissionPassTime: TSpeedButton
          Left = 1078
          Top = 216
          Width = 23
          Height = 22
          Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
          ParentShowHint = False
          ShowHint = True
          OnClick = btnAfterPermissionPassTimeClick
        end
        object btnAfterStartPassTime: TSpeedButton
          Left = 1078
          Top = 240
          Width = 23
          Height = 22
          Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
          ParentShowHint = False
          ShowHint = True
          OnClick = btnAfterStartPassTimeClick
        end
        object Label16: TLabel
          Left = 770
          Top = 267
          Width = 168
          Height = 13
          Caption = #1058#1072#1081#1084#1072#1091#1090' '#1088#1072#1073#1086#1090#1099' '#1076#1074#1080#1075#1072#1090#1077#1083#1103', '#1089#1077#1082':'
        end
        object btnEngineTime: TSpeedButton
          Left = 1078
          Top = 267
          Width = 23
          Height = 22
          Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
          ParentShowHint = False
          ShowHint = True
          OnClick = btnEngineTimeClick
        end
        object edAfterPermissionPassTime: TEdit
          Left = 1001
          Top = 216
          Width = 56
          Height = 21
          NumbersOnly = True
          TabOrder = 2
          Text = '1'
        end
        object UpDown2: TUpDown
          Left = 1057
          Top = 216
          Width = 16
          Height = 21
          Associate = edAfterPermissionPassTime
          Min = 1
          Max = 255
          Position = 1
          TabOrder = 3
        end
        object edAfterStartPassTime: TEdit
          Left = 1001
          Top = 240
          Width = 56
          Height = 21
          NumbersOnly = True
          TabOrder = 4
          Text = '1'
        end
        object UpDown3: TUpDown
          Left = 1057
          Top = 240
          Width = 16
          Height = 21
          Associate = edAfterStartPassTime
          Min = 1
          Max = 255
          Position = 1
          TabOrder = 5
        end
        object edEngineTime: TEdit
          Left = 1001
          Top = 267
          Width = 56
          Height = 21
          NumbersOnly = True
          TabOrder = 6
          Text = '1'
        end
        object UpDown6: TUpDown
          Left = 1057
          Top = 267
          Width = 16
          Height = 21
          Associate = edEngineTime
          Min = 1
          Max = 255
          Position = 1
          TabOrder = 7
        end
        object GroupBox6: TGroupBox
          Left = 8
          Top = 18
          Width = 375
          Height = 271
          Caption = #1042#1093#1086#1076
          TabOrder = 0
          object rgEnter: TRadioGroup
            Left = 8
            Top = 15
            Width = 247
            Height = 31
            Columns = 2
            ItemIndex = 0
            Items.Strings = (
              #1055#1088#1086#1093#1086#1076' '#1079#1072#1082#1088#1099#1090
              #1057#1074#1086#1073#1086#1076#1085#1099#1081' '#1087#1088#1086#1093#1086#1076)
            TabOrder = 0
            OnClick = rgEnterClick
          end
          object GroupBox11: TGroupBox
            Left = 8
            Top = 51
            Width = 358
            Height = 105
            Caption = #1047#1077#1083#1077#1085#1099#1081
            TabOrder = 2
            object Label3: TLabel
              Left = 8
              Top = 78
              Width = 223
              Height = 13
              Caption = #1054#1073#1097#1072#1103' '#1076#1083#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1080#1085#1076#1080#1082#1072#1094#1080#1080', '#1074' 100 '#1084#1089' :'
            end
            object Label4: TLabel
              Left = 8
              Top = 51
              Width = 239
              Height = 13
              Caption = #1044#1083#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1074#1099#1082#1083#1102#1095#1077#1085#1080#1103' '#1089#1080#1075#1085#1072#1083#1072', '#1074' 100 '#1084#1089' :'
            end
            object Label7: TLabel
              Left = 8
              Top = 24
              Width = 231
              Height = 13
              Caption = #1044#1083#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1074#1082#1083#1102#1095#1077#1085#1080#1103' '#1089#1080#1075#1085#1072#1083#1072', '#1074' 100 '#1084#1089' :'
            end
            object btnEnterGreen: TSpeedButton
              Left = 331
              Top = 77
              Width = 23
              Height = 22
              Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
              ParentShowHint = False
              ShowHint = True
              OnClick = btnEnterGreenClick
            end
            object edEnterGreen_t: TEdit
              Left = 253
              Top = 24
              Width = 56
              Height = 21
              NumbersOnly = True
              TabOrder = 0
              Text = '1'
            end
            object UpDown4: TUpDown
              Left = 309
              Top = 78
              Width = 16
              Height = 21
              Associate = edEnterGreen_time
              Min = 1
              Max = 255
              Position = 1
              TabOrder = 5
            end
            object edEnterGreen_t2: TEdit
              Left = 253
              Top = 51
              Width = 56
              Height = 21
              NumbersOnly = True
              TabOrder = 2
              Text = '1'
            end
            object UpDown5: TUpDown
              Left = 309
              Top = 51
              Width = 16
              Height = 21
              Associate = edEnterGreen_t2
              Min = 1
              Max = 255
              Position = 1
              TabOrder = 3
            end
            object edEnterGreen_time: TEdit
              Left = 253
              Top = 78
              Width = 56
              Height = 21
              NumbersOnly = True
              TabOrder = 4
              Text = '1'
            end
            object UpDown7: TUpDown
              Left = 309
              Top = 24
              Width = 16
              Height = 21
              Associate = edEnterGreen_t
              Min = 1
              Max = 255
              Position = 1
              TabOrder = 1
            end
          end
          object GroupBox12: TGroupBox
            Left = 8
            Top = 156
            Width = 358
            Height = 105
            Caption = #1050#1088#1072#1089#1085#1099#1081
            TabOrder = 3
            object Label8: TLabel
              Left = 8
              Top = 78
              Width = 223
              Height = 13
              Caption = #1054#1073#1097#1072#1103' '#1076#1083#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1080#1085#1076#1080#1082#1072#1094#1080#1080', '#1074' 100 '#1084#1089' :'
            end
            object Label14: TLabel
              Left = 8
              Top = 51
              Width = 239
              Height = 13
              Caption = #1044#1083#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1074#1099#1082#1083#1102#1095#1077#1085#1080#1103' '#1089#1080#1075#1085#1072#1083#1072', '#1074' 100 '#1084#1089' :'
            end
            object Label15: TLabel
              Left = 8
              Top = 24
              Width = 231
              Height = 13
              Caption = #1044#1083#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1074#1082#1083#1102#1095#1077#1085#1080#1103' '#1089#1080#1075#1085#1072#1083#1072', '#1074' 100 '#1084#1089' :'
            end
            object btnEnterRed: TSpeedButton
              Left = 331
              Top = 78
              Width = 23
              Height = 22
              Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
              ParentShowHint = False
              ShowHint = True
              OnClick = btnEnterRedClick
            end
            object edEnterRed_t: TEdit
              Left = 253
              Top = 24
              Width = 56
              Height = 21
              NumbersOnly = True
              TabOrder = 0
              Text = '1'
            end
            object UpDown8: TUpDown
              Left = 309
              Top = 78
              Width = 16
              Height = 21
              Associate = edEnterRed_time
              Min = 1
              Max = 255
              Position = 1
              TabOrder = 5
            end
            object edEnterRed_t2: TEdit
              Left = 253
              Top = 51
              Width = 56
              Height = 21
              NumbersOnly = True
              TabOrder = 2
              Text = '1'
            end
            object UpDown9: TUpDown
              Left = 309
              Top = 51
              Width = 16
              Height = 21
              Associate = edEnterRed_t2
              Min = 1
              Max = 255
              Position = 1
              TabOrder = 3
            end
            object edEnterRed_time: TEdit
              Left = 253
              Top = 78
              Width = 56
              Height = 21
              NumbersOnly = True
              TabOrder = 4
              Text = '1'
            end
            object UpDown10: TUpDown
              Left = 309
              Top = 24
              Width = 16
              Height = 21
              Associate = edEnterRed_t
              Min = 1
              Max = 255
              Position = 1
              TabOrder = 1
            end
          end
          object btnEnterPass: TBitBtn
            Left = 261
            Top = 20
            Width = 102
            Height = 25
            Caption = #1054#1076#1080#1085#1086#1095#1085#1099#1081
            TabOrder = 1
            OnClick = btnEnterPassClick
          end
        end
        object GroupBox8: TGroupBox
          Left = 389
          Top = 18
          Width = 375
          Height = 271
          Caption = #1042#1099#1093#1086#1076
          TabOrder = 1
          object rgExit: TRadioGroup
            Left = 8
            Top = 15
            Width = 247
            Height = 31
            Columns = 2
            ItemIndex = 0
            Items.Strings = (
              #1055#1088#1086#1093#1086#1076' '#1079#1072#1082#1088#1099#1090
              #1057#1074#1086#1073#1086#1076#1085#1099#1081' '#1087#1088#1086#1093#1086#1076)
            TabOrder = 0
            OnClick = rgExitClick
          end
          object GroupBox13: TGroupBox
            Left = 8
            Top = 51
            Width = 358
            Height = 105
            Caption = #1047#1077#1083#1077#1085#1099#1081
            TabOrder = 2
            object Label17: TLabel
              Left = 8
              Top = 78
              Width = 223
              Height = 13
              Caption = #1054#1073#1097#1072#1103' '#1076#1083#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1080#1085#1076#1080#1082#1072#1094#1080#1080', '#1074' 100 '#1084#1089' :'
            end
            object Label18: TLabel
              Left = 8
              Top = 51
              Width = 239
              Height = 13
              Caption = #1044#1083#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1074#1099#1082#1083#1102#1095#1077#1085#1080#1103' '#1089#1080#1075#1085#1072#1083#1072', '#1074' 100 '#1084#1089' :'
            end
            object Label19: TLabel
              Left = 8
              Top = 24
              Width = 231
              Height = 13
              Caption = #1044#1083#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1074#1082#1083#1102#1095#1077#1085#1080#1103' '#1089#1080#1075#1085#1072#1083#1072', '#1074' 100 '#1084#1089' :'
            end
            object btnExitGreen: TSpeedButton
              Left = 331
              Top = 77
              Width = 23
              Height = 22
              Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
              ParentShowHint = False
              ShowHint = True
              OnClick = btnExitGreenClick
            end
            object edExitGreen_t: TEdit
              Left = 253
              Top = 24
              Width = 56
              Height = 21
              NumbersOnly = True
              TabOrder = 0
              Text = '1'
            end
            object UpDown11: TUpDown
              Left = 309
              Top = 78
              Width = 16
              Height = 21
              Associate = edExitGreen_time
              Min = 1
              Max = 255
              Position = 1
              TabOrder = 5
            end
            object edExitGreen_t2: TEdit
              Left = 253
              Top = 51
              Width = 56
              Height = 21
              NumbersOnly = True
              TabOrder = 2
              Text = '1'
            end
            object UpDown12: TUpDown
              Left = 309
              Top = 51
              Width = 16
              Height = 21
              Associate = edExitGreen_t2
              Min = 1
              Max = 255
              Position = 1
              TabOrder = 3
            end
            object edExitGreen_time: TEdit
              Left = 253
              Top = 78
              Width = 56
              Height = 21
              NumbersOnly = True
              TabOrder = 4
              Text = '1'
            end
            object UpDown13: TUpDown
              Left = 309
              Top = 24
              Width = 16
              Height = 21
              Associate = edExitGreen_t
              Min = 1
              Max = 255
              Position = 1
              TabOrder = 1
            end
          end
          object GroupBox14: TGroupBox
            Left = 8
            Top = 156
            Width = 358
            Height = 105
            Caption = #1050#1088#1072#1089#1085#1099#1081
            TabOrder = 3
            object Label20: TLabel
              Left = 8
              Top = 78
              Width = 223
              Height = 13
              Caption = #1054#1073#1097#1072#1103' '#1076#1083#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1080#1085#1076#1080#1082#1072#1094#1080#1080', '#1074' 100 '#1084#1089' :'
            end
            object Label21: TLabel
              Left = 8
              Top = 51
              Width = 239
              Height = 13
              Caption = #1044#1083#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1074#1099#1082#1083#1102#1095#1077#1085#1080#1103' '#1089#1080#1075#1085#1072#1083#1072', '#1074' 100 '#1084#1089' :'
            end
            object Label22: TLabel
              Left = 8
              Top = 24
              Width = 231
              Height = 13
              Caption = #1044#1083#1080#1090#1077#1083#1100#1085#1086#1089#1090#1100' '#1074#1082#1083#1102#1095#1077#1085#1080#1103' '#1089#1080#1075#1085#1072#1083#1072', '#1074' 100 '#1084#1089' :'
            end
            object btnExitRed: TSpeedButton
              Left = 331
              Top = 78
              Width = 23
              Height = 22
              Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
              ParentShowHint = False
              ShowHint = True
              OnClick = btnExitRedClick
            end
            object edExitRed_t: TEdit
              Left = 253
              Top = 24
              Width = 56
              Height = 21
              NumbersOnly = True
              TabOrder = 0
              Text = '1'
            end
            object UpDown14: TUpDown
              Left = 309
              Top = 78
              Width = 16
              Height = 21
              Associate = edExitRed_time
              Min = 1
              Max = 255
              Position = 1
              TabOrder = 5
            end
            object edExitRed_t2: TEdit
              Left = 253
              Top = 51
              Width = 56
              Height = 21
              NumbersOnly = True
              TabOrder = 2
              Text = '1'
            end
            object UpDown15: TUpDown
              Left = 309
              Top = 51
              Width = 16
              Height = 21
              Associate = edExitRed_t2
              Min = 1
              Max = 255
              Position = 1
              TabOrder = 3
            end
            object edExitRed_time: TEdit
              Left = 253
              Top = 78
              Width = 56
              Height = 21
              NumbersOnly = True
              TabOrder = 4
              Text = '1'
            end
            object UpDown16: TUpDown
              Left = 309
              Top = 24
              Width = 16
              Height = 21
              Associate = edExitRed_t
              Min = 1
              Max = 255
              Position = 1
              TabOrder = 1
            end
          end
          object btnExitPass: TBitBtn
            Left = 261
            Top = 20
            Width = 102
            Height = 25
            Caption = #1054#1076#1080#1085#1086#1095#1085#1099#1081
            TabOrder = 1
            OnClick = btnExitPassClick
          end
        end
        object rgPassState: TRadioGroup
          Left = 770
          Top = 18
          Width = 217
          Height = 89
          Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1087#1088#1086#1093#1086#1076#1072
          ItemIndex = 0
          Items.Strings = (
            #1053#1086#1088#1084#1072#1083#1100#1085#1099#1081' '#1088#1077#1078#1080#1084
            #1041#1083#1086#1082#1080#1088#1086#1074#1082#1072
            #1040#1085#1090#1080#1087#1072#1085#1080#1082#1072)
          TabOrder = 8
          OnClick = rgPassStateClick
        end
        object cbDemo: TCheckBox
          Left = 1001
          Top = 18
          Width = 97
          Height = 17
          Caption = 'Demo '#1088#1077#1078#1080#1084
          TabOrder = 9
          OnClick = cbDemoClick
        end
        object btnGetTimers: TButton
          Left = 770
          Top = 176
          Width = 103
          Height = 25
          Caption = #1054#1087#1088#1077#1076#1077#1083#1080#1090#1100
          TabOrder = 10
          OnClick = btnGetTimersClick
        end
      end
      object GroupBox3: TGroupBox
        Left = 3
        Top = 307
        Width = 1113
        Height = 258
        Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086' '#1089#1086#1089#1090#1086#1103#1085#1080#1080
        TabOrder = 1
        object Label5: TLabel
          Left = 8
          Top = 21
          Width = 134
          Height = 13
          Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1093#1086#1076#1086#1074' '#1085#1072' '#1074#1093#1086#1076':'
        end
        object Label6: TLabel
          Left = 8
          Top = 48
          Width = 142
          Height = 13
          Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1093#1086#1076#1086#1074' '#1085#1072' '#1074#1099#1093#1086#1076':'
        end
        object Label10: TLabel
          Left = 330
          Top = 79
          Width = 50
          Height = 13
          Caption = #1042#1093#1086#1076' hex:'
        end
        object Label11: TLabel
          Left = 331
          Top = 133
          Width = 58
          Height = 13
          Caption = #1042#1099#1093#1086#1076' hex:'
        end
        object Label23: TLabel
          Left = 330
          Top = 106
          Width = 60
          Height = 13
          Caption = #1042#1093#1086#1076' ASCII:'
        end
        object Label24: TLabel
          Left = 330
          Top = 160
          Width = 68
          Height = 13
          Caption = #1042#1099#1093#1086#1076' ASCII:'
        end
        object edEnterCount: TEdit
          Left = 156
          Top = 21
          Width = 121
          Height = 21
          ReadOnly = True
          TabOrder = 0
          Text = '0'
        end
        object edExitCount: TEdit
          Left = 156
          Top = 48
          Width = 121
          Height = 21
          ReadOnly = True
          TabOrder = 1
          Text = '0'
        end
        object GroupBox5: TGroupBox
          Left = 331
          Top = 19
          Width = 170
          Height = 54
          TabOrder = 2
          object Label9: TLabel
            Left = 11
            Top = 9
            Width = 122
            Height = 13
            Caption = #1044#1074#1080#1075#1072#1090#1077#1083#1100' '#1073#1083#1086#1082#1080#1088#1086#1074#1072#1085':'
          end
          object cbEngineBlockState: TCheckBox
            Left = 145
            Top = 9
            Width = 19
            Height = 17
            TabOrder = 0
          end
        end
        object edCard: TEdit
          Left = 428
          Top = 79
          Width = 674
          Height = 21
          ReadOnly = True
          TabOrder = 3
        end
        object edCard2: TEdit
          Left = 428
          Top = 133
          Width = 674
          Height = 21
          ReadOnly = True
          TabOrder = 4
        end
        object GroupBox9: TGroupBox
          Left = 167
          Top = 74
          Width = 153
          Height = 175
          Caption = #1042#1099#1093#1086#1076
          Enabled = False
          TabOrder = 5
          object rgExitState: TRadioGroup
            Left = 8
            Top = 15
            Width = 137
            Height = 74
            ItemIndex = 0
            Items.Strings = (
              #1055#1088#1086#1093#1086#1076' '#1079#1072#1082#1088#1099#1090
              #1054#1076#1080#1085#1086#1095#1085#1099#1081' '#1087#1088#1086#1093#1086#1076
              #1057#1074#1086#1073#1086#1076#1085#1099#1081' '#1087#1088#1086#1093#1086#1076)
            TabOrder = 0
          end
          object rgExitPassState: TRadioGroup
            Left = 8
            Top = 95
            Width = 137
            Height = 73
            Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1087#1088#1086#1093#1086#1076#1072
            ItemIndex = 0
            Items.Strings = (
              #1055#1088#1086#1093#1086#1076' '#1089#1074#1086#1073#1086#1076#1077#1085
              #1055#1088#1086#1093#1086#1076' '#1085#1072#1095#1072#1090)
            TabOrder = 1
          end
        end
        object GroupBox10: TGroupBox
          Left = 8
          Top = 74
          Width = 153
          Height = 175
          Caption = #1042#1093#1086#1076
          Enabled = False
          TabOrder = 6
          object rgEnterState: TRadioGroup
            Left = 8
            Top = 15
            Width = 137
            Height = 74
            ItemIndex = 0
            Items.Strings = (
              #1055#1088#1086#1093#1086#1076' '#1079#1072#1082#1088#1099#1090
              #1054#1076#1080#1085#1086#1095#1085#1099#1081' '#1087#1088#1086#1093#1086#1076
              #1057#1074#1086#1073#1086#1076#1085#1099#1081' '#1087#1088#1086#1093#1086#1076)
            TabOrder = 0
          end
          object rgEnterPassState: TRadioGroup
            Left = 8
            Top = 95
            Width = 134
            Height = 73
            Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1087#1088#1086#1093#1086#1076#1072
            ItemIndex = 0
            Items.Strings = (
              #1055#1088#1086#1093#1086#1076' '#1089#1074#1086#1073#1086#1076#1077#1085
              #1055#1088#1086#1093#1086#1076' '#1085#1072#1095#1072#1090)
            TabOrder = 1
          end
        end
        object edCardASCII: TEdit
          Left = 428
          Top = 106
          Width = 674
          Height = 21
          ReadOnly = True
          TabOrder = 7
        end
        object edCard2ASCII: TEdit
          Left = 428
          Top = 160
          Width = 674
          Height = 21
          ReadOnly = True
          TabOrder = 8
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1048#1085#1076#1080#1082#1072#1090#1086#1088
      ImageIndex = 1
      object Label31: TLabel
        Left = 8
        Top = 8
        Width = 62
        Height = 13
        Caption = #1057#1086#1086#1073#1097#1077#1085#1080#1077':'
      end
      object btnSetMessage: TSpeedButton
        Left = 284
        Top = 5
        Width = 23
        Height = 22
        Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
        ParentShowHint = False
        ShowHint = True
        OnClick = btnSetMessageClick
      end
      object Label32: TLabel
        Left = 8
        Top = 32
        Width = 47
        Height = 13
        Caption = #1052#1080#1075#1072#1085#1080#1077':'
      end
      object btnBlink: TSpeedButton
        Left = 284
        Top = 32
        Width = 23
        Height = 22
        Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
        ParentShowHint = False
        ShowHint = True
        OnClick = btnBlinkClick
      end
      object Label33: TLabel
        Left = 8
        Top = 207
        Width = 35
        Height = 13
        Caption = #1040#1076#1088#1077#1089':'
      end
      object btnSetAddress: TSpeedButton
        Left = 176
        Top = 207
        Width = 23
        Height = 22
        Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
        ParentShowHint = False
        ShowHint = True
        OnClick = btnSetAddressClick
      end
      object edMessage: TEdit
        Left = 76
        Top = 5
        Width = 205
        Height = 21
        TabOrder = 0
      end
      object clbBlink: TCheckListBox
        Left = 76
        Top = 32
        Width = 205
        Height = 169
        Columns = 3
        ItemHeight = 13
        Items.Strings = (
          '1'
          '2'
          '3'
          '4'
          '5'
          '6'
          '7'
          '8'
          '9'
          '10'
          '11'
          '12'
          '13'
          '14'
          '15'
          '16'
          '17'
          '18'
          '19'
          '20'
          '21'
          '22'
          '23'
          '24'
          '25'
          '26'
          '27'
          '28'
          '29'
          '30'
          '31'
          '32')
        TabOrder = 1
      end
      object edSetAddr: TEdit
        Left = 76
        Top = 207
        Width = 78
        Height = 21
        TabOrder = 2
        Text = '1'
      end
      object UpDown18: TUpDown
        Left = 154
        Top = 207
        Width = 16
        Height = 21
        Associate = edSetAddr
        Min = 1
        Position = 1
        TabOrder = 3
      end
    end
  end
end
