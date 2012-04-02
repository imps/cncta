@name("IMPS C&C TA Helper")
@author("aszlig")
@description("A small tool which helps managing an alliance.")
@namespace("https://github.com/imps/cncta")
@include(
    [ "https://prodgame*.alliances.commandandconquer.com/*"
    , "http://prodgame*.alliances.commandandconquer.com/*"
    ]
)
@run_at("document-end")
@version("0.2.7")
@license("BSD3")
@date("2012-03-21")

class CNCTA
{
    private var xmpp:cncta.xmpp.Chat;

    private var maindata:cncta.inject.MainData;
    private var ui:cncta.inject.ui.Application;

    public function new()
    {
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

        cncta.inject.qx.EventRegistration.addListener(
            js.Lib.window,
            "shutdown",
            function(e) { this.xmpp.disconnect(); }
        );
    }

    private function start()
    {
        this.maindata = cncta.inject.MainData.GetInstance();
        this.ui = cast cncta.inject.qx.Init.getApplication();

        var chat_widget = this.ui.getChat();
        chat_widget.chatPos.bottom = 0;
        chat_widget._onSizeMinimize();
        chat_widget.setVisibility("visible");

        this.attach_basebuilder();

        var watch_player = new cncta.watchers.PlayerWatch();
        watch_player.on_watch_ready = this.start_xmpp;
    }

    private function attach_basebuilder()
    {
        var navbar = this.ui.getNavigationBar();
        // dangerous... TODO: identify explicitly
        var buttons:cncta.inject.qx.Composite = cast navbar.getChildren()[2];

        var bb_button = new cncta.inject.qx.Button("BB", null).set({
            appearance: "button-friendlist-scroll",
            height: 24,
            width: 26,
            toolTipText: "Get BaseBuilder URL",
        });

        bb_button.addListener("execute", this.on_basebuilder);

        buttons.addAt(bb_button, 3);
    }

    private function on_basebuilder()
    {
        var popup = new cncta.ui.BaseBuilder();
        //popup.show();
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
        UserScript.extract_meta("CNCTA", "cncta.user.js");

        new CNCTA();
    }
}
