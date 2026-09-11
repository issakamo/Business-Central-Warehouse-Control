namespace WarehouseControl.Warehouse;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Location;
using Microsoft.Warehouse.Structure;

table 50100 "WHX Inventory Exception"
{
    DataClassification = CustomerContent;
    Caption = 'Inventory Exceptions';
    LookupPageID = "WHX Inventory Exception List";
    DrillDownPageID = "WHX Inventory Exception List";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            AutoIncrement = true;
            DataClassification = SystemMetadata;
        }
        field(10; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item."No.";
            DataClassification = CustomerContent;
            NotBlank = true;
        }
        field(11; "Description"; Text[100])
        {
            Caption = 'Description';
            FieldClass = FlowField;
            CalcFormula = Lookup(Item.Description where("No." = field("Item No.")));
            Editable = false;
        }
        field(20; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
            DataClassification = CustomerContent;
        }
        field(21; "Bin Code"; Code[20])
        {
            Caption = 'Bin Code';
            TableRelation = Bin.Code where("Location Code" = field("Location Code"));
            DataClassification = CustomerContent;
        }
        field(30; "Exception Type"; Enum "WHX Exception Type")
        {
            Caption = 'Exception Type';
            DataClassification = CustomerContent;
        }
        field(40; "Expected Quantity"; Decimal)
        {
            Caption = 'Expected Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(41; "Actual Quantity"; Decimal)
        {
            Caption = 'Actual Quantity';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
        }
        field(42; "Difference"; Decimal)
        {
            Caption = 'Difference';
            DecimalPlaces = 0 : 5;
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50; Status; Enum "WHX Exception Status")
        {
            Caption = 'Status';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Status = Status::Resolved then
                    "Resolved Date" := Today
                else
                    "Resolved Date" := 0D;
            end;
        }
        field(51; Priority; Enum "WHX Exception Priority")
        {
            Caption = 'Priority';
            DataClassification = CustomerContent;
        }
        field(60; "Resolution Notes"; Text[250])
        {
            Caption = 'Resolution Notes';
            DataClassification = CustomerContent;
        }
        field(70; "Created Date"; Date)
        {
            Caption = 'Created Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(71; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(80; "Resolved Date"; Date)
        {
            Caption = 'Resolved Date';
            DataClassification = SystemMetadata;
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(ItemStatus; "Item No.", Status)
        {

        }
    }

    trigger OnInsert()
    begin
        if "Created Date" = 0D then
            "Created Date" := Today;
        if "Created By" = '' then
            "Created By" := CopyStr(UserId(), 1, MaxStrLen("Created By"));
        Difference := "Actual Quantity" - "Expected Quantity";
    end;


}