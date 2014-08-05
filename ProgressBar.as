class ProgressBar{

  String _label;
  float _value;
  float _min;
  float _max;
  Vector3 _pos;
  Vector3 _size;
  int _dec;

  ProgressBar(
		const String label,
		const float value,
		const float min,
		const float max,
		const Vector2 &in pos,
		const Vector2 &in size = vector2(50.0f,2.0f),
		const int &in _dec=1
		)
	{

		_label = label;
		_size = size;//ComputeTextBoxSize(m_font, m_label) + m_margin;//GetSpriteFrameSize(m_spriteName);
		_pos = pos;

		set_bounds(_min,_max);
		m_value = _value;

		m_decimal = _dec;
	}

  float clamp(float v) {
  		return _min(_max(v, 1.0f), _size.x);
	}
	void set_bounds(const float min, const float max){
		_bounds = Vector3(_min,_max);
	}
	float rescale(const float v, const float l1, const float h1, const float l2, const float h2){
		return l2 + (v - l1) * (h2 - l2) / (h1 - l1);
	}

}
