namespace WarehouseControl.Warehouse;

enum 50101 "WHX Exception Status"
{
    Extensible = true;
    value(0; Open)
    {
        Caption = 'Open';
    }
    value(1; Investigating)
    {
        Caption = 'Investigating';
    }
    value(2; Resolved)
    {
        Caption = 'Resolved';
    }
    value(3; Cancelled)
    {
        Caption = 'Cancelled';
    }
}