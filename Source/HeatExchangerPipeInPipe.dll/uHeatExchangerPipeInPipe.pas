unit uHeatExchangerPipeInPipe;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufrmHeatExchangerPipeInPipe, OpenGL, ExtCtrls, StdCtrls;

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

  THeatExchangerPipeInPipeForm = class(TForm)
    frmHeatExchangerPipeInPipe: TfrmHeatExchangerPipeInPipe;
    tmrOpenGLPaint: TTimer;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure frmHeatExchangerPipeInPipeMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure tmrOpenGLPaintTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }


      DC: HDC;
    hrc: HGLRC;
    procedure PixelFormat;
    procedure Scale(m: double);
    procedure TranslateGLToPixels(AttachObject, ObjectOwner: TControl; XGL, YGL, Scale: double);
   // procedure LiquidInToOutMorphing(CentreX, CentreY: double; CentreColor, ContourColor: cardinal);
   // procedure ControlsAttaching;
  public
    { Public declarations }
  end;

var

  Tank: TRectangle;
  PipeProduct: TRectangle;
  LeftCover: TRectangle;
  RightCover: TRectangle;
  PipeInOut: TRectangle;

  ValveIn: TValve;
  ValveInPatch: TRectangle;

  ValveSteam: TValve;
  ValveSteamPatch: Trectangle;

  PipeSteamHorizontal: TRectangle;
  PipeSteamVertical: TRectangle;

  PipeSteamTrapVertical: TRectangle;
  PipeSteamTrapWhite: TRectangle;
  PipeSteamTrapBlack: TRectangle;

   PipeSteamPatchTop: TRectangle;
   PipeSteamPatchBottom: TRectangle;

 { PipeInHorizontal: TRectangle;  // Горизонтальный участок трубы на входе
  PipeInVertical: TRectangle;    // Вертикальный участок трубы на входе
  PipeInPatch: TRectangle;       // "Заплата" в месте стыка труб
  Jacket: TRectangle;            // "Рубашка" теплообменника
  Liquid: TRectangle;            // Жидкость в теплообменнике



  ValveInPatch: Trectangle;

  PipeOutHorizontal: TRectangle;
  PipeOutVertical: TRectangle;
  PipeOutPatchTop: TRectangle;
  PipeOutPatchBottom: TRectangle;
  ValveOutPatch: Trectangle;

  PipeSteamTrapHorizontal: TRectangle;
   }



  HeatExchangerPipeInPipeForm: THeatExchangerPipeInPipeForm;

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






procedure THeatExchangerPipeInPipeForm.Button1Click(Sender: TObject);
begin
  PipeSteamVertical.Centre.x := -PipeSteamVertical.Centre.x;
  PipeSteamHorizontal.Centre.x := -PipeSteamHorizontal.Centre.x;
  ValveSteamPatch.Centre.x := -ValveSteamPatch.Centre.x;
  ValveSteam.Centre.x := -ValveSteam.Centre.x;

  PipeSteamTrapVertical.Centre.x := -PipeSteamTrapVertical.Centre.x;
  PipeSteamTrapWhite.Centre.x := PipeSteamTrapVertical.Centre.x-0.1;
  PipeSteamTrapBlack.Centre.x := PipeSteamTrapVertical.Centre.x+0.1;

  PipeSteamPatchTop.Centre.x := -PipeSteamPatchTop.Centre.x;
   PipeSteamPatchBottom.Centre.x := -PipeSteamPatchBottom.Centre.x;



end;

procedure THeatExchangerPipeInPipeForm.FormCreate(Sender: TObject);
var
 // HLib: THandle;
  ps: TPaintStruct;
begin
  DC := GetDC(frmHeatExchangerPipeInPipe.Handle);
  PixelFormat;
  hrc := wglCreateContext(DC);
  wglMakeCurrent(DC, hrc);
  BeginPaint(frmHeatExchangerPipeInPipe.Handle,ps);
  glClearColor(1,1,1,1);
  gllinewidth(3);
 EndPaint(frmHeatExchangerPipeInPipe.Handle,ps);

