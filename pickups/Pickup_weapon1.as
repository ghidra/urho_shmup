#include "Scripts/shmup/pickups/Pickup.as"
class Pickup_weapon1:Pickup{
  void effect(Actor@ otherObject, VariantMap& eventData){
    Node@ n = otherObject.get_node();
    //StaticModel@ = smn.children[0].GetScriptObject("Weapon");
    StaticModel@ sm = n.children[0].GetComponent("StaticModel");
    sm.model = cache.GetResource("Model", "Models/Cone.mdl");
  }
}
