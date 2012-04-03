package qx.ui.container;

import qx.ui.core.LayoutItem;

extern class Composite extends qx.ui.core.Widget
{
    public function getChildren():Array<LayoutItem>;

    public function addAt(child:LayoutItem, index:Int):Void;
    public function addBefore(child:LayoutItem, before:LayoutItem):Void;
    public function addAfter(child:LayoutItem, after:LayoutItem):Void;
}
