#include "Scripts/shmup/pickups/Pickup.as"
#include "Scripts/shmup/weapons/WeaponTripleSin.as"

class PickupWeapon2:Pickup{

  PickupWeapon2(){
    pname="WeaponTripleSin";
  }

  void effect(Actor@ otherObject, VariantMap& eventData){
    Pickup::effect(otherObject,eventData);
  }
}
