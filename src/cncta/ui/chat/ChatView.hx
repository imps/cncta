package cncta.ui.chat;

class ChatView extends qx.ui.container.Composite
{
    private var scroller:qx.ui.container.Scroll;
    private var view:qx.ui.basic.Label;
    private var content:String;
    private var lines:Int;

    public function new()
    {
        var layout = new qx.ui.layout.VBox(2);
        super(layout);

        this.content = "";
        this.lines = 0;

        this.view = new qx.ui.basic.Label(this.content);
        this.view.set({
            rich: true,
            selectable: true,
        });

        this.scroller = new qx.ui.container.Scroll(this.view);
        this.scroller.set({
            minWidth: 200,
            minHeight: 50,
            scrollbarY: "on",
        });

        this.add(this.scroller, {flex: 1});
    }

    public function add_message(nick:String, text:String)
    {
        var cutter = "<!-- C -->";

        // they're using <font/> in C&C TA, so we can do it, too? O_o
        var fullmsg = "<font color=\"#00ff00\">[00:00:00]</font>";
        fullmsg += " <font color=\"#66ffff\">" + nick + "</font>";
        fullmsg += "<font color=\"#00cc00\">:</font>";
        fullmsg += " <font color=\"#ffffff\">" + text + "</font>";
        fullmsg += "<br>" + cutter;

        this.content += fullmsg;
        if (++this.lines > 1000) {
            var cutterpos = this.content.indexOf(cutter);
            if (cutterpos != -1) {
                var cut_at = cutterpos + cutter.length;
                this.content = this.content.substr(cut_at);
            }
        }
        this.view.setValue(this.content);
        this.scroller.scrollToY(500000);
    }
}
