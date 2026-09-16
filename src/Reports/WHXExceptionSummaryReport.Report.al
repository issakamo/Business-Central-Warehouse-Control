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
            begin
                BuildPriorityBuffer(PriorityBuffer);
            end;
        }
        dataitem(ItemBuffer; "WHX Item Count Buffer")
        {
            column(ItemNo_; "Item No.") { }
            column(ItemCount; "Count") { }

            trigger OnPreDataItem()
            begin
                BuildItemBuffer(ItemBuffer);
            end;
        }
    }

    local procedure BuildPriorityBuffer(var Buffer: Record "WHX Priority Count Buffer" temporary)
    var
        InventoryException: Record "WHX Inventory Exception";
    begin
        InventoryException.SetRange(Status, InventoryException.Status::Open);
        if InventoryException.FindSet() then
            repeat
                if Buffer.Get(InventoryException.Priority) then begin
                    Buffer."Count" += 1;
                    Buffer.Modify();
                end else begin
                    Buffer.Init();
                    Buffer.Priority := InventoryException.Priority;
                    Buffer."Count" := 1;
                    Buffer.Insert();
                end;
            until InventoryException.Next() = 0;
    end;

    local procedure BuildItemBuffer(var Buffer: Record "WHX Item Count Buffer" temporary)
    var
        InventoryException: Record "WHX Inventory Exception";
    begin
        InventoryException.SetRange(Status, InventoryException.Status::Open);
        if InventoryException.FindSet() then
            repeat
                if Buffer.Get(InventoryException."Item No.") then begin
                    Buffer."Count" += 1;
                    Buffer.Modify();
                end else begin
                    Buffer.Init();
                    Buffer."Item No." := InventoryException."Item No.";
                    Buffer."Count" := 1;
                    Buffer.Insert();
                end;
            until InventoryException.Next() = 0;

        Buffer.SetCurrentKey("Count");
        Buffer.Ascending(false);
    end;
}