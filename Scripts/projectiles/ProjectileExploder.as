#include "Scripts/projectiles/Projectile.as"

shared class ProjectileExploder:Projectile{

  void FixedUpdate(float timeStep){
    Projectile::FixedUpdate(timeStep);

    if(node !is null){//if we havent removed the node
      RigidBody@ body = node.GetComponent("RigidBody");
      Vector3 distance = node.position-hit_;
      if(distance.length<0.2f){
        spawn_explosion(node.position,body.linearVelocity);
        node.Remove();
      }
    }
  }

}
