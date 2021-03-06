package cncta.inject;

@:native("ClientLib.Data.MainData")
extern class MainData
{
    public function get_Chat():cncta.inject.data.Chat;
    public function get_Player():cncta.inject.data.Player;
    public function get_Alliance():cncta.inject.data.Alliance;
    public function get_Server():cncta.inject.data.Server;
    public function get_Cities():cncta.inject.data.Cities;

    public static function GetInstance():MainData;
}
