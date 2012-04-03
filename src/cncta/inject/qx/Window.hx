package cncta.inject.qx;

@:native("qx.ui.window")
extern class Window extends Widget
{
    public function new(title:String, ?icon:String):Void;
    public function add(child:LayoutItem, ?options:Dynamic):Widget;
    public function show():Void;
    public function setAppearance(value:String):String;
}
