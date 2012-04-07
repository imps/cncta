package qx.core;

extern class Object
{
    public function set(data:Dynamic):Object;
    public function addListener(type:String, listener:Dynamic,
                                ?self:Object):String;
    public function fireEvent(type:String):Bool;
}
