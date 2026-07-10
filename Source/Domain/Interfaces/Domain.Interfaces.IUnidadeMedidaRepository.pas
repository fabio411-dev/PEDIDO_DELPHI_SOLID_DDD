unit Domain.Interfaces.IUnidadeMedidaRepository;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Domain.ValueObjects.UnidadeMedida;

type
  IUnidadeMedidaRepository = interface
    ['{5E9B4A1F-3D7C-4EB2-BB8D-C8D6A8DF5C1A}']

    function GetAll: TObjectList<TUnidadeMedida>;
  end;

implementation

end.

