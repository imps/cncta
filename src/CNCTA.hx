// ==UserScript==
// @name          IMPS C&C TA Helper
// @author        aszlig
// @description   A small tool which helps managing an alliance.
// @namespace     https://github.com/imps/cncta
// @include       http://prodgame*.alliances.commandandconquer.com/*/index.*
// @run_at        document-end
// @version       0.2.3
// @license       BSD3
// @date          2012-03-21
// ==/UserScript==

class CNCTA
{
    private var xmpp:cncta.xmpp.Chat;

    private var maindata:cncta.inject.MainData;
    private var ui:cncta.inject.ui.Application;

    private var is_running:Bool;

    public function new()
    {
        this.is_running = false;
    }

    public function run()
    {
        if (this.is_running)
            return;

        this.is_running = true;
        var watch = new cncta.watchers.InitWatch();
        watch.on_watch_ready = this.start;
    }

    private function on_new_message(msg:cncta.xmpp.ChatMessage)
    {
        this.ui.getChat()._onNewMessage(msg.get_object());
    }

    private function add_chat_handlers()
    {
        this.maindata.get_Chat().AddMsg = this.xmpp.send;
        this.xmpp.on_groupchat_message = this.on_new_message;

        var eventReg = untyped __js__("qx.event.Registration");
        eventReg.addListener(untyped __js__("window"), "shutdown",
            this.xmpp.disconnect);
    }

    private function start()
    {
        this.maindata = untyped __js__("ClientLib.Data.MainData.GetInstance()");
        this.ui = untyped __js__("qx.core.Init.getApplication()");

        var chat_widget = this.ui.getChat();
        chat_widget.chatPos.bottom = 0;
        chat_widget._onSizeMinimize();
        chat_widget.setVisibility("visible");

        var watch_player = new cncta.watchers.PlayerWatch();
        watch_player.on_watch_ready = this.start_xmpp;
    }

    private function get_alliance_hash():String
    {
        var alliance = this.maindata.get_Alliance();
        var members = alliance.get_MemberDataAsArray().copy();

        members.sort(function(m1, m2) {
            if (m1.JoinStep > m2.JoinStep) return -1;
            if (m1.JoinStep < m2.JoinStep) return 1;
            return 0;
        });

        var first = members.pop();
        var hash = haxe.SHA1.encode(Std.string(first.JoinStep) +
                                    Std.string(first.Id));
        return hash;
    }

    private function get_channel_name():String
    {
        var clantag = this.maindata.get_Alliance().get_Abbreviation();
        var world_id = this.maindata.get_Server().get_WorldId();

        var enc_tag = StringTools.replace(clantag, " ", "-");
        var enc_world = Std.string(world_id);

        return ("cncta" + enc_world + "_" + enc_tag).toLowerCase();
    }

    private function start_xmpp()
    {
        var nick = this.maindata.get_Player().get_Name();
        var passwd = this.get_alliance_hash();

        this.xmpp = new cncta.xmpp.Chat(nick, this.get_channel_name(), passwd);
        this.xmpp.on_joined = this.add_chat_handlers;
        this.xmpp.connect();
    }

    static function main()
    {
        var cncta = new CNCTA();
        untyped __js__("loader.addFinishHandler")(
            function() { cncta.run(); }
        );
    }
}
