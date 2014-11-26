#include "Scripts/shmup/core/SceneManager.as"
#include "Scripts/shmup/core/InputPlayer.as"
//#include "Scripts/shmup/InputBasics.as"
#include "Scripts/shmup/math/Graph.as"
#include "Scripts/shmup/core/Character.as"
#include "Scripts/shmup/weapons/Weapon.as"//i might not need this here, test later
#include "Scripts/shmup/core/CameraLogic.as"
//#include "Scripts/shmup/Perlin.as"
//#include "Scripts/shmup/Stage.as"

//#include "Scripts/shmup/EnemyBasic.as"

SceneManager@ scene_manager_;
Scene@ scene_;
Node@ camera_node_;
InputPlayer@ input_player_;
//InputBasics@ input_basics_;



//Character@ character_;//not even sure i need any of these, but there are here for now

//Graph@ _graph;

void Start(){
  scene_manager_ = SceneManager(1);
  scene_ = scene_manager_.scene_;
  camera_node_ = scene_manager_.camera_node_;
  scene_manager_.set_camera_parameters(true,42.0f, Vector3(75.0f,0.0f,0.0f));
  input_player_ = InputPlayer();//need some kind of value in here to make it real, no idea why
  //input_basics_ = InputBasics();

  CreateScene();

}

void CreateScene(){
  //Graph@ _graph_ground = Graph(scene_,camera_node_,10,10,100.0f,100.0f);//make the graph
  //Graph@ graph_ = Graph(scene_,camera_node_,10,3,100.0f,25.0f);//make the graph
  //graph_.node_.Rotate(Quaternion(-90.0f,0.0f,0.0f));
  //graph_.node_.Translate(Vector3(0.0f,0.0f,25.0f/2.0f));//move it up equal with the ground

  //Stage@ stage = Stage(scene_,50,50);

  Node@ camera_target = scene_.CreateChild("camera_target");

  Node@ player_ = spawn_player();
  //Print(player_.GetComponent("ScriptObject").category);
  //Character@ c_ = cast<Character>(player_.GetScriptObject("Character"));
  //Character@ c_ = cast<Character>(player_.scriptObject);

  //character_ = Character(scene_);//create the character at the scene level
  scene_manager_.set_camera_target(camera_target);
  scene_manager_.set_camera_target(player_);
  input_player_.set_controlnode(player_);
  //input_player_.set_graph(graph_);
  input_player_.set_cameranode(camera_node_);

  //my first enemy
  /*EnemyBasic@ enemy_ = EnemyBasic(scene_);
  enemy_.set_position(Vector3(-10.0f,0.0f,0.0f));
  enemy_.set_enemytarget(character_.node_);
  */
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
  physics.gravity = Vector3(0.0f,0.0f,0.0f);
}

Node@ spawn_player(){
  XMLFile@ xml = cache.GetResource("XMLFile", "Scripts/shmup/nodes/Character.xml");
  return scene_.InstantiateXML(xml, Vector3(0.0f,0.0f,0.0f), Quaternion());
}

//--------------------
