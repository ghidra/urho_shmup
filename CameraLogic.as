class CameraLogic : ScriptObject{

  float _follow_distance;
  Vector3 _follow_rotation;
  bool _fixed;

  Vector3 _out = Vector3(0.0f,0.0f,-1.0f);
  Quaternion _rotation;

  Vector3 _pos;//where the camera wants to be, after getting _out and _rotation and _follow_distance

  Node@ _target;

  void set_parameters( Node@ target, bool fixed = true,float fdistance = 10.0f, Vector3 frotation = Vector3(10.0f,0.0f,0.0f) ){

    _target = target;

    _fixed = fixed;
    _follow_distance = fdistance;
    _follow_rotation = frotation;

    //I could create a camera here, but i think i'll keep that out of here
    //Camera@ camera = node.CreateComponent("Camera");
    //camera.farClip = 300.0f;

    _rotation.FromEulerAngles(frotation.x,frotation.y,frotation.z);

    //_pos = _out*_rotation;

  }

}
