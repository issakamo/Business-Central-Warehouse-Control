namespace WarehouseControl.Warehouse;

using Microsoft.Finance.RoleCenters;

pageextension 50100 "WHX Business Manager RC Ext" extends "Business Manager Role Center"
{
    layout
    {
        addfirst(RoleCenter)
        {
            part(WHXExceptionCue; "WHX Exception Cue")
            {
                ApplicationArea = All;
            }
        }
    }
}