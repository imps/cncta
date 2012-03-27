package;

class UserScript
{
    public static function main()
    {
    }

#if macro
    public static function generator()
    {
        haxe.macro.Compiler.setCustomJSGenerator(
            function(api) new UserScriptGenerator(api).generate()
        );
    }
#end
}

#if macro
class UserScriptGenerator extends haxe.macro.DefaultJSGenerator
{
}
#end
