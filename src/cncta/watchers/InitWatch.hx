package cncta.watchers;

import cncta.inject.ui.Application;

class InitWatch extends Watch
{
    public function new()
    {
        super(this.watcher);
    }

    private function watcher():Bool
    {
        var app:Application = cast qx.core.Init.getApplication();
        return app.initDone == true;
    }
}
