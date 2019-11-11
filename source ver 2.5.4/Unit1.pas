unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Printers, Winspool,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Imaging.jpeg, ShellApi, System.ImageList,
  Vcl.ImgList, Vcl.Grids, Vcl.FileCtrl, GDIPAPI,GDIPOBJ, Vcl.ButtonGroup,
  Vcl.Menus, inifiles, Registry, Unit2;

type
  TForm1 = class(TForm)
    PrintDialog1: TPrintDialog;
    RadioGroup1: TRadioGroup;
    RadioButton_auto: TRadioButton;
    Button1: TButton;
    RadioButton_manual: TRadioButton;
    RadioButton_lotok1: TRadioButton;
    RadioButton_lotok2: TRadioButton;
    ListViewPrinter: TListView;
    ImageList1: TImageList;
    ScrollBox1: TScrollBox;
    GroupBox1: TGroupBox;
    EditNumberOfCopy: TEdit;
    TrackBar1: TTrackBar;
    GroupBox2: TGroupBox;
    ButtonStarTestWithoutDialog: TButton;
    ButtonStarTestWithDialog: TButton;
    ButtonStandartPageWindows: TButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Button2: TButton;
    ButtonIncRight: TButton;
    ButtonDecLeft: TButton;
    Button_Clear_All_Setting: TButton;
    GroupBox3: TGroupBox;
    Button_Head_Cleaning_Normal: TButton;
    Button_Nozzle_Check: TButton;
    Button_Head_Cleaning_Deep: TButton;
    Button_Head_Cleaning_Starter: TButton;
    Label1: TLabel;

    procedure PrintStandartTestPageWhitoutDialog();
    //procedure ListPrinter();
    procedure TrackBar1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure PrintImage(ImageBitmap: TImage);
    procedure PrintFromImageWithDialog();
    procedure PrintFromImageWithoutDialog();
    procedure ButtonStarTestWithoutDialogClick(Sender: TObject);
    procedure ButtonStarTestWithDialogClick(Sender: TObject);
    procedure ButtonStandartPageWindowsClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ChangePrinterTray;
    procedure GetImageFiles();
    //procedure select_checkbox(Sender:TObject);
    procedure select_checkbox_2(Sender:TObject);
    function GetAllSelectCheckbox:integer;
    function PrinterSupportsDuplex: Boolean;
    function GetPrinterStatus(PrinterName: string) : Integer;
    procedure ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    //procedure ScrollBox1Click(Sender: TObject);
    //procedure ListViewPrinterColumnClick(Sender: TObject; Column: TListColumn);
    procedure WindowPrintQueue();
    procedure WindowPrinterProperties();
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure WindowOutputPrintSettings();
    procedure N3Click(Sender: TObject);
    procedure ListPrinter2();
    procedure Button2Click(Sender: TObject);

    procedure Button_Clear_All_SettingClick(Sender: TObject);
    procedure ButtonIncRightClick(Sender: TObject);
    procedure ButtonDecLeftClick(Sender: TObject);
    function CheckSelectTestList() : Integer;
    function CheckSelectPrinter() : Integer;
    procedure ScrollBox1MouseEnter(Sender: TObject);
    procedure FormDestroy(Sender: TObject);


    procedure NozzleCheckEpson();
    procedure NozzleCheckCanon();

    procedure HeadCleaningEpsonNormal();
    procedure HeadCleaningEpsonDeep();
    procedure HeadCleaningCanonNormal();
    procedure HeadCleaningCanonDeep();
    procedure HeadCleaningCanonStarter();

    procedure Button_Head_Cleaning_NormalClick(Sender: TObject);
    procedure Button_Nozzle_CheckClick(Sender: TObject);
    procedure Button_Head_Cleaning_DeepClick(Sender: TObject);
    procedure Button_Head_Cleaning_StarterClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;



var
  Form1: TForm1;
  Registry: TRegIniFile;

implementation

{$R *.dfm}

{
 // Получить имя выделенного принтера
 ListView1.Items[ListView1.ItemIndex].Caption

 // Индекс выделленного принтера
 Printer.Printers.IndexOf(ListView1.Items[ListView1.ItemIndex].Caption);

 ChangeFileExt(ExtractFileName(ИМЯ_С_РАЗРЕШЕНИЕМ),'');  // Получаем только имя без .jpg

}

//////////////////////////////////////////////////
//                Ф У Н К Ц И И                 //
//////////////////////////////////////////////////

// ФУНКЦИЯ Проверка выделен ли тестовы лист
function Tform1.CheckSelectTestList() : Integer;
var
  SelectTestList: Integer;
