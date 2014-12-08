#include "Scripts/shmup/core/Character.as"
#include "Scripts/shmup/gui/ProgressBar.as"

/*class EnemyBasic{

  Node@ node_;

  EnemyBasic(Scene@ scene){

    node_ = scene.CreateChild("Character");

    StaticModel@ coneObject = node_.CreateComponent("StaticModel");
    coneObject.model = cache.GetResource("Model", "Models/Cone.mdl");
    coneObject.material = cache.GetResource("Material", "Materials/StoneTiled.xml");
    //---------------------------

    RigidBody@ body_ = node_.CreateComponent("RigidBody");
    body_.mass = 0.25f;
    body_.friction = 0.75f;
    body_.linearDamping = 0.6f;
    body_.useGravity = false;
    CollisionShape@ shape = node_.CreateComponent("CollisionShape");
    shape.SetBox(Vector3(1.0f, 1.0f, 1.0f));

    EnemyBasic_Script@ enemybasic_script_ = cast<EnemyBasic_Script>(node_.CreateScriptObject(scriptFile, "EnemyBasic_Script"));
  }

  //-------from old pawn
  void set_enemytarget(Node@ target){
    Pawn_Script@ pawn_ = cast<Pawn_Script>(node_.scriptObject);
    pawn_.set_enemytarget(target);
  }

  void set_position(Vector3 pos){
    node_.position = pos;
  }
  //----------------------

}*/

class Enemy:Character{
  //ProgressBar@ bar_;
  Node@ target_;//this will likely be the main character that I am firing at
  //float bar_regen_ = 0.001f;

  void Start(){
    //bar_ = ProgressBar(node.scene,node,"cooldown",Vector3(0.0f,1.2f,0.0f));//use defaults
  }

  void FixedUpdate(float timeStep){
    if(target_!=null){
      fire(target_.position,timeStep);
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
