namespace WarehouseControl.Warehouse;

table 50103 "WHX Item Count Buffer"
{
    TableType = Temporary;
    fields
    {
        field(1; "Item No."; Code[20])
        {
            DataClassification = SystemMetadata;
        }
        field(2; "Count"; Integer)
        {
            DataClassification = SystemMetadata;
        }
    }

    keys { key(PK; "Item No.") { Clustered = true; } }

}