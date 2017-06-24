unit uHeatExchangerShellTube;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OpenGL, math, ufmHeatExchangerShellTube, ExtCtrls, StdCtrls, ComCtrls;

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


  THeatExchangerShellTubeForm = class(TForm)
    frmHeatExchangerShellTube: TfrmHeatExchangerShellTube;
    Timer1: TTimer;
    trckbrValveSteam: TTrackBar;
    lbledtValveSteam: TLabeledEdit;
    pnlFlowSteam: TPanel;
    lbledtPSteam: TLabeledEdit;
    trckbrPSteam: TTrackBar;
    pnlFlowCondensate: TPanel;
    trckbrValveIn: TTrackBar;
    lbledtValveIn: TLabeledEdit;
    pnlFlowIn: TPanel;
    lbledtTLiquidIn: TLabeledEdit;
    lbledtPLiquidIn: TLabeledEdit;
    trckbrTLiquidIn: TTrackBar;
    trckbrPLiquidIn: TTrackBar;
    pnlTLiquidOut: TPanel;
    pnlFlowOut: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure frmHeatExchangerShellTubeMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure frmHeatExchangerShellTubeMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    DC: HDC;
    hrc: HGLRC;
    procedure PixelFormat;
    procedure Scale(m: double);
    procedure TranslateGLToPixels(AttachObject, ObjectOwner: TControl; XGL, YGL, Scale: double);
  //  procedure LiquidInToOutMorphing(CentreX, CentreY: double; CentreColor, ContourColor: cardinal);
    procedure ControlsAttaching;
  public
    { Public declarations }
  end;

var
  HeatExchangerShellTubeForm: THeatExchangerShellTubeForm;

  Tank: TRectangle;              // Ёмкость теплообменника
  TopCover: Trectangle;
  BottomCover: Trectangle;

  ValveSteamPatch: TRectangle;

  PipeSteamHorizontal: TRectangle;  // Горизонтальный участок трубы на входе
  PipeSteamPatch: TRectangle;


  PipeSteamTrapHorizontal: TRectangle;
  PipeSteamTrapVertical: TRectangle;
  PipeSteamTrapWhite: TRectangle;
  PipeSteamTrapBlack: TRectangle;



    PipeInHorizontal: TRectangle;  // Горизонтальный участок трубы на входе
  PipeInVertical: TRectangle;    // Вертикальный участок трубы на входе
  PipeInPatchBottom: TRectangle;       // "Заплата" в месте стыка труб
   PipeInPatchTop: TRectangle;
   ValveInPatch: Trectangle;



  PipeOutHorizontal: TRectangle;
  PipeOutVertical: TRectangle;
  PipeOutPatchTop: TRectangle;
  PipeOutPatchBottom: TRectangle;
 // ValveOutPatch: Trectangle;

  Pipe1, Pipe2, Pipe3, Pipe4: Trectangle;
 Pipe5, Pipe6, Pipe7: Trectangle;


  ValveSteam: TValve;
  ValveIn: TValve;
 // ValveOut: TValve;



implementation

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



procedure THeatExchangerShellTubeForm.Scale(m: double);
var
  W, H: integer;
begin
  W := frmHeatExchangerShellTube.Width;
  H := frmHeatExchangerShellTube.Height;
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  if  (W <= H) then glOrtho(-m,m, -m*H/W, m*H/W, -1,1)
               else glOrtho(-m*W/H, m*W/H, -m,m, -1,1);
 glViewport(0, 0, W, H);
end;




procedure THeatExchangerShellTubeForm.FormCreate(Sender: TObject);
var
  ps: TPaintStruct;
