#include "Scripts/shmup/core/Pawn.as";
class Behavior{
  Node@ slave_;
  int mirror_;//if we mirror this effect
  float speed_=5.0f;//incase we dont find one, we should
  Behavior(Node@ slave,const int&in mirror = 0){
    slave_ = slave;
    Pawn@ p = cast<Pawn>(slave_.scriptObject);//get the script that controls this enemy
    speed_ = p.speed_;//get the speed from it to appy here
  }
  void update(){
    RigidBody@ body_ = slave_.GetComponent("RigidBody");
    //body_.linearVelocity = body_.linearVelocity+Vector3(0.0f,0.0f,-0.1f);
    body_.linearVelocity = Vector3(0.0f,0.0f,-speed_);
  }
}
