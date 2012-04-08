package qx.ui.core;

extern class Widget extends LayoutItem
{
    public function setVisibility(v:String):Void;

    public function getDecorator():Dynamic;
    public function setDecorator(v:Dynamic):Void;
    public function resetDecorator():Void;

    public function getAppearance():String;
    public function setAppearance(v:String):String;
    public function updateAppearance():Void;

    public function getBackgroundColor():Dynamic;
    public function setBackgroundColor(value:Dynamic):Void;

    public function syncWidget():Void;

    public function show():Void;
    public function hide():Void;
    public function isVisible():Bool;

    public function focus():Void;
    public function blur():Void;
}