begin
 DC := GetDC(frmHeatExchangerShellTube.Handle);
  PixelFormat;
  hrc := wglCreateContext(DC);
  wglMakeCurrent(DC, hrc);
  BeginPaint(frmHeatExchangerShellTube.Handle,ps);
  glClearColor(1,1,1,1);
  gllinewidth(3);
 EndPaint(frmHeatExchangerShellTube.Handle,ps);


  Tank := TRectangle.Create(0, 0, 3, 3.4, 0, 0, 0, 0, clred, clred, clred, clred, 0);
  TopCover := TRectangle.Create(Tank.Centre.x, Tank.Centre.y + Tank.height / 2 + 0.5, 3.5, 1, 0, 1, 1, 0, RGB(200,0, 0), RGB(200,0, 0), RGB(200,0, 0), RGB(200,0, 0), 0);

  PipeSteamHorizontal := TRectangle.Create(Tank.Centre.x - Tank.width /2 - 1.2, Tank.Centre.y + 1.3, 2.4, 0.2, 0, 0, 0, 0, clred, clred, clred, clred, 0);
 PipeSteamPatch := TRectangle.Create(PipeSteamHorizontal.Centre.x + PipeSteamHorizontal.width/2, PipeSteamHorizontal.Centre.y, 0.1, PipeSteamHorizontal.height - 0.05, 0, 0, 0, 0, clred, clred, clred, clred, 0);

  ValveSteam := Tvalve.Create(-3, PipeSteamHorizontal.Centre.y, 0.8, 0.5, 0, true, clblack);
  ValveSteamPatch := TRectangle.Create(ValveSteam.Centre.X, ValveSteam.Centre.Y, ValveSteam.Width, PipeSteamHorizontal.height*1.5, 0, 0, 0, 0, clwhite, clwhite, clwhite, clwhite, 0);

   BottomCover := TRectangle.Create(Tank.Centre.x, Tank.Centre.y - Tank.height / 2 - 0.5, 3.5, 1, 1, 0, 0, 1, clblue, clblue, clblue, clblue, 0);

   PipeSteamTrapHorizontal := TRectangle.Create(Tank.width/2 + 0.6, Tank.Centre.y - 1.3, 1.2, 0.1, 0, 0, 0, 0, clBlack, clBlack, clBlack, clBlack, 0);
   PipeSteamTrapVertical := TRectangle.Create(PipeSteamTrapHorizontal.Centre.x + PipeSteamTrapHorizontal.width/2, PipeSteamTrapHorizontal.Centre.y + PipeSteamTrapHorizontal.height/2 - 0.5, 0.1, 1, 0, 0, 0, 0, clBlack, clBlack, clBlack, clBlack, 0);

   PipeSteamTrapWhite := TRectangle.Create(PipeSteamTrapVertical.Centre.x-0.1, PipeSteamTrapVertical.Centre.y - PipeSteamTrapVertical.height/2 -0.2, 0.6, 0.3, 0, 0, 0, 0, clwhite, clwhite, clwhite, clwhite, 45);
   PipeSteamTrapBlack := TRectangle.Create(PipeSteamTrapVertical.Centre.x+0.1, PipeSteamTrapVertical.Centre.y - PipeSteamTrapVertical.height/2 -0.4, 0.6, 0.3, 0, 0, 0, 0, clblack, clblack, clblack, clblack, 45);



    PipeInVertical := TRectangle.Create(0, Tank.Centre.y - Tank.height / 2 - BottomCover.height - 0.3, 0.2, 0.6, 0, 0, 0, 0, clblue, clblue, clblue, clblue, 0);
  PipeInHorizontal := TRectangle.Create(PipeInVertical.Centre.x - PipeInVertical.width/2 - 1.9, PipeInVertical.Centre.y - PipeInVertical.height/2 + 0.1, 3.8, 0.2, 0, 0, 0, 0, clblue, clblue, clblue, clblue, 0);
  PipeInPatchBottom := TRectangle.Create(PipeInHorizontal.Centre.x + PipeInHorizontal.width/2, PipeInHorizontal.Centre.y, 0.1, PipeInHorizontal.height - 0.05, 0, 0, 0, 0, clblue, clblue, clblue, clblue, 0);

  PipeInPatchTop := TRectangle.Create(PipeInVertical.Centre.x, PipeInVertical.Centre.y + PipeInVertical.height/2, PipeInVertical.width, 0.1, 0, 0, 0, 0, clblue, clblue, clblue, clblue, 0);

  ValveIn := Tvalve.Create(-3, PipeInHorizontal.Centre.y, 0.8, 0.5, 0, true, clblack);
  ValveInPatch := TRectangle.Create(ValveIn.Centre.X, ValveIn.Centre.Y, ValveIn.Width, PipeInHorizontal.height*1.5, 0, 0, 0, 0, clwhite, clwhite, clwhite, clwhite, 0);




   PipeOutVertical := TRectangle.Create(0, Tank.Centre.y + Tank.height / 2 + TopCover.height + 0.3, 0.2, 0.6, 0, 0, 0, 0, RGB(200,0, 0), RGB(200,0, 0), RGB(200,0, 0), RGB(200,0, 0), 0);
   PipeOutHorizontal := TRectangle.Create(PipeOutVertical.Centre.x + PipeOutVertical.width/2 + 1.5, PipeOutVertical.Centre.y + PipeOutVertical.height/2 - 0.1, 3.0, 0.2, 0, 0, 0, 0, RGB(200,0, 0), RGB(200,0, 0), RGB(200,0, 0), RGB(200,0, 0), 0);

   PipeOutPatchBottom := TRectangle.Create(PipeOutVertical.Centre.x, PipeOutVertical.Centre.y - PipeOutVertical.height/2, PipeOutVertical.width, 0.1, 0, 0, 0, 0, RGB(200,0, 0), RGB(200,0, 0), RGB(200,0, 0), RGB(200,0, 0), 0);
   PipeOutPatchTop := TRectangle.Create(PipeOutHorizontal.Centre.x - PipeOutHorizontal.width/2, PipeOutHorizontal.Centre.y, 0.1, PipeOutHorizontal.height - 0.05, 0, 0, 0, 0, RGB(200,0, 0), RGB(200,0, 0), RGB(200,0, 0), RGB(200,0, 0), 0);;


 // ValveOut := Tvalve.Create(2.9, PipeOutHorizontal.Centre.y, 0.8, 0.5, 0, true, clblack);

 //  ValveOutPatch := TRectangle.Create(ValveOut.Centre.X, ValveOut.Centre.Y, ValveOut.Width, PipeOutHorizontal.height*1.5, 0, 0, 0, 0, clwhite, clwhite, clwhite, clwhite, 0);


   Pipe1 := TRectangle.Create(Tank.Centre.x, Tank.Centre.y, 0.1, Tank.height, 0, 0, 0, 0, clblue, RGB(200,0, 0), RGB(200,0, 0), clblue, 0);;
   Pipe2 := TRectangle.Create(Tank.Centre.x + Tank.width / 8 * 1, Tank.Centre.y, 0.1, Tank.height, 0, 0, 0, 0, clblue, RGB(200,0, 0), RGB(200,0, 0), clblue, 0);;
   Pipe3 := TRectangle.Create(Tank.Centre.x + Tank.width / 8 * 2, Tank.Centre.y, 0.1, Tank.height, 0, 0, 0, 0, clblue, RGB(200,0, 0), RGB(200,0, 0), clblue, 0);;
   Pipe4 := TRectangle.Create(Tank.Centre.x + Tank.width / 8 * 3, Tank.Centre.y, 0.1, Tank.height, 0, 0, 0, 0, clblue, RGB(200,0, 0), RGB(200,0, 0), clblue, 0);;

   Pipe5 := TRectangle.Create(Tank.Centre.x - Tank.width / 8 * 1, Tank.Centre.y, 0.1, Tank.height, 0, 0, 0, 0, clblue, RGB(200,0, 0), RGB(200,0, 0), clblue, 0);;
   Pipe6 := TRectangle.Create(Tank.Centre.x - Tank.width / 8 * 2, Tank.Centre.y, 0.1, Tank.height, 0, 0, 0, 0, clblue, RGB(200,0, 0), RGB(200,0, 0), clblue, 0);;
   Pipe7 := TRectangle.Create(Tank.Centre.x - Tank.width / 8 * 3, Tank.Centre.y, 0.1, Tank.height, 0, 0, 0, 0, clblue, RGB(200,0, 0), RGB(200,0, 0), clblue, 0);;

