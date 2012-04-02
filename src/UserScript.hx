#if macro
import haxe.macro.Expr;
#end

class UserScript
{
    public function new()
    {
        trace(haxe.rtti.Meta.getType(UserScript));
    }

#if macro
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
        var out = "// ==UserScript==";

        for (m in meta) {
            var name:String = m.name;

            for (p in m.params) {
                var values = UserScript.get_values(p.expr);
                for (value in values) {
                    out += UserScript.finalize_meta(name, value);
                }
            }
        }

        out += "// ==/UserScript==";

        return out;
    }
#end

    @:macro public static function extract_meta(uscls:String):Expr
    {
        haxe.macro.Context.onGenerate(function (types) {
            for (type in types) {
                switch (type) {
                    case TInst(c, _):
                        var cls = c.get();
                        if (cls.name == uscls) {
                            var meta = cls.meta.get();
                            trace(UserScript.generate_meta(meta));
                        }
                    default:
                }
            }
        });
        var ret = EConst(CType("Void"));
        return {expr: ret, pos:haxe.macro.Context.currentPos()};
    }
}
