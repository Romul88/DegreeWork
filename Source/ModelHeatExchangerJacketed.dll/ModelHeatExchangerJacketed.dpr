{************************************************************}
{                                                            }
{         Библиотека "ModelHeatExchangerJacketed.dll"        }
{                Copyright (c) 2010 "BolkodaB"               }
{                                                            }
{  Разработчик: Максимов Р.Ю.                                }
{  Модифицирован: 6.03.2010                                  }
{  Версия:        0.6.0.0                                    }
{************************************************************}

library ModelHeatExchangerJacketed;

uses
  Windows, SysUtils, Classes,
  IniFiles;                      // Модули Delphi

{$R *.res}

//******************************************************************************

procedure ModelHEJCalculate(AreaTank, AreaPipe, Beta, KHeatTransfer, RoLiquid, CpLiquid,                  // Технические параметры
                            PSteamIn, TLiquidIn, PLiquidIn, AlphaLiquidIn, AlphaLiquidOut, AlphaSteamIn,  // Технологические переменные
                            Step: double;                                                                 // Дополнительные параметры
                            var LevelLiquid, TSteam, TLiquidOut, FlowLiquidIn, FlowLiquidOut,             // Изменяющиеся переменные
                                FlowSteamIn, FlowCondensate: double);
                            stdcall; export;
var
  AreaHeatExchange, PressureSteamJacket: double;
  K1, K2, K3, K4, M1, M2, M3, M4: double;
begin
  AreaHeatExchange := AreaTank * LevelLiquid;
  PressureSteamJacket := (sqr(AlphaSteamIn) * PSteamIn) / (sqr(AlphaSteamIn) +
                          sqr(beta)) {* step * 1/5 + PSteamIn * (1 - step * 1/5)};
  if (PressureSteamJacket = 0) then TSteam := 0
                               else TSteam := -0.000000000042756 * sqr(PressureSteamJacket) +
                                              0.000129949899939 * PressureSteamJacket + 96.4984111106861;

{ Расчёт системы ДУ методом Рунге-Кутта:
  дополнительные коэффициенты k1, k2, k3, k4 - для расчёта уровня
  дополнительные коэффициенты m1, m2, m3, m4 - для расчёта температуры. }

  K1 := (AlphaLiquidIn * AreaPipe * sqrt(PLiquidIn) - AlphaLiquidOut *
         AreaPipe * sqrt(RoLiquid * 10 * LevelLiquid)) / AreaTank * step;
  M1 := (AlphaLiquidIn * AreaPipe * sqrt(PLiquidIn) * RoLiquid * CpLiquid *
         TLiquidIn - AlphaLiquidOut * AreaPipe * sqrt(RoLiquid * 10 *
         LevelLiquid) * RoLiquid * CpLiquid * TLiquidOut + KHeatTransfer *
         AreaHeatExchange * (TSteam - TLiquidOut)) / (LevelLiquid * AreaTank *
         CpLiquid * RoLiquid) * step;
  K2 := (AlphaLiquidIn * AreaPipe * sqrt(PLiquidIn) - AlphaLiquidOut *
         AreaPipe * sqrt(RoLiquid * 10 * (LevelLiquid + k1 / 2))) / AreaTank * step;
  M2 := (AlphaLiquidIn * AreaPipe * sqrt(PLiquidIn) * RoLiquid * CpLiquid *
         TLiquidIn - AlphaLiquidOut * AreaPipe * sqrt(RoLiquid * 10 *
         (LevelLiquid + k1 / 2)) * RoLiquid * CpLiquid * (TLiquidOut + m1/2) +
         KHeatTransfer * AreaHeatExchange * (TSteam - (TLiquidOut + m1 / 2))) /
         ((LevelLiquid + k1 / 2) * AreaTank * CpLiquid * RoLiquid) * step;
  K3 := (AlphaLiquidIn * AreaPipe * sqrt(PLiquidIn) - AlphaLiquidOut *
         AreaPipe * sqrt(RoLiquid * 10 * (LevelLiquid + k2 / 2))) / AreaTank * step;
  M3 := (AlphaLiquidIn * AreaPipe * sqrt(PLiquidIn) * RoLiquid * CpLiquid *
         TLiquidIn - AlphaLiquidOut * AreaPipe * sqrt(RoLiquid * 10 *
         (LevelLiquid + k2 / 2)) * RoLiquid * CpLiquid * (TLiquidOut + m2/2) +
         KHeatTransfer * AreaHeatExchange * (TSteam - (TLiquidOut + m2 / 2))) /
         ((LevelLiquid + k2 / 2) * AreaTank * CpLiquid * RoLiquid) * step;
  K4 := (AlphaLiquidIn * AreaPipe * sqrt(PLiquidIn) - AlphaLiquidOut *
         AreaPipe * sqrt(RoLiquid * 10 * (LevelLiquid + k3))) / AreaTank * step;
  M4 := (AlphaLiquidIn * AreaPipe * sqrt(PLiquidIn) * RoLiquid * CpLiquid *
         TLiquidIn - AlphaLiquidOut * AreaPipe * sqrt(RoLiquid * 10 *
         (LevelLiquid + k3)) * RoLiquid * CpLiquid * (TLiquidOut + m3) + KHeatTransfer *
         AreaHeatExchange * (TSteam - (TLiquidOut + m3))) / ((LevelLiquid + k3) *
         AreaTank * CpLiquid * RoLiquid) * step;

