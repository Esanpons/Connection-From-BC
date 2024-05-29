page 51101 "My Oders API"
{
    PageType = API;
    APIVersion = 'v2.0';
    APIPublisher = 'mycompany';
    APIGroup = 'sales';
    EntityName = 'myorder';
    EntitySetName = 'myorders';
    DelayedInsert = true;
    ODataKeyFields = "No.";
    SourceTable = "Sales header";
    InsertAllowed = true;
    DeleteAllowed = true;
    ModifyAllowed = true;
    SourceTableView = WHERE("Document Type" = FILTER(Order));

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(custNo; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(sellToCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                part(SalesLines; "MyOderLine")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                    Enabled = Rec."Sell-to Customer No." <> '';
                    SubPageLink = "Document No." = FIELD("No.");
                    UpdatePropagation = Both;
                    EntityName = 'myorderline';
                    EntitySetName = 'myorderslines';
                }
                part(SalesCommentlines; "MySalesCommentlines")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = true;
                    Enabled = Rec."Sell-to Customer No." <> '';
                    SubPageLink = "No." = FIELD("No.");
                    UpdatePropagation = Both;
                    EntityName = 'sales_comment_line';
                    EntitySetName = 'sales_comment_lines';
                }
            }
        }
    }

}
