package cncta.ui.chat;

class ChatLine extends qx.ui.container.Composite
{
    public inline var is_me(default, set_is_me):Bool;
    private var nicklabel:qx.ui.basic.Label;

    public function new(date:Date, nick:String, text:String)
    {
        super(new qx.ui.layout.HBox(5));

        var time = DateTools.format(date, "%H:%M:%S");

        var bbtext = cncta.inject.Util.convertBBCode(text, true, "#ff9900");

        var timelabel = new cncta.ui.ColorLabel("#00ff00", "[" + time + "]");
        timelabel.set({selectable: true});
        this.add(timelabel);

        this.nicklabel = new qx.ui.basic.Label(nick + ":");
        this.nicklabel.set({selectable: true});
        this.is_me = false;
        this.add(this.nicklabel);

        var textlabel = new cncta.ui.ColorLabel("#ffffff", bbtext);

        textlabel.set({
            rich: true,
            wrap: true,
            selectable: true,
            allowGrowY: true,
        });

        this.add(textlabel, {flex: 1});
    }

    private inline function set_is_me(v:Bool)
    {
        this.nicklabel.set({
            textColor: (v ? "#ff5050" : "#66ffff")
        });
        return is_me = v;
    }
}
