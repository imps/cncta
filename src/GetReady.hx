class GetReady implements IUserScriptTemplate
{
    public function new()
    {
    }

    private function get_watcher_on(teststr:String, code:String)
    {
        var out = "";

        out += "(function() {";
        out += "var wtimer__;";
        out += "function watch_timer__(){";
        out +=     "if(" + teststr + "){";
        out +=         this.make_loader(code);
        out +=         "window.clearInterval(wtimer__);";
        out +=     "}";
        out += "}";
        out += "var wtimer__ = window.setInterval(watch_timer__, 1000);";
        out += "})();";

        return out;
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
        return this.get_watcher_on("typeof(webfrontend) == 'object'", code);
    }
}
