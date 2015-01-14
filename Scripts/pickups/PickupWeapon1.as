#include "Scripts/shmup/pickups/Pickup.as"
#include "Scripts/shmup/weapons/WeaponDoubleSin.as"

class PickupWeapon1:Pickup{

  PickupWeapon1(){
    pname="WeaponDoubleSin";
  }

  void effect(Actor@ otherObject, VariantMap& eventData){
    Pickup::effect(otherObject,eventData);
  }
}
