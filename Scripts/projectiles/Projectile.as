#include "Scripts/core/Actor.as"
#include "Scripts/projectiles/Explosion.as"

shared class Projectile:Actor{

  Vector3 pos_born_;//the position this projectile was born
  Vector3 hit_;//this is if we want this projectile to aim at a specific position
  float range_=40.0f;//how far this projectile can travel
  float damage_=1.0f;//how much damage this projectile can do

  void Start(){
    collision_layer_=2;
    collision_mask_=56;

    pos_born_ = node.position;
    SubscribeToEvent(node, "NodeCollision", "HandleNodeCollision");
  }

  void FixedUpdate(float timeStep){
    //Actor::FixedUpdate(timeStep);
    if(node !is null){
      RigidBody@ body = node.GetComponent("RigidBody");
      Vector3 v_dist = node.position-pos_born_;
      float dist = v_dist.length;
      if(dist>range_){
        node.Remove();
      }
      /*Array<Node@> nodes = node.scene.GetChildrenWithScript("Explosion_Script", true);
      for (uint i = 0; i < nodes.length; ++i){
        Vector3 distance_vector = node.position-nodes[i].position;
        Explosion_Script@ explosion_script = cast<Explosion_Script>(nodes[i].scriptObject);
        if(distance_vector.length < explosion_script.radius_){
          //spawn_explosion(node.position,body.linearVelocity);
          node.Remove();
        }
      }*/
    }

  }
  //collision
  void ObjectCollision(Actor@ otherObject, VariantMap& eventData){
    RigidBody@ body = node.GetComponent("RigidBody");
    //spawn_explosion(node.position,body.linearVelocity);
    node.Remove();
  }

  void set_hit(Vector3 hit){//this is a specific location that we are aiming for
    hit_ = hit;
  }
  void set_parms(const Vector3 dir,const float speed,const uint enemy = 0, const Vector3 hit=Vector3(0.0f,0.0f,.0.0f)){
    RigidBody@ body = node.GetComponent("RigidBody");
    body.linearVelocity = dir * speed;
    hit_=hit;
    if(enemy>0){
      collision_layer_=8;
      collision_mask_=33;
    }
    RigidBody@ rb = node.GetComponent("RigidBody");
    rb.collisionLayer=collision_layer_;
    rb.collisionMask=collision_mask_;
  }

  void spawn_explosion(Vector3 pos, Vector3 mag){//position and magnitude, which we can derive direction and speed from
    float speed = mag.length;
    Vector3 dir = mag.Normalized();
    Explosion@ explosion_ = Explosion(node.scene,pos,dir,speed);
  }

}
