package cncta.ui;

class BaseBuilder extends cncta.inject.ui.CustomWindow
{
    private var url_widget:cncta.inject.qx.Label;

    public override function new()
    {
        super("Base Builder");
        this.set({
            allowMaximize: false,
            allowMinimize: false,
            showMaximize: false,
            showMinimize: false,
            showStatusbar: false,
            movable: true,
            alwaysOnTop: true,
            showClose: true,
        });

        untyped __js__("this.setLayout(new qx.ui.layout.VBox())");

        this.url_widget = new cncta.inject.qx.Label();
        this.url_widget.setDecorator("pane-comment");
        this.url_widget.set({
            selectable: true,
            rich: true,
        });

        this.add(url_widget, {
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
        });

        this.addListener("appear", this.on_appear);
    }

    private function set_bbid(id:String)
    {
        var url = "http://cncbasebuilder.appspot.com/";
        url += "#" + id;

        var link = "<a href=\"#\" onClick=\"webfrontend.";
        link += "gui.Util.openLinkFromInnerHtml(this);\">";
        link += url;
        link += "</a>";

        this.url_widget.setValue(link);
    }

    private function calculate_bbid():String
    {
        return "todo";
    }

    private function on_appear()
    {
        this.set_bbid(this.calculate_bbid());
        this.bringToFront();
    }
}
