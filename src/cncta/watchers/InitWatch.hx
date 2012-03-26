package cncta.watchers;

class InitWatch extends Watch
{
    public function new()
    {
        super(this.watcher);
    }

    private function watcher():Bool
    {
        var init_done = untyped
            __js__("qx.core.Init.getApplication().initDone");
        return init_done == true;
    }
}
