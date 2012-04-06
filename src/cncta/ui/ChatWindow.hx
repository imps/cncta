package cncta.ui;

class ChatWindow extends cncta.inject.ui.CustomWindow
{
    private var view:cncta.ui.chat.ChatView;
    private var input:cncta.ui.chat.ChatInput;

    public function new()
    {
        super("Chat");

        this.setLayout(new qx.ui.layout.VBox());

        this.set({
            allowMaximize: true,
            allowMinimize: false,
            showMaximize: true,
            showMinimize: false,
            showStatusbar: false,
            resizable: true,
            movable: true,
            alwaysOnTop: false,
            showClose: true,
        });

        this.view = new cncta.ui.chat.ChatView();
        this.input = new cncta.ui.chat.ChatInput();

        this.add(this.view);
        this.add(this.input);

        this.input.on_send = function(text) {
            this.add_message("foo", text);
        };
    }

    public inline function add_message(nick:String, text:String)
    {
        this.view.add_message(nick, text);
    }
}
