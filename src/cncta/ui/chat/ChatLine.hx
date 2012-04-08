package cncta.ui.chat;

class ChatLine extends qx.ui.basic.Label
{
    public function new(date:Date, nick:String, text:String, is_me:Bool)
    {
        var time = DateTools.format(date, "%H:%M:%S");

        var bbtext = cncta.inject.Util.convertBBCode(text, true, "#ff9900");

        var fullmsg = this.color("#00ff00", "[" + time + "]");
        fullmsg += " " + this.color(is_me ? "#ff5050" : "#66ffff", nick);
        fullmsg += this.color("#00cc00", ":");
        fullmsg += " " + this.color("#ffffff", bbtext);

        super(fullmsg);
        this.set({
            rich: true,
            selectable: true,
        });
    }

    private function color(color:String, value:String)
    {
        return "<span style=\"color:" + color + "\">" + value + "</span>";
    }
}
