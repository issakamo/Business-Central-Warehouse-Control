namespace WarehouseControl.Warehouse;

table 50102 "WHX Priority Count Buffer"
{
    TableType = Temporary;
    fields
    {
        field(1; Priority; Enum "WHX Exception Priority")
        {
            DataClassification = SystemMetadata;
        }
        field(2; "Count"; Integer)
        {
            DataClassification = SystemMetadata;
        }
    }
    keys { key(PK; Priority) { Clustered = true; } }
}
