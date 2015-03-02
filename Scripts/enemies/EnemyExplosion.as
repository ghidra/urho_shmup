#include "Scripts/core/AnimatedSprite.as"

shared class EnemyExplosion:AnimatedSprite{

  EnemyExplosion(){
    //this just to set the material to use
    material_="explosion_01";
  }
  void Start(){
    //i seem to need to use this function to call the set parameters. I tried to override it, but there were issues.
    set_parameters(material_);
  }
  void set_position(const Vector3 pos){
    //this is my own specificl set parameters, which is basically just set the position
    node.position=pos;
  }


}
