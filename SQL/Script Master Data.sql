-- Populating Location table
INSERT INTO Location (LocationId, LocationDesc)
VALUES
    ('L1', 'North Field'),
    ('L2', 'South Field'),
    ('L3', 'East Field'),
    ('L4', 'West Field');

-- Populating Department table
INSERT INTO Departament (DepartamentId, Location)
VALUES
    ('D1', 'L1'),
    ('D2', 'L2'),
    ('D3', 'L3'),
    ('D4', 'L4');

-- Populating WorkArea table
INSERT INTO WorkArea (WorkAreaId, WorkAreaDesc, Departament)
VALUES
    ('W1', 'Corn Field', 'D1'),
    ('W2', 'Soybean Field', 'D2'),
    ('W3', 'Wheat Field', 'D3'),
    ('W4', 'Rice Field', 'D4');

-- Populating Management table
INSERT INTO Management (ManagementId, ManagementDesc, Departament)
VALUES
    ('M1', 'Farm Manager', 'D1'),
    ('M2', 'Assistant Farm Manager', 'D2'),
    ('M3', 'Farm Supervisor', 'D3'),
    ('M4', 'Assistant Farm Supervisor', 'D4');

-- Populating Instruments table
INSERT INTO Instruments (InstrumentId, InstrumentDesc, InstrumentType, WorkArea)
VALUES
    ('I1', 'Soil Moisture Sensor', 'Sensor', 'W1'),
    ('I2', 'Temperature Sensor', 'Sensor', 'W2'),
    ('I3', 'Air Quality Sensor', 'Sensor', 'W3'),
    ('I4', 'Rain Gauge', 'Sensor', 'W4');

-- Populating Machines table
INSERT INTO Machines (MachineID, MachineType, MachineDesc, WorkArea)
VALUES
    ('M1', 'Tractor', 'John Deere 8000 Series', 'W1'),
    ('M2', 'Combine Harvester', 'John Deere S790', 'W2'),
    ('M3', 'Seeder', 'John Deere 1590', 'W3'),
    ('M4', 'Irrigation System', 'John Deere 4045', 'W4');

-- Populating Employee table
INSERT INTO Employee (EmployeeId, Job, Wage, Management)
VALUES
    ('E1', 'Farm Manager', '5000', 'M1'),
    ('E2', 'Assistant Farm Manager', '4000', 'M2'),
    ('E3', 'Farm Supervisor', '3000', 'M3'),
    ('E4', 'Assistant Farm Supervisor', '2500', 'M4');

-- Populating ProductLevel table
INSERT INTO ProductLevel (ProductLevelId, ProductLevelDesc, WorkArea)
VALUES
    ('PL1', 'Grade A', 'W1'),
    ('PL2', 'Grade B', 'W2'),
    ('PL3', 'Grade C', 'W3'),
    ('PL4', 'Grade D', 'W4');

-- Populating Product table
INSERT INTO Product (ProductId, ProductType, ProductDesc, CreatedBy, ProductLevelId)
VALUES
    ('P1', 'Corn', 'Yellow Corn', 'E1', 'PL1'),
    ('P2', 'Soybean', 'Green Soybean', 'E2', 'PL2'),
    ('P3', 'Wheat', 'Red Wheat', 'E3', 'PL3'),
    ('P4', 'Rice', 'White Rice', 'E4', 'PL4');

-- Populating ParamItem table
INSERT INTO ParamItem (ParamId, ParamDesc, ParamType)
VALUES
('PI1', 'Soil Moisture Level', 'Sensor'),
('PI2', 'Air Temperature', 'Sensor'),
('PI3', 'Nitrogen Level', 'Sensor'),
('PI4', 'Fuel Level', 'Machine');

-- Populating ParamList table
INSERT INTO ParamList (ParamListId, ParamListDesc, ParamListType, InstrumentID, MachineID, ParamItem)
VALUES
('PL1', 'Corn Field Parameters', 'Field', 'I1', 'M1', 'PI1'),
('PL2', 'Soybean Field Parameters', 'Field', 'I2', 'M2', 'PI2'),
('PL3', 'Wheat Field Parameters', 'Field', 'I3', 'M3', 'PI3'),
('PL4', 'Rice Field Parameters', 'Field', 'I4', 'M4', 'PI4');

-- Populating DataSet table
INSERT INTO DataSet (DataSetId, DataSetCreateDate, DataSetStatus, DataSetType, DataSetDesc, ParamList, Product)
VALUES
(1, '2022-01-01', 'New', 'Field Data', 'Corn Field Data', 'PL1', 'P1'),
(2, '2022-01-02', 'New', 'Field Data', 'Soybean Field Data', 'PL2', 'P2'),
(3, '2022-01-03', 'New', 'Field Data', 'Wheat Field Data', 'PL3', 'P3'),
(4, '2022-01-04', 'New', 'Field Data', 'Rice Field Data', 'PL4', 'P4');

-- Populating DataItem table
INSERT INTO DataItem (DataItemId, DataParamId, DataItemValue, DataItemStatus, DataSet)
VALUES
('DI1', 'PI1', '25', 'Normal', 1),
('DI2', 'PI1', '27', 'Normal', 1),
('DI3', 'PI1', '30', 'Dry', 1),
('DI4', 'PI2', '20', 'Normal', 2),
('DI5', 'PI2', '22', 'Normal', 2),
('DI6', 'PI2', '24', 'High', 2),
('DI7', 'PI3', '10', 'Low', 3),
('DI8', 'PI3', '15', 'Normal', 3),
('DI9', 'PI3', '20', 'Normal', 3),
('DI10', 'PI4', '50', 'Normal', 4),
('DI11', 'PI4', '55', 'Normal', 4),
('DI12', 'PI4', '60', 'Low', 4);
