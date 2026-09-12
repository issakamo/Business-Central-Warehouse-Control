namespace WarehouseControl.Warehouse;

page 50102 "WHX Exception Cue"
{
    Caption = 'Inventory Exceptions';
    PageType = CardPart;
    SourceTable = "WHX Exception Cue";

    layout
    {
        area(Content)
        {
            cuegroup(Main)
            {
                Caption = 'Warehouse Exceptions';
                field("Open Exceptions"; Rec."Open Exceptions")
                {
                    Caption = 'Open Exceptions';
                    ToolTip = 'Specifies the number of open inventory exceptions.';
                    ApplicationArea = All;
                    DrillDownPageId = "WHX Inventory Exception List";
                }
                field("Critical Exceptions"; Rec."Critical Exceptions")
                {
                    Caption = 'Critical Exceptions';
                    ToolTip = 'Specifies the number of critical inventory exceptions.';
                    ApplicationArea = All;
                    DrillDownPageId = "WHX Inventory Exception List";
                    StyleExpr = 'Unfavorable';
                }
                field("High Priority Exceptions"; Rec."High Priority Exceptions")
                {
                    Caption = 'High Priority Exceptions';
                    ToolTip = 'Specifies the number of high priority inventory exceptions.';
                    ApplicationArea = All;
                    DrillDownPageId = "WHX Inventory Exception List";
                    StyleExpr = 'Ambiguous';
                }
                field("Receiving Discrepancies"; Rec."Receiving Discrepancies")
                {
                    Caption = 'Receiving Discrepancies';
                    ToolTip = 'Specifies the number of receiving discrepancies.';
                    ApplicationArea = All;
                    DrillDownPageId = "WHX Inventory Exception List";
                }
                field("Stock Discrepancies"; Rec."Stock Discrepancies")
                {
                    Caption = 'Stock Discrepancies';
                    ToolTip = 'Specifies the number of stock discrepancies.';
                    ApplicationArea = All;
                    DrillDownPageId = "WHX Inventory Exception List";
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}