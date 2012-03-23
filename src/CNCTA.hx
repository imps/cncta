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
    public var room:jabber.client.MUChat;

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

        auth.onSuccess = this.on_auth_success;

        auth.start(null, null);
    }

    private function on_auth_success()
    {
        this.stream.sendPresence();
        this.join_room();
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

class ChatMessage
{
    public var content:String;
    public var sender:String;
    public var message:String;

    //c = "@A";         // alliance
    //c = "@CCC";       // dunno?
    //c = "@CCM";       // dunno?
    //c = "privatein";  // incoming private message
    //c = "privateout"; // outgoing private message

    public function new(sender:String, msg:String)
    {
        this.content = "@A";
        this.sender = sender;
        this.message = msg;
    }

    public function get_object():Dynamic
    {
        return {'c': this.content, 's': this.sender, 'm': this.message};
    }
}

class CNCWatch
{
    private var _timer:haxe.Timer;
    private var _watcher:Void -> Bool;

    public function new(watcher:Void -> Bool)
    {
        this._watcher = watcher;
        this._timer = new haxe.Timer(10);
        this._timer.run = this.on_timer;
    }

    private function on_timer()
    {
        if (this._watcher()) {
            this._timer.stop();
            this.on_watch_ready();
        }
    }

    public dynamic function on_watch_ready():Void {}
}

class CNCInitWatch extends CNCWatch
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

class CNCTA
{
    private var xmpp:XMPP;
    private var maindata:cncta.inject.ClientLib;
    private var chatdata:cncta.inject.Chat;

    private var _timer:haxe.Timer;

    public function new()
    {
        var watch = new CNCInitWatch();
        watch.on_watch_ready = this.start;
    }

    private function get_chat_widget():Dynamic
    {
        var app = untyped __js__("qx.core.Init.getApplication()");
        return app.getChat();
    }

    private function on_new_message(xmpp_from, xmpp_msg)
    {
        var msg = new ChatMessage(xmpp_from.nick, xmpp_msg.body);
        this.get_chat_widget()._onNewMessage(msg.get_object());
    }

    private function add_chat_handlers()
    {
        this.chatdata.AddMsg = this.xmpp.send;
        this.xmpp.room.onMessage = this.on_new_message;

        var eventReg = untyped __js__("qx.event.Registration");
        eventReg.addListener(untyped __js__("window"), "shutdown",
            this.xmpp.disconnect);
    }

    private function start()
    {
        this.maindata = untyped __js__("ClientLib.Data.MainData.GetInstance()");
        this.chatdata = this.maindata.get_Chat();
        this.get_chat_widget().setVisibility("visible");

        var nick = this.maindata.get_Player().get_Name();
        this.xmpp = new XMPP(nick, "imps", "zA_rw8tumQy=9oY=&='/|7Z+KJ*dEX");
        this.xmpp.on_joined = this.add_chat_handlers;
        this.xmpp.connect();
    }

    static function main()
    {
        untyped __js__("loader.addFinishHandler")(
            function() { new CNCTA(); }
        );
    }
}
