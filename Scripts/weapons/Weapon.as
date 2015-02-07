#include "Scripts/core/Actor.as"
#include "Scripts/projectiles/Projectile.as"

shared class Weapon:Actor{
  //String meshtype_ = "Box";//the weaon mesh
  String meshtype_ = "centered_weapon_01";//the weaon mesh
  String mattype_ = "Pixel";//the weapons material

  int firing_ = 0;
  float fire_velocity_ = 50.0f;
  float firing_timer_ = 0.0f;//when the firing began, so I can use a timer for interval
  float firing_interval_ = 0.2f;//how often we can fire

  Vector3 projectile_offset_ = Vector3(0.0f,0.0f,0.5f);
  float projectile_damage_mult = 0.5f;

  String ntype_ = "Projectile";//the node/ mesh to use
  String ctype_ = "Projectile";//the class type of projectile to use

  Array<Vector3> aprojectile_offset_ = {Vector3(0.0f,0.0f,0.5f),Vector3(0.0f,0.0f,0.5f),Vector3(0.0f,0.0f,0.5f)};//this needs to be a array if we have multiple bullets

  //------------------
  //-----   setters
  void set_firerate(const float&in rate){
    firing_interval_ = rate;
  }
  void set_enemy(){//called if we are from an enemy pawn
    isenemy_=1;//we are possesed by the enemy
    //here we can multiply the speed perhapse
    fire_velocity_*=0.25f;//slower bullets for the enemy
  }
  //-----------------

  void fire(Vector3 target_position,float timestep = 0.0f){
    //Array<Vector3> dir = {Vector3(0.0f,0.0f,1.0f)};
    if(target_position.length>0.0f){
      Vector3 direction = target_position-node.worldPosition;
      direction.Normalize();
      fire_logic(timestep,direction);
    }else{
      fire_logic(timestep);
    }
  }
  void release_fire(){
    firing_=0;
    firing_timer_ = 0;
  }

  void fire_logic(const float timestep, const Vector3 dir = Vector3(0.0f,0.0f,1.0f), const Vector3 hit = Vector3() ){
    if(firing_<1){//start firing
      firing_=1;
      firing_timer_ = timestep;

      spawn_projectile(dir,hit);

    }else{//we are firing, we need to shot intermittenly
      firing_timer_+=timestep;
      if(firing_timer_> firing_interval_){//we can shoot again if we are past our interval time
        firing_timer_= 0;

        spawn_projectile(dir,hit);

      }
    }
  }

  void fire_logic(const float timestep, const Array<Vector3> dir, const Vector3 hit = Vector3() ){
    if(firing_<1){//start firing
      firing_=1;
      firing_timer_ = timestep;

      spawn_projectile(dir,hit);

    }else{//we are firing, we need to shot intermittenly
      firing_timer_+=timestep;
      if(firing_timer_> firing_interval_){//we can shoot again if we are past our interval time
        firing_timer_= 0;

        spawn_projectile(dir,hit);

      }
    }
  }

  void spawn_projectile(const Vector3&in dir, const Vector3 hit = Vector3()){

    XMLFile@ xml = cache.GetResource("XMLFile", "Scripts/nodes/" + ntype_ + ".xml");
    Node@ projectile_ = scene.InstantiateXML(xml, node.worldPosition+aprojectile_offset_[0], Quaternion());

    Projectile@ node_script_ = cast<Projectile>(projectile_.CreateScriptObject(scriptFile, ctype_, LOCAL));
    node_script_.set_parms(dir,fire_velocity_,isenemy_,hit);

    //return projectile_;
  }

  void spawn_projectile(const Array<Vector3> dir, const Vector3 hit = Vector3()){

    XMLFile@ xml = cache.GetResource("XMLFile", "Scripts/nodes/" + ntype_ + ".xml");

    for(uint i=0; i<dir.length;i++){
      Node@ projectile_ = scene.InstantiateXML(xml, node.worldPosition+aprojectile_offset_[i], Quaternion());

      Projectile@ node_script_ = cast<Projectile>(projectile_.CreateScriptObject(scriptFile, ctype_, LOCAL));
      node_script_.set_parms(dir[i],fire_velocity_,isenemy_,hit);
    }

    //return projectile_;
  }

}