begin
  SelectTestList := 0;

  if GetAllSelectCheckbox > 0 then
  begin
    SelectTestList := 1;
  end;

  if SelectTestList <> 1 then
  begin
    ShowMessage('Надо выбрать тестовый лист');
    Result := 0;
  end
  else
  begin
    Result := 1;
  end;

end;


// ФУНКЦИЯ Проверка выделен ли тестовы лист или принтер
function Tform1.CheckSelectPrinter() : Integer;
var
  i, SelectPrinter: Integer;
begin
  SelectPrinter := 0;

  i := ListViewPrinter.Items.Count - 1;
  while i >= 0 do
  begin
    if ListViewPrinter.Items[i].Selected = True then
      begin
         SelectPrinter := 1;
      end;
    Dec(i);
  end;

  if (SelectPrinter <> 1) then
  begin
    ShowMessage('Надо выбрать принтер');
    Result := 0;
  end
  else
  begin
    Result := 1;
  end;

end;

// ФУНКЦИЯ проверки Статуса принтера
// Нашел тут http://forum.vingrad.ru/topic-376303.html
function TForm1.GetPrinterStatus(PrinterName: string) : Integer;
var
  BufferLength: Cardinal;
  Buffer: Pointer;
  PrinterInfo: PPrinterInfo2;
  hPrinter: THandle;
  PD: TPrinterDefaults;
  //PrinterStatus: Cardinal;
  //PrinterJobs: Cardinal;
begin
  //PrinterStatus := MAXDWORD;
  ZeroMemory(@PD, SizeOf(PD));
  PD.DesiredAccess := PRINTER_ACCESS_USE;
  if OpenPrinter(PChar(PrinterName), hPrinter, @PD) then
  try
    GetPrinter(hPrinter, 2, nil, 0, @BufferLength);
    if GetLastError = ERROR_INSUFFICIENT_BUFFER then
    begin
      Buffer := AllocMem(BufferLength);
      try
        if GetPrinter(hPrinter, 2, Buffer, BufferLength, @BufferLength) then
        begin
          PrinterInfo := PPrinterInfo2(Buffer);
          //PrinterStatus := PrinterInfo^.Status;
          // для распознавания автономного режима
          //if (PrinterInfo^.Attributes and PRINTER_ATTRIBUTE_WORK_OFFLINE) > 0 then
          //  PrinterStatus := PrinterStatus or PRINTER_STATUS_OFFLINE;
          //  PrinterJobs := PrinterInfo^.cJobs;
          if PrinterInfo^.Attributes and PRINTER_ATTRIBUTE_WORK_OFFLINE = PRINTER_ATTRIBUTE_WORK_OFFLINE then
            begin
               //Label2.Caption := ('OFFLINE');
               //ShowMessage('OFFLINE');
               Result := 0;
            end
            else
            begin
               //Label2.Caption := ('ONLINE');
               //ShowMessage('ONLINE');
               Result := 1;
            end;
        end
        else
          RaiseLastOSError;
        finally
        FreeMem(Buffer, BufferLength);
      end;
    end
    else
      RaiseLastOSError;
    finally
    ClosePrinter(hPrinter);
  end;
end;

// ФУНКЦИЯ возвращает сколько листов выделенно
function TForm1.GetAllSelectCheckbox:integer;
var
  i: Integer;
  all_select: Integer;
begin
  all_select := 0;
  with ScrollBox1 do
  for i := 0 to ComponentCount - 1 do
  begin
    //ShowMessage(Components[i].Name);
    if TImage(Components[i]).ImageCheck = True then
    begin
        all_select := all_select + 1;
    end;
  end;
  Result := all_select;
end;

// ФУНКЦИЯ проверки Дюплекса в принтере
function TForm1.PrinterSupportsDuplex: Boolean;
 var
   Device, Driver, Port: array[0..255] of Char;
   hDevMode: THandle;
 begin
   Printer.GetPrinter(Device, Driver, Port, hDevmode);
   Result := WinSpool.DeviceCapabilities(Device, Port, DC_DUPLEX, nil, nil) <> 0;
 end;


//////////////////////////////////////////////////////
//                П Р О Ц Е Д У Р Ы                 //
//////////////////////////////////////////////////////

// ПРОЦЕДУРА Печать пробной страницы Windows без диалога
procedure TForm1.PrintStandartTestPageWhitoutDialog();
var
  i: Integer;
  n: Integer;
  cmd: string;
