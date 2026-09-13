namespace WarehouseControl.Warehouse;

using Microsoft.Inventory.Item;

pageextension 50101 "WHX Item Card Ext" extends "Item Card"
{
    layout
    {
        addAfter("Inventory")
        {
            field("WHX Open Exception Count"; Rec."WHX Open Exception Count")
            {
                ApplicationArea = All;
                Tooltip = 'Displays the number of open exceptions for this item.';
                Caption = 'WHX Open Exception Count';
                Editable = false;
                StyleExpr = ExceptionStyleExpr;

                trigger OnDrillDown()
                var
                    InventoryException: Record "WHX Inventory Exception";
                    ExceptionListPage: Page "WHX Inventory Exception List";
                begin
                    InventoryException.SetRange("Item No.", Rec."No.");
                    InventoryException.SetRange("Status", InventoryException.Status::Open);
                    ExceptionListPage.SetTableView(InventoryException);
                    ExceptionListPage.Run();
                end;
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            action("WHXViewExceptions")
            {
                ApplicationArea = All;
                Caption = 'View Exceptions';
                Tooltip = 'View all exceptions for this item.';
                Image = Warning;
                trigger OnAction()
                var
                    InventoryException: Record "WHX Inventory Exception";
                    ExceptionListPage: Page "WHX Inventory Exception List";
                begin
                    InventoryException.SetRange("Item No.", Rec."No.");
                    ExceptionListPage.SetTableView(InventoryException);
                    ExceptionListPage.Run();
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