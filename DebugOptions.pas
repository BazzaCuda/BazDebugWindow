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
unit DebugOptions;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls;

type
  TDebugConfigData = class(TObject)
  public
    Start: Boolean;
    OnMessage: Boolean;
    Bottom: Boolean;
    constructor Create;
    procedure SaveSettings;
    procedure LoadSettings;
  end;

type
  TfmDebugOptions = class(TForm)
    gbxView: TGroupBox;
    chkShowOnStartup: TCheckBox;
    chkShowOnMessage: TCheckBox;
    gbxMessages: TGroupBox;
    chkNewAtBottom: TCheckBox;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  end;

var
  ConfigInfo: TDebugConfigData = nil;
  fmDebugOptions: TfmDebugOptions;

implementation

uses Registry{, GX_GenericUtils}; // BAZ

{$R *.dfm}

constructor TDebugConfigData.Create;
begin
  inherited Create;

  LoadSettings;
end;

procedure TDebugConfigData.LoadSettings;
var
  Settings: TRegIniFile;
begin
  Settings := TRegIniFile.Create('Software\Baz\Debug'); // Do not localize
  try
    Start := Settings.ReadBool('View', 'startup', False);
    OnMessage := Settings.ReadBool('View', 'onMessage', TRUE);
    Bottom := Settings.ReadBool('Messages', 'bottom', False);
  finally
    FreeAndNil(Settings);
  end;
end;

procedure TDebugConfigData.SaveSettings;
var
  Settings: TRegIniFile;
begin
  Settings := TRegIniFile.Create('Software\Baz\Debug');
  try
    Settings.WriteBool('View', 'startup', Start);
    Settings.WriteBool('View', 'onMessage', OnMessage);
    Settings.WriteBool('Messages', 'bottom', Bottom);
  finally
    FreeAndNil(Settings);
  end;
end;

procedure TfmDebugOptions.FormCreate(Sender: TObject);
begin
//  SetDefaultFont(Self); // BAZ
  chkShowOnStartup.Checked := ConfigInfo.Start;
  chkShowOnMessage.Checked := ConfigInfo.OnMessage;
  chkNewAtBottom.Checked := ConfigInfo.Bottom;
end;

procedure TfmDebugOptions.btnOKClick(Sender: TObject);
begin
  ConfigInfo.Start := chkShowOnStartup.Checked;
  ConfigInfo.OnMessage := chkShowOnMessage.Checked;
  ConfigInfo.Bottom := chkNewAtBottom.Checked;
  ConfigInfo.SaveSettings;
  ModalResult := mrOk;
end;

initialization
  ConfigInfo := TDebugConfigData.Create;

finalization
  FreeAndNil(ConfigInfo);

end.
