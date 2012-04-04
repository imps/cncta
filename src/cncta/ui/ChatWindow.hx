package cncta.ui;

class ChatWindow extends cncta.inject.ui.CustomWindow
{
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

        this.add(new cncta.ui.chat.ChatInput());
    }
}
