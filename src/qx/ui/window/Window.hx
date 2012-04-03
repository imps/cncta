package qx.ui.window;

import qx.ui.core.LayoutItem;
import qx.ui.core.Widget;

extern class Window extends Widget
{
    public function new(title:String, ?icon:String):Void;
    public function add(child:LayoutItem, ?options:Dynamic):Widget;
    public function show():Void;
}
