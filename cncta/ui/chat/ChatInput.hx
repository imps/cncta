package cncta.ui.chat;

class ChatInput extends qx.ui.container.Composite
{
    private var chatline:qx.ui.form.TextField;
    private var sendbutton:qx.ui.form.Button;

    private var history:Array<String>;
    private var history_index:Int;
    private var original_value:String;

    public function new()
    {
        super(new qx.ui.layout.HBox());

        this.history = new Array();
        this.history_index = null;

        this.chatline = new qx.ui.form.TextField();
        this.chatline.set({
            appearance: "chat-textfield",
            allowGrowX: true,
        });

        this.chatline.addListener("keypress", this.on_chatinput);

        this.sendbutton = new qx.ui.form.Button("Send");
        this.sendbutton.set({
            appearance: "button-friendlist-scroll",
        });

        this.sendbutton.addListener("execute", this.on_submit);

        this.add(this.chatline, {flex: 1});
        this.add(this.sendbutton);
    }

    public function set_focus()
    {
        this.chatline.focus();
    }

    private function history_up()
    {
        if (this.history_index == null) {
            this.original_value = this.chatline.getValue();
            this.history_index = this.history.length;
        } else if (this.history_index <= 0) {
            return;
        }

        this.history_index--;

        this.push_history();
    }

    private function history_down()
    {
        if (this.history_index == null)
            return;

        if (this.history_index >= this.history.length - 1) {
            this.history_index = null;
        } else {
            this.history_index++;
        }

        this.push_history();
    }

    private function push_history()
    {
        var value:String;
        if (this.history_index == null) {
            value = this.original_value;
        } else {
            value = this.history[history_index];
        }

        this.chatline.setValue(value);
    }

    private function append_history(line:String)
    {
        this.history.push(line);
        this.history_index = null;
    }

    private function on_chatinput(e:Dynamic)
    {
        switch (e.getKeyIdentifier()) {
            case "Enter": this.on_submit();
            case "Up": history_up(); e.stop();
            case "Down": history_down(); e.stop();
            default:
        }
    }

    private function on_submit()
    {
        var line = this.chatline.getValue();
        this.chatline.setValue("");

        if (line == null || line.length == 0)
            return;

        this.append_history(line);
        this.on_send(line);
    }

    public dynamic function on_send(input:String):Void {}
}
