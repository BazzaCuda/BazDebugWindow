# BazDebugWindow

BazDebugWindow is a reworking of the original DebugWindow by GExperts, renamed as per their licensing requirements.

A very useful tool for Delphi developers - say "goodbye" to all those ShowMessage(...) calls while trying to debug your program.

![Clipboard Image](https://github.com/BazzaCuda/BazDebugWindow/assets/22550919/ca3ac051-2db6-4d99-beca-a6831e49dd55)

The BazDebugWindow will pop-up in the bottom righthand corner of your Windows desktop when you send it a debug message.

This is very easily done: just add the _debugWindow.pas unit to your project and include it in the "uses" clause of any unit.
N.B. You don't need to copy the unit to every project. Just add it from its current location.

At its most basic, just call _"debug('some string')"_ from anywhere in your code for it to appear in the BazDebugWindow.

There are numerous other calls which can be made which I will detail below.

Initial Installation
--------------------

1. Download the _debugWindow.pas unit from the source code and save it to any folder.
2. Download the latest debugWindow_release_v1_n_n.zip file from "Releases" and unzip it to a folder of your choice.
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

procedure debug(const msg: string);

procedure debugBoolean(const identifier: string; const value: boolean);

procedure debugCardinal(const identifier: string; const value: cardinal);

procedure debugClear; // this won't cause the window to pop-up - suggested location: in your .dpr file

procedure debugDateTime(const identifier: string; const value: TDateTime);

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

More details to follow
----------------------

I will expand on each of these later - I just wanted to get a basic "readme" file into the first release.zip file.

Any questions or issues, go to Discussions (https://github.com/BazzaCuda/BazDebugWindow/discussions)

regards,
Baz.










 
