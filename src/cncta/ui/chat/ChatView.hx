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
            width: 300,
            height: 50,
            minWidth: 100,
            scrollbarY: "on",
        });

        this.add(this.scroller, {flex: 4});

        this.roster = new ChatRoster();
        this.roster.set({
            allowShrinkX: true,
            minWidth: 50,
            maxWidth: 200,
        });

        this.add(this.roster, {flex: 1});

        this.addListener("resize", this.scroll_down);
    }

    private function scroll_down()
    {
        this.scroller.scrollToY(500000);
    }

    public function add_message(nick:String, date:Date, text:String,
                                ?is_me:Bool = false)
    {
        var line = new cncta.ui.chat.ChatLine(date, nick, text);
        line.is_me = is_me;
        this.view.add(line);

        if (++this.lines > 1000) {
            this.view.removeAt(0);
        }

        this.scroll_down();
    }
}
