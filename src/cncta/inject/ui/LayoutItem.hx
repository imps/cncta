package cncta.inject.ui;

@:native("qx.ui.core.LayoutItem")
extern class LayoutItem
{
    // this is really in qx.core.Object, but we don't want to
    // implement a full Qooxdoo binding, do we?
    public function set(data:Dynamic):LayoutItem;
}
