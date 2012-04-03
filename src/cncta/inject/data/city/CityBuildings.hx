package cncta.inject.data.city;

// we want to avoid implementing an extern for
// System.Collections.Generic.List at the moment
extern class BuildingsListDummy
{
    public var l:Array<CityBuilding>;
}

@:native("ClientLib.Data.CityBuildings")
extern class CityBuildings
{
    public var m_Buildings:BuildingsListDummy;
}
