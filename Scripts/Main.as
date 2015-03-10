#include "Scripts/core/SceneManager.as"
#include "Scripts/core/InputPlayer.as"
#include "Scripts/core/Character.as"
#include "Scripts/core/CameraLogic.as"

#include "Scripts/pickups/PickupWeapon1.as"
#include "Scripts/pickups/PickupWeapon2.as"

#include "Scripts/enemies/Factory.as"
#include "Scripts/enemies/HexHive.as"

#include "Scripts/stages/CrystalCanyon.as"
#include "Scripts/core/AnimatedSprite.as"

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

  //Node@ test_ = scene_.CreateChild("test");
  //AnimatedSprite@ asso = cast<AnimatedSprite>(test_.CreateScriptObject(scriptFile,"AnimatedSprite"));
  //asso.set_parameters("explosion_01");
  //test_.Scale(3.0f);

  Node@ stage_ = scene_.CreateChild("Stage");
  CrystalCanyon@ ccso = cast<CrystalCanyon>(stage_.CreateScriptObject(scriptFile,"CrystalCanyon"));

  scene_manager_.set_camera_target(container_);

  input_player_.set_scene_manager(scene_manager_);
  input_player_.set_controlnode(player_);
  input_player_.set_cameranode(camera_node_);

  //enemy
  Node@ en = container_.CreateChild("factory");
  Factory@ ef = cast<Factory>(en.CreateScriptObject(scriptFile, "Factory"));
  ef.generate_enemy_factory(Vector3(5.0f,0.0f,26.0f),5,3.0f,"Enemy","Weapon","Behavior",3.0f,0,1.0f);

  //TES ENEMY
  Node@ hhn = container_.CreateChild("hexhive");
  HexHive@ hh = cast<HexHive>(hhn.CreateScriptObject(scriptFile, "HexHive"));
  hh.set_parameters("","",1.0,Vector3(8.0,0.0,8.0));

  //my material to use
  Material@ usemat = cache.GetResource("Material", "Materials/Pixel.xml");

  //corners
  Node@ c1 = scene_.CreateChild("Corner");
  StaticModel@ c1m = c1.CreateComponent("StaticModel");
  c1m.model = cache.GetResource("Model", "Models/corner.mdl");
  Material@ matc1 = usemat.Clone();
  Color colc1 = Color(Random(1.0f),Random(1.0f),Random(1.0f),1.0f);
  matc1.shaderParameters["ObjectColor"]=Variant(colc1);//single quotes didnt work
  matc1.shaderParameters["ObjectBlend"]=Variant(0.5f);
  c1m.material = matc1;
  c1.position=Vector3(-24.0,0.0,20.0);

  Node@ c2 = scene_.CreateChild("Corner");
  StaticModel@ c2m = c2.CreateComponent("StaticModel");
  c2m.model = cache.GetResource("Model", "Models/corner.mdl");
  Material@ matc2 = usemat.Clone();
  Color colc2 = Color(Random(1.0f),Random(1.0f),Random(1.0f),1.0f);
  matc2.shaderParameters["ObjectColor"]=Variant(colc2);//single quotes didnt work
  matc2.shaderParameters["ObjectBlend"]=Variant(0.5f);
  c2m.material = matc2;
  Quaternion q2 = Quaternion();
  q2.FromAngleAxis(90.0,Vector3(0.0,1.0,0.0));
  c2.Rotate( q2 );//q2.FromAngleAxis(90.0,Vector3(0.0,1.0,0.0)) );
  c2.position=Vector3(24.0,0.0,20.0);

  Node@ c3 = scene_.CreateChild("Corner");
  StaticModel@ c3m = c3.CreateComponent("StaticModel");
  c3m.model = cache.GetResource("Model", "Models/corner.mdl");
  Material@ matc3 = usemat.Clone();
  Color colc3 = Color(Random(1.0f),Random(1.0f),Random(1.0f),1.0f);
  matc3.shaderParameters["ObjectColor"]=Variant(colc3);//single quotes didnt work
  matc3.shaderParameters["ObjectBlend"]=Variant(0.5f);
  c3m.material = matc3;
  Quaternion q3 = Quaternion();
  q3.FromAngleAxis(-90.0,Vector3(0.0,1.0,0.0));
  c3.Rotate( q3 );//q2.FromAngleAxis(90.0,Vector3(0.0,1.0,0.0)) );
  c3.position=Vector3(-24.0,0.0,-16.0);

  Node@ c4 = scene_.CreateChild("Corner");
  StaticModel@ c4m = c4.CreateComponent("StaticModel");
  c4m.model = cache.GetResource("Model", "Models/corner.mdl");
  Material@ matc4 = usemat.Clone();
  Color colc4 = Color(Random(1.0f),Random(1.0f),Random(1.0f),1.0f);
  matc4.shaderParameters["ObjectColor"]=Variant(colc4);//single quotes didnt work
  matc4.shaderParameters["ObjectBlend"]=Variant(0.5f);
  c4m.material = matc4;
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
  Material@ matsm1 = usemat.Clone();
  Color colsm1 = Color(Random(1.0f),Random(1.0f),Random(1.0f),1.0f);
  matsm1.shaderParameters["ObjectColor"]=Variant(colsm1);//single quotes didnt work
  matsm1.shaderParameters["ObjectBlend"]=Variant(0.8f);
  sm1.material = matsm1;
  PickupWeapon1@ pu1_script_ = cast<PickupWeapon1>(pu1.CreateScriptObject(scriptFile, "PickupWeapon1"));
  sm1.castShadows = true;

  StaticModel@ sm2 = pu2.GetComponent("StaticModel");
  sm2.model = cache.GetResource("Model", "Models/2.mdl");
  Material@ matsm2 = usemat.Clone();
  Color colsm2 = Color(Random(1.0f),Random(1.0f),Random(1.0f),1.0f);
  matsm2.shaderParameters["ObjectColor"]=Variant(colsm2);//single quotes didnt work
  matsm2.shaderParameters["ObjectBlend"]=Variant(0.8f);
  sm2.material = matsm1;
  sm2.castShadows = true;

  PickupWeapon2@ pu2_script_ = cast<PickupWeapon2>(pu2.CreateScriptObject(scriptFile, "PickupWeapon2"));

  StaticModel@ sm3 = pu3.GetComponent("StaticModel");
  sm3.model = cache.GetResource("Model", "Models/3.mdl");
  Material@ matsm3 = usemat.Clone();
  Color colsm3 = Color(Random(1.0f),Random(1.0f),Random(1.0f),1.0f);
  matsm3.shaderParameters["ObjectColor"]=Variant(colsm3);//single quotes didnt work
  matsm3.shaderParameters["ObjectBlend"]=Variant(0.8f);
  sm3.material = matsm1;
  sm3.castShadows = true;

  StaticModel@ sm4 = pu4.GetComponent("StaticModel");
  sm4.model = cache.GetResource("Model", "Models/4.mdl");
  Material@ matsm4 = usemat.Clone();
  Color colsm4 = Color(Random(1.0f),Random(1.0f),Random(1.0f),1.0f);
  matsm4.shaderParameters["ObjectColor"]=Variant(colsm4);//single quotes didnt work
  matsm4.shaderParameters["ObjectBlend"]=Variant(0.8f);
  sm4.material = matsm1;
  sm4.castShadows = true;

  // Create a point light to the world. Enable cascaded shadows on it
  Node@ lightNode = player_.CreateChild("Light");
  //lightNode.direction = Vector3(0.6f, -0.5f, 0.8f);
  lightNode.position = Vector3(0.0f,-60.0f,40.0f);
  Light@ light = lightNode.CreateComponent("Light");
  light.lightType = LIGHT_POINT;
  light.castShadows = true;
  light.range = 100.0f;
  light.brightness = 0.9f;
  //light.shadowBias = BiasParameters(0.00025f, 0.5f);
  // Set cascade splits at 10, 50 and 200 world units, fade shadows out at 80% of maximum shadow distance
  light.shadowCascade = CascadeParameters(10.0f, 50.0f, 200.0f, 0.0f, 0.8f);

  // Create a directional light to the world. Enable cascaded shadows on it
  Node@ lightNode2 = container_.CreateChild("Light Directional");
  lightNode2.direction = Vector3(0.1f, -0.5f, 0.2f);
  Light@ light2 = lightNode2.CreateComponent("Light");
  light2.brightness = 0.5f;
  light2.lightType = LIGHT_DIRECTIONAL;
  light2.castShadows = true;
  light2.shadowBias = BiasParameters(0.00025f, 0.5f);
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
