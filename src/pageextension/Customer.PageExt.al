pageextension 51100 "Customer" extends "Customer List"
{
    actions
    {
        addfirst(navigation)
        {
            action(PostPageAPI)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Post Page API', Locked = true;
                ToolTip = 'Post Page API', Locked = true;
                Image = SendApprovalRequest;

                trigger OnAction()
                begin
                    Clear(MyConection);
                    Clear(MyCreateUrl);
                    URL := MyCreateUrl.ReturnBaseURLPageAPI('mycustomers');
                    MyConection.CreateAuthorization('admin', 'admin');
                    jsontext := MyConection.CallWebService(URL, 'Post', ReturnTestJsonPageAPI('CREATE'));
                    NewCustNo := ReturnCustomerNo(JsonText);
                    Message(JsonText);
                end;
            }
            action(GetPageAPI)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'GET Page API', Locked = true;
                ToolTip = 'GET Page API', Locked = true;
                Image = SendApprovalRequest;

                trigger OnAction()
                begin
                    Clear(MyConection);
                    Clear(MyCreateUrl);
                    URL := MyCreateUrl.ReturnBaseURLPageAPI('mycustomers');
                    MyCreateUrl.SetUrlPageAPI(URL, NewCustNo, '');
                    MyConection.CreateAuthorization('admin', 'admin');
                    Result := MyConection.CallWebService(URL, 'Get', '');
                    Message(Result);
                end;
            }
            action(PutPageAPI)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Put Page API', Locked = true;
                ToolTip = 'Put Page API', Locked = true;
                Image = SendApprovalRequest;

                trigger OnAction()
                begin
                    Clear(MyConection);
                    Clear(MyCreateUrl);
                    URL := MyCreateUrl.ReturnBaseURLPageAPI('mycustomers');
                    MyCreateUrl.SetUrlPageAPI(URL, NewCustNo, '');
                    MyConection.CreateAuthorization('admin', 'admin');
                    MyConection.SearchTag(URL, NewCustNo);
                    Result := MyConection.CallWebService(URL, 'Put', ReturnTestJsonPageAPI('MOD'));
                    Message(Result);
                end;
            }
            action(DeletePageAPI)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Delete Page API', Locked = true;
                ToolTip = 'Delete Page API', Locked = true;
                Image = SendApprovalRequest;

                trigger OnAction()
                begin
                    Clear(MyConection);
                    Clear(MyCreateUrl);
                    URL := MyCreateUrl.ReturnBaseURLPageAPI('mycustomers');
                    MyCreateUrl.SetUrlPageAPI(URL, NewCustNo, '');
                    MyConection.CreateAuthorization('admin', 'admin');
                    Result := MyConection.CallWebService(URL, 'Delete', '');
                    Message(Result);
                end;
            }
            action(Functions)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'Functions Page API', Locked = true;
                ToolTip = 'Functions Page API', Locked = true;
                Image = SendApprovalRequest;

                trigger OnAction()
                begin
                    Clear(MyConection);
                    Clear(MyCreateUrl);
                    URL := MyCreateUrl.ReturnBaseURLPageAPI('mycustomers');
                    MyCreateUrl.SetUrlPageAPI(URL, NewCustNo, 'editName');
                    MyConection.CreateAuthorization('admin', 'admin');
                    Result := MyConection.CallWebService(URL, 'Function', '');
                    Message(Result);
                end;
            }


            action(GetQueryOdata4)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'GET Query Odata4', Locked = true;
                ToolTip = 'GET Query Odata4', Locked = true;
                Image = SendApprovalRequest;

                trigger OnAction()
                begin
                    Clear(MyConection);
                    Clear(MyCreateUrl);
                    URL := MyCreateUrl.ReturnBaseURLPageOData4('JobLedgerEntries');
                    MyConection.CreateAuthorization('admin', 'admin');
                    Result := MyConection.CallWebService(URL, 'Get', '');
                    Message(Result);
                end;
            }


            action(GetPageAndSubPageOdata4)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                Caption = 'GET Page And SubPage Odata4', Locked = true;
                ToolTip = 'GET Page And SubPage Odata4', Locked = true;
                Image = SendApprovalRequest;

                trigger OnAction()
                begin
                    Clear(MyConection);
                    Clear(MyCreateUrl);
                    URL := MyCreateUrl.ReturnBaseURLPageOData4('SalesOrder');
                    MyCreateUrl.SetUrlSubPage(URL, 'SalesOrderSalesLines');
                    MyCreateUrl.SetUrlTop(URL, 2);
                    MyCreateUrl.SetUrlEqValue(URL, 'Status', 'Released', true);
                    MyCreateUrl.SetUrlEqValue(URL, 'Sell_to_Customer_No', '30000', true);
                    MyCreateUrl.SetUrlSelectFields(URL, 'Document_Type,No,Sell_to_Customer_No');
                    MyConection.CreateAuthorization('admin', 'admin');
                    Result := MyConection.CallWebService(URL, 'Get', '');
                    Message(Result);
                end;
            }
        }
    }

    local procedure ReturnTestJsonPageAPI(NewName: Text) JsonText: Text
    var
        JObject: JsonObject;
    begin
        JObject.Add('name', 'CustomerName: ' + NewName);
        JObject.WriteTo(JsonText);
    end;

    local procedure ReturnTestJsonOdata4() JsonText: Text
    var
        JObject: JsonObject;
    begin
        JObject.Add('Sell_to_Customer_No', '30000');
        JObject.WriteTo(JsonText);
    end;

    local procedure ReturnCustomerNo(JsonText: Text) CustomerNo: Text
    var
        Jtoken: JsonToken;
        JObject: JsonObject;
        MyConection: Codeunit "MyConection";
    begin
        Jtoken.ReadFrom(JsonText);
        JObject := Jtoken.AsObject();
        JObject.Get('custNo', Jtoken);
        CustomerNo := Jtoken.AsValue().AsText();
    end;

    var
        MyCreateUrl: Codeunit "MyCreateUrl";
        MyConection: Codeunit "MyConection";
        URL: Text;
        NewCustNo: Text;
        Result: Text;
        jsontext: Text;
}