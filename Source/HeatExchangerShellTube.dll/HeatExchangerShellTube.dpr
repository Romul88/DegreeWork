library HeatExchangerShellTube;


uses
  Windows,
  SysUtils,
  Forms,
  uHeatExchangerShellTube in 'uHeatExchangerShellTube.pas' {HeatExchangerShellTubeForm},
  ufmHeatExchangerShellTube in 'ufmHeatExchangerShellTube.pas' {frmHeatExchangerShellTube: TFrame};

{$R *.res}

procedure CreateV; stdcall; export;
begin
  HeatExchangerShellTubeForm := THeatExchangerShellTubeForm.Create(Application);
  HeatExchangerShellTubeForm.Show;
end;

exports CreateV name 'VCreate';

begin
end.



