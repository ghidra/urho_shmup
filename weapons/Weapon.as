#include "Scripts/shmup/Actor.as"
#include "Scripts/shmup/Projectile.as"

shared class Weapon:Actor{
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
  }

  void spawn_projectile(Vector3 dir, Vector3 hit = Vector3(0.0f,0.0f,0.0f)){
    const float OBJECT_VELOCITY = 50.0f;
    Projectile@ projectile_ = Projectile(node.scene,node.worldPosition,dir,OBJECT_VELOCITY,hit);
  }

}
