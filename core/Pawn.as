#include "Scripts/shmup/core/Actor.as"
#include "Scripts/shmup/weapons/Weapon.as"

shared class Pawn:Actor{

  //Node@ enemytarget_;
  Weapon@ weapon_;
  String weapon_type_ = "Weapon";
  int firing_ = 0;
  float firing_timer_ = 0.0f;//when the firing began, so I can use a timer for interval
  float firing_interval_ = 0.2f;//how often we can fire

  //setters
  void set_position(Vector3 pos){
    node.position = pos;
  }

  //void set_enemytarget(Node@ target){
  //  enemytarget_ = target;
  //}
  //void set_weapon(Weapon@ weapon){
  //  weapon_ = weapon;
  //}

  //-----

  void move(Vector3 direction, float timestep){
    RigidBody@ body_ = node.GetComponent("RigidBody");
    body_.linearVelocity = body_.linearVelocity+(direction*speed_*timestep);
    //Print("try from pawn");
  }
  //this is called from the inputPLayer class
  void fire(Vector3 target_position,float timestep = 0.0f){
    //lets check that we have a weapon class
    //Weapon@ weapon = cast<Weapon>(node.children[0].GetScriptObject(weapon_type_));
    Weapon@ weapon = cast<Weapon>(node.children[0].scriptObject);
    if(weapon !is null){//if we have a weapon, we can fire that bitch
      weapon.fire(target_position,timestep);
    }
  }
  void release_fire(){
    //Weapon@ weapon = cast<Weapon>(node.children[0].GetScriptObject(weapon_type_));
    Weapon@ weapon = cast<Weapon>(node.children[0].scriptObject);
    if(weapon !is null){//if we have a weapon, we can fire that bitch
      weapon.release_fire();
    }
  }

}
