program BazDebugWindow;

uses
  Windows,
  Forms,
  DebugOptions in 'DebugOptions.pas' {fmDebugOptions},
  DebugWindow in 'DebugWindow.pas' {fmDebug},
  Vcl.Themes,
  Vcl.Styles;

{$R *_icon.res}
{$R *.res}

var
  PrvHWND: HWND;

begin
  ReportMemoryLeaksOnShutdown := TRUE;

  // Project Relative Search Path:  ..\..\Utils\;..\..\Framework\;..\..\..\ExternalSource\UniSynEdit
  Application.Initialize;
  Application.Title := '';

  PrvHWND := FindWindow('TApplication', 'Baz Debug Window');
  case PrvHWND <> 0 of TRUE:  begin
//                                case IsIconic(PrvHWND) of TRUE: ShowWindow(PrvHWND, SW_RESTORE); end; // BAZ
//                                SetForegroundWindow(PrvHWND);                                         // BAZ
                                HALT; end;end;

  Application.ShowMainForm      := ConfigInfo.Start;
  Application.Title             := 'Baz Debug Window'; // Do not localize.
  Application.ShowMainForm      := FALSE;     // BAZ
  Application.MainFormOnTaskBar := TRUE;      // BAZ
  TStyleManager.TrySetStyle('Charcoal Dark Slate');
  Application.CreateForm(TfmDebug, fmDebug);
  Application.Run;
end.
