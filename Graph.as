class Graph{
//class Graph{
	//basic dimensions
	private uint _xdiv;//we need this valus, cause in update we are looking for it to have something
	private uint _ydiv;
	private float _width;
	private float _height;
	private Vector3 _offset;
	private float _xstep;//the distance between x divisions
	private float _ystep;

	Array<Vector3> _points;//points that make up the grid
	Array<Array<uint>> _lines;//linear lines that make up the division, very basic outline

	Array<graph_center@> _centers;
  Array<graph_corner@> _corners;
  Array<graph_edge@> _edges;

	//uint _geo_id;//the id of the geo component, that we are associated with
	Scene@ _scene;
	Node@ _node;
	CustomGeometry@ _geo;
	Node@ _camera_node;

	Vector3 _hit;

	Graph( Scene@ scene, Node@ camera_node, uint xdiv=10,uint ydiv=10,float width=100.0f,float height=100.0f ){
	//void SetParameters(uint xdiv,uint ydiv,float width,float height ){
		_scene = scene;
		_camera_node = camera_node;

		_xdiv = xdiv;
		_ydiv = ydiv;
		_width = width;
		_height = height;
		_offset = Vector3(width/2.0f,0.0f,height/2.0f);
		_xstep = width/(xdiv-1.0f);
		_ystep = height/(ydiv-1.0f);

		_node = _scene.CreateChild("Graph");//make the node at the scene level
		//Graph_ScriptObject@ graph_scriptobject = cast<Graph>(_node.CreateScriptObject(scriptFile, "Graph_ScriptObject"));//make the scriptobject
		//graph_scriptobject.set_parameters(_camera_node);

		construct_grid();//build the grid
		construct_graph();//build the graph
		construct_geo();//make the custom geo component, and save the link to it
		SubscribeToEvent("Update", "update");
	}

	void construct_grid(){
		//build out the points
		//0,1,2,3,4
		//5,6,7,8,9
		for (uint i = 0; i < _xdiv*_ydiv; i++){
				float px = (i%((_xdiv)*1.0f)) * (_width/(_xdiv-1.0f));//x = modulo count by xdiv * width / xdiv-1
				float py = Floor(i/(_xdiv*1.0f)) * (_height/(_ydiv-1.0f));//floor((y*1.0f)/(m_ydiv*1.0f)) * (m_height/(m_ydiv*1.0f));//y = floor(y/ ydiv) * (ydiv/height)
				Vector3 p(px,0.0f,py);
				_points.Push( p-_offset );
				//_points.Push( multiply(p,m_isomatrix) );//go ahead and multiply into iso style here as well
		}
		//now i need to get the horizontal lines
		for(uint i = 0; i < _ydiv; i++){
			Array<uint> p = {(i*_xdiv),((i+1)*_xdiv)-1};
			_lines.Push(p);
		}
		//now i need to get the vertical lines to draw
		for (uint i = 0; i < _xdiv; i++){
			Array<uint> p = {i,((_xdiv*_ydiv)*1)-((_xdiv-i)*1)};
			_lines.Push(p);
		}
	}

	void construct_graph(){
		int nx = _xdiv-1;
    int ny = _ydiv-1;

    int off = 0;
    int offb = 0;

		int x = int(_xdiv);
		int y = int(_ydiv);

    //each grid point is actually a corner
    for( int i = 0; i < int(_points.length); i++ ){
    	//determine which polys it touches
    	//determine which edges come off this corner
    	//determine which points are adjacent -- allow diagonals?
      off = i/nx;
      offb = i/x;

      int t0 = ((i-x)%x>0) ? i-x-offb : -1;//this one is creating one when it shouldne at the end of the row
      int t1 = ((i+1)%x>0) ? i-nx-offb : -1;//(t+1%nx>0)? t-nx-offb : -1;
      int t2 = ((i+1)%x>0) ? i-offb : -1;
      int t3 = (i%x>0) ? i-offb-1 : -1;

      int e0 = ( (i+1)%x > 0) ? (i*2)-(offb*2)-(nx*2)+1:-1;
      int e1 = ( (i+1)%x > 0) ? (i*2)-(offb*2) : -1;
      int e2 = ( (i+1)%x > 0) ? e1+1 : -1;
      int e3 = ( (i+1)%x > 0) ? e1-2 : -1;

      int a0 = (i+off%(nx-1)>0) ? i-nx-1 : -1;
      int a1 = ((i+1)%x > 0) ? i+1 : -1;
      int a2 = (i+(x) < x*y) ? i+(nx+1) : -1;
      int a3 = (i%x > 0 ) ? i-1 : -1;//this one is a bit wanky too

      Array<int> touches_ids = {t0,t1,t2,t3};//the centers that are touching to this corner point
      Array<int> protrudes_ids = {e0,e1,e2,e3};//the edges that protrude from this point
      Array<int> adjacent_ids = {a0,a1,a2,a3};//corners that are near // should i include diagonals?

      bool border_test = ( i<x || i%x == x-1 || i%x == 0 || i>(x*y)-x );

      _corners.Push( graph_corner( i,touches_ids,protrudes_ids,adjacent_ids,border_test ) );//add basic center
    }

		//centers
		//this is going to loop for each square, so each NODE, not every point of the grid

		for( int i = 0 ; i < nx*ny ; i++ ){
			off = i/nx;
			//0,1,11,10-0  //1,2,12,11-1  //2,3,13,12-2  //8,9,19,18-8  //10,11,21,20-9  //20,21,31,30-18
			//corner point ids
			int p0 = i + off;
			int p1 = p0+1;
			int p2 = p0+x+1;
			int p3 = p0+x;

			//neighbor center ids
			int n0 = ((i+1)%nx > 0) ? i+1 : -1;
			int n1 = (i+nx < nx*ny) ? i+nx : -1;
			int n2 = (i%nx > 0) ? i-1 : -1;
			//int n3 = (t-nx > 0) ? t-nx : -1;
      int n3 = i-nx;
			//allow diagonals?
			//if so need for more

			//edges, i need to make 2 edges per center point, top edge and left edge
			//also need to make 2 more edges based on the corresponding edge that they cross, some wont have any
			//edge arrays //voronoi edge
			Array<int> v0 = {p0,p1};//top edge
			Array<int> v1 = {p3,p0};//left edge
			//now the dulany edge that crosses, which it may or maynot have
			Array<int> d0 = {n3,i};
			Array<int> d1 = {n2,i};

      //border edges
			int e0 = i*2;
			int e1 = e0+1;
      //these 2 are pulled from 2 different centers, just calculating the edge numbesr they will be based on our system
      int e2 = (i+nx < nx*ny) ? ((nx)*2)+(i*2) : -1;
			int e3 = ((i+1)%nx > 0)? e0+3 : -1;//( t%nx > 0 ) ? e0+3 : -1;
			//int e3 = ( t < (2*(nx-1))*(nx-1) ) ? (t+1)*(2*(nx-1)) : -1;

			Array<int> corner_ids = {p0,p1,p2,p3};//graph_corner@[] corn = {corners[p0],corners[p1],corners[p2],corners[p3]};//sets the squares corner points
			Array<int> neighbor_ids = {n0,n1,n2,n3};//
			Array<int> border_ids = {e0,e1,e2,e3};//edge ids


			//get my center points for each square
			Vector3 add = _points[p0] + _points[p1] + _points[p2] + _points[p3];//center
      //determine if its a border
      bool border_test = ( i<nx || i%nx == nx-1 || i%nx == 0 || i>(nx*ny)-nx );

			//centers.insertLast( graph_center( centers.length(),add/4.0f, corn ) );//add basic center
			_centers.Push( graph_center( _centers.length,add/4.0f, corner_ids, neighbor_ids, border_ids,border_test ) );//add basic center

			//edges
      //test if they are an edge
      bool vtop_border_test = ( p0<x );
      bool vleft_border_test = ( p0%x == 0 );
			//i need to send more data to the edgs, centers and edges next and before
			_edges.Push( graph_edge(_edges.length,v0,d0,vtop_border_test) );
			_edges.Push( graph_edge(_edges.length,v1,d1,vleft_border_test) );
			//this does not get the edges on the far right
			//and very bottom
		}
	}
	//-----------------
	void construct_geo(){
		_geo = _node.CreateComponent("CustomGeometry");
		//now build the actual geo for ray casting against later
		_geo.BeginGeometry(0,TRIANGLE_LIST);
		for(uint i = 0; i < _centers.length; i++ ){
			Array<int> corners = _centers[i]._corner_ids;
			//first triangle
			/*_geo.DefineVertex( _points[corners[0]] );
			//_geo.DefineTexCoord();
			_geo.DefineVertex( _points[corners[1]] );
			//_geo.DefineTexCoord();
			_geo.DefineVertex( _points[corners[3]] );
			//_geo.DefineTexCoord();
			//second triangle
			_geo.DefineVertex( _points[corners[1]] );
			//_geo.DefineTexCoord();
			_geo.DefineVertex( _points[corners[2]] );
			//_geo.DefineTexCoord();
			_geo.DefineVertex( _points[corners[3]] );*/
			//_geo.DefineTexCoord();

			_geo.DefineVertex( _points[corners[3]] );
			_geo.DefineVertex( _points[corners[1]] );
			_geo.DefineVertex( _points[corners[0]] );
			//second triangle
			_geo.DefineVertex( _points[corners[3]] );
			_geo.DefineVertex( _points[corners[2]] );
			_geo.DefineVertex( _points[corners[1]] );
		}
		_geo.Commit();
		_geo.material = cache.GetResource("Material", "Materials/Transparent.xml");


	}

	//------------------

	void update(StringHash eventType, VariantMap& eventData){
		float timeStep = eventData["TimeStep"].GetFloat();
		DebugRenderer@ debug = _scene.debugRenderer;

		//for raycasting
		//Node@ cameraNode = node.scene.GetNode(_camera_id);
		Camera@ camera = _camera_node.GetComponent("Camera");
		//Camera@ camera = node.scene.GetComponent("Camera");
		IntVector2 pos = ui.cursorPosition;

		Vector3 bias(0.0f, 0.05f, 0.0f);

		//which cell we are in
		int cell = -1;

		//-----------------------------------------

		//draw the basic lines
		/*for (uint i = 0; i < _lines.length; ++i){
			Vector3 p0 = _points[_lines[i][0]];
			Vector3 p1 = _points[_lines[i][1]];
			debug.AddLine(p0+bias, p1+bias, Color(1.0f, 1.0f, 1.0f));
		}*/

		//draw corners as boundinboxes
		for(uint i =0; i < _points.length; ++i){
			debug.AddBoundingBox(bbpoint(_points[i]),Color(1.0f, 1.0f, 1.0f));
		}

		//raycast
		Ray cameraRay = camera.GetScreenRay(float(pos.x) / graphics.width, float(pos.y) / graphics.height );
		RayQueryResult result = _scene.octree.RaycastSingle(cameraRay, RAY_TRIANGLE, 255.0f, DRAWABLE_GEOMETRY);
		if (result.drawable !is null){
			_hit = result.position;
			debug.AddBoundingBox( bbpoint(_hit) ,Color(1.0f, 0.0f, 0.0f));
			//cell = ((floor(max(m_isomousepos.x,0.0f)/m_xstep)+1)+( floor(max(m_isomousepos.y,0.0f)/m_ystep)*(m_xdiv-1) ) )-1;
		}




		//-----------------------------------------
		//_geo.DrawDebugGeometry(debug,true);//draws the custom geo, draws a green line around geo


	}
	//-----draw function helpers
	BoundingBox bbpoint(const Vector3 p,const float size = 0.1f){
		return BoundingBox(p - Vector3(size,size,size), p + Vector3(size,size,size));
	}
}