begin
  n := StrToInt(EditNumberOfCopy.Text);
  for i:= 1 to n do
  begin
    //cmd := 'RUNDLL32 PRINTUI.DLL,PrintUIEntry /k /n"' + Trim(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption) + '"';
    //WinExec(PAnsiChar(AnsiString(cmd)), SW_HIDE);
    cmd := 'PRINTUI.DLL,PrintUIEntry /k /n"' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', 'rundll32.exe', Pchar(cmd), nil, SW_NORMAL);
  end;
end;

// ПРОЦЕДУРА  окно очереди печати
procedure TForm1.WindowPrintQueue();
var
  cmd: string;
begin
    //cmd := 'RUNDLL32 PRINTUI.DLL,PrintUIEntry /o /n"' + Trim(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption) + '"';
    //WinExec(PAnsiChar(AnsiString(cmd)), SW_HIDE);
    cmd := 'PRINTUI.DLL,PrintUIEntry /o /n"' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', 'rundll32.exe', Pchar(cmd), nil, SW_NORMAL);
end;

// ПРОЦЕДУРА  Провека Дюз Epson
procedure TForm1.NozzleCheckEpson();
var
  cmd: string;
begin
    cmd := ' "spool\epson_nozzle_check.spl" "' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', Pchar('spool\spool.exe'), Pchar(cmd), nil, SW_HIDE);
end;

// ПРОЦЕДУРА  Провека Дюз Canon
procedure TForm1.NozzleCheckCanon();
var
  cmd: string;
begin
    cmd := ' "spool\canon_nozzle_check.spl" "' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', Pchar('spool\spool.exe'), Pchar(cmd), nil, SW_HIDE);
end;

// ПРОЦЕДУРА  Прочистка ПГ Epson
procedure TForm1.HeadCleaningEpsonNormal();
var
  cmd: string;
begin
    cmd := ' "spool\epson_head_cleaning_normal.spl" "' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', Pchar('spool\spool.exe'), Pchar(cmd), nil, SW_HIDE);
end;

// ПРОЦЕДУРА  Прочистка ПГ Epson Strong
procedure TForm1.HeadCleaningEpsonDeep();
var
  cmd: string;
begin
    cmd := ' "spool\epson_head_cleaning_deep.spl" "' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', Pchar('spool\spool.exe'), Pchar(cmd), nil, SW_HIDE);
end;

// ПРОЦЕДУРА  Прочистка ПГ Canon Normal
procedure TForm1.HeadCleaningCanonNormal();
var
  cmd: string;
begin
    cmd := ' "spool\canon_head_cleaning_normal.spl" "' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', Pchar('spool\spool.exe'), Pchar(cmd), nil, SW_HIDE);
end;

// ПРОЦЕДУРА  Прочистка ПГ Canon Deep
procedure TForm1.HeadCleaningCanonDeep();
var
  cmd: string;
begin
    cmd := ' "spool\canon_head_cleaning_deep.spl" "' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', Pchar('spool\spool.exe'), Pchar(cmd), nil, SW_HIDE);
end;

// ПРОЦЕДУРА  Прочистка ПГ Canon Starter
procedure TForm1.HeadCleaningCanonStarter();
var
  cmd: string;
begin
    cmd := ' "spool\canon_head_cleaning_system_starter.spl" "' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', Pchar('spool\spool.exe'), Pchar(cmd), nil, SW_HIDE);
end;

// ПРОЦЕДУРА окно свойства принтера
procedure TForm1.WindowPrinterProperties();
var
  cmd: string;
begin
    //cmd := 'RUNDLL32 PRINTUI.DLL,PrintUIEntry /p /n"' + Trim(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption) + '"';
    //WinExec(PAnsiChar(AnsiString(cmd)), SW_HIDE);
    cmd := 'PRINTUI.DLL,PrintUIEntry /p /n"' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', 'rundll32.exe', Pchar(cmd), nil, SW_NORMAL);
end;

// ПРОЦЕДУРА окно вывод параметров настройки печати
procedure TForm1.WindowOutputPrintSettings();
var
  cmd: string;
begin
    //cmd := 'RUNDLL32 PRINTUI.DLL,PrintUIEntry /e /n"' + Trim(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption) + '"';
    //WinExec(PAnsiChar(AnsiString(cmd)), SW_HIDE);
    cmd := 'PRINTUI.DLL,PrintUIEntry /e /n"' + ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption + '"';
    ShellExecute(handle, 'open', 'rundll32.exe', Pchar(cmd), nil, SW_NORMAL);
end;

// ПРОЦЕДУРА Активации элемента ScrollBox1 когда над ним мышка
procedure TForm1.ScrollBox1MouseEnter(Sender: TObject);
begin
   ScrollBox1.SetFocus;
end;

