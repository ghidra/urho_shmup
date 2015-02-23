#include "Scripts/core/Pawn.as"
#include "Scripts/enemies/Behavior.as"

#include "Scripts/gui/ProgressBar.as"

class Enemy:Pawn{
  //ProgressBar@ bar_;
  Node@ target_;//this will likely be the main character that I am firing at
  Behavior@ behavior_;//the behavior object
  Node@ healthbar_;

  //float bar_regen_ = 0.001f;
  Enemy(){
  //void Start(){
    side_=SIDE_ENEMY;
    speed_=0.1f;
    collision_layer_=16;
    collision_mask_=51;
    mesh_="spaceship_02_shiponly";
    health_=10;
    maxHealth_=10;
  }
  void Start(){
    SubscribeToEvent(node, "NodeCollision", "HandleNodeCollision");
  }

  //this is called from the enemy factory as soon as it is made, here we need to put it all together
  void set_parameters(String etype,String ctype,String wtype,String btype, float fire_rate){//this all comes in from the enemy factory
    //etype, ctype, wtype, btype, firerate (enemy type, class type, weapon type, behavior type, fire rate)
    build_geo(mesh_,material_,0.2f);
    //build_weapon(wtype);
    set_behavior(btype);

    WeaponBank@ wb = get_weaponbank();
    wb.set_weapon(0,"Weapon",fire_rate,1);

    //Weapon@ weapon = cast<Weapon>(node.children[0].scriptObject);
    //Weapon@ weapon = cast<Weapon>(node.GetChild("Weapon").scriptObject);
    //weapon.set_firerate(fire_rate);
    //weapon.set_enemy();
    healthbar_ = node.CreateChild("healthbar");
    ProgressBar@ bar = cast<ProgressBar>(healthbar_.CreateScriptObject(scriptFile, "ProgressBar"));
    bar.set_parameters();
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
  //-----
  void ObjectCollision(Actor@ otherObject, VariantMap& eventData){
    //Print("HIT");
    //RigidBody@ body = node.GetComponent("RigidBody");
    //spawn_explosion(node.position,body.linearVelocity);
    //node.Remove();
    Damage(otherObject,1);
    //Print(health_);
  }


}
