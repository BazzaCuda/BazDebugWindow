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
unit DebugWindow;

// {$I GX_CondDefine.inc} // BAZ

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ImgList, Menus, ComCtrls, TrayIcon, ActnList, ToolWin,
  System.Actions, System.ImageList;

type
  TfmDebug = class(TForm)
    pmuTaskBar: TPopupMenu;
    mitTrayShutdown: TMenuItem;
    mitTrayShow: TMenuItem;
    MainMenu: TMainMenu;
    mitFile: TMenuItem;
    mitClearWindow: TMenuItem;
    mitFileSep1: TMenuItem;
    mitFileShutdown: TMenuItem;
    mitFileExit: TMenuItem;
    mitFileOptions: TMenuItem;
    ilDebug: TImageList;
    lvMessages: TListView;
    mitEdit: TMenuItem;
    mitCopySelectedLines: TMenuItem;
    imgMessage: TImage;
    mitTrayClear: TMenuItem;
    mitSaveToFile: TMenuItem;
    dlgSaveLog: TSaveDialog;
    tbnClear: TToolButton;
    tbnCopy: TToolButton;
    tbnSave: TToolButton;
    tbnSep1: TToolButton;
    Actions: TActionList;
    actFileOptions: TAction;
    actFileShutdown: TAction;
    actFileHideWindow: TAction;
    actEditCopySelectedLines: TAction;
    actEditClearWindow: TAction;
    actEditSaveToFile: TAction;
    actViewShow: TAction;
    actShowItemInDialog: TAction;
    ToolBar: TToolBar;
    tbnSep2: TToolButton;
    tbnOptions: TToolButton;
    tbnPause: TToolButton;
    actFilePause: TAction;
    mitFilePause: TMenuItem;
    pmuListbox: TPopupMenu;
    mitListClearWindow: TMenuItem;
    mitListShowItem: TMenuItem;
    mitView: TMenuItem;
    actViewStayOnTop: TAction;
    actViewToolBar: TAction;
    mitViewShowToolBar: TMenuItem;
    mitViewStayOnTop: TMenuItem;
    actEditSelectAll: TAction;
    mitEditSelectAll: TMenuItem;
    mitListSelectAll: TMenuItem;
    ilImages: TImageList;
    ilDisabled: TImageList;
    procedure TrayIconDblClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lvMessagesDblClick(Sender: TObject);
    procedure actEditCopySelectedLinesExecute(Sender: TObject);
    procedure actEditClearWindowExecute(Sender: TObject);
    procedure actEditSaveToFileExecute(Sender: TObject);
    procedure actFileOptionsExecute(Sender: TObject);
    procedure actFileShutdownExecute(Sender: TObject);
    procedure actFileHideWindowExecute(Sender: TObject);
    procedure actViewShowExecute(Sender: TObject);
    procedure actShowItemInDialogExecute(Sender: TObject);
    procedure actShowItemInDialogUpdate(Sender: TObject);
    procedure actFilePauseExecute(Sender: TObject);
    procedure ActionsUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure actViewToolBarExecute(Sender: TObject);
    procedure actViewStayOnTopExecute(Sender: TObject);
    procedure actEditSelectAllExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject); // BAZ
  private
    FAllowClose: Boolean;
    FStayOnTop: Boolean;
    FTaskIcon: TTrayIcon;
    procedure SetStayOnTop(OnTop: Boolean);
    procedure SaveSettings;
    procedure LoadSettings;
    procedure ApplicationMsgHandler(var Msg: TMsg; var Handled: Boolean);
    procedure WMEndSession(var Message: TMessage); message WM_ENDSESSION;
    procedure WMCopyData(var Message: TWMCopyData); message WM_COPYDATA;
    procedure WMQueryEndSession(var Message: TMessage); message WM_QUERYENDSESSION;
    property  StayOnTop: Boolean read FStayOnTop write SetStayOnTop;
    procedure setWindowPosBottomRight; // BAZ
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create(AOwner: TComponent); override; // BAZ
    destructor Destroy; override;
  end;

  TGXUnicodeChar    = WideChar;                       // BAZ
  TGXUnicodeString  = WideString;                     // BAZ

var
  fmDebug: TfmDebug;

implementation

{$R *.dfm}

uses
  Clipbrd, Registry, DebugOptions;                    // BAZ

