package cncta.ui;

class ColorLabel extends qx.ui.basic.Label
{
    public function new(color:String, ?text:String)
    {
        super(text);
        this.set({textColor: color});
    }
}
