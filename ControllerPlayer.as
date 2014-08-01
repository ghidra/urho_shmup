#include "Scripts/outlyer/Controller.as"
#include "Scripts/outlyer/CameraLogic.as"

class ControllerPlayer : Controller{

  Graph@ _graph;

  ControllerPlayer(Scene@ scene, Node@ node){
    super(scene, node);
  }
  void move(Vector3 direction, float timeStep){
    if(_node is null)
      return;
    RigidBody@ _body = _node.GetComponent("RigidBody");
    _body.linearVelocity = _body.linearVelocity+(direction*_speed*timeStep);
  }
  void move_mouse(IntVector2 mousemove){
    if(_camera_node is null)
      return;
    CameraLogic@ _camera_logic = cast<CameraLogic>(_camera_node.GetScriptObject("CameraLogic"));
    if(_camera_logic is null)
      return;
    _camera_logic.move_mouse(mousemove,_sensitivity);
  }
  void left_mouse(){
    if(_node is null)
      return;
    //here i get to use the location on the grid to determine where to fire my projectile
    Vector3 direction = _graph._hit-_node.position;
    //direction.Normalize();

    spawn_projectile(_node.position, direction);
  }

  //------specific method
  void set_graph(Graph@ graph){
    _graph = graph;
  }

  //------spawn a projectile
  void spawn_projectile(Vector3 pos, Vector3 dir){
    Node@ boxNode = _scene.CreateChild("SmallBox");
    boxNode.position = pos+(dir.Normalized()*1.0f);
    //boxNode.rotation = cameraNode.rotation;
    boxNode.SetScale(0.25f);
    StaticModel@ boxObject = boxNode.CreateComponent("StaticModel");
    boxObject.model = cache.GetResource("Model", "Models/Box.mdl");
    boxObject.material = cache.GetResource("Material", "Materials/StoneEnvMapSmall.xml");
    boxObject.castShadows = true;

    // Create physics components, use a smaller mass also
    RigidBody@ body = boxNode.CreateComponent("RigidBody");
    body.mass = 0.25f;
    body.friction = 0.75f;
    CollisionShape@ shape = boxNode.CreateComponent("CollisionShape");
    shape.SetBox(Vector3(1.0f, 1.0f, 1.0f));

    const float OBJECT_VELOCITY = 4.5f;

    // Set initial velocity for the RigidBody based on camera forward vector. Add also a slight up component
    // to overcome gravity better
    body.linearVelocity = dir+Vector3(0.0f,1.0f,0.0f) * OBJECT_VELOCITY;
  }
}
