#include "Scripts/shmup/core/SceneManager.as"
#include "Scripts/shmup/core/InputPlayer.as"
#include "Scripts/shmup/math/Graph.as"
#include "Scripts/shmup/core/Character.as"
#include "Scripts/shmup/weapons/Weapon.as"//i might not need this here, test later
#include "Scripts/shmup/core/CameraLogic.as"
//#include "Scripts/shmup/Enemy.as"
//#include "Scripts/shmup/Perlin.as"

SceneManager@ scene_manager_;
Scene@ scene_;
Node@ camera_node_;
InputPlayer@ input_player_;

void Start(){
  scene_manager_ = SceneManager(1);
  scene_ = scene_manager_.scene_;
  camera_node_ = scene_manager_.camera_node_;
  scene_manager_.set_camera_parameters(true,42.0f, Vector3(75.0f,0.0f,0.0f));
  input_player_ = InputPlayer();//need some kind of value in here to make it real, no idea why

  CreateScene();

}

void CreateScene(){

  Node@ player_ = spawn_player();

  Node@ camera_target = scene_.CreateChild("camera_target");
  scene_manager_.set_camera_target(camera_target);
  //scene_manager_.set_camera_target(player_);

  input_player_.set_controlnode(player_);
  input_player_.set_cameranode(camera_node_);

  //my first enemy
  /*Enemy@ enemy_ = Enemy();
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

  PhysicsWorld@ physics = scene_.physicsWorld;
  physics.gravity = Vector3(0.0f,0.0f,0.0f);
}

Node@ spawn_player(){
  XMLFile@ xml = cache.GetResource("XMLFile", "Scripts/shmup/nodes/Character.xml");
  return scene_.InstantiateXML(xml, Vector3(0.0f,0.0f,0.0f), Quaternion());
}

//--------------------
