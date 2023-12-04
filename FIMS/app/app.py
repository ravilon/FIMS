import os
from flask import Flask, render_template, redirect, request

from .sdc import *
from . import db



sdclist = [
    SDC(table='location', displayname='Location', displaynameplural='Locations', columns=[
        Column('locationid',   'ID',          None, is_pk=True),
        Column('locationdesc', 'Description', None)
    ]),
    SDC(table='departament', displayname='Departament', displaynameplural='Departaments', columns=[
        Column('departamentid', 'ID',       None, is_pk=True),
        Column('location',      'Location', None, reference=Reference('location', 'locationid'), nullable=True),
    ]),
    SDC(table='workarea', displayname='Work Area', displaynameplural='Work Areas', columns=[
        Column('workareaid',   'ID',          None, is_pk=True),
        Column('workareadesc', 'Description', None),
        Column('departament',  'Departament',           None, reference=Reference('departament', 'departamentid')),
    ]),
    SDC(table='management', displayname='Management', displaynameplural='Management', columns=[
        Column('managementid',   'ID',          None, is_pk=True),
        Column('managementdesc', 'Description', None),
        Column('departament',    'Departament',            None, reference=Reference('departament', 'departamentid')),
    ]),
    SDC(table='instruments', displayname='Instrument', displaynameplural='Instruments', columns=[
        Column('instrumentid',   'ID',          None, is_pk=True),
        Column('instrumentdesc', 'Description', None),
        Column('instrumenttype', 'Type',        None, nullable=True),
        Column('workarea',       'Work Area',   None, nullable=True, reference=Reference('workarea', 'workareaid')),
    ]),
    SDC(table='machines', displayname='Machine', displaynameplural='Machines', columns=[
        Column('machineid',   'ID',          None, is_pk=True),
        Column('machinetype', 'Type',        None, nullable=True),
        Column('machinedesc', 'Description', None),
        Column('workarea',    'Work Area',   None, nullable=True, reference=Reference('workarea', 'workareaid')),
    ]),
    SDC(table='employee', displayname='Employee', displaynameplural='Employees', columns=[
        Column('employeeid', 'ID',         None, is_pk=True),
        Column('job',        'Job',        None, nullable=True),
        Column('wage',       'Wage',       None, nullable=True),
        Column('management', 'Management', None, nullable=True, reference=Reference('management', 'managementid')),
    ]),
    SDC(table='productlevel', displayname='Product Level', displaynameplural='Product Levels', columns=[
        Column('productlevelid',   'ID',          None, is_pk=True),
        Column('productleveldesc', 'Description', None),
        Column('workarea',         'Work Area',   None, reference=Reference('workarea', 'workareaid')),
    ]),
    SDC(table='product', displayname='Product', displaynameplural='Product', columns=[
        Column('productid',      'ID',               None, is_pk=True),
        Column('producttype',    'Type',             None, nullable=True),
        Column('productdesc',    'Description',      None),
        Column('createdby',      'Created By',       None, nullable=True, reference=Reference('employee', 'employeeid')),
        Column('productlevelid', 'Product Level ID', None, reference=Reference('productlevel', 'productlevelid')),
    ]),
    SDC(table='paramlist', displayname='Parameter List', displaynameplural='Parameters Lists', columns=[
        Column('paramlistid',   'ID',            None, is_pk=True),
        Column('paramlistdesc', 'Description',   None),
        Column('paramlisttype', 'Type',          None, nullable=True),
        Column('instrumentid',  'Instrument ID', None, nullable=True, reference=Reference('instruments', 'instrumentid')),
        Column('machineid',     'Machine ID',    None, nullable=True, reference=Reference('machines', 'machineid')),
    ]),
    SDC(table='paramitem', displayname='Parameter', displaynameplural='Parameters', columns=[
        Column('paramid',   'ID',          None, is_pk=True),
        Column('paramdesc', 'Description', None),
        Column('paramtype', 'Type',        None, nullable=True),
        Column('paramlist', 'ParamList',   None, reference=Reference('paramlist', 'paramlistid')),
    ]),
    SDC(table='dataset', displayname='Data Set', displaynameplural='Data Sets', columns=[
        Column('datasetid',         'ID',             None, is_pk=True, serial=True),
        Column('datasetcreatedate', 'Create Date',    None, nullable=True),
        Column('datasetstatus',     'Status',         None, nullable=True),
        Column('datasettype',       'Type',           None, nullable=True),
        Column('datasetdesc',       'Description',    None),
        Column('paramlist',         'Parameter List', None, reference=Reference('paramlist', 'paramlistid')),
        Column('product',           'Product',        None, reference=Reference('product', 'productid'))
    ], has_data_entry=True),
    SDC(table='dataitem', displayname='Data Item', displaynameplural='Data Item', columns=[
        Column('dataitemid',     'ID',           None, is_pk=True),
        Column('dataparamid',    'Parameter ID', None, reference=Reference('paramitem', 'paramid')),
        Column('dataitemvalue',  'Status',       None, nullable=True),
        Column('dataitemstatus', 'Type',         None, nullable=True),
        Column('dataset',        'Dataset',      None, reference=Reference('dataset', 'datasetid')),
    ], has_list_page=False, has_maint_page=False),
]
sdcs = {sdc.table: sdc for sdc in sdclist}

try:
    result = db.run('SELECT 1')
    print('Database connection successful.')
    # Use the 'result' variable if needed
except Exception as e:
    print(f'Error: {e}')


app = Flask(__name__)

@app.route('/sdcs')
def hello(): return sdcs

@app.route('/')
def index(): return render_template('index.html', sdclist=sdclist)

