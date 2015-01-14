#include "Scripts/shmup/weapons/Weapon.as"
#include "Scripts/shmup/projectiles/Projectile.as"

shared class WeaponTripleSin:Weapon{

  float fire_angle_;
  float fire_angle_spread_ = 30.0f;
  float timer_total_ = 0.0f;
  float fire_frequency_ = 2.0f*30.0f;

  WeaponTripleSin(){
    fire_velocity_ = 0.7f*30.0f;
    firing_interval_ = 0.025f;
    projectile_damage_mult = 0.1;
  }

  void fire(Vector3 target_position,float timestep = 0.0f){
    Array<Vector3> fire_direction = {Vector3(0.0f,0.0f,1.0f)};
    timer_total_ += timestep;

    Quaternion dir_rot = Quaternion();
    fire_angle_=(Cos(timer_total_*4500.0f)*fire_angle_spread_);
    dir_rot.FromAngleAxis(fire_angle_,Vector3(0.0f,1.0f,0.0f));
    fire_direction[0] = dir_rot * fire_direction[0];

    fire_logic(timestep,fire_direction);

  }

}
