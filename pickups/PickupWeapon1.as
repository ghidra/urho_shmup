#include "Scripts/shmup/pickups/Pickup.as"
#include "Scripts/shmup/weapons/WeaponNoisy.as"

class PickupWeapon1:Pickup{

  PickupWeapon1(){
    pname="WeaponNoisy";
  }

  void effect(Actor@ otherObject, VariantMap& eventData){
    Pickup::effect(otherObject,eventData);
  }
}
