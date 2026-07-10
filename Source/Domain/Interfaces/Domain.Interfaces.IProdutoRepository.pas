unit Domain.Interfaces.IProdutoRepository;

interface

uses
  System.SysUtils,
  Generics.Collections,
  Domain.Entities.Produto;

type
  IProdutoRepository = interface
    ['{B4D8E8BC-4B61-42E1-91E5-FF45DE0CF29E}']

    function  FindById(AIdProduto: Integer): TProduto;
    function  FindAll(APartialDesc : String): TObjectList<TProduto>;
    procedure Add(const AProduto: TProduto);
    procedure Update(const AProduto: TProduto);
    procedure Delete(AIdProduto: Integer);
  end;

implementation

end.

