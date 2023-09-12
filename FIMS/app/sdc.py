from dataclasses import dataclass
from typing import List

@dataclass
class Reference:
    table: str
    column: str

@dataclass
class Column:
    name: str
    displayname: str
    type: str
    listable: bool       = True # Show or not on list page.
    is_pk: bool          = False
    reference: Reference = None # Some other table.
    nullable: bool       = False
    serial: bool         = False

    def escape(self, val: str): # Make input val SQL-comparable with this column.
        if self.type is not None: pass # TODO: implement me!
        elif val == '': return "null"
        else:           return f"'{val}'"

@dataclass
class SDC:
    table: str
    displayname: str
    displaynameplural: str
    columns: List[Column]

    has_list_page: bool = True
    has_maint_page: bool = True
    has_data_entry: bool = False

    def escape(self, column_name, val): return [c for c in self.columns if c.name == column_name][0].escape(val)

    def get_sdi_key(self, sdi):
        pks = list( filter(lambda c: c.is_pk, self.columns) )
        values = [ str(sdi[pk.name]) for pk in pks ]
        return ";".join(values)

    def get_sdi_reference_key(self, sdi, sdc: str):
        fks = list( filter(lambda c: c.reference is not None and c.reference.table == sdc, self.columns) )
        values = [ str(sdi[fk.name]) for fk in fks ]
        return ";".join(values)