#include "Scripts/shmup/Projectile.as"

shared class ProjectileExploder:Projectile{

  void FixedUpdate(float timeStep){
    Projectile::FixedUpdate(timeStep);

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
