package qx.ui.form;

extern class AbstractField extends qx.ui.core.Widget
{
    public function getValue():String;
    public function setValue(value:String):Void;
    public function setTextSelection(start:Int, end:Int):Void;
}