type
  TDebugType = (dtAnsiMessage, dtUnicodeMessage, dtSQL, dtCommand);

  TDebugMessage = record
    DebugType: TDebugType;
    MessageType: TMsgDlgType;
    AnsiMsg: AnsiString;
    UnicodeMsg:TGXUnicodeString;
  end;

const
  TopMenu = 100;

{ TfmDebug }

procedure TfmDebug.setWindowPosBottomRight;  // BAZ
begin
  var vRect := Screen.WorkAreaRect;
  setWindowPos(handle, 0, vRect.right - width, vRect.bottom - height, 0, 0, SWP_NOSIZE); // always position in bottom right-hand corner
end;

procedure TfmDebug.WMCopyData(var Message: TWMCopyData);
var
  NewMsg:       TDebugMessage;
  ListItem:     TListItem;
  vClearWindow: boolean; // BAZ

  procedure AddMessage(MessageType: TMsgDlgType; const MessageText: string);
  begin
    if ConfigInfo.Bottom or (lvMessages.Items.Count = 0) then
    begin
      ListItem := lvMessages.Items.Add;
      ListItem.MakeVisible(True);
    end
    else
      ListItem := lvMessages.Items.Insert(0);
    ListItem.Caption := MessageText;
    ListItem.ImageIndex := Ord(MessageType);
    ListItem.SubItems.Add(TimeToStr(Time));
  end;

  procedure GetMessage;
  const
    chrDebugTypeANSI    = #1;
    chrDebugTypeSQL     = #2;
    chrClearCommand     = #3;
    chrDebugTypeUnicode = #4;
  var
    CData: TCopyDataStruct;
    MessageContent: PAnsiChar;
    i: Integer;
    CharWord: Word;
    UChar: TGXUnicodeChar;
  begin
    CData := Message.CopyDataStruct^;
    MessageContent := CData.lpData; // TODO: Make this use the passed-in byte count for the payload length
    vClearWindow := MessageContent[0] = chrClearCommand; // BAZ
    if MessageContent[0] = chrClearCommand then
    begin
      NewMsg.DebugType := dtCommand;
      actEditClearWindow.Execute;
      Exit;
    end;

    if MessageContent[0] = chrDebugTypeSQL then
      NewMsg.DebugType := dtSQL
    else if MessageContent[0] = chrDebugTypeUnicode then
      NewMsg.DebugType := dtUnicodeMessage
    else
      NewMsg.DebugType := dtAnsiMessage;

    NewMsg.MessageType := TMsgDlgType(Integer(MessageContent[1]) - 1);
    i := 2; // Byte 0 = payload, Byte 1 = message type
    while MessageContent[i] <> #0 do
    begin
      if NewMsg.DebugType = dtUnicodeMessage then
      begin
        WordRec(CharWord).Lo := Byte(MessageContent[i]);
        WordRec(CharWord).Hi := Byte(MessageContent[i+1]);
        UChar := TGXUnicodeChar(CharWord);
        NewMsg.UnicodeMsg := NewMsg.UnicodeMsg + UChar; // TODO: This is very slow....
        Inc(i, 2);
      end
      else
      begin
        NewMsg.AnsiMsg := NewMsg.AnsiMsg + MessageContent[i];
        Inc(i);
      end;
    end;
  end;

var
  OldClientWidth: Integer;
begin
  GetMessage;
  if actFilePause.Checked then
    Exit;
  OldClientWidth := lvMessages.ClientWidth;
  if NewMsg.DebugType = dtAnsiMessage then
    AddMessage(NewMsg.MessageType, string(NewMsg.AnsiMsg))
  else if NewMsg.DebugType = dtUnicodeMessage then
    AddMessage(NewMsg.MessageType, NewMsg.UnicodeMsg);
  // Resize the header when the scrollbar is added
  if not (lvMessages.ClientWidth = OldClientWidth) then
    FormResize(Self);
  if not Visible then
    FTaskIcon.Icon := imgMessage.Picture.Icon;
  if (ConfigInfo.OnMessage) and NOT vClearWindow then // BAZ don't show the window just because of a clearWindow command
    actViewShow.Execute;
end;

procedure TfmDebug.TrayIconDblClick(Sender: TObject);
begin
  actViewShow.Execute;
end;

procedure TfmDebug.FormResize(Sender: TObject);
begin
  if lvMessages.ClientWidth > 100 then
    lvMessages.Column[0].Width := lvMessages.ClientWidth - lvMessages.Column[1].Width;
