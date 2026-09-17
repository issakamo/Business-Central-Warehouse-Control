namespace WarehouseControl.Warehouse.Test;

using System.TestLibraries.Utilities;
using WarehouseControl.Warehouse;

codeunit 50121 "WHX Exception Reporting Test"
{
    Subtype = Test;

    [Test]
    procedure BuildPriorityBuffer_AggregatesCorrectly()
    var
        InventoryException: Record "WHX Inventory Exception";
        TempBuffer: Record "WHX Priority Count Buffer" temporary;
        ExceptionMgt: Codeunit "WHX Exception Management";
        ReportingMgt: Codeunit "WHX Exception Reporting Mgt";
    begin
        InventoryException.DeleteAll(false);
        // [GIVEN] Two Medium and one Critical open exception
        ExceptionMgt.CreateStockException('1896-S', 'WHITE', 'W-08-0001', 100, 94);   // Medium
        ExceptionMgt.CreateStockException('1896-S', 'WHITE', 'W-08-0002', 60, 55);    // Medium
        ExceptionMgt.CreateStockException('1896-S', 'WHITE', 'W-08-0003', 50, 20);    // Critical

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
        InventoryException.DeleteAll(false);
        // [GIVEN] One Medium exception, resolved
        EntryNo := ExceptionMgt.CreateStockException('1900-S', 'WHITE', 'W-08-0001', 100, 94);
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
        InventoryException: Record "WHX Inventory Exception";
        TempBuffer: Record "WHX Item Count Buffer" temporary;
        ExceptionMgt: Codeunit "WHX Exception Management";
        ReportingMgt: Codeunit "WHX Exception Reporting Mgt";
    begin
        InventoryException.DeleteAll(false);
        // [GIVEN] Item 1908-S has 3 open exceptions, item 1920-S has 1
        ExceptionMgt.CreateStockException('1908-S', 'WHITE', 'W-08-0001', 100, 94);
        ExceptionMgt.CreateStockException('1908-S', 'WHITE', 'W-08-0002', 60, 55);
        ExceptionMgt.CreateStockException('1908-S', 'WHITE', 'W-08-0003', 50, 20);
        ExceptionMgt.CreateStockException('1920-S', 'WHITE', 'W-08-0003', 30, 29);

        // [WHEN]
        ReportingMgt.BuildItemBuffer(TempBuffer);

        // [THEN] First record after FindSet is the highest count (1908-S, with 3)
        TempBuffer.FindFirst();
        Assert.AreEqual('1908-S', TempBuffer."Item No.", 'Highest-count item should sort first');
        Assert.AreEqual(3, TempBuffer."Count", 'Item 1908-S should have count 3');
    end;

    var
        Assert: Codeunit "Library Assert";
}