namespace WarehouseControl.Warehouse;

report 50100 "WHX Inventory Exception Report"
{
    Caption = 'Inventory Exception Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = Word;
    WordLayout = './src/Reports/Layouts/InventoryExceptionReport.docx';

    dataset
    {
        dataitem(InventoryException; "WHX Inventory Exception")
        {
            RequestFilterFields = "Item No.", Status, Priority, "Location Code";
            column(EntryNo; "Entry No.") { }
            column(ItemNo; "Item No.") { }
            column(Description_; Description) { }
            column(LocationCode; "Location Code") { }
            column(BinCode; "Bin Code") { }
            column(ExceptionType; "Exception Type") { }
            column(ExpectedQty; "Expected Quantity") { }
            column(ActualQty; "Actual Quantity") { }
            column(Difference_; Difference) { }
            column(Priority_; Priority) { }
            column(Status_; Status) { }
            column(CreatedDate; "Created Date") { }
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(IncludeResolved; IncludeResolvedFlag)
                    {
                        ApplicationArea = All;
                        Caption = 'Include Resolved Exceptions';
                        Tooltip = 'Select this option to include resolved exceptions in the report.';
                    }
                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if not IncludeResolvedFlag then
            InventoryException.SetFilter(Status, '<>%1', InventoryException.Status::Resolved);
    end;

    var
        IncludeResolvedFlag: Boolean;
}
