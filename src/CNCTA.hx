// ==UserScript==
// @name          IMPS C&C TA Helper
// @author        aszlig
// @description   A small tool which helps managing an alliance.
// @namespace     https://github.com/aszlig/imps
// @include       http://prodgame*.alliances.commandandconquer.com/*/index.aspx
// @run_at        document-end
// @version       1.0
// @date          2012-03-21
// ==/UserScript==

import jabber.sasl.AnonymousMechanism;

class SecureXMPPConnection extends jabber.BOSHConnection
{
    override function getHTTPPath():String
    {
        return "https://" + this.path;
    }
}

class XMPP
{
    private var xmpp:SecureXMPPConnection;
    private var stream:jabber.client.Stream;
    private var room:jabber.client.MUChat;

    private var nick:String;
    private var channel:String;
    private var passwd:String;

    public function new(nick:String, channel:String, ?passwd:String)
    {
        this.nick = nick;
        this.channel = channel;
        this.passwd = passwd;
    }

    public dynamic function on_joined():Void {}

    public function connect()
    {
        this.xmpp_connect(
            "anonymous.headcounter.org",
            "jabber.headcounter.org/http-bind"
        );
    }

    public inline function disconnect()
    {
        this.xmpp.disconnect();
    }

    private function join_room()
    {
        this.room = new jabber.client.MUChat(
            this.stream,
            "conference.headcounter.org",
            this.channel
        );

        this.room.onJoin = this.on_joined;

        this.room.join(this.nick, this.passwd);
    }

    public function send(text:String)
    {
        if (this.room != null) {
            this.room.speak(text);
        }
    }

    private function on_xmpp_open()
    {
        var server_mechs = this.stream.server.features.get("mechanisms");

        var auth = new jabber.client.Authentication(
            this.stream,
            [new AnonymousMechanism()]
        );

        auth.onSuccess = function() {
            this.stream.sendPresence();
            this.join_room();
        }

        auth.start(null, null);
    }

    private function xmpp_connect(host:String, path:String)
    {
        this.xmpp = new SecureXMPPConnection(host, path, null, null, true);
        this.stream = new jabber.client.Stream(this.xmpp);

        stream.onOpen = this.on_xmpp_open;

        var jid = new jabber.JID(null);
        jid.domain = host;
        stream.open(jid);
    }
}

extern class Loader
{
    public function addFinishHandler(cb:Dynamic):Void;
}

class CNCTA
{
    private var xmpp:XMPP;
    private var client_lib:cncta.inject.ClientLib;
    private var chat:cncta.inject.Chat;

    public function new()
    {
        this.game_started();
    }

    private function game_started()
    {
        this.client_lib = untyped
            __js__("ClientLib.Data.MainData.GetInstance()");
        this.chat = this.client_lib.get_Chat();

        this.xmpp = new XMPP("ingame_asshole", "imps", "zA_rw8tumQy=9oY=&='/|7Z+KJ*dEX");
        this.xmpp.on_joined = this.add_chat_handlers;
        this.xmpp.connect();

        var timer = new haxe.Timer(10);
        timer.run = function() {
            var init_done = untyped
                __js__("qx.core.Init.getApplication().initDone");
            if (init_done == true) {
                timer.stop();
                this.start();
            }
        };
    }

    private function get_chat_widget():Dynamic
    {
        var app = untyped __js__("qx.core.Init.getApplication()");
        return app.getChat();
    }

    private function add_chat_handlers()
    {
        this.chat.AddMsg = this.xmpp.send;

        var eventReg = untyped __js__("qx.event.Registration");
        eventReg.addListener(untyped __js__("window"), "shutdown",
            this.xmpp.disconnect);
    }

    private function start()
    {
        this.get_chat_widget().setVisibility("visible");
    }

    static function main()
    {
        untyped __js__("loader.addFinishHandler")(
            function() { new CNCTA(); }
        );
    }
}
