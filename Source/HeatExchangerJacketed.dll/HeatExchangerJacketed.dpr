{************************************************************}
{                                                            }
{             Библиотека "HeatExchangerJacketed.dll"         }
{                Copyright (c) 2010 "BolkodaB"               }
{                                                            }
{  Разработчик: Максимов Р.Ю.                                }
{  Модифицирован: 4.03.2010                                  }
{  Версия:        0.1.0.0                                    }
{************************************************************}

library HeatExchangerJacketed;

uses
  SysUtils,
  Forms,
  uHeatExchangerJacketed in 'uHeatExchangerJacketed.pas' {HeatExchangerForm},
  ufmHeatExchangerJacketed in 'ufmHeatExchangerJacketed.pas' {frmHeatExchanger: TFrame},
  uHeatExchangerJacketedGraphics in 'uHeatExchangerJacketedGraphics.pas' {HeatExchangerGraphicsForm},
  ufmHeatExchangerJacketedGraphics in 'ufmHeatExchangerJacketedGraphics.pas' {frmHeatExchangerGraphics: TFrame},
  Unit1 in 'Unit1.pas' {Form1};

{$R *.res}

procedure StartHeatExchangerJacketed; stdcall; export;
begin
  HeatExchangerForm := THeatExchangerForm.Create(Application);
  HeatExchangerGraphicsForm := THeatExchangerGraphicsForm.Create(Application);
  Form1 := TForm1.Create(Application);
  HeatExchangerForm.Show;
end;

exports StartHeatExchangerJacketed name 'StartHeatExchangerJacketed';

begin
end.
