package qx.ui.core;

extern class Widget extends LayoutItem
{
    public function setVisibility(v:String):Void;
    public function setDecorator(v:String):Void;

    public function setAppearance(v:String):String;
    public function updateAppearance():Void;

    public function show():Void;
    public function hide():Void;
    public function isVisible():Bool;

    public function focus():Void;
    public function blur():Void;
}
