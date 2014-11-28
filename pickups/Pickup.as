#include "Scripts/shmup/core/Actor.as"
class Pickup:Actor{

  void Start(){
      SubscribeToEvent(node, "NodeCollision", "HandleNodeCollision");
  }

  void ObjectCollision(Actor@ otherObject, VariantMap& eventData){
    //apply the data to the colliding object
    Print("collided with pickup");

    //RigidBody@ body = node.GetComponent("RigidBody");
    //spawn_explosion(node.position,body.linearVelocity);
    effect(otherObject,eventData);
    node.Remove();
  }

  void effect(Actor@ otherObject, VariantMap& eventData){
    uint temp = 1;
  }


}
