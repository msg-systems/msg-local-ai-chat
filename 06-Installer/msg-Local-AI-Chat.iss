;;
;;  msg-Local-AI-Chat.iss -- Inno Setup Installer Configuration for msg Local AI
;;  Copyright (c) 2024 msg Research, msg systems ag
;;  Distributed under Apache 2.0 license
;;

;;  installer information
#define MyAppName            "msg Local AI Chat"
#define MyAppFileName        "msg-Local-AI-Chat"
#define MyAppPublisher       "msg Research, msg systems ag"
#define MyAppVersion         "0.9.2"

;;  packaging information
#define FaradayVersion       "0.14.4"
#define ModelENInstructURL   "http://msg.direct/local-ai-mistral-7b-en-instruct"
#define ModelENInstructFile  "Mistral-7B-EN-Instruct"
#define ModelDEInstructURL   "http://msg.direct/local-ai-mistral-7b-de-instruct"
#define ModelDEInstructFile  "Mistral-7B-DE-Instruct"
#define ModelENChatURL       "http://msg.direct/local-ai-mistral-7b-en-chat"
#define ModelENChatFile      "Mistral-7B-EN-Chat"
#define ModelDEChatURL       "http://msg.direct/local-ai-mistral-7b-de-chat"
#define ModelDEChatFile      "Mistral-7B-DE-Chat"
#define MigrationENInstruct  "migration-EN-instruct.sql"
#define MigrationENChat      "migration-EN-chat.sql"
#define MigrationDEInstruct  "migration-DE-instruct.sql"
#define MigrationDEChat      "migration-DE-chat.sql"