end;

procedure TfmDebug.FormShow(Sender: TObject);
begin
  FTaskIcon.Icon := Icon;
  FormResize(Self);
  MainMenu.Images := ilImages;
end;

procedure TfmDebug.SetStayOnTop(OnTop: Boolean);
begin
  FStayOnTop := OnTop;
  if OnTop then
    SetWindowPos(Self.Handle, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE)
  else
    SetWindowPos(Self.Handle, HWND_NOTOPMOST, 0, 0, 0, 0, SWP_NOMOVE + SWP_NOSIZE);
end;

procedure TfmDebug.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := FAllowClose;
  if not CanClose then
    Hide;
end;

procedure TfmDebug.FormCreate(Sender: TObject); // BAZ
begin
  popupMode   := pmExplicit;
  borderIcons := [biSystemMenu];
  setWindowPosBottomRight;
  position    := poDesigned;
end;

procedure TfmDebug.SaveSettings;
var
  Settings: TRegIniFile;
begin
  Settings := TRegIniFile.Create('Software\Baz');
  try
//    Settings.WriteInteger('Debug', 'left', Left); // BAZ
//    Settings.WriteInteger('Debug', 'top', Top);   // BAZ
    Settings.WriteInteger('Debug', 'width', Width);
    Settings.WriteInteger('Debug', 'height', Height);
    Settings.WriteString('Debug', 'savePath', dlgSaveLog.InitialDir);
    Settings.WriteBool('Debug', 'viewToolBar', ToolBar.Visible);
    Settings.WriteBool('Debug', 'stayOnTop', FStayOnTop);
  finally
    FreeAndNil(Settings);
  end;
end;

procedure TfmDebug.LoadSettings;
var
  Settings: TRegIniFile;
begin
  setWindowPosBottomRight; // BAZ

//  Left := (Screen.Width - Width) div 2;  // BAZ
//  Top := (Screen.Height - Height) div 2; // BAZ

  Settings := TRegIniFile.Create('Software\Baz');
  try
//    Left := Settings.ReadInteger('Debug', 'Left', Left); // BAZ
//    Top := Settings.ReadInteger('Debug', 'Top', Top);    // BAZ
    Width := Settings.ReadInteger('Debug', 'width', Width);
    Height := Settings.ReadInteger('Debug', 'height', Height);
    ToolBar.Visible := Settings.ReadBool('Debug', 'viewToolBar', True);
    StayOnTop := Settings.ReadBool('Debug', 'stayOnTop', False);
    dlgSaveLog.InitialDir := Settings.ReadString('Debug', 'savePath', '');
  finally
    FreeAndNil(Settings);
  end;
end;

procedure TfmDebug.ApplicationMsgHandler(var Msg: TMsg; var Handled: Boolean);
begin
  if (Msg.Message = WM_SYSCOMMAND) and (Msg.wParam = SC_RESTORE) then Show;
end;

procedure TfmDebug.WMEndSession(var Message: TMessage);
begin
  FAllowClose := True;
  Close;

  inherited;
end;

procedure TfmDebug.WMQueryEndSession(var Message: TMessage);
begin
  FTaskIcon.Active := False;
  FAllowClose := True;
  Close;

  inherited;
end;

procedure TfmDebug.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfmDebug.lvMessagesDblClick(Sender: TObject);
begin
  actShowItemInDialog.Execute;
end;

procedure TfmDebug.actEditCopySelectedLinesExecute(Sender: TObject);
var
  CopyStrings: TStrings;
  i: Integer;
  ListItem: TListItem;
  NewLine: string;
begin
  CopyStrings := TStringList.Create;
  try
    for i := 0 to lvMessages.Items.Count - 1 do
    begin
      if lvMessages.Items[i].Selected then
      begin
        ListItem := lvMessages.Items[i];
        NewLine := Format('%d'#9'%s'#9'%s', [ListItem.ImageIndex, ListItem.Caption,
                                             ListItem.SubItems[0]]);
        CopyStrings.Add(NewLine);
      end;
    end;
    Clipboard.AsText := CopyStrings.Text;
  finally
    FreeAndNil(CopyStrings);
  end;
end;

procedure TfmDebug.actEditClearWindowExecute(Sender: TObject);
begin
  lvMessages.Items.BeginUpdate;
  try
    lvMessages.Items.Clear;
  finally
    lvMessages.Items.EndUpdate;
  end;
  FTaskIcon.Icon := Icon;
  FormResize(Self);
