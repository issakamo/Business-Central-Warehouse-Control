namespace WarehouseControl.Warehouse;

enum 50100 "WHX Exception Type"
{
    Extensible = true;
    value(0; "Low Stock")
    {
        Caption = 'Low Stock';
    }
    value(1; "Stock Discrepancy")
    {
        Caption = 'Stock Discrepancy';
    }
    value(2; "Receiving Discrepancy")
    {
        Caption = 'Receiving Discrepancy';
    }
    value(3; Overstock)
    {
        Caption = 'Overstock';
    }
    value(4; "Inactive Item")
    {
        Caption = 'Inactive Item';
    }
    value(5; "Bin Issue")
    {
        Caption = 'Bin Issue';
    }
}