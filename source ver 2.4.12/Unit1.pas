unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Printers, Winspool,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Imaging.jpeg, ShellApi, System.ImageList,
  Vcl.ImgList, Vcl.Grids, Vcl.FileCtrl, GDIPAPI,GDIPOBJ, Vcl.ButtonGroup,
  Vcl.Menus;

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
    GroupBox3: TGroupBox;
    ButtonClearAllSelectChecbox: TButton;
    ButtonIncRight: TButton;
    ButtonDecLeft: TButton;

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
    procedure select_checkbox(Sender:TObject);
    function GetAllSelectCheckbox:integer;
    function PrinterSupportsDuplex: Boolean;
    function GetPrinterStatus(PrinterName: string) : Integer;
    procedure ScrollBox1MouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure ScrollBox1Click(Sender: TObject);
    //procedure ListViewPrinterColumnClick(Sender: TObject; Column: TListColumn);
    procedure WindowPrintQueue();
    procedure WindowPrinterProperties();
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure WindowOutputPrintSettings();
    procedure N3Click(Sender: TObject);
    procedure ListPrinter2();
    procedure Button2Click(Sender: TObject);

    procedure ButtonClearAllSelectChecboxClick(Sender: TObject);
    procedure ButtonIncRightClick(Sender: TObject);
    procedure ButtonDecLeftClick(Sender: TObject);
    function CheckSelectTestList() : Integer;
    function CheckSelectPrinter() : Integer;

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{
 // Получить имя выделенного принтера
 ListView1.Items[ListView1.ItemIndex].Caption

 // Индекс выделленного принтера
 Printer.Printers.IndexOf(ListView1.Items[ListView1.ItemIndex].Caption);

 ChangeFileExt(ExtractFileName(ИМЯ_С_РАЗРЕШЕНИЕМ),'');  // Получаем только имя без .jpg

}

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

// ПРОЦЕДУРА устанавливаем фокус при клике на ScrollBox активируем его
procedure TForm1.ScrollBox1Click(Sender: TObject);
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


// КЛИК по Очередь печати над ListViewPrinter
procedure TForm1.N1Click(Sender: TObject);
begin
    WindowPrintQueue;
end;

// КЛИК по Свойству принтера над ListViewPrinter
procedure TForm1.N2Click(Sender: TObject);
begin
   WindowPrinterProperties;
end;

// КЛИК по Настройка печати над ListViewPrinter
procedure TForm1.N3Click(Sender: TObject);
begin
   WindowOutputPrintSettings;
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

// КНОПКА Обновить список принтеров
procedure TForm1.Button2Click(Sender: TObject);
begin
   ListPrinter2;
end;

// КНОПКА Снять все чекбоксы в тестовых листах
procedure TForm1.ButtonClearAllSelectChecboxClick(Sender: TObject);
var
  i: Integer;
begin
  with ScrollBox1 do
  for i := 0 to ControlCount - 1 do
  begin
    if (Controls[i] is TCheckBox) and (Controls[i] as TCheckBox).Checked then
    begin
        (Controls[i] as TCheckBox).Checked := False;
    end;
  end;
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

// КНОПКА  Печать в Duplex режиме
procedure TForm1.Button1Click(Sender: TObject);
begin
   if (CheckSelectPrinter = 1) AND (CheckSelectTestList = 1) then ChangePrinterTray;
end;

// ПРОЦЕДУРА Старт формы
procedure TForm1.FormCreate(Sender: TObject);
begin
  //ListPrinter;
  ListPrinter2;
  GetImageFiles;
end;

// ПРОЦЕДУРА получения списка файлов
procedure TForm1.GetImageFiles();
var
   searchResult: TSearchRec;
   img : TImage;
   cb : TCheckBox;
   x, y, count : Integer;
begin
     if FindFirst( './files/*.bmp', faAnyFile, searchResult) = 0 then
       begin
        x := 20;  // стартовое значение
        y := 30;
        count := 1;
         repeat
          // Создаем обычный Image и играемся с ним
          img := TImage.Create(ScrollBox1);
          //img.Picture.Bitmap.PixelFormat := pf16bit;
          //img.Picture.Bitmap.HandleType := bmDIB;
          img.Parent := ScrollBox1;
          img.Picture.Bitmap.LoadFromFile('files/' + searchResult.Name);
          img.Name := ChangeFileExt(ExtractFileName(searchResult.Name),'');  // Получаем только имя без .bmp
          img.Width := 100;
          img.Height := 130;
          img.Stretch := True;
          img.Left := x;
          img.Top := y;

          img.Hint := searchResult.Name;  // Храним имя и разрешение в hint
          img.OnClick := select_checkbox;

          // Создаем чекбокс
          cb := TCheckBox.Create(ScrollBox1);
          cb.Parent := ScrollBox1;
          cb.Caption := searchResult.Name;
          cb.Left := x;
          cb.Top := y - 20;

          // отступ по горизонтали
          if count = 5 then
            begin
              x := 20; // стартовое значение
              count := 0;
              y := y + 160;
            end
          else
            begin
              x := x + 120;
            end;

          Inc(count);
         until FindNext(searchResult) <> 0;

       end;
       FindClose(searchResult);
