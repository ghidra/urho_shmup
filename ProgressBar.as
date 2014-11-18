class ProgressBar{

  String label_;
  float value_;
  float min_;
  float max_;
  Vector2 bounds_;
  Vector3 offset_;
  Vector3 size_;
  float size_scale_ = 1.0f;
  int decimal_;

  Scene@ scene_;
  Node@ node_;
  Node@ fill_node_;

  ProgressBar(
    Scene@ scene,
    Node@ node,
		String label,
    Vector3 offset,
		float value = 1.0f,
		float min = 0.0f,
		float max = 1.0f,
		Vector3 size = Vector3(1.4f,0.2f,0.01f),
		int dec=1
		)
	{
    scene_ = scene;
		label_ = label;
    offset_ = offset;
		size_ = size;//ComputeTextBoxSize(m_font, m_label) + m_margin;//GetSpriteFrameSize(m_spriteName);
		//_pos = pos;

    min_ = min;
    max_ = max;
		set_bounds(min,max);
		value_ = value;

		decimal_ = dec;

    //build the bar out
    node_ = node.CreateChild("bar");//"maybe call it _node.name"

    fill_node_ = node_.CreateChild("barfill");
    StaticModel@ barObject = fill_node_.CreateComponent("StaticModel");
    barObject.model = cache.GetResource("Model", "Models/Box.mdl");
    barObject.material = cache.GetResource("Material", "Materials/StoneTiled.xml");
    node_.position = offset_;
    node_.scale = size_;

    ProgressBar_Script@ node_script_ = cast<ProgressBar_Script>(node_.CreateScriptObject(scriptFile, "ProgressBar_Script"));
	  node_script_.set_parameters(this);
  }

  float clamp(float v) {
  		return Min(Max(v, 1.0f), size_.x);
	}
	void set_bounds(const float min, const float max){
		bounds_ = Vector2(min,max);
	}
	float rescale(const float v, const float l1, const float h1, const float l2, const float h2){
		return l2 + (v - l1) * (h2 - l2) / (h1 - l1);
	}
  void set_value(float v = 0.0f){
		value_ = Min(Max(v,0.0f),bounds_.y);
	}

  void temp(){
    node_.scale = node_.scale*1.001f;
  }

  //-------------

  BoundingBox bbpoint(const Vector3 p,const Vector3 size = Vector3(0.1f,0.1f,0.1f)){
    Vector3 size_pos = size/2.0f;
    return BoundingBox(p - size_pos, p + size_pos);
  }

}

class ProgressBar_Script:ScriptObject{

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
}
