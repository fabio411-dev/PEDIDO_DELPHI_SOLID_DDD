unit Domain.Interfaces.IPedidoRepository;

interface

uses
  System.SysUtils,
  Generics.Collections,
  Domain.Entities.Pedido;

type
  IPedidoRepository = interface
    ['{AC9B7EF2-3A84-4C5D-BE56-78F3FA6F8E2A}']

    function  FindById(AIdPedido: Integer): TPedido;
    function  FindAll: TObjectList<TPedido>;
    procedure Add(const APedido: TPedido);
    procedure Update(const APedido: TPedido);
    procedure Delete(AIdPedido: Integer);
  end;

implementation

end.

