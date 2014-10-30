//right now this is just to visualize the noise, on an array
//of boxes in the scene
class Stage{
  private uint xdiv_;//we need this valus, cause in update we are looking for it to have something
  private uint ydiv_;
  private float width_;
  private float height_;

  Node@ node_;

  Stage( Scene@ scene, uint xdiv=10,uint ydiv=10,float width=10.0f,float height=10.0f ){

    node_ = scene.CreateChild("Stage");

    xdiv_ = xdiv;
    ydiv_ = ydiv;
    width_ = width;
    height_ = height;
    //offset_ = Vector3(width/2.0f,0.0f,height/2.0f);
    //xstep_ = width/(xdiv-1.0f);
    //step_ = height/(ydiv-1.0f);

    construct_grid();//build the grid
  }

  void construct_grid(){
    StaticModel@ boxObject = node_.CreateComponent("StaticModel");
    boxObject.model = cache.GetResource("Model", "Models/Box.mdl");
    boxObject.material = cache.GetResource("Material", "Materials/StoneTiled.xml");

    return;
  }
}
