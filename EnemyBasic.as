#include "Scripts/shmup/Pawn.as"
#include "Scripts/shmup/ProgressBar.as"

class EnemyBasic{

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
    Pawn@ pawn_ = cast<Pawn>(node_.scriptObject);
    pawn_.set_enemytarget(target);
  }

  void set_position(Vector3 pos){
    node_.position = pos;
  }
  //----------------------

}

class EnemyBasic_Script:Pawn{
  ProgressBar@ bar_;
  float bar_regen_ = 0.001f;

  void Start(){
    bar_ = ProgressBar(node.scene,node,"cooldown",Vector3(0.0f,1.2f,0.0f));//use defaults
  }

  void Update(float timeStep){
    if(bar_.value_ >= 1.0f){//we can fire a shots, then set it to zero
        bar_.set_value();
        fire_projectile();
    }
    bar_.set_value(bar_.value_+bar_regen_);
  }

  void fire_projectile(){
    if(enemytarget_ !is null){
      //figure out how to shoot toward the dude
      Vector3 fire_from = node.position+Vector3(0.0f,0.5f,0.0f);
      Vector3 fire_on = enemytarget_.position;
      Vector3 dir = fire_on-fire_from;

      spawn_projectile(dir);
    }
  }
  void spawn_projectile(Vector3 dir, Vector3 hit = Vector3(0.0f,0.0f,0.0f)){
    Vector3 pos = node.position+(dir.Normalized()*1.4f);
    const float OBJECT_VELOCITY = 1.5f;
    //Projectile@ projectile_ = Projectile(node.scene,pos,dir,OBJECT_VELOCITY,hit);
    //ProjectileExploder@ projectile_ = ProjectileExploder(node.scene,node.position,dir,OBJECT_VELOCITY,hit);
    ProjectileNoisy@ projectile_ = ProjectileNoisy(node.scene,node.position,dir,OBJECT_VELOCITY,hit);
  }

}
