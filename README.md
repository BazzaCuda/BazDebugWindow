# BazDebugWindow

**NEW 2025/05/12**

- _debugWindow.pas now references an include file: bazDebugWindow.inc
- The .inc file defines `const BazDebugWindow = TRUE;` or `const BazDebugWindow = FALSE;`
- This enables or disables the definition of the procedures in _debugWindow.pas
- Your project should have its own individual copy of bazDebugWindow.inc
- Drag and Drop the file onto the Project Explorer in the Delphi IDE to make it visible to the code
- In each project, you can now make calls to the debug procedures conditional at compile time based on the TRUE/FALSE value of the const:
   ``` Delphi
    {$if BazDebugWindow}
      debugFormat('openFile: %s', [sFileToOpen]);
    {$endif}
    ```
    
**NEW** 

Added 
``` Delphi
TDebug.debugEnum<T>()
```
allowing you to pass a variable of any enumerated type and have its value reported:
``` Delphi
    type
         TMediaType = (mtAudio, mtVideo);
    var            
         FMediaType: TMediaType;
    begin
         FMediaType := mtAudio;
         TDebug.debugEnum<TMediaType>('FMediaType', FMediaType);
    end;
```
![Clipboard Image (1)](https://github.com/BazzaCuda/BazDebugWindow/assets/22550919/6bab8900-b929-407f-bb70-0bd6c27764b0)

BazDebugWindow is a reworking of the original DebugWindow by GExperts, renamed as per their licensing requirements.

A very useful tool for Delphi developers - say "goodbye" to all those `ShowMessage(...)` calls while trying to debug your program.

![BazDebugWindow](https://github.com/BazzaCuda/BazDebugWindow/assets/22550919/8beab9d4-c578-4ab5-8d58-500f7d847769)

The BazDebugWindow will pop-up in the bottom righthand corner of your Windows desktop when you send it a debug message.

This is very easily done: just add the `_debugWindow.pas` unit to your project and include it in the "uses" clause of any unit.
N.B. You don't need to copy the unit to every project. Just add it from its current location.

At its most basic, just call _`debug('some string')`_ from anywhere in your code for it to appear in the BazDebugWindow.

There are numerous other calls which can be made which I will detail below.

Initial Installation
--------------------

1. Download the latest BazDebugWindow_release_v1_n_n.zip file from "Releases" and unzip it to a folder of your choice.
2. Note that the folder now also contains the _debugWindow.pas unit for inclusion in your project.
3. Run the BazDebugWindow.exe - it will appear minimized in the system tray on your desktop.

When the app runs, it will try to write it's installation location to the registry at
[HKEY_CURRENT_USER\SOFTWARE\Baz\Debug]

If this fails, it will create a "registerExe.reg" file so that you can do this yourself.
Once this registry entry has been created, any call to "debug(...)" or any of the other debug methods at any time will launch BazDebugWindow.exe if it's not already running.
You don't need to remember to launch it yourself before running the program you're debugging.

N.B. If necessary, you can move BazDebugWindow.exe to a different folder, or rename the folder it's currently in. 
If you do this, you must run the exe immediately to register its new location.

BazDebugWindow methods
----------------------
``` Delphi
procedure debug(const msg: string);

procedure debugBoolean(const identifier: string; const value: boolean);

procedure debugCardinal(const identifier: string; const value: cardinal);

procedure debugClear; // this won't cause the window to pop-up - suggested location: in your .dpr file

procedure debugDateTime(const identifier: string; const value: TDateTime);

procedure TDebug.debugEnum\<T\>(const identifier: string; const value: \<T\>);

procedure debugDouble(const identifier: string; const value: double);

procedure debugError(const msg: string);

procedure debugEx(const msg: string; MType: TMsgDlgType);

procedure debugFormat(const msg: string; const args: array of const);

procedure debugFormatEx(const msg: string; const args: array of const; MType: TmsgDlgType);

procedure debugIndent;

procedure debugint64(const identifier: string; const value: int64);

procedure debuginteger(const identifier: string; const value: integer);

procedure debugMethodEnter(const methodName: string);

procedure debugMethodExit(const methodName: string);

procedure debugOutdent;

procedure debugPause;

procedure debugResume;

procedure debugSeparator;

procedure debugString(const identifier: string; const value: string);

procedure debugStringList(const identifier: string; const value: TStringList);

procedure debugWarning(const msg: string);
```

More details to follow
----------------------

I will expand on each of these later - I just wanted to get a basic "readme" file into the first release.zip file.

Any questions or issues, go to Discussions (https://github.com/BazzaCuda/BazDebugWindow/discussions)

regards,
Baz.










 
