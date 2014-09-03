//this is the new pawn, that extends actor that extends the script object. meant to be used by the character and enemy classes
//and anything that needs to be moved i guess, maybe even projectiles later
//this class should house the mean to move an actor, and remove the code from the controler classes
#include "Scripts/outlyer/Actor.as"
class Pawn:Actor{

  //String _node_name;
  //Controller@ _controller;
  Node@ camera_node_;//the camera node

  //setters
  /*void set_position(Vector3 pos){
    node_.position = pos;
  }

  void set_enemytarget(Node@ target){
    enemytarget_ = target;
  }*/

  //-----

  void move(Vector3 direction, float timeStep){
    RigidBody@ body_ = node.GetComponent("RigidBody");
    body_.linearVelocity = body_.linearVelocity+(direction*speed_*timeStep);
  }
  void fire_projectile(Vector3 target_position){
    //here i get to use the location on the grid to determine where to fire my projectile
    Vector3 direction = target_position-node.position;
    //direction.Normalize();
    spawn_projectile(direction,target_position);
  }

  void spawn_projectile(Vector3 dir, Vector3 hit = Vector3(0.0f,0.0f,0.0f)){
    return;
    //const float OBJECT_VELOCITY = 4.5f;
    //Projectile@ projectile_ = Projectile(node.scene,node.position,dir,OBJECT_VELOCITY,hit);
  }
}
