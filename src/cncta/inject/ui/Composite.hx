package cncta.inject.ui;

@:native("qx.ui.container.Composite")
extern class Composite
{
    public function getChildren():List<LayoutItem>;

    public function addAt(child:LayoutItem, index):Void;
    public function addBefore(child:LayoutItem, before:LayoutItem):Void;
    public function addAfter(child:LayoutItem, after:LayoutItem):Void;
}
