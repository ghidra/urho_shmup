#include "Scripts/outlyer/SceneManager.as"
#include "Scripts/outlyer/InputPlayer.as"
#include "Scripts/outlyer/Graph.as"
#include "Scripts/outlyer/Character.as"
#include "Scripts/outlyer/CameraLogic.as"
#include "Scripts/outlyer/Perlin.as"

#include "Scripts/outlyer/EnemyBasic.as"

SceneManager@ scene_manager_;
Scene@ scene_;
Node@ camera_node_;
InputPlayer@ input_player_;
Character@ character_;//not even sure i need any of these, but there are here for now

//Graph@ _graph;

void Start(){
  scene_manager_ = SceneManager(1);
  scene_ = scene_manager_.scene_;
  camera_node_ = scene_manager_.camera_node_;
  input_player_ = InputPlayer();//need some kind of value in here to make it real, no idea why

  CreateScene();

}

void CreateScene(){
  //Graph@ _graph_ground = Graph(_scene,_camera_node,32,32,100.0f,100.0f);//make the graph
  Graph@ graph_ = Graph(scene_,camera_node_,10,3,100.0f,25.0f);//make the graph
  graph_.node_.Rotate(Quaternion(-90.0f,0.0f,0.0f));
  graph_.node_.Translate(Vector3(0.0f,0.0f,25.0f/2.0f));//move it up equal with the ground

  character_ = Character(scene_);//create the character at the scene level
  scene_manager_.set_camera_target(character_.node_);
  input_player_.set_controlnode(character_.node_);
  input_player_.set_graph(graph_);
  input_player_.set_cameranode(camera_node_);

  //my first enemy
  EnemyBasic@ enemy_ = EnemyBasic(scene_);
  enemy_.set_position(Vector3(-10.0f,0.0f,0.0f));
  enemy_.set_enemytarget(character_.node_);

  // Create a directional light to the world. Enable cascaded shadows on it
  Node@ lightNode = scene_.CreateChild("DirectionalLight");
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

  PhysicsWorld@ physics = scene_.physicsWorld;
  //physics.gravity = Vector3(0.0f,0.0f,0.0f);
}

//--------------------
