#include "Scripts/shmup/core/SceneManager.as"
#include "Scripts/shmup/core/InputPlayer.as"
#include "Scripts/shmup/math/Graph.as"
#include "Scripts/shmup/core/Character.as"
//#include "Scripts/shmup/weapons/Weapon.as"//i might not need this here, test later
#include "Scripts/shmup/core/CameraLogic.as"
#include "Scripts/shmup/pickups/PickupWeapon1.as"
#include "Scripts/shmup/pickups/PickupWeapon2.as"

#include "Scripts/shmup/enemies/Factory.as"
#include "Scripts/shmup/enemies/EnemyFactory.as"

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

  //OpenConsoleWindow();
  CreateScene();

}

void CreateScene(){

  Node@ player_ = spawn_object("Character");
  //Node@ enemy_ =spaw;
  //enemy.set_target(player_)

  Node@ container_ = scene_.CreateChild("camera_target");
  container_.CreateScriptObject(scriptFile, "Container");//make the container
  container_.AddChild(player_);//put the player under the container

  Container@ cso = cast<Container>(container_.scriptObject);
  Character@ chso = cast<Character>(player_.scriptObject);
  chso.set_bounds(cso.bounds_);

  scene_manager_.set_camera_target(container_);
  //scene_manager_.set_camera_target(player_);

  input_player_.set_controlnode(player_);
  input_player_.set_cameranode(camera_node_);

  //enemy
  Node@ en = container_.CreateChild("enemy_factory");
  EnemyFactory@ ef = cast<EnemyFactory>(en.CreateScriptObject(scriptFile, "EnemyFactory"));
  //Node@ enemy = ef.spawn_enemy("Enemy","Enemy",Vector3(5.0f,0.0f,5.0f));

  //pickups
  Node@ pu1 = spawn_object("Pickup",Vector3(-15.0f,0.0f,-5.0f) );
  Node@ pu2 = spawn_object("Pickup",Vector3(-5.0f,0.0f,-5.0f) );
  Node@ pu3 = spawn_object("Pickup",Vector3(5.0f,0.0f,-5.0f) );
  Node@ pu4 = spawn_object("Pickup",Vector3(15.0f,0.0f,-5.0f) );

  StaticModel@ sm1 = pu1.GetComponent("StaticModel");
  sm1.model = cache.GetResource("Model", "Scripts/shmup/models/1.mdl");
  sm1.material = Material();//cache.GetResource("Material", "Materials/Stone.xml");
  PickupWeapon1@ pu1_script_ = cast<PickupWeapon1>(pu1.CreateScriptObject(scriptFile, "PickupWeapon1"));

  StaticModel@ sm2 = pu2.GetComponent("StaticModel");
  sm2.model = cache.GetResource("Model", "Scripts/shmup/models/2.mdl");
  sm2.material = Material();//cache.GetResource("Material", "Materials/Stone.xml");

  PickupWeapon2@ pu2_script_ = cast<PickupWeapon2>(pu2.CreateScriptObject(scriptFile, "PickupWeapon2"));

  StaticModel@ sm3 = pu3.GetComponent("StaticModel");
  sm3.model = cache.GetResource("Model", "Scripts/shmup/models/3.mdl");
  sm3.material = Material();//cache.GetResource("Material", "Materials/Stone.xml");

  StaticModel@ sm4 = pu4.GetComponent("StaticModel");
  sm4.model = cache.GetResource("Model", "Scripts/shmup/models/4.mdl");
  sm4.material = Material();//cache.GetResource("Material", "Materials/Stone.xml");

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

Node@ spawn_object(const String&in otype, const Vector3&in pos= Vector3(), const Quaternion&in ori = Quaternion() ){
  XMLFile@ xml = cache.GetResource("XMLFile", "Scripts/shmup/nodes/" + otype + ".xml");
  return scene_.InstantiateXML(xml, pos, ori);
}

//--------------------

//the container to move the whol scene
class Container:ScriptObject{
  Vector2 bounds_ = Vector2(24.0f,16.0f);
  void FixedUpdate(float timeStep){
    node.position = node.position+Vector3(0.0f,0.0f,0.75f*timeStep);
  }
}
