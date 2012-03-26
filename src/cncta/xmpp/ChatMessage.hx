package cncta.xmpp;

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