end;

// ПРОЦЕДУРА выбор чекбокса при клике на картинку
procedure TForm1.select_checkbox(Sender:TObject);
var
  img_hint: string;
  i:integer;
begin
  img_hint := (Sender as TImage).Hint; // имя

  with ScrollBox1 do
    for i := 0 to ComponentCount-1 do
      begin

        if TCheckBox(Components[i]).Caption = trim(img_hint) then
        begin
          if TCheckBox(Components[i]).Checked = True then TCheckBox(Components[i]).Checked := False
          else TCheckBox(Components[i]).Checked := True;
        end;

      end;
end;

// Бегунок
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
  string_temp : String;
begin
  // Выбираем принтер
  Printer.PrinterIndex := Printer.Printers.IndexOf(ListViewPrinter.Items[ListViewPrinter.ItemIndex].Caption);

  // Ставим кол-во копий
  PrintDialog1.Copies := StrToInt(EditNumberOfCopy.Text);

  // Запуск диалога
  if PrintDialog1.Execute then
    Begin
      num_all_cb := GetAllSelectCheckbox - 1; // Кол-во выделеных  Checkbox
      Printer.BeginDoc;
      // Ищем все в ScrollBox
      with ScrollBox1 do     // Ищем все в ScrollBox
            for i := 0 to ControlCount - 1 do  // считаем кол-во всех элементов
              begin
                // если это TCheckBox и он Checked
                if (Controls[i] is TCheckBox) and (Controls[i] as TCheckBox).Checked then
                  begin

                    // получаем имя TImage
                    string_temp := ChangeFileExt(ExtractFileName((Controls[i] as TCheckBox).Caption),'') ;

                    //ShowMessage( (FindComponent('color_1') as TImage) );

                    // Передаем имя в в печать
                    PrintImage( (FindComponent(string_temp) as TImage) );


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
   string_temp : String;
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
        for i := 0 to ControlCount - 1 do  // считаем кол-во всех элементов
          begin
            // если это TCheckBox и он Checked
            if (Controls[i] is TCheckBox) and (Controls[i] as TCheckBox).Checked then
              begin

                // получаем имя TImage
                string_temp := ChangeFileExt(ExtractFileName((Controls[i] as TCheckBox).Caption),'') ;

                //ShowMessage( (FindComponent('color_1') as TImage) );
                //ShowMessage( string_temp );
                // Передаем имя в в печать
                PrintImage( (FindComponent(string_temp) as TImage) );


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

// ФУНКЦИЯ возвращает сколько листов выделенно
function TForm1.GetAllSelectCheckbox:integer;
var
  i: Integer;
  all_select: Integer;
begin
  all_select := 0;
  with ScrollBox1 do
  for i := 0 to ControlCount - 1 do
  begin
    if (Controls[i] is TCheckBox) and (Controls[i] as TCheckBox).Checked then
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

// ПРОЦЕДУРА проверки лотка для Дюплекс режима
procedure TForm1.ChangePrinterTray;
var
  Device: array[0..255] of char;
  Driver: array[0..255] of char;
  Port: array[0..255] of char;
  hDMode: THandle;
  PDMode: PDEVMODE;
  i : Integer;
  //num_all_cb: Integer;
  string_temp: String;
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
        //num_all_cb := GetAllSelectCheckbox - 1; // Кол-во выделеных  Checkbox
        //Printer.BeginDoc;
        // Ищем все в ScrollBox
        with ScrollBox1 do     // Ищем все в ScrollBox
              for i := 0 to ControlCount - 1 do  // считаем кол-во всех элементов
                begin
                  // если это TCheckBox и он Checked
                  if (Controls[i] is TCheckBox) and (Controls[i] as TCheckBox).Checked then
                    begin

                      // получаем имя TImage
                      string_temp := ChangeFileExt(ExtractFileName((Controls[i] as TCheckBox).Caption),'') ;

                      Printer.BeginDoc;
                      //ShowMessage( (FindComponent('color_1') as TImage) );
                      // Передаем имя в в печать
                      PrintImage( (FindComponent(string_temp) as TImage) );

                      Printer.NewPage;

                      PrintImage( (FindComponent(string_temp) as TImage) );
                      // Новый лист нужен ?
                      {
                      if num_all_cb > 0 then
                      begin
                        Printer.NewPage;
                        Dec(num_all_cb);
                      end;
                      }
                      Printer.EndDoc;
                    end;
                end;
        // Подготовка листов законцена можно печатать
        //Printer.EndDoc;
        end;

  //end
  //else  ShowMessage('Этот принтер/мфу не поддерживает Duplex режим');

end;


end.
