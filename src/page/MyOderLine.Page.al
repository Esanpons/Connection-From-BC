page 51102 "MyOderLine"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Sales Line";
    SourceTableView = WHERE("Document Type" = FILTER(Order));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                    ApplicationArea = All;
                }

                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the field', comment = 'ESP="Especifica el valor del campo"';
                    ApplicationArea = All;
                }

            }
        }
    }
}