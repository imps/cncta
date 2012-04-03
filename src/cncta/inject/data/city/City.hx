package cncta.inject.data.city;

@:native("ClientLib.Data.City")
extern class City
{
    public function get_CityBuildingsData():CityBuildings;
    public function GetResourceType(x:Int, y:Int):Int;
}
