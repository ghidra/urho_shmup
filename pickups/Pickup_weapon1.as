#include "Scripts/shmup/pickups/Pickup.as"
#include "Scripts/shmup/weapons/Weapon_noisy.as"

shared class Pickup_weapon1:Pickup{
  void effect(Actor@ otherObject, VariantMap& eventData){
    Node@ n = otherObject.get_node();
    //StaticModel@ = smn.children[0].GetScriptObject("Weapon");
    Node@ weapon = n.children[0];
    StaticModel@ sm = weapon.GetComponent("StaticModel");
    sm.model = cache.GetResource("Model", "Models/Cone.mdl");
    ScriptInstance@ so = weapon.GetComponent("ScriptInstance");
    //n.RemoveComponent(so);
    so.Remove();

    weapon.CreateScriptObject(scriptFile, "Weapon_noisy");
    //so.CreateObject(scriptFile,"Weapon_noisy");
    //so.className="Weapon_noisy";
  }
}
