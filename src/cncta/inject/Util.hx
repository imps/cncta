package cncta.inject;

@:native("webfrontend.gui.Util")
extern class Util
{
    public static function convertBBCode(text:String, nohr:Bool,
                                         link_color:String):String;
}