end;

procedure THeatExchangerShellTubeForm.FormResize(Sender: TObject);
begin
  HeatExchangerShellTubeForm.scale(4);
end;






procedure THeatExchangerShellTubeForm.FormShow(Sender: TObject);
begin
 frmHeatExchangerShellTube.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 2);
  frmHeatExchangerShellTube.Top := Round(GetSystemMetrics(SM_CYSCREEN) / 4 - GetSystemMetrics(SM_CYMENU));
  frmHeatExchangerShellTube.Width := frmHeatExchangerShellTube.Height;
  frmHeatExchangerShellTube.Left := Round(GetSystemMetrics(SM_CXSCREEN) / 2 - frmHeatExchangerShellTube.Width / 2);


  ControlsAttaching;




//******************************************************************************
  HeatExchangerShellTubeForm.Scale(4);
end;

procedure THeatExchangerShellTubeForm.frmHeatExchangerShellTubeMouseDown(
  Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (ValveIn.Scale <> 1) then if (trckbrValveIn.Tag = 1) then trckbrValveIn.Tag := 0 else trckbrValveIn.Tag := 1;
//  if (ValveOut.Scale <> 1) then if (trckbrValveOut.Tag = 1) then trckbrValveOut.Tag := 0 else trckbrValveOut.Tag := 1;
 if (ValveSteam.Scale <> 1) then if (trckbrValveSteam.Tag = 1) then trckbrValveSteam.Tag := 0 else trckbrValveSteam.Tag := 1;
end;

procedure THeatExchangerShellTubeForm.frmHeatExchangerShellTubeMouseMove(
  Sender: TObject; Shift: TShiftState; X, Y: Integer);

   var VisibleIn: boolean;
      VisibleOut: boolean;
      VisibleSteam: boolean;

begin
   ValveSteam.MouseMoving(x, y, frmHeatExchangerShellTube);
  ValveSteamPatch.SetScale(ValveSteam.scale);

   ValveIn.MouseMoving(x, y, frmHeatExchangerShellTube);
  ValveInPatch.SetScale(Valvein.scale);

  ///ValveOut.MouseMoving(x, y, frmHeatExchangerShellTube);
 /// ValveOutPatch.SetScale(Valveout.scale);

    if (ValveIn.Scale <> 1) or (trckbrValveIn.Tag = 1) then VisibleIn:= true else VisibleIn:= false;

        trckbrValveIn.Visible := VisibleIn;
        lbledtValveIn.Visible := VisibleIn;
        pnlFlowIn.Visible := VisibleIn;
        lbledtTLiquidIn.Visible := VisibleIn;
        trckbrTLiquidIn.Visible := VisibleIn;
        lbledtPLiquidIn.Visible := VisibleIn;
        trckbrPLiquidIn.Visible := VisibleIn;
        pnlFlowOut.Visible := VisibleIn;
        {
    if (ValveOut.Scale <> 1) or (trckbrValveOut.Tag = 1) then VisibleOut:= true else VisibleOut:= false;
           trckbrValveOut.Visible := VisibleOut;
        lbledtValveOut.Visible := VisibleOut;
         pnlFlowOut.Visible := VisibleOut;
         pnlTLiquidOut.Visible := VisibleOut;      }
    if (ValveSteam.Scale <> 1) or (trckbrValveSteam.Tag = 1) then VisibleSteam:= true else VisibleSteam:= false;
           trckbrValveSteam.Visible := VisibleSteam;
        lbledtValveSteam.Visible := VisibleSteam;
        pnlFlowSteam.Visible := VisibleSteam;
        pnlFlowCondensate.Visible := VisibleSteam;
        lbledtPSteam.Visible := VisibleSteam;
        trckbrPSteam.Visible := VisibleSteam;
end;

procedure THeatExchangerShellTubeForm.PixelFormat;
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



procedure THeatExchangerShellTubeForm.Timer1Timer(Sender: TObject);
var ps: TPaintStruct;
begin
BeginPaint(frmHeatExchangerShellTube.Handle,ps);
  glClear(GL_DEPTH_BUFFER_BIT or GL_COLOR_BUFFER_BIT);

  ///--------
  ///
  ///

   PipeInHorizontal.PaintRectangle;
  PipeInHorizontal.PaintContour;

  PipeInVertical.PaintRectangle;
  PipeInVertical.PaintContour;


   PipeInPatchBottom.PaintRectangle;


  ValveInPatch.PaintRectangle;

    ValveIn.Paint;



  Tank.PaintRectangle;
  Tank.PaintContour;



  TopCover.PaintRectangle;
  TopCover.PaintContour;




   BottomCover.PaintRectangle;
  BottomCover.PaintContour;

   PipeInPatchTop.PaintRectangle;

  PipeSteamHorizontal.PaintRectangle;
  PipeSteamHorizontal.PaintContour;

  PipeSteamPatch.PaintRectangle;

  ValveSteamPatch.PaintRectangle;


  ValveSteam.Paint;


    PipeSteamTrapHorizontal.PaintRectangle;
  PipeSteamTrapVertical.PaintRectangle;

  PipeSteamTrapWhite.PaintRectangle;
  PipeSteamTrapWhite.PaintContour;

  PipeSteamTrapBlack.PaintRectangle;
  PipeSteamTrapBlack.PaintContour;




   PipeOutVertical.PaintRectangle;
  PipeOutVertical.PaintContour;

  PipeOutHorizontal.PaintRectangle;
  PipeOutHorizontal.PaintContour;

  PipeOutPatchTop.PaintRectangle;
  PipeOutPatchBottom.PaintRectangle;

  //ValveOutPatch.PaintRectangle;

  //ValveOut.Paint;



  Pipe1.PaintRectangle;
  pipe1.PaintContour;

  Pipe2.PaintRectangle;
  pipe2.PaintContour;

  Pipe3.PaintRectangle;
  pipe3.PaintContour;

  Pipe4.PaintRectangle;
  pipe4.PaintContour;

  Pipe5.PaintRectangle;
  pipe5.PaintContour;

  Pipe6.PaintRectangle;
  pipe6.PaintContour;

  Pipe7.PaintRectangle;
  pipe7.PaintContour;


  //***********

   EndPaint(frmHeatExchangerShellTube.Handle,ps);
  swapBuffers(dc);
end;




procedure THeatExchangerShellTubeForm.TranslateGLToPixels;
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





procedure THeatExchangerShellTubeForm.ControlsAttaching;
begin
//******************************************************************************



  trckbrValveIn.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 10);
  if (trckbrValveIn.Height/3 >= 40) then trckbrValveIn.Width := Round(trckbrValveIn.Height/3) else trckbrValveIn.Width := 40;
  TranslateGLToPixels(trckbrValveIn, frmHeatExchangerShellTube, ValveIn.Centre.X, ValveIn.Centre.Y + 2.2, 4);
  trckbrValveIn.Left := Round(trckbrValveIn.Left - trckbrValveIn.Width / 2);
  //trckbrValveIn.Position := Round(100 - AlphaLiquidIn * 10000);

  lbledtValveIn.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 30);
  lbledtValveIn.Width := Round(lbledtValveIn.Height / 0.8);
  TranslateGLToPixels(lbledtValveIn, frmHeatExchangerShellTube, ValveIn.Centre.X + 0.4, ValveIn.Centre.Y + 1.6, 4);
  lbledtValveIn.Left := lbledtValveIn.Left + 1;


  lbledtValveIn.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 60);
  lbledtValveIn.EditLabel.Font.Size := lbledtValveIn.Font.Size;
  lbledtValveIn.Font.Color := clsilver;
  lbledtValveIn.EditLabel.Font.Color := clsilver;
  lbledtValveIn.Text := IntToStr(100 - trckbrValveIn.Position);

  ////////////////////////


  pnlFlowSteam.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 40);
  pnlFlowSteam.Width := Round(pnlFlowSteam.Height * 7);
  TranslateGLToPixels(pnlFlowSteam, frmHeatExchangerShellTube, Tank.Centre.X - Tank.width / 2, ValveSteam.Centre.Y - ValveSteam.Height / 2, 4);
  pnlFlowSteam.Left := pnlFlowSteam.Left - pnlFlowSteam.Width - 2;
  pnlFlowSteam.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 80);



  pnlFlowIn.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 40);
  pnlFlowIn.Width := Round(pnlFlowIn.Height * 7);
  TranslateGLToPixels(pnlFlowIn, frmHeatExchangerShellTube, PipeInHorizontal.Centre.X, ValveIn.Centre.Y - ValveIn.Height / 2, 4);
  pnlFlowIn.Left := pnlFlowSteam.Left;
  pnlFlowIn.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 80);







   pnlFlowCondensate.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 40);
  pnlFlowCondensate.Width := Round(pnlFlowCondensate.Height * 7);
  TranslateGLToPixels(pnlFlowCondensate, frmHeatExchangerShellTube, PipeSteamTrapVertical.Centre.X, PipeSteamTrapVertical.Centre.Y - PipeSteamTrapVertical.Height / 2 - 0.8, 4);
  pnlFlowCondensate.Left := Round(pnlFlowCondensate.Left - pnlFlowCondensate.Width / 2);
  pnlFlowCondensate.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 80);



   pnlFlowOut.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 50);
  pnlFlowOut.Width := Round(pnlFlowOut.Height * 8);
  TranslateGLToPixels(pnlFlowOut, frmHeatExchangerShellTube, PipeOutHorizontal.Centre.X + PipeOutHorizontal.width / 2, PipeOutHorizontal.Centre.Y - PipeOutHorizontal.Height / 2 - 0.02, 4);
 pnlFlowOut.Left := Round(pnlFlowOut.Left - pnlFlowOut.Width);
  // pnlFlowOut.Left := Round(pnlFlowSteam.Left + pnlFlowSteam.Width - pnlFlowOut.Width);
  pnlFlowOut.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 80);



