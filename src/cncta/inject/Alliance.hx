package cncta.inject;

extern class Member
{
    public var Id:Int;
    public var JoinStep:Int;
}

extern class Alliance
{
    public function get_Name():String;
    public function get_Abbreviation():String;
    public function get_MemberDataAsArray():Array<Member>;
}
