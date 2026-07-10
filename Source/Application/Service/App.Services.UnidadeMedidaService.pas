unit App.Services.UnidadeMedidaService;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Domain.Interfaces.IUnidadeMedidaRepository,
  Domain.ValueObjects.UnidadeMedida;

type
  TUnidadeMedidaService = class
  private
    FRepo: IUnidadeMedidaRepository;
  public
    constructor Create(ARepo: IUnidadeMedidaRepository);

    function GetAllForCombo: TList<TPair<Integer, string>>;
  end;

implementation

constructor TUnidadeMedidaService.Create(ARepo: IUnidadeMedidaRepository);
begin
  inherited Create;
  FRepo := ARepo;
end;

function TUnidadeMedidaService.GetAllForCombo;
var
  Unids: TObjectList<TUnidadeMedida>;
  i: Integer;
begin
  Result := TList<TPair<Integer, string>>.Create;
  Unids  := FRepo.GetAll;
  try
    for i := 0 to Unids.Count - 1 do
      Result.Add(TPair<Integer, string>.Create(
        Unids[i].IdUnidadeMedida,
        Unids[i].Descricao));
  finally
    Unids.Free;
  end;
end;

end.

