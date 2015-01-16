#include "Scripts/shmup/core/SceneManager.as"
#include "Scripts/shmup/core/InputPlayer.as"
#include "Scripts/shmup/core/Character.as"
#include "Scripts/shmup/core/CameraLogic.as"

#include "Scripts/shmup/pickups/PickupWeapon1.as"
#include "Scripts/shmup/pickups/PickupWeapon2.as"

#include "Scripts/shmup/enemies/Factory.as"

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

  //---------------

  Node@ container_ = scene_.CreateChild("container");
  Container@ cso = cast<Container>(container_.CreateScriptObject(scriptFile, "Container"));//make the container

  Node@ player_ = container_.CreateChild("Character");
  Character@ chso = cast<Character>(player_.CreateScriptObject(scriptFile,"Character"));
  chso.set_bounds(cso.bounds_);

  scene_manager_.set_camera_target(container_);

  input_player_.set_controlnode(player_);
  input_player_.set_cameranode(camera_node_);

  //enemy
  Node@ en = container_.CreateChild("factory");
  Factory@ ef = cast<Factory>(en.CreateScriptObject(scriptFile, "Factory"));
  ef.generate_enemy_factory(Vector3(5.0f,0.0f,26.0f),5,1.0f,"Enemy","Weapon","Behavior",1.0f,0,1.0f);

  //pickups
  Node@ pu1 = spawn_object("Pickup",Vector3(-15.0f,0.0f,-5.0f) );
  Node@ pu2 = spawn_object("Pickup",Vector3(-5.0f,0.0f,-5.0f) );
  Node@ pu3 = spawn_object("Pickup",Vector3(5.0f,0.0f,-5.0f) );
  Node@ pu4 = spawn_object("Pickup",Vector3(15.0f,0.0f,-5.0f) );

  StaticModel@ sm1 = pu1.GetComponent("StaticModel");
  sm1.model = cache.GetResource("Model", "Models/shmup/1.mdl");
  sm1.material = cache.GetResource("Material", "Materials/shmup/Pixel.xml");//cache.GetResource("Material", "Materials/Stone.xml");
  PickupWeapon1@ pu1_script_ = cast<PickupWeapon1>(pu1.CreateScriptObject(scriptFile, "PickupWeapon1"));

  StaticModel@ sm2 = pu2.GetComponent("StaticModel");
  sm2.model = cache.GetResource("Model", "Models/shmup/2.mdl");
  sm2.material = cache.GetResource("Material", "Materials/shmup/Pixel.xml");//cache.GetResource("Material", "Materials/Stone.xml");

  PickupWeapon2@ pu2_script_ = cast<PickupWeapon2>(pu2.CreateScriptObject(scriptFile, "PickupWeapon2"));

  StaticModel@ sm3 = pu3.GetComponent("StaticModel");
  sm3.model = cache.GetResource("Model", "Models/shmup/3.mdl");
  sm3.material = cache.GetResource("Material", "Materials/shmup/Pixel.xml");//cache.GetResource("Material", "Materials/Stone.xml");

  StaticModel@ sm4 = pu4.GetComponent("StaticModel");
  sm4.model = cache.GetResource("Model", "Models/shmup/4.mdl");
  sm4.material = cache.GetResource("Material", "Materials/shmup/Pixel.xml");//cache.GetResource("Material", "Materials/Stone.xml");

  // Create a directional light to the world. Enable cascaded shadows on it
  Node@ lightNode = scene_.CreateChild("DirectionalLight");
  lightNode.direction = Vector3(0.6f, -0.5f, 0.8f);
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
