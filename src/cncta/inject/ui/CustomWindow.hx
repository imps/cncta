package cncta.inject.ui;

@:native("webfrontend.gui.CustomWindow")
extern class CustomWindow extends cncta.inject.qx.Window
{
    public function bringToFront():Void;
    public function centerPosition():Void;
}
