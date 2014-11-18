//right now this is just to visualize the noise, on an array
//of boxes in the scene
#include "Scripts/outlyer/Perlin.as"

class Stage{
  private uint xdiv_;//we need this valus, cause in update we are looking for it to have something
  private uint ydiv_;
  private float width_;
  private float height_;
  private Vector3 offset_;

  Array<Vector3> points_;

  Perlin@ noise_;

  Node@ node_;

  Stage( Scene@ scene, uint xdiv=10,uint ydiv=10,float width=1.2f,float height=1.2f ){

    node_ = scene.CreateChild("Stage");

    xdiv_ = xdiv;
    ydiv_ = ydiv;
    width_ = width*xdiv;
    height_ = height*xdiv;
    offset_ = Vector3(width_/2.0f,0.0f,height_/2.0f);
    //xstep_ = width/(xdiv-1.0f);
    //step_ = height/(ydiv-1.0f);

    noise_ = Perlin();

    construct_grid();//build the grid
  }

  void construct_grid(){


    //StaticModel@ boxObject = node_.CreateComponent("StaticModel");
    //boxObject.model = cache.GetResource("Model", "Models/Box.mdl");
    //boxObject.material = cache.GetResource("Material", "Materials/StoneTiled.xml");

    for (uint i = 0; i < xdiv_*ydiv_; i++){
        float px = (i%((xdiv_)*1.0f)) * (width_/(xdiv_-1.0f));//x = modulo count by xdiv * width / xdiv-1
        float py = Floor(i/(xdiv_*1.0f)) * (height_/(ydiv_-1.0f));//floor((y*1.0f)/(m_ydiv*1.0f)) * (m_height/(m_ydiv*1.0f));//y = floor(y/ ydiv) * (ydiv/height)
        Vector3 p(px,0.0f,py);
        points_.Push( p-offset_ );
        //_points.Push( multiply(p,m_isomatrix) );//go ahead and multiply into iso style here as well

        Node@ boxnode = node_.CreateChild("box");
        StaticModel@ boxObject = boxnode.CreateComponent("StaticModel");
        boxObject.model = cache.GetResource("Model", "Models/Box.mdl");
        boxObject.material = cache.GetResource("Material", "Materials/StoneTiled.xml");

        Vector3 n = p-offset_;
        float scl = 0.08f;

        float nx = noise_.simplex3(n.x,n.y,n.z,scl,scl,scl);
        float ny = noise_.simplex3(n.x,n.y,n.z,scl,scl,scl);
        float nz = noise_.simplex3(n.x,n.y,n.z,scl,scl,scl);

        boxnode.position = Vector3(n.x,ny,n.z);
    }


    return;
  }
}
