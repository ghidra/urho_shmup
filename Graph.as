class Graph{
//class Graph{
	//basic dimensions
	private uint xdiv_;//we need this valus, cause in update we are looking for it to have something
	private uint ydiv_;
	private float width_;
	private float height_;
	private Vector3 offset_;
	private float xstep_;//the distance between x divisions
	private float ystep_;

	Array<Vector3> points_;//points that make up the grid
	Array<Array<uint>> lines_;//linear lines that make up the division, very basic outline

	Array<graph_center@> centers_;
  Array<graph_corner@> corners_;
  Array<graph_edge@> edges_;

	//uint _geo_id;//the id of the geo component, that we are associated with
	Scene@ scene_;
	Node@ node_;
	CustomGeometry@ geo_;
	Node@ camera_node_;

	Vector3 hit_;

	Graph( Scene@ scene, Node@ camera_node, uint xdiv=10,uint ydiv=10,float width=100.0f,float height=100.0f ){
	//void SetParameters(uint xdiv,uint ydiv,float width,float height ){
		scene_ = scene;
		camera_node_ = camera_node;

		xdiv_ = xdiv;
		ydiv_ = ydiv;
		width_ = width;
		height_ = height;
		offset_ = Vector3(width/2.0f,0.0f,height/2.0f);
		xstep_ = width/(xdiv-1.0f);
		ystep_ = height/(ydiv-1.0f);

		node_ = scene_.CreateChild("Graph");//make the node at the scene level
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
		for (uint i = 0; i < xdiv_*ydiv_; i++){
				float px = (i%((xdiv_)*1.0f)) * (width_/(xdiv_-1.0f));//x = modulo count by xdiv * width / xdiv-1
				float py = Floor(i/(xdiv_*1.0f)) * (height_/(ydiv_-1.0f));//floor((y*1.0f)/(m_ydiv*1.0f)) * (m_height/(m_ydiv*1.0f));//y = floor(y/ ydiv) * (ydiv/height)
				Vector3 p(px,0.0f,py);
				points_.Push( p-offset_ );
				//_points.Push( multiply(p,m_isomatrix) );//go ahead and multiply into iso style here as well
		}
		//now i need to get the horizontal lines
		for(uint i = 0; i < ydiv_; i++){
			Array<uint> p = {(i*xdiv_),((i+1)*xdiv_)-1};
			lines_.Push(p);
		}
		//now i need to get the vertical lines to draw
		for (uint i = 0; i < xdiv_; i++){
			Array<uint> p = {i,((xdiv_*ydiv_)*1)-((xdiv_-i)*1)};
			lines_.Push(p);
		}
	}

	void construct_graph(){
		int nx = xdiv_-1;
    int ny = ydiv_-1;

    int off = 0;
    int offb = 0;

		int x = int(xdiv_);
		int y = int(ydiv_);

    //each grid point is actually a corner
    for( int i = 0; i < int(points_.length); i++ ){
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

      corners_.Push( graph_corner( i,touches_ids,protrudes_ids,adjacent_ids,border_test ) );//add basic center
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
			Vector3 add = points_[p0] + points_[p1] + points_[p2] + points_[p3];//center
      //determine if its a border
      bool border_test = ( i<nx || i%nx == nx-1 || i%nx == 0 || i>(nx*ny)-nx );

			//centers.insertLast( graph_center( centers.length(),add/4.0f, corn ) );//add basic center
			centers_.Push( graph_center( centers_.length,add/4.0f, corner_ids, neighbor_ids, border_ids,border_test ) );//add basic center

			//edges
      //test if they are an edge
      bool vtop_border_test = ( p0<x );
      bool vleft_border_test = ( p0%x == 0 );
			//i need to send more data to the edgs, centers and edges next and before
			edges_.Push( graph_edge(edges_.length,v0,d0,vtop_border_test) );
			edges_.Push( graph_edge(edges_.length,v1,d1,vleft_border_test) );
			//this does not get the edges on the far right
			//and very bottom
		}
	}
	//-----------------
	void construct_geo(){
		geo_ = node_.CreateComponent("CustomGeometry");
		//now build the actual geo for ray casting against later
		geo_.BeginGeometry(0,TRIANGLE_LIST);
		for(uint i = 0; i < centers_.length; i++ ){
			Array<int> corners = centers_[i].corner_ids_;
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

			geo_.DefineVertex( points_[corners[3]] );
			geo_.DefineVertex( points_[corners[1]] );
			geo_.DefineVertex( points_[corners[0]] );
			//second triangle
			geo_.DefineVertex( points_[corners[3]] );
			geo_.DefineVertex( points_[corners[2]] );
			geo_.DefineVertex( points_[corners[1]] );
		}
		geo_.Commit();
		geo_.material = cache.GetResource("Material", "Materials/Transparent.xml");


	}

	//------------------

	void update(StringHash eventType, VariantMap& eventData){
		float timeStep = eventData["TimeStep"].GetFloat();
		DebugRenderer@ debug = scene_.debugRenderer;

		//for raycasting
		//Node@ cameraNode = node.scene.GetNode(_camera_id);
		Camera@ camera = camera_node_.GetComponent("Camera");
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
		for(uint i =0; i < points_.length; ++i){
			debug.AddBoundingBox(bbpoint(node_.transform*points_[i]),Color(1.0f, 1.0f, 1.0f));
		}

		//raycast
		Ray cameraRay = camera.GetScreenRay(float(pos.x) / graphics.width, float(pos.y) / graphics.height );
		RayQueryResult result = scene_.octree.RaycastSingle(cameraRay, RAY_TRIANGLE, 255.0f, DRAWABLE_GEOMETRY);
		if (result.drawable !is null){
			hit_ = result.position;
			debug.AddBoundingBox( bbpoint(hit_) ,Color(1.0f, 0.0f, 0.0f));
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
	int index_;
	bool is_border_; // at the edge of the map
	/*bool water; // lake or ocean
  bool ocean; // ocean
  bool coast; // land polygon touching an ocean
  float elevation; // 0.0-1.0
  float moisture; // 0.0-1.0*/
}

class graph_center : graph_point_data{
   // string biome; // biome type (see article)
  Vector3 position_;

  Array<int> corner_ids_;//i need to just get the ids first, before connecting it to the objects of these objects
  Array<int> neighbor_ids_;
  Array<int> border_ids_;

  //Array<graph_corner@> corners;
  //Array<graph_center@> neighbors;
  //Array<graph_edge@> borders;

  graph_center(const int id, const Vector3 p, const Array<int> c, const Array<int> n, const Array<int> b, const bool bo = false){
  	index_ = id;
    position_ = p;

    corner_ids_ = c;
    neighbor_ids_ = n;
    border_ids_ = b;

    is_border_=bo;
  }
    //void couple(){}
}

class graph_corner : graph_point_data{
	Array<int> touches_ids_;//i need to just get the ids first, before connecting it to the objects of these objects
  Array<int> protrudes_ids_;
  Array<int> adjacent_ids_;

  //Array<graph_center@> touches;
  //Array<graph_edge@> protrudes;
  //Array<graph_corner@> adjacent;

    //int river; // 0 if no river, or volume of water in river
    //graph_corner@ downslope; // pointer to adjacent corner most downhill

  graph_corner(const int id, const Array<int> t, const Array<int> p, const Array<int> a, const bool bo=false){
    	index_ = id;

      touches_ids_ = t;
      protrudes_ids_ = p;
      adjacent_ids_ = a;

      is_border_=bo;
  }
}

class graph_edge : graph_point_data{
	Array<int> voronoi_ids_;
	Array<int> delaunay_ids_;

	graph_corner@ v0_; // Voronoi edge
  graph_corner@ v1_;
  graph_center@ d0_; // Delaunay edge
  graph_center@ d1_;
  //Vector3 midpoint_; // halfway between v0,v1

  //Array<graph_center@> joins;//polys on either side of the voroni edge
  //Array<graph_edge@> continues;//edges to either side // allow perpendicular?  // also know as loop
  //end points are given
  //int river; // volume of water, or 0

  graph_edge(const int id, const Array<int> v, const Array<int> d, const bool bo=false){
  	index_ = id;
    voronoi_ids_ = v;
    delaunay_ids_ = d;

    is_border_=bo;
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
