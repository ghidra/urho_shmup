#include "Scripts/shmup/core/Actor.as"
#include "Scripts/shmup/projectiles/Projectile.as"
#include "Scripts/shmup/projectiles/ProjectileNoisy.as"
#include "Scripts/shmup/projectiles/ProjectileExploder.as"

shared class Weapon:Actor{
  int firing_ = 0;
  float firing_timer_ = 0.0f;//when the firing began, so I can use a timer for interval
  float firing_interval_ = 0.2f;//how often we can fire

  void fire(Vector3 target_position,float timestep = 0.0f){
    if(firing_<1){//start firing
      firing_=1;
      firing_timer_ = timestep;

      //spawn_projectile(Vector3(0,0,1),target_position);
      spawn_projectile("Projectile",Vector3(0,0,1),target_position);
    }else{//we are firing, we need to shot intermittenly
      firing_timer_+=timestep;
      if(firing_timer_> firing_interval_){//we can shoot again if we are past our interval time
        firing_timer_=0;
        spawn_projectile("Projectile",Vector3(0,0,1),target_position);
      }
    }

  }
  void release_fire(){
    firing_=0;
  }

  Node@ spawn_projectile(const String&in ptype, const Vector3&in dir, const Vector3 hit = Vector3(0.0f,0.0f,0.0f)){
    const float OBJECT_VELOCITY = 50.0f;

    XMLFile@ xml = cache.GetResource("XMLFile", "Scripts/shmup/nodes/" + ptype + ".xml");
    Node@ projectile_ = scene.InstantiateXML(xml, node.worldPosition, Quaternion());

    Projectile@ node_script_ = cast<Projectile>(projectile_.CreateScriptObject(scriptFile, "ProjectileBukkake", LOCAL));
    node_script_.set_parms(dir,OBJECT_VELOCITY,hit);

    return projectile_;
  }

}
