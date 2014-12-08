#include "Scripts/shmup/pickups/Pickup.as"
#include "Scripts/shmup/weapons/WeaponTripleSide.as"

class PickupWeapon2:Pickup{

  PickupWeapon2(){
    pname="WeaponTripleSide";
  }

  void effect(Actor@ otherObject, VariantMap& eventData){
    Pickup::effect(otherObject,eventData);
  }
}
