#include "Scripts/shmup/core/Pawn.as"
#include "Scripts/shmup/enemies/Behavior.as"

#include "Scripts/shmup/gui/ProgressBar.as"

class Enemy:Pawn{
  //ProgressBar@ bar_;
  Node@ target_;//this will likely be the main character that I am firing at
  Behavior@ behavior_;//the behavior object

  //float bar_regen_ = 0.001f;
  Enemy(){
    speed_=8.0f;
  }

  void Start(){
    //bar_ = ProgressBar(node.scene,node,"cooldown",Vector3(0.0f,1.2f,0.0f));//use defaults
  }

  void FixedUpdate(float timeStep){
    if(target_ !is null){
      fire(target_.position,timeStep);
    }
    if(behavior_ !is null){//if we have a behavior object, we should turn over control to it
      behavior_.update();
    }
    //RigidBody@ rb_ = node.GetComponent("RigidBody");
    //Print(rb_.collisionMask);
    /*if(bar_.value_ >= 1.0f){//we can fire a shots, then set it to zero
        bar_.set_value();
        fire();
    }
    bar_.set_value(bar_.value_+bar_regen_);*/
  }
  void set_parameters(const String&in wtype,const String&in btype, const float&in fire_rate){//this all comes in from the enemy factory
    set_weapon(wtype);
    set_behavior(btype);
  }
  void set_target(Node@ t){
    target_=t;
  }
  //----------------
  void set_weapon(const String&in wtype="Weapon"){
    if(wtype=="Weapon"){
      //weapon_ = Weapon();
    }
  }
  void set_behavior(const String&in btype="Behavior"){
    if(btype=="Behavior"){
      behavior_ = Behavior(node);
    }

  }

  /*void fire(){
    if(target_ !is null){
      //figure out how to shoot toward the dude
      Vector3 fire_from = node.position+Vector3(0.0f,0.5f,0.0f);
      Vector3 fire_on = enemytarget_.position;
      Vector3 dir = fire_on-fire_from;

      spawn_projectile(dir);
    }
  }*/

}
