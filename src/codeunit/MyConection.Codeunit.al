codeunit 51101 "MyConection"
{
    procedure CreateAuthorization(UserName: Text; Password: Text) ReturnValue: Text
    var
        Base64Convert: Codeunit "Base64 Convert";
    begin
        Authorization := 'Basic ' + Base64Convert.toBase64(StrSubstNo('%1:%2', UserName, Password));
    end;

    procedure SearchTag(URL: Text; ODataKeyFields: Text)
    var
        JsonText: Text;
        Jtoken: JsonToken;
        JObject: JsonObject;
    begin
        JsonText := CallWebService(URL, 'Get', '');
        Jtoken.ReadFrom(JsonText);
        JObject := Jtoken.AsObject();
        JObject.Get('@odata.etag', Jtoken);
        TagText := Jtoken.AsValue().AsText();
    end;

    procedure CallWebService(URL: Text; RequestType: Text; jsonText: Text) ReturnValue: Text
    var
        Client: HttpClient;
        Headers: HttpHeaders;
        Content: HttpContent;
        ContentHeaders: HttpHeaders;
        ResponseMessage: HttpResponseMessage;

        ResultLbl: Label 'Result: ', Comment = 'ESP="Resultado: "';
    begin
        Headers := Client.DefaultRequestHeaders();
        Headers.Add('Authorization', Authorization);

        case RequestType of
            'Get':
                Client.Get(URL, ResponseMessage);
            'Put':
                begin
                    if TagText <> '' then
                        Headers.Add('If-Match', TagText);

                    Content.WriteFrom(jsonText);

                    Content.GetHeaders(ContentHeaders);
                    ContentHeaders.Clear();
                    ContentHeaders.Add('Content-Type', 'application/json');

                    Client.Put(URL, Content, ResponseMessage);
                end;
            'Post':
                begin
                    Content.WriteFrom(jsonText);

                    Content.GetHeaders(ContentHeaders);
                    ContentHeaders.Clear();
                    ContentHeaders.Add('Content-Type', 'application/json');

                    Client.Post(URL, Content, ResponseMessage);
                end;
            'Delete':
                begin
                    Client.Delete(URL, ResponseMessage);
                    if ResponseMessage.IsSuccessStatusCode then
                        exit(ResultLbl + format(ResponseMessage.IsSuccessStatusCode));
                end;
            'Function':
                begin
                    Client.Post(URL, Content, ResponseMessage);
                    if ResponseMessage.IsSuccessStatusCode then
                        exit(ResultLbl + format(ResponseMessage.IsSuccessStatusCode));
                end;
        end;
        ResponseMessage.Content().ReadAs(ReturnValue);
    end;

    var
        TagText: text;
        Authorization: Text;
}