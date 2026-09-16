namespace WarehouseControl.Warehouse.Test;

using System.TestLibraries.Utilities;
using WarehouseControl.Warehouse;

codeunit 50120 "WHX Exception Mgt Test"
{
    Subtype = Test;

    [Test]
    procedure CreateStockException_MismatchCreatesRecord()
    var
        InventoryException: Record "WHX Inventory Exception";
        ExceptionMgt: Codeunit "WHX Exception Management";
        EntryNo: Integer;
    begin
        // [GIVEN] Expected and actual quantities differ
        // [WHEN] CreateStockException is called
        EntryNo := ExceptionMgt.CreateStockException('1000', 'BLUE', 'B-01', 100, 94);

        // [THEN] A record is created with the correct difference and priority
        InventoryException.Get(EntryNo);
        Assert.AreEqual(-6, InventoryException.Difference, 'Difference should be Actual - Expected');
        Assert.AreEqual(InventoryException.Priority::Medium, InventoryException.Priority, 'Wrong priority tier');
    end;

    [Test]
    procedure CreateStockException_NoMismatchCreatesNothing()
    var
        ExceptionMgt: Codeunit "WHX Exception Management";
        EntryNo: Integer;
    begin
        // [GIVEN] Expected equals actual
        // [WHEN] CreateStockException is called
        EntryNo := ExceptionMgt.CreateStockException('1000', 'BLUE', 'B-01', 100, 100);

        // [THEN] No record is created — returns 0
        Assert.AreEqual(0, EntryNo, 'No exception should be created when quantities match');
    end;

    [Test]
    procedure ZeroExpected_YieldsHighPriority()
    var
        InventoryException: Record "WHX Inventory Exception";
        ExceptionMgt: Codeunit "WHX Exception Management";
        EntryNo: Integer;
    begin
        // [GIVEN] Expected quantity is zero (division-by-zero edge case)
        // [WHEN] CreateStockException is called
        EntryNo := ExceptionMgt.CreateStockException('1002', 'RED', 'B-05', 0, 15);

        // [THEN] Priority defaults to High, no runtime error
        InventoryException.Get(EntryNo);
        Assert.AreEqual(InventoryException.Priority::High, InventoryException.Priority, 'Zero-expected case should be High');
    end;

    [Test]
    procedure ResolveException_WithoutNotesFails()
    var
        InventoryException: Record "WHX Inventory Exception";
        ExceptionMgt: Codeunit "WHX Exception Management";
        EntryNo: Integer;
    begin
        // [GIVEN] An open exception with no resolution notes
        EntryNo := ExceptionMgt.CreateStockException('1000', 'BLUE', 'B-01', 100, 94);
        InventoryException.Get(EntryNo);

        // [WHEN] ResolveException is called without notes
        asserterror ExceptionMgt.ResolveException(InventoryException);

        // [THEN] It fails with the TestField error
        Assert.ExpectedError('Resolution Notes');
    end;

    [Test]
    procedure ResolveException_WithNotesSucceeds()
    var
        InventoryException: Record "WHX Inventory Exception";
        ExceptionMgt: Codeunit "WHX Exception Management";
        EntryNo: Integer;
    begin
        // [GIVEN] An open exception with notes filled in
        EntryNo := ExceptionMgt.CreateStockException('1000', 'BLUE', 'B-01', 100, 94);
        InventoryException.Get(EntryNo);
        InventoryException."Resolution Notes" := 'Recount confirmed shrinkage.';
        InventoryException.Modify();

        // [WHEN] ResolveException is called
        ExceptionMgt.ResolveException(InventoryException);

        // [THEN] Status is Resolved and Resolved Date is set
        InventoryException.Get(EntryNo);
        Assert.AreEqual(InventoryException.Status::Resolved, InventoryException.Status, 'Status should be Resolved');
        Assert.AreNotEqual(0D, InventoryException."Resolved Date", 'Resolved Date should be populated');
    end;

    var
        Assert: Codeunit "Library Assert";
}