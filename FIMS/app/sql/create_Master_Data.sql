-- Populando Locations

Insert into Location (locationid, locationdesc)
values ('L01', 'Fazenda Roberval Pinto');
Insert into Location (locationid, locationdesc)
values ('L02', 'Fazenda São José');
Insert into Location (locationid, locationdesc)
values ('L03', 'Fazenda São João');

-- Populando Departaments

Insert into Departament (departamentid, location)
values ('D01', 'L01');
Insert into Departament (departamentid, location)
values ('D02', 'L02');
Insert into Departament (departamentid, location)
values ('D03', 'L03');

-- Populando Work Areas

