unit unit_test_pages;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  Printers, ExtCtrls, PrintersDlgs;

type

  { TForm1 }

  TForm1 = class(TForm)
    ButtonStarTestWithDialog: TButton;
    ButtonStarTestWithoutDialog: TButton;
    EditNumberOfCopy: TEdit;
    ImageMonochrome1: TImage;
    ImageMonochrome2: TImage;
    ImageMonochrome3: TImage;
    ImageMonochrome4: TImage;
    ImageColor1: TImage;
    ImageColor2: TImage;
    ImageColor3: TImage;
    ImageColor4: TImage;
    Label1: TLabel;
    Label2: TLabel;
    ListBoxPrinter: TListBox;
    PrintDialog1: TPrintDialog;
    RadioButtonMonochrome1: TRadioButton;
    RadioButtonMonochrome2: TRadioButton;
    RadioButtonMonochrome3: TRadioButton;
    RadioButtonMonochrome4: TRadioButton;
    RadioButtonColor1: TRadioButton;
    RadioButtonColor2: TRadioButton;
    RadioButtonColor3: TRadioButton;
    RadioButtonColor4: TRadioButton;
    RadioButtonStandartTestPage: TRadioButton;
    TrackBar1: TTrackBar;
    procedure ButtonStarTestWithDialogClick(Sender: TObject);
    procedure ButtonStarTestWithoutDialogClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ImageColor1Click(Sender: TObject);
    procedure ImageColor2Click(Sender: TObject);
    procedure ImageColor3Click(Sender: TObject);
    procedure ImageColor4Click(Sender: TObject);
    procedure ImageMonochrome1Click(Sender: TObject);
    procedure ImageMonochrome2Click(Sender: TObject);
    procedure ImageMonochrome3Click(Sender: TObject);
    procedure ImageMonochrome4Click(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure ListPrinter();
    procedure PrintImage(Image: TImage);
    procedure PrintFromImageWithDialog(Image: TImage);
    procedure PrintFromImageWithoutDialog(Image: TImage);
    procedure PrintStandartTestPageWhitDialog();
    procedure PrintStandartTestPageWhitoutDialog();
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }
// Печать тестовой страницы
procedure TForm1.PrintStandartTestPageWhitoutDialog();
var
  s: String;
  i: Integer;
  n: Integer;
begin
  n := StrToInt(EditNumberOfCopy.Text);
  for i:= 1 to n do
  begin
    s := 'RUNDLL32 PRINTUI.DLL,PrintUIEntry /n"'
         + ListBoxPrinter.Items[ListBoxPrinter.ItemIndex]
         + '" /k';
    SysUtils.ExecuteProcess(s, '', []);
  end;
end;

// Печать тестовой страницы
procedure TForm1.PrintStandartTestPageWhitDialog();
var
  s: String;
  i: Integer;
  n: Integer;
begin
   // Выбираем принтер
   Printer.SetPrinter(ListBoxPrinter.Items[ListBoxPrinter.ItemIndex]);
   // Ставим кол-во копий
   PrintDialog1.Copies := StrToInt(EditNumberOfCopy.Text);
   // Запуск диалога
  If PrintDialog1.Execute then
  begin
       n := StrToInt(EditNumberOfCopy.Text);
       for i:= 1 to n do
       begin
            s := 'RUNDLL32 PRINTUI.DLL,PrintUIEntry /n"'
            + ListBoxPrinter.Items[ListBoxPrinter.ItemIndex]
            + '" /k';
            SysUtils.ExecuteProcess(s, '', []);
       end;
  end;

end;

//=== Получения списка принтеров ===//
procedure TForm1.ListPrinter();
var
  i, i2: Integer;
  name_def_printer: String;
begin
  name_def_printer := Printer.Printers.Strings[Printer.PrinterIndex];
  // Список принтеров
  i :=  Printer.Printers.Count - 1;
  While i >= 0 Do
  begin
       ListBoxPrinter.Items.Add(Printer.Printers.Strings[i]);
       Dec(i);
  end;
  // Выбираем принтер по умолчанию
  i2 :=  Printer.Printers.Count - 1;
  While i2 > 0 Do
  begin
    if ListBoxPrinter.Items[i2] = name_def_printer then
      begin
        ListBoxPrinter.ItemIndex := i2;
      end;
    Dec(i2);
  end;
end;

// Старт формы
procedure TForm1.FormCreate(Sender: TObject);
begin
     ListPrinter;
end;


procedure TForm1.ImageColor1Click(Sender: TObject);
begin
  RadioButtonColor1.Checked:=True;
end;

procedure TForm1.ImageColor2Click(Sender: TObject);
begin
  RadioButtonColor2.Checked:=True;
end;

procedure TForm1.ImageColor3Click(Sender: TObject);
begin
  RadioButtonColor3.Checked:=True;
end;

procedure TForm1.ImageColor4Click(Sender: TObject);
begin
  RadioButtonColor4.Checked:=True;
end;

procedure TForm1.ImageMonochrome1Click(Sender: TObject);
begin
  RadioButtonMonochrome1.Checked:=True;
end;

procedure TForm1.ImageMonochrome2Click(Sender: TObject);
begin
  RadioButtonMonochrome2.Checked:=True;
end;

