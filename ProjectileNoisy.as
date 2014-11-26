#include "Scripts/shmup/Projectile.as"
#include "Scripts/shmup/Perlin.as"

shared class ProjectileNoisy:Projectile{

  Perlin@ noise_;

  void Start(){
    //Super();
    noise_ = Perlin();
    SubscribeToEvent(node, "NodeCollision", "HandleNodeCollision");
  }

  void FixedUpdate(float timeStep){
    Projectile::FixedUpdate(timeStep);

    if(node !is null){//if we havent removed the node
      RigidBody@ body_ = node.GetComponent("RigidBody");

      float nx = noise_.simplex2(node.position.x,node.position.y,100.0f,100.0f);
      float ny = noise_.simplex2(node.position.x,node.position.y,100.0f,100.0f,10.0f,33.0f);
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
