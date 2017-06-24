{************************************************************}
{                                                            }
{              Модуль "uHeatExchangerJacketed.pas"           }
{                Copyright (c) 2010 "BolkodaB"               }
{                                                            }
{  Разработчик: Максимов Р.Ю.                                }
{  Модифицирован: 6.04.2010                                  }
{  Версия:        0.6.0.0                                    }
{************************************************************}

unit uHeatExchangerJacketed;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufmHeatExchangerJacketed, StdCtrls, OpenGL, ExtCtrls, ComCtrls,
  Buttons, Menus, math, ToolWin, ufmHeatExchangerJacketedGraphics,    Unit1,
  pngimage;

type
//******************************************************************************

// ОБЪЯВЛЕНИЕ КЛАССА "ВЕНТИЛЬ"
  TValve = class
    Centre: record   // Параметры центра вентиля
      X: double;      // Абсцисса центра вентиля
      Y: double;      // Ордината центра вентиля
    end;
    Width: double;    // Ширина вентиля
    Height: double;   // Высота вентиля
    Angle: double;    // Угол поворота относительно горизонтали (против часовой)
    Scale: double;    // Коэффициент увеличения масштаба
    TwingleParam: record
      TwingleOn: boolean;    // Мигает вентиль или нет
      Direction: integer;    // Направление нарастания R, G и B
      TwingleSpeed: integer  // Частота мигания
    end;
    Color, CurrentColor: cardinal;  // Цвет вентиля, текущий цвет (при мерцании)
    constructor Create(x, y, w, h, a: double; tw: boolean; clr: cardinal);
    destructor Destroy; override;
    procedure Paint;                   // Метод рисования (включая мигание)
    procedure SetTwingleSpeed(twspd: integer);  // Метод задания частоты мигания
    procedure SetScale(scl: double);  // Метод задания масштаба
    procedure MouseMoving (CoordX, CoordY: double; FormOwner: TControl);
  end;

//******************************************************************************

// ОБЪЯВЛЕНИЕ КЛАССА "ПРЯМОУГОЛЬНИК (основа для рисования объектов)
  TRectangle = class
    Centre: record   // Параметры центра прямоугольника
      x: double;   // Абсцисса центра прямоугольника
      y:double;   // Ордината центра прямоугольника
    end;
    width: double;    // Ширина прямоугольника
    height: double;   // Высота прямоугольника
    RoundParam: record
      LeftBottomRad: double;   // Радиус нижнего левого скругления
      LeftTopRad: double;      // Радиус верхнего левого скругления
      RightTopRad: double;     // Радиус верхнего правого скругления
      RightBottomRad: double;  // Радиус нижнего правого скругления
    end;
    VertexColorParam: record
      VLeftBottomColor: cardinal;   // Цвет нижней левой вершины
      VLeftTopColor: cardinal;      // Цвет верхней левой вершины
      VRightTopColor: cardinal;     // Цвет верхней правой вершины
      VRightBottomColor: cardinal;  // Цвет нижней правой вершины
    end;
    ContourColor: cardinal;
    angle: double;    // Угол поворота относительно горизонтали (против часовой)
    scale: double;    // Коэффициент увеличения масштаба
    constructor Create(x, y, w, h: real; LBR,LTR, RTR,RBR: double;
    VLBC, VLTC, VRTC, VRBC: cardinal; a: double);
    Destructor Destroy;
    procedure PaintRectangle; // Метод рисования
    procedure PaintContour; // Метод рисования
    procedure SetScale(scl: double);  // Метод задания масштаба
   // procedure SetColor(VLBC, VLTC, VRTC, VRBC, : cardinal);
end;

