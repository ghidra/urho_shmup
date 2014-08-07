#include "Scripts/outlyer/Controller.as"
#include "Scripts/outlyer/ProgressBar.as"

class ControllerEnemyBasic:Controller{

  ProgressBar@ _bar;
  float _bar_regen;

  ControllerEnemyBasic(Scene@ scene, Node@ node){
    super(scene, node);

    //my timer bar, right now for weapons
    _bar = ProgressBar(_scene,_node,"cooldown",Vector3(0.0f,1.2f,0.0f));//use defaults
    _bar_regen = 0.001f;//speed that the bar can regen
    //_bar_node = _scene.CreateChild("bar");//"maybe call it _node.name"
    //
    ControllerEnemyBasic_Script@ _node_script = cast<ControllerEnemyBasic_Script>(_node.CreateScriptObject(scriptFile, "ControllerEnemyBasic_Script"));
    _node_script.set_parameters(this);
  }
  void move(Vector3 direction, float timeStep){
    if(_node is null)
      return;
    _node.Translate(direction*_speed*timeStep);
  }
  void move_mouse(IntVector2 mousemove){
    if(_camera_node is null)
      return;
  }
  void left_mouse(){
    if(_node is null)
      return;
  }
  //----
  void set_cameranode(Node@ cameranode){
    _camera_node = cameranode;
  }
  //----
  //since enemies are controlled by the computer, I need a update function so that they are updated every frame
  //----
}

class ControllerEnemyBasic_Script:ScriptObject{

  ControllerEnemyBasic@ _parent;

  void Update(float timeStep){
    //DebugRenderer@ debug = node.scene.debugRenderer;
    //debug.AddBoundingBox( _parent.bbpoint(node.parent.position+_parent._offset,_parent._size) ,Color(1.0f, 1.0f, 0.0f) );
    //_parent._bar.temp();
    if(_parent._bar._value >= 1.0f){//we can fire a shots, then set it to zero
        _parent._bar.set_value();
    }
    _parent._bar.set_value(_parent._bar._value+_parent._bar_regen);
  }

  void set_parameters(ControllerEnemyBasic@ parent){
    _parent = parent;
  }
}
