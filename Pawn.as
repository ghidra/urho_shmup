//this is the new pawn, that extends actor that extends the script object. meant to be used by the character and enemy classes
//and anything that needs to be moved i guess, maybe even projectiles later
//this class should house the mean to move an actor, and remove the code from the controler classes
#include "Scripts/shmup/Actor.as"
class Pawn{
  //pawns have a node, and they carry a weapon
  Node@ node_;
  //Weapon@ weapon_;
  Pawn(Scene@ scene, String name){
    node_ = scene.CreateChild(name);
    //weapon_ = Weapon(scene);
  }
}

class Pawn_Script:Actor{

  Node@ enemytarget_;
  Weapon@ weapon_;
  int firing_ = 0;
  float firing_timer_ = 0.0f;//when the firing began, so I can use a timer for interval
  float firing_interval_ = 0.2f;//how often we can fire

  //setters
  void set_position(Vector3 pos){
    node.position = pos;
  }

  void set_enemytarget(Node@ target){
    enemytarget_ = target;
  }
  void set_weapon(Weapon@ weapon){
    weapon_ = weapon;
  }

  //-----

  void move(Vector3 direction, float timestep){
    RigidBody@ body_ = node.GetComponent("RigidBody");
    body_.linearVelocity = body_.linearVelocity+(direction*speed_*timestep);
  }
  void fire(Vector3 target_position,float timestep = 0.0f){
    //Weapon_Script@ weapon = cast<Weapon_Script>(weapon_.weapon_script_.scriptObject);
    //weapon.fire();

    if(firing_<1){//start firing
      firing_=1;
      firing_timer_ = timestep;
      //here i get to use the location on the grid to determine where to fire my projectile
      //Vector3 direction = target_position-node.position;
      //direction.Normalize();
      spawn_projectile(Vector3(0,0,1),target_position);
    }else{//we are firing, we need to shot intermittenly
      firing_timer_+=timestep;
      if(firing_timer_> firing_interval_){//we can shoot again if we are past our interval time
        firing_timer_=0;
        spawn_projectile(Vector3(0,0,1),target_position);
      }
      //firing_=0;
    }
    //i need to toggle all this off on button release some how, otherwise i have to hit the button twise to start again
  }
  void release_fire(){
    firing_=0;
    //firing_timer_=0.0f;
  }

  void spawn_projectile(Vector3 dir, Vector3 hit = Vector3(0.0f,0.0f,0.0f)){
    const float OBJECT_VELOCITY = 4.5f;
    Projectile@ projectile_ = Projectile(node.scene,node.position,dir,OBJECT_VELOCITY,hit);
  }

}
