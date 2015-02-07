#include "Scripts/weapons/Weapon.as"
#include "Scripts/projectiles/Projectile.as"

shared class WeaponTripleSide:Weapon{

  float fire_angle_;
  float fire_angle_spread_ = 30.0f;
  float timer_total_ = 0.0f;
  float fire_frequency_ = 2.0f*30.0f;

  WeaponTripleSide(){
    fire_velocity_ = 0.7f*30.0f;
    firing_interval_ = 0.025f;
    projectile_damage_mult = 0.1;
    //aprojectile_offset_ = Array<Vector3>(Vector3(0.5f,0.0f,0.5f), Vector3(-0.5f,0.0f,0.5f), Vector3(0.0f,0.0f,0.5f));
    aprojectile_offset_[0] = Vector3(0.5f,0.0f,0.5f);
    aprojectile_offset_[1] = Vector3(-0.5f,0.0f,0.5f);
    aprojectile_offset_[2] = Vector3(0.0f,0.0f,0.5f);
  }

  void fire(Vector3 target_position,float timestep = 0.0f){
    Vector3 fire_directionA = Vector3(0.0f,0.0f,1.0f);
    Vector3 fire_directionB = Vector3(0.0f,0.0f,1.0f);
    Vector3 fire_directionC = Vector3(0.0f,0.0f,1.0f);

    timer_total_ += timestep;
    Quaternion dir_rotA = Quaternion();
    Quaternion dir_rotB = Quaternion();
    Quaternion dir_rotC = Quaternion();

    dir_rotA.FromAngleAxis(25,Vector3(0.0f,1.0f,0.0f));
    dir_rotB.FromAngleAxis(-25,Vector3(0.0f,1.0f,0.0f));

    fire_directionA = dir_rotA * fire_directionA;
    fire_directionB = dir_rotB * fire_directionB;

    Array<Vector3>dirs = {fire_directionA,fire_directionB,fire_directionC};

    fire_logic(timestep,dirs);

  }


}
