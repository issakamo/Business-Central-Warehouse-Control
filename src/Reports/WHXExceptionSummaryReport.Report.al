namespace WarehouseControl.Warehouse;

report 50101 "WHX Exception Summary Report"
{
    Caption = 'Warehouse Exception Summary';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = Word;
    WordLayout = './src/Reports/Layouts/ExceptionSummaryReport.docx';

    dataset
    {
        dataitem(PriorityBuffer; "WHX Priority Count Buffer")
        {
            column(Priority_; Priority) { }
            column(PriorityCount; "Count") { }

            trigger OnPreDataItem()
            var
                WHXReportingMgt: Codeunit "WHX Exception Reporting Mgt.";
            begin
                WHXReportingMgt.BuildPriorityBuffer(PriorityBuffer);
            end;
        }
        dataitem(ItemBuffer; "WHX Item Count Buffer")
        {
            column(ItemNo_; "Item No.") { }
            column(ItemCount; "Count") { }

            trigger OnPreDataItem()
            var
                WHXReportingMgt: Codeunit "WHX Exception Reporting Mgt.";
            begin
                WHXReportingMgt.BuildItemBuffer(ItemBuffer);
            end;
        }
    }

}