#include "Scripts/shmup/weapons/Weapon.as"
#include "Scripts/shmup/projectiles/Projectile.as"

shared class WeaponTripleSin:Weapon{
  //int firing_ = 0;
  //float firing_timer_ = 0.0f;//when the firing began, so I can use a timer for interval
  //float firing_interval_ = 0.2f;//how often we can fire
  float fire_angle_;
  float fire_angle_spread_ = 30.0f;
  float fire_speed_ = 0.7f*30.0f;
  float timer_total_ = 0.0f;
  float fire_frequency_ = 2.0f*30.0f;
  //Vector3 fire_direction_ = (0.0f,0.0f,1.0f)

  WeaponTripleSin(){
    firing_interval_ = 0.025f;
  }

  void fire(Vector3 target_position,float timestep = 0.0f){
    Vector3 fire_direction_ = Vector3(0.0f,0.0f,1.0f);
    timer_total_ += timestep;
    if(firing_<1){//start firing
      firing_=1;
      firing_timer_ = timestep;
      spawn_projectile("Projectile",fire_direction_,target_position);
    }else{//we are firing, we need to shot intermittenly
      firing_timer_+=timestep;
      Quaternion dir_rot = Quaternion();
      fire_angle_=(Cos(timer_total_*4500.0f)*fire_angle_spread_);
      dir_rot.FromAngleAxis(fire_angle_,Vector3(0.0f,1.0f,0.0f));
      fire_direction_ = dir_rot * fire_direction_;

      if(firing_timer_> firing_interval_){//we can shoot again if we are past our interval time
        firing_timer_=0;
        spawn_projectile("Projectile",fire_direction_,target_position);
      }
    }

  }

  void release_fire(){
    firing_=0;
  }

  Node@ spawn_projectile(const String&in ptype, const Vector3&in dir, const Vector3 hit = Vector3(0.0f,0.0f,0.0f)){
    const float OBJECT_VELOCITY = 5.0f;

    XMLFile@ xml = cache.GetResource("XMLFile", "Scripts/shmup/nodes/" + ptype + ".xml");
    Node@ projectile_ = scene.InstantiateXML(xml, node.worldPosition, Quaternion());

    Projectile@ node_script_ = cast<Projectile>(projectile_.CreateScriptObject(scriptFile, "Projectile", LOCAL));
    node_script_.set_parms(dir,fire_speed_,hit);

    return projectile_;
  }

}