//******************************************************************************

  THeatExchangerForm = class(TForm)
    frmHeatExchanger: TfrmHeatExchanger;
    mmHEJ: TMainMenu;
    btnFile: TMenuItem;
    btnClose: TMenuItem;
    trckbrValveIn: TTrackBar;
    lbledtValveIn: TLabeledEdit;
    pnlFlowIn: TPanel;
    trckbrValveSteam: TTrackBar;
    trckbrValveOut: TTrackBar;
    lbledtValveOut: TLabeledEdit;
    lbledtValveSteam: TLabeledEdit;
    pnlFlowSteam: TPanel;
    pnlFlowOut: TPanel;
    tmrOpenGLPaint: TTimer;
    lbledtTLiquidIn: TLabeledEdit;
    lbledtPLiquidIn: TLabeledEdit;
    trckbrTLiquidIn: TTrackBar;
    trckbrPLiquidIn: TTrackBar;
    lbledtPSteam: TLabeledEdit;
    trckbrPSteam: TTrackBar;
    pnlTLiquidOut: TPanel;
    pnlFlowCondensate: TPanel;
    tmrColorCalculate: TTimer;
    btnGraphs: TMenuItem;
    btnShowGraphs: TMenuItem;
    N2: TMenuItem;
    gbChooseRegime: TGroupBox;
    spdbtnStaticRegime: TSpeedButton;
    spdbtnDynamicRegime: TSpeedButton;
    tmrModelCalculate: TTimer;
    pnlLLiquidCurrent: TPanel;
    pnlLLiquidFinal: TPanel;
    pnlTLiquidOut1: TPanel;
    pnlTLiquidFinal: TPanel;
    Panel1: TPanel;
    Timer1: TTimer;
    Image1: TImage;
    Image2: TImage;
    Timer2: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure tmrModelCalculateTimer(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure frmHeatExchangerMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure frmHeatExchangerMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure trckbrValveInChange(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure lbledtValveInChange(Sender: TObject);
    procedure trckbrValveSteamChange(Sender: TObject);
    procedure trckbrValveOutChange(Sender: TObject);
    procedure lbledtValveSteamChange(Sender: TObject);
    procedure lbledtValveOutChange(Sender: TObject);
    procedure tmrOpenGLPaintTimer(Sender: TObject);
    procedure trckbrTLiquidInChange(Sender: TObject);
    procedure trckbrPLiquidInChange(Sender: TObject);
    procedure lbledtTLiquidInChange(Sender: TObject);
    procedure lbledtPLiquidInChange(Sender: TObject);
    procedure lbledtPSteamChange(Sender: TObject);
    procedure trckbrPSteamChange(Sender: TObject);
    procedure tmrColorCalculateTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnShowGraphsClick(Sender: TObject);
    procedure spdbtnStaticRegimeClick(Sender: TObject);
    procedure spdbtnDynamicRegimeClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);


  private
    { Private declarations }
    DC: HDC;
    hrc: HGLRC;
    procedure PixelFormat;
    procedure Scale(m: double);
    procedure TranslateGLToPixels(AttachObject, ObjectOwner: TControl; XGL, YGL, Scale: double);
    procedure LiquidInToOutMorphing(CentreX, CentreY: double; CentreColor, ContourColor: cardinal);
    procedure ControlsAttaching;

    procedure HintEnter;

  public
    { Public declarations }
  end;

  _TModelHEJInitialize = procedure(var AreaTank, AreaPipe, Beta, KHeatTransfer, RoLiquid, CpLiquid,               // Технические параметры
                                   PSteamIn, TLiquidIn, PLiquidIn, AlphaLiquidIn, AlphaLiquidOut, AlphaSteamIn,   // Технологические переменные
                                   step,                                                                          // Дополнительные параметры
                                   LLiquid, TSteam, TLiquidOut, FlowLiquidIn, FlowLiquidOut,                      // Изменяющиеся переменные
                                   FlowSteamIn, FlowCondensate: double);
                                   stdcall;





  _TModelHEJCalculate = procedure(AreaTank, AreaPipe, Beta, KHeatTransfer, RoLiquid, CpLiquid,                   // Технические параметры
                                  PSteamIn, TLiquidIn, PLiquidIn, AlphaLiquidIn, AlphaLiquidOut, AlphaSteamIn,   // Технологические переменные
                                  Step: double;                                                                  // Дополнительные параметры
                                  var LevelLiquid, TSteam, TLiquidOut, FlowLiquidIn, FlowLiquidOut,              // Изменяющиеся переменные
                                      FlowSteamIn, FlowCondensate : double);
                                  stdcall;


  TRegime = (StaticRegime, DynamicRegime);
//******************************************************************************
var
  PipeInHorizontal: TRectangle;  // Горизонтальный участок трубы на входе
  PipeInVertical: TRectangle;    // Вертикальный участок трубы на входе
  PipeInPatch: TRectangle;       // "Заплата" в месте стыка труб
  Tank: TRectangle;              // Ёмкость теплообменника
  Jacket: TRectangle;            // "Рубашка" теплообменника
  Liquid: TRectangle;            // Жидкость в теплообменнике
  PipeSteamHorizontal: TRectangle;  // Труба на паре
  PipeSteamPatch: TRectangle;
  ValveSteamPatch: Trectangle;
  ValveInPatch: Trectangle;

  PipeOutHorizontal: TRectangle;
  PipeOutVertical: TRectangle;
  PipeOutPatchTop: TRectangle;
  PipeOutPatchBottom: TRectangle;
  ValveOutPatch: Trectangle;

  PipeSteamTrapHorizontal: TRectangle;
  PipeSteamTrapVertical: TRectangle;
  PipeSteamTrapWhite: TRectangle;
  PipeSteamTrapBlack: TRectangle;

  MixerRoller: TRectangle;
  MixerFan: TRectangle;

//******************************************************************************

 i: double = -1;

  Regime: TRegime = StaticRegime;





  HLib: THandle;

   LiquidOutColor: cardinal;
  LiquidInColor: cardinal;
  SteamColor: cardinal;


  dop: double;




  HeatExchangerForm: THeatExchangerForm;
  ValveIn, ValveOut, ValveSteam: TValve;
  Heater, Bak, Rub, Trub: TRectangle;
  _ModelHEJIni: _TModelHEJInitialize;



   AreaTank, AreaPipe, Beta, KHeatTransfer, RoLiquid,
                             CpLiquid, TLiquidIn, PLiquidIn, AlphaLiquidIn,
                             AlphaLiquidOut,PSteamIn, AlphaSteamIn, step : double;



    _ModelHEJCalc: _TModelHEJCalculate;

     LLiquid: double;
     TLiquidOut: double;

     TSteam, PressureSteamJacket, FlowLiquidIn, FlowLiquidOut, FlowSteamIn, FlowCondensate: double;




     ending : real = 20.05;
     tg:real=-0.05; //Убирает опоздание на графике
  //ps: TPaintStruct;

implementation

uses uHeatExchangerJacketedGraphics;

{$R *.dfm}

//******************************************************************************

// МЕТОДЫ КЛАССА "ВЕНТИЛЬ"

//******************************************************************************

 { Конструктор класса "Вентиль". При инициализации объекта задаются необходимые
  входные параметры:
  x - координата x центра вентиля,
  y - координата y центра вентиля,
  w - ширина вентиля,
  h - высота вентиля,
  a - угол поворота вентиля относительно горизонтали (против часовой стрелки),
  tw - логическая переменная, отвечающая за мигание вентиля:
    True - мигает,
    False - не мигает
  direction - определяет направление нарастания цвета при мигании:
    1 - цвет идёт к белому
    -1 - цвет идёт к первоначальному
  TwingleSpeed - показывает, на сколько прирастатает цвет (0-255) за каждый
                 проход процедуры "Paint"
  clr - цвет вентиля типа Cardinal }
constructor TValve.Create;
begin
  Centre.x := x;
  Centre.y := y;
  width := w;
  height := h;
  angle := a;
  scale := 1;
  TwingleParam.twingleOn := tw;
  TwingleParam.direction := 1;
  TwingleParam.twingleSpeed := 40;
  color := clr;
  CurrentColor := clr;
end;

//******************************************************************************

// Деструктор класса "Вентиль". Все поля класса обнуляются
Destructor Tvalve.Destroy;
begin
  Centre.x := 0;
  Centre.y := 0;
  width := 0;
  height := 0;
  angle := 0;
  scale := 0;
  TwingleParam.twingleOn := false;
  TwingleParam.direction := 0;
  TwingleParam.twingleSpeed := 0;
  color := 0;
  CurrentColor := 0;
end;

//******************************************************************************

// Метод "Рисование" класса "Вентиль"
procedure TValve.Paint;
var
  R, G, B: byte;
begin
//----- Цикл обработки мигания
  if (TwingleParam.twingleOn) then  // Если мигание включено,...
  begin                             // ...то начинаем цикл
// Считывается красная составляющая текущего цвета...
    R := GetRValue(CurrentColor);
// ...если красная составляющая находится в пределах "текущий цвет-255"...
    if (R >= GetRValue(Color)) and (R <= 255 - TwingleParam.twingleSpeed)
// ...то увеличиваем её на заданное значение шага
    then R := R + TwingleParam.direction * TwingleParam.twingleSpeed;
// Считывается зелёная составляющая текущего цвета...
    G := GetGValue(CurrentColor);
// ...если зелёная составляющая находится в пределах "текущий цвет-255"...
    if (G >= GetGValue(Color)) and (G <= 255 - TwingleParam.twingleSpeed)
// ...то увеличиваем её на заданное значение шага
    then G := G + TwingleParam.direction * TwingleParam.twingleSpeed;
// Считывается синяя составляющая текущего цвета...
    B:= GetBValue(CurrentColor);
// ...если синяя составляющая находится в пределах "цвет-255"...
    if (B >= GetBValue(Color)) and (B <= 255 - TwingleParam.twingleSpeed)
// ...то увеличиваем её на заданное значение шага
    then B := B + TwingleParam.direction * TwingleParam.twingleSpeed;
// Если красная составляющая меньше нижнего предела ("цвет + шаг")...
      if (R < GetRValue(Color) + TwingleParam.twingleSpeed)
// ...и зелёная составляющая меньше нижнего предела ("цвет + шаг")...
      and (G < GetGValue(Color) + TwingleParam.twingleSpeed)
//...и синяя составляющая меньше нижнего предела ("цвет + шаг"), то...
      and (B < GetBValue(Color) + TwingleParam.twingleSpeed) then
      begin
        TwingleParam.direction := 1;  // Нарастание цвета - прямое (+шаг)
// красная составляющая := красная составляющая от начального цвета
        R:= GetRValue(Color);
// зелёная составляющая := красная составляющая от начального цвета
        G:= GetGValue(Color);
// синяя составляющая := красная составляющая от начального цвета
        B:= GetBValue(Color);
      end
// Иначе...
      else
// ...если красная составляющая больше верхнего предела ("255 - шаг")...
      if (R > 255 - TwingleParam.twingleSpeed)
// ...и зелёная составляющая больше верхнего предела ("255 - шаг")...
      and (G > 255 - TwingleParam.twingleSpeed)
// ...и синяя составляющая больше верхнего предела ("255 - шаг"), то...
      and (B > 255 - TwingleParam.twingleSpeed) then
      begin
        TwingleParam.direction := -1;  // Нарастание цвета - обратное (-шаг)
        R:= 255 - TwingleParam.twingleSpeed; // красная составляющая := 255-шаг
        G:= 255 - TwingleParam.twingleSpeed; // зелёная составляющая := 255-шаг
        B:= 255 - TwingleParam.twingleSpeed; // синяя составляющая := 255-шаг
      end;
    CurrentColor := RGB(R, G, B); // Формируем текущий цвет
  end;
//-----Цикл непосредственного рисования
  glTranslateF(centre.x, centre.y, 0);
// Поворот осей OpenGL на угол TValve.angle
  glRotateF(angle, 0, 0, 1);
// Получение цвета из TValve.Color и перевод его в пределы [0,1]...
// ...Если есть мерцание, то получаем текущий цвет...
  if (TwingleParam.twingleOn) then glColor3F(GetRValue(CurrentColor)/255,
      GetGValue(CurrentColor)/255, GetBValue(CurrentColor)/255)
// ...иначе получаем исходный цвет
  else glColor3F(GetRValue(Color)/255, GetGValue(Color)/255,
       GetBValue(Color)/255);
 // glColor3F(GetRValue(Color), getGValue(Color),getBValue(Color));
// Непосредственное рисование вентиля (с учётом масштаба)
//---- "восьмёрка" вентиля
  glbegin(GL_LINE_LOOP);
// Левый нижний угол
    glVertex2F(-width/2*scale,-height/2*scale);
// Левый верхний угол
    glVertex2F(-width/2*scale,height/2*scale);
// Правый нижний угол
    glVertex2F(width/2*scale,-height/2*scale);
// Правый верхний угол
    glVertex2F(width/2*scale,height/2*scale);
  glend;
//---- "Регулятор" вентиля
  glbegin(GL_LINES);
//-- Вертикальный отрезок
// Нижний конец
    glVertex2F(0,0);
// Верхний конец
    glVertex2F(0,height*scale);
//-- Горизонтальный отрезок
// Левый конец
    glVertex2F(-height/2*scale,height*scale);
// правый конец
    glVertex2F(height/2*scale,height*scale);
  glend;
// Обратный поворот осей OpenGL на угол -(TValve.angle)
  glRotateF(-angle, 0, 0, 1);
  glTranslateF(-centre.x, -centre.y, 0);
end;

//******************************************************************************

// Метод "Задать частоту мигания" класса "Вентиль"
procedure TValve.SetTwingleSpeed;
begin
  TwingleParam.twingleSpeed := twspd;
end;

//******************************************************************************

// Метод "Задать новый масштаб" класса "Вентиль"
procedure TValve.SetScale;
begin
  scale := scl;
end;

//******************************************************************************

// Процедура вычисления экранных координат
procedure TValve.MouseMoving;
begin
  if (CoordX > FormOwner.Width / 2 + FormOwner.Height / 8 * (Centre.x - width / 2))
  and (CoordX < FormOwner.Width / 2 + FormOwner.Height / 8 * (Centre.x + width / 2))
  and (CoordY > FormOwner.Height / 2 - GetSystemMetrics(SM_CYMENU) +
      FormOwner.Height / 8 * (-Centre.y - height * 3 / 1))
  and (CoordY < FormOwner.Height / 2 - GetSystemMetrics(SM_CYMENU) +
      FormOwner.Height / 8 * (-Centre.y + height / 1)) then
  begin
    //FormOwner.Cursor := crHandPoint;
    SetScale(1.5);
    TwingleParam.twingleOn := false;
  end else
  begin
    //FormOwner.Cursor := crDefault;
    SetScale(1);
    TwingleParam.twingleOn := true;
  end;
end;

//******************************************************************************

// МЕТОДЫ КЛАССА "ПРЯМОУГОЛЬНИК"

//******************************************************************************

// Конструктор класса "Прямоугольник".
constructor TRectangle.Create;
begin
  centre.x := x;
  centre.y := y;
  width := w;
  height := h;
  RoundParam.LeftBottomRad := LBR;
  RoundParam.LeftTopRad := LTR;
  RoundParam.RightTopRad := RTR;
  RoundParam.RightBottomRad := RBR;
  VertexColorParam.VLeftBottomColor := VLBC;
  VertexColorParam.VLeftTopColor := VLTC;
  VertexColorParam.VRightTopColor := VRTC;
  VertexColorParam.VRightBottomColor := VRBC;
  ContourColor := clblack;
  angle := a;
  scale := 1;
end;

//******************************************************************************

// Деструктор класса "Прямоугольник". Все поля класса обнуляются
Destructor TRectangle.Destroy;
begin
  centre.x := 0;
  centre.y := 0;
  width := 0;
  height := 0;
  RoundParam.LeftBottomRad := 0;
  RoundParam.LeftTopRad := 0;
  RoundParam.RightTopRad := 0;
  RoundParam.RightBottomRad := 0;
  VertexColorParam.VLeftBottomColor := 0;
  VertexColorParam.VLeftTopColor := 0;
  VertexColorParam.VRightTopColor := 0;
  VertexColorParam.VRightBottomColor := 0;
  ContourColor := 0;
  angle := 0;
  scale := 0;
end;

//******************************************************************************

procedure TRectangle.SetScale;
begin
  scale := scl;
end;

//******************************************************************************

// Метод "Рисование" класса "Прямоугольник"
procedure TRectangle.PaintRectangle;
  var i, step : double;
begin
  step := 0.1;
  glTranslateF(centre.x, centre.y, 0);
  glRotateF(angle, 0, 0, 1);
  glbegin(GL_POLYGON);
//-----
    glColor3F(GetRValue(VertexColorParam.VLeftBottomColor)/255,
              GetGValue(VertexColorParam.VLeftBottomColor)/255,
              GetBValue(VertexColorParam.VLeftBottomColor)/255);
    if (RoundParam.LeftBottomRad > 0) then
    begin
      i := 0;
      while (i <= Pi/2) do
      begin
        glVertex2F((-(width/2-RoundParam.LeftBottomRad)-(RoundParam.LeftBottomRad * sin(i)))*scale,
                   (-(height/2-RoundParam.LeftBottomRad)-RoundParam.LeftBottomRad * cos(i))*scale);
        i := i + step;
      end;
    end else glVertex2F(-width/2 * scale, -height/2 * scale);
//-----
    glColor3F(GetRValue(VertexColorParam.VLeftTopColor)/255,
              GetGValue(VertexColorParam.VLeftTopColor)/255,
              GetBValue(VertexColorParam.VLeftTopColor)/255);
    if (RoundParam.LeftTopRad > 0) then
    begin
      i := 0;
      while (i <= Pi/2) do
      begin
        glVertex2F((-(width/2-RoundParam.LeftTopRad)-(RoundParam.LeftTopRad * cos(i)))*scale,
                   ((height/2-RoundParam.LeftTopRad) + RoundParam.LeftTopRad * sin(i))*scale);
        i := i + step;
      end;
    end else glVertex2F(-width/2 * scale, height/2 * scale);
//-----
    glColor3F(GetRValue(VertexColorParam.VRightTopColor)/255,
              GetGValue(VertexColorParam.VRightTopColor)/255,
              GetBValue(VertexColorParam.VRightTopColor)/255);
    if (RoundParam.RightTopRad > 0) then
    begin
      i := 0;
      while (i <= Pi/2) do
      begin
        glVertex2F(((width/2-RoundParam.RightTopRad)+(RoundParam.RightTopRad * sin(i)))*scale,
                   ((height/2-RoundParam.RightTopRad)+RoundParam.RightTopRad * cos(i))*scale);
        i := i + step;
      end;
    end else glVertex2F(width/2 * scale, height/2 * scale);
//------
    glColor3F(GetRValue(VertexColorParam.VRightBottomColor)/255,
              GetGValue(VertexColorParam.VRightBottomColor)/255,
              GetBValue(VertexColorParam.VRightBottomColor)/255);
    if (RoundParam.RightBottomRad > 0) then
    begin
      i := 0;
      while (i <= Pi/2) do
      begin
        glVertex2F(((width/2-RoundParam.RightBottomRad)+(RoundParam.RightBottomRad * cos(i)))*scale,
                   (-(height/2-RoundParam.RightBottomRad)-RoundParam.RightBottomRad * sin(i))*scale);
        i := i + step;
      end;
    end else glVertex2F(width/2 * scale, -height/2 * scale);
//-----
  glend;
  glRotateF(-angle, 0, 0, 1);
  glTranslateF(-centre.x, -centre.y, 0);
end;

//******************************************************************************

procedure TRectangle.PaintContour;
var i, step : real;
begin
  step := 0.1;
  glTranslateF(centre.x, centre.y, 0);
  glRotateF(angle, 0, 0, 1);
  glbegin(GL_LINE_LOOP);
//-----
    glColor3F(GetRValue(ContourColor)/255,
              GetGValue(ContourColor)/255,
              GetBValue(ContourColor)/255);
    if (RoundParam.LeftBottomRad > 0) then
    begin
      i := 0;
      while (i <= Pi/2) do
      begin
        glVertex2F((-(width/2-RoundParam.LeftBottomRad)-(RoundParam.LeftBottomRad * sin(i)))*scale,
                   (-(height/2-RoundParam.LeftBottomRad)-RoundParam.LeftBottomRad * cos(i))*scale);
        i := i + step;
      end;
    end else glVertex2F(-width/2 * scale, -height/2 * scale);
//-----
    if (RoundParam.LeftTopRad > 0) then
    begin
      i := 0;
      while (i <= Pi/2) do
      begin
        glVertex2F((-(width/2-RoundParam.LeftTopRad)-(RoundParam.LeftTopRad * cos(i)))*scale,
                   ((height/2-RoundParam.LeftTopRad)+RoundParam.LeftTopRad * sin(i))*scale);
        i := i + step;
      end;
    end else glVertex2F(-width/2 * scale, height/2 * scale);
//-----
     if (RoundParam.RightTopRad > 0) then
    begin
      i := 0;
      while (i <= Pi/2) do
      begin
        glVertex2F(((width/2-RoundParam.RightTopRad)+(RoundParam.RightTopRad * sin(i)))*scale,
                   ((height/2-RoundParam.RightTopRad)+RoundParam.RightTopRad * cos(i))*scale);
        i := i + step;
      end;
    end else glVertex2F(width/2 * scale, height/2 * scale);
//------
    if (RoundParam.RightBottomRad > 0) then
    begin
      i := 0;
      while (i <= Pi/2) do
      begin
        glVertex2F(((width/2-RoundParam.RightBottomRad)+(RoundParam.RightBottomRad * cos(i)))*scale,
                   (-(height/2-RoundParam.RightBottomRad)-RoundParam.RightBottomRad * sin(i))*scale);
        i := i + step;
      end;
    end else glVertex2F(width/2 * scale, -height/2 * scale);
//-----
  glend;
  glRotateF(-angle, 0, 0, 1);
  glTranslateF(-centre.x, -centre.y, 0);
end;




//******************************************************************************








procedure THeatExchangerForm.BitBtn1Click(Sender: TObject);
begin
HeatExchangerForm.Close;
end;

procedure THeatExchangerForm.Button1Click(Sender: TObject);
begin
   frmHeatExchanger.Left := frmHeatExchanger.Left + 500;
   ControlsAttaching;
   //HeatExchangerForm.Scale(4);
end;

procedure THeatExchangerForm.Button2Click(Sender: TObject);
begin
   frmHeatExchanger.Left := frmHeatExchanger.Left - 500;
   ControlsAttaching;
  // HeatExchangerForm.Scale(4);
end;

procedure THeatExchangerForm.FormCreate(Sender: TObject);
var
 // HLib: THandle;
  ps: TPaintStruct;
begin
  DC := GetDC(frmHeatExchanger.Handle);
  PixelFormat;
  hrc := wglCreateContext(DC);
  wglMakeCurrent(DC, hrc);
  BeginPaint(frmHeatExchanger.Handle,ps);
  glClearColor(1,1,1,1);
  gllinewidth(3);
 EndPaint(frmHeatExchanger.Handle,ps);


     Hlib:=0;
  Hlib:=LoadLibrary('E:\Projects\Degree Work\Source\ModelHeatExchangerJacketed.dll\ModelHeatExchangerJacketed.dll');      //загрузка библиотеки
if Hlib<>0 then                             //загрузка прошла успешно
    _ModelHEJIni:=GetProcAddress(Hlib,'ModelHEJInitialize');

    _ModelHEJIni(AreaTank, AreaPipe, Beta, KHeatTransfer, RoLiquid, CpLiquid,
                 PSteamIn, TLiquidIn, PLiquidIn, AlphaLiquidIn, AlphaLiquidOut, AlphaSteamIn,
                 step,
                 LLiquid, TSteam, TLiquidOut, FlowLiquidIn, FlowLiquidOut, FlowSteamIn, FlowCondensate);

  //  FreeLibrary(Hlib);
     _ModelHEJCalc:=GetProcAddress(Hlib,'ModelHEJCalculate');
     _ModelHEJCalc(AreaTank, AreaPipe, Beta, KHeatTransfer, RoLiquid, CpLiquid,
                  PSteamIn, TLiquidIn, PLiquidIn, AlphaLiquidIn, AlphaLiquidOut, AlphaSteamIn,
                  Step,
                  LLiquid, TSteam, TLiquidOut, FlowLiquidIn, FlowLiquidOut, FlowSteamIn, FlowCondensate);




    LiquidInColor := RGB(Round(TLiquidIn / 250 * 255), 0, 255 - Round(TLiquidIn / 250 * 255));
    LiquidOutColor := RGB(Round(TLiquidOut / 250 * 255), 0, 255 - Round(TLiquidOut / 250 * 255));
     SteamColor := RGB(Round(TSteam / 200 * 255), 75, 255 - Round(TSteam / 200 * 255));
//******************************************************************************

  PipeInVertical := TRectangle.Create(-0.9, 2.5, 0.2, 1.5, 0, 0, 0, 0, LiquidInColor, LiquidInColor, LiquidInColor, LiquidInColor, 0);
  PipeInHorizontal := TRectangle.Create(PipeInVertical.Centre.x - PipeInVertical.width/2 - 1.4, PipeInVertical.Centre.y + PipeInVertical.height/2 - 0.1, 2.8, 0.2, 0, 0, 0, 0, LiquidInColor, LiquidInColor, LiquidInColor, LiquidInColor, 0);
  PipeInPatch := TRectangle.Create(PipeInHorizontal.Centre.x + PipeInHorizontal.width/2, PipeInHorizontal.Centre.y, 0.1, PipeInHorizontal.height - 0.05, 0, 0, 0, 0, LiquidInColor, LiquidInColor, LiquidInColor, LiquidInColor, 0);
  ValveIn := Tvalve.Create(-2.8, PipeInHorizontal.Centre.y, 0.8, 0.5, 0, true, clblack);
  ValveInPatch := TRectangle.Create(ValveIn.Centre.X, ValveIn.Centre.Y, ValveIn.Width, PipeInHorizontal.height*1.5, 0, 0, 0, 0, clwhite, clwhite, clwhite, clwhite, 0);


  Jacket := TRectangle.Create(-0.4, -1, 4, 3, 1.0, 0.5, 0.5, 1.0, SteamColor, SteamColor, SteamColor, SteamColor, 0);
  Tank := TRectangle.Create(-0.4, 0, 3, 4, 0.5, 0.5, 0.5, 0.5, clwhite, clwhite, clwhite, clwhite, 0);
  Liquid := TRectangle.Create(-0.4, -1, 3, 2, 0.5, 0, 0, 0.5, LiquidOutColor, LiquidOutColor, LiquidOutColor, LiquidOutColor, 0);

  PipeSteamHorizontal := TRectangle.Create(Jacket.width/2 + 0.7, -0.5, 2.2, 0.2, 0, 0, 0, 0, SteamColor, SteamColor, SteamColor, SteamColor, 0);
  PipeSteamPatch := TRectangle.Create(PipeSteamHorizontal.Centre.x - PipeSteamHorizontal.width/2, PipeSteamHorizontal.Centre.y, 0.1, PipeSteamHorizontal.height - 0.05, 0, 0, 0, 0, SteamColor, SteamColor, SteamColor, SteamColor, 0);
  ValveSteam := Tvalve.Create(2.9, PipeSteamHorizontal.Centre.y, 0.8, 0.5, 0, true, clblack);
  ValveSteamPatch := TRectangle.Create(ValveSteam.Centre.X, ValveSteam.Centre.Y, ValveSteam.Width, PipeSteamHorizontal.height*1.5, 0, 0, 0, 0, clwhite, clwhite, clwhite, clwhite, 0);

   PipeOutVertical := TRectangle.Create(-0.4, -2.8, 0.2, 1.6, 0, 0, 0, 0, LiquidOutColor, LiquidOutColor, LiquidOutColor, LiquidOutColor, 0);
   PipeOutHorizontal := TRectangle.Create(PipeOutVertical.Centre.x + PipeOutVertical.width/2 + 2.1, PipeOutVertical.Centre.y - PipeOutVertical.height/2 + 0.1, 4.2, 0.2, 0, 0, 0, 0, LiquidOutColor, LiquidOutColor, LiquidOutColor, LiquidOutColor, 0);

   PipeOutPatchTop := TRectangle.Create(Tank.Centre.x, Tank.Centre.y - Tank.height/2, PipeOutVertical.width, 0.1, 0, 0, 0, 0, LiquidOutColor, LiquidOutColor, LiquidOutColor, LiquidOutColor, 0);
   PipeOutPatchBottom := TRectangle.Create(PipeOutHorizontal.Centre.x - PipeOutHorizontal.width/2, PipeOutHorizontal.Centre.y, 0.1, PipeOutHorizontal.height - 0.05, 0, 0, 0, 0, LiquidOutColor, LiquidOutColor, LiquidOutColor, LiquidOutColor, 0);;


  ValveOut := Tvalve.Create(2.9, PipeOutHorizontal.Centre.y, 0.8, 0.5, 0, true, clblack);

   ValveOutPatch := TRectangle.Create(ValveOut.Centre.X, ValveOut.Centre.Y, ValveOut.Width, PipeOutHorizontal.height*1.5, 0, 0, 0, 0, clwhite, clwhite, clwhite, clwhite, 0);

   PipeSteamTrapHorizontal := TRectangle.Create(-Jacket.width/2 - 0.9, -1, 1, 0.1, 0, 0, 0, 0, clBlack, clBlack, clBlack, clBlack, 0);
   PipeSteamTrapVertical := TRectangle.Create(PipeSteamTrapHorizontal.Centre.x - PipeSteamTrapHorizontal.width/2, PipeSteamTrapHorizontal.Centre.y + PipeSteamTrapHorizontal.height/2 - 0.5, 0.1, 1, 0, 0, 0, 0, clBlack, clBlack, clBlack, clBlack, 0);

   PipeSteamTrapWhite := TRectangle.Create(PipeSteamTrapVertical.Centre.x-0.1, PipeSteamTrapVertical.Centre.y - PipeSteamTrapVertical.height/2 -0.2, 0.6, 0.3, 0, 0, 0, 0, clwhite, clwhite, clwhite, clwhite, 45);
   PipeSteamTrapBlack := TRectangle.Create(PipeSteamTrapVertical.Centre.x+0.1, PipeSteamTrapVertical.Centre.y - PipeSteamTrapVertical.height/2 -0.4, 0.6, 0.3, 0, 0, 0, 0, clblack, clblack, clblack, clblack, 45);

   MixerRoller := TRectangle.Create(Tank.Centre.x, 1, 0.05, 4, 0, 0, 0, 0, clblack, clblack, clblack, clblack, 0);
   MixerFan := TRectangle.Create(Tank.Centre.x, -0.85, 2, 0.2, 0.1, 0.1, 0.1, 0.1, clblack, clblack, clblack, clblack, 0);

   //LiquidInToOutMorphing := TRectangle.Create(PipeSteamTrapVertical.Centre.x+0.1, PipeSteamTrapVertical.Centre.y - PipeSteamTrapVertical.height/2 -0.4, 0.6, 0.3, 0, 0, 0, 0, clblack, clblack, clblack, clblack, 45);
//******************************************************************************














end;

procedure THeatExchangerForm.FormDragDrop(Sender, Source: TObject; X,
  Y: Integer);
begin
 // HeatExchangerForm.Left := 0;
 // HeatExchangerForm.Top := 0;
end;

procedure THeatExchangerForm.FormKeyPress(Sender: TObject; var Key: Char);
var
  LLiquidFinal: double;
begin
//******************************************************************************
  if (key = #13) then
  begin
    AlphaLiquidIn := StrToFloat(lbledtValveIn.Text) / 10000;
    trckbrValveIn.Position := Round(100 - AlphaLiquidIn * 10000);
    lbledtValveIn.Font.Color := clsilver;
    lbledtValveIn.EditLabel.Font.Color := clsilver;

    AlphaLiquidOut := StrToFloat(lbledtValveOut.Text) / 10000;
    trckbrValveOut.Position := Round(100 - AlphaLiquidOut * 10000);
    lbledtValveOut.Font.Color := clsilver;
    lbledtValveOut.EditLabel.Font.Color := clsilver;

    AlphaSteamIn := StrToFloat(lbledtValveSteam.Text) / 100;
    trckbrValveSteam.Position := Round(100 - AlphaSteamIn * 100);
    lbledtValveSteam.Font.Color := clsilver;
    lbledtValveSteam.EditLabel.Font.Color := clsilver;

    TLiquidIn := StrToFloat(lbledtTLiquidIn.Text);
    trckbrTLiquidIn.Position := Round(TLiquidIn);
    lbledtTLiquidIn.Font.Color := clsilver;
    lbledtTLiquidIn.EditLabel.Font.Color := clsilver;

    PLiquidIn := StrToFloat(lbledtPLiquidIn.Text) * 1000;
    trckbrPLiquidIn.Position := Round(PLiquidIn / 1000);
    lbledtPLiquidIn.Font.Color := clsilver;
    lbledtPLiquidIn.EditLabel.Font.Color := clsilver;

    PSteamIn := StrToFloat(lbledtPSteam.Text) * 1000;
    trckbrPSteam.Position := Round(PSteamIn / 1000);
    lbledtPSteam.Font.Color := clsilver;
    lbledtPSteam.EditLabel.Font.Color := clsilver;

    if (regime = StaticRegime) then
    begin
      if (AlphaLiquidOut = 0) and (AlphaLiquidIn <> 0) then LLiquid := 1 else
      if (AlphaLiquidOut = 0) and (AlphaLiquidIn = 0) then LLiquid := 0 else LLiquid := sqr(AlphaLiquidIn / AlphaLiquidOut) * PLiquidIn / (RoLiquid * 10);
      if (LLiquid > 1) then LLiquid := 1;
    {  _ModelHEJCalc(AreaTank, AreaPipe, Beta, KHeatTransfer, RoLiquid, CpLiquid,
                  PSteamIn, TLiquidIn, PLiquidIn, AlphaLiquidIn, AlphaLiquidOut, AlphaSteamIn,
                  Step,
                  LLiquid, TSteam, TLiquidOut, FlowLiquidIn, FlowLiquidOut, FlowSteamIn, FlowCondensate);  }
    end;
     if (AlphaLiquidOut = 0) and (AlphaLiquidIn <> 0) then LLiquidFinal := 1 else
     if (AlphaLiquidOut = 0) and (AlphaLiquidIn = 0) then LLiquidFinal := 0 else LLiquidFinal := sqr(AlphaLiquidIn / AlphaLiquidOut) * PLiquidIn / (RoLiquid * 10);
     if (LLiquidFinal > 1) then LLiquidFinal := 1;
    pnlLLiquidFinal.Caption := 'Установившийся уровень  - ' + formatfloat('0', LLiquidFinal * 100) + '%';



  end;
//******************************************************************************

end;

procedure THeatExchangerForm.FormResize(Sender: TObject);
//var ps: Tpaintstruct;
begin
 // ShowWindow(Handle,SW_SHOW);
{ HeatExchangerForm.Width := HeatExchangerForm.Height;
 frmHeatExchanger.Height := Round(HeatExchangerForm.Height / 2);
 frmHeatExchanger.Width := frmHeatExchanger.Height; }
  HeatExchangerForm.scale(4);
end;


procedure THeatExchangerForm.FormShow(Sender: TObject);
begin
  frmHeatExchanger.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 2);
  frmHeatExchanger.Top := Round(GetSystemMetrics(SM_CYSCREEN) / 4 - GetSystemMetrics(SM_CYMENU));
  frmHeatExchanger.Width := frmHeatExchanger.Height;
  frmHeatExchanger.Left := Round(GetSystemMetrics(SM_CXSCREEN) / 2 - frmHeatExchanger.Width / 2);

 { frmHeatExchanger.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 2);
  frmHeatExchanger.Top := Round(GetSystemMetrics(SM_CYSCREEN) / 4 - GetSystemMetrics(SM_CYMENU));
  frmHeatExchanger.Width := frmHeatExchanger.Height;
  frmHeatExchanger.Left := Round(GetSystemMetrics(SM_CXSCREEN) * 0.7 - frmHeatExchanger.Width / 2);     }


  ControlsAttaching;