// Расчёт температуры и уровня
  LevelLiquid := LevelLiquid + (k1 + 2 * k2 + 2 * k3 + k4) / 6;
  if (LevelLiquid >= 1) then LevelLiquid := 1 else if (LevelLiquid <= 0.01) then LevelLiquid := 0.01;
  TLiquidOut := TLiquidOut + (m1 + 2 * m2 + 2 * m3 + m4) / 6;
  if (LevelLiquid <= 0.02) then TLiquidOut := 0;


// Вывод информации о величине расходов и температуры
  FlowLiquidIn := AlphaLiquidIn * 100 * AreaPipe * sqrt(PLiquidIn);
  FlowLiquidOut := AlphaLiquidOut * 100 * AreaPipe * sqrt(RoLiquid*10*LevelLiquid);
  FlowSteamIn := AlphaSteamIn / 100 * sqrt(PSteamIn - PressureSteamJacket);
  FlowCondensate := Beta / 100 * sqrt(PressureSteamJacket);
end;

//******************************************************************************

procedure ModelHEJInitialize(var AreaTank, AreaPipe, Beta, KHeatTransfer, RoLiquid, CpLiquid,                   // Технические параметры
                                 PSteamIn, TLiquidIn, PLiquidIn, AlphaLiquidIn, AlphaLiquidOut, AlphaSteamIn,   // Технологические переменные
                                 step,                                                                          // Дополнительные параметры
                                 LLiquid, TSteam, TLiquidOut, FlowLiquidIn, FlowLiquidOut,                      // Изменяющиесz переменные
                                 FlowSteamIn, FlowCondensate: double);
                                 stdcall; export;
var
  FilePath : string;
  IniFile : TMemIniFile;
begin
  FilePath := '';
  FilePath := ExtractFilePath(paramstr(0)) + '\Bin\ModelHeatExchangerJacketed.ini';
  IniFile := TMemIniFile.Create(FilePath);

// Если изначально файл конфигурации не создан, то создаем его.
  if not (FileExists(IniFile.FileName)) then
  begin
// Технические параметры теплообменного аппарата
    IniFile.WriteFloat('Технические параметры теплообменника с паровой рубашкой',
                       'Площадь сечения бака, м^2', 1);
    IniFile.WriteFloat('Технические параметры теплообменника с паровой рубашкой',
                       'Площадь сечения трубы, м^2', 0.01);
    IniFile.WriteFloat('Технические параметры теплообменника с паровой рубашкой',
                       'Коэффициент конденсационного горшка, безразмерный', 0.5);
    IniFile.WriteFloat('Технические параметры теплообменника с паровой рубашкой',
                       'Коэффициент теплопередачи, Вт/(м^2 * К)', 100);
    IniFile.WriteFloat('Технические параметры теплообменника с паровой рубашкой',
                       'Плотность жидкости, кг/м^3', 1000);
    IniFile.WriteFloat('Технические параметры теплообменника с паровой рубашкой',
                       'Теплоемкость жидкости, Дж/К', 2);
