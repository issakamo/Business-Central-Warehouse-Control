namespace WarehouseControl.Warehouse.Test;

using System.TestLibraries.Utilities;
using WarehouseControl.Warehouse;

codeunit 50121 "WHX Exception Reporting Test"
{
    Subtype = Test;

    [Test]
    procedure BuildPriorityBuffer_AggregatesCorrectly()
    var
        TempBuffer: Record "WHX Priority Count Buffer" temporary;
        ExceptionMgt: Codeunit "WHX Exception Management";
        ReportingMgt: Codeunit "WHX Exception Reporting Mgt";
    begin
        // [GIVEN] Two Medium and one Critical open exception
        ExceptionMgt.CreateStockException('1000', 'BLUE', 'B-01', 100, 94);   // Medium
        ExceptionMgt.CreateStockException('1000', 'BLUE', 'B-02', 60, 55);    // Medium
        ExceptionMgt.CreateStockException('1000', 'BLUE', 'B-03', 50, 20);    // Critical

        // [WHEN]
        ReportingMgt.BuildPriorityBuffer(TempBuffer);

        // [THEN]
        TempBuffer.Get(TempBuffer.Priority::Medium);
        Assert.AreEqual(2, TempBuffer."Count", 'Expected 2 Medium exceptions');
        TempBuffer.Get(TempBuffer.Priority::Critical);
        Assert.AreEqual(1, TempBuffer."Count", 'Expected 1 Critical exception');
    end;

    [Test]
    procedure BuildPriorityBuffer_ExcludesResolved()
    var
        InventoryException: Record "WHX Inventory Exception";
        TempBuffer: Record "WHX Priority Count Buffer" temporary;
        ExceptionMgt: Codeunit "WHX Exception Management";
        ReportingMgt: Codeunit "WHX Exception Reporting Mgt";
        EntryNo: Integer;
    begin
        // [GIVEN] One Medium exception, resolved
        EntryNo := ExceptionMgt.CreateStockException('1000', 'BLUE', 'B-01', 100, 94);
        InventoryException.Get(EntryNo);
        InventoryException."Resolution Notes" := 'Handled.';
        InventoryException.Modify();
        ExceptionMgt.ResolveException(InventoryException);

        // [WHEN]
        ReportingMgt.BuildPriorityBuffer(TempBuffer);

        // [THEN] No Medium row exists at all — resolved records aren't counted
        Assert.IsFalse(TempBuffer.Get(TempBuffer.Priority::Medium), 'Resolved exceptions should not appear in the buffer');
    end;

    [Test]
    procedure BuildItemBuffer_SortsDescendingByCount()
    var
        TempBuffer: Record "WHX Item Count Buffer" temporary;
        ExceptionMgt: Codeunit "WHX Exception Management";
        ReportingMgt: Codeunit "WHX Exception Reporting Mgt";
    begin
        // [GIVEN] Item 1000 has 3 open exceptions, item 1001 has 1
        ExceptionMgt.CreateStockException('1000', 'BLUE', 'B-01', 100, 94);
        ExceptionMgt.CreateStockException('1000', 'BLUE', 'B-02', 60, 55);
        ExceptionMgt.CreateStockException('1000', 'BLUE', 'B-03', 50, 20);
        ExceptionMgt.CreateStockException('1001', 'BLUE', 'B-04', 30, 29);

        // [WHEN]
        ReportingMgt.BuildItemBuffer(TempBuffer);

        // [THEN] First record after FindSet is the highest count (1000, with 3)
        TempBuffer.FindFirst();
        Assert.AreEqual('1000', TempBuffer."Item No.", 'Highest-count item should sort first');
        Assert.AreEqual(3, TempBuffer."Count", 'Item 1000 should have count 3');
    end;

    var
        Assert: Codeunit "Library Assert";
}