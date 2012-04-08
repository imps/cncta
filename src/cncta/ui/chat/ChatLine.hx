package cncta.ui.chat;

class ChatLine extends qx.ui.container.Composite
{
    public function new(date:Date, nick:String, text:String, is_me:Bool)
    {
        super(new qx.ui.layout.HBox(5));

        var time = DateTools.format(date, "%H:%M:%S");

        var bbtext = cncta.inject.Util.convertBBCode(text, true, "#ff9900");

        var timelabel = new cncta.ui.ColorLabel("#00ff00", "[" + time + "]");
        timelabel.set({selectable: true});
        this.add(timelabel);

        var nicklabel = new qx.ui.basic.ColorLabel(
            is_me ? "#ff5050" : "#66ffff",
            nick + ":"
        );
        nicklabel.set({selectable: true});
        this.add(nicklabel);

        var textlabel = new cncta.ui.ColorLabel("#ffffff", bbtext);

        textlabel.set({
            rich: true,
            wrap: true,
            selectable: true,
            allowGrowY: true,
        });

        this.add(textlabel, {flex: 1});
    }

    private function color(color:String, value:String)
    {
        return "<span style=\"color:" + color + "\">" + value + "</span>";
    }
}
