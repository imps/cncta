package cncta.inject.data;

extern class Alliance
{
    public function get_Name():String;
    public function get_Abbreviation():String;
    public function get_MemberDataAsArray():Array<AllianceMember>;
}