//******************************************************************************
  HeatExchangerForm.Scale(4);


end;






procedure THeatExchangerForm.frmHeatExchangerMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (ValveIn.Scale <> 1) then if (trckbrValveIn.Tag = 1) then trckbrValveIn.Tag := 0 else trckbrValveIn.Tag := 1;
  if (ValveOut.Scale <> 1) then if (trckbrValveOut.Tag = 1) then trckbrValveOut.Tag := 0 else trckbrValveOut.Tag := 1;
 if (ValveSteam.Scale <> 1) then if (trckbrValveSteam.Tag = 1) then trckbrValveSteam.Tag := 0 else trckbrValveSteam.Tag := 1;



end;

procedure THeatExchangerForm.frmHeatExchangerMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
  var VisibleIn: boolean;
      VisibleOut: boolean;
      VisibleSteam: boolean;
begin
  Valvein.MouseMoving(x, y, frmHeatExchanger);
  ValveInPatch.SetScale(ValveIn.scale);
  ValveSteam.MouseMoving(x, y, frmHeatExchanger);
  ValveSteamPatch.SetScale(ValveSteam.scale);
  ValveOut.MouseMoving(x, y, frmHeatExchanger);
  ValveOutPatch.SetScale(ValveOut.scale);

  ///////// для входной трубы /////////
