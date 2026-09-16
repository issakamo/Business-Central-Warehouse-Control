namespace WarehouseControl.Warehouse;

permissionset 50100 "WHX Exception User"
{
    Caption = 'Warehouse Exception User';
    Assignable = true;

    Permissions =
        tabledata "WHX Inventory Exception" = RIM,
        tabledata "WHX Exception Cue" = RIM,
        table "WHX Inventory Exception" = X,
        table "WHX Exception Cue" = X,
        page "WHX Inventory Exception List" = X,
        page "WHX Inventory Exception Card" = X,
        page "WHX Exception Cue" = X;
}