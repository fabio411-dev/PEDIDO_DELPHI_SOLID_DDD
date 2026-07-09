unit Domain.ValueObjects.IDocumento;

interface

uses
  System.SysUtils;

type

  IDocumento = interface
    ['{3F8C0D6B-7AE5-4E9A-BF32-A1CC1F2DF5C3}']

    function Numero: string; overload;

    function ToString: string; overload;

    procedure Validate; overload;
  end;

implementation

end.

