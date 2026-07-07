object DMConexao: TDMConexao
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 261
  Width = 315
  object FDConexao: TFDConnection
    Left = 96
    Top = 24
  end
  object FDTrans: TFDTransaction
    Connection = FDConexao
    Left = 192
    Top = 24
  end
  object FDPhysIBDriverLink1: TFDPhysIBDriverLink
    Left = 56
    Top = 104
  end
end
