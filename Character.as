//class Character : ScriptObject{
//#include "Scripts/shmup/InputPlayer.as"
#include "Scripts/shmup/Pawn.as"
//#include "Scripts/shmup/ControllerPlayer.as"
#include "Scripts/shmup/Actor.as"
#include "Scripts/shmup/weapons/Weapon.as"
#include "Scripts/shmup/ProjectileExploder.as"
#include "Scripts/shmup/ProjectileNoisy.as"

//class Character : InputPlayer{
class Character:Pawn{

  Character(Scene@ scene){
    super(scene,"Character");

    StaticModel@ coneObject = node_.CreateComponent("StaticModel");
    coneObject.model = cache.GetResource("Model", "Models/Cone.mdl");
    coneObject.material = cache.GetResource("Material", "Materials/StoneTiled.xml");
    //---------------------------

    RigidBody@ body_ = node_.CreateComponent("RigidBody");
    body_.mass = 0.25f;
    body_.friction = 0.75f;
    body_.linearDamping = 0.6f;
    body_.useGravity = false;

    body_.mass=10.0f;//heavy mass makes it so stuff doesnt effect it as much
    //body_.angularDamping = 1000.0f;
    body_.angularFactor = Vector3(0.0f, 0.0f, 0.0f);
    body_.collisionEventMode = COLLISION_ALWAYS;

    CollisionShape@ shape = node_.CreateComponent("CollisionShape");
    shape.SetBox(Vector3(1.0f, 1.0f, 1.0f));

    Character_Script@ character_script_ = cast<Character_Script>(node_.CreateScriptObject(scriptFile, "Character_Script"));
    //Weapon@ weapon = Weapon(scene);
    //character_script_.set_weapon(weapon);
  }

}


class Character_Script:Pawn_Script{

  void Update(float timeStep){
    float my_y = node.position.y;
    if(my_y<0){
      RigidBody@ body_ = node.GetComponent("RigidBody");
      body_.linearVelocity =body_.linearVelocity*Vector3(1.0f,0.0f,1.0f);
      node.position=Vector3(node.position.x,0.0f,node.position.z);
    }
  }
  //projetiles are so far specifically exploder variety
  void spawn_projectile(Vector3 dir, Vector3 hit = Vector3(0.0f,0.0f,0.0f)){
    Vector3 pos = node.position+(dir.Normalized()*1.4f);
    const float OBJECT_VELOCITY = 50.0f;
    //Projectile@ projectile_ = Projectile(node.scene,pos,dir,OBJECT_VELOCITY,hit);
    ProjectileExploder@ projectile_ = ProjectileExploder(node.scene,node.position,dir,OBJECT_VELOCITY,hit);
    //ProjectileNoisy@ projectile_ = ProjectileNoisy(node.scene,node.position,dir,OBJECT_VELOCITY,hit);
  }
}
