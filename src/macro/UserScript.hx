package macro;

import haxe.macro.Expr;

class UserScript
{
    private var template:String;

    public function new(template:String)
    {
        this.template = sys.io.File.getContent(template);
    }

    public function from_infile(infile:String)
    {
        var code = new jsmin.JSMin(sys.io.File.getContent(infile)).output;

        // XXX: GetReady is hardcoded here, need to find a way to fix it...
        var tpl:IUserScriptTemplate = new GetReady(code);

        this.template = StringTools.replace(
            this.template,
            "#CODE_HERE#",
            tpl.generate()
        );
    }

    public function write(outfile:String)
    {
        var out = sys.io.File.write(outfile, false);
        out.writeString(this.template);
        out.close();
    }

    public static function finalize_meta(name:String, value:String):String
    {
        return "// @" + name + " " + value + "\n";
    }

    public static function get_string_value(e:ExprDef):String
    {
        switch (e) {
            case EConst(c):
                switch (c) {
                    case CString(val):
                        return val;
                    default:
                }
            default:
        }

        return null;
    }

    public static function get_values(e:ExprDef):Array<String>
    {
        var out:Array<String> = new Array();

        switch (e) {
            case EConst(c):
                switch (c) {
                    case CString(val):
                        return [val];
                    default:
                }
            case EArrayDecl(a):
                for (val in a) {
                    out.push(UserScript.get_string_value(val.expr));
                }
            default:
        }

        return out;
    }

    public static function generate_meta(meta:Metadata)
    {
        var out = "// ==UserScript==\n";

        for (m in meta) {
            var name:String = m.name;

            for (p in m.params) {
                var values = UserScript.get_values(p.expr);
                for (value in values) {
                    out += UserScript.finalize_meta(name, value);
                }
            }
        }

        out += "// ==/UserScript==\n\n";

        out += "// THIS FILE IS AUTOGENERATED, PLEASE DO NOT MODIFY!\n";
        out += "// If you want to make changes, please look into the\n";
        out += "// UserScript block above to get more information on\n";
        out += "// how to obtain the source code or make changes.\n";

        return out;
    }
}
