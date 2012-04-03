package qx.event;

extern class EventRegistration
{
    public static function addListener(obj:Dynamic, type:String, listener:Event -> Void):Dynamic;
}