//

    if (ValveIn.Scale <> 1) or (trckbrValveIn.Tag = 1) then VisibleIn:= true else VisibleIn:= false;

        trckbrValveIn.Visible := VisibleIn;
        lbledtValveIn.Visible := VisibleIn;
        pnlFlowIn.Visible := VisibleIn;
      //  pnlFlowOut.Visible := VisibleIn;
        lbledtTLiquidIn.Visible := VisibleIn;
        trckbrTLiquidIn.Visible := VisibleIn;
        lbledtPLiquidIn.Visible := VisibleIn;
        trckbrPLiquidIn.Visible := VisibleIn;
    if (ValveOut.Scale <> 1) or (trckbrValveOut.Tag = 1) then VisibleOut:= true else VisibleOut:= false;
           trckbrValveOut.Visible := VisibleOut;
        lbledtValveOut.Visible := VisibleOut;
         pnlFlowOut.Visible := VisibleOut;
       //  pnlFlowIn.Visible := pnlFlowOut.Visible;
         pnlTLiquidOut.Visible := VisibleOut;
    if (ValveSteam.Scale <> 1) or (trckbrValveSteam.Tag = 1) then VisibleSteam:= true else VisibleSteam:= false;
           trckbrValveSteam.Visible := VisibleSteam;
        lbledtValveSteam.Visible := VisibleSteam;
        pnlFlowSteam.Visible := VisibleSteam;
        pnlFlowCondensate.Visible := VisibleSteam;
        lbledtPSteam.Visible := VisibleSteam;
        trckbrPSteam.Visible := VisibleSteam;
 { If (pnlFlowIn.Visible) or (pnlFlowOut.Visible) then
  begin
    pnlFlowIn.Visible := true;
    pnlFlowOut.Visible := true;
  end;    }
  //If (Edit2.Visible) then Edit2.Visible := False else Edit2.Visible:=true;
  //HeatExchangerForm.Repaint;
end;






procedure THeatExchangerForm.lbledtPLiquidInChange(Sender: TObject);
begin
  lbledtPLiquidIn.Font.Color := clblack;
  lbledtPLiquidIn.EditLabel.Font.Color := clblack;
