package cncta.inject.ui;

@:native("webfrontend.Application")
extern class Application implements qx.application.IApplication
{
    public var initDone:Bool;

    public function getChat():Chat;
    public function getNavigationBar():CitiesNavigationBar;
    public function getDesktop():qx.ui.core.Widget;
}