// Начальные значения технологических переменных
    IniFile.WriteFloat('Начальные значения технологических переменных',
                       'Температура жидкости на входе в теплообменник, град.Цельсия (не более 200)', 100);
    IniFile.WriteFloat('Начальные значения технологических переменных',
                       'Давление жидкости на входе в теплообменник, кПа', 5);
    IniFile.WriteFloat('Начальные значения технологических переменных',
                       'Степень открытия клапана на притоке жидкости, %', 50);
    IniFile.WriteFloat('Начальные значения технологических переменных',
                       'Степень открытия клапана на стоке жидкости, %', 50);
    IniFile.WriteFloat('Начальные значения технологических переменных',
                       'Давление пара на входе в трубу рубашки, кПа', 1090);
    IniFile.WriteFloat('Начальные значения технологических переменных',
                       'Степень открытия клапана на паре, %', 8);
    IniFile.WriteFloat('Начальные значения технологических переменных',
                       'Уровень жидкости в емкости теплообменника, %', 50);
// Дополнительные параметры
    IniFile.WriteFloat('Дополнительные параметры',
                       'Шаг промежуточных вычислений', 0.1);
    IniFile.UpdateFile;
  end;

// Считываем данные из файла конфигурации
// Технические параметры теплообменного аппарата
  AreaTank := IniFile.ReadFloat('Технические параметры теплообменника с паровой рубашкой',
                                'Площадь сечения бака, м^2', 1);
  AreaPipe := IniFile.ReadFloat('Технические параметры теплообменника с паровой рубашкой',
                                'Площадь сечения трубы, м^2', 1);
  Beta := IniFile.ReadFloat('Технические параметры теплообменника с паровой рубашкой',
                            'Коэффициент конденсационного горшка, безразмерный', 0.5);
  KHeatTransfer := IniFile.ReadFloat('Технические параметры теплообменника с паровой рубашкой',
                                     'Коэффициент теплопередачи, Вт/(м^2 * К)', 100);
  RoLiquid := IniFile.ReadFloat('Технические параметры теплообменника с паровой рубашкой',
                                'Плотность жидкости, кг/м^3', 1000);
  CpLiquid := IniFile.ReadFloat('Технические параметры теплообменника с паровой рубашкой',
                                'Теплоемкость жидкости, Дж/К', 2);
// Начальные значения технологических переменных
  TLiquidIn := IniFile.ReadFloat('Начальные значения технологических переменных',
                                'Температура жидкости на входе в теплообменник, град.Цельсия (не более 200)', 100);
  PLiquidIn := IniFile.ReadFloat('Начальные значения технологических переменных',
                                 'Давление жидкости на входе в теплообменник, кПа', 5) * 1000;
  AlphaLiquidIn := IniFile.ReadFloat('Начальные значения технологических переменных',
                                     'Степень открытия клапана на притоке жидкости, %', 50) / 10000;
  AlphaLiquidOut := IniFile.ReadFloat('Начальные значения технологических переменных',
                                       'Степень открытия клапана на стоке жидкости, %', 50) / 10000;
  PSteamIn := IniFile.ReadFloat('Начальные значения технологических переменных',
                                 'Давление пара на входе в трубу рубашки, кПа', 1090) * 1000;
  AlphaSteamIn := IniFile.ReadFloat('Начальные значения технологических переменных',
                                   'Степень открытия клапана на паре, %', 8) / 100;
  LLiquid := IniFile.ReadFloat('Начальные значения технологических переменных',
                               'Уровень жидкости в емкости теплообменника, %', 50) / 100;
// Дополнительные параметры
  Step := IniFile.ReadFloat('Дополнительные параметры',
                            'Шаг промежуточных вычислений', 0.1);

// Инициализируем оставшиеся переменные
  TSteam := 0;
  TLiquidOut := TliquidIn;
  FlowLiquidIn := 0;
  FlowLiquidOut := 0;
  FlowSteamIn := 0;
  FlowCondensate := 0;
end;

//*****************************************************************************

exports ModelHEJCalculate name 'ModelHEJCalculate';
exports ModelHEJInitialize name 'ModelHEJInitialize';

//******************************************************************************

begin
end.
