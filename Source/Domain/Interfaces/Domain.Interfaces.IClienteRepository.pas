unit Domain.Interfaces.IClienteRepository;

interface

uses
  System.SysUtils,
  Generics.Collections,
  Domain.Entities.Cliente;

type
  IClienteRepository = interface
    ['{E7B0A2F2-6EB9-43F8-93C5-BA3DAA6C5F27}']

    function  FindById(AIdCliente: Integer): TCliente;
    function  FindAll: TObjectList<TCliente>;
    procedure Add(const ACliente: TCliente);
    procedure Update(const ACliente: TCliente);
    procedure Delete(AIdCliente: Integer);
  end;

implementation

end.

