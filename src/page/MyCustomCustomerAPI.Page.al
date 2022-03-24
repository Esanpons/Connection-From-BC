page 51100 "My Custom Customer API"
{
    PageType = API;
    APIVersion = 'v2.0';
    APIPublisher = 'mycompany';
    APIGroup = 'sales';
    EntityName = 'mycustomer';
    EntitySetName = 'mycustomers';
    DelayedInsert = true;
    ODataKeyFields = "No.";
    SourceTable = Customer;
    InsertAllowed = true;
    DeleteAllowed = true;
    ModifyAllowed = true;

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
                field(name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(email; Rec."E-Mail")
                {
                    ApplicationArea = All;
                }
                field(creditLimit; Rec."Credit Limit (LCY)")
                {
                    ApplicationArea = All;
                }
                field(lastDateModified; Rec."Last Date Modified")
                {
                    ApplicationArea = All;
                }
                field(id; Rec.SystemId)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin

        clear(MyJson);
        Jsontext := 'OnOpenPage := ' + MyJson.CreateJson(Rec);
        JsonText := CopyStr(JsonText, 1, 200);

        i := 1;

        MyLog.reset();
        if MyLog.FindLast() then
            i := MyLog.EntryNo + 1;

        MyLog.init();
        MyLog.EntryNo := i;
        MyLog.JsonText := JsonText;
        if not MyLog.Insert() then;

    end;

    trigger OnModifyRecord(): Boolean
    begin

        clear(MyJson);
        Jsontext := 'OnModifyRecord := ' + MyJson.CreateJson(Rec);
        JsonText := CopyStr(JsonText, 1, 200);

        i := 1;

        MyLog.reset();
        if MyLog.FindLast() then
            i := MyLog.EntryNo + 1;

        MyLog.init();
        MyLog.EntryNo := i;
        MyLog.JsonText := JsonText;
        if not MyLog.Insert() then;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        clear(MyJson);
        Jsontext := 'OnInsertRecord := ' + MyJson.CreateJson(Rec);
        JsonText := CopyStr(JsonText, 1, 200);

        i := 1;

        MyLog.reset();
        if MyLog.FindLast() then
            i := MyLog.EntryNo + 1;

        MyLog.init();
        MyLog.EntryNo := i;
        MyLog.JsonText := JsonText;
        if not MyLog.Insert() then;

    end;

    var
        MyJson: Codeunit MyJson;
        JsonText: Text;
        MyLog: Record MyLog;
        i: Integer;

    [ServiceEnabled]
    procedure editName(var ActionContext: WebServiceActionContext)
    begin
        Rec.Name := 'NewName2 ';
        Rec.Modify();
        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(Page::"My Custom Customer API");
        ActionContext.AddEntityKey(Rec.FieldNo("No."), Rec."No.");
        ActionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;

}