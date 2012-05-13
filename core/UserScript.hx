package core;

@name("IMPS C&C TA Helper")
@author("aszlig")
@description("Various extensions to Command & Conquer - Tiberium Alliances")
@namespace("https://github.com/imps/cncta")
@include(
    [ "https://prodgame*.alliances.commandandconquer.com/*"
    , "http://prodgame*.alliances.commandandconquer.com/*"
    ]
)
@run_at("document-end")
@version("0.3.4")
@license("BSD3")

@watch_for("qx")
@watch_for("webfrontend")
@watch_for("qx.core.Init.getApplication")

@watch_for("qx.core.Init.getApplication().initDone", "true")

class UserScript implements userscript.UserScript
{
    public static function main()
    {
        new Init();
    }
}
