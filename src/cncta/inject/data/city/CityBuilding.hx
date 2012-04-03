package cncta.inject.data.city;

@:native("ClientLib.Data.CityBuilding")
extern class CityBuilding
{
    public function get_Type():Int;
    public function get_ProductionModifierTypeDBId():Int;
    public function get_CurrentLevel():Int;
    public function get_CoordX():Int;
    public function get_CoordY():Int;
}
