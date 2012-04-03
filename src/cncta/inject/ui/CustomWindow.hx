package cncta.inject.ui;

@:native("webfrontend.gui.CustomWindow")
extern class CustomWindow extends qx.ui.window.Window
{
    public function bringToFront():Void;
    public function centerPosition():Void;
}