end;

procedure THeatExchangerForm.lbledtPSteamChange(Sender: TObject);
begin
  lbledtPSteam.Font.Color := clblack;
  lbledtPSteam.EditLabel.Font.Color := clblack;
end;

procedure THeatExchangerForm.lbledtTLiquidInChange(Sender: TObject);
begin
  lbledtTLiquidIn.Font.Color := clblack;
  lbledtTLiquidIn.EditLabel.Font.Color := clblack;
end;

procedure THeatExchangerForm.lbledtValveInChange(Sender: TObject);
begin
  lbledtValveIn.Font.Color := clblack;
  lbledtValveIn.EditLabel.Font.Color := clblack;
end;

procedure THeatExchangerForm.lbledtValveOutChange(Sender: TObject);
begin
  lbledtValveOut.Font.Color := clblack;
  lbledtValveOut.EditLabel.Font.Color := clblack;
end;

procedure THeatExchangerForm.lbledtValveSteamChange(Sender: TObject);
begin
  lbledtValveSteam.Font.Color := clblack;
  lbledtValveSteam.EditLabel.Font.Color := clblack;
end;

procedure THeatExchangerForm.Scale(m: double);
var
  W, H: integer;
begin
  W := frmHeatExchanger.Width;
  H := frmHeatExchanger.Height;
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  if  (W <= H) then glOrtho(-m,m, -m*H/W, m*H/W, -1,1)
               else glOrtho(-m*W/H, m*W/H, -m,m, -1,1);
 glViewport(0, 0, W, H);
end;




procedure THeatExchangerForm.spdbtnDynamicRegimeClick(Sender: TObject);
begin
  Regime := DynamicRegime;
  tmrModelCalculate.Enabled := true;
  pnlLLiquidCurrent.Visible := true;
  pnlTLiquidOut1.Visible := true;
end;

procedure THeatExchangerForm.spdbtnStaticRegimeClick(Sender: TObject);
var
  LLiquidFinal: double;
begin
  Regime := StaticRegime;
  tmrModelCalculate.Enabled := false;
   if (AlphaLiquidOut = 0) then LLiquid := 1 else LLiquid := sqr(AlphaLiquidIn / AlphaLiquidOut) * PLiquidIn / (RoLiquid * 10);
      if (LLiquid > 1) then LLiquid := 1;
      _ModelHEJCalc(AreaTank, AreaPipe, Beta, KHeatTransfer, RoLiquid, CpLiquid,
                  PSteamIn, TLiquidIn, PLiquidIn, AlphaLiquidIn, AlphaLiquidOut, AlphaSteamIn,
                  Step,
                  LLiquid, TSteam, TLiquidOut, FlowLiquidIn, FlowLiquidOut, FlowSteamIn, FlowCondensate);
   pnlLLiquidCurrent.Visible := false;
    if (AlphaLiquidOut = 0) and (AlphaLiquidIn <> 0) then LLiquidFinal := 1 else
     if (AlphaLiquidOut = 0) and (AlphaLiquidIn = 0) then LLiquidFinal := 0 else LLiquidFinal := sqr(AlphaLiquidIn / AlphaLiquidOut) * PLiquidIn / (RoLiquid * 10);
     if (LLiquidFinal > 1) then LLiquidFinal := 1;
     pnlLLiquidFinal.Caption := 'Установившийся уровень - ' + formatfloat('0', LLiquidFinal * 100) + '%';

     pnlTLiquidOut1.Visible := false;




end;

procedure THeatExchangerForm.Timer1Timer(Sender: TObject);
begin
 if (panel1.visible) then (panel1.visible := false) else (panel1.visible := true);

end;

procedure THeatExchangerForm.Timer2Timer(Sender: TObject);
begin

if (Panel1.Color=RGB(255, 0, 0)) then
begin
  if (LLiquid*100 >= 80) then if Image1.Visible then Image1.Visible := false else Image1.Visible := true else
  if (LLiquid*100 <= 20) then if Image2.Visible then Image2.Visible := false else Image2.Visible := true;
 { if (TLiquidOut >= 160) then if Image4.Visible then Image4.Visible := false else Image4.Visible := true else
  if (TLiquidOut <= 40) then if Image3.Visible then Image3.Visible := false else Image3.Visible := true;       }
  if Panel1.Visible then Panel1.Visible := false else Panel1.Visible := true;
end
//else Panel1.Visible := true;
end;

procedure THeatExchangerForm.PixelFormat;
var
  nPixelFormat: Integer;
  pfd: TPixelFormatDescriptor;
begin
  FillChar(pfd, Sizeof(pfd), 0);
  pfd.nSize := sizeof(pfd);
  pfd.nVersion := 1;
  pfd.dwFlags := PFD_DOUBLEBUFFER+PFD_DRAW_TO_WINDOW+PFD_SUPPORT_OPENGL+PFD_GENERIC_ACCELERATED;
  pfd.iPixelType := PFD_TYPE_RGBA;
  pfd.cColorBits := 24;
  pfd.cAlphaBits := 128;
  pfd.cAccumBits := 64;
  pfd.cDepthBits := 32;
  pfd.cStencilBits := 64;
  pfd.iLayerType := PFD_MAIN_PLANE;
  nPixelFormat := ChoosePixelFormat(DC, @pfd);
  if (nPixelFormat<>0) then SetPixelFormat(DC, nPixelFormat, @pfd);
end;



procedure THeatExchangerForm.tmrColorCalculateTimer(Sender: TObject);
begin
  LiquidInColor := RGB(Round(TLiquidIn / 250 * 255), 0, 255 - Round(TLiquidIn / 250 * 255));
  PipeInHorizontal.VertexColorParam.VLeftBottomColor :=LiquidInColor;
  PipeInHorizontal.VertexColorParam.VLeftTopColor := LiquidInColor;
  PipeInHorizontal.VertexColorParam.VRightTopColor := LiquidInColor;
  PipeInHorizontal.VertexColorParam.VRightBottomColor := LiquidInColor;
  PipeInVertical.VertexColorParam.VLeftBottomColor :=LiquidInColor;
  PipeInVertical.VertexColorParam.VLeftTopColor := LiquidInColor;
  PipeInVertical.VertexColorParam.VRightTopColor := LiquidInColor;
  PipeInVertical.VertexColorParam.VRightBottomColor := LiquidInColor;
  PipeInPatch.VertexColorParam.VLeftBottomColor :=LiquidInColor;
  PipeInPatch.VertexColorParam.VLeftTopColor := LiquidInColor;
  PipeInPatch.VertexColorParam.VRightTopColor := LiquidInColor;
  PipeInPatch.VertexColorParam.VRightBottomColor := LiquidInColor;


  LiquidOutColor := RGB(Round(TLiquidOut / 250 * 255), 0, 255 - Round(TLiquidOut / 250 * 255));
  Liquid.VertexColorParam.VLeftBottomColor :=LiquidOutColor;
  Liquid.VertexColorParam.VLeftTopColor := LiquidOutColor;
  Liquid.VertexColorParam.VRightTopColor := LiquidOutColor;
  Liquid.VertexColorParam.VRightBottomColor := LiquidOutColor;
  PipeOutVertical.VertexColorParam.VLeftBottomColor := LiquidOutColor;
  PipeOutVertical.VertexColorParam.VLeftTopColor := LiquidOutColor;
  PipeOutVertical.VertexColorParam.VRightTopColor := LiquidOutColor;
  PipeOutVertical.VertexColorParam.VRightBottomColor := LiquidOutColor;
  PipeOutHorizontal.VertexColorParam.VLeftBottomColor := LiquidOutColor;
  PipeOutHorizontal.VertexColorParam.VLeftTopColor := LiquidOutColor;
  PipeOutHorizontal.VertexColorParam.VRightTopColor := LiquidOutColor;
  PipeOutHorizontal.VertexColorParam.VRightBottomColor := LiquidOutColor;
  PipeOutPatchTop.VertexColorParam.VLeftBottomColor := LiquidOutColor;
  PipeOutPatchTop.VertexColorParam.VLeftTopColor := LiquidOutColor;
  PipeOutPatchTop.VertexColorParam.VRightTopColor := LiquidOutColor;
  PipeOutPatchTop.VertexColorParam.VRightBottomColor := LiquidOutColor;
  PipeOutPatchBottom.VertexColorParam.VLeftBottomColor := LiquidOutColor;
  PipeOutPatchBottom.VertexColorParam.VLeftTopColor := LiquidOutColor;
  PipeOutPatchBottom.VertexColorParam.VRightTopColor := LiquidOutColor;
  PipeOutPatchBottom.VertexColorParam.VRightBottomColor := LiquidOutColor;


  SteamColor := RGB(Round(TSteam / 200 * 255), 75, 255 - Round(TSteam / 200 * 255));
  Jacket.VertexColorParam.VLeftBottomColor := SteamColor;
  Jacket.VertexColorParam.VLeftTopColor := SteamColor;
  Jacket.VertexColorParam.VRightTopColor := SteamColor;
  Jacket.VertexColorParam.VRightBottomColor := SteamColor;
  PipeSteamHorizontal.VertexColorParam.VLeftBottomColor := SteamColor;
  PipeSteamHorizontal.VertexColorParam.VLeftTopColor := SteamColor;
  PipeSteamHorizontal.VertexColorParam.VRightTopColor := SteamColor;
  PipeSteamHorizontal.VertexColorParam.VRightBottomColor := SteamColor;
  PipeSteamPatch.VertexColorParam.VLeftBottomColor := SteamColor;
  PipeSteamPatch.VertexColorParam.VLeftTopColor := SteamColor;
  PipeSteamPatch.VertexColorParam.VRightTopColor := SteamColor;
  PipeSteamPatch.VertexColorParam.VRightBottomColor := SteamColor;

  pnlFlowIn.Caption := 'Расход - ' + formatfloat('0.00', FlowLiquidIn) + ' м^3/с';
 pnlFlowOut.Caption := 'Расход - ' + formatfloat('0.00', FlowLiquidOut) + ' м^3/с';
 pnlFlowSteam.Caption := 'Расход - ' + formatfloat('0.00', FlowSteamIn) + ' м^3/с';
 pnlFlowCondensate.Caption := 'Расход - ' + formatfloat('0.00', FlowCondensate) + ' м^3/с';
 pnlTLiquidOut.Caption := formatfloat('0.00', TLiquidOut) + ' ' + #0176 + 'C';
 pnlLLiquidCurrent.Caption := 'Текущий уровень - ' + formatfloat('0', LLiquid * 100) + '%';
 pnlTLiquidOut1.Caption := 'Температура на выходе - ' + formatfloat('0', TLiquidOut) + ' ' + #0176 + 'C';



  Liquid.height := (Tank.height - Tank.RoundParam.LeftBottomRad - Tank.RoundParam.LeftTopRad) * LLiquid + Tank.RoundParam.LeftBottomRad;
  Liquid.Centre.y := Tank.Centre.y - Tank.height / 2 + Liquid.height / 2;

   if (Regime = DynamicRegime) then
  begin
  HeatExchangerGraphicsForm.GUroven.Series[0].AddXY((tg+0.05),LLiquid*100);
  HeatExchangerGraphicsForm.GUroven.Series[1].AddXY((tg+0.05),alphaLiquidIn*10000);
  HeatExchangerGraphicsForm.GUroven.Series[2].AddXY((tg+0.05),alphaLiquidOut*10000);
  HeatExchangerGraphicsForm.GTemper.Series[0].AddXY((tg+0.05),TLiquidOut);
  HeatExchangerGraphicsForm.GTemper.Series[1].AddXY((tg+0.05),TLiquidIn);
  HeatExchangerGraphicsForm.GTemper.Series[2].AddXY((tg+0.05),TSteam);
  end;

   If (tg > ending) then
  begin
    HeatExchangerGraphicsForm.GUroven.BottomAxis.SetMinMax(0,round(tg*3/2));
    HeatExchangerGraphicsForm.GTemper.BottomAxis.SetMinMax(0,round(tg*3/2));
    ending := round(tg*3/2);
  end;

  if (Regime = DynamicRegime) then
