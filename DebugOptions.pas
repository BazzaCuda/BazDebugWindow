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
  // Do not localize
  Settings := TRegIniFile.Create('Software\Baz\Debug');
  try
    Start := Settings.ReadBool('View', 'Startup', False);
    OnMessage := Settings.ReadBool('View', 'OnMessage', False);
    Bottom := Settings.ReadBool('Messages', 'Bottom', False);
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
    Settings.WriteBool('View', 'Startup', Start);
    Settings.WriteBool('View', 'OnMessage', OnMessage);
    Settings.WriteBool('Messages', 'Bottom', Bottom);
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
