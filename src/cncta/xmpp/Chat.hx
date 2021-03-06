package cncta.xmpp;

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

class Chat
{
    private var conn:SecureXMPPConnection;
    private var stream:jabber.client.Stream;
    private var room:MUChat;

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
    public dynamic function on_groupchat_message(m:ChatMessage):Void {}
    public dynamic function on_enter(nick:String):Void {}
    public dynamic function on_leave(nick:String):Void {}

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
        this.room = new MUChat(
            this.stream,
            "conference.headcounter.org",
            this.channel
        );

        this.room.onJoin = function() {
            if (this.room.affiliation == owner) {
                this.configure_room();
            }
            this.on_enter(this.room.nick);
            this.on_joined();
        };

        this.room.onError = this.on_room_error;
        this.room.onPresence = this.on_presence;
        this.room.onMessage = this.on_message;

        this.room.join(this.nick, this.passwd);
    }

    private inline function form_field(name:String, value:String)
    {
        var field = new xmpp.dataform.Field();
        field.variable = name;
        field.values.push(value);
        return field;
    }

    private function on_message(xmpp_from:MUCOccupant, xmpp_msg:xmpp.Message)
    {
        if (xmpp_from == null || xmpp_msg == null) {
            return;
        }

        var date:Date;
        var delay = xmpp.Delayed.fromPacket(xmpp_msg);
        if (delay == null) {
            date = Date.now();
        } else {
            var tz = untyped Date.now().getTimezoneOffset() * 60000;
            date = DateTools.delta(xmpp.DateTime.toDate(delay.stamp), -tz);
        }

        switch (xmpp_msg.type) {
            case groupchat:
                if (xmpp_from.nick == null || xmpp_msg.body == null)
                    return;
                var nick = xmpp_from.nick;
                var body = xmpp_msg.body;
                var myself = this.room.nick == nick;
                var msg = new ChatMessage(myself, nick, date, body);
                this.on_groupchat_message(msg);
            default:
                return;
        }
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
        if (member.presence.status == "unavailable") {
            if (member.nick == this.nick) {
                this.room.changeNick(this.nick);
            }

            this.on_leave(member.nick);
        } else {
            this.on_enter(member.nick);
        }
    }

    public function send(text:String)
    {
        if (this.room != null) {
            this.room.speak(StringTools.htmlEscape(StringTools.trim(text)));
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
