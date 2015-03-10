#include "Scripts/enemies/Enemy.as"

class EnemyFactory:ScriptObject{
  //float timer_total_;
  float timer_;
  float spawn_timer_;
  float spawn_interval_;
  int spawn_amount_;
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
          spawn_enemy("Enemy","Weapon","Behavior",fire_rate_,Vector3(5.0f,0.0f,5.0f));
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

  void set_parameters(int samount=5, float sinterval = 1.0f, String etype = "Enemy", String eweapon="Weapon", String ebehavior="Behavior", float fire_rate=1.0f, int mirror= 0,float active_time=-1.0f){//set the enemy type, behavior, and when this factory is active
    spawn_amount_ = samount;
    spawn_interval_ = sinterval;
    enemy_type_ = etype;
    enemy_weapon_ = eweapon;
    enemy_behavior_ = ebehavior;
    fire_rate_ = fire_rate;
    mirror_behavior_ = mirror;
    active_time_ = active_time;
    timer_=0.0f;
  }

  void spawn_enemy(String& etype,String& wtype,String& btype, float& fire_rate, Vector3& pos, Quaternion& ori = Quaternion()){
    //enemy type, class type, weapon type, behavior type, position, orientation
    //Print("Spawn enemy");
    Node@ enemy_node_ = node.CreateChild("Enemy");
    Enemy@ node_script_ = cast<Enemy>(enemy_node_.CreateScriptObject(scriptFile, etype, LOCAL));
    node_script_.set_parameters(wtype,btype,fire_rate);//send it the weapon and the behavior

  }
}
