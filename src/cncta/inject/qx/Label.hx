package cncta.inject.qx;

@:native("qx.ui.basic.Label")
extern class Label extends Widget
{
    public function new(?value:String):Void;
    public var value:String;
    public function setValue(value:String):String;
}
