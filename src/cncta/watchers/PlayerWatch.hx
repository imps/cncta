package cncta.watchers;

class PlayerWatch extends Watch
{
    public function new()
    {
        super(this.watcher);
    }

    private function watcher():Bool
    {
        var player_name = untyped __js__(
            "ClientLib.Data.MainData.GetInstance().get_Player().get_Name()"
        );
        return player_name;
    }
}

