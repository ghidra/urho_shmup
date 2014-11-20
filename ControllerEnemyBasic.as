
//OBSOLETE
#include "Scripts/shmup/Controller.as"
#include "Scripts/shmup/ProgressBar.as"
#include "Scripts/shmup/Projectile.as"

class ControllerEnemyBasic:Controller{

  ProgressBar@ bar_;
  float bar_regen_;
  //Projectile@ _projectile;
  Node@ enemytarget_;

  ControllerEnemyBasic(Scene@ scene, Node@ node){
    super(scene, node);

    //my timer bar, right now for weapons
    bar_ = ProgressBar(scene_,node_,"cooldown",Vector3(0.0f,1.2f,0.0f));//use defaults
    bar_regen_ = 0.001f;//speed that the bar can regen
    //_bar_node = _scene.CreateChild("bar");//"maybe call it _node.name"
    //
    ControllerEnemyBasic_Script@ node_script_ = cast<ControllerEnemyBasic_Script>(node_.CreateScriptObject(scriptFile, "ControllerEnemyBasic_Script"));
    node_script_.set_parameters(this);
  }
  void move(Vector3 direction, float timeStep){
    if(node_ is null)
      return;
    node_.Translate(direction*speed_*timeStep);
  }
  void move_mouse(IntVector2 mousemove){
    if(camera_node_ is null)
      return;
  }
  void left_mouse(){
    if(node_ is null)
      return;

    if(enemytarget_ !is null){
      //figure out how to shoot toward the dude
      Vector3 fire_from = node_.position+Vector3(0.0f,0.5f,0.0f);
      Vector3 fire_on = enemytarget_.position;
      Vector3 fire_dir = fire_on-fire_from;

      spawn_projectile(fire_from, fire_dir,4.5f);
    }
  }
  //----
  void set_cameranode(Node@ cameranode){
    camera_node_ = cameranode;
  }
  void set_enemytarget(Node@ target){
    enemytarget_ = target;
  }
  //----
  //since enemies are controlled by the computer, I need a update function so that they are updated every frame
  //----
  void spawn_projectile(Vector3 pos, Vector3 dir,float speed){
    Projectile@ projectile_ = Projectile(scene_,pos,dir,speed);
    //_projectile = Projectile(_scene,pos,dir,OBJECT_VELOCITY);
    //_projectiles.Push( Projectile(_scene,pos,dir,OBJECT_VELOCITY));
  }
}

class ControllerEnemyBasic_Script:ScriptObject{

  ControllerEnemyBasic@ parent_;

  void Update(float timeStep){
    //DebugRenderer@ debug = node.scene.debugRenderer;
    //debug.AddBoundingBox( _parent.bbpoint(node.parent.position+_parent._offset,_parent._size) ,Color(1.0f, 1.0f, 0.0f) );
    //_parent._bar.temp();
    if(parent_.bar_.value_ >= 1.0f){//we can fire a shots, then set it to zero
        parent_.bar_.set_value();
        parent_.left_mouse();
    }
    parent_.bar_.set_value(parent_.bar_.value_+parent_.bar_regen_);
  }

  void set_parameters(ControllerEnemyBasic@ parent){
    parent_ = parent;
  }
}
