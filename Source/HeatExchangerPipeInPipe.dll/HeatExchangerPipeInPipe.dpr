{************************************************************}
{                                                            }
{           ���������� "HeatExchangerPipeInPipe.dll"         }
{                Copyright (c) 2010 "BolkodaB"               }
{                                                            }
{  �����������: �������� �.�.                                }
{  �������������: 30.04.2010                                 }
{  ������:        0.1.0.0                                    }
{************************************************************}

library HeatExchangerPipeInPipe;

uses
  SysUtils,
  Forms,
  uHeatExchangerPipeInPipe in 'uHeatExchangerPipeInPipe.pas' {HeatExchangerPipeInPipeForm},
  ufrmHeatExchangerPipeInPipe in 'ufrmHeatExchangerPipeInPipe.pas' {frmHeatExchangerPipeInPipe: TFrame};

{$R *.res}

procedure StartHeatExchangerPipeInPipe; stdcall; export;
begin
  HeatExchangerPipeInPipeForm := THeatExchangerPipeInPipeForm.Create(Application);
  HeatExchangerPipeInPipeForm.ShowModal;
end;

exports StartHeatExchangerPipeInPipe name 'StartHeatExchangerPipeInPipe';

begin
end.
