{************************************************************}
{                                                            }
{         ���������� "ModelHeatExchangerJacketed.dll"        }
{                Copyright (c) 2010 "BolkodaB"               }
{                                                            }
{  �����������: �������� �.�.                                }
{  �������������: 6.03.2010                                  }
{  ������:        0.6.0.0                                    }
{************************************************************}

library ModelHeatExchangerJacketed;

uses
  Windows, SysUtils, Classes,
  IniFiles;                      // ������ Delphi

{$R *.res}

//******************************************************************************

procedure ModelHEJCalculate(AreaTank, AreaPipe, Beta, KHeatTransfer, RoLiquid, CpLiquid,                  // ����������� ���������
                            PSteamIn, TLiquidIn, PLiquidIn, AlphaLiquidIn, AlphaLiquidOut, AlphaSteamIn,  // ��������������� ����������
                            Step: double;                                                                 // �������������� ���������
                            var LevelLiquid, TSteam, TLiquidOut, FlowLiquidIn, FlowLiquidOut,             // ������������ ����������
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

{ ������ ������� �� ������� �����-�����:
  �������������� ������������ k1, k2, k3, k4 - ��� ������� ������
  �������������� ������������ m1, m2, m3, m4 - ��� ������� �����������. }

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

// ������ ����������� � ������
  LevelLiquid := LevelLiquid + (k1 + 2 * k2 + 2 * k3 + k4) / 6;
  if (LevelLiquid >= 1) then LevelLiquid := 1 else if (LevelLiquid <= 0.01) then LevelLiquid := 0.01;
  TLiquidOut := TLiquidOut + (m1 + 2 * m2 + 2 * m3 + m4) / 6;
  if (LevelLiquid <= 0.02) then TLiquidOut := 0;


// ����� ���������� � �������� �������� � �����������
  FlowLiquidIn := AlphaLiquidIn * 100 * AreaPipe * sqrt(PLiquidIn);
  FlowLiquidOut := AlphaLiquidOut * 100 * AreaPipe * sqrt(RoLiquid*10*LevelLiquid);
  FlowSteamIn := AlphaSteamIn / 100 * sqrt(PSteamIn - PressureSteamJacket);
  FlowCondensate := Beta / 100 * sqrt(PressureSteamJacket);
end;

//******************************************************************************

procedure ModelHEJInitialize(var AreaTank, AreaPipe, Beta, KHeatTransfer, RoLiquid, CpLiquid,                   // ����������� ���������
                                 PSteamIn, TLiquidIn, PLiquidIn, AlphaLiquidIn, AlphaLiquidOut, AlphaSteamIn,   // ��������������� ����������
                                 step,                                                                          // �������������� ���������
                                 LLiquid, TSteam, TLiquidOut, FlowLiquidIn, FlowLiquidOut,                      // �����������z ����������
                                 FlowSteamIn, FlowCondensate: double);
                                 stdcall; export;
var
  FilePath : string;
  IniFile : TMemIniFile;
begin
  FilePath := '';
  FilePath := ExtractFilePath(paramstr(0)) + '\Bin\ModelHeatExchangerJacketed.ini';
  IniFile := TMemIniFile.Create(FilePath);

// ���� ���������� ���� ������������ �� ������, �� ������� ���.
  if not (FileExists(IniFile.FileName)) then
  begin
// ����������� ��������� �������������� ��������
    IniFile.WriteFloat('����������� ��������� �������������� � ������� ��������',
                       '������� ������� ����, �^2', 1);
    IniFile.WriteFloat('����������� ��������� �������������� � ������� ��������',
                       '������� ������� �����, �^2', 0.01);
    IniFile.WriteFloat('����������� ��������� �������������� � ������� ��������',
                       '����������� ���������������� ������, ������������', 0.5);
    IniFile.WriteFloat('����������� ��������� �������������� � ������� ��������',
                       '����������� �������������, ��/(�^2 * �)', 100);
    IniFile.WriteFloat('����������� ��������� �������������� � ������� ��������',
                       '��������� ��������, ��/�^3', 1000);
    IniFile.WriteFloat('����������� ��������� �������������� � ������� ��������',
                       '������������ ��������, ��/�', 2);
// ��������� �������� ��������������� ����������
    IniFile.WriteFloat('��������� �������� ��������������� ����������',
                       '����������� �������� �� ����� � �������������, ����.������� (�� ����� 200)', 100);
    IniFile.WriteFloat('��������� �������� ��������������� ����������',
                       '�������� �������� �� ����� � �������������, ���', 5);
    IniFile.WriteFloat('��������� �������� ��������������� ����������',
                       '������� �������� ������� �� ������� ��������, %', 50);
    IniFile.WriteFloat('��������� �������� ��������������� ����������',
                       '������� �������� ������� �� ����� ��������, %', 50);
    IniFile.WriteFloat('��������� �������� ��������������� ����������',
                       '�������� ���� �� ����� � ����� �������, ���', 1090);
    IniFile.WriteFloat('��������� �������� ��������������� ����������',
                       '������� �������� ������� �� ����, %', 8);
    IniFile.WriteFloat('��������� �������� ��������������� ����������',
                       '������� �������� � ������� ��������������, %', 50);
// �������������� ���������
    IniFile.WriteFloat('�������������� ���������',
                       '��� ������������� ����������', 0.1);
    IniFile.UpdateFile;
  end;

// ��������� ������ �� ����� ������������
// ����������� ��������� �������������� ��������
  AreaTank := IniFile.ReadFloat('����������� ��������� �������������� � ������� ��������',
                                '������� ������� ����, �^2', 1);
  AreaPipe := IniFile.ReadFloat('����������� ��������� �������������� � ������� ��������',
                                '������� ������� �����, �^2', 1);
  Beta := IniFile.ReadFloat('����������� ��������� �������������� � ������� ��������',
                            '����������� ���������������� ������, ������������', 0.5);
  KHeatTransfer := IniFile.ReadFloat('����������� ��������� �������������� � ������� ��������',
                                     '����������� �������������, ��/(�^2 * �)', 100);
  RoLiquid := IniFile.ReadFloat('����������� ��������� �������������� � ������� ��������',
                                '��������� ��������, ��/�^3', 1000);
  CpLiquid := IniFile.ReadFloat('����������� ��������� �������������� � ������� ��������',
                                '������������ ��������, ��/�', 2);
// ��������� �������� ��������������� ����������
  TLiquidIn := IniFile.ReadFloat('��������� �������� ��������������� ����������',
                                '����������� �������� �� ����� � �������������, ����.������� (�� ����� 200)', 100);
  PLiquidIn := IniFile.ReadFloat('��������� �������� ��������������� ����������',
                                 '�������� �������� �� ����� � �������������, ���', 5) * 1000;
  AlphaLiquidIn := IniFile.ReadFloat('��������� �������� ��������������� ����������',
                                     '������� �������� ������� �� ������� ��������, %', 50) / 10000;
  AlphaLiquidOut := IniFile.ReadFloat('��������� �������� ��������������� ����������',
                                       '������� �������� ������� �� ����� ��������, %', 50) / 10000;
  PSteamIn := IniFile.ReadFloat('��������� �������� ��������������� ����������',
                                 '�������� ���� �� ����� � ����� �������, ���', 1090) * 1000;
  AlphaSteamIn := IniFile.ReadFloat('��������� �������� ��������������� ����������',
                                   '������� �������� ������� �� ����, %', 8) / 100;
  LLiquid := IniFile.ReadFloat('��������� �������� ��������������� ����������',
                               '������� �������� � ������� ��������������, %', 50) / 100;
// �������������� ���������
  Step := IniFile.ReadFloat('�������������� ���������',
                            '��� ������������� ����������', 0.1);

// �������������� ���������� ����������
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
