class Pawn{
    Node@ node_;
    Scene@ scene_;
    Node@ enemytarget_;//this is a target that we might want to aim at
    //String _node_name;
    //Controller@ _controller;
    Pawn(Scene@ scene,String node_name ){
      scene_ = scene;

      node_ = scene_.CreateChild(node_name);
      //_node_name = node_name;

      StaticModel@ coneObject = node_.CreateComponent("StaticModel");
      coneObject.model = cache.GetResource("Model", "Models/Cone.mdl");
      coneObject.material = cache.GetResource("Material", "Materials/StoneTiled.xml");
    }

    //setters
    void set_position(Vector3 pos){
      node_.position = pos;
    }

    void set_enemytarget(Node@ target){
      enemytarget_ = target;
    }
}
