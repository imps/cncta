package;

class MonkeyTest extends haxe.unit.TestCase
{
    public function test_array_normal()
    {
        var a:Array<Int> = [1, 2, 3];

        this.assertEquals(3, a.length);
        this.assertEquals(2, a[1]);
        this.assertEquals(3, a[2]);

        a.insert(2, 666);

        this.assertEquals(4, a.length);
        this.assertEquals(666, a[2]);

        a.remove(3);

        this.assertEquals(3, a.length);

        a.insert(666, 5);

        this.assertEquals(4, a.length);

        this.assertEquals(1, a[0]);
        this.assertEquals(2, a[1]);
        this.assertEquals(666, a[2]);
        this.assertEquals(5, a[3]);
        this.assertEquals(null, a[4]);

        var sa = a.splice(1,1);
        this.assertEquals(1, sa.length);
        this.assertEquals(2, sa[0]);
        this.assertEquals(null, sa[1]);
    }

    public function test_array_iter()
    {
        var a:Array<Int> = [1, 2, 3];

        var iter = a.iterator();

        for (i in [1, 2, 3]) {
            var cur = iter.next();
            this.assertEquals(i, cur);
        }

        this.assertEquals(null, iter.next());
    }

    public function test_array_lambda()
    {
        var a:Array<Int> = [1, 2, 3];

        this.assertEquals(3, Lambda.count(a));

        var nl = Lambda.map(a, function(x) return x + 1);
        var na = Lambda.array(nl);

        this.assertEquals(2, na[0]);
        this.assertEquals(3, na[1]);
        this.assertEquals(4, na[2]);
    }
}

class Test
{
    public static function main()
    {
        var runner = new haxe.unit.TestRunner();
        runner.add(new MonkeyTest());
        runner.run();
    }
}
