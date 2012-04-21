package;

#if macro
import haxe.macro.Expr;
#end

class UserScript
{
    @:macro public static function extract_meta(uscls:String, file:String):Expr
    {
        haxe.macro.Context.onGenerate(function (types) {
            for (type in types) {
                switch (type) {
                    case TInst(c, _):
                        var cls = c.get();
                        if (cls.name == uscls) {
                            var meta = cls.meta.get();
                            var usheader = macro.UserScript.generate_meta(meta);
                            usheader += "\n#CODE_HERE#\n";

                            // remove all metadata
                            for (m in meta) {
                                cls.meta.remove(m.name);
                            }

                            var outfile = neko.io.File.write(file, false);
                            outfile.writeString(usheader);
                            outfile.close();
                        }
                    default:
                }
            }
        });

        var ret = EConst(CType("Void"));
        return {expr: ret, pos:haxe.macro.Context.currentPos()};
    }

#if macro
    public static function generate(infile:String, outfile:String)
    {
        var script = new macro.UserScript(outfile);
        script.from_infile(infile);
        script.write(outfile);
    }
#end
}
