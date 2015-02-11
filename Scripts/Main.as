#include "Scripts/core/SceneManager.as"
#include "Scripts/core/InputPlayer.as"
#include "Scripts/core/Character.as"
#include "Scripts/core/CameraLogic.as"

#include "Scripts/pickups/PickupWeapon1.as"
#include "Scripts/pickups/PickupWeapon2.as"

#include "Scripts/enemies/Factory.as"

#include "Scripts/stages/CrystalCanyon.as"

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

  Node@ stage_ = scene_.CreateChild("Stage");
  CrystalCanyon@ ccso = cast<CrystalCanyon>(stage_.CreateScriptObject(scriptFile,"CrystalCanyon"));

  scene_manager_.set_camera_target(container_);

  input_player_.set_controlnode(player_);
  input_player_.set_cameranode(camera_node_);

  //enemy
  Node@ en = container_.CreateChild("factory");
  Factory@ ef = cast<Factory>(en.CreateScriptObject(scriptFile, "Factory"));
  ef.generate_enemy_factory(Vector3(5.0f,0.0f,26.0f),5,1.0f,"Enemy","Weapon","Behavior",1.0f,0,1.0f);

  //corners
  Node@ c1 = scene_.CreateChild("Corner");
  StaticModel@ c1m = c1.CreateComponent("StaticModel");
  c1m.model = cache.GetResource("Model", "Models/corner.mdl");
  c1m.material = cache.GetResource("Material", "Materials/Pixel.xml");
  c1.position=Vector3(-24.0,0.0,20.0);

  Node@ c2 = scene_.CreateChild("Corner");
  StaticModel@ c2m = c2.CreateComponent("StaticModel");
  c2m.model = cache.GetResource("Model", "Models/corner.mdl");
  c2m.material = cache.GetResource("Material", "Materials/Pixel.xml");
  Quaternion q2 = Quaternion();
  q2.FromAngleAxis(90.0,Vector3(0.0,1.0,0.0));
  c2.Rotate( q2 );//q2.FromAngleAxis(90.0,Vector3(0.0,1.0,0.0)) );
  c2.position=Vector3(24.0,0.0,20.0);

  Node@ c3 = scene_.CreateChild("Corner");
  StaticModel@ c3m = c3.CreateComponent("StaticModel");
  c3m.model = cache.GetResource("Model", "Models/corner.mdl");
  c3m.material = cache.GetResource("Material", "Materials/Pixel.xml");
  Quaternion q3 = Quaternion();
  q3.FromAngleAxis(-90.0,Vector3(0.0,1.0,0.0));
  c3.Rotate( q3 );//q2.FromAngleAxis(90.0,Vector3(0.0,1.0,0.0)) );
  c3.position=Vector3(-24.0,0.0,-16.0);

  Node@ c4 = scene_.CreateChild("Corner");
  StaticModel@ c4m = c4.CreateComponent("StaticModel");
  c4m.model = cache.GetResource("Model", "Models/corner.mdl");
  c4m.material = cache.GetResource("Material", "Materials/Pixel.xml");
  Quaternion q4 = Quaternion();
  q4.FromAngleAxis(180.0,Vector3(0.0,1.0,0.0));
  c4.Rotate( q4 );//q2.FromAngleAxis(90.0,Vector3(0.0,1.0,0.0)) );
  c4.position=Vector3(24.0,0.0,-16.0);

  //pickups
  Node@ pu1 = spawn_object("Pickup",Vector3(-15.0f,0.0f,-5.0f) );
  Node@ pu2 = spawn_object("Pickup",Vector3(-5.0f,0.0f,-5.0f) );
  Node@ pu3 = spawn_object("Pickup",Vector3(5.0f,2.0f,-5.0f) );
  Node@ pu4 = spawn_object("Pickup",Vector3(15.0f,2.0f,-5.0f) );

  StaticModel@ sm1 = pu1.GetComponent("StaticModel");
  sm1.model = cache.GetResource("Model", "Models/1.mdl");
  sm1.material = cache.GetResource("Material", "Materials/Pixel.xml");//cache.GetResource("Material", "Materials/Stone.xml");
  PickupWeapon1@ pu1_script_ = cast<PickupWeapon1>(pu1.CreateScriptObject(scriptFile, "PickupWeapon1"));
  sm1.castShadows = true;

  StaticModel@ sm2 = pu2.GetComponent("StaticModel");
  sm2.model = cache.GetResource("Model", "Models/2.mdl");
  sm2.material = cache.GetResource("Material", "Materials/Pixel.xml");//cache.GetResource("Material", "Materials/Stone.xml");
  sm2.castShadows = true;

  PickupWeapon2@ pu2_script_ = cast<PickupWeapon2>(pu2.CreateScriptObject(scriptFile, "PickupWeapon2"));

  StaticModel@ sm3 = pu3.GetComponent("StaticModel");
  sm3.model = cache.GetResource("Model", "Models/3.mdl");
  sm3.material = cache.GetResource("Material", "Materials/Pixel.xml");//cache.GetResource("Material", "Materials/Stone.xml");
  sm3.castShadows = true;

  StaticModel@ sm4 = pu4.GetComponent("StaticModel");
  sm4.model = cache.GetResource("Model", "Models/4.mdl");
  sm4.material = cache.GetResource("Material", "Materials/Pixel.xml");//cache.GetResource("Material", "Materials/Stone.xml");
  sm4.castShadows = true;

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
  XMLFile@ xml = cache.GetResource("XMLFile", "Scripts/nodes/" + otype + ".xml");
  return scene_.InstantiateXML(xml, pos, ori);
}

//--------------------

//the container to move the whol scene
class Container:ScriptObject{
  Vector2 bounds_ = Vector2(24.0f,16.0f);
  void FixedUpdate(float timeStep){
    //node.position = node.position+Vector3(0.0f,0.0f,0.75f*timeStep);
  }
}
