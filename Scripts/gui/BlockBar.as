class BlockBar:ScriptObject{

  Vector3 offset_;
  uint numblocks_;
  Vector3 size_;
  float margin_;
  float value_;
  float max_;
  int decimal_;

  Array<Node@> blocks_;

  String material_ = "Pixel";

  void set_parameters(
    Vector3 offset = Vector3(5.0f,0.0f,0.0f),
    uint blocks = 8,
    Vector3 size = Vector3(4.0f,0.5f,0.1f),
    float margin = 0.2f,
		float value = 1.0f,
		float max = 1.0f,
		int dec=1
		)
	{
    offset_ = offset;
    numblocks_ = blocks;
		size_ = size;
		margin_ = margin;
		value_ = value;
    max_ = max;
		decimal_ = dec;

    //build the bar out
    Node@ main_node = node.CreateChild("bar");//"maybe call it _node.name"

    //i need to loop for each block that I want to make

    //do the math to determine where to place pieces
    float w = (size_.x-((float(numblocks_)-1.0f)*margin_))/float(numblocks_);//this is the resulting size of a block
    for(uint i=0;i<numblocks_;i++){
      Node@ block = main_node.CreateChild("block_"+i);

      block.position = Vector3( (w/2.0f)+(float(i)*(w+margin_)), 0.0f, 0.0f );
      block.scale = Vector3(w,size_.y,size_.z);

      StaticModel@ sm = block.CreateComponent("StaticModel");
      sm.model = cache.GetResource("Model", "Models/Box.mdl");

      Material@ usemat = cache.GetResource("Material", "Materials/"+material_+".xml");
      Material@ mesh_material = usemat.Clone();
      Color col = Color(Random(1.0f),Random(1.0f),Random(1.0f),1.0f);
      mesh_material.shaderParameters["ObjectColor"]=Variant(col);//single quotes didnt work
      sm.material = mesh_material;

      blocks_.Push(block);
    }

    /*fill_node_ = node_.CreateChild("barfill");
    StaticModel@ barObject = fill_node_.CreateComponent("StaticModel");
    barObject.model = cache.GetResource("Model", "Models/Box.mdl");
    barObject.material = cache.GetResource("Material", "Materials/StoneTiled.xml");
    node_.position = offset_;
    node_.scale = size_;

    ProgressBar_Script@ node_script_ = cast<ProgressBar_Script>(node_.CreateScriptObject(scriptFile, "ProgressBar_Script"));
	  node_script_.set_parameters(this);*/
  }

  float clamp(float v) {
  		return Min(Max(v, 1.0f), size_.x);
	}

	float rescale(const float v, const float l1, const float h1, const float l2, const float h2){
		return l2 + (v - l1) * (h2 - l2) / (h1 - l1);
	}
  void set_value(float v = 0.0f){
		value_ = Min(Max(v,0.0f),max_);
	}

  //-------------

  /*BoundingBox bbpoint(const Vector3 p,const Vector3 size = Vector3(0.1f,0.1f,0.1f)){
    Vector3 size_pos = size/2.0f;
    return BoundingBox(p - size_pos, p + size_pos);
  }*/

}

/*class ProgressBar_Script:ScriptObject{

  ProgressBar@ parent_;

  void Update(float timeStep){
    DebugRenderer@ debug = node.scene.debugRenderer;
    debug.AddBoundingBox( parent_.bbpoint(node.parent.position+parent_.offset_,parent_.size_) ,Color(1.0f, 1.0f, 0.0f) );

    //correct the position of the bar because of the parents rotation
    node.rotation = Quaternion(node.parent.rotation.Inverse());
    node.position = node.rotation*parent_.offset_;

    //now update the bars size based on the value
    parent_.fill_node_.scale = Vector3(parent_.rescale(parent_.value_,parent_.min_,parent_.max_,0.0f,1.0f),1.0f,1.0f);
    //parent_.node_.scale = parent_.size_*Vector3(parent_.rescale(parent_.value_,parent_.min_,parent_.max_,0.0f,1.0f),1.0f,1.0f);
    //use that scale to set the fill to the front of the bar
    //node.position = node.position+Vector3( (parent_.node_.scale.x/2.0f)-(parent_.size_.x/2.0f),0.0f,0.0f);
    parent_.fill_node_.position = Vector3( (parent_.fill_node_.scale.x-1)*(parent_.size_.x/2.0f),0.0f,0.0f);
  }

  void set_parameters(ProgressBar@ parent){
    parent_ = parent;
  }
}*/
