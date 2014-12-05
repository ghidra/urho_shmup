#include "Scripts/shmup/weapons/Weapon.as"
#include "Scripts/shmup/projectiles/ProjectileNoisy.as"

shared class WeaponNoisy:Weapon{

  WeaponNoisy(){
    ctype_ = "ProjectileNoisy";
    fire_velocity_ = 5.0f;
    firing_interval_ = 0.2f;
    projectile_damage_mult = 5.0f;
  }

  /*void fire(Vector3 target_position,float timestep = 0.0f){
    if(firing_<1){//start firing
      firing_=1;
      firing_timer_ = timestep;

      //spawn_projectile(Vector3(0,0,1),target_position);
      spawn_projectile(Vector3(0,0,1),target_position);
    }else{//we are firing, we need to shot intermittenly
      firing_timer_+=timestep;
      if(firing_timer_> firing_interval_){//we can shoot again if we are past our interval time
        firing_timer_=0;
        spawn_projectile(Vector3(0,0,1),target_position);
      }
    }

  }*/

}