begin
tg:=tg+0.1;
tmrColorCalculate.Tag:=tmrColorCalculate.Tag+1;
end;

if (Panel1.Color=RGB(255, 255, 0)) then
begin
  if (LLiquid*100 >= 70) then if Image1.Visible then Image1.Visible := false else Image1.Visible := true else
  if (LLiquid*100 <= 30) then if Image2.Visible then Image2.Visible := false else Image2.Visible := true;
  if Panel1.Visible then Panel1.Visible := false else Panel1.Visible := true;
end;

{if (Panel2.Color=RGB(255, 255, 0)) then
begin
  if (TLiquidOut >= 140) then
  begin
    if Image4.Visible then Image4.Visible := false else Image4.Visible := true
  end
  else
  if (TLiquidOut <= 60) then
  begin
    if Image3.Visible then Image3.Visible := false else Image3.Visible := true;
  end;
  if Panel2.Visible then Panel1.Visible := false else Panel1.Visible := true;
end;      }


end;


procedure THeatExchangerForm.tmrModelCalculateTimer(Sender: TObject);
begin


_ModelHEJCalc(AreaTank, AreaPipe, Beta, KHeatTransfer, RoLiquid, CpLiquid,
                  PSteamIn, TLiquidIn, PLiquidIn, AlphaLiquidIn, AlphaLiquidOut, AlphaSteamIn,
                  Step,
                  LLiquid, TSteam, TLiquidOut, FlowLiquidIn, FlowLiquidOut, FlowSteamIn, FlowCondensate);




if (LLiquid*100 < 70) and (LLiquid*100 > 30) then
begin
HeatExchangerForm.Panel1.Color := RGB(0, 255, 0);
HeatExchangerForm.Panel1.Caption := 'Уровень - все хорошо';
Image1.Visible := false;
lbledtValveIn.Color := clwhite;
image2.visible := false;
Panel1.Visible := true;
end
else
if (LLiquid*100 >= 70) and (LLiquid*100 < 80) then
begin
HeatExchangerForm.Panel1.Color := RGB(255, 255, 0);
HeatExchangerForm.Panel1.Caption := 'Внимание, опасность перелива !';
//Image1.Visible := true;
lbledtValveIn.Color := clwhite;
image2.visible := false;
end
else
if (LLiquid*100 >= 80) then
begin
HeatExchangerForm.Panel1.Color := RGB(255, 0, 0);
HeatExchangerForm.Panel1.Caption := 'Перелив !!!';
//Image1.Visible := true;
lbledtValveIn.Color := clred;
image2.visible := false;
end
else
if (LLiquid*100 > 20) and (LLiquid*100 <= 30) then
begin
HeatExchangerForm.Panel1.Color := RGB(255, 255, 0);
HeatExchangerForm.Panel1.Caption := 'Внимание, опасность опустошения !';
Image1.Visible := false;
lbledtValveIn.Color := clwhite;
//image2.visible := true;
end
else
if (LLiquid*100 <= 20) then
begin
HeatExchangerForm.Panel1.Color := RGB(255, 0, 0);
HeatExchangerForm.Panel1.Caption := 'Емкость опустела !!!';
//Image2.Visible := true;
lbledtValveIn.Color := clred;
image1.visible := false;
end;


//////////////////////////////////////////////////////////////////////////////////////////
///
{if (TLiquidOut < 140) and (TLiquidOut > 60) then
begin
HeatExchangerForm.Panel2.Color := RGB(0, 255, 0);
HeatExchangerForm.Panel2.Caption := 'Температура - все хорошо';
Image3.Visible := false;
lbledtValveIn.Color := clwhite;
image4.visible := false;
end
else
if (TLiquidOut >= 140) and (TLiquidOut < 160) then
begin
HeatExchangerForm.Panel2.Color := RGB(255, 255, 0);
HeatExchangerForm.Panel2.Caption := 'Внимание, опасность перегрева !';
//Image3.Visible := false;
lbledtValveIn.Color := clwhite;
//image4.visible := false;
end
else
if (TLiquidOut >= 160) then
begin
HeatExchangerForm.Panel2.Color := RGB(255, 0, 0);
HeatExchangerForm.Panel2.Caption := 'Перегрев !!!';
//Image3.Visible := true;
lbledtValveIn.Color := clred;
//image4.visible := false;
end
else
if (TLiquidOut*100 <= 60) and (LLiquid*100 <= 60) then
begin
HeatExchangerForm.Panel2.Color := RGB(255, 255, 0);
HeatExchangerForm.Panel2.Caption := 'Внимание, падение температуры !';
Image3.Visible := false;
lbledtValveIn.Color := clred;
//image4.visible := false;
end
else
if (LLiquid*100 <= 40) then
begin
HeatExchangerForm.Panel1.Color := RGB(255, 0, 0);
HeatExchangerForm.Panel1.Caption := 'Температура упала !!!';
//Image3.Visible := true;
lbledtValveIn.Color := clred;
//image4.visible := false;
end;       }


//trckbrValveIn



end;

procedure THeatExchangerForm.tmrOpenGLPaintTimer(Sender: TObject);
var ps: TPaintStruct;


begin



  BeginPaint(frmHeatExchanger.Handle,ps);
  glClear(GL_DEPTH_BUFFER_BIT or GL_COLOR_BUFFER_BIT);

//******************************************************************************
  PipeSteamHorizontal.PaintRectangle;
  PipeSteamHorizontal.PaintContour;

  Jacket.PaintRectangle;
  Jacket.PaintContour;

  Tank.PaintRectangle;


  PipeInHorizontal.PaintRectangle;
  PipeInHorizontal.PaintContour;




  Liquid.PaintRectangle;
  Liquid.PaintContour;


  ValveInPatch.PaintRectangle;

  PipeSteamPatch.PaintRectangle;
  ValveSteamPatch.PaintRectangle;

  PipeOutVertical.PaintRectangle;
  PipeOutVertical.PaintContour;

  PipeOutHorizontal.PaintRectangle;
  PipeOutHorizontal.PaintContour;


  PipeOutPatchBottom.PaintRectangle;

  ValveOutPatch.PaintRectangle;

  PipeSteamTrapHorizontal.PaintRectangle;
  PipeSteamTrapVertical.PaintRectangle;

  PipeSteamTrapWhite.PaintRectangle;
  PipeSteamTrapWhite.PaintContour;

  PipeSteamTrapBlack.PaintRectangle;
  PipeSteamTrapBlack.PaintContour;




   if (FlowLiquidIn > 0) then LiquidInToOutMorphing(PipeInVertical.Centre.x, Liquid.Centre.y + liquid.height / 2 - 0.02,LiquidInColor,LiquidOutColor);



     Tank.PaintContour;
    PipeOutPatchTop.PaintRectangle;

    PipeInVertical.PaintRectangle;
      PipeInVertical.PaintContour;
      PipeInPatch.PaintRectangle;

      MixerRoller.PaintRectangle;

       If (MixerFan.width <= 0) then i := 1 else
   If (MixerFan.width >= 2) then i := -1;
   MixerFan.width := MixerFan.width + i * 0.1;

      MixerFan.PaintRectangle;
//******************************************************************************
  ValveIn.Paint;
  ValveOut.Paint;
  ValveSteam.Paint;
//******************************************************************************
  EndPaint(frmHeatExchanger.Handle,ps);
  swapBuffers(dc);


 // tmrColorCalculate.Interval := 1000;


end;

procedure THeatExchangerForm.TranslateGLToPixels;
begin
  if (ObjectOwner.Width >= ObjectOwner.Height) then
  begin
   AttachObject.Top := Round(ObjectOwner.Top  + (ObjectOwner.Height / 2) - (YGL * (ObjectOwner.Height / (scale * 2))));
   AttachObject.Left := Round(ObjectOwner.Left  + (ObjectOwner.Width / 2) + (XGL * (ObjectOwner.Height / (scale * 2))));
  end else
  begin
    AttachObject.Top := Round(ObjectOwner.Top  + (ObjectOwner.Height / 2) - (YGL * (ObjectOwner.Width / (scale * 2))));
    AttachObject.Left := Round(ObjectOwner.Left  + (ObjectOwner.Width / 2) + (XGL * (ObjectOwner.Width / (scale * 2))));
  end;
end;




procedure THeatExchangerForm.trckbrPLiquidInChange(Sender: TObject);
begin
  lbledtPLiquidIn.Text := FloatToStr(trckbrPLiquidIn.Position);
  lbledtPLiquidIn.Font.Color := clblack;
  lbledtPLiquidIn.EditLabel.Font.Color := clblack;
end;

procedure THeatExchangerForm.trckbrPSteamChange(Sender: TObject);
begin
  lbledtPSteam.Text := FloatToStr(trckbrPSteam.Position);
  lbledtPSteam.Font.Color := clblack;
  lbledtPSteam.EditLabel.Font.Color := clblack;
end;

procedure THeatExchangerForm.trckbrTLiquidInChange(Sender: TObject);
begin
  lbledtTLiquidIn.Text := FloatToStr(trckbrTLiquidIn.Position);
  lbledtTLiquidIn.Font.Color := clblack;
  lbledtTLiquidIn.EditLabel.Font.Color := clblack;
end;


procedure THeatExchangerForm.trckbrValveInChange(Sender: TObject);
begin
  lbledtValveIn.Text := IntToStr(100 - trckbrValveIn.Position);
  lbledtValveIn.Font.Color := clblack;
  lbledtValveIn.EditLabel.Font.Color := clblack;
  HintEnter;
end;



procedure THeatExchangerForm.trckbrValveOutChange(Sender: TObject);
begin
  lbledtValveOut.Text := IntToStr(100 - trckbrValveOut.Position);
  lbledtValveOut.Font.Color := clblack;
  lbledtValveOut.EditLabel.Font.Color := clblack;
