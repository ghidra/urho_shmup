#include "Scripts/outlyer/SceneManager.as"
#include "Scripts/outlyer/InputPlayer.as"
#include "Scripts/outlyer/Graph.as"
#include "Scripts/outlyer/Character.as"
#include "Scripts/outlyer/CameraLogic.as"

#include "Scripts/outlyer/EnemyBasic.as"

Scene@ _scene;
Node@ _camera_node;
InputPlayer@ _input_player;

//Character@ _character;

//Graph@ _graph;

void Start(){
  SceneManager@ _scene_manager = SceneManager();
  _scene = _scene_manager._scene;
  _camera_node = _scene_manager._camera_node;
  _input_player = InputPlayer(1);//need some kind of value in here to make it real, no idea why

  CreateScene();

}

void CreateScene(){
  //Graph@ _graph_ground = Graph(_scene,_camera_node,32,32,100.0f,100.0f);//make the graph
  Graph@ _graph = Graph(_scene,_camera_node,10,3,100.0f,25.0f);//make the graph
  _graph._node.Rotate(Quaternion(-90.0f,0.0f,0.0f));
  _graph._node.Translate(Vector3(0.0f,0.0f,25.0f/2.0f));//move it up equal with the ground

  Character@ _character = Character(_scene);//create the character at the scene level
  _character._controller.set_graph(_graph);//give the graph to the controllerplayer
  _character._controller.set_cameranode(_camera_node);
  //_character.set_position(Vector3(0.0f,3.0f,0.0f));

  //my first enemy
  EnemyBasic@ _enemy = EnemyBasic(_scene);
  _enemy.set_position(Vector3(5.0f,0.0f,0.0f));

  CameraLogic@ _camera_logic = cast<CameraLogic>(_camera_node.GetScriptObject("CameraLogic"));
  _camera_logic.set_target(_character._node);
  _input_player.set_controller(_character._controller);//the input_player needs to know what controller to send commands to



  // Create a directional light to the world. Enable cascaded shadows on it
  Node@ lightNode = _scene.CreateChild("DirectionalLight");
  lightNode.direction = Vector3(0.6f, -1.0f, 0.8f);
  Light@ light = lightNode.CreateComponent("Light");
  light.lightType = LIGHT_DIRECTIONAL;
  light.castShadows = true;
  light.shadowBias = BiasParameters(0.00025f, 0.5f);
  // Set cascade splits at 10, 50 and 200 world units, fade shadows out at 80% of maximum shadow distance
  light.shadowCascade = CascadeParameters(10.0f, 50.0f, 200.0f, 0.0f, 0.8f);

  /*Node@ graphNode = _scene.CreateChild("Graph");
  Graph@ graph = cast<Graph>(graphNode.CreateScriptObject(scriptFile, "Graph"));
  graph.set_parameters(_cameraNode,32,32,100.0f,100.0f);*/

  PhysicsWorld@ physics = _scene.physicsWorld;
  //physics.gravity = Vector3(0.0f,0.0f,0.0f);
}

//--------------------
