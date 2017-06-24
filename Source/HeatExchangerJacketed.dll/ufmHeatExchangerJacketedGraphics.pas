unit ufmHeatExchangerJacketedGraphics;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, Series, TeEngine, StdCtrls, CheckLst, Buttons, ExtCtrls, TeeProcs,
  Chart;

type
  TfrmHeatExchangerGraphics = class(TFrame)
    GUroven: TChart;
    BHistoryOpen: TSpeedButton;
    POperat: TGroupBox;
    BHistoryDelete: TSpeedButton;
    BUrovenClear: TSpeedButton;
    CBCoordinates: TCheckBox;
    PHistory: TGroupBox;
    CLBHistory: TCheckListBox;
    Edit1: TEdit;
    Series1: TFastLineSeries;
    Series2: TFastLineSeries;
    Series3: TFastLineSeries;
    Series8: TFastLineSeries;
    GTemper: TChart;
    Series4: TFastLineSeries;
    Series5: TFastLineSeries;
    Series6: TFastLineSeries;
    Series7: TFastLineSeries;
    Series9: TPointSeries;
    Series10: TFastLineSeries;
    Series11: TPointSeries;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

end.
