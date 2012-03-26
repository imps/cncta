package cncta.inject.qx;

import js.Dom;

@:native("qx.event.Registration")
extern class EventRegistration
{
    public static function addListener(obj:Dynamic, type:String, listener:Event -> Void):Dynamic;
}