procedure TForm1.ImageMonochrome3Click(Sender: TObject);
begin
  RadioButtonMonochrome3.Checked:=True;
end;

procedure TForm1.ImageMonochrome4Click(Sender: TObject);
begin
   RadioButtonMonochrome4.Checked:=True;
end;

// Бегунок
procedure TForm1.TrackBar1Change(Sender: TObject);
begin
  EditNumberOfCopy.Text:= IntToStr(TrackBar1.Position);
end;


// Печать изображения и подгона его под лист А4
procedure TForm1.PrintImage(Image: TImage);
var
  TempImageBMP: Graphics.TBitmap;
  TempImageJPEG: TImage;
  ScaleX, ScaleY: Double;
  RectLeft,RectTop,RectRight,RectBottom: Integer;
begin
//ShowMessage(IntToStr(ListBoxPrinter.ItemIndex));
TempImageBMP := Graphics.TBitmap.Create;
TempImageBMP.Assign(Image.Picture.Graphic);
TempImageJPEG := TImage.Create(Self);
TempImageJPEG.Picture.Bitmap := TempImageBMP;

// Выбираем принтер
//Printer.SetPrinter(ListBoxPrinter.Items[ListBoxPrinter.ItemIndex]);
//ShowMessage(printer.printers[printer.printerindex]);

//Printer.BeginDoc;
// Соостношение сторон
ScaleX := Printer.PageWidth / TempImageJPEG.Picture.Bitmap.Width;
ScaleY := Printer.PageHeight / TempImageJPEG.Picture.Bitmap.Height;

RectLeft:=0;
RectTop:=0;
RectRight := trunc(TempImageJPEG.Picture.Bitmap.Width * scaleX);
RectBottom := trunc(TempImageJPEG.Picture.Bitmap.Height * scaleY);
Printer.Canvas.StretchDraw(
        Rect(RectLeft,RectTop,RectRight,RectBottom),
        TempImageJPEG.Picture.Bitmap);
//Printer.EndDoc;

TempImageBMP.Free;
TempImageJPEG.Free;
end;


//Печать картинки с диалогом
procedure TForm1.PrintFromImageWithDialog(Image: TImage);
begin
     // Выбираем принтер
     Printer.SetPrinter(ListBoxPrinter.Items[ListBoxPrinter.ItemIndex]);
     // Ставим кол-во копий
     PrintDialog1.Copies := StrToInt(EditNumberOfCopy.Text);
     // Запуск диалога
     if PrintDialog1.Execute then
     Begin
     // Печать картринки
     Printer.BeginDoc;
     PrintImage(Image);
     Printer.EndDoc;
     end;

end;


// Печать картинки без диалога
procedure TForm1.PrintFromImageWithoutDialog(Image: TImage);
begin
     // Выбираем принтер
     Printer.SetPrinter(ListBoxPrinter.Items[ListBoxPrinter.ItemIndex]);
     // Ставим кол-во копий
     Printer.Copies := StrToInt(EditNumberOfCopy.Text);
     Printer.BeginDoc;
     PrintImage(Image);
     Printer.EndDoc;
end;

 // КНОПКА запуск теста без диалога
procedure TForm1.ButtonStarTestWithoutDialogClick(Sender: TObject);
begin
if RadioButtonStandartTestPage.Checked = True then PrintStandartTestPageWhitoutDialog;
if RadioButtonMonochrome1.Checked = True then PrintFromImageWithoutDialog(ImageMonochrome1);
if RadioButtonMonochrome2.Checked = True then PrintFromImageWithoutDialog(ImageMonochrome2);
if RadioButtonMonochrome3.Checked = True then PrintFromImageWithoutDialog(ImageMonochrome3);
if RadioButtonMonochrome4.Checked = True then PrintFromImageWithoutDialog(ImageMonochrome4);
if RadioButtonColor1.Checked = True then PrintFromImageWithoutDialog(ImageColor1);
if RadioButtonColor2.Checked = True then PrintFromImageWithoutDialog(ImageColor2);
if RadioButtonColor3.Checked = True then PrintFromImageWithoutDialog(ImageColor3);
if RadioButtonColor4.Checked = True then PrintFromImageWithoutDialog(ImageColor4);
end;

// КНОПКА запуск теста с диалогом
procedure TForm1.ButtonStarTestWithDialogClick(Sender: TObject);
begin
if RadioButtonStandartTestPage.Checked = True then PrintStandartTestPageWhitDialog;
if RadioButtonMonochrome1.Checked = True then PrintFromImageWithDialog(ImageMonochrome1);
if RadioButtonMonochrome2.Checked = True then PrintFromImageWithDialog(ImageMonochrome2);
if RadioButtonMonochrome3.Checked = True then PrintFromImageWithDialog(ImageMonochrome3);
if RadioButtonMonochrome4.Checked = True then PrintFromImageWithDialog(ImageMonochrome4);
if RadioButtonColor1.Checked = True then PrintFromImageWithDialog(ImageColor1);
if RadioButtonColor2.Checked = True then PrintFromImageWithDialog(ImageColor2);
if RadioButtonColor3.Checked = True then PrintFromImageWithDialog(ImageColor3);
if RadioButtonColor4.Checked = True then PrintFromImageWithDialog(ImageColor4);
end;

end.

