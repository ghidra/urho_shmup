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
    collision_layer_=16;
    collision_mask_=51;
  }
  //this is called from the enemy factory as soon as it is made, here we need to put it all together
  void set_parameters(const String&in etype,const String&in ctype,const String&in wtype,const String&in btype, const float&in fire_rate){//this all comes in from the enemy factory
    //etype, ctype, wtype, btype, firerate (enemy type, class type, weapon type, behavior type, fire rate)
    build_geo(mesh_,material_);
    build_weapon(wtype);
    set_behavior(btype);

    //Weapon@ weapon = cast<Weapon>(node.children[0].scriptObject);
    Weapon@ weapon = cast<Weapon>(node.GetChild("Weapon").scriptObject);
    weapon.set_firerate(fire_rate);
    weapon.set_enemy();

  }
  //--------------------
  //--------------------

  void FixedUpdate(float timeStep){

	  Pawn::FixedUpdate(timeStep);

    if(target_ !is null){
      fire(target_.position,timeStep);
    }
    if(behavior_ !is null){//if we have a behavior object, we should turn over control to it
      behavior_.update(timeStep);
    }
    //RigidBody@ rb_ = node.GetComponent("RigidBody");
    //Print(rb_.collisionMask);
    /*if(bar_.value_ >= 1.0f){//we can fire a shots, then set it to zero
        bar_.set_value();
        fire();
    }
    bar_.set_value(bar_.value_+bar_regen_);*/
  }
  void set_target(Node@ t){
    target_=t;
  }
  //----------------
  void set_behavior(const String&in btype="Behavior"){
    if(btype=="Behavior"){
      behavior_ = Behavior(node);
    }

  }


}
