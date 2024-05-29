codeunit 51101 "MyConection"
{
    procedure CreateAuthorization(UserName: Text; Password: Text) ReturnValue: Text
    var
        Base64Convert: Codeunit "Base64 Convert";
    begin
        Authorization := 'Basic ' + Base64Convert.toBase64(StrSubstNo('%1:%2', UserName, Password));
        ReturnValue := Authorization;
    end;

    procedure CreateAuthorization(Token: Text) ReturnValue: Text
    begin
        Authorization := 'Bearer ' + Token;
        ReturnValue := Authorization;
    end;

    procedure CallWebService(URL: Text; RequestType: Text; jsonText: Text) ReturnValue: Text
    var
        HttpClient: HttpClient;
        HttpHeaders: HttpHeaders;
        HttpContent: HttpContent;
        ContentHttpHeaders: HttpHeaders;
        HttpResponseMessage: HttpResponseMessage;
        HttpRequestMessage: HttpRequestMessage;
        ResultLbl: Label 'Result: ', Comment = 'ESP="Resultado: "';
    begin
        HttpHeaders := HttpClient.DefaultRequestHeaders();

        if Authorization <> '' then
            HttpHeaders.Add('Authorization', Authorization);

        case RequestType of
            'Get':
                HttpClient.Get(URL, HttpResponseMessage);
            'Put':
                begin
                    HttpHeaders.Add('If-Match', '*');

                    HttpContent.WriteFrom(jsonText);

                    HttpContent.GetHeaders(ContentHttpHeaders);
                    ContentHttpHeaders.Clear();
                    ContentHttpHeaders.Add('Content-Type', 'application/json');

                    HttpClient.Put(URL, HttpContent, HttpResponseMessage);
                end;
            'Patch':
                begin
                    Clear(HttpClient);
                    Clear(HttpHeaders);
                    Clear(HttpContent);
                    Clear(ContentHttpHeaders);
                    Clear(HttpResponseMessage);
                    Clear(HttpRequestMessage);

                    HttpContent.WriteFrom(jsonText);
                    HttpContent.GetHeaders(ContentHttpHeaders);
                    ContentHttpHeaders.Clear();
                    ContentHttpHeaders.Add('Content-Type', 'application/json');

                    HttpRequestMessage.GetHeaders(HttpHeaders);
                    if Authorization <> '' then
                        HttpHeaders.Add('Authorization', Authorization);

                    HttpRequestMessage.Content(HttpContent);
                    HttpRequestMessage.SetRequestUri(URL);
                    HttpRequestMessage.Method('PATCH');

                    HttpClient.Send(HttpRequestMessage, HttpResponseMessage);
                end;
            'Post':
                begin
                    HttpContent.WriteFrom(jsonText);

                    HttpContent.GetHeaders(ContentHttpHeaders);
                    ContentHttpHeaders.Clear();
                    ContentHttpHeaders.Add('Content-Type', 'application/json');

                    HttpClient.Post(URL, HttpContent, HttpResponseMessage);
                end;
            'Delete':
                begin
                    HttpClient.Delete(URL, HttpResponseMessage);
                    if HttpResponseMessage.IsSuccessStatusCode then
                        exit(ResultLbl + format(HttpResponseMessage.IsSuccessStatusCode));
                end;
            'Function':
                begin
                    HttpClient.Post(URL, HttpContent, HttpResponseMessage);
                    if HttpResponseMessage.IsSuccessStatusCode then
                        exit(ResultLbl + format(HttpResponseMessage.IsSuccessStatusCode));
                end;
        end;
        HttpResponseMessage.Content().ReadAs(ReturnValue);
    end;

    var
        Authorization: Text;
}