;;  global configuration options
[Setup]
AppId={{0479AB23-0676-42C2-8031-18AEED13AA42}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultGroupName={#MyAppName}
OutputBaseFilename={#MyAppFileName}-Setup-{#MyAppVersion}
Compression=lzma2/max
SolidCompression=no
DefaultDirName={userappdata}\{#MyAppFileName}
DiskSpanning=no
PrivilegesRequired=lowest
DisableDirPage=yes
DisableReadyPage=yes
SetupIconFile=msg-Local-AI-Chat.ico
WizardSmallImageFile=msg-Local-AI-Chat-logo.bmp
WizardImageFile=msg-Local-AI-Chat-sidebar.bmp
InfoBeforeFile=msg-Local-AI-Chat-info.rtf
ArchitecturesAllowed=x64
OutputDir=Output
DisableWelcomePage=no
DisableProgramGroupPage=yes
CloseApplications=no
RestartApplications=no
ExtraDiskSpaceRequired=17475433152

;;  language support
[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

;;  packaging manifest (files)
[Files]
Source: "msg-Local-AI-Chat.ico";                             DestDir: "{app}"; DestName: "{#MyAppFileName}.ico"; Flags: ignoreversion
Source: "..\04-Runtime\faraday-Setup-{#FaradayVersion}.exe"; DestDir: "{tmp}"; Flags: ignoreversion nocompression
Source: "..\01-Artwork\character*.jpg";                      DestDir: "{userappdata}\faraday\images"; Flags: recursesubdirs

Source: "..\05-Config\{#MigrationENInstruct}";               DestDir: "{tmp}"; Flags: ignoreversion; Tasks: instruct_en
Source: "..\05-Config\{#MigrationDEInstruct}";               DestDir: "{tmp}"; Flags: ignoreversion; Tasks: instruct_de
Source: "..\05-Config\{#MigrationENChat}";                   DestDir: "{tmp}"; Flags: ignoreversion; Tasks: chat_en
Source: "..\05-Config\{#MigrationDEChat}";                   DestDir: "{tmp}"; Flags: ignoreversion; Tasks: chat_de

Source: "{tmp}\{#ModelENInstructFile}"; DestDir: "{userappdata}\faraday\models"; DestName: "{#ModelENInstructFile}.gguf"; Flags: external; ExternalSize: 4368439584; Tasks: instruct_en
Source: "{tmp}\{#ModelDEInstructFile}"; DestDir: "{userappdata}\faraday\models"; DestName: "{#ModelDEInstructFile}.gguf"; Flags: external; ExternalSize: 4368438912; Tasks: instruct_de
Source: "{tmp}\{#ModelENChatFile}";     DestDir: "{userappdata}\faraday\models"; DestName: "{#ModelENChatFile}.gguf";     Flags: external; ExternalSize: 4369387104; Tasks: chat_en
Source: "{tmp}\{#ModelDEChatFile}";     DestDir: "{userappdata}\faraday\models"; DestName: "{#ModelDEChatFile}.gguf";     Flags: external; ExternalSize: 4369167552; Tasks: chat_de

;;  packaging manifest (icons)
[Icons]
Name: "{group}\{#MyAppName}";                 Filename: "{localappdata}\faraday\Faraday.exe"; WorkingDir: "{localappdata}"; IconFilename: "{app}\{#MyAppFileName}.ico"
Name: "{group}\Uninstall {#MyAppName}";       Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}";           Filename: "{localappdata}\faraday\Faraday.exe"; WorkingDir: "{localappdata}"; IconFilename: "{app}\{#MyAppFileName}.ico"; HotKey: "ctrl+alt+a"
Name: "{autodesktop}\Uninstall {#MyAppName}"; Filename: "{uninstallexe}"

;;  program executions at end of installation
[Run]
Filename: "{tmp}\faraday-Setup-{#FaradayVersion}.exe"; Parameters: "--silent"; Description: "Run Faraday Application";  Flags: shellexec runascurrentuser; BeforeInstall: FaradaySetupBefore; AfterInstall: FaradaySetupAfter
Filename: "{localappdata}\faraday\Faraday.exe";                                Description: {cm:LaunchProgram,Faraday}; Flags: nowait postinstall skipifsilent

;;  program executions at uninstallation time
[UninstallRun]
Filename: "{localappdata}\faraday\Update.exe"; Parameters: "--uninstall -s"; Flags: runascurrentuser

;;  allow application to be started at end of installation
[CustomMessages]
AppName={#MyAppName}
LaunchProgram=Start {#MyAppName} after finishing installation

;;  override standard text messages of Inno Setup to be more specific
[Messages]
WelcomeLabel2=This will install [name/ver] on your computer, a freely available solution to locally run Large Language Model (LLM) based generative Artificial Intelligence (AI) characters (aka "chat-bots"). The solution is based on the freely-available Faraday host application, the Open Source LLMs Mistral 7B, and a set of pre-defined AI characters.
StatusRunProgram=Installing Faraday LLM host application (just still be patient)...
InfoBeforeLabel=Please read the following information before continuing.
InfoAfterLabel=Please read the following information before continuing.
DownloadingLabel=Downloading Large Language Model (LLM) files (just be patient)...
WizardSelectTasks=Select Approach & Language Support
SelectTasksDesc=Which approaches and languages should the AI characters support?
SelectTasksLabel2=Select the approaches and languages you would like Setup to establish while installing [name], then click Install. Each particular support requires downloading a particular Large Language Model (LLM) with about 4.3GB.

;;  allow optional selections
[Tasks]
Name: instruct_en; Description: "Instruct (EN) [size: 4.3GB, license: Apache 2.0]"; GroupDescription: "Instruct AI character support (recommended):"
Name: instruct_de; Description: "Instruct (DE) [size: 4.3GB, license: Apache 2.0]"; GroupDescription: "Instruct AI character support (recommended):"
Name: chat_en;     Description: "Chat (EN) [size: 4.3GB, license: Apache 2.0]";     GroupDescription: "Chat AI character support (optional):";        Flags: unchecked
Name: chat_de;     Description: "Chat (DE) [size: 4.3GB, license: Apache 2.0]";     GroupDescription: "Chat AI character support (optional):";        Flags: unchecked

;;  scripting section
[Code]

//  hook into processing: before Faraday Setup execution
procedure FaradaySetupBefore;
var
    Directory: String;
begin
    //  remove migrations directory to ensure we have a chance to detect when Faraday Setup is done 
    Directory := ExpandConstant('{localappdata}\faraday\app-{#FaradayVersion}\resources\app.asar.unpacked\prisma\migrations')
    DelTree(Directory, True, True, True)
end;

//  helper function: install Faraday/Prisma migration script
function InstallMigrationSQL(const SrcPath: String; const DstDir: String): Boolean;
var
    DstPath: String;
    Oldtext: String;
    NewText: String;
    MyFile:  TStrings;
    MyText:  String;
begin
    ForceDirectories(DstDir)
    DstPath := Format('%s\migration.sql', [ DstDir ])
    OldText := 'C:\Users\studio\AppData\Roaming'
    NewText := ExpandConstant('{userappdata}')
    MyFile := TStringList.Create
    MyFile.LoadFromFile(SrcPath)
    MyText := MyFile.Text
    StringChangeEx(MyText, OldText, Newtext, True)
    MyFile.Text := MyText
    MyFile.SaveToFile(DstPath)
    MyFile.Free
    Result := True
end;

//  hook into processing: after Faraday Setup execution
procedure FaradaySetupAfter;
var
    SrcPath:   String;
    DstPath:   String;
    Directory: String;
    Icon:      String;
 
begin
    //  wait until Faraday Setup is really done
    Directory := ExpandConstant('{localappdata}\faraday\app-{#FaradayVersion}\resources\app.asar.unpacked\prisma\migrations')
    while not(DirExists(Directory)) do
    begin
        Sleep(500)
    end;

    //  optionally install various Faraday/Prisma migration scripts
    if WizardIsTaskSelected('instruct_en') then
    begin
        InstallMigrationSQL(ExpandConstant('{tmp}/{#MigrationENInstruct}'),
            ExpandConstant('{localappdata}\faraday\app-{#FaradayVersion}\resources\app.asar.unpacked\prisma\migrations\9999_msg_instruct_EN'))
    end;
    if WizardIsTaskSelected('instruct_de') then
    begin
        InstallMigrationSQL(ExpandConstant('{tmp}/{#MigrationDEInstruct}'),
            ExpandConstant('{localappdata}\faraday\app-{#FaradayVersion}\resources\app.asar.unpacked\prisma\migrations\9999_msg_instruct_DE'))
    end;
    if WizardIsTaskSelected('chat_en') then
    begin
        InstallMigrationSQL(ExpandConstant('{tmp}/{#MigrationENChat}'),
            ExpandConstant('{localappdata}\faraday\app-{#FaradayVersion}\resources\app.asar.unpacked\prisma\migrations\9999_msg_chat_EN'))
    end;
    if WizardIsTaskSelected('chat_de') then
    begin
        InstallMigrationSQL(ExpandConstant('{tmp}/{#MigrationDEChat}'),
            ExpandConstant('{localappdata}\faraday\app-{#FaradayVersion}\resources\app.asar.unpacked\prisma\migrations\9999_msg_chat_DE'))
    end;

    //  remove desktop icon of Faraday
    Icon := ExpandConstant('{userdesktop}\Faraday.lnk')
    while not(FileExists(Icon)) do
    begin
        Sleep(500)
    end;
    DeleteFile(Icon)
end;

//  hook into processing: on uninstallation, remove left-overs of Faraday
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
    case CurUninstallStep of
        usPostUninstall: begin
            if MsgBox('Should Faraday LLM host application configuration files be deleted, too?', mbConfirmation, MB_YESNO) = idYes then
            begin
                DelTree(ExpandConstant('{userappdata}\faraday'), True, True, True);
                DelTree(ExpandConstant('{localappdata}\faraday'), True, True, True);
            end;
        end;
    end;
end;

//  host into processing: change button on Task page
procedure CurPageChanged(CurPageID: Integer);
begin
    if CurPageID = wpSelectTasks then
        WizardForm.NextButton.Caption := SetupMessage(msgButtonInstall)
    else
        WizardForm.NextButton.Caption := SetupMessage(msgButtonNext);
end;

//  helper function for logging download progress
function OnDownloadProgress(const Url, FileName: String; const Progress, ProgressMax: Int64): Boolean;
begin
    if Progress = ProgressMax then
        Log(Format('Successfully downloaded file to {tmp}: %s', [FileName]));
    Result := True;
end;

//  hook into processing: during setup initialization
var
    DownloadPage: TDownloadWizardPage;
procedure InitializeWizard;
begin
    DownloadPage := CreateDownloadPage(SetupMessage(msgWizardPreparing), SetupMessage(msgPreparingDesc), @OnDownloadProgress);
end;

//  hook into processing: on clicking the Next button on the Tasks page
function NextButtonClick(CurPageID: Integer): Boolean;
begin
    if CurPageID = wpSelectTasks then
    begin
        //  establish and show Download page
        DownloadPage.Clear;
        if WizardIsTaskSelected('instruct_en') then
        begin
            DownloadPage.Add(ExpandConstant('{#ModelENInstructURL}'), ExpandConstant('{#ModelENInstructFile}'), '')
        end;
        if WizardIsTaskSelected('instruct_de') then
        begin
            DownloadPage.Add(ExpandConstant('{#ModelDEInstructURL}'), ExpandConstant('{#ModelDEInstructFile}'), '')
        end;                     
        if WizardIsTaskSelected('chat_en') then
        begin
            DownloadPage.Add(ExpandConstant('{#ModelENChatURL}'), ExpandConstant('{#ModelENChatFile}'), '')
        end;
        if WizardIsTaskSelected('chat_de') then
        begin
            DownloadPage.Add(ExpandConstant('{#ModelDEChatURL}'), ExpandConstant('{#ModelDEChatFile}'), '')
        end;
        DownloadPage.Show;
        try
            try
                DownloadPage.Download
                Result := True
            except
                if DownloadPage.AbortedByUser then
                    Log('Aborted by user.')
                else
                    SuppressibleMsgBox(AddPeriod(GetExceptionMessage), mbCriticalError, MB_OK, IDOK);
                    Result := False;
                end;
            finally
                DownloadPage.Hide;
            end;
        end
    else
        Result := True;
end;

