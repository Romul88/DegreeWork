object HeatExchangerGraphicsForm: THeatExchangerGraphicsForm
  Left = 69
  Top = 150
  BorderStyle = bsSizeToolWin
  Caption = 'HeatExchangerGraphicsForm'
  ClientHeight = 751
  ClientWidth = 543
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesigned
  OnMouseMove = FormMouseMove
  OnResize = FormShow
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GUroven: TChart
    Left = 0
    Top = 0
    Width = 543
    Height = 297
    AllowPanning = pmNone
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Gradient.EndColor = clWhite
    Legend.Alignment = laTop
    Legend.Frame.Visible = False
    Legend.LegendStyle = lsSeries
    Legend.Shadow.HorizSize = 0
    Legend.Shadow.VertSize = 0
    Legend.TopPos = 0
    MarginBottom = 3
    MarginLeft = 1
    MarginTop = 3
    Title.Alignment = taLeftJustify
    Title.Font.Charset = RUSSIAN_CHARSET
    Title.Font.Color = clBlack
    Title.Font.Height = -19
    Title.Font.Name = 'Times New Roman'
    Title.Text.Strings = (
      '     '#1047#1072#1074#1080#1089#1080#1084#1086#1089#1090#1100' '#1091#1088#1086#1074#1085#1103' '#1086#1090' '#1074#1088#1077#1084#1077#1085#1080' - H(t)')
    BottomAxis.Automatic = False
    BottomAxis.AutomaticMaximum = False
    BottomAxis.AutomaticMinimum = False
    BottomAxis.ExactDateTime = False
    BottomAxis.Maximum = 20.000000000000000000
    LeftAxis.Automatic = False
    LeftAxis.AutomaticMaximum = False
    LeftAxis.AutomaticMinimum = False
    LeftAxis.ExactDateTime = False
    LeftAxis.Maximum = 105.000000000000000000
    LeftAxis.Minimum = -5.000000000000000000
    View3D = False
    Zoom.Allow = False
    Zoom.Animated = True
    Align = alTop
    Color = clWhite
    TabOrder = 0
    Locked = True
    OnMouseMove = FormMouseMove
    DesignSize = (
      543
      297)
    object BHistoryOpen: TSpeedButton
      Left = 419
      Top = 1
      Width = 123
      Height = 24
      Anchors = [akTop, akRight]
      Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1086' >>'
      Flat = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = BHistoryOpenClick
      ExplicitLeft = 348
    end
    object POperat: TGroupBox
      Left = 415
      Top = 33
      Width = 120
      Height = 97
      Anchors = [akTop, akRight]
      Caption = #1054#1087#1077#1088#1072#1094#1080#1080
      TabOrder = 0
      Visible = False
      object BHistoryDelete: TSpeedButton
        Left = 8
        Top = 40
        Width = 105
        Height = 22
        Caption = #1059#1076#1072#1083#1080#1090#1100
      end
      object btnGraphsClear: TSpeedButton
        Left = 8
        Top = 16
        Width = 105
        Height = 22
        Caption = #1056#1077#1089#1090#1072#1088#1090' '#1075#1088#1072#1092#1080#1082#1086#1074
        OnClick = btnGraphsClearClick
      end
      object CBCoordinates: TCheckBox
        Left = 8
        Top = 64
        Width = 97
        Height = 17
        Caption = #1050#1086#1086#1088#1076#1080#1085#1072#1090#1099
        TabOrder = 0
      end
    end
    object PHistory: TGroupBox
      Left = 415
      Top = 137
      Width = 120
      Height = 145
      Anchors = [akTop, akRight]
      Caption = #1048#1089#1090#1086#1088#1080#1080
      TabOrder = 1
      Visible = False
      object CLBHistory: TCheckListBox
        Left = 8
        Top = 16
        Width = 105
        Height = 120
        OnClickCheck = CLBHistoryClickCheck
        BorderStyle = bsNone
        ItemHeight = 13
        TabOrder = 0
      end
    end
    object Series1: TFastLineSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Visible = False
      SeriesColor = clBlack
      Title = #1059#1088#1086#1074#1077#1085#1100' '#1074' '#1073#1072#1082#1077
      LinePen.Width = 3
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series2: TFastLineSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Visible = False
      SeriesColor = clBlue
      Title = #1057#1090#1077#1087#1077#1085#1100' '#1086#1090#1082#1088#1099#1090#1080#1103' '#1082#1083#1072#1087#1072#1085#1072' '#1085#1072' '#1087#1088#1080#1090#1086#1082#1077
      LinePen.Color = clBlue
      LinePen.Width = 2
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series3: TFastLineSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Visible = False
      Title = #1057#1090#1077#1087#1077#1085#1100' '#1086#1090#1082#1088#1099#1090#1080#1103' '#1082#1083#1072#1087#1072#1085#1072' '#1085#1072' '#1089#1090#1086#1082#1077
      LinePen.Color = clRed
      LinePen.Width = 2
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series8: TFastLineSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Visible = False
      SeriesColor = clBlack
      ShowInLegend = False
      Title = '<<'#1042#1077#1088#1090#1080#1082#1072#1083#1100#1085#1072#1103' '#1086#1089#1100'>>'
      LinePen.SmallDots = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object GTemper: TChart
    Left = 0
    Top = 297
    Width = 543
    Height = 277
    AllowPanning = pmNone
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Style = bsClear
    Gradient.EndColor = clWhite
    Gradient.Visible = True
    LeftWall.Color = clWhite
    Legend.Alignment = laTop
    Legend.ColorWidth = 30
    Legend.Frame.Visible = False
    Legend.LegendStyle = lsSeries
    Legend.Shadow.HorizSize = 0
    Legend.Shadow.VertSize = 0
    Legend.Symbol.Width = 30
    Legend.TopPos = 0
    MarginBottom = 3
    MarginLeft = 1
    MarginTop = 3
    Title.Alignment = taLeftJustify
    Title.Brush.Color = clWhite
    Title.Font.Charset = RUSSIAN_CHARSET
    Title.Font.Color = clBlack
    Title.Font.Height = -19
    Title.Font.Name = 'Times New Roman'
    Title.Text.Strings = (
      '     '#1047#1072#1074#1080#1089#1080#1084#1086#1089#1090#1100' '#1090#1077#1084#1087#1077#1088#1072#1090#1091#1088#1099' '#1086#1090' '#1074#1088#1077#1084#1077#1085#1080' - T(t)')
    BottomAxis.Automatic = False
    BottomAxis.AutomaticMaximum = False
    BottomAxis.AutomaticMinimum = False
    BottomAxis.AxisValuesFormat = '#,##0.#'
    BottomAxis.ExactDateTime = False
    BottomAxis.Maximum = 20.000000000000000000
    LeftAxis.Automatic = False
    LeftAxis.AutomaticMaximum = False
    LeftAxis.AutomaticMinimum = False
    LeftAxis.Maximum = 210.000000000000000000
    LeftAxis.Minimum = -10.000000000000000000
    View3D = False
    Zoom.Allow = False
    Zoom.Animated = True
    Align = alTop
    Color = clWhite
    TabOrder = 1
    Locked = True
    OnMouseMove = FormMouseMove
    object Series4: TFastLineSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Visible = False
      SeriesColor = 4194368
      Title = #1058#1077#1084#1087#1077#1088#1072#1090#1091#1088#1072' '#1074' '#1073#1072#1082#1077
      LinePen.Color = 4194368
      LinePen.Width = 3
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series5: TFastLineSeries
      Cursor = crCross
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Visible = False
      SeriesColor = clBlue
      Title = #1058#1077#1084#1087#1077#1088#1072#1090#1091#1088#1072' '#1085#1072' '#1074#1093#1086#1076#1077' '#1074' '#1073#1072#1082
      LinePen.Color = clBlue
      LinePen.Width = 2
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series6: TFastLineSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Visible = False
      Title = #1058#1077#1084#1087#1077#1088#1072#1090#1091#1088#1072' '#1087#1072#1088#1072
      LinePen.Color = clRed
      LinePen.Width = 2
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series7: TFastLineSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Callout.Length = 0
      Marks.Visible = False
      SeriesColor = clBlack
      ShowInLegend = False
      Title = '<<'#1042#1077#1088#1090#1080#1082#1072#1083#1100#1085#1072#1103' '#1086#1089#1100'>>'
      LinePen.Style = psDashDot
      LinePen.SmallDots = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series9: TPointSeries
      Marks.Arrow.Color = clBlack
      Marks.Arrow.Visible = False
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Color = clBlack
      Marks.Callout.Arrow.Visible = False
      Marks.Callout.Length = 2
      Marks.BackColor = clWhite
      Marks.Color = clWhite
      Marks.Font.Charset = ANSI_CHARSET
      Marks.Font.Height = -13
      Marks.Font.Style = [fsBold]
      Marks.Frame.Color = clWhite
      Marks.Style = smsXValue
      Marks.Visible = True
      SeriesColor = clBlack
      ShowInLegend = False
      Title = '<<'#1055#1086#1076#1087#1080#1089#1100' '#1087#1086' X>>'
      ValueFormat = '#,##0.#'
      ClickableLine = False
      Pointer.HorizSize = 1
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.VertSize = 1
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series10: TFastLineSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Callout.Length = 0
      Marks.Visible = False
      SeriesColor = clBlack
      ShowInLegend = False
      Title = '<<'#1043#1086#1088#1080#1079#1086#1085#1090#1072#1083#1100#1085#1072#1103' '#1086#1089#1100'>>'
      LinePen.SmallDots = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series11: TPointSeries
      Marks.Arrow.Visible = False
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = False
      Marks.Callout.Length = -6
      Marks.BackColor = clWhite
      Marks.Color = clWhite
      Marks.Font.Charset = RUSSIAN_CHARSET
      Marks.Font.Height = -13
      Marks.Font.Name = 'Times New Roman'
      Marks.Font.Style = [fsBold]
      Marks.Frame.Visible = False
      Marks.Style = smsValue
      Marks.Visible = True
      SeriesColor = clBlack
      ShowInLegend = False
      Title = '<<'#1055#1086#1076#1087#1080#1089#1100' '#1087#1086' Y>>'
      ValueFormat = '#,##0.#'
      ClickableLine = False
      Pointer.HorizSize = 1
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.VertSize = 1
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
end
