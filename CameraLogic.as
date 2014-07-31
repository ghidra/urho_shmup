class CameraLogic : ScriptObject{

  float _follow_distance;
  Vector3 _follow_rotation;
  bool _fixed;

  Vector3 _out = Vector3(0.0f,0.0f,-1.0f);
  //Quaternion _rotation;
  Quaternion _boom_rotation;

  Vector3 _boom_pos;//where the camera wants to be, after getting _out and _rotation and _follow_distance
  Vector3 _pos;//the calculated position based on the target

  //offset rotations
  float yaw = 0.0f;
  float pitch = 0.0f;

  Node@ _target;

  void set_parameters( bool fixed = true,float fdistance = 24.0f, Vector3 frotation = Vector3(30.0f,0.0f,0.0f) ){

    //_target = target;

    _fixed = fixed;
    _follow_distance = fdistance;
    _follow_rotation = frotation;

    //I could create a camera here, but i think i'll keep that out of here
    //Camera@ camera = node.CreateComponent("Camera");
    //camera.farClip = 300.0f;

    _boom_rotation.FromEulerAngles(frotation.x,frotation.y,frotation.z);
    //_rotation = _boom_rotation.Inverse();

    _boom_pos = _boom_rotation*_out*fdistance;

  }

  void set_target( Node@ target ){
    _target = target;
  }

  void set_position(){
    if(_target is null)
      return;

    _pos = _target.rotation*_boom_pos;
    _pos += _target.position;

    node.position = _pos;
    node.rotation = _boom_rotation;
  }

  void Update(float timeStep){
    set_position();
  }

}
