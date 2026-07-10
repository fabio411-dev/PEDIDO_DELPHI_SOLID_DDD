unit Domain.Interfaces.ICidadeRepository;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Domain.ValueObjects.Cidade;

type
  ICidadeRepository = interface
    ['{A6E5C8B0-0D7F-45C3-B4D4-D90DBE2AF1C9}']
    function FindById(AIdCidade: Integer): TCidade;
    function GetAll: TObjectList<TCidade>;
  end;

implementation

end.