//--------------------------------------
//--------------------------------------
//graph classes


class graph_point_data{
	int _index;
	bool _is_border; // at the edge of the map
	/*bool water; // lake or ocean
  bool ocean; // ocean
  bool coast; // land polygon touching an ocean
  float elevation; // 0.0-1.0
  float moisture; // 0.0-1.0*/
}

class graph_center : graph_point_data{
   // string biome; // biome type (see article)
  Vector3 _position;

  Array<int> _corner_ids;//i need to just get the ids first, before connecting it to the objects of these objects
  Array<int> _neighbor_ids;
  Array<int> _border_ids;

  //Array<graph_corner@> corners;
  //Array<graph_center@> neighbors;
  //Array<graph_edge@> borders;

  graph_center(const int id, const Vector3 p, const Array<int> c, const Array<int> n, const Array<int> b, const bool bo = false){
  	_index = id;
    _position = p;

    _corner_ids = c;
    _neighbor_ids = n;
    _border_ids = b;

    _is_border=bo;
  }
    //void couple(){}
}

class graph_corner : graph_point_data{
	Array<int> _touches_ids;//i need to just get the ids first, before connecting it to the objects of these objects
  Array<int> _protrudes_ids;
  Array<int> _adjacent_ids;

  //Array<graph_center@> touches;
  //Array<graph_edge@> protrudes;
  //Array<graph_corner@> adjacent;

