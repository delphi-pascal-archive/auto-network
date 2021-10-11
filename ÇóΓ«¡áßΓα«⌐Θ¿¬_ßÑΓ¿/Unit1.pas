unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellAPI, xpman, WinSock, ComCtrls, ExtCtrls,
  Buttons, Jpeg;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Button12: TButton;
    Button4: TButton;
    Button5: TButton;
    Button13: TButton;
    TabSheet2: TTabSheet;
    Button9: TButton;
    Button8: TButton;
    TabSheet3: TTabSheet;
    Button3: TButton;
    Button2: TButton;
    Button1: TButton;
    TabSheet4: TTabSheet;
    Button10: TButton;
    Button7: TButton;
    Button6: TButton;
    Button11: TButton;
    Shape1: TShape;
    Image5: TImage;
    Shape2: TShape;
    Image3: TImage;
    Image4: TImage;
    Shape3: TShape;
    Image1: TImage;
    Shape4: TShape;
    Image2: TImage;
    Label3: TLabel;
    Button14: TButton;
    Label4: TLabel;
    Memo1: TMemo;
    ProgressBar1: TProgressBar;
    Timer1: TTimer;
    Label5: TLabel;
    BitBtn1: TBitBtn;
    Label6: TLabel;
    Label7: TLabel;
    Timer2: TTimer;
    Button15: TButton;
    GroupBox1: TGroupBox;
    Edit5: TEdit;
    Label8: TLabel;
    Label9: TLabel;
    Button16: TButton;
    Memo2: TMemo;
    Label10: TLabel;
    Label11: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
    procedure Timer1Timer(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Label11Click(Sender: TObject);
    procedure Edit5KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    revers1:integer;
    revers2:integer;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
/////////////////////////////////////////////////
procedure ExecConsoleApp(CommandLine: AnsiString; Output: TStringList; Errors:
 TStringList);
var
 sa: TSECURITYATTRIBUTES;
 si: TSTARTUPINFO;
 pi: TPROCESSINFORMATION;
 hPipeOutputRead: THANDLE;
 hPipeOutputWrite: THANDLE;
 hPipeErrorsRead: THANDLE;
 hPipeErrorsWrite: THANDLE;
 Res, bTest: Boolean;
 env: array[0..100] of Char;
 szBuffer: array[0..256] of Char;
 dwNumberOfBytesRead: DWORD;
 Stream: TMemoryStream;
begin
 sa.nLength := sizeof(sa);
 sa.bInheritHandle := true;
 sa.lpSecurityDescriptor := nil;
 CreatePipe(hPipeOutputRead, hPipeOutputWrite, @sa, 0);
 CreatePipe(hPipeErrorsRead, hPipeErrorsWrite, @sa, 0);
 ZeroMemory(@env, SizeOf(env));
 ZeroMemory(@si, SizeOf(si));
 ZeroMemory(@pi, SizeOf(pi));
 si.cb := SizeOf(si);
 si.dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
 si.wShowWindow := SW_HIDE;
 si.hStdInput := 0;
 si.hStdOutput := hPipeOutputWrite;
 si.hStdError := hPipeErrorsWrite;
 (* Remember that if you want to execute an app with no parameters you nil the
  second parameter and use the first, you can also leave it as is with no
  problems. *)
 Res := CreateProcess(nil, pchar(CommandLine), nil, nil, true,
  CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, @env, nil, si, pi);
 // Procedure will exit if CreateProcess fail
 if not Res then
 begin
  CloseHandle(hPipeOutputRead);
  CloseHandle(hPipeOutputWrite);
  CloseHandle(hPipeErrorsRead);
  CloseHandle(hPipeErrorsWrite);
  Exit;
 end;
 CloseHandle(hPipeOutputWrite);
 CloseHandle(hPipeErrorsWrite);
 //Read output pipe
 Stream := TMemoryStream.Create;
 try
  while true do
  begin
  bTest := ReadFile(hPipeOutputRead, szBuffer, 256, dwNumberOfBytesRead,
  nil);
  if not bTest then
  begin
  break;
  end;
  Stream.Write(szBuffer, dwNumberOfBytesRead);
  end;
  Stream.Position := 0;
  Output.LoadFromStream(Stream);
 finally
  Stream.Free;
 end;
 //Read error pipe
 Stream := TMemoryStream.Create;
 try
  while true do
  begin
  bTest := ReadFile(hPipeErrorsRead, szBuffer, 256, dwNumberOfBytesRead,
  nil);
  if not bTest then
  begin
  break;
  end;
  Stream.Write(szBuffer, dwNumberOfBytesRead);
  end;
  Stream.Position := 0;
  Errors.LoadFromStream(Stream);
 finally
  Stream.Free;
 end;
 WaitForSingleObject(pi.hProcess, INFINITE);
 CloseHandle(pi.hProcess);
 CloseHandle(hPipeOutputRead);
 CloseHandle(hPipeErrorsRead);
end;
/////////////////////////////////////////////////
procedure TForm1.Button1Click(Sender: TObject);
begin
if MessageBox(0, 'Хотите ли Вы просмотреть и сохранить отчет используя к примеру Microsoft Word нажмите "Да" (И в окне открытой программы выберите кодировку MS-DOS)', 'Просмотр роутинга', +mb_YesNo +MB_ICONQUESTION) = 6 then
ShellExecute(0,'open','cmd.exe','/c route print >route.rtf & route.rtf','C:\Windows\system32\',SW_SHOW)
else
ShellExecute(0,'open','cmd.exe','/k route print','C:\Windows\system32\',SW_SHOW);
end;

procedure TForm1.Button2Click(Sender: TObject);
var adres:string;
begin
adres:= Edit1.Text+'.'+Edit2.Text+'.'+Edit3.Text+'.'+Edit4.Text;
if MessageBox(0, 'Прописать роутинг?', 'Пропись роутинга', +mb_YesNo +MB_ICONQUESTION) = 6 then
begin
ShellExecute(0,'open','cmd.exe',PChar('/c route -p add 10.0.0.0 mask 255.0.0.0 10.10.'+ Edit3.Text +'.254'),'C:\Windows\system32\',SW_SHOW);
ShowMessage('Route на '+Edit1.Text+'.'+Edit2.Text+'.'+Edit3.Text+'.'+Edit4.Text+' успешно прописан');
end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
if MessageBox(0, 'Вы действительно хотите удалить роутинг?', 'Удаление роутинга', +mb_YesNo +MB_ICONQUESTION) = 6 then
begin
ShellExecute(0,'open','cmd.exe','/c route -f','C:\Windows\system32\',SW_SHOW);
ShowMessage('Route успешно удален!');
end;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
ShellExecute(0,'open','cmd.exe','/c ipconfig >ipconfig.txt & ipconfig.txt','C:\Windows\system32\',SW_SHOW);
end;

procedure TForm1.Button5Click(Sender: TObject);
const WSVer = $101;
var
  wsaData: TWSAData;
  P: PHostEnt;
  Buf: array [0..127] of Char;
  Result: String;
begin
  Result:= '';
  if WSAStartup(WSVer, wsaData) = 0 then begin
    if GetHostName(@Buf, 128) = 0 then begin
      P := GetHostByName(@Buf);
      if P <> nil then Result := iNet_ntoa(PInAddr(p^.h_addr_list^)^);
    end;
    WSACleanup;
    Label2.Caption:=result;
    ShowMessage('Ваш IP-адрес: '+result); 
  end;
end;

procedure TForm1.Button6Click(Sender: TObject);
const WSVer = $101;
var
  wsaData: TWSAData;
  P: PHostEnt;
  Buf: array [0..127] of Char;
  Result: String;
begin
  Result:= '';
  if WSAStartup(WSVer, wsaData) = 0 then begin
    if GetHostName(@Buf, 128) = 0 then begin
      P := GetHostByName(@Buf);
      if P <> nil then Result := iNet_ntoa(PInAddr(p^.h_addr_list^)^);
    end;
    WSACleanup;
    Label2.Caption:=result;
if MessageBox(0, 'Вы действительно хотите пропинговать свой IP-адрес?', 'Пингование собственного IP-адреса', +mb_YesNo +MB_ICONQUESTION) = 6 then
    ShellExecute(0,'open','cmd.exe',PChar('/k ping '+ result),'C:\Windows\system32\',SW_SHOW);
end;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
if MessageBox(0, 'Вы действительно хотите пропинговать сервер с IP-адресом: 10.10.1.1?', 'Пингование сервера 10.10.1.1', +mb_YesNo +MB_ICONQUESTION) = 6 then
ShellExecute(0,'open','cmd.exe',PChar('/k ping 10.10.1.1'),'C:\Windows\system32\',SW_SHOW);
end;

procedure TForm1.Button8Click(Sender: TObject);
var ip: string;
    g:string;
begin
// Настройка сети по введенному IP
ip:=Edit1.Text+'.'+Edit2.Text+'.'+Edit3.Text+'.'+Edit4.Text;
g:=Edit1.Text+'.'+Edit2.Text+'.'+Edit3.Text;
if MessageBox(0, 'Настройка сети длится до 2-х минут. Что бы приступить к настройке сети на введенный Вами IP-адрес дождитесь закрытия появившегося окна! Для продолжения нажмите "Да"', 'Настройка сети со статическим IP-адресом', +mb_YesNo +MB_ICONINFORMATION) = 6 then
// запрос на отображение сетевых настроек в текстовом файле
if MessageBox(0, 'Вы хотите просмотреть Ваши сетевые настройки после завершения установки?', 'Настройка сети со статическим IP-адресом', +mb_YesNo +MB_ICONINFORMATION) = 6 then
begin
//отображаю скрытые элементы визуализации
//настраиваю сначала сеть затем прописываю DNS 10.10.1.1
ShellExecute(0,'open','cmd.exe',PChar('/c netsh interface ip set address name="Подключение по локальной сети" static addr='+ip+' mask=255.255.255.0 gateway='+g+'.254 gwmetric=10.10.1.1 && netsh interface ip set dns "Подключение по локальной сети" static 10.10.1.1 && ipconfig/all >Ваши_сетевые_настройки.doc & Ваши_сетевые_настройки.doc'),'C:\Windows\system32\',SW_SHOW);
timer1.Enabled :=true;
ProgressBar1.Visible :=true;
label5.Visible :=true;
end
else
ShellExecute(0,'open','cmd.exe',PChar('/c netsh interface ip set address name="Подключение по локальной сети" static addr='+ip+' mask=255.255.255.0 gateway='+g+'.254 gwmetric=10.10.1.1 && netsh interface ip set dns "Подключение по локальной сети" static 10.10.1.1'),'C:\Windows\system32\',SW_SHOW);
end;

procedure TForm1.Button9Click(Sender: TObject);
const WSVer = $101;
var
  wsaData: TWSAData;
  P: PHostEnt;
  Buf: array [0..127] of Char;
  Result: String;
begin
if MessageBox(0, 'Вы действительно хотите настроить сеть с автоматическим присвоением IP-адреса дождитесь закрытия появившегося окна! Для продолжения нажмите "Да"', 'Настройка сети с автоматическим присвоением IP-адреса', +mb_YesNo +MB_ICONINFORMATION) = 6 then
begin
Result:= '';
  if WSAStartup(WSVer, wsaData) = 0 then begin
    if GetHostName(@Buf, 128) = 0 then begin
      P := GetHostByName(@Buf);
      if P <> nil then Result := iNet_ntoa(PInAddr(p^.h_addr_list^)^);
    end;
    WSACleanup;
    Label2.Caption:=result;
    end;
end;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
if MessageBox(0, 'Вы действительно хотите пропинговать VPN.LAN?', 'Пингование VPN.LAN', +mb_YesNo +MB_ICONQUESTION) = 6 then
ShellExecute(0,'open','cmd.exe',PChar('/k ping VPN.LAN'),'C:\Windows\system32\',SW_SHOW);
end;

procedure TForm1.Button11Click(Sender: TObject);
const WSVer = $101;
var
  wsaData: TWSAData;
  P: PHostEnt;
  Buf: array [0..127] of Char;
  Result: String;
begin
  Result:= '';
  if WSAStartup(WSVer, wsaData) = 0 then begin
    if GetHostName(@Buf, 128) = 0 then begin
      P := GetHostByName(@Buf);
      if P <> nil then Result := iNet_ntoa(PInAddr(p^.h_addr_list^)^);
    end;
    WSACleanup;
    Label2.Caption:=result;
if MessageBox(0, 'Вы действительно хотите пропинговать свой шлюз?', 'Пингование собственного шлюза', +mb_YesNo +MB_ICONQUESTION) = 6 then
  ShellExecute(0,'open','cmd.exe',PChar('/k ping 10.10.'+ edit3.Text+'.254'),'C:\Windows\system32\',SW_SHOW);
end;
end;

procedure TForm1.Button12Click(Sender: TObject);
var
 OutP: TStringList;
 ErrorP: TStringList;
begin
ShellExecute(0,'open','cmd.exe','/c ipconfig/all >ipconfig_all.txt & ipconfig_all.txt','C:\Windows\system32\',SW_SHOW);
 OutP := TStringList.Create;
 ErrorP := TstringList.Create;
 //ExecConsoleApp('ipconfig /all', OutP, ErrorP);
 Memo1.Lines.Assign(OutP);
 //ShowMessage(memo1.text);
 OutP.Free;
 ErrorP.Free;
end;

procedure TForm1.Button14Click(Sender: TObject);
const WSVer = $101;
var
  wsaData: TWSAData;
  P: PHostEnt;
  Buf: array [0..127] of Char;
  Result: String;
begin
  Result:= '';
  if WSAStartup(WSVer, wsaData) = 0 then begin
    if GetHostName(@Buf, 128) = 0 then begin
      P := GetHostByName(@Buf);
      if P <> nil then Result := iNet_ntoa(PInAddr(p^.h_addr_list^)^);
    end;
    WSACleanup;
    Label2.Caption:=result;
if MessageBox(0, 'Комплексная проверка включает в себя пингование собственного IP-адреса, пингование VPN.LAN и пинговние собственного шлюза и займет примерно 1-2 минуты! Вы хотите продолжить?', 'Комплексная проверка потерь', +mb_YesNo +MB_ICONINFORMATION) = 6 then
    //пингуем VPN, шлюз, ip-адрес
    ShellExecute(0,'open','cmd.exe',PChar('/k ping 10.10.'+ edit3.Text+'.254 -t -l 1470 -n 25 & ping VPN.LAN -t -l 1470 -n 25 & ping '+ result+' -t -l 1470 -n 25'),'C:\Windows\system32\',SW_SHOW);
end;
end;

procedure TForm1.Button15Click(Sender: TObject);
begin
button15.Caption :='К о д ы < О ш и б о к';
timer2.Enabled :=true;
form1.Height:= 265;
end;

procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: Char);
const Digit: Set of Char=['0' .. '9', #8 ];
begin
if not (Key in Digit) then
Key:=#0;

end;

procedure TForm1.Edit2KeyPress(Sender: TObject; var Key: Char);
const Digit: Set of Char=['0' .. '9', #8 ];
begin
if not (Key in Digit) then
Key:=#0;
end;

procedure TForm1.Edit3KeyPress(Sender: TObject; var Key: Char);
const Digit: Set of Char=['0' .. '9', #8 ];
begin
if not (Key in Digit) then
Key:=#0;
end;

procedure TForm1.Edit4KeyPress(Sender: TObject; var Key: Char);
const Digit: Set of Char=['0' .. '9', #8 ];
begin
if not (Key in Digit) then
Key:=#0;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
if ProgressBar1.Position=100 then
begin
timer1.Enabled :=false;
ProgressBar1.Visible :=false;
label5.Visible :=false;
end;
ProgressBar1.Position:= ProgressBar1.Position +1;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
label6.Visible:=true;
label7.Visible:=true;
end;

procedure TForm1.Image5Click(Sender: TObject);
begin
if MessageBox(0, 'Если вы хотите просмотреть и сохранить информацию используя к примеру Microsoft Word нажмите Ok', 'Вывод информации о системе', +mb_YesNo +MB_ICONINFORMATION) = 6 then
ShellExecute(0,'open','cmd.exe','/c systeminfo >systeminfo.rtf & systeminfo.rtf','C:\Windows\system32\',SW_SHOW)
else
ShellExecute(0,'open','cmd.exe','/k systeminfo','C:\Windows\system32\',SW_SHOW);
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
form1.Width :=form1.Width + 5*revers1;
if (form1.Width >=500)then
begin
timer2.Enabled :=false;
revers1:=-1;
end;
if (form1.Width <=325)then
begin
timer2.Enabled :=false;
revers1:=1;
Button15.Caption :='К о д ы > О ш и б о к';
end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
form1.Width :=406;
form1.Height:= 331;
revers1 :=1;
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
form1.Height:= 500;
if edit5.text='' then
begin
form1.Height:=275;
ShowMessage('Введите номер ошибки');
edit5.SetFocus;
end
else
if FileExists(ExtractFilePath(Application.ExeName)+'\Errors\'+Edit5.Text+'.rtf') then
memo2.Lines.LoadFromFile(ExtractFilePath(Application.ExeName)+'\Errors\'+Edit5.Text+'.rtf')
else
begin
edit5.SetFocus;
form1.Height :=500;
memo2.Lines.LoadFromFile(ExtractFilePath(Application.ExeName)+'\Errors\ErrorsAll.rtf');
ShowMessage('Введенная Вами ошибка отсутствует в базе. Пожалуйста проверьте правильность набора номера ошибки или найдите ее из нижеприведенного списка ошибок. За дальнейшей информацией обратитесь в службу технической поддержки по тел.: 4-06-16, 4-86-97, 095-497-24-60');
end;
end;

procedure TForm1.Label11Click(Sender: TObject);
begin
form1.Height :=500;
memo2.Lines.LoadFromFile(ExtractFilePath(Application.ExeName)+'\Errors\ErrorsAll.rtf');
end;

procedure TForm1.Edit5KeyPress(Sender: TObject; var Key: Char);
begin
if key=#13 then  Button16.Click;
end;

end.
