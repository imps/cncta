package cncta.inject.data;

import cncta.inject.data.city.City;

@:native("ClientLib.Data.Cities")
extern class Cities
{
    public function get_CurrentCity():City;
}