    //int river; // 0 if no river, or volume of water in river
    //graph_corner@ downslope; // pointer to adjacent corner most downhill

  graph_corner(const int id, const Array<int> t, const Array<int> p, const Array<int> a, const bool bo=false){
    	_index = id;

      _touches_ids = t;
      _protrudes_ids = p;
      _adjacent_ids = a;

      _is_border=bo;
  }
}

class graph_edge : graph_point_data{
	Array<int> _voronoi_ids;
	Array<int> _delaunay_ids;

	graph_corner@ _v0; // Voronoi edge
  graph_corner@ _v1;
  graph_center@ _d0; // Delaunay edge
  graph_center@ _d1;
  Vector3 midpoint; // halfway between v0,v1

  //Array<graph_center@> joins;//polys on either side of the voroni edge
  //Array<graph_edge@> continues;//edges to either side // allow perpendicular?  // also know as loop
  //end points are given
  //int river; // volume of water, or 0

  graph_edge(const int id, const Array<int> v, const Array<int> d, const bool bo=false){
  	_index = id;
    _voronoi_ids = v;
    _delaunay_ids = d;

    _is_border=bo;
  }
}

//----------------------
// The Script object for updating
//----------------------

/*class Graph_ScriptObject : ScriptObject{
	private Node@ = _camera_node;
	void set_parameters(Node@ camera_node){
		_camera_node = camera_node;
	}
}*/
