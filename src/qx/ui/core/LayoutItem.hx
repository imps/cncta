package qx.ui.core;

extern class LayoutItem
{
    // these methods really are in qx.core.Object, but we don't want to
    // implement a full Qooxdoo binding, do we?
    public function set(data:Dynamic):LayoutItem;
    public function addListener(type:String, listener:Void -> Void):String;
}