// ПРОЦЕДУРА скролинга ScrollBox
procedure TForm1.ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  WheelDelta := WheelDelta div 4;
  ScrollBox1.VertScrollBar.Position := ScrollBox1.VertScrollBar.Position - WheelDelta;
end;

// ПРОЦЕДУРА Получения списка только ONLINE принтеров
procedure TForm1.ListPrinter2();
var
  i, i3: Integer;
  name_def_printer: String;
begin
   // Очищаем список
  ListViewPrinter.Clear;

  // Обновляем список принтеров
  Printer.Free;
  TPrinter.Create;

  // Имя принтера по умолчанию
  name_def_printer := Printer.Printers.Strings[Printer.PrinterIndex];

  // Строим список принтеров
  i :=  Printer.Printers.Count - 1;
  While i >= 0 Do
  begin

       if GetPrinterStatus ( Printer.Printers.Strings[i] ) = 1 then
       begin
          with ListViewPrinter.Items.Add do
          begin
            Caption := Printer.Printers.Strings[i]; // Заголовок
            ImageIndex:= 3;  // Картинка
          end;
       end;
       Dec(i);
  end;

  // Выделяем и подсвечиваем принтер по умолчанию
  i3 := ListViewPrinter.Items.Count - 1;
  While i3 >= 0 Do
  begin
    if Trim(ListViewPrinter.Items[i3].Caption) = Trim(name_def_printer) then
      begin
        ListViewPrinter.ItemIndex := i3;
      end;
    Dec(i3);
  end;

end;

// ПРОЦЕДУРА Старт формы
procedure TForm1.FormCreate(Sender: TObject);
var
  Registry: TRegistry;
begin
  //ListPrinter;
  ListPrinter2;
  GetImageFiles;

  // Загружаем с реестра значения положения окна
  Registry := TRegistry.Create;
  Registry.RootKey := HKEY_CURRENT_USER;
  Registry.OpenKey('\SOFTWARE\TestPageProgram',True);

  if Registry.ValueExists('Left') then Form1.Left := Registry.ReadInteger('Left');
  if Registry.ValueExists('Top') then Form1.Top := Registry.ReadInteger('Top');
  if Registry.ValueExists('Width') then Form1.Width := Registry.ReadInteger('Width');
  if Registry.ValueExists('Height') then Form1.Height := Registry.ReadInteger('Height');

  Registry.Free;

end;

// ПРОЦЕДУРА Сохраняем в реестре значения положения окна
procedure TForm1.FormDestroy(Sender: TObject);
var
  Registry: TRegistry;
begin
  Registry := TRegistry.Create;
  Registry.RootKey := HKEY_CURRENT_USER;
  Registry.OpenKey('\SOFTWARE\TestPageProgram',True);

  Registry.WriteInteger('Left', Form1.Left);
  Registry.WriteInteger('Top', Form1.Top);
  Registry.WriteInteger('Width', Form1.Width);
  Registry.WriteInteger('Height', Form1.Height);

  Registry.Free;
end;

// ПРОЦЕДУРА Рисование картинок на Scrollbox и получения списка файлов
procedure TForm1.GetImageFiles();
var
   searchResult: TSearchRec;
   img : TImage;
   x, y, count : Integer;
   pic_in_widh: Integer;
   count_str_in_scrollbox : Integer;
begin
     count_str_in_scrollbox := 1; // Кол-во строк в скролбоксе
     pic_in_widh := Round(ScrollBox1.Width / 120); // Кол-во картинок по ширине 8 шт счет с нуля

     if FindFirst( './files/*.bmp', faAnyFile, searchResult) = 0 then
       begin
          x := 10;  // стартовое значение по горизонтали
          y := 10;  // стартовое значение по вертикали
          count := 1;  // просто счетчик картинок
         repeat
          //ShowMessage('searchResult = ' + searchResult.Name);
          // Создаем обычный Image и играемся с ним
          img := TImage.Create(ScrollBox1);
          img.Parent := ScrollBox1;
          img.Picture.Bitmap.LoadFromFile('files/' + searchResult.Name);
          img.Name := ChangeFileExt(ExtractFileName(searchResult.Name),'');  // Получаем только имя без .bmp
          img.Width := 100;
          img.Height := 130;
          img.Stretch := True;
          img.Left := x;
          img.Top := y;

          img.NameAndExtension := searchResult.Name;  // Храним имя и расширение
          img.ImageCheck := False; // Храним состояние Выделенна картинка или нет
          img.OnClick := select_checkbox_2;

          case count of
              0..7:
                begin
                  x := x + 112; // сдвигаем по горизонтали
                end;
              8:
                begin
                  x := 10; // стартовое значение
                  y := y + 140;  // смещение по вертикали
                End;
              9:
                begin
                  x := x + 112; // сдвигаем по горизонтали
                  Inc(count_str_in_scrollbox); // увеличиваем значение скролбокса
                  count := 1; // Обнуляем счетчик для новой строки
                end;
          end;
          Inc(count);  // увеличиваем счетчик
         until FindNext(searchResult) <> 0;


       end;
       FindClose(searchResult);
       // Настриваиваем скролбар чтобы видел что у него в нутри что-то да есть
       ScrollBox1.VertScrollBar.Range := count_str_in_scrollbox * 145;