end;

procedure THeatExchangerForm.trckbrValveSteamChange(Sender: TObject);
begin
  lbledtValveSteam.Text := IntToStr(100 - trckbrValveSteam.Position);
  lbledtValveSteam.Font.Color := clblack;
  lbledtValveSteam.EditLabel.Font.Color := clblack;
end;


procedure THeatExchangerForm.btnCloseClick(Sender: TObject);
begin
   HeatExchangerForm.ModalResult := 1;
   HeatExchangerForm.Close;
end;

procedure THeatExchangerForm.btnShowGraphsClick(Sender: TObject);
begin

  HeatExchangerGraphicsForm.Show;
 // HeatExchangerGraphicsForm.Visible := true;
     frmHeatExchanger.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 2);
  frmHeatExchanger.Top := Round(GetSystemMetrics(SM_CYSCREEN) / 4 - GetSystemMetrics(SM_CYMENU));
  frmHeatExchanger.Width := frmHeatExchanger.Height;
  frmHeatExchanger.Left := Round(GetSystemMetrics(SM_CXSCREEN) * 0.7 - frmHeatExchanger.Width / 2);

  ControlsAttaching;

   HeatExchangerForm.Repaint;
  //  Form1.Show;
end;




procedure THeatExchangerForm.LiquidInToOutMorphing;
var
  i, j, step : real;
  A, Radius: double;
begin
    A := PLiquidIn / 1000 / 2 + 1;
    if ((AlphaLiquidIn * 10000) < 10) then glpointSize(1.0) else glpointSize(2.0);
    glbegin(GL_POINTS);
      i := PipeInVertical.Centre.y - PipeInVertical.height / 2;
      if (dop <> 1) then i := i - 0.05;
      while (i > Liquid.Centre.y + Liquid.height / 2) do
      begin
        j := i - 0.025;
        glColor3F(GetRValue(CentreColor)/255, GetGValue(CentreColor)/255, GetBValue(CentreColor)/255);
        if ((AlphaLiquidIn * 10000) > 0) then glVertex3F(centreX, i, 0);
        if ((AlphaLiquidIn * 10000) > 20) then
        begin
          glVertex3F(CentreX + (PipeInVertical.width / 6 + (PipeInVertical.Centre.y - PipeInVertical.height / 2 - i) * tan(A * 3.14 / 180)), j, 0);
          glVertex3F(CentreX - (PipeInVertical.width / 6 + (PipeInVertical.Centre.y - PipeInVertical.height / 2 - i) * tan(A * 3.14 / 180)), j, 0);
        end;
        if ((AlphaLiquidIn * 10000) > 40) then
        begin
          glVertex3F(centreX + (PipeInVertical.width / 6 * 2 + (PipeInVertical.Centre.y - PipeInVertical.height / 2 - i) * tan(2*A * 3.14 / 180)), i, 0);
          glVertex3F(centreX - (PipeInVertical.width / 6 * 2 + (PipeInVertical.Centre.y - PipeInVertical.height / 2 - i) * tan(2*A * 3.14 / 180)), i, 0);
        end;
        if ((AlphaLiquidIn * 10000) > 70) then
        begin
          glVertex3F(centreX + (PipeInVertical.width / 6 * 3 + (PipeInVertical.Centre.y - PipeInVertical.height / 2 - i) * tan(3*A * 3.14 / 180)), j, 0);
          glVertex3F(centreX - (PipeInVertical.width / 6 * 3 + (PipeInVertical.Centre.y - PipeInVertical.height / 2 - i) * tan(3*A * 3.14 / 180)), j, 0);
        end;
        i:= i - 0.1;
      end;
    glend;
    if (dop = 1) then dop := 2 else dop := 1;
    if ((AlphaLiquidIn * 10000) > 70) then Radius := PipeInVertical.width * 2 + (PipeInVertical.Centre.y - PipeInVertical.height / 2  - Liquid.Centre.y - Liquid.height / 2) * tan(3*A * 3.14 / 180) else
    if ((AlphaLiquidIn * 10000) > 40) then Radius := PipeInVertical.width * 2 + (PipeInVertical.Centre.y - PipeInVertical.height / 2  - Liquid.Centre.y - Liquid.height / 2) * tan(2*A * 3.14 / 180) else
    if ((AlphaLiquidIn * 10000) > 20) then Radius := PipeInVertical.width * 2 + (PipeInVertical.Centre.y - PipeInVertical.height / 2  - Liquid.Centre.y - Liquid.height / 2) * tan(A * 3.14 / 180) else
    Radius := 0.1;
     if (Radius > Liquid.height) then Radius := Liquid.height - 0.05;
    if (Radius > abs(Liquid.Centre.x) + Liquid.width / 2 - abs(centreX)) then Radius := abs(Liquid.Centre.x) + Liquid.width / 2 - abs(centreX) - 0.05;


    step := 0.1;
    glbegin(GL_POLYGON);
      glColor3F(GetRValue(CentreColor)/255, GetGValue(CentreColor)/255, GetBValue(CentreColor)/255);
      glVertex2F(centreX, CentreY);
      glColor3F(GetRValue(ContourColor)/255, GetGValue(ContourColor)/255, GetBValue(ContourColor)/255);
      i := 0;
      while (i <= Pi) do
      begin
        glVertex2F(CentreX + Radius * cos(i), CentreY - Radius * sin(i));
        i := i + step;
      end;
      glVertex2F(centreX - Radius, CentreY);
    glend;
 end;








procedure THeatExchangerForm.N2Click(Sender: TObject);
begin
  frmHeatExchanger.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 2);
  frmHeatExchanger.Top := Round(GetSystemMetrics(SM_CYSCREEN) / 4 - GetSystemMetrics(SM_CYMENU));
  frmHeatExchanger.Width := frmHeatExchanger.Height;
  frmHeatExchanger.Left := Round(GetSystemMetrics(SM_CXSCREEN) / 2 - frmHeatExchanger.Width / 2);


  ControlsAttaching;
end;

function WindowProc (MainWindow: HWnd; Message: UINT; WParam, LParam: Longint):Longint; stdcall;
begin
   result:=0;
  case message of
  WM_ERASEBKGND:
  begin
    result:= 1;
  end;
  end;
end;





procedure THeatExchangerForm.ControlsAttaching;
begin
//******************************************************************************



  trckbrValveIn.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 10);
  if (trckbrValveIn.Height/3 >= 40) then trckbrValveIn.Width := Round(trckbrValveIn.Height/3) else trckbrValveIn.Width := 40;
  TranslateGLToPixels(trckbrValveIn, frmHeatExchanger, ValveIn.Centre.X, ValveIn.Centre.Y + 2.2, 4);
  trckbrValveIn.Left := Round(trckbrValveIn.Left - trckbrValveIn.Width / 2);
  trckbrValveIn.Position := Round(100 - AlphaLiquidIn * 10000);

  lbledtValveIn.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 30);
  lbledtValveIn.Width := Round(lbledtValveIn.Height / 0.8);
  TranslateGLToPixels(lbledtValveIn, frmHeatExchanger, ValveIn.Centre.X + 0.4, ValveIn.Centre.Y + 1.6, 4);
  lbledtValveIn.Left := lbledtValveIn.Left + 1;


  lbledtValveIn.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 60);
  lbledtValveIn.EditLabel.Font.Size := lbledtValveIn.Font.Size;
  lbledtValveIn.Font.Color := clsilver;
  lbledtValveIn.EditLabel.Font.Color := clsilver;
  lbledtValveIn.Text := IntToStr(100 - trckbrValveIn.Position);

  ////////////////////////


  pnlFlowIn.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 40);
  pnlFlowIn.Width := Round(pnlFlowIn.Height * 7);
  TranslateGLToPixels(pnlFlowIn, frmHeatExchanger, PipeInHorizontal.Centre.X, ValveIn.Centre.Y - ValveIn.Height / 2, 4);
  pnlFlowIn.Left := Round(pnlFlowIn.Left - pnlFlowIn.Width / 2 - 5);
  pnlFlowIn.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 80);





  pnlFlowSteam.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 40);
  pnlFlowSteam.Width := Round(pnlFlowSteam.Height * 7);
  TranslateGLToPixels(pnlFlowSteam, frmHeatExchanger, PipeSteamHorizontal.Centre.X - PipeSteamHorizontal.width / 2, ValveSteam.Centre.Y - ValveSteam.Height / 2, 4);
  pnlFlowSteam.Left := Round(pnlFlowSteam.Left + 1);
  pnlFlowSteam.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 80);


   pnlFlowCondensate.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 40);
  pnlFlowCondensate.Width := Round(pnlFlowCondensate.Height * 7);
  TranslateGLToPixels(pnlFlowCondensate, frmHeatExchanger, PipeSteamTrapVertical.Centre.X, PipeSteamTrapVertical.Centre.Y - PipeSteamTrapVertical.Height / 2 - 0.8, 4);
  pnlFlowCondensate.Left := Round(pnlFlowCondensate.Left - pnlFlowCondensate.Width / 2);
  pnlFlowCondensate.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 80);



   pnlFlowOut.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 40);
  pnlFlowOut.Width := Round(pnlFlowOut.Height * 7);
  TranslateGLToPixels(pnlFlowOut, frmHeatExchanger, PipeOutHorizontal.Centre.X + PipeOutHorizontal.width / 2, ValveOut.Centre.Y - ValveOut.Height / 2, 4);
 //pnlFlowOut.Left := Round(pnlFlowOut.Left - pnlFlowOut.Width);
   pnlFlowOut.Left := Round(pnlFlowSteam.Left + pnlFlowSteam.Width - pnlFlowOut.Width);
  pnlFlowOut.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 80);



