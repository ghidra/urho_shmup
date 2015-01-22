class CameraLogic : ScriptObject{

  float follow_distance_;
  Vector3 follow_rotation_;
  bool fixed_;

  Vector3 out_ = Vector3(0.0f,0.0f,-1.0f);
  //Quaternion _rotation;
  Quaternion boom_rotation_;

  Vector3 boom_pos_;//where the camera wants to be, after getting _out and _rotation and _follow_distance
  Vector3 pos_;//the calculated position based on the target

  //offset rotations
  float yaw = 0.0f;
  float pitch = 0.0f;

  Quaternion rotation_offset_;

  Node@ target_;

  void set_parameters( bool fixed = true,float fdistance = 24.0f, Vector3 frotation = Vector3(30.0f,0.0f,0.0f) ){

    //_target = target;

    fixed_ = fixed;
    follow_distance_ = fdistance;
    follow_rotation_ = frotation;

    //I could create a camera here, but i think i'll keep that out of here
    //Camera@ camera = node.CreateComponent("Camera");
    //camera.farClip = 300.0f;

    boom_rotation_.FromEulerAngles(frotation.x,frotation.y,frotation.z);
    //_rotation = _boom_rotation.Inverse();

    boom_pos_ = boom_rotation_*out_*fdistance;

  }

  void set_target( Node@ target ){
    target_ = target;
  }

  void set_position(){
    if(target_ is null)
      return;

    //_pos = _target.rotation*_boom_pos;
    pos_ = boom_pos_;
    pos_ += target_.position;

    node.position = pos_;
    node.rotation = rotation_offset_*boom_rotation_;
  }

  void FixedUpdate(float timeStep){
    set_position();
  }

  //---------------
  void move_mouse(IntVector2 mousemove, float sensitivity){
    yaw += sensitivity * mousemove.x;
    pitch += sensitivity * mousemove.y;
    pitch = Clamp(pitch, -90.0f, 90.0f);
    rotation_offset_ = Quaternion(pitch, yaw, 0.0f);
  }

}
