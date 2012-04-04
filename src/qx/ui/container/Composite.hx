package qx.ui.container;

import qx.ui.core.LayoutItem;

extern class Composite extends qx.ui.core.Widget
{
    public function new(layout:qx.ui.layout.Abstract):Void;

    public function getChildren():Array<LayoutItem>;

    public function add(child:LayoutItem,
                        ?opts:Dynamic):Void;
    public function addAt(child:LayoutItem, index:Int,
                          ?opts:Dynamic):Void;
    public function addBefore(child:LayoutItem, before:LayoutItem,
                              ?opts:Dynamic):Void;
    public function addAfter(child:LayoutItem, after:LayoutItem,
                             ?opts:Dynamic):Void;
}
