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

    //Muestra la subPage
    procedure SetUrlSubPage(NameSubPage: Text)
    var
        FilterLbl: Label '$expand=', Locked = true;
    begin
        RepeatControl(UrlSubPage, FilterLbl, MyLogicalOperators::" ");

        InitConsultationOptionsURL(UrlSubPage, FilterLbl, MyLogicalOperators::" ");
        UrlSubPage += NameSubPage;
    end;

    //Filtro de subpage
    procedure SetUrlSubPage_Filter(NameSubPage: Text; TagField: Text; ValueEquals: Variant; MyLogicalOperators: Enum MyLogicalOperators; MyUrlFilter: Enum MyUrlFilter)
    var
        MyCreateUrl: Codeunit MyCreateUrl;
        WhichLbl: Label '?', Locked = true;
        WhereLbl: Label '=', Locked = true;
    begin
        Clear(MyCreateUrl);
        MyCreateUrl.SetUrlFilter(TagField, ValueEquals, MyLogicalOperators, MyURLFilter);
        UrlSubPage_Filter += MyCreateUrl.GetURL();
        UrlSubPage_Filter := DelChr(UrlSubPage_Filter, WhereLbl, WhichLbl);
    end;

    //Muestra los primeros registros que se ponga en el Top
    procedure SetUrlTop(Top: Integer)
    var
        FilterLbl: Label '$top=', Locked = true;
    begin
        InitConsultationOptionsURL(UrlTop, FilterLbl, MyLogicalOperators::" ");
        UrlTop += Format(Top);
    end;

    //solo mostrara en el Json los campos añadidos
    procedure SetUrlSelectFields(NameFields: Text)
    var
        FilterLbl: Label '$select=', Locked = true;
    begin
        RepeatControl(UrlSelectFields, FilterLbl, MyLogicalOperators::" ");

        InitConsultationOptionsURL(UrlSelectFields, FilterLbl, MyLogicalOperators::" ");
        UrlSelectFields += NameFields;
    end;

    //filtros 
    procedure SetUrlFilter(TagField: Text; ValueEquals: Variant; MyLogicalOperators: Enum MyLogicalOperators; MyUrlFilter: Enum MyUrlFilter)
    var
        FilterLbl: Label '$filter=', Locked = true;
        ParenthesisLbl: Label '(%1,%2)', Locked = true;
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

        InitConsultationOptionsURL(UrlFilter, FilterLbl, MyLogicalOperators);
        case MyUrlFilter of
            MyUrlFilter::contains, MyUrlFilter::startswith, MyUrlFilter::endswith:
                UrlFilter += Format(MyUrlFilter) + StrSubstNo(ParenthesisLbl, TagField, TxtValueEquals);
            else
                UrlFilter += TagField + Format(MyUrlFilter) + TxtValueEquals;
        end;

    end;

    //retorna la URL ya creada
    procedure GetURL(): Text
    var
        TxtLastUrl: Text;
        PosicionInicialLbl: Label '?$', Locked = true;
        SubPageFilterLbl: Label '(%1)', Locked = true;
    begin
        if UrlSubPage_Filter <> '' then
            UrlSubPage += StrSubstNo(SubPageFilterLbl, UrlSubPage_Filter);

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

    //funcion para inicilaizar las opciones de consultas de la URL
    local procedure InitConsultationOptionsURL(var TextFilterUrl: Text; FilterTxt: Text; MyEnumUrlFilter: Enum MyLogicalOperators)
    var
        Pos: Integer;
        "?Lbl": Label '?', Locked = true;
        "&Lbl": Label '&', Locked = true;
    begin
        RepeatControl(TextFilterUrl, FilterTxt, MyEnumUrlFilter);

        if IsTheQuestionMarkThere then
            TextFilterUrl += "&Lbl"
        else begin
            TextFilterUrl += "?Lbl";
            IsTheQuestionMarkThere := true;
        end;

        Pos := StrPos(TextFilterUrl, FilterTxt);
        if Pos = 0 then
            TextFilterUrl += FilterTxt
        else begin
            TextFilterUrl := PadStr(TextFilterUrl, StrLen(TextFilterUrl) - 1);
            TextFilterUrl += format(MyEnumUrlFilter);
        end;
    end;

    //comprueba que no este repetido el control
    local procedure RepeatControl(TextFilterUrl: Text; FilterTxt: Text; MyEnumUrlFilter: Enum MyLogicalOperators)
    var
        Pos: Integer;
        Text001Err: Label 'Filter type "%1" is already in URL', Comment = 'ESP="El tipo de filtro "%1" ya esta en la URL"';
    begin
        if MyEnumUrlFilter = MyEnumUrlFilter::" " then begin
            Pos := StrPos(TextFilterUrl, FilterTxt);
            if Pos <> 0 then
                Error(Text001Err, FilterTxt);
        end;
    end;


    var
        IsTheQuestionMarkThere: Boolean;
        BaseURL: Text;
        UrlFuntionPageAPI: Text;
        UrlFilterKeyPageAPI: Text;
        UrlSubPage: Text;
        UrlSubPage_Filter: Text;
        UrlTop: Text;
        UrlSelectFields: Text;
        UrlFilter: Text;
}