namespace WarehouseControl.Warehouse;

codeunit 50103 "WHX Exception Reporting Mgt"
{
    procedure BuildPriorityBuffer(var Buffer: Record "WHX Priority Count Buffer" temporary)
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

    procedure BuildItemBuffer(var Buffer: Record "WHX Item Count Buffer" temporary)
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