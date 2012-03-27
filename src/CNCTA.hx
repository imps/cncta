// ==UserScript==
// @name          IMPS C&C TA Helper
// @author        aszlig
// @description   A small tool which helps managing an alliance.
// @namespace     https://github.com/imps/cncta
// @include       http://prodgame*.alliances.commandandconquer.com/*/index.*
// @run_at        document-end
// @version       0.2.4
// @license       BSD3
// @date          2012-03-21
// ==/UserScript==

import xmpp.MessageType;
import xmpp.muc.Affiliation;
import jabber.sasl.AnonymousMechanism;
import jabber.client.MUChat;

class SecureXMPPConnection extends jabber.BOSHConnection
{
    override function getHTTPPath():String
    {
        return "https://" + this.path;
    }
}

class XMPPRoom extends MUChat
{
    private var password:String;

    public override function join(nick:String, ?passwd:String):Bool
    {
        this.password = passwd;
        return super.join(nick, passwd);
    }

    override function sendMyPresence(priority:Int = 5):xmpp.Presence
    {
        var x = xmpp.X.create(xmpp.MUC.XMLNS);
        x.addChild(xmpp.XMLUtil.createElement("password", this.password));

        var history = Xml.createElement("history");
        history.set("maxstanzas", "5");
        x.addChild(history);

        var p = new xmpp.Presence(null, null, priority);
        p.to = this.myjid;
        p.properties.push(x);

        return this.stream.sendPacket(p);
    }
}

class XMPP
{
    private var conn:SecureXMPPConnection;
    private var stream:jabber.client.Stream;
    public var room:XMPPRoom;

    private var nick:String;
    private var channel:String;
    private var passwd:String;

    private var nick_retries:Int;

    public function new(nick:String, channel:String, ?passwd:String)
    {
        this.nick = nick;
        this.channel = channel;
        this.passwd = passwd;

        this.nick_retries = 0;
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
        this.conn.disconnect();
    }

    private function join_room()
    {
        this.room = new XMPPRoom(
            this.stream,
            "conference.headcounter.org",
            this.channel
        );

        this.room.onJoin = function() {
            if (this.room.affiliation == owner) {
                this.configure_room();
            }
            this.on_joined();
        };

        this.room.onError = this.on_room_error;
        this.room.onPresence = this.on_presence;

        this.room.join(this.nick, this.passwd);
    }

    private inline function form_field(name:String, value:String)
    {
        var field = new xmpp.dataform.Field();
        field.variable = name;
        field.values.push(value);
        return field;
    }

    private function configure_room()
    {
        var form = new xmpp.DataForm(xmpp.dataform.FormType.submit);

        for (f in [
            form_field("FORM_TYPE", xmpp.MUC.XMLNS + "#roomconfig"),
            form_field("muc#roomconfig_passwordprotectedroom", "1"),
            form_field("muc#roomconfig_roomsecret", this.passwd),
            form_field("muc#roomconfig_allowinvites", "1"),
            form_field("public_list", "0"),
            form_field("muc#roomconfig_publicroom", "0"),
            form_field("muc#roomconfig_roomname", "alliance name here"),
        ]) form.fields.push(f);

        var iq = new xmpp.IQ(xmpp.IQType.set, null, this.room.jid);
        var query = new xmpp.MUCOwner().toXml();
        query.addChild(form.toXml());
        iq.properties.push(query);
        this.room.stream.sendIQ(iq, function(r:xmpp.IQ) {});
    }

    private function get_next_nick():String
    {
        this.nick_retries++;
        return this.nick + Std.string(this.nick_retries);
    }

    private function on_room_error(e:jabber.XMPPError)
    {
        if (e.code == 409) { // nickname in use
            this.room.join(this.get_next_nick(), this.passwd);
        }
    }

    private function on_presence(member:MUCOccupant)
    {
        if (member.nick == this.nick && member.role == xmpp.muc.Role.none) {
            this.room.changeNick(this.nick);
        }
    }

    private function prepare_text(text:String)
    {
        text = StringTools.trim(text);
        if (StringTools.startsWith(text, "/a ")) {
            // XXX: Just strip it by now, as we don't have global chat, yet.
            return text.substr(3);
        }
        return StringTools.htmlEscape(text);
    }

    public function send(text:String)
    {
        if (this.room != null) {
            this.room.speak(prepare_text(text));
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
        this.conn = new SecureXMPPConnection(host, path, null, null, true);
        this.stream = new jabber.client.Stream(this.conn);

        stream.onOpen = this.on_xmpp_open;

        var jid = new jabber.JID(null);
        jid.domain = host;
        stream.open(jid);
    }
}

class ChatMessage
{
    public var content:String;
    public var sender:String;
    public var message:String;

    //c = "@A";         // alliance
    //c = "@C";         // dunno?
    //c = "@CCC";       // dunno?
    //c = "@CCM";       // dunno?
    //s = "@System";    // system message
    //s = "@Info";      // info message
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
        return {c: this.content, s: this.sender, m: this.message};
    }
}

class CNCWatch
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

class PlayerWatch extends CNCWatch
{
    public function new()
    {
        super(this.watcher);
    }

    private function watcher():Bool
    {
        var player_name = untyped __js__(
            "ClientLib.Data.MainData.GetInstance().get_Player().get_Name()"
        );
        return player_name;
    }
}

class CNCTA
{
    private var xmpp:XMPP;
    private var maindata:cncta.inject.ClientLib;
    private var chatdata:cncta.inject.Chat;

    private var _timer:haxe.Timer;

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
        if (xmpp_from == null || xmpp_msg == null) {
            return;
        }

        switch (xmpp_msg.type) {
            case groupchat:
                if (xmpp_from.nick == null || xmpp_msg.body == null)
                    return;
                var msg = new ChatMessage(xmpp_from.nick, xmpp_msg.body);
                this.get_chat_widget()._onNewMessage(msg.get_object());
            default:
                return;
        }
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

        var chat_widget = this.get_chat_widget();
        chat_widget.chatPos.bottom = 0;
        chat_widget._onSizeMinimize();
        chat_widget.setVisibility("visible");

        var watch_player = new PlayerWatch();
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

        this.xmpp = new XMPP(nick, this.get_channel_name(), passwd);
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
