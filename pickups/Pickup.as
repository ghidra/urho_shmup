#include "Scripts/shmup/core/Actor.as"
class Pickup:Actor{

  String ptype = "Weapon";//pickup type (weapon experience etc)
  String pmesh = "Cone";
  String pname = "Weapon";//the pick up class name

  void Start(){
      SubscribeToEvent(node, "NodeCollision", "HandleNodeCollision");
  }

  void ObjectCollision(Actor@ otherObject, VariantMap& eventData){
    effect(otherObject,eventData);
    node.Remove();
  }

  void effect(Actor@ otherObject, VariantMap& eventData){
    //specifically for weapon pick ups
    //this changes the mesh and the script object
    if(ptype=="Weapon"){
      Node@ n = otherObject.get_node();
      Node@ weapon = n.children[0];

      StaticModel@ sm = weapon.GetComponent("StaticModel");
      sm.model = cache.GetResource("Model", "Models/"+pmesh+".mdl");//replace the weapon mesh

      ScriptInstance@ si = weapon.GetComponent("ScriptInstance");
      si.CreateObject(scriptFile,pname);

      //ScriptInstance@ nsi = weapon.CreateComponent("ScriptInstance");
      //ScriptFile@ sf = cache.GetResource("ScriptFile", "Scripts/shmup/weapons/WeaponNoisy.as");
      //si.CreateObject(sf,"WeaponNoisy");
      //si.className="WeaponNoisy";
    }
  }


}
