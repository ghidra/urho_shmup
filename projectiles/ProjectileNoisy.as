#include "Scripts/shmup/projectiles/Projectile.as"
#include "Scripts/shmup/math/Perlin.as"

shared class ProjectileNoisy:Projectile{

  Perlin@ noise;

  void Start(){
    noise = Perlin();
    SubscribeToEvent(node, "NodeCollision", "HandleNodeCollision");
  }

  void FixedUpdate(float timeStep){
    Projectile::FixedUpdate(timeStep);

    if(node !is null){//if we havent removed the node
      RigidBody@ body = node.GetComponent("RigidBody");

      float nx = noise.simplex2(node.position.x,node.position.y,100.0f,100.0f);
      float ny = noise.simplex2(node.position.x,node.position.y,100.0f,100.0f,10.0f,33.0f);
      Vector3 d2 = Vector3(nx,ny,0.0f);
      Vector3 d1 = body.linearVelocity;
      float ds = d1.length;
      Vector3 newd = d1+d2;

      body.linearVelocity = newd;

      Vector3 distance = node.position-hit_;
      if(distance.length<0.2f){
        spawn_explosion(node.position,body.linearVelocity);
        node.Remove();
      }
    }
  }

}