end;

// ПРОЦЕДУРА выделяем Картинку по клику
procedure TForm1.select_checkbox_2(Sender:TObject);
var
  i :integer;
  BitmapImg: TBitmap;
  NameAndExtension: String;
begin
  NameAndExtension := (Sender as TImage).NameAndExtension; // получаем имя с расширением через указатель на картинку

  BitmapImg := TBitmap.Create;    // Создаем  Bitmap
  BitmapImg.LoadFromFile('files/' + NameAndExtension);  // Загружаем картинку

  with ScrollBox1 do      // ищем имя в ScrollBox1
    for i := 0 to ComponentCount-1 do
      begin

        if TImage(Components[i]).NameAndExtension = trim(NameAndExtension) then    // если нашли
        begin

          if TImage(Components[i]).ImageCheck = False then
            begin
              if BitmapImg.Width > 2000 then
                begin
                  TImage(Components[i]).Canvas.Pen.Width := 100;  //толщина рамки
                end
              else if (BitmapImg.Width < 2000) and (BitmapImg.Width > 1000) then
                begin
                  TImage(Components[i]).Canvas.Pen.Width := 50;  //толщина рамки
                end
              else if BitmapImg.Width < 1000 then
                begin
                  TImage(Components[i]).Canvas.Pen.Width := 25;  //толщина рамки
                end;

              TImage(Components[i]).Canvas.Pen.Color := clRed; //цвет рамки
              TImage(Components[i]).Canvas.Brush.Style := bsClear; // стиль
              TImage(Components[i]).Canvas.Rectangle(0,0, BitmapImg.Width, BitmapImg.Height);//рисуем квадрат (рамку)

              TImage(Components[i]).ImageCheck := True; // Запоминаем состояние картинки она ВЫБРАННА
            end
          else
            begin
              TImage(Components[i]).Picture.Bitmap := BitmapImg;
              TImage(Components[i]).ImageCheck := False; // Запоминаем состояние картинки она НЕ ВЫБРАННА
            end;

        end;

      end;
  BitmapImg.Destroy;   // Очищаем  Bitmap
end;

// ПРОЦЕДУРА Бегунка
procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  EditNumberOfCopy.Text := IntToStr(TrackBar1.Position);
end;

// ПРОЦЕДУРА формировани картинки и подгона его под лист А4
procedure TForm1.PrintImage(ImageBitmap: TImage);
var
  //TempImageBMP: TBitmap;
  PRect: Trect;
  MetaFile:TMetafile;
  MetaCanvas:TMetafileCanvas;

begin
  //TempImageBMP := TBitmap.Create; // Создаю BMP
  //TempImageBMP.LoadFromFile('./files/'+ ImageBitmap.Name +'.bmp');
  //TempImageBMP.Assign(ImageBitmap.Picture.Bitmap); // Засовываю JPG в режими JPEG в BMP в режиме Bitmap

  with PRect do
  begin
    left:=0;
    top:=0;
    right:=Printer.PageWidth;
    Bottom:=Printer.PageHeight;
  end;

  // Создаем метафайл (векторный рисунок)
  MetaFile:= TMetafile.Create;
  MetaFile.Height:= ImageBitmap.Picture.Bitmap.Height;
  MetaFile.Width:= ImageBitmap.Picture.Bitmap.Width;
  // Рисуем метафайл
  MetaCanvas:= TMetafileCanvas.Create(MetaFile,0);
  MetaCanvas.Draw(0,0, ImageBitmap.Picture.Bitmap);
  // Конец рисования
  MetaCanvas.Free;
  // Запускаем в печать
  Printer.Canvas.StretchDraw(PRect, MetaFile);
  // Очищаем память
  MetaFile.Free;
end;

// ПРОЦЕДУРА Печать картинки С диалогом
procedure TForm1.PrintFromImageWithDialog();
var
  i, num_all_cb: Integer;
  img_temp : TImage;