//******************************************************************************
   Tank := TRectangle.Create(0, 0, 3, 2, 0.2, 0.2, 0.2, 0.2, clred, clred, clred, clred, 0);
   PipeInOut := TRectangle.Create(0, 0, 7.8, 0.2, 0, 0, 0, 0, clblue, clblue, clblue, clblue, 0);
   PipeProduct := TRectangle.Create(0, 0, 3.6, 1.2, 0, 0, 0, 0, clblue, clblue, clblue, clblue, 0);
   LeftCover := TRectangle.Create(-2, 0, 0.5, 2, 0.5, 0.5, 0, 0, clblue, clblue, clblue, clblue, 0);
   RightCover := TRectangle.Create(2, 0, 0.5, 2, 0, 0, 0.5, 0.5, clblue, clblue, clblue, clblue, 0);

   ValveIn := Tvalve.Create(-3.1, 0, 0.8, 0.5, 0, true, clblack);
   ValveInPatch := TRectangle.Create(ValveIn.Centre.X, ValveIn.Centre.Y, ValveIn.Width, PipeInOut.height*1.5, 0, 0, 0, 0, clwhite, clwhite, clwhite, clwhite, 0);


   PipeSteamVertical := TRectangle.Create(1.2, 2, 0.2, 2, 0, 0, 0, 0, clred, clred, clred, clred, 0);
   PipeSteamHorizontal := TRectangle.Create(PipeSteamVertical.Centre.x + PipeSteamVertical.width/2 + 1.3, PipeSteamVertical.Centre.y + PipeSteamVertical.height/2 - 0.1, 2.6, 0.2, 0, 0, 0, 0, clred, clred, clred, clred, 0);

   ValveSteam := Tvalve.Create(3.1, PipeSteamHorizontal.Centre.y, 0.8, 0.5, 0, true, clblack);
  ValveSteamPatch := TRectangle.Create(ValveSteam.Centre.X, ValveSteam.Centre.Y, ValveSteam.Width, PipeSteamHorizontal.height*1.5, 0, 0, 0, 0, clwhite, clwhite, clwhite, clwhite, 0);


  PipeSteamTrapVertical := TRectangle.Create(-1.2, -1.5, 0.1, 1, 0, 0, 0, 0, clBlack, clBlack, clBlack, clBlack, 0);

   PipeSteamTrapWhite := TRectangle.Create(PipeSteamTrapVertical.Centre.x-0.1, PipeSteamTrapVertical.Centre.y - PipeSteamTrapVertical.height/2 -0.2, 0.6, 0.3, 0, 0, 0, 0, clwhite, clwhite, clwhite, clwhite, 45);
   PipeSteamTrapBlack := TRectangle.Create(PipeSteamTrapVertical.Centre.x+0.1, PipeSteamTrapVertical.Centre.y - PipeSteamTrapVertical.height/2 -0.4, 0.6, 0.3, 0, 0, 0, 0, clblack, clblack, clblack, clblack, 45);


  PipeSteamPatchTop := TRectangle.Create(PipeSteamHorizontal.Centre.x - PipeSteamHorizontal.width/2, PipeSteamHorizontal.Centre.y, 0.1, PipeSteamHorizontal.height - 0.05, 0, 0, 0, 0, clred, clred, clred, clred, 0);
  PipeSteamPatchBottom := TRectangle.Create(PipeSteamVertical.Centre.x, PipeSteamVertical.Centre.y - PipeSteamVertical.height/2, PipeSteamVertical.width - 0.05, 0.1, 0, 0, 0, 0, clred, clred, clred, clred, 0);


  {PipeInVertical := TRectangle.Create(-0.9, 2.5, 0.2, 1.5, 0, 0, 0, 0, clred, clred, clred, clred, 0);
  PipeInHorizontal := TRectangle.Create(PipeInVertical.Centre.x - PipeInVertical.width/2 - 1.4, PipeInVertical.Centre.y + PipeInVertical.height/2 - 0.1, 2.8, 0.2, 0, 0, 0, 0, clred, clred, clred, clred, 0);
  PipeInPatch := TRectangle.Create(PipeInHorizontal.Centre.x + PipeInHorizontal.width/2, PipeInHorizontal.Centre.y, 0.1, PipeInHorizontal.height - 0.05, 0, 0, 0, 0, clred, clred, clred, clred, 0);
  ValveIn := Tvalve.Create(-2.8, PipeInHorizontal.Centre.y, 0.8, 0.5, 0, true, clblack);
  ValveInPatch := TRectangle.Create(ValveIn.Centre.X, ValveIn.Centre.Y, ValveIn.Width, PipeInHorizontal.height*1.5, 0, 0, 0, 0, clwhite, clwhite, clwhite, clwhite, 0);


  Jacket := TRectangle.Create(-0.4, -1, 4, 3, 1.0, 0.5, 0.5, 1.0, clred, clred, clred, clred, 0);

  Liquid := TRectangle.Create(-0.4, -1, 3, 2, 0.5, 0, 0, 0.5, clblue, clblue, clblue, clblue, 0);

  PipeSteamHorizontal := TRectangle.Create(Jacket.width/2 + 0.7, -0.5, 2.2, 0.2, 0, 0, 0, 0, clred, clred, clred, clred, 0);
  PipeSteamPatch := TRectangle.Create(PipeSteamHorizontal.Centre.x - PipeSteamHorizontal.width/2, PipeSteamHorizontal.Centre.y, 0.1, PipeSteamHorizontal.height - 0.05, 0, 0, 0, 0, clred, clred, clred, clred, 0);
  ValveSteam := Tvalve.Create(2.9, PipeSteamHorizontal.Centre.y, 0.8, 0.5, 0, true, clblack);
  ValveSteamPatch := TRectangle.Create(ValveSteam.Centre.X, ValveSteam.Centre.Y, ValveSteam.Width, PipeSteamHorizontal.height*1.5, 0, 0, 0, 0, clwhite, clwhite, clwhite, clwhite, 0);

   PipeOutVertical := TRectangle.Create(-0.4, -2.8, 0.2, 1.6, 0, 0, 0, 0, clblue, clblue, clblue, clblue, 0);
   PipeOutHorizontal := TRectangle.Create(PipeOutVertical.Centre.x + PipeOutVertical.width/2 + 2.1, PipeOutVertical.Centre.y - PipeOutVertical.height/2 + 0.1, 4.2, 0.2, 0, 0, 0, 0, clblue, clblue, clblue, clblue, 0);

   PipeOutPatchTop := TRectangle.Create(Tank.Centre.x, Tank.Centre.y - Tank.height/2, PipeOutVertical.width, 0.1, 0, 0, 0, 0, clblue, clblue, clblue, clblue, 0);
   PipeOutPatchBottom := TRectangle.Create(PipeOutHorizontal.Centre.x - PipeOutHorizontal.width/2, PipeOutHorizontal.Centre.y, 0.1, PipeOutHorizontal.height - 0.05, 0, 0, 0, 0, clblue, clblue, clblue, clblue, 0);;


  ValveOut := Tvalve.Create(2.9, PipeOutHorizontal.Centre.y, 0.8, 0.5, 0, true, clblack);

   ValveOutPatch := TRectangle.Create(ValveOut.Centre.X, ValveOut.Centre.Y, ValveOut.Width, PipeOutHorizontal.height*1.5, 0, 0, 0, 0, clwhite, clwhite, clwhite, clwhite, 0);

   PipeSteamTrapHorizontal := TRectangle.Create(-Jacket.width/2 - 0.9, -1, 1, 0.1, 0, 0, 0, 0, clBlack, clBlack, clBlack, clBlack, 0);

   //LiquidInToOutMorphing := TRectangle.Create(PipeSteamTrapVertical.Centre.x+0.1, PipeSteamTrapVertical.Centre.y - PipeSteamTrapVertical.height/2 -0.4, 0.6, 0.3, 0, 0, 0, 0, clblack, clblack, clblack, clblack, 45);
//******************************************************************************       }





    { Hlib:=0;
  Hlib:=LoadLibrary('E:\Projects\Degree Work\Source\ModelHeatExchangerJacketed.dll\ModelHeatExchangerJacketed.dll');      //загрузка библиотеки
if Hlib<>0 then                             //загрузка прошла успешно
    _ModelHEJIni:=GetProcAddress(Hlib,'ModelHEJInitialize');

    _ModelHEJIni(AreaTank, AreaPipe, Beta, KHeatTransfer, RoLiquid, CpLiquid,
                 PSteamIn, TLiquidIn, PLiquidIn, AlphaLiquidIn, AlphaLiquidOut, AlphaSteamIn,
                 step,
                 LLiquid, TSteam, TLiquidOut, FlowLiquidIn, FlowLiquidOut, FlowSteamIn, FlowCondensate);

  //  FreeLibrary(Hlib);
     _ModelHEJCalc:=GetProcAddress(Hlib,'ModelHEJCalculate');   }

 end;






procedure THeatExchangerPipeInPipeForm.FormResize(Sender: TObject);
begin
HeatExchangerPipeInPipeForm.scale(4);
end;




procedure THeatExchangerPipeInPipeForm.FormShow(Sender: TObject);
begin
  frmHeatExchangerPipeInPipe.Height := Round(GetSystemMetrics(SM_CYSCREEN) / 2);
  frmHeatExchangerPipeInPipe.Top := Round(GetSystemMetrics(SM_CYSCREEN) / 4 - GetSystemMetrics(SM_CYMENU));
  frmHeatExchangerPipeInPipe.Width := frmHeatExchangerPipeInPipe.Height;
  frmHeatExchangerPipeInPipe.Left := Round(GetSystemMetrics(SM_CXSCREEN) / 2 - frmHeatExchangerPipeInPipe.Width / 2);

 // ControlsAttaching;


//******************************************************************************
  HeatExchangerPipeInPipeForm.Scale(4);
end;



procedure THeatExchangerPipeInPipeForm.frmHeatExchangerPipeInPipeMouseMove(
  Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
 Valvein.MouseMoving(x, y, frmHeatExchangerPipeInPipe);
  ValveInPatch.SetScale(ValveIn.scale);
  ValveSteam.MouseMoving(x, y, frmHeatExchangerPipeInPipe);
  ValveSteamPatch.SetScale(ValveSteam.scale);
end;

procedure THeatExchangerPipeInPipeForm.Scale(m: double);
var
  W, H: integer;
begin
  W := frmHeatExchangerPipeInPipe.Width;
  H := frmHeatExchangerPipeInPipe.Height;
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  if  (W <= H) then glOrtho(-m,m, -m*H/W, m*H/W, -1,1)
               else glOrtho(-m*W/H, m*W/H, -m,m, -1,1);
 glViewport(0, 0, W, H);
end;


procedure THeatExchangerPipeInPipeForm.tmrOpenGLPaintTimer(Sender: TObject);
var ps: TPaintStruct;
begin
 BeginPaint(frmHeatExchangerPipeInPipe.Handle,ps);
  glClear(GL_DEPTH_BUFFER_BIT or GL_COLOR_BUFFER_BIT);

//******************************************************************************
  Tank.PaintRectangle;
  Tank.PaintContour;

  PipeInOut.PaintRectangle;
  PipeInOut.PaintContour;

  PipeProduct.PaintRectangle;
  PipeProduct.PaintContour;

  LeftCover.PaintRectangle;
  LeftCover.PaintContour;

  RightCover.PaintRectangle;
  RightCover.PaintContour;


  ValveInPatch.PaintRectangle;
  ValveIn.Paint;


  PipeSteamVertical.PaintRectangle;
  PipeSteamVertical.PaintContour;

  PipeSteamHorizontal.PaintRectangle;
  PipeSteamHorizontal.PaintContour;

   ValveSteamPatch.PaintRectangle;
  ValveSteam.Paint;


    PipeSteamTrapVertical.PaintRectangle;

  PipeSteamTrapWhite.PaintRectangle;
  PipeSteamTrapWhite.PaintContour;

  PipeSteamTrapBlack.PaintRectangle;
  PipeSteamTrapBlack.PaintContour;

  PipeSteamPatchTop.PaintRectangle;
  PipeSteamPatchBottom.PaintRectangle;
//******************************************************************************
  EndPaint(frmHeatExchangerPipeInPipe.Handle,ps);
  swapBuffers(dc);
end;

procedure THeatExchangerPipeInPipeForm.PixelFormat;
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



 procedure THeatExchangerPipeInPipeForm.TranslateGLToPixels;
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



end.
