unit Unit2;

interface

uses  Classes, Vcl.ExtCtrls;

type
  TImage = class(Vcl.ExtCtrls.TImage)
    private
      NewProperty_ImageCheck: Boolean;
      NewProperty_NameAndExtension: String;
    public
      property ImageCheck : Boolean read NewProperty_ImageCheck write NewProperty_ImageCheck;
      property NameAndExtension : String read NewProperty_NameAndExtension write NewProperty_NameAndExtension;
  end;

implementation

end.