begin
  // Выбираем принтер
  Printer.PrinterIndex := Printer.Printers.IndexOf(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption);

  // Ставим кол-во копий
  PrintDialog1.Copies := StrToInt(EditNumberOfCopy.Text);

  // Запуск диалога
  if PrintDialog1.Execute then
    Begin
      // Кол-во выделеных  Checkbox
      num_all_cb := GetAllSelectCheckbox - 1;
      // Запускаем подготовку к печати
      Printer.BeginDoc;
      // Ищем все в ScrollBox
      with ScrollBox1 do     // Ищем все в ScrollBox
            for i := 0 to ComponentCount - 1 do  // считаем кол-во всех элементов
              begin
                // если это TImage и он Checked
                if TImage(Components[i]).ImageCheck = True then
                  begin

                    // Создаем TImage
                    img_temp := TImage.Create(Self);
                    // загружаем картинку иначе будет с рамкой
                    img_temp.Picture.Bitmap.LoadFromFile('files/' + TImage(Components[i]).NameAndExtension);
                    // Передаем имя в в печать
                    PrintImage( img_temp );
                    // Очищаем память
                    img_temp.Free;

                    // Новый лист нужен ?
                    if num_all_cb > 0 then
                    begin
                      Printer.NewPage;
                      Dec(num_all_cb);
                    end;

                  end;
              end;
      // Подготовка листов законцена можно печатать
      Printer.EndDoc;
     end;
end;

// ПРОЦЕДУРА Печать картинки БЕЗ диалога
procedure TForm1.PrintFromImageWithoutDialog();
var
   i, num_all_cb: Integer;
   img_temp : TImage;
begin
  // Выбираем принтер
  Printer.PrinterIndex := Printer.Printers.IndexOf(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption);

  // Ставим кол-во копий
  Printer.Copies := StrToInt(EditNumberOfCopy.Text);

  // Кол-во выделеных  Checkbox
  num_all_cb := GetAllSelectCheckbox - 1;
  // Запускаем подготовку к печати
  Printer.BeginDoc;
  // Ищем все в ScrollBox
  with ScrollBox1 do     // Ищем все в ScrollBox
        for i := 0 to ComponentCount - 1 do  // считаем кол-во всех элементов
          begin
            // если это TImage и он Checked
            if TImage(Components[i]).ImageCheck = True then
              begin

                // Создаем TImage
                img_temp := TImage.Create(Self);
                // загружаем картинку иначе будет с рамкой
                img_temp.Picture.Bitmap.LoadFromFile('files/' + TImage(Components[i]).NameAndExtension);
                // Передаем имя в в печать
                PrintImage( img_temp );
                // Очищаем память
                img_temp.Free;

                // Новый лист нужен ?
                if num_all_cb > 0 then
                begin
                  Printer.NewPage;
                  Dec(num_all_cb);
                end;

              end;
          end;
  // Подготовка листов законцена можно печатать
  Printer.EndDoc;
end;

// ПРОЦЕДУРА проверки лотка для Дюплекс режима и Печать
procedure TForm1.ChangePrinterTray;
var
  Device: array[0..255] of char;
  Driver: array[0..255] of char;
  Port: array[0..255] of char;
  hDMode: THandle;
  PDMode: PDEVMODE;
  i : Integer;
  img_temp : TImage;