@app.route('/list/<sdcid>')
def list(sdcid):
    sdc = sdcs[sdcid.lower()]
    columns = filter(lambda c: c.listable, sdc.columns)
    sdis = db.run(f'SELECT {", ".join([f"{sdc.table}.{c.name}" for c in columns])} FROM {sdc.table}')
    print(sdis)

    return render_template('list.html', sdclist=sdclist, sdc=sdc, sdis=sdis)

@app.route('/debug/list/<sdcid>')
def list_debug(sdcid):
    sdc = sdcs[sdcid.lower()]
    return [f'SELECT {",".join([c.name for c in sdc.columns])} FROM {sdc.table}', db.run(f'SELECT {",".join([c.name for c in sdc.columns])} FROM {sdc.table}')]

@app.route('/new/<sdcid>', methods=['GET', 'POST'])
def new_maint(sdcid):
    sdc = sdcs[sdcid.lower()]

    if request.method == 'POST':
        pk   = [e for e in filter(lambda c: c.is_pk, sdc.columns)][0]
        vals = {k: sdc.escape(k, v) for k, v in dict(request.form).items() if k != pk.name or (k == pk.name and not pk.serial)}
        sdi_pk = db.run(f'INSERT INTO {sdc.table} ({", ".join(vals.keys())}) VALUES ({", ".join(vals.values())}) RETURNING {pk.name}')[0]

        return redirect(f'/maint/{sdcid}/{sdi_pk[pk.name]}')

    else:
        return maint(sdcid, sdi=None, new=True)

@app.route('/maint/<sdcid>/<sdi>', methods=['GET', 'POST'])
def maint(sdcid, sdi, new=False):
    sdc = sdcs[sdcid.lower()]

    if request.method == 'POST':
        pk_column_names = [e.name for e in filter(lambda c: c.is_pk, sdc.columns)]
        where   = {f'{k} = {sdc.escape(k, v)}' for k, v in dict(request.form).items() if k     in pk_column_names}
        newvals = {f'{k} = {sdc.escape(k, v)}' for k, v in dict(request.form).items() if k not in pk_column_names}
        db.run(f'UPDATE {sdc.table} SET {", ".join(newvals)} WHERE {", ".join(where)}', fetch=False)

    if not new:
        pks = sdi.split(';')
        pk_columns = [e for e in filter(lambda c: c.is_pk, sdc.columns)]
        assert len(pks) == len(pk_columns)

        wheres = [f'{sdc.table}.{col.name} = {col.escape(val)}' for col, val in zip(pk_columns, pks)]
        sdi = db.run(f'SELECT * FROM {sdc.table} WHERE ' + ' AND '.join(wheres))[0]
    else:
        sdi = None

    ref_cols = [c for c in sdc.columns if c.reference != None]
    ref_options = {c.name: [v[c.reference.column] for v in db.run(f'SELECT DISTINCT {c.reference.table}.{c.reference.column} FROM {c.reference.table}')] for c in ref_cols}

    return render_template('maint.html', new=new, sdclist=sdclist, sdc=sdc, sdi=sdi, ref_options=ref_options)

@app.route('/dataentry/<dataset>', methods=['GET', 'POST'])
def dataentry(dataset):
    sdc = sdcs['dataset']

    if request.method == 'POST':
        sdc2 = sdcs['dataitem']

        if any( map( lambda v: v not in ['', None], dict(request.form).values() ) ):
            values = [
                (sdc2.escape('dataitemid', id), sdc2.escape('dataitemstatus', 'Released'), sdc2.escape('dataitemvalue', val))
                for id, val in dict(request.form).items()
                if val not in ['', None]
            ]
            ids      = [id for (id, _, _) in values]
            statuses = [f'WHEN {id} THEN {status}' for (id, status, _) in values]
            values   = [f'WHEN {id} THEN {value}'  for (id, _, value) in values]
            db.run(f'''
                UPDATE dataitem SET
                    dataitemstatus = CASE dataitemid {" ".join(statuses)} END,
                    dataitemvalue  = CASE dataitemid {" ".join(values)}   END
                WHERE dataitemid in ({", ".join(ids)})
            ''', fetch=False)

    pks = dataset.split(';')
    pk_columns = [e for e in filter(lambda c: c.is_pk, sdc.columns)]
    assert len(pks) == len(pk_columns)

    wheres = [f'{sdc.table}.{col.name} = {col.escape(val)}' for col, val in zip(pk_columns, pks)]
    sdi = db.run(f'SELECT * FROM {sdc.table} WHERE ' + ' AND '.join(wheres))[0]

    dataitems = db.run(f'''
        SELECT di.*, paramdesc
        FROM dataitem di
            JOIN dataset ds  ON di.dataset = ds.datasetid
            JOIN paramitem p ON di.dataparamid = p.paramid
    ''')

    return render_template('dataentry.html', sdclist=sdclist, sdc=sdc, sdi=sdi, dataitems=dataitems)

@app.route('/debug/reinit')
def reinit():
    with open('app/sql/create_FIMS_tables.sql') as f: schema_sql      = f.read()
    with open('app/sql/create_Master_Data.sql') as f: master_data_sql = f.read()
    with open('app/sql/dataset_trigger.sql')    as f: dataset_trigger = f.read()
    db.run( schema_sql + master_data_sql + dataset_trigger, fetch = False)
    return (schema_sql + master_data_sql + dataset_trigger).replace('\n', '<br>')

@app.route('/debug/pwd')
def pwd(): return os.environ['PWD']

if __name__ == "__main__": app.run(debug=True)