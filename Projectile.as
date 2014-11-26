#include "Scripts/shmup/Actor.as"
#include "Scripts/shmup/Explosion.as"

shared class Projectile{

  //Vector3 hit_;//this is if we want this projectile to aim at a specific position

  Projectile(Scene@ scene, Vector3 pos, Vector3 dir, float speed = 4.5f, Vector3 hit = Vector3(0.0f,0.0f,0.0f) ){
    //super(scene,"Projectile");
    //scene_ = scene;
    Node@ node_ = scene.CreateChild("Projectile");
    node_.position = pos+(dir.Normalized()*1.0f);
    //_projectile_node.rotation = cameraNode.rotation;
    node_.SetScale(0.25f);
    StaticModel@ object_ = node_.CreateComponent("StaticModel");
    object_.model = cache.GetResource("Model", "Models/Box.mdl");
    object_.material = cache.GetResource("Material", "Materials/StoneEnvMapSmall.xml");
    object_.castShadows = true;

    // Create physics components, use a smaller mass also
    RigidBody@ body_ = node_.CreateComponent("RigidBody");
    body_.mass = 0.25f;
    body_.friction = 0.75f;
    CollisionShape@ shape_ = node_.CreateComponent("CollisionShape");
    shape_.SetBox(Vector3(1.0f, 1.0f, 1.0f));

    // Set initial velocity for the RigidBody based on camera forward vector. Add also a slight up component
    // to overcome gravity better
    //body_.linearVelocity = dir+Vector3(0.0f,1.0f,0.0f) * speed;
    body_.linearVelocity = dir * speed;

    //attach scriptObject
    attach_script(node_,hit);//send it the node and a hit position
  }

  void attach_script(Node@ node, Vector3 hit = Vector3(0.0f,0.f,0.0f)){
    Projectile_Script@ node_script_ = cast<Projectile_Script>(node.CreateScriptObject(scriptFile, "Projectile_Script"));
    node_script_.set_hit(hit);
  }

}

shared class Projectile_Script:Actor{

  Vector3 hit_;//this is if we want this projectile to aim at a specific position

  void Start(){
      SubscribeToEvent(node, "NodeCollision", "HandleNodeCollision");
  }

  void FixedUpdate(float timeStep){
  //  Actor::FixedUpdate(timeStep);
    if(node !is null and node.position.y <= -1)
      node.Remove();
      //remove_all();//i have to delete all the other components for it to remove properly
    ///here now we are trying to get some of the explosion objects to collide against
    if(node !is null){
      RigidBody@ body_ = node.GetComponent("RigidBody");
      Array<Node@> nodes = node.scene.GetChildrenWithScript("Explosion_Script", true);
      for (uint i = 0; i < nodes.length; ++i){
        Vector3 distance_vector = node.position-nodes[i].position;
        Explosion_Script@ explosion_script_ = cast<Explosion_Script>(nodes[i].scriptObject);
        if(distance_vector.length < explosion_script_.radius_){
          spawn_explosion(node.position,body_.linearVelocity);
          node.Remove();
        }
      }
    }

  }
  //collision
  void ObjectCollision(Actor@ otherObject, VariantMap& eventData){
    RigidBody@ body_ = node.GetComponent("RigidBody");
    /*if (hitDamage > 0){
      RigidBody@ body = node.GetComponent("RigidBody");
      if ((body.linearVelocity.length >= snowballMinHitSpeed))
      {
          if (side != otherObject.side)
          {
              otherObject.Damage(this, hitDamage);
              // Create a temporary node for the hit sound
              SpawnSound(node.position, "Sounds/PlayerFistHit.wav", 0.2);
          }

          hitDamage = 0;
      }
    }
    if (duration > snowballObjectHitDuration)
        duration = snowballObjectHitDuration;*/
    spawn_explosion(node.position,body_.linearVelocity);
    node.Remove();
    //remove_all();
  }


  /*void remove_all(){
    node.RemoveAllComponents();
    node.RemoveAllChildren();
    node.Remove();
  }*/

  void set_hit(Vector3 hit){//this is a specific location that we are aiming for
    hit_ = hit;
  }

  void spawn_explosion(Vector3 pos, Vector3 mag){//position and magnitude, which we can derive direction and speed from
    float speed = mag.length;
    Vector3 dir = mag.Normalized();
    Explosion@ explosion_ = Explosion(node.scene,pos,dir,speed);
  }

}
