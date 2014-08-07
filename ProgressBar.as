class ProgressBar{

  String _label;
  float _value;
  float _min;
  float _max;
  Vector2 _bounds;
  Vector3 _offset;
  Vector3 _size;
  float _size_scale = 1.0f;
  int _decimal;

  Scene@ _scene;
  Node@ _node;
  Node@ _fill_node;

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
    _scene = scene;
		_label = label;
    _offset = offset;
		_size = size;//ComputeTextBoxSize(m_font, m_label) + m_margin;//GetSpriteFrameSize(m_spriteName);
		//_pos = pos;

    _min = min;
    _max = max;
		set_bounds(min,max);
		_value = value;

		_decimal = dec;

    //build the bar out
    _node = node.CreateChild("bar");//"maybe call it _node.name"
    StaticModel@ barObject = _node.CreateComponent("StaticModel");
    barObject.model = cache.GetResource("Model", "Models/Box.mdl");
    barObject.material = cache.GetResource("Material", "Materials/StoneTiled.xml");
    _node.position = _offset;
    _node.scale = _size;

    ProgressBar_Script@ _node_script = cast<ProgressBar_Script>(_node.CreateScriptObject(scriptFile, "ProgressBar_Script"));
	  _node_script.set_parameters(this);
  }

  float clamp(float v) {
  		return Min(Max(v, 1.0f), _size.x);
	}
	void set_bounds(const float min, const float max){
		_bounds = Vector2(min,max);
	}
	float rescale(const float v, const float l1, const float h1, const float l2, const float h2){
		return l2 + (v - l1) * (h2 - l2) / (h1 - l1);
	}
  void set_value(float v = 0.0f){
		_value = Min(Max(v,0.0f),_bounds.y);
	}

  void temp(){
    _node.scale = _node.scale*1.001f;
  }

  //-------------

  BoundingBox bbpoint(const Vector3 p,const Vector3 size = Vector3(0.1f,0.1f,0.1f)){
    Vector3 size_pos = size/2.0f;
    return BoundingBox(p - size_pos, p + size_pos);
  }

}

class ProgressBar_Script:ScriptObject{

  ProgressBar@ _parent;

  void Update(float timeStep){
    DebugRenderer@ debug = node.scene.debugRenderer;
    debug.AddBoundingBox( _parent.bbpoint(node.parent.position+_parent._offset,_parent._size) ,Color(1.0f, 1.0f, 0.0f) );

    //correct the position of the bar because of the parents rotation
    node.rotation = Quaternion(node.parent.rotation.Inverse());
    node.position = node.rotation*_parent._offset;

    //now update the bars size based on the value
    _parent._node.scale = _parent._size*Vector3(_parent.rescale(_parent._value,_parent._min,_parent._max,0.0f,1.0f),1.0f,1.0f);
    //use that scale to set the fill to the front of the bar
    node.position = node.position+Vector3( (_parent._node.scale.x/2.0f)-(_parent._size.x/2.0f),0.0f,0.0f);
  }

  void set_parameters(ProgressBar@ parent){
    _parent = parent;
  }
}
