package core;

class Init
{
    private var xmpp:core.xmpp.Chat;

    private var maindata:cncta.inject.MainData;
    private var ui:cncta.inject.ui.Application;

    private var chatwin:cncta.ui.ChatWindow;
    private var toolbox:cncta.ui.ToolBox;

    public function new()
    {
        this.maindata = cncta.inject.MainData.GetInstance();
        this.ui = cast qx.core.Init.getApplication();

        var navbar = this.ui.getAppointmentsBar();

        this.toolbox = new cncta.ui.ToolBox();
        navbar.add(this.toolbox);

        this.attach2toolbox();

        var watch_player = new cncta.watchers.PlayerWatch();
        watch_player.on_watch_ready = this.start_xmpp;
    }

    private function on_new_message(msg:core.xmpp.ChatMessage)
    {
        this.chatwin.add_message(
            msg.sender,
            msg.date,
            msg.message,
            msg.myself
        );
    }

    private function add_chat_handlers()
    {
        this.xmpp.on_groupchat_message = this.on_new_message;
        this.chatwin.on_send = this.xmpp.send;

        qx.event.Registration.addListener(
            js.Lib.window,
            "shutdown",
            function(e) { this.xmpp.disconnect(); }
        );
    }

    private inline function attach2toolbox()
    {
        this.chatwin = new cncta.ui.ChatWindow();

        this.toolbox.add_window_button(
            "Alliance Chat",
            "Open alliance chat",
            this.chatwin
        );

        this.toolbox.add_window_button(
            "Base Builder",
            "Get BaseBuilder URL",
            new cncta.ui.BaseBuilder()
        );
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

        this.xmpp = new core.xmpp.Chat(nick, this.get_channel_name(), passwd);
        this.xmpp.on_joined = this.add_chat_handlers;
        this.xmpp.on_enter = this.chatwin.on_enter;
        this.xmpp.on_leave = this.chatwin.on_leave;
        this.xmpp.connect();
    }
}
