(*
 * GExperts Debug Window Interface
 * http://www.gexperts.org
 *
 * You are free to use this code in any application to send commands to the
 * GExperts debug window.  This includes usage in commercial, shareware,
 * freeware, public domain, and other applications.
 *)

 //
 // Baz Cuda, 2022: Renamed, rejigged, camelhumped and augmented.
 //                 All credit rests with the original authors for this very handy tool.
program BazDebugWindow;

uses
  Windows,
  Forms,
  DebugOptions in 'DebugOptions.pas' {fmDebugOptions},
  DebugWindow in 'DebugWindow.pas' {fmDebug},
  Vcl.Themes,
  Vcl.Styles,
  registry, classes, strUtils, sysUtils;

{$R *_icon.res}
{$R *.res}

var
  PrvHWND: HWND;

  function writeToReg(aPath: string): boolean;
  begin
    result := FALSE;
    var reg := TRegistry.create(KEY_WRITE);
    try
      reg.rootKey := HKEY_CURRENT_USER;
      case reg.openKey('\Software\Baz\Debug\', TRUE) of FALSE: EXIT; end;
      reg.writeString('filePath', aPath);
      reg.writeString('width', '500');
      reg.writeString('height', '320');
      reg.writeString('viewToolbar', '1');
      reg.writeString('stayOnTop', '0');
      reg.closeKey;
      case reg.openKey('\Software\Baz\Debug\Messages\', TRUE) of FALSE: EXIT; end;
      reg.writeString('onMessages', '1');
      reg.closeKey;
    finally
      reg.free;
    end;
    result := TRUE;
  end;

  function writeToRegFile(aPath: string): boolean;
  begin
    result := FALSE;
    var SL := TStringList.create;
    try
      SL.add('Windows Registry Editor Version 5.00');
      SL.add('');
      SL.add('[HKEY_CURRENT_USER\SOFTWARE\Baz]');
      SL.add('');
      SL.add('[HKEY_CURRENT_USER\SOFTWARE\Baz\Debug]');
      SL.add(replaceStr(aPath, '\', '\\'));
      SL.add('"height"="320"');
      SL.add('"stayOnTop"="0"');
      SL.add('"viewToolBar"="1"');
      SL.add('"width"="500"');
      SL.add('');
      SL.add('[HKEY_CURRENT_USER\SOFTWARE\Baz\Debug]');
      SL.add('"onMessage"="1"');
      SL.saveToFile(extractFilePath(aPath) + 'registerExe.reg');
    finally
      SL.free;
    end;
    result := TRUE;
  end;

begin
  ReportMemoryLeaksOnShutdown := TRUE;

  Application.Initialize;
  Application.Title := '';

  PrvHWND := FindWindow('TApplication', 'Baz Debug Window');
  case PrvHWND <> 0 of TRUE:  begin
                                case IsIconic(PrvHWND) of TRUE: ShowWindow(PrvHWND, SW_RESTORE); end;
//                                SetForegroundWindow(PrvHWND);
                                HALT; end;end;

  // write app location to registry so it can find itself ("Hommmmmmmm")
  case writeToReg(paramStr(0)) of FALSE: writeToRegFile(paramStr(0)); end;
//  writeToRegFile(paramStr(0)); // TEST;

  Application.ShowMainForm      := ConfigInfo.Start;
  Application.Title             := 'Baz Debug Window'; // Do not localize.
  Application.ShowMainForm      := FALSE;
  Application.MainFormOnTaskBar := TRUE;
  TStyleManager.TrySetStyle('Charcoal Dark Slate');
  Application.CreateForm(TfmDebug, fmDebug);
  Application.Run;
end.
