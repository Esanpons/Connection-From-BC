codeunit 51102 "MyCreateUrl"
{
    procedure ReturnBaseURLPageAPI(EntitySetName: Text): Text
    var
        URLBaseLbl: Label 'http://bclast:7048/BC/api/', Locked = true;
        APIPublisherLbl: Label 'mycompany/', Locked = true;
        APIGroupLbl: Label 'sales/', Locked = true;
        VersionLbl: Label 'v2.0/', Locked = true;
        URLCompanieLbl: Label 'companies(33e38fba-8f98-ec11-bb87-000d3a2690e9)/', Locked = true;
    begin
        exit(URLBaseLbl + APIPublisherLbl + APIGroupLbl + VersionLbl + URLCompanieLbl + EntitySetName);
    end;

    procedure ReturnBaseURLPageOData4(NameService: Text): Text
    var
        URLBaseLbl: Label 'http://bclast:7048/BC/ODataV4/', Locked = true;
        URLCompanieLbl: Label 'Company(%1CRONUS%20Espa%C3%B1a%20S.A.%1)/', Locked = true;
        TxtURLCompanieLbl: text;
        char39: Char;
    begin
        char39 := 39;
        TxtURLCompanieLbl := StrSubstNo(URLCompanieLbl, char39);
        exit(URLBaseLbl + TxtURLCompanieLbl + NameService);
    end;

    procedure SetUrlPageAPI(var URL: Text; ODataKeyFields: Text; NameFunction: Text)
    var
        txt: text;
        char39: Char;
        FunctionLbl: Label '/Microsoft.NAV.', Locked = true;
    begin
        if ODataKeyFields <> '' then begin
            char39 := 39;
            txt := char39 + ODataKeyFields + char39;
            ODataKeyFields := StrSubstNo('(%1)', txt);
            URL += ODataKeyFields;
        end;

        if NameFunction <> '' then begin
            NameFunction := FunctionLbl + NameFunction;
            URL += NameFunction;
        end;
    end;

    procedure SetUrlSubPage(var URL: Text; NameSubPage: Text)
    var
        FilterLbl: Label '$expand=', Locked = true;
    begin
        InitUrl(URL, FilterLbl, false);
        URL += NameSubPage;
    end;

    //Muestra los primeros registros que se ponga en el Top
    procedure SetUrlTop(var URL: Text; Top: Integer)
    var
        FilterLbl: Label '$top=', Locked = true;
    begin
        InitUrl(URL, FilterLbl, false);
        URL += Format(Top);
    end;

    procedure SetUrlSelectFields(var URL: Text; NameFields: Text)
    var
        FilterLbl: Label '$select=', Locked = true;
    begin
        InitUrl(URL, FilterLbl, false);
        URL += NameFields;
    end;

    procedure SetUrlEqValue(var URL: Text; TagField: Text; ValueEquals: Variant; IsAnd: Boolean)
    var
        FilterLbl: Label '$filter=', Locked = true;
        ExpressionLbl: Label ' eq ', Locked = true;
        Pos: Integer;
        char39: Char;
        TxtValueEquals: Text;

    begin
        char39 := 39;
        TxtValueEquals := Format(ValueEquals);

        if ValueEquals.IsText then
            TxtValueEquals := char39 + TxtValueEquals + char39;

        InitUrl(URL, FilterLbl, false);
        URL += TagField + ExpressionLbl + TxtValueEquals;
    end;

    local procedure InitUrl(var URL: Text; FilterTxt: Text; IsAnd: Boolean)
    var
        Pos: Integer;
        AndLbl: Label ' And ', Locked = true;
        OrLbl: Label ' Or ', Locked = true;
        "?Lbl": Label '?', Locked = true;
        "&Lbl": Label '&', Locked = true;
        PosicionInicialLbl: Label '?$', Locked = true;
    begin
        Pos := StrPos(URL, PosicionInicialLbl);
        if Pos = 0 then
            URL += "?Lbl"
        else
            URL += "&Lbl";

        Pos := StrPos(URL, FilterTxt);
        if Pos = 0 then
            URL += FilterTxt
        else begin
            URL := PadStr(URL, StrLen(URL) - 1);
            if IsAnd then
                URL += AndLbl
            else
                URL += OrLbl;
        end;
    end;

    /*
    https://docs.microsoft.com/es-es/learn/modules/work-with-web-services/7-query-options
    lt: inferior a
    gt: superior a
    ne: no igual que
    le: inferior a o igual que
    ge: superior a o igual que
    /SalesOrders?$expand=SalesOrderSalesLines($filter=No eq '1920-S')

    POSTMAN: http://bclast:7048/BC/ODataV4/Company('CRONUS%20Espa%C3%B1a%20S.A.')/SalesOrder?$expand=SalesOrderSalesLines&$filter=Status eq 'Released' and Sell_to_Customer_No eq '30000'&$top=2
    */

    //filtra el resgitro que tenga el campo con el valor exacto
    //eq: igual que





}