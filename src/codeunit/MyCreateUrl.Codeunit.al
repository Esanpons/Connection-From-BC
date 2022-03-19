codeunit 51102 "MyCreateUrl"
{
    procedure InitBaseURLPageAPI(EntitySetName: Text)
    var
        URLBaseLbl: Label 'http://bclast:7048/BC/api/', Locked = true;
        APIPublisherLbl: Label 'mycompany/', Locked = true;
        APIGroupLbl: Label 'sales/', Locked = true;
        VersionLbl: Label 'v2.0/', Locked = true;
        URLCompanieLbl: Label 'companies(33e38fba-8f98-ec11-bb87-000d3a2690e9)/', Locked = true;
    begin
        BaseURL := URLBaseLbl + APIPublisherLbl + APIGroupLbl + VersionLbl + URLCompanieLbl + EntitySetName;
    end;

    procedure InitBaseURLPageOData4(NameService: Text)
    var
        URLBaseLbl: Label 'http://bclast:7048/BC/ODataV4/', Locked = true;
        URLCompanieLbl: Label 'Company(%1CRONUS%20Espa%C3%B1a%20S.A.%1)/', Locked = true;
        TxtURLCompanieLbl: text;
        char39: Char;
    begin
        char39 := 39;
        TxtURLCompanieLbl := StrSubstNo(URLCompanieLbl, char39);
        Baseurl := URLBaseLbl + TxtURLCompanieLbl + NameService;
    end;

    procedure SetUrlFuntionPageAPI(NameFunction: Text)
    var
        FunctionLbl: Label '/Microsoft.NAV.', Locked = true;
    begin
        FilterRepeatControl(UrlFuntionPageAPI, FunctionLbl, MyLogicalOperators::" ");

        NameFunction := FunctionLbl + NameFunction;
        UrlFuntionPageAPI := NameFunction;
    end;

    procedure SetUrlFilterKeyPageAPI(ValueEquals: Variant)
    var
        char39: Char;
        TxtValueEquals: Text;
    begin

        char39 := 39;
        TxtValueEquals := Format(ValueEquals);

        case true of
            ValueEquals.IsText:
                TxtValueEquals := char39 + TxtValueEquals + char39;
            ValueEquals.IsDate:
                TxtValueEquals := Format(ValueEquals, 0, '<Year4>-<Month,2>-<Day,2>');
        end;

        TxtValueEquals := StrSubstNo('(%1)', TxtValueEquals);
        UrlFilterKeyPageAPI := TxtValueEquals;
    end;

    procedure SetUrlSubPage(NameSubPage: Text)
    var
        FilterLbl: Label '$expand=', Locked = true;
    begin
        InitFilterUrl(UrlSubPage, FilterLbl, MyLogicalOperators::" ");
        UrlSubPage := NameSubPage;
    end;



    /*
        procedure SetUrlSubPage_Filter( NameSubPage: Text)
        var
            FilterLbl: Label '$expand=%1($filter=', Locked = true;
            TxtFilter: Text;
            MyCreateUrl:Codeunit MyCreateUrl;
        begin
            Clear(MyCreateUrl);

            TxtFilter := StrSubstNo(FilterLbl, NameSubPage);
            //InitFilterUrl(URL, TxtFilter, MyLogicalOperators::" ");
            MyCreateUrl.SetUrlFilter('Sell_to_Customer_No', '30000', MyLogicalOperators::" and ", MyURLFilter::" eq ");
            UrlSubPage_Filter += GetURL();
        end;
    */




    //Muestra los primeros registros que se ponga en el Top
    procedure SetUrlTop(Top: Integer)
    var
        FilterLbl: Label '$top=', Locked = true;
    begin
        InitFilterUrl(UrlTop, FilterLbl, MyLogicalOperators::" ");
        UrlTop := Format(Top);
    end;

    procedure SetUrlSelectFields(NameFields: Text)
    var
        FilterLbl: Label '$select=', Locked = true;
    begin
        InitFilterUrl(UrlSelectFields, FilterLbl, MyLogicalOperators::" ");
        UrlSelectFields := NameFields;
    end;

    procedure SetUrlFilter(TagField: Text; ValueEquals: Variant; MyLogicalOperators: Enum MyLogicalOperators; MyUrlFilter: Enum MyUrlFilter)
    var
        FilterLbl: Label '$filter=', Locked = true;
        Pos: Integer;
        char39: Char;
        TxtValueEquals: Text;
    begin
        char39 := 39;
        TxtValueEquals := Format(ValueEquals);

        case true of
            ValueEquals.IsText:
                TxtValueEquals := char39 + TxtValueEquals + char39;
            ValueEquals.IsDate:
                TxtValueEquals := Format(ValueEquals, 0, '<Year4>-<Month,2>-<Day,2>');
        end;

        InitFilterUrl(UrlFilter, FilterLbl, MyLogicalOperators);
        UrlFilter += TagField + Format(MyUrlFilter) + TxtValueEquals;
    end;

    procedure GetURL(): Text
    var
        Pos: Integer;
        TxtLastUrl: Text;
        PosicionInicialLbl: Label '?$', Locked = true;
    begin
        case true of
            StrPos(UrlSubPage, PosicionInicialLbl) <> 0:
                TxtLastUrl := UrlSubPage + UrlTop + UrlSelectFields + UrlFilter;
            StrPos(UrlTop, PosicionInicialLbl) <> 0:
                TxtLastUrl := UrlTop + UrlSubPage + UrlSelectFields + UrlFilter;
            StrPos(UrlSelectFields, PosicionInicialLbl) <> 0:
                TxtLastUrl := UrlSelectFields + UrlSubPage + UrlTop + UrlFilter;
            StrPos(UrlFilter, PosicionInicialLbl) <> 0:
                TxtLastUrl := UrlFilter + UrlSubPage + UrlTop + UrlSelectFields;
        end;

        exit(BaseURL + UrlFilterKeyPageAPI + UrlFuntionPageAPI + TxtLastUrl);
    end;

    local procedure InitFilterUrl(var URL: Text; FilterTxt: Text; MyEnumUrlFilter: Enum MyLogicalOperators)
    var
        Pos: Integer;
        AndLbl: Label ' and ', Locked = true;
        OrLbl: Label ' or ', Locked = true;
        "?Lbl": Label '?', Locked = true;
        "&Lbl": Label '&', Locked = true;
        PosicionInicialLbl: Label '?$', Locked = true;
    begin
        FilterRepeatControl(URL, FilterTxt, MyEnumUrlFilter);

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
            URL += format(MyEnumUrlFilter);
        end;
    end;

    local procedure FilterRepeatControl(URL: Text; FilterTxt: Text; MyEnumUrlFilter: Enum MyLogicalOperators)
    var
        Pos: Integer;
        error01: Label 'Filter type %1 is already in URL %2 and there can only be one per URL', Comment = 'ESP="El tipo de filtro %1 ya esta en la URL %2 y solo puede haber uno por URL"';
    begin
        exit;
        if MyEnumUrlFilter = MyEnumUrlFilter::" " then begin
            Pos := StrPos(URL, FilterTxt);
            if Pos <> 0 then
                Error(error01);
        end;
    end;


    var
        BaseURL: Text;
        UrlFuntionPageAPI: Text;
        UrlFilterKeyPageAPI: Text;
        UrlSubPage: Text;
        UrlTop: Text;
        UrlSelectFields: Text;
        UrlFilter: Text;


    /*
https://docs.microsoft.com/es-es/learn/modules/work-with-web-services/7-query-options
https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/webservices/use-filter-expressions-in-odata-uris




termina con	$filter=endswith(VAT_Bus_Posting_Group,'RT')

Consulta sobre Atención al cliente. Devuelve todos los clientes con valores de VAT_Bus_Posting_Group que terminan en RT.	*
comienza con	$filter=startswith(Name, 'S')

Consulta sobre Atención al cliente. Devuelve todos los nombres de clientes que comienzan con "S".	
contiene	$filter=contains(Name, 'urn')

Consulta sobre Atención al cliente. Devuelve registros de clientes para clientes con nombres que contienen la cadena "urna".	
índice de	$filter=indexof(Location_Code, 'BLUE') eq 0

Consulta sobre Atención al cliente. Devuelve registros de clientes para clientes que tienen un código de ubicación que comienza con la cadena AZUL.	
reemplazar	$filter=replace(City, 'Miami', 'Tampa') eq 'CODERED'	
subcadena	$filter=substring(Location_Code, 5) eq 'RED'

Consulta sobre Atención al cliente. Devuelve verdadero para clientes con la cadena RED en su código de ubicación que comienza en la posición 5.	
reducir	$filter=tolower(Location_Code) eq 'code red'	
topper	$filter=toupper(FText) eq '2ND ROW'	
podar	$filter=trim(FCode) eq 'CODE RED'	
concat	$filter=concat(concat(FText, ', '), FCode) eq '2nd row, CODE RED'	
ronda	$filter=round(FDecimal) eq 1	
piso	$filter=floor(FDecimal) eq 0	
techo	$filter=ceiling(FDecimal) eq 1
*/
}