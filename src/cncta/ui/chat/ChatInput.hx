package cncta.ui.chat;

class ChatInput extends qx.ui.container.Composite
{
    private var chatline:qx.ui.form.TextField;
    private var sendbutton:qx.ui.form.Button;

    public function new()
    {
        super(new qx.ui.layout.HBox());

        this.chatline = new qx.ui.form.TextField();
        this.chatline.set({
            appearance: "chat-textfield",
        });

        this.chatline.addListener("keypress", this.on_chatinput);

        this.sendbutton = new qx.ui.form.Button("Send");
        this.sendbutton.set({
            appearance: "button-friendlist-scroll",
        });

        this.sendbutton.addListener("execute", this.on_submit);

        this.add(this.chatline);
        this.add(this.sendbutton);
    }

    private function on_chatinput(e:Dynamic)
    {
        if (e.getKeyIdentifier() == "Enter") {
            this.on_submit();
        }
    }

    private function on_submit()
    {
        var line = this.chatline.getValue();
        this.chatline.setValue("");

        if (line == null || line.length == 0)
            return;

        this.on_send(line);
    }

    public dynamic function on_send(input:String):Void {}
}