begin
  // Выбираем принтер
  Printer.PrinterIndex := Printer.Printers.IndexOf(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption);

  // Проверяем принтер на режим дюплекса, если есть то включем его
  //if PrinterSupportsDuplex then
  //begin

    // Включаем дюплекс
    Printer.GetPrinter(Device, Driver, Port, hDMode);

        if hDMode <> 0 then
        begin
          pDMode := GlobalLock(hDMode);
          if pDMode <> nil then
          begin
              pDMode^.dmFields := pDMode^.dmFields or DM_DEFAULTSOURCE;

              // Выбор лотка
              if RadioButton_auto.Checked then pDMode^.dmDefaultSource := DMBIN_AUTO;
              if RadioButton_manual.Checked then pDMode^.dmDefaultSource := DMBIN_MANUAL;
              if RadioButton_lotok1.Checked then pDMode^.dmDefaultSource := 1;
              if RadioButton_lotok2.Checked then pDMode^.dmDefaultSource := 2;

              //pDMode^.dmDefaultSource := DMBIN_MANUAL;
              // 0 DMBIN_AUTO, 1 Лоток_1, DMBIN_MANUAL Ручная_настройка

              // Включае дюплекс
              pDMode^.dmFields := pDMode^.dmFields or DM_DUPLEX;
              pDMode^.dmDuplex := DMDUP_VERTICAL; //Использовать двухстороннюю печать


              //pDMode^.dmDuplex := DMDUP_SIMPLEX;   // отключение дюплекса
              //Printer.SetPrinter(Device, Driver, Port, hDMode);
              GlobalUnlock(hDMode);
          end;
        end;

        // Выбираем принтер для печати
        Printer.PrinterIndex := Printer.Printers.IndexOf(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption);

        // Ставим кол-во копий
        Printer.Copies := StrToInt(EditNumberOfCopy.Text);

      // Запуск диалога
      if PrintDialog1.Execute then
      Begin
        // Ищем все в ScrollBox
        (*
        with ScrollBox1 do     // Ищем все в ScrollBox
              for i := 0 to ControlCount - 1 do  // считаем кол-во всех элементов
                begin
                  // если это TCheckBox и он Checked
                  if (Controls[i] is TCheckBox) and (Controls[i] as TCheckBox).Checked then
                    begin
                      // получаем имя TImage
                      string_temp := ChangeFileExt(ExtractFileName((Controls[i] as TCheckBox).Caption),'') ;
                      // Подготовка листов
                      Printer.BeginDoc;
                      // Передаем имя в в печать
                      PrintImage( (FindComponent(string_temp) as TImage) );
                      // Добавляем новую страницу
                      Printer.NewPage;
                      // Передаем имя в в печать
                      PrintImage( (FindComponent(string_temp) as TImage) );
                      // Подготовка листов законцена можно печатать
                      Printer.EndDoc;
                    end;
                end;
            *)
        with ScrollBox1 do     // Ищем все в ScrollBox
        for i := 0 to ComponentCount - 1 do  // считаем кол-во всех элементов
          begin
            // если это TImage и он Checked
            if TImage(Components[i]).ImageCheck = True then
              begin
                // Создаем TImage
                img_temp := TImage.Create(Self);
                // загружаем картинку иначе будет с рамкой
                img_temp.Picture.Bitmap.LoadFromFile('files/' + TImage(Components[i]).NameAndExtension);
                // Подготовка листов
                Printer.BeginDoc;
                // Передаем имя в в печать
                PrintImage(img_temp);
                // Добавляем новую страницу
                Printer.NewPage;
                // Передаем имя в в печать
                PrintImage(img_temp);
                // Подготовка листов законцена можно печатать
                Printer.EndDoc;
                // Очищаем память
                img_temp.Free;
              end;
          end;
      end;

  //end
  //else  ShowMessage('Этот принтер/мфу не поддерживает Duplex режим');

    // Отключаем дюплекс
    Printer.GetPrinter(Device, Driver, Port, hDMode);   // Выбрали принтер

    if hDMode <> 0 then
    begin
    pDMode := GlobalLock(hDMode);  // заблокировали настройки
      if pDMode <> nil then
        begin
          pDMode^.dmFields := pDMode^.dmFields or DM_DEFAULTSOURCE;
          pDMode^.dmDefaultSource := DMBIN_AUTO;
          pDMode^.dmDuplex := DMDUP_SIMPLEX;  // отключаем дюплекс
          GlobalUnlock(hDMode);  // разблокировали настройки
        end;
    end;

end;


////////////////////////////////////////////////
//                К Н О П К И                 //
////////////////////////////////////////////////

// КНОПКА Обновить список принтеров
procedure TForm1.Button2Click(Sender: TObject);
begin
   ListPrinter2;
end;

// КНОПКА Сброс всех установок пользователя
procedure TForm1.Button_Clear_All_SettingClick(Sender: TObject);
var
  i: Integer;
begin
  // Убираем рамки в тестовых листах
  with ScrollBox1 do
  for i := 0 to ComponentCount - 1 do
  begin
    if TImage(Components[i]).ImageCheck = True then
    begin
       TImage(Components[i]).Picture.LoadFromFile('files/' + TImage(Components[i]).NameAndExtension);
       TImage(Components[i]).ImageCheck := False;
    end;
  end;
  // Обнуляем количество копий и бегунок
  EditNumberOfCopy.Text := '1';
  TrackBar1.Position := 1;
  // Ставим лоток в руной режим
  RadioButton_manual.Checked := True;
end;

// КНОПКА Уменьшить кол-во копий
procedure TForm1.ButtonDecLeftClick(Sender: TObject);
begin
   if StrToInt(EditNumberOfCopy.Text) > 1 then
   begin
      EditNumberOfCopy.Text :=  IntToStr( StrToInt(EditNumberOfCopy.Text) - 1 );
      TrackBar1.Position := StrToInt(EditNumberOfCopy.Text) ; // Изменяем положение бегунка
   end;
end;

