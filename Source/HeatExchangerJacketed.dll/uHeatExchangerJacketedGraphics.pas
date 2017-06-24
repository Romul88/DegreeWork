unit uHeatExchangerJacketedGraphics;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, TeeProcs, TeEngine, Chart, Series, Buttons, StdCtrls,
  CheckLst, ComCtrls, uHeatExchangerJacketed;

type
   THistPoints=record
      x,y : real;
   end;
   THistory=record
      name : String;
      color : Cardinal;
      Points : array of THistPoints;
   end;
  THeatExchangerGraphicsForm = class(TForm)
    GUroven: TChart;
    BHistoryOpen: TSpeedButton;
    POperat: TGroupBox;
    BHistoryDelete: TSpeedButton;
    btnGraphsClear: TSpeedButton;
    CBCoordinates: TCheckBox;
    PHistory: TGroupBox;
    CLBHistory: TCheckListBox;
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
    procedure BHistoryOpenClick(Sender: TObject);
    procedure btnGraphsClearClick(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure CLBHistoryClickCheck(Sender: TObject);
  //  procedure BHistorySaveClick(Sender: TObject);
  {  procedure CLBHistoryClickCheck(Sender: TObject);
    procedure BHistoryDeleteClick(Sender: TObject);
    procedure BUrovenClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure GTemperMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure CBCoordinatesClick(Sender: TObject);   }
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  HeatExchangerGraphicsForm: THeatExchangerGraphicsForm;
  MouseX: integer=0;
  MouseY: integer=0;
  Histories,HistoriesTemper: array of THistory;
   C : integer = 1;


implementation

uses Unit1;


{$R *.dfm}




// Процедура на открытие панели управления историей


// Кнопка сохранения истории
{procedure TGrafUroven.BHistorySaveClick(Sender: TObject);
   var i:real; j:integer;
       Series:TFastLineSeries;
begin
    Form1.Timer1.Enabled:=False;
    FHistory.ShowModal;
if (FHistory.ModalResult<>mrCancel) then begin
    Setlength(Histories,length(Histories)+1);
    Setlength(Histories[length(Histories)-1].Points,Round((tg+0.05)*10));
    i:=0.05;
    j:=0;
    While (i<=tg) do begin
       Histories[length(Histories)-1].Points[j].x:= GUroven.Series[0].XValue[j];
       Histories[length(Histories)-1].Points[j].y:=GUroven.Series[0].YValue[j];
       i:=i+0.1;
       inc(j);
    end;
    Histories[length(Histories)-1].color:=FHistory.CBHistoryColor.Selected;
    Histories[length(Histories)-1].name:=FHistory.EHistoryName.Text;
    CLBHistory.AddItem(FHistory.EHistoryName.Text,self);
    FHistory.EHistoryName.Text:='';
    Series:= TFastLineSeries.Create(GUroven);
    Series.LinePen.Width:=2;
    GUroven.AddSeries(Series);
    GUroven.Series[length(Histories)].SeriesColor:=Histories[length(Histories)-1].color;
end;
    Form1.Timer1.Enabled:=True;
end;   }

// Выбор истории, которую показывать.





//Процедура очистки графика
     {
// Процедура удаления
procedure TGrafUroven.BHistoryDeleteClick(Sender: TObject);
   var i,j,k:integer;
begin
   for i:=0 to (length(Histories)-1) do if CLBHistory.Selected[i] then
   begin
      for j:=i+2 to (length(Histories)-2+2) do
      begin
         Guroven.Series[j+1].Assign(Guroven.Series[j+2]);
         GTemper.Series[j+1].Assign(GTemper.Series[j+2]);
         Setlength(Histories[j].Points,length(Histories[j+1].Points));
         Setlength(HistoriesTemper[j].Points,length(HistoriesTemper[j+1].Points));
         for k:=0 to (length(Histories[j].Points)-1) do
         begin
            Histories[j].Points[k].x:= Histories[j+1].Points[k].x;
            Histories[j].Points[k].y:= Histories[j+1].Points[k].y;
         end;
         for k:=0 to (length(HistoriesTemper[j].Points)-1) do
         begin
            HistoriesTemper[j].Points[k].x:= HistoriesTemper[j+1].Points[k].x;
            HistoriesTemper[j].Points[k].y:= HistoriesTemper[j+1].Points[k].y;
         end;
         Histories[j].name:=Histories[j+1].name;
         HistoriesTemper[j].name:=HistoriesTemper[j+1].name;
         Histories[j].color:=Histories[j+1].color;
         HistoriesTemper[j].color:=HistoriesTemper[j+1].color;
         CLBHistory.Items[j]:=CLBHistory.Items[j+1];
      end;
      Guroven.Series[length(Histories)+2].Destroy;
      GTemper.Series[length(HistoriesTemper)+2].Destroy;
      CLBHistory.Items.Delete(length(Histories)-1);
      Setlength(Histories,length(Histories)-1);
      Setlength(HistoriesTemper,length(HistoriesTemper)-1);
      GrafUroven.CLBHistoryClickCheck(Sender);
      break;
   end;
end;


procedure TGrafUroven.FormCreate(Sender: TObject);
begin
//   Setlength(Histories,3);
   GUroven.Height:=Round(GrafUroven.ClientHeight/2-1);
   GTemper.Height:=Round(GrafUroven.ClientHeight/2);
   GrafUroven.Repaint;
end;
   }
//-------------------------------------------------------------------------------
// Процедура показа перекрестья координат на графике температуры по движению мыши
//-------------------------------------------------------------------------------


     {


procedure TGrafUroven.CBCoordinatesClick(Sender: TObject);
var j: integer;
begin
   If not(CBCoordinates.Checked) then
   begin
           for j := 3 to 6 do Gtemper.Series[j].Clear;
      for j := 0 to 2 do Gtemper.Series[j].Cursor := CrDefault;
   end;
end;         }

procedure THeatExchangerGraphicsForm.BHistoryOpenClick(Sender: TObject);
begin
   if (BHistoryOpen.Tag=0) then
   begin
      GUroven.MarginRight := 32;
      GTemper.MarginRight := 32;
      BHistoryOpen.Caption:= '<< Скрыть';
      POperat.Visible:= True;
      PHistory.Visible:=True;
      BHistoryOpen.Tag:=1;
   end else
   if (BHistoryOpen.Tag=1) then
   begin
      GUroven.MarginRight := 3;
      GTemper.MarginRight := 3;
      BHistoryOpen.Caption:= 'Дополнительно >>';
      POperat.Visible:= False;
      PHistory.Visible:=False;
      BHistoryOpen.Tag:=0;
   end;
end;

procedure THeatExchangerGraphicsForm.btnGraphsClearClick(Sender: TObject);
     var i:real; j:integer;
       Series:TFastLineSeries;
begin
    HeatExchangerForm.tmrModelCalculate.Enabled:=False;
 //   FHistory.ShowModal;
//if (FHistory.ModalResult<>mrCancel) then
    begin
    Setlength(Histories,length(Histories)+1);
    Setlength(HistoriesTemper,length(HistoriesTemper)+1);
    Setlength(Histories[length(Histories)-1].Points,Round((tg+0.05)*10));
    Setlength(HistoriesTemper[length(HistoriesTemper)-1].Points,Round((tg+0.05)*10));
    i:=0.05;
    j:=0;
    While (i<=tg) do begin
       Histories[length(Histories)-1].Points[j].x:= GUroven.Series[0].XValue[j];
       HistoriesTemper[length(HistoriesTemper)-1].Points[j].x:= GTemper.Series[0].XValue[j];
       Histories[length(Histories)-1].Points[j].y:=GUroven.Series[0].YValue[j];
       HistoriesTemper[length(HistoriesTemper)-1].Points[j].y:=GTemper.Series[0].YValue[j];
       i:=i+0.1;
       inc(j);
    end;
    Histories[length(Histories)-1].color:= RGB(250,0,0);
    HistoriesTemper[length(HistoriesTemper)-1].color:= RGB(250,0,0);
    Histories[length(Histories)-1].name:='История ' + IntToStr(C);
    HistoriesTemper[length(HistoriesTemper)-1].name:='История ' + IntToStr(C);
    Inc(C);
    CLBHistory.AddItem(Histories[length(Histories)-1].name,self);
   // FHistory.EHistoryName.Text:='';
    Series:= TFastLineSeries.Create(GUroven);
    Series.LinePen.Width:=2;
    GUroven.AddSeries(Series);
    GUroven.Series[length(Histories)+2].SeriesColor:=Histories[length(Histories)-1].color;
    GUroven.Series[length(Histories)+2].ShowInLegend:= False;
    Series:= TFastLineSeries.Create(GTemper);
    Series.LinePen.Width:=2;
    GTemper.AddSeries(Series);
    GTemper.Series[length(HistoriesTemper)+2].SeriesColor:=HistoriesTemper[length(HistoriesTemper)-1].color;
    GTemper.Series[length(HistoriesTemper)+2].ShowInLegend:= False;
end;
    HeatExchangerForm.tmrModelCalculate.Enabled:=True;
     HeatExchangerGraphicsForm.Guroven.Series[0].Clear;
     HeatExchangerGraphicsForm.Guroven.Series[1].Clear;
     HeatExchangerGraphicsForm.Guroven.Series[2].Clear;
     HeatExchangerGraphicsForm.GTemper.Series[0].Clear;
     HeatExchangerGraphicsForm.GTemper.Series[1].Clear;
     HeatExchangerGraphicsForm.GTemper.Series[2].Clear;
   tg:=-0.05;
   HeatExchangerGraphicsForm.GUroven.BottomAxis.SetMinMax(0,10);
   HeatExchangerGraphicsForm.GTemper.BottomAxis.SetMinMax(0,10);
    ending := 10;
end;

procedure THeatExchangerGraphicsForm.CLBHistoryClickCheck(Sender: TObject);
   var i,j:integer;
begin
   for i:=0 to (length(Histories)-1) do
   begin
      If (CLBHistory.Checked[i]=True) then
      begin
         GUroven.Series[i+1+2].Clear;
         for j:=0 to (length(Histories[i].Points)-1) do
         begin
            GUroven.Series[i+1+2].AddXY(Histories[i].Points[j].x,Histories[i].Points[j].y);
            GTemper.Series[i+1+2].AddXY(HistoriesTemper[i].Points[j].x,HistoriesTemper[i].Points[j].y);
         end;
      end
      else
      begin
         GUroven.Series[i+1+2].Clear;
         GTemper.Series[i+1+2].Clear;
      end;
   end;
end;

procedure THeatExchangerGraphicsForm.FormMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var XTime, YTemperature: real;   //Переменные: XTime - время (в секундах), соответствующее координате Х мыши на графике
                                 //            YTemperature - температура (в градусах), соответствующая координате Y мыши на графике
    i: integer;   // Переменная - внутренний счётчик
begin
   if (CBCoordinates.Checked) and (Gtemper.Tag = 1) then   //Если опция "Показ координат" выделена на панели "Операции",
                                                           // и тэг равен 1 (курсор мыши в пределах графика), то...
   begin
      for i := 3 to 6 do Gtemper.Series[i].Clear;   // Очистка 4-х трендов, отвечающих за пунктир и подписи перекрестья
      for i := 0 to 2 do Gtemper.Series[i].Cursor := CrCross;   // При наведении на тренды, отвечающие за температуру
                                                                // курсор будет принимать форму креста ("Попали!")
      for i := 3 to 3 do GUroven.Series[i].Clear;

// Следующее выражение определяет значение переменной XTime. Вычисления проводятся исходя из следующих величин:
//    X - текущая ЭКРАННАЯ КООРДИНАТА Х мыши;
//    27 - стандартный неликвидируемый и неизменяемый отступ на текст слева (без учёта отступа MarginLeft);
//    Gtemper.MarginLeft/100 - отступ слева от 27-го пиксела до графика В ПРОЦЕНТАХ ОТ ВСЕЙ ШИРИНЫ ОКНА (поэтому делится на 100);
//    Gtemper.Width - ширина всего окна графика (включая пустое пространство слева и справа;
//    Ending - крайнее правое значение по оси времени ("конец графика") в секундах;
//    Gtemper.MarginRight/100 - отступ справа от конца графика до края окна В ПРОЦЕНТАХ ОТ ВСЕЙ ШИРИНЫ ОКНА (поэтому делится на 100);
// Вычисление ведётся по следующему алгоритму: вначале из общей ширины окна вычитаются все отступы (получается непосредственная ширина графика в пикселах).
// Далее, разделив Общую длину графика в секундах на его длину в пикселах, получаем количество секунд в одном пикселе.
// После этого, умножив текущую координату мыши (опять же с поправкой на отступы слева) на количество секунд в одном пикселе, получаем координату мыши в секундах,
// т.е. значение времени в точке, указанной мышью.

      Xtime := (X - (27 + Gtemper.MarginLeft/100 * Gtemper.Width)) * Ending / (Gtemper.Width - (27 + Gtemper.MarginLeft/100 * Gtemper.Width) - (Gtemper.MarginRight/100 * Gtemper.Width));

      Gtemper.Series[3].AddXY(Xtime,Gtemper.LeftAxis.Minimum);   // Нижняя точка вертикальной оси перекрестья...
      Gtemper.Series[3].AddXY(Xtime,Gtemper.LeftAxis.Maximum);   // ...и верхняя точка вертикальной оси перекрестья

      GUroven.Series[3].AddXY(Xtime,Gtemper.LeftAxis.Minimum);
      GUroven.Series[3].AddXY(Xtime,Gtemper.LeftAxis.Maximum);

      if (y > Gtemper.Height/2) then   // Если курсор мыши находится в нижней половине графика
                                       // (т.к. координата Y отсчитываются от верхней границы окна), то...
      begin
         Gtemper.Series[4].AddXY(Xtime,Gtemper.LeftAxis.Maximum);   // Надпись выводится в верхней части графика
         Gtemper.Series[4].Marks.ArrowLength := -18;   // Сдвиг надписи вниз относительно точки, которую она обозначает (на 18 пикселей)
      end else   // Иначе (если курсор мыши находится в верхней половине графика)...
      begin
         Gtemper.Series[4].AddXY(Xtime,Gtemper.LeftAxis.Minimum);   // Надпись выводится в нижней части графика
         Gtemper.Series[4].Marks.ArrowLength := 2;   // Сдвиг надписи вверх относительно точки, которую она обозначает (на 2 пиксела)
      end;

//-----------------------------------
   YTemperature:=210-(Y-(68+Gtemper.MarginTop/100*Gtemper.Height))*220/(Gtemper.Height-(68+Gtemper.MarginTop/100*Gtemper.Height)-(19+Gtemper.MarginBottom/100*Gtemper.Height));

   Gtemper.Series[5].AddXY(GTemper.BottomAxis.Minimum,YTemperature);
   Gtemper.Series[5].AddXY(Gtemper.BottomAxis.Maximum,YTemperature);

   if (XTime > Ending/2) then
   begin
      Gtemper.Series[6].AddXY(0,YTemperature);
   end else
   begin
       Gtemper.Series[6].AddXY(ending,YTemperature);
   end;
 //----------------------------

      if (X >= (Gtemper.Width  - (Gtemper.MarginRight/100 * Gtemper.Width))) or (X <= 27 + (Gtemper.MarginLeft/100 * Gtemper.Width))  then
      begin
         for i := 3 to 6 do Gtemper.Series[i].Clear;
         Gtemper.Tag:=0;
      end;
  end;
  if (X >= (Gtemper.Width  - (Gtemper.MarginRight/100 * Gtemper.Width))) or (X <= 27 + (Gtemper.MarginLeft/100 * Gtemper.Width)) then Gtemper.Tag:=0 else Gtemper.Tag:=1;
  //Edit1.Text:='x = ' + FloatToStr(x) + ' y = ' + FloatToStr(y);
end;

procedure THeatExchangerGraphicsForm.FormShow(Sender: TObject);
begin
  GUroven.Height:=Round(HeatExchangerGraphicsForm.ClientHeight/2-1);
   GTemper.Height:=Round(HeatExchangerGraphicsForm.ClientHeight/2);
  // HeatExchangerGraphicsForm.Repaint;
end;

end.
