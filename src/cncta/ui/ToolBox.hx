package cncta.ui;

class ToolBox extends qx.ui.container.Composite
{
    private var buttons:qx.ui.container.Composite;

    public function new()
    {
        super(new qx.ui.layout.Canvas());

        this.buttons = new qx.ui.container.Composite(new qx.ui.layout.VBox(2));
        this.add(this.buttons, {right: 0, top: 0});
    }

    public function add_window_button(label:String, tooltip:String,
                                      window:qx.ui.window.Window)
    {
        var listener = function() {
            if (window.isVisible())
                window.close();
            else
                window.open();
        };
        this.add_button(label, tooltip, listener);
    }

    private function add_button(label:String, tooltip:String,
                                listener:Void -> Void)
    {
        var icon = "FractionUI/icons/cht_opt_maximize.gif";

        var button = new qx.ui.form.Button(label, icon);
        button.set({height: 24, toolTipText: tooltip, center: false});
        button.addListener("execute", listener);

        this.buttons.add(cast button);
    }
}