// КНОПКА Увеличить кол-во копий
procedure TForm1.ButtonIncRightClick(Sender: TObject);
begin
  EditNumberOfCopy.Text :=  IntToStr( StrToInt(EditNumberOfCopy.Text) + 1 );
  TrackBar1.Position := StrToInt(EditNumberOfCopy.Text) ;  // Изменяем положение бегунка
end;

// КНОПКА Пробная страница печати Windows без диалога
procedure TForm1.ButtonStandartPageWindowsClick(Sender: TObject);
begin
  if (CheckSelectPrinter = 1) then PrintStandartTestPageWhitoutDialog;
end;

// КНОПКА Печать с диалогом
procedure TForm1.ButtonStarTestWithDialogClick(Sender: TObject);
begin
  if (CheckSelectPrinter = 1) AND (CheckSelectTestList = 1) then  PrintFromImageWithDialog;
end;

// КНОПКА Печать без диалога
procedure TForm1.ButtonStarTestWithoutDialogClick(Sender: TObject);
begin
   if (CheckSelectPrinter = 1) AND (CheckSelectTestList = 1) then  PrintFromImageWithoutDialog;
end;

// КНОПКА Печать в Duplex режиме
procedure TForm1.Button1Click(Sender: TObject);
begin
   if (CheckSelectPrinter = 1) AND (CheckSelectTestList = 1) then ChangePrinterTray;
end;

// КНОПКА запуск прочистки печатающей головки. Обычная
procedure TForm1.Button_Head_Cleaning_NormalClick(Sender: TObject);
var
  NamePrinter: string;
begin
  //ShowMessage(IntToStr(GetAllSelectCheckbox));
  NamePrinter := LowerCase(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption); // Получаем имя в нижнем регистре
  if CheckSelectPrinter = 1 then
    begin
      if Pos('canon', NamePrinter) > 0 then
      begin
         //Label1.Caption := 'canon';
         HeadCleaningCanonNormal;
      end;
      if Pos('epson', NamePrinter) > 0 then
      begin
         //Label1.Caption := 'epson';
         HeadCleaningEpsonNormal;
      end;
    end;
end;

// КНОПКА запуск прочистки печатающей головки. Глубокая
procedure TForm1.Button_Head_Cleaning_DeepClick(Sender: TObject);
var
  NamePrinter: string;
begin
  NamePrinter := LowerCase(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption); // Получаем имя в нижнем регистре
  if CheckSelectPrinter = 1 then
    begin
      if Pos('canon', NamePrinter) > 0 then
      begin
         //Label1.Caption := 'canon';
         HeadCleaningCanonDeep;
      end;
      if Pos('epson', NamePrinter) > 0 then
      begin
         //Label1.Caption := 'epson';
         HeadCleaningEpsonDeep;
      end;
    end;
end;

// КНОПКА запуск первоначальной прокачки
procedure TForm1.Button_Head_Cleaning_StarterClick(Sender: TObject);
var
  NamePrinter: string;
begin
  NamePrinter := LowerCase(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption); // Получаем имя в нижнем регистре
  if CheckSelectPrinter = 1 then
    begin
      if Pos('canon', NamePrinter) > 0 then
      begin
         //Label1.Caption := 'canon';
         HeadCleaningCanonStarter;
      end;
      if Pos('epson', NamePrinter) > 0 then
      begin
         //Label1.Caption := 'epson';
         ShowMessage('Для Epson еще нет');
      end;
    end;
end;


// КНОПКА запуск проверки дюз
procedure TForm1.Button_Nozzle_CheckClick(Sender: TObject);
var
  NamePrinter: string;
begin
  NamePrinter := LowerCase(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption); // Получаем имя в нижнем регистре
  if CheckSelectPrinter = 1 then               // Проверка на выделение принтера
    begin
      if Pos('canon', NamePrinter) > 0 then
      begin
         //Label1.Caption := 'canon';
         NozzleCheckCanon;
      end;
      if Pos('epson', NamePrinter) > 0 then
      begin
         //Label1.Caption := 'epson';
         NozzleCheckEpson;
      end;
    end;
end;

//////////////////////////////////////////////////////////
//                П Р А В Ы Й   К Л И К                 //
//////////////////////////////////////////////////////////

// ПРАВЫЙ КЛИК по Очередь печати над ListViewPrinter
procedure TForm1.N1Click(Sender: TObject);
begin
    WindowPrintQueue;
end;

// ПРАВЫЙ КЛИК по Свойству принтера над ListViewPrinter
procedure TForm1.N2Click(Sender: TObject);
begin
   WindowPrinterProperties;
end;

// ПРАВЫЙ КЛИК по Настройка печати над ListViewPrinter
procedure TForm1.N3Click(Sender: TObject);
begin
   WindowOutputPrintSettings;
end;


end.
