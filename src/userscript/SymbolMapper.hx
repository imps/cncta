package userscript;

class SymbolMapper
{
    var symbols:Hash<String>;
    var current:Array<Int>;

    static var available_chars =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_";

    public function new()
    {
        this.symbols = new Hash();
        this.current = new Array();
    }

    /*
       Folding function which generates a String from a list of integers using
       SymbolMapper.available_chars.
     */
    private function mogrify(elem:Int, acc:String):String
    {
        return acc + SymbolMapper.available_chars.charAt(elem);
    }

    /*
       Increment integer value combinations of this.current.
       This is like most brute force password crackers which generate
       combinations like this:
          a b c d ... aa ab ac ad ... aaa aab aac aad ...
     */
    private function increment_chars(?pos:Int):Void
    {
        if (pos == null) {
            if ((pos = this.current.length - 1) < 0) {
                this.current.push(0);
                return;
            }
        }

        if (this.current[pos] >= SymbolMapper.available_chars.length - 1) {
            this.current[pos] = 0;
            if (pos > 0) {
                this.increment_chars(pos - 1);
            } else {
                this.current.insert(0, 0);
            }
        } else {
            this.current[pos]++;
        }
    }

    /*
       Create a new string value based on the previous one.
     */
    private function new_symbol(literal:String):String
    {
        this.increment_chars();
        var str = Lambda.fold(this.current, this.mogrify, "");
        this.symbols.set(literal, str);
        return str;
    }

    /*
       Get the symbol for the given literal or create a new one.
     */
    public function get_symbol(literal:String):String
    {
        var sym = this.symbols.get(literal);
        if (sym == null) {
            return this.new_symbol(literal);
        } else {
            return sym;
        }
    }
}
