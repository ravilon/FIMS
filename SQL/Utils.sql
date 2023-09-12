-- Query para retonar todos departamentos e respectivas localizações
SELECT d.DepartamentId, l.LocationDesc
FROM Departament d
LEFT JOIN Location l ON d.Location = l.LocationId;

-- Consulta para recuperar todas as máquinas e suas respectivas áreas de trabalho e departamentos:
SELECT m.MachineID, w.WorkAreaDesc, d.DepartamentId
FROM Machines m
INNER JOIN WorkArea w ON m.WorkArea = w.WorkAreaId
INNER JOIN Departament d ON w.Departament = d.DepartamentId;

-- Consulta para recuperar todos os funcionários e seus respectivos gerentes:
SELECT e.EmployeeId, m.ManagementDesc
FROM Employee e
LEFT JOIN Management m ON e.Management = m.ManagementId;

-- Consulta para recuperar todos os níveis de produto e suas respectivas áreas de trabalho:
SELECT pl.ProductLevelId, w.WorkAreaDesc
FROM ProductLevel pl
INNER JOIN WorkArea w ON pl.WorkArea = w.WorkAreaId;

-- Consulta para recuperar todos os itens de dados e seus respectivos conjuntos de dados, itens de parâmetro e valores de parâmetro:
SELECT di.DataItemId, ds.DataSetDesc, pi.ParamDesc, di.DataItemValue
FROM DataItem di
INNER JOIN DataSet ds ON di.DataSet = ds.DataSetId
INNER JOIN ParamItem pi ON di.DataParamId = pi.ParamId;

-- Consulta para recuperar todos os conjuntos de dados e seus respectivos tipos de produto e níveis de produto:
SELECT ds.DataSetId, p.ProductType, pl.ProductLevelDesc
FROM DataSet ds
INNER JOIN Product p ON ds.Product = p.ProductId
INNER JOIN ProductLevel pl ON p.ProductLevelId = pl.ProductLevelId;
