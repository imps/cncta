package;

class JSArrayHelper
{
    public static dynamic function remove<T>(a:Array<T>, x:T):Bool { return false; }

    public static function gen_iter<T>(a:Array<T>)
    {
        untyped {
            return {
                cur : 0,
                arr : a,
                hasNext : function() {
                    return __this__.cur < __this__.arr.length;
                },
                next : function() {
                    return __this__.arr[__this__.cur++];
                }
            }
        }
    }

    public static function __init__()
    {
        JSArrayHelper.remove = if(untyped Array.prototype.indexOf)
            untyped function(a, x) {
                var idx = a.indexOf(x);
                if(idx == -1) return false;
                a.splice(idx, 1);
                return true;
            }
        else untyped function(a, x) {
            var i = 0;
            var l = a.length;
            while (i < l) {
                if (a[i] == x) {
                    a.splice(i, 1);
                    return true;
                }
                i++;
            }
            return false;
        };
    }
}
