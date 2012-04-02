class GetReady implements IUserScriptTemplate
{
    public function new()
    {
    }

    private function make_loader(code:String)
    {
        var out = "";

        out += "(function(){";
        out +=     "inject__ = document.createElement('script');";
        out +=     "inject__.type = 'text/javascript';";
        out +=     "inject__.appendChild(document.createTextNode(";
        out +=         code;
        out +=     "));";
        out +=     "document.getElementsByTagName('head')[0].";
        out +=         "appendChild(inject__);";
        out += "})();";

        return out;
    }

    public function generate(code:String):String
    {
        return this.make_loader(code);
    }
}
