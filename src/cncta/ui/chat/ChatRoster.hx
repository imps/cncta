package cncta.ui.chat;

class ChatRoster extends qx.ui.container.Scroll
{
    private var nicklist:qx.ui.container.Composite;
    private var nickmap:Hash<qx.ui.basic.Label>;

    public function new()
    {
        var layout = new qx.ui.layout.VBox();
        this.nicklist = new qx.ui.container.Composite(layout);
        this.nickmap = new Hash();

        super(this.nicklist);
    }

    public function add_member(ident:String, nick:String)
    {
        if (this.nickmap.exists(ident))
            return;

        var text = "<span style=\"color:#ffff00\">" + nick + "</span>";
        var label = new qx.ui.basic.Label(text);
        label.set({rich: true});
        this.nickmap.set(ident, label);
        this.nicklist.add(label);
    }

    public function remove_member(ident:String)
    {
        var label = this.nickmap.get(ident);
        if (label != null) {
            this.nicklist.remove(label);
            this.nickmap.remove(ident);
        }
    }
}
