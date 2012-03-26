package cncta.inject.ui;

@:native("webfrontend.Application")
extern class Application implements cncta.inject.qx.IApplication
{
    public function getChat():Chat;
}
