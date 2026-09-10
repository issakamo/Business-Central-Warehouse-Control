namespace WarehouseControl.Warehouse;

page 50100 "WHX Inventory Exception List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "WHX Inventory Exception";
    Caption = 'Inventory Exceptions';
    CardPageID = "WHX Inventory Exception Card";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Tooltip = 'Specifies the entry number of the inventory exception.';
                    Caption = 'Entry No.';
                }
                field("Item No."; Rec."Item No.")
                {
                    Tooltip = 'Specifies the item number of the inventory exception.';
                    Caption = 'Item No.';
                    StyleExpr = this.PriorityStyle;
                }
                field(Description; Rec.Description)
                {
                    Tooltip = 'Specifies the description of the inventory exception.';
                    Caption = 'Description';
                }
                field("Location Code"; Rec."Location Code")
                {
                    Tooltip = 'Specifies the location code of the inventory exception.';
                    Caption = 'Location Code';
                }
                field("Bin Code"; Rec."Bin Code")
                {
                    Tooltip = 'Specifies the bin code of the inventory exception.';
                    Caption = 'Bin Code';
                }
                field("Exception Type"; Rec."Exception Type")
                {
                    Tooltip = 'Specifies the type of the inventory exception.';
                    Caption = 'Exception Type';
                }
                field(Difference; Rec.Difference)
                {
                    Tooltip = 'Specifies the difference of the inventory exception.';
                    Caption = 'Difference';
                    StyleExpr = this.PriorityStyle;
                }
                field(Priority; Rec.Priority)
                {
                    Tooltip = 'Specifies the priority of the inventory exception.';
                    Caption = 'Priority';
                    StyleExpr = this.PriorityStyle;
                }
                field(Status; Rec.Status)
                {
                    Tooltip = 'Specifies the status of the inventory exception.';
                    Caption = 'Status';
                }
                field("Created Date"; Rec."Created Date")
                {
                    Tooltip = 'Specifies the date when the inventory exception was created.';
                    Caption = 'Created Date';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Resolve)
            {
                ApplicationArea = All;
                Caption = 'Resolve';
                ToolTip = 'Resolves the selected inventory exception.';
                Image = Approve;

                trigger OnAction()
                var
                    ExceptionMgt: Codeunit "WHX Exception Management";
                begin
                    ExceptionMgt.ResolveException(Rec);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        this.SetPriorityStyle();
    end;

    local procedure SetPriorityStyle()
    begin
        case Rec.Priority of
            Rec.Priority::Critical:
                this.PriorityStyle := 'Unfavorable';
            Rec.Priority::High:
                this.PriorityStyle := 'Ambiguous';
            else
                this.PriorityStyle := 'Ambiguous';
        end;
    end;

    var
        PriorityStyle: Text;
}