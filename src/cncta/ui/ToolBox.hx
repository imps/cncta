package cncta.ui;

class ToolBox extends qx.ui.container.Composite
{
    private var buttons:qx.ui.container.Composite;

    public function new()
    {
        super(new qx.ui.layout.Canvas());

        this.buttons = new qx.ui.container.Composite(new qx.ui.layout.HBox(2));
        this.attach_buttons();
        this.add(this.buttons, {right: 0, top: 0});
    }

    private inline function attach_buttons()
    {
        this.add_window_button(
            "Base Builder",
            "Get BaseBuilder URL",
            new BaseBuilder()
        );
    }

    private function add_window_button(label:String, tooltip:String,
                                       window:qx.ui.window.Window)
    {
        var listener = function() { window.show(); };
        this.add_button(label, tooltip, listener);
    }

    private function add_button(label:String, tooltip:String,
                                listener:Void -> Void)
    {
        var icon = "FractionUI/icons/cht_opt_maximize.gif";

        var button = new qx.ui.form.Button(label, icon);
        button.set({height: 24, toolTipText: tooltip});
        button.addListener("execute", listener);

        this.buttons.add(cast button);
    }
}
