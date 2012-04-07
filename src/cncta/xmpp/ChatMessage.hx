package cncta.xmpp;

class ChatMessage
{
    public var sender:String;
    public var date:Date;
    public var message:String;

    public function new(sender:String, date:Date, msg:String)
    {
        this.sender = sender;
        this.date = date;
        this.message = msg;
    }
}
