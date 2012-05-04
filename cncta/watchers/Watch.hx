package cncta.watchers;

class Watch
{
    private var _watcher:Void -> Bool;

    public function new(watcher:Void -> Bool)
    {
        this._watcher = watcher;
        this.on_timer();
    }

    private function on_timer()
    {
        if (this._watcher()) {
            this.on_watch_ready();
        } else {
            haxe.Timer.delay(this.on_timer, 10);
        }
    }

    public dynamic function on_watch_ready():Void {}
}
