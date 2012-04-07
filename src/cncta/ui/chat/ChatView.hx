package cncta.ui.chat;

class ChatView extends qx.ui.container.Composite
{
    private var scroller:qx.ui.container.Scroll;
    private var view:qx.ui.container.Composite;
    private var lines:Int;

    public var roster:ChatRoster;

    public function new()
    {
        super(new qx.ui.layout.HBox(2));

        this.lines = 0;

        var layout = new qx.ui.layout.VBox(0);
        this.view = new qx.ui.container.Composite(layout);

        this.scroller = new qx.ui.container.Scroll(this.view);
        this.scroller.set({
            minWidth: 300,
            minHeight: 50,
            scrollbarY: "on",
        });

        this.add(this.scroller, {flex: 1});

        this.roster = new ChatRoster();
        this.add(this.roster);

        this.addListener("resize", this.scroll_down);
    }

    private function color(color:String, value:String)
    {
        return "<span style=\"color:" + color + "\">" + value + "</span>";
    }

    private function scroll_down()
    {
        this.scroller.scrollToY(500000);
    }

    public function add_message(nick:String, date:Date, text:String)
    {
        var time = DateTools.format(date, "%H:%M:%S");

        var fullmsg = this.color("#00ff00", "[" + time + "]");
        fullmsg += " " + this.color("#66ffff", nick);
        fullmsg += this.color("#00cc00", ":");
        fullmsg += " " + this.color("#ffffff", text);

        var line = new qx.ui.basic.Label(fullmsg);
        line.set({
            rich: true,
            selectable: true,
        });

        this.view.add(line);

        if (++this.lines > 1000) {
            this.view.removeAt(0);
        }

        this.scroll_down();
    }
}
