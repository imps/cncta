package core.userscript;

class Generate implements core.userscript.ITemplate
{
    private var code:String;

    public function new(code:String)
    {
        this.code = code;
    }

    private function get_watcher_on(teststr:String, code:String):String
    {
        var out = "";

        var retry = "window.setTimeout(watch_timer__, 1000);";

        out += "function watch_timer__(){";
        out +=     "if(" + teststr + "){";
        out +=         code;
        out +=     "} else {";
        out +=         retry;
        out +=     "}";
        out += "}";
        out += retry;

        return out;
    }

    private function make_loader(code:String):String
    {
        var out = "";

        out += "var inject__ = document.createElement('script');";
        out += "inject__.setAttribute('type', 'text/javascript');";
        out += "inject__.innerHTML = " + code + ";";
        out += "document.body.appendChild(inject__);";
        out += "document.body.removeChild(inject__);";

        return out;
    }

    private function make_watcher(code:String):String
    {
        var syms = [
            "qx",
            "webfrontend",
            "qx.core.Init.getApplication",
        ];

        var check_code = "";
        for (sym in syms) {
            check_code += "typeof(" + sym + ") != 'undefined'";
            check_code += " && ";
        }

        check_code += "qx.core.Init.getApplication().initDone == true";

        return this.get_watcher_on(check_code, code);
    }

    private function make_mainfunction(code:String):String
    {
        var out = "function cncta_userscript__(){";
        out += "function userscript_main_code__(){" + code + "}";
        out += this.make_watcher("userscript_main_code__();");
        out += "}";

        return out;
    }

    private function enclose(code:String):String
    {
        return "(function(){" + code + "})();";
    }

    public function generate():String
    {
        var out = make_mainfunction(this.code);
        out += this.make_loader("'('+cncta_userscript__.toString()+')()'");
        return this.enclose(out);
    }
}
