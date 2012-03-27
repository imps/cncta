package;

#if macro
import haxe.macro.Type;
#end

class UserScript
{
    public static function main()
    {
    }

#if macro
    public static function generator()
    {
        haxe.macro.Compiler.setCustomJSGenerator(
            function(js) new UserScriptGenerator(js).generate()
        );
    }
#end
}

#if macro
class UserScriptGenerator
{
    private var js:haxe.macro.JSGenApi;

    private var packages:userscript.Packages;
    private var constructor_calls:List<TypedExpr>;

    public function new(js:haxe.macro.JSGenApi)
    {
        this.js = js;

        this.packages = new userscript.Packages();
        this.constructor_calls = new List();
    }

    private function generate_class(cls:ClassType)
    {
        this.packages.add_path(cls.pack.concat([cls.name]));

        if (cls.constructor != null) {
            //trace(cls.constructor.get());
            //trace(this.js.generateConstructor(cls.constructor.get().expr));
        }
    }

    private function generate_enum(enm:EnumType)
    {
        this.packages.add_path(enm.pack.concat([enm.name]));
    }

    private function create_type(type:Type)
    {
        switch (type) {
            case TInst(clstype, params):
                var cls = clstype.get();
                if (cls.init != null)
                    this.constructor_calls.add(cls.init);
                if (!cls.isExtern)
                    this.generate_class(cls);
            case TEnum(enumtype, params):
                var enm = enumtype.get();
                if (!enm.isExtern)
                    this.generate_enum(enm);
            default:
        }
    }

    public function generate()
    {
        for (type in this.js.types) {
            this.create_type(type);
        }

        trace(this.packages.toString());

        //trace(this.js.generateConstructor(js.main.constructor.get().expr));
    }
}
#end