////////////////////////////////////
  trckbrValveOut.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 10);
  if (trckbrValveOut.Height/3 >= 40) then trckbrValveOut.Width := Round(trckbrValveOut.Height/3) else trckbrValveOut.Width := 40;
  TranslateGLToPixels(trckbrValveOut, frmHeatExchanger, ValveOut.Centre.X, ValveOut.Centre.Y + 2.2, 4);
  trckbrValveOut.Left := Round(trckbrValveOut.Left - trckbrValveOut.Width / 2);
  trckbrValveOut.Position := Round(100 - AlphaLiquidOut * 10000);

  lbledtValveOut.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 30);
  lbledtValveOut.Width := Round(lbledtValveOut.Height / 0.8);
  TranslateGLToPixels(lbledtValveOut, frmHeatExchanger, ValveOut.Centre.X + 0.4, ValveOut.Centre.Y + 1.6, 4);
  lbledtValveOut.Left := lbledtValveOut.Left + 1;
  lbledtValveOut.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 60);
  lbledtValveOut.EditLabel.Font.Size := lbledtValveOut.Font.Size;
  lbledtValveOut.Font.Color := clsilver;
  lbledtValveOut.EditLabel.Font.Color := clsilver;
  lbledtValveOut.Text := IntToStr(100 - trckbrValveOut.Position);


  //////
  trckbrValveSteam.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 10);
   if (trckbrValveSteam.Height/3 >= 40) then trckbrValveSteam.Width := Round(trckbrValveSteam.Height/3) else trckbrValveSteam.Width := 40;
  TranslateGLToPixels(trckbrValveSteam, frmHeatExchanger, ValveSteam.Centre.X, ValveSteam.Centre.Y + 2.2, 4);
  trckbrValveSteam.Left := Round(trckbrValveSteam.Left - trckbrValveSteam.Width / 2);
  trckbrValveSteam.Position := Round(100 - AlphaSteamIn * 100);

  lbledtValveSteam.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 30);
  lbledtValveSteam.Width := Round(lbledtValveSteam.Height / 0.8);
  TranslateGLToPixels(lbledtValveSteam, frmHeatExchanger, ValveSteam.Centre.X + 0.4, ValveSteam.Centre.Y + 1.6, 4);
 lbledtValveSteam.Left := lbledtValveSteam.Left + 1;


  lbledtValveSteam.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 60);
  lbledtValveSteam.EditLabel.Font.Size := lbledtValveSteam.Font.Size;
  lbledtValveSteam.Font.Color := clsilver;
  lbledtValveSteam.EditLabel.Font.Color := clsilver;
  lbledtValveSteam.Text := IntToStr(100 - trckbrValveSteam.Position);








      trckbrTLiquidIn.Height := trckbrValveIn.Width;
  /////
  lbledtTLiquidIn.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 30);
  lbledtTLiquidIn.Width := Round(lbledtTLiquidIn.Height * 1.5);
  //lbledtTLiquidIn.EditLabel.Width := lbledtTLiquidIn.Width;
  TranslateGLToPixels(lbledtTLiquidIn, frmHeatExchanger, PipeInHorizontal.Centre.X, PipeInHorizontal.Centre.Y + PipeInHorizontal.height / 2, 4);
  lbledtTLiquidIn.Left := frmHeatExchanger.Left - lbledtTLiquidIn.Width - lbledtTLiquidIn.EditLabel.Width ;;
  lbledtTLiquidIn.Top := lbledtTLiquidIn.Top - trckbrTLiquidIn.Height - 1 - lbledtTLiquidIn.Height;
  lbledtTLiquidIn.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 60);
  lbledtTLiquidIn.EditLabel.Font.Size := lbledtTLiquidIn.Font.Size;
  lbledtTLiquidIn.Font.Color := clsilver;
  lbledtTLiquidIn.EditLabel.Font.Color := clsilver;
  lbledtTLiquidIn.Text := IntToStr(trckbrTLiquidIn.Position);

   ///

   trckbrTLiquidIn.Width := lbledtTLiquidIn.Width + lbledtTLiquidIn.EditLabel.Width;
  TranslateGLToPixels(trckbrTLiquidIn, frmHeatExchanger, PipeInHorizontal.Centre.X, PipeInHorizontal.Centre.Y + PipeInHorizontal.height / 2, 4);

 trckbrTLiquidIn.Left := lbledtTLiquidIn.Left;
  trckbrTLiquidIn.Top := lbledtTLiquidIn.Top + lbledtTLiquidIn.Height + 1;
  trckbrTLiquidIn.Position := Round(TLiquidIn);

      //////
  lbledtPLiquidIn.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 30);
  lbledtPLiquidIn.Width := Round(lbledtPLiquidIn.Height);
 // lbledtPLiquidIn.EditLabel.Width := lbledtPLiquidIn.Width;
  TranslateGLToPixels(lbledtPLiquidIn, frmHeatExchanger, PipeInHorizontal.Centre.X, PipeInHorizontal.Centre.Y - PipeInHorizontal.height / 2, 4);
  lbledtPLiquidIn.Left := lbledtTLiquidIn.Left;
 // lbledtPLiquidIn.Top := lbledtPLiquidIn.Top + 1;
  lbledtPLiquidIn.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 60);
  lbledtPLiquidIn.EditLabel.Font.Size := lbledtPLiquidIn.Font.Size;
  lbledtPLiquidIn.Font.Color := clsilver;
  lbledtPLiquidIn.EditLabel.Font.Color := clsilver;
  lbledtPLiquidIn.Text := FloatToStr(PLiquidIn / 1000);
  ////
   trckbrPLiquidIn.Height := trckbrValveIn.Width;
   trckbrPLiquidIn.Width := lbledtPLiquidIn.Width + lbledtPLiquidIn.EditLabel.Width;
  TranslateGLToPixels(trckbrPLiquidIn, frmHeatExchanger, PipeInHorizontal.Centre.X, PipeInHorizontal.Centre.Y, 4);

 trckbrPLiquidIn.Left := lbledtPLiquidIn.Left;
  trckbrPLiquidIn.Top := lbledtPLiquidIn.Top + lbledtPLiquidIn.Height + 1;
  trckbrPLiquidIn.Position := Round(PLiquidIn / 1000);


   /////

  lbledtPSteam.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 30);
  lbledtPSteam.Width := Round(lbledtPSteam.Height * 2);
  TranslateGLToPixels(lbledtPSteam, frmHeatExchanger, PipeSteamHorizontal.Centre.X, PipeSteamHorizontal.Centre.Y, 4);

  lbledtPSteam.Left := pnlFlowSteam.Left + pnlFlowSteam.Width;

  lbledtPSteam.Top := lbledtPSteam.Top - lbledtPSteam.Height;
  lbledtPSteam.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 60);
  lbledtPSteam.EditLabel.Font.Size := lbledtPSteam.Font.Size;
  lbledtPSteam.Font.Color := clsilver;
  lbledtPSteam.EditLabel.Font.Color := clsilver;
  lbledtPSteam.Text := FloatToStr(PSteamIn / 1000);
  ////
   trckbrPSteam.Height := trckbrValveSteam.Width;
   trckbrPSteam.Width := lbledtPSteam.Width + lbledtPSteam.EditLabel.Width;
  TranslateGLToPixels(trckbrPSteam, frmHeatExchanger, PipeInHorizontal.Centre.X, PipeInHorizontal.Centre.Y, 4);

 trckbrPSteam.Left := lbledtPSteam.Left;
  trckbrPSteam.Top := lbledtPSteam.Top + lbledtPSteam.Height + 1;
  trckbrPSteam.Position := Round(PSteamIn);


   ////////////
  pnlTLiquidOut.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 40);
  pnlTLiquidOut.Width := Round(pnlFlowSteam.Height * 4);
  TranslateGLToPixels(pnlTLiquidOut, frmHeatExchanger, PipeOutHorizontal.Centre.X + PipeOutHorizontal.width / 2, ValveOut.Centre.Y, 4);
  pnlTLiquidOut.Left := lbledtPSteam.Left;
  pnlTLiquidOut.Top := Round(pnlTLiquidOut.Top - pnlTLiquidOut.Height / 2);
  pnlTLiquidOut.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 60);



  //////

  gbChooseRegime.Top := 10;
  gbChooseRegime.Width := Round(GetSystemMetrics(SM_CYSCREEN) * 0.2);
  gbChooseRegime.Left := GetSystemMetrics(SM_CXSCREEN) - 10 - gbChooseRegime.Width;

  spdbtnStaticRegime.Top := Round(GetSystemMetrics(SM_CYSCREEN) / 30);
  spdbtnStaticRegime.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 40);
  spdbtnStaticRegime.Width := spdbtnStaticRegime.Height * 7;
  spdbtnStaticRegime.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 80);

  spdbtnDynamicRegime.Top := spdbtnStaticRegime.Top + spdbtnStaticRegime.Height + 2;
  spdbtnDynamicRegime.Height := spdbtnStaticRegime.Height;
  spdbtnDynamicRegime.Width := spdbtnStaticRegime.Width;
  spdbtnDynamicRegime.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 80);

  gbChooseRegime.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 10);
  gbChooseRegime.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 60);

    Panel1.Left := 0{gbChooseRegime.Left + gbChooseRegime.Width - panel1.Width};
    Panel1.Top := 0{gbChooseRegime.Top + gbChooseRegime.Height + 30};

    //Panel2.Left := Panel1.Left;
    //Panel2.Top := Panel1.Top + Panel1.Height;

 // mmHEJ





  ///
  pnlLLiquidFinal.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 40);
  pnlLLiquidFinal.Width := Round(pnlFlowSteam.Height * 14);
  pnlLLiquidFinal.Left := Round(frmHeatExchanger.Left + frmHeatExchanger.Width / 2 - pnlLLiquidFinal.Width - 20);

  pnlLLiquidFinal.Top := frmHeatExchanger.Top + frmHeatExchanger.Height + 50;

  pnlLLiquidFinal.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 60);



  pnlLLiquidCurrent.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 40);
  pnlLLiquidCurrent.Width := Round(pnlFlowSteam.Height * 11);
  pnlLLiquidCurrent.Left := Round(frmHeatExchanger.Left + frmHeatExchanger.Width / 2 - pnlLLiquidCurrent.Width - 20);

   pnlLLiquidCurrent.Top := pnlLLiquidFinal.Top + pnlLLiquidFinal.Height;
  pnlLLiquidCurrent.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 60);




  pnlTLiquidFinal.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 40);
  pnlTLiquidFinal.Width := Round(pnlFlowSteam.Height * 18);
  pnlTLiquidFinal.Left := Round(frmHeatExchanger.Left + frmHeatExchanger.Width / 2);

   pnlTLiquidFinal.Top := pnlLLiquidFinal.Top;
  pnlTLiquidFinal.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 60);






  pnlTLiquidOut1.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 40);
  pnlTLiquidOut1.Width := Round(pnlFlowSteam.Height * 14);
  pnlTLiquidOut1.Left := pnlTLiquidFinal.Left + pnlTLiquidFinal.Width - pnlTLiquidOut1.Width;

  pnlTLiquidOut1.Top := pnlLLiquidCurrent.Top;
  pnlTLiquidOut1.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 60);


  Image1.Left := trckbrValveIn.Left;
  Image1.Top := trckbrValveIn.Top - Image1.Height;

  Image2.Left := trckbrValveIn.Left;
  Image2.Top := trckbrValveIn.Top - Image1.Height;

 { Image3.Left := trckbrValveSteam.Left;
  Image3.Top := trckbrValveSteam.Top - Image1.Height;

  Image3.Left := trckbrValveSteam.Left;
  Image3.Top := trckbrValveSteam.Top - Image1.Height;





  panel3.width := round(frmHeatExchanger.Width * 1/4);
  panel3.Left := frmHeatExchanger.Left + round(frmHeatExchanger.Width * 3/4);

  panel3.height := round(frmHeatExchanger.Width * 6/20);
  panel3.top := frmHeatExchanger.top;     }
end;





procedure THeatExchangerForm.HintEnter;
begin
 // HeatExchangerForm.StatusBar1.Panels[0].Text := 'Нажмите Enter';
   // HeatExchangerForm.
end;

end.