end;

procedure TfmDebug.actEditSaveToFileExecute(Sender: TObject);
resourcestring
  SSaveError = 'Error saving messages: %s';
var
  i: Integer;
  Messages: TStrings;
begin
  if lvMessages.Items.Count > 0 then
  begin
    // Note: this is not part of the IDE, hence we
    // do not do any "current folder" protection.
    if dlgSaveLog.Execute then
    try
      Messages := TStringList.Create;
      try
        for i := 0 to lvMessages.Items.Count - 1 do
        begin
          Messages.Add(
             IntToStr(lvMessages.Items[i].ImageIndex) + #9 +
             lvMessages.Items[i].Caption + #9 +
             lvMessages.Items[i].SubItems[0]);
        end;
        Messages.SaveToFile(dlgSaveLog.FileName);
        dlgSaveLog.InitialDir := ExtractFilePath(dlgSaveLog.FileName);
      finally
        FreeAndNil(Messages);
      end;
    except
      on E: Exception do
        MessageDlg(Format(SSaveError, [E.Message]), mtError, [mbOK], 0);
    end;
  end;
end;

procedure TfmDebug.actFileOptionsExecute(Sender: TObject);
begin
  with TfmDebugOptions.Create(nil) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfmDebug.actFileShutdownExecute(Sender: TObject);
begin
  FAllowClose := True;
  Close;
end;

procedure TfmDebug.actFileHideWindowExecute(Sender: TObject);
begin
  Close;
end;

procedure TfmDebug.actViewShowExecute(Sender: TObject);
begin
  Show;
//  setWindowPosBottomRight;
  BringToFront;
//  Application.BringToFront;
//  EnsureFormVisible(Self); // BAZ
end;

constructor TfmDebug.Create(AOwner: TComponent);
resourcestring
  SAlwaysFStayOnTop = '&Always On Top';
begin
  inherited Create(AOwner);
//  SetDefaultFont(Self);         // BAZ
//  SetToolbarGradient(Toolbar);  // BAZ
  Application.OnMessage := ApplicationMsgHandler;
  FStayOnTop            := False;
  Application.ShowHint  := True;
  Caption               := Application.Title;

  FTaskIcon             := TTrayIcon.Create(Self);
  FTaskIcon.Icon        := Icon;
  FTaskIcon.Active      := True;
  FTaskIcon.PopupMenu   := pmuTaskBar;
  FTaskIcon.ToolTip     := Application.Title;
  FTaskIcon.OnDblClick  := TrayIconDblClick;

  FAllowClose := False;

  LoadSettings;
end;

procedure TfmDebug.CreateParams(var Params: TCreateParams); // BAZ
// no taskbar icon for this window
begin
  inherited;
  Params.ExStyle    := Params.ExStyle AND (NOT WS_EX_APPWINDOW); // don't display an icon on the taskbar for this window
//  Params.WndParent  := Application.Handle;
end;

destructor TfmDebug.Destroy;
begin
  SaveSettings;

  inherited Destroy;
end;

procedure TfmDebug.actShowItemInDialogExecute(Sender: TObject);
begin
  if lvMessages.Selected <> nil then
    MessageDlg(lvMessages.Selected.Caption, mtInformation, [mbOK], 0);
end;

procedure TfmDebug.actShowItemInDialogUpdate(Sender: TObject);
begin
  (Sender as TCustomAction).Enabled := (lvMessages.Selected <> nil);
end;

procedure TfmDebug.actFilePauseExecute(Sender: TObject);
begin
  actFilePause.Checked := not actFilePause.Checked;
end;

procedure TfmDebug.ActionsUpdate(Action: TBasicAction; var Handled: Boolean);
begin
  actViewStayOnTop.Checked := StayOnTop;
  actViewToolBar.Checked := ToolBar.Visible;
end;

procedure TfmDebug.actViewToolBarExecute(Sender: TObject);
begin
  ToolBar.Visible := not ToolBar.Visible;
end;

procedure TfmDebug.actViewStayOnTopExecute(Sender: TObject);
begin
  StayOnTop := not StayOnTop;
end;

procedure TfmDebug.actEditSelectAllExecute(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lvMessages.Items.Count - 1 do
    lvMessages.Items[i].Selected := True;
end;

end.

