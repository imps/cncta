package core.xmpp;

class ChatMessage
{
    public var myself:Bool;
    public var sender:String;
    public var date:Date;
    public var message:String;

    public function new(myself:Bool, sender:String, date:Date, msg:String)
    {
        this.myself = myself;
        this.sender = sender;
        this.date = date;
        this.message = msg;
    }
}
