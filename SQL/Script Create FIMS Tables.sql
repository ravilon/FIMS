--Populando o banco de dados 

-- Creting Schema FIMS

-- Creating Location Table

CREATE TABLE Location (
LocationId VARCHAR(30) NOT NULL,
LocationDesc VARCHAR(160) NOT NULL,

PRIMARY KEY (LocationId)
);

-- Creating Department Table

Create Table Departament (
DepartamentId VARCHAR (30) NOT NULL,
Location VARCHAR (30),
	
Primary Key (DepartamentId),
Foreign Key	(Location) References location(LocationId)
		on delete set NULL
		on update cascade
);

-- Creating Work Area Table

Create Table WorkArea (
WorkAreaId VARCHAR (30) NOT NULL,
WorkAreaDesc VARCHAR (160) NOT NULL,
Departament VARCHAR (30) NOT NULL,
Primary Key (WorkAreaId),
Foreign Key (Departament) References Departament (DepartamentId)
        on update cascade
        on delete cascade

);

-- Creating Management Table

Create Table Management (
ManagementId VARCHAR (30) NOT NULL,
ManagementDesc VARCHAR (160) NOT NULL,
Departament VARCHAR (30) NOT NULL,
Primary Key (ManagementId),
Foreign Key (Departament) References Departament (DepartamentId)
        on update cascade
        on delete cascade
);

-- Creating Instrument Table

Create Table Instruments (
InstrumentId VARCHAR (30) NOT NULL,
InstrumentDesc VARCHAR (160) NOT NULL,
InstrumentType VARCHAR (30),
WorkArea VARCHAR (30),

Primary Key (InstrumentId),
Foreign Key (WorkArea) References WorkArea (WorkAreaId)
	on update cascade
    on delete cascade
);
    


-- Creating Machine Table

Create Table Machines (
MachineID VARCHAR (30) NOT NULL,
MachineType VARCHAR (30) ,
MachineDesc VARCHAR (160) NOT NULL,
WorkArea VARCHAR (30),
	
Primary Key (MachineID),
Foreign Key (WorkArea) References WorkArea(WorkAreaId)
	on update cascade
    on delete cascade
    );
    

-- Creating Employee Table

Create Table Employee (
EmployeeId VARCHAR (30) NOT NULL,
Job VARCHAR (30),
Wage VARCHAR (30),
Management VARCHAR (30),
	
Primary Key (EmployeeId),
Foreign Key (Management) References Management(ManagementId)
	on update cascade
    on delete cascade
);
    

-- Creating ProductLevel Table

Create Table ProductLevel (
ProductLevelId VARCHAR(30) NOT NULL,
ProductLevelDesc VARCHAR(160) NOT NULL,
WorkArea VARCHAR(30) NOT NULL,
	
Primary Key (ProductLevelID),
Foreign Key (WorkArea) References WorkArea(WorkAreaID)
	on update cascade
    on delete cascade
    );

-- Creating Product Table

Create Table Product (
ProductId VARCHAR (30) NOT NULL,
ProductType VARCHAR (30),
ProductDesc VARCHAR (160) NOT NULL,
CreatedBy VARCHAR (30),
ProductLevelId VARCHAR (30) NOT NULL,

Primary Key (ProductId),
Foreign Key (CreatedBy) References Employee(EmployeeId)
    on update cascade,
Foreign Key (ProductLevelId) References ProductLevel(ProductLevelId)
    on update cascade
    on delete cascade
);

-- Creating ParamItem Table

Create Table ParamItem (
ParamId VARCHAR (30) NOT NULL,
ParamDesc VARCHAR (160) NOT NULL,
ParamType VARCHAR (30),

Primary Key (ParamId)
);

-- Creating ParamList Table

Create Table ParamList (
ParamListId VARCHAR (30) NOT NULL,
ParamListDesc VARCHAR (160) NOT NULL,
ParamListType VARCHAR (30),
InstrumentID VARCHAR (30),
MachineID VARCHAR (30),
ParamItem VARCHAR (30),

Primary Key (ParamListId),
Foreign Key (InstrumentID) References Instruments(InstrumentId)
    on update cascade,
Foreign Key (MachineID) References Machines(MachineId)
    on update cascade,
Foreign Key (ParamItem) References ParamItem(ParamId)
    on update cascade
);

-- Creating DataSet Table

Create Table DataSet (
DataSetId SERIAL,
DataSetCreateDate VARCHAR (30),
DataSetStatus VARCHAR (30),
DataSetType VARCHAR (30),
DataSetDesc VARCHAR (160) NOT NULL,
ParamList VARCHAR (30) NOT NULL,
Product VARCHAR (30) NOT NULL,

Primary Key (DataSetId),
Foreign Key (ParamList) References ParamList(ParamListId)
    on update cascade
    on delete cascade,
Foreign Key (Product) References Product(ProductId)
    on update cascade
    on delete cascade
);

-- Creating DataItem Table

Create Table DataItem (
DataItemId VARCHAR (30) NOT NULL,
DataParamId VARCHAR (30) NOT NULL,
DataItemValue VARCHAR (30),
DataItemStatus VARCHAR (30),
DataSet SERIAL,

Primary Key (DataItemId),
Foreign Key (DataSet) References DataSet(DataSetId)
    on update cascade
    on delete cascade,
Foreign key (DataParamId) References ParamItem(ParamId)
    on update cascade
    on delete cascade
);

--- Trigger (quando nao há dataitens vinculados com o value null o datasetstatus é atualizado para completed)

CREATE OR REPLACE FUNCTION update_dataset_status() RETURNS TRIGGER AS $$
BEGIN
  IF NOT EXISTS (
    SELECT *
    FROM DataItem
    WHERE DataSet = NEW.DataSetId
      AND DataItemValue IS NULL
  ) THEN
    UPDATE DataSet
    SET DataSetStatus = 'Completed'
    WHERE DataSetId = NEW.DataSetId;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER dataset_completed_trigger
AFTER UPDATE ON DataItem
FOR EACH ROW
EXECUTE FUNCTION update_dataset_status();
