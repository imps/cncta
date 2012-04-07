package cncta.ui.chat;

class ChatView extends qx.ui.container.Composite
{
    private var scroller:qx.ui.container.Scroll;
    private var view:qx.ui.container.Composite;
    private var lines:Int;

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
    }

    public function add_message(nick:String, date:Date, text:String)
    {
        var time = DateTools.format(date, "%H:%M:%S");

        // they're using <font/> in C&C TA, so we can do it, too? O_o
        var fullmsg = "<font color=\"#00ff00\">[" + time + "]</font>";
        fullmsg += " <font color=\"#66ffff\">" + nick + "</font>";
        fullmsg += "<font color=\"#00cc00\">:</font>";
        fullmsg += " <font color=\"#ffffff\">" + text + "</font>";

        var line = new qx.ui.basic.Label(fullmsg);
        line.set({
            rich: true,
            selectable: true,
        });

        this.view.add(line);

        if (++this.lines > 1000) {
            this.view.removeAt(0);
        }

        this.scroller.scrollToY(500000);
    }
}
