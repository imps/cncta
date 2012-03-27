package userscript.macro;

class PackageNode
{
    public var name:String;
    public var parent:PackageNode;
    public var children:List<PackageNode>;

    public function new()
    {
        this.name = null;
        this.parent = null;
        this.children = new List();
    }

    /*
       Add a new child to the current node, and return the new node instance.
       If the child already exists, do nothing and return the existing node.
     */
    public function add(name:String):PackageNode
    {
        for (child in this.children) {
            // don't create node if it is already there
            if (child.name == name) {
                return child;
            }
        }

        var node = new PackageNode();
        node.name = name;
        node.parent = this;
        this.children.add(node);
        return node;
    }

    /*
       Return the current node path up to and including the root node.
     */
    public function get_full_path():String
    {
        if (this.parent == null || this.parent.name == null) {
            return this.name;
        } else {
            return this.parent.get_full_path() + "." + this.name;
        }
    }

    public function all_children():Array<PackageNode>
    {
        var subnodes = new Array();

        if (this.name != null) {
            subnodes.push(this);
        }

        for (child in this.children) {
            subnodes = subnodes.concat(child.all_children());
        }

        return subnodes;
    }
}

class Packages
{
    private var root:PackageNode;

    public function new()
    {
        this.root = new PackageNode();
    }

    public function add_path(path:Array<String>):Void
    {
        var current_node = this.root;

        for (elem in path) {
            current_node = current_node.add(elem);
        }
    }

    public function toString():String
    {
        return Lambda.map(
            this.root.all_children(),
            function(c) return c.get_full_path()
        ).join("\n");
    }
}
