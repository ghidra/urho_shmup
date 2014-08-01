//class Character : ScriptObject{
//#include "Scripts/outlyer/InputPlayer.as"
#include "Scripts/outlyer/ControllerPlayer.as"

//class Character : InputPlayer{
class Character{
  Node@ _node;
  //Node@ _camera_node;
  RigidBody@ _body;

  ControllerPlayer@ _controller;

  Character(Scene@ scene){

    //super();

    _node = scene.CreateChild("Character");

    StaticModel@ coneObject = _node.CreateComponent("StaticModel");
    coneObject.model = cache.GetResource("Model", "Models/Cone.mdl");
    coneObject.material = cache.GetResource("Material", "Materials/StoneTiled.xml");
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