////////////////////////////////////
{  trckbrValveOut.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 10);
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
  lbledtValveOut.Text := IntToStr(100 - trckbrValveOut.Position); }


  //////
  trckbrValveSteam.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 10);
   if (trckbrValveSteam.Height/3 >= 40) then trckbrValveSteam.Width := Round(trckbrValveSteam.Height/3) else trckbrValveSteam.Width := 40;
  TranslateGLToPixels(trckbrValveSteam, frmHeatExchangerShellTube, ValveSteam.Centre.X, ValveSteam.Centre.Y + 2.2, 4);
  trckbrValveSteam.Left := Round(trckbrValveSteam.Left - trckbrValveSteam.Width / 2);
//  trckbrValveSteam.Position := Round(100 - AlphaSteamIn * 100);

  lbledtValveSteam.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 30);
  lbledtValveSteam.Width := Round(lbledtValveSteam.Height / 0.8);
  TranslateGLToPixels(lbledtValveSteam, frmHeatExchangerShellTube, ValveSteam.Centre.X + 0.4, ValveSteam.Centre.Y + 1.6, 4);
 lbledtValveSteam.Left := lbledtValveSteam.Left + 1;


  lbledtValveSteam.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 60);
  lbledtValveSteam.EditLabel.Font.Size := lbledtValveSteam.Font.Size;
  lbledtValveSteam.Font.Color := clsilver;
  lbledtValveSteam.EditLabel.Font.Color := clsilver;
  lbledtValveSteam.Text := IntToStr(100 - trckbrValveSteam.Position);




  lbledtPSteam.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 30);
  lbledtPSteam.Width := Round(lbledtPSteam.Height * 2);
  TranslateGLToPixels(lbledtPSteam, frmHeatExchangerShellTube, PipeSteamHorizontal.Centre.X, PipeSteamHorizontal.Centre.Y, 4);

  lbledtPSteam.Left := pnlFlowSteam.Left - lbledtPSteam.Width - lbledtPSteam.EditLabel.Width;

  lbledtPSteam.Top := lbledtPSteam.Top - lbledtPSteam.Height;
  lbledtPSteam.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 60);
  lbledtPSteam.EditLabel.Font.Size := lbledtPSteam.Font.Size;
  lbledtPSteam.Font.Color := clsilver;
  lbledtPSteam.EditLabel.Font.Color := clsilver;
 // lbledtPSteam.Text := FloatToStr(PSteamIn / 1000);
  ////
   trckbrPSteam.Height := trckbrValveSteam.Width;
   trckbrPSteam.Width := lbledtPSteam.Width + lbledtPSteam.EditLabel.Width;
  TranslateGLToPixels(trckbrPSteam, frmHeatExchangerShellTube, PipeInHorizontal.Centre.X, PipeInHorizontal.Centre.Y, 4);

 trckbrPSteam.Left := lbledtPSteam.Left;
  trckbrPSteam.Top := lbledtPSteam.Top + lbledtPSteam.Height + 1;
 // trckbrPSteam.Position := Round(PSteamIn);






      trckbrTLiquidIn.Height := trckbrValveIn.Width;
  /////
  lbledtTLiquidIn.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 30);
  lbledtTLiquidIn.Width := Round(lbledtTLiquidIn.Height * 1.5);
  //lbledtTLiquidIn.EditLabel.Width := lbledtTLiquidIn.Width;
  TranslateGLToPixels(lbledtTLiquidIn, frmHeatExchangerShellTube, PipeInHorizontal.Centre.X, PipeInHorizontal.Centre.Y + PipeInHorizontal.height / 2, 4);
  lbledtTLiquidIn.Left :=  lbledtPSteam.Left;
  lbledtTLiquidIn.Top := lbledtTLiquidIn.Top - trckbrTLiquidIn.Height - 1 - lbledtTLiquidIn.Height;
  lbledtTLiquidIn.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 60);
  lbledtTLiquidIn.EditLabel.Font.Size := lbledtTLiquidIn.Font.Size;
  lbledtTLiquidIn.Font.Color := clsilver;
  lbledtTLiquidIn.EditLabel.Font.Color := clsilver;
  lbledtTLiquidIn.Text := IntToStr(trckbrTLiquidIn.Position);

   ///

   trckbrTLiquidIn.Width := trckbrPSteam.Width;
  TranslateGLToPixels(trckbrTLiquidIn, frmHeatExchangerShellTube, PipeInHorizontal.Centre.X, PipeInHorizontal.Centre.Y + PipeInHorizontal.height / 2, 4);

 trckbrTLiquidIn.Left := lbledtTLiquidIn.Left;
  trckbrTLiquidIn.Top := lbledtTLiquidIn.Top + lbledtTLiquidIn.Height + 1;
