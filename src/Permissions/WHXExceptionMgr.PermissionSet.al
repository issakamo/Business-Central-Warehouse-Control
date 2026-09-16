namespace WarehouseControl.Warehouse;

permissionset 50101 "WHX Exception Mgr"
{
    Caption = 'Warehouse Exception Manager';
    Assignable = true;
    IncludedPermissionSets = "WHX Exception User";

    Permissions =
        tabledata "WHX Inventory Exception" = D,
        report "WHX Inventory Exception Report" = X,
        report "WHX Exception Summary Report" = X;
}