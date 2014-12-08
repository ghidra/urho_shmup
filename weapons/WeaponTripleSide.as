#include "Scripts/shmup/weapons/Weapon.as"
#include "Scripts/shmup/projectiles/Projectile.as"

shared class WeaponTripleSide:Weapon{

  float fire_angle_;
  float fire_angle_spread_ = 30.0f;
  float timer_total_ = 0.0f;
  float fire_frequency_ = 2.0f*30.0f;

  WeaponTripleSide(){
    fire_velocity_ = 0.7f*30.0f;
    firing_interval_ = 0.025f;
    projectile_damage_mult = 0.1;
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

    fire_logicB(timestep,fire_directionA,fire_directionB,fire_directionC);

  }
  void fire_logicB(const float timestep, const Vector3&in dirA = Vector3(0.0f,0.0f,1.0f),const Vector3&in dirB = Vector3(0.0f,0.0f,-1.0f),const Vector3&in dirC = Vector3(0.0f,0.0f,-1.0f), const Vector3 hit = Vector3() ){
    if(firing_<1){//start firing
      firing_=1;
      firing_timer_ = timestep;

      spawn_projectileB(dirA,dirB,dirC,hit);

    }else{//we are firing, we need to shot intermittenly
      firing_timer_+=timestep;
      if(firing_timer_> firing_interval_){//we can shoot again if we are past our interval time
        firing_timer_= 0;

        spawn_projectileB(dirA,dirB,dirC,hit);

      }
    }
  }
  void spawn_projectileB(const Vector3&in dirA,const Vector3&in dirB,const Vector3&in dirC, const Vector3 hit = Vector3()){

    XMLFile@ xml = cache.GetResource("XMLFile", "Scripts/shmup/nodes/" + ntype_ + ".xml");
    Node@ projectileA_ = scene.InstantiateXML(xml, node.worldPosition+projectile_offset_+Vector3(0.5f,0.0f,0.0f), Quaternion());
    Node@ projectileB_ = scene.InstantiateXML(xml, node.worldPosition+projectile_offset_+Vector3(-0.5f,0.0f,0.0f), Quaternion());
    Node@ projectileC_ = scene.InstantiateXML(xml, node.worldPosition+projectile_offset_+Vector3(0.0f,0.0f,0.5f), Quaternion());

    Projectile@ node_scriptA_ = cast<Projectile>(projectileA_.CreateScriptObject(scriptFile, ctype_, LOCAL));
    node_scriptA_.set_parms(dirA,fire_velocity_,hit);

    Projectile@ node_scriptB_ = cast<Projectile>(projectileB_.CreateScriptObject(scriptFile, ctype_, LOCAL));
    node_scriptB_.set_parms(dirB,fire_velocity_,hit);

    Projectile@ node_scriptC_ = cast<Projectile>(projectileC_.CreateScriptObject(scriptFile, ctype_, LOCAL));
    node_scriptC_.set_parms(dirC,fire_velocity_,hit);

    //return projectile_;
  }


}