//  trckbrTLiquidIn.Position := Round(TLiquidIn);

      //////
  lbledtPLiquidIn.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 30);
  lbledtPLiquidIn.Width := Round(lbledtPLiquidIn.Height);
 // lbledtPLiquidIn.EditLabel.Width := lbledtPLiquidIn.Width;
  TranslateGLToPixels(lbledtPLiquidIn, frmHeatExchangerShellTube, PipeInHorizontal.Centre.X, PipeInHorizontal.Centre.Y - PipeInHorizontal.height / 2, 4);
  lbledtPLiquidIn.Left := lbledtTLiquidIn.Left;
 // lbledtPLiquidIn.Top := lbledtPLiquidIn.Top + 1;
  lbledtPLiquidIn.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 60);
  lbledtPLiquidIn.EditLabel.Font.Size := lbledtPLiquidIn.Font.Size;
  lbledtPLiquidIn.Font.Color := clsilver;
  lbledtPLiquidIn.EditLabel.Font.Color := clsilver;
 // lbledtPLiquidIn.Text := FloatToStr(PLiquidIn / 1000);
  ////
   trckbrPLiquidIn.Height := trckbrValveIn.Width;
   trckbrPLiquidIn.Width := trckbrPSteam.Width;
  TranslateGLToPixels(trckbrPLiquidIn, frmHeatExchangerShellTube, PipeInHorizontal.Centre.X, PipeInHorizontal.Centre.Y, 4);

 trckbrPLiquidIn.Left := lbledtPLiquidIn.Left;
  trckbrPLiquidIn.Top := lbledtPLiquidIn.Top + lbledtPLiquidIn.Height + 1;
 // trckbrPLiquidIn.Position := Round(PLiquidIn / 1000);    }


   /////




   ////////////
  pnlTLiquidOut.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 40);
  pnlTLiquidOut.Width := Round(pnlFlowSteam.Height * 4);
  TranslateGLToPixels(pnlTLiquidOut, frmHeatExchangerShellTube, PipeOutHorizontal.Centre.X + PipeOutHorizontal.width / 2, PipeOutHorizontal.Centre.Y, 4);
  pnlTLiquidOut.Left := lbledtPSteam.Left;
  pnlTLiquidOut.Top := Round(pnlTLiquidOut.Top - pnlTLiquidOut.Height / 2);
  pnlTLiquidOut.Font.Size := Round(GetSystemMetrics(SM_CYSCREEN) / 60);
end;

end.
