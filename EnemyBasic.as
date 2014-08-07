#include "Scripts/outlyer/Pawn.as"
#include "Scripts/outlyer/ControllerEnemyBasic.as"

class EnemyBasic:Pawn{

  RigidBody@ _body;

  ControllerEnemyBasic@ _controller;

  EnemyBasic(Scene@ scene){

    super(scene,"EnemyBasic");

    _body = _node.CreateComponent("RigidBody");
    _body.mass = 0.25f;
    _body.friction = 0.75f;
    _body.linearDamping = 0.6f;
    _body.useGravity = false;
    CollisionShape@ shape = _node.CreateComponent("CollisionShape");
    shape.SetBox(Vector3(1.0f, 1.0f, 1.0f));
    //push_object();

    _controller = ControllerEnemyBasic(_scene,_node);
  }

}
