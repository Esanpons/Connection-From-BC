enum 51101 "MyUrlFilter"
{
    /*
    Informacion extraida de las siguientes fuentes
    https://docs.microsoft.com/es-es/learn/modules/work-with-web-services/7-query-options
    https://docs.microsoft.com/en-us/dynamics365/business-central/dev-itpro/webservices/use-filter-expressions-in-odata-uris
    */

    value(1; " ")
    {
    }
    //igual que
    value(2; " eq ")
    {
    }
    //menor que
    value(3; " lt ")
    {
    }
    //mayor que
    value(4; " gt ")
    {
    }
    //no es igual que
    value(5; " ne ")
    {
    }
    //inferior a o igual que
    value(6; " le ")
    {
    }
    //superior a o igual que
    value(7; " ge ")
    {
    }
    //Contiene el valor que
    value(8; "contains")
    {
    }
    //Empieza con el valor que
    value(9; "startswith")
    {
    }
    //Finaliza por el valor que
    value(10; "endswith")
    {
    }
}