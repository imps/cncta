package cncta.inject.ui;

@:native("webfrontend.gui.Chat")
extern class Chat extends qx.ui.core.Widget
{
    public var chatPos:Dynamic;
    public var chatSize:Array<{width:Int, height:Int}>;
    public var sizeMode:Int;

    public function _onSizeMinimize():Void;
    public function _onNewMessage(m:Dynamic):Void;

    //public var sendButton:form.Button;
    //public var chatLine:form.TextField;
}
