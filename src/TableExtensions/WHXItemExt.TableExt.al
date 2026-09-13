namespace WarehouseControl.Warehouse;

using Microsoft.Inventory.Item;

tableextension 50100 "WHX Item Ext" extends Item
{
    fields
    {
        field(50100; "WHX Open Exception Count"; Integer)
        {
            Caption = 'WHX Open Exception Count';
            FieldClass = FlowField;
            CalcFormula = Count("WHX Inventory Exception" WHERE("Item No." = FIELD("No."), "Status" = CONST(Open)));
        }
    }
}