package cncta.watchers;

class PlayerWatch extends Watch
{
    public function new()
    {
        super(this.watcher);
    }

    private function watcher():Bool
    {
        var main_data = cncta.inject.MainData.GetInstance();
        return cast main_data.get_Player().get_Name();
    }
}
