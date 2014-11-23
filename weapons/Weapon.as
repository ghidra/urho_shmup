#include "Scripts/shmup/Actor.as"
#include "Scripts/shmup/Projectile.as"
class Weapon{
  Node@ node_;
  Weapon_Script@ weapon_script_;

  Weapon(Scene@ scene){
    node_ = scene.CreateChild("Weapon");
    weapon_script_ = cast<Weapon_Script>(node_.CreateScriptObject(scriptFile, "Weapon_Script"));
  }
  void attach_script(Node@ node){
    Weapon_Script@ node_script_ = cast<Weapon_Script>(node.CreateScriptObject(scriptFile, "Weapon_Script"));
    //node_script_.set_hit(hit);
  }

}

class Weapon_Script:Actor{
  int firing_ = 0;
  float firing_timer_ = 0.0f;//when the firing began, so I can use a timer for interval
  float firing_interval_ = 0.2f;//how often we can fire

  void fire(Vector3 target_position,float timestep = 0.0f){
    if(firing_<1){//start firing
      firing_=1;
      firing_timer_ = timestep;

      spawn_projectile(Vector3(0,0,1),target_position);
    }else{//we are firing, we need to shot intermittenly
      firing_timer_+=timestep;
      if(firing_timer_> firing_interval_){//we can shoot again if we are past our interval time
        firing_timer_=0;
        spawn_projectile(Vector3(0,0,1),target_position);
      }
    }

  }
  void release_fire(){
    firing_=0;
    //firing_timer_=0.0f;
  }

  void spawn_projectile(Vector3 dir, Vector3 hit = Vector3(0.0f,0.0f,0.0f)){
    const float OBJECT_VELOCITY = 4.5f;
    Projectile@ projectile_ = Projectile(node.scene,node.position,dir,OBJECT_VELOCITY,hit);
  }

}
