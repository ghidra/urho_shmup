//class Character : ScriptObject{
//#include "Scripts/outlyer/InputPlayer.as"
#include "Scripts/outlyer/Pawn.as"
#include "Scripts/outlyer/ControllerPlayer.as"

//class Character : InputPlayer{
class Character:Pawn{

  RigidBody@ _body;

  ControllerPlayer@ _controller;

  Character(Scene@ scene){

    super(scene,"Character");
    
    _body = _node.CreateComponent("RigidBody");
    _body.mass = 0.25f;
    _body.friction = 0.75f;
    _body.linearDamping = 0.6f;
    _body.useGravity = false;
    CollisionShape@ shape = _node.CreateComponent("CollisionShape");
    shape.SetBox(Vector3(1.0f, 1.0f, 1.0f));
    //push_object();

    _controller = ControllerPlayer(_scene,_node);
    //_controller = cast<Controller>(_node.CreateScriptObject(scriptFile, "Controller"));
    //_controller = controller;
  }

  /*void translate_player( Vector3 d, float s, float t){
    _body.linearVelocity = _body.linearVelocity+(d*s*t);
  }*/

}
