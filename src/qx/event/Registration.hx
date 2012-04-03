package qx.event;

import qx.event.type.Event;

extern class Registration
{
    public static function addListener(obj:Dynamic,
                                       type:String,
                                       listener:Event -> Void):Dynamic;
}
