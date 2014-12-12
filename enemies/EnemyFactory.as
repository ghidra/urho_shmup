#include "Scripts/shmup/enemies/Enemy.as"

class EnemyFactory:ScriptObject{
  //float timer_total_;
  float timer_;
  float spawn_timer_;
  float spawn_interval_ = 1.0f;
  int spawn_amount_=5;
  int spawn_increment_=0;
  int active_=0;
  float active_time_=-1.0f;

  String enemy_type_="Enemy";//they type of enemies that we are going to spawn
  String enemy_behavior_="Behavior";//the behavior that we are going to attach
  String enemy_weapon_="Weapon";
  float fire_rate_=1.0f;
  int mirror_behavior_=0;//if we want to mirror the behavior

  void Start(){
    //spawn_enemy("Character","Enemy",Vector3(5.0f,0.0f,5.0f));
    spawn_timer_ = spawn_interval_;//this just lets me spawn immediatly
  }

  void FixedUpdate(float timeStep){
    //timer_total_+=timeStep;
    timer_+=timeStep;
    if(timer_>=active_time_ && active_<1 && active_time_>=0.0f){
      active_=1;
    }
    if(active_>0){
      spawn_timer_+=timeStep;
      if(spawn_timer_>=spawn_interval_){
        if(spawn_increment_< spawn_amount_){
          spawn_enemy("Character","Enemy","Weapon","Behavior",fire_rate_,Vector3(5.0f,0.0f,5.0f));
          spawn_timer_=0;
          spawn_increment_+=1;
        }
        //do not delete the whole, thing. I need to wait until all the guys have left screen or died before i remove them
        //else{
        //  node.Remove();//justremove the factory now, we dont need it
        //}
      }
    }
  }

  void set_parameters(const String&in etype = "Enemy", const String&in eweapon="Weapon", const String&in ebehavior="Behavior", const float&in fire_rate=1.0f, const int mirror= 0,const float&in active_time=-1.0f){//set the enemy type, behavior, and when this factory is active
    enemy_type_ = etype;
    enemy_weapon_ = eweapon;
    enemy_behavior_ = ebehavior;
    fire_rate_ = fire_rate;
    mirror_behavior_ = mirror;
    active_time_ = active_time;
    timer_=0.0f;
  }

  void spawn_enemy(const String&in etype, const String&in ctype,const String&in wtype,const String&in btype, const float&in fire_rate, const Vector3&in pos, const Quaternion&in ori = Quaternion()){
    //enemy type, class type, weapon type, behavior type, position, orientation

    Node@ main_node_ = node.CreateChild("Enemy");

    StaticModel@ object_ = main_node_.CreateComponent("StaticModel");
    object_.model = cache.GetResource("Model", "Models/Sphere.mdl");
    object_.material = cache.GetResource("Material", "Materials/Stone.xml");

    RigidBody@ body_ = main_node_.CreateComponent("RigidBody");
    body_.mass = 0.25f;
    body_.friction = 0.75f;
    body_.linearDamping = 0.6f;
    body_.linearFactor = Vector3(1.0f,0.0f,1.0f);
    body_.useGravity = false;
    body_.collisionLayer=16;
    body_.collisionMask=51;
    CollisionShape@ shape = main_node_.CreateComponent("CollisionShape");
    shape.SetBox(Vector3(1.0f, 1.0f, 1.0f));

    //XMLFile@ xml = cache.GetResource("XMLFile", "Scripts/shmup/nodes/" + ntype + ".xml");
    //Node@ enemy_ = scene.InstantiateXML(xml, pos, ori);
    //Node@ enemy_ = node.LoadXML(xml);

    //i need to set the collision mast to 2 for enmies
    //RigidBody@ rb_ = enemy_.GetComponent("RigidBody");
    //rb_.collisionMask=2;

    Enemy@ node_script_ = cast<Enemy>(main_node_.CreateScriptObject(scriptFile, ctype, LOCAL));
    node_script_.set_parameters(wtype,btype,fire_rate);//send it the weapon and the behavior

  }
}
