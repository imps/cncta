package;

class JSArrayHelper
{
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
}
