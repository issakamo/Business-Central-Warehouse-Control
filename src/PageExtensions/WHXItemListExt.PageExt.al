namespace WarehouseControl.Warehouse;

using Microsoft.Inventory.Item;

pageextension 50102 "WHX Item List Ext" extends "Item List"
{
    layout
    {
        addafter("No.")
        {
            field("WHX Open Exception Count"; Rec."WHX Open Exception Count")
            {
                ApplicationArea = All;
                Caption = 'Open Exceptions';
                Tooltip = 'Specifies the number of open exceptions for this item.';
                StyleExpr = ExceptionStyleExpr;
                Editable = false;

                trigger OnDrillDown()
                var
                    InventoryException: Record "WHX Inventory Exception";
                    ExceptionList: Page "WHX Inventory Exception List";
                begin
                    InventoryException.SetRange("Item No.", Rec."No.");
                    InventoryException.SetRange(Status, InventoryException.Status::Open);
                    ExceptionList.SetTableView(InventoryException);
                    ExceptionList.Run();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetExceptionStyle();
    end;

    local procedure SetExceptionStyle()
    begin
        if Rec."WHX Open Exception Count" > 0 then
            ExceptionStyleExpr := 'Unfavorable'
        else
            ExceptionStyleExpr := 'Standard';
    end;

    var
        ExceptionStyleExpr: Text;
}