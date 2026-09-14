namespace WarehouseControl.Warehouse;

pageextension 50103 "WHX Exception List Dev Ext" extends "WHX Inventory Exception List"
{
    actions
    {
        addlast(Processing)
        {
            action(WHXGenerateSampleData)
            {
                ApplicationArea = All;
                Caption = 'Generate Sample Data (Dev Only)';
                Tooltip = 'Generates sample inventory and receiving exceptions for testing purposes.';
                Image = TestReport;
                trigger OnAction()
                var
                    DemoDataMgt: Codeunit "WHX Demo Data Mgt";
                begin
                    DemoDataMgt.GenerateSampleExceptions();
                    CurrPage.Update(false);
                end;
            }
        }
    }
}
