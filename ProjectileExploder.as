#include "Scripts/shmup/Projectile.as"

shared class ProjectileExploder:Projectile{

  ProjectileExploder(Scene@ scene, Vector3 pos, Vector3 dir, float speed = 4.5f, Vector3 hit = Vector3(0.0f,0.0f,0.0f)){
    super(scene,pos,dir,speed,hit);
  }

  void attach_script(Node@ node, Vector3 hit = Vector3(0.0f,0.0f,0.0f) ){
    ProjectileExploder_Script@ node_script_ = cast<ProjectileExploder_Script>(node.CreateScriptObject(scriptFile, "ProjectileExploder_Script"));
    node_script_.set_hit(hit);
  }

}

shared class ProjectileExploder_Script:Projectile_Script{

  void FixedUpdate(float timeStep){
    Projectile_Script::FixedUpdate(timeStep);

    if(node !is null){//if we havent removed the node
      RigidBody@ body_ = node.GetComponent("RigidBody");
      Vector3 distance = node.position-hit_;
      if(distance.length<0.2f){
        spawn_explosion(node.position,body_.linearVelocity);
        node.Remove();
        //remove_all();
      }
    }
  }

}
