#include "Scripts/shmup/core/Actor.as"
class Pickup:Actor{

  String ptype = "Weapon";
  String pname = "Weapon";

  void Start(){
      SubscribeToEvent(node, "NodeCollision", "HandleNodeCollision");
  }

  void ObjectCollision(Actor@ otherObject, VariantMap& eventData){
    //Print("collided with pickup");
    //RigidBody@ body = node.GetComponent("RigidBody");
    //spawn_explosion(node.position,body.linearVelocity);
    effect(otherObject,eventData);
    node.Remove();
  }

  void effect(Actor@ otherObject, VariantMap& eventData){
    //specifically for weapon pick ups
    if(ptype=="Weapon"){
      Node@ n = otherObject.get_node();
      Node@ weapon = n.children[0];

      StaticModel@ sm = weapon.GetComponent("StaticModel");
      sm.model = cache.GetResource("Model", "Models/Cone.mdl");

      ScriptInstance@ si = weapon.GetComponent("ScriptInstance");

      //ScriptInstance@ nsi = weapon.CreateComponent("ScriptInstance");
      //ScriptFile@ sf = cache.GetResource("ScriptFile", "Scripts/shmup/weapons/WeaponNoisy.as");

      si.CreateObject(scriptFile,pname);
      //si.CreateObject(sf,"WeaponNoisy");
      //si.className="WeaponNoisy";
    }
  }


}
