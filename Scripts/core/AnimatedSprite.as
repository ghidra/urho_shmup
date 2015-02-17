#include "Scripts/core/Actor.as"

shared class AnimatedSprite:Actor{
//shared class AnimatedSprite:ScriptObject{
  //Vector2 sheet_;

  //String material_ = "AnimatedSprite";
  uint offset_ = 0;
  StaticModel@ sm_;

  AnimatedSprite(){
    material_ = "AnimatedSprite";
  }

  void set_parameters(const String&in material, const float&in speed = 1.0f, const uint&in offset=0){
    material_=material;
    //sheet_=sheet;
    speed_=speed;
    offset_=offset;
    //i guess I could also set the grid geo and set it to either center or offset
    //also set the scale of the geo, and control it viewing the camera at all times

    sm_ = node.CreateComponent("StaticModel");
    sm_.model = cache.GetResource("Model", "Models/Plane.mdl");

    Material@ usemat = cache.GetResource("Material", "Materials/"+material_+".xml");
    //mesh_material_ = usemat.Clone();
    //Color col = Color(Random(1.0f),Random(1.0f),Random(1.0f),1.0f);
    sm_.material = usemat;
    node.Scale(4.0f);

  }

  void FixedUpdate(float timeStep){
    Actor::FixedUpdate(timeStep);//update time increment
    Material@ mat = sm_.materials[0];
    mat.shaderParameters["Time"]=Variant(timeIncrement_);
  }

}
