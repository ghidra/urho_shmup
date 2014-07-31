#include "Scripts/outlyer/Controller.as"
class ControllerPlayer : Controller{

  Graph@ _graph;

  ControllerPlayer(Node@ node){
    super(node);
  }
  void move(Vector3 direction, float timeStep){
    if(_node is null)
      return;
    RigidBody@ _body = _node.GetComponent("RigidBody");
    _body.linearVelocity = _body.linearVelocity+(direction*_speed*timeStep);
  }

  //------specific method
  void set_graph(Graph@ graph){
    _graph = graph;
  }
}
