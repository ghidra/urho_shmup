#include "Scripts/outlyer/Projectile.as"
#include "Scripts/outlyer/Perlin.as"

class ProjectileNoisy:Projectile{

  ProjectileNoisy(Scene@ scene, Vector3 pos, Vector3 dir, float speed = 4.5f, Vector3 hit = Vector3(0.0f,0.0f,0.0f)){
    super(scene,pos,dir,speed,hit);
  }

  void attach_script(Node@ node, Vector3 hit = Vector3(0.0f,0.0f,0.0f) ){
    ProjectileNoisy_Script@ node_script_ = cast<ProjectileNoisy_Script>(node.CreateScriptObject(scriptFile, "ProjectileNoisy_Script"));
    node_script_.set_hit(hit);
  }

}

class ProjectileNoisy_Script:Projectile_Script{

  Perlin@ noise_;

  void Start(){
    //Super();
    noise_ = Perlin();
    SubscribeToEvent(node, "NodeCollision", "HandleNodeCollision");
  }

  void FixedUpdate(float timeStep){
    Projectile_Script::FixedUpdate(timeStep);

    if(node !is null){//if we havent removed the node
      RigidBody@ body_ = node.GetComponent("RigidBody");

      float nx = noise_.noise2(node.position.x,node.position.y,100.0f,100.0f);
      float ny = noise_.noise2(node.position.x,node.position.y,100.0f,100.0f,10.0f,33.0f);
      Vector3 d2 = Vector3(nx,ny,0.0f);
      Vector3 d1 = body_.linearVelocity;
      float ds = d1.length;

      //Vector3 newd = d1.Normalized()+d2.Normalized();
      Vector3 newd = d1+d2;
      //newd = newd.Normalized()*ds;

      body_.linearVelocity = newd;


      Vector3 distance = node.position-hit_;
      if(distance.length<0.2f){
        spawn_explosion(node.position,body_.linearVelocity);
        node.Remove();
        //remove_all();
      }
    }
  }

}
