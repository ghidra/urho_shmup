#include "Scripts/outlyer/Pawn.as"
#include "Scripts/outlyer/ControllerEnemyBasic.as"

class EnemyBasic:Pawn{

  RigidBody@ body_;

  ControllerEnemyBasic@ controller_;

  EnemyBasic(Scene@ scene){

    super(scene,"EnemyBasic");

    body_ = node_.CreateComponent("RigidBody");
    body_.mass = 0.25f;
    body_.friction = 0.75f;
    body_.linearDamping = 0.6f;
    body_.useGravity = false;
    CollisionShape@ shape = node_.CreateComponent("CollisionShape");
    shape.SetBox(Vector3(1.0f, 1.0f, 1.0f));
    //push_object();

    controller_ = ControllerEnemyBasic(scene_,node_);
  }

  //override
  void set_enemytarget(Node@ target){
    enemytarget_ = target;
    controller_.set_enemytarget(target);
  }

}
