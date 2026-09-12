namespace WarehouseControl.Warehouse;

table 50101 "WHX Exception Cue"
{
    Caption = 'WHX Exception Cue';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            DataClassification = SystemMetadata;
        }
        field(10; "Open Exceptions"; Integer)
        {
            Caption = 'Open Exceptions';
            FieldClass = FlowField;
            CalcFormula = Count("WHX Inventory Exception" WHERE("Status" = CONST(Open)));
            Editable = false;
        }
        field(11; "Critical Exceptions"; Integer)
        {
            Caption = 'Critical Exceptions';
            FieldClass = FlowField;
            CalcFormula = Count("WHX Inventory Exception" WHERE("Status" = CONST(Open), "Priority" = CONST(Critical)));
            Editable = false;
        }
        field(12; "High Priority Exceptions"; Integer)
        {
            Caption = 'High Priority Exceptions';
            FieldClass = FlowField;
            CalcFormula = Count("WHX Inventory Exception" WHERE("Status" = CONST(Open), "Priority" = CONST(High)));
            Editable = false;
        }
        field(13; "Receiving Discrepancies"; Integer)
        {
            Caption = 'Receiving Discrepancies';
            FieldClass = FlowField;
            CalcFormula = Count("WHX Inventory Exception" WHERE("Status" = CONST(Open), "Exception Type" = CONST("Receiving Discrepancy")));
            Editable = false;
        }
        field(14; "Stock Discrepancies"; Integer)
        {
            Caption = 'Stock Discrepancies';
            FieldClass = FlowField;
            CalcFormula = Count("WHX Inventory Exception" WHERE("Status" = CONST(Open), "Exception Type" = CONST("Stock Discrepancy")));
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
}