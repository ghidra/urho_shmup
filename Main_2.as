#include "Scripts/Utilities/Sample.as"

Scene@ _scene;
Node@ _cameraNode;

float yaw = 0.0f;
float pitch = 0.0f;

Vector3 _hitpos;

void Start(){
  SampleStart();
  CreateScene();
  CreateUI();
  CreateText();// Create "Hello World" Text

  SetupViewport();
  SubscribeToEvents();// Finally, hook-up this HelloWorld instance to handle update events
}

void CreateScene(){
  _scene = Scene();

  _scene.CreateComponent("Octree");// Create octree, use default volume (-1000, -1000, -1000) to (1000, 1000, 1000)
  _scene.CreateComponent("DebugRenderer");// Also create a DebugRenderer component so that we can draw debug geometry

  // Create scene node & StaticModel component for showing a static plane
  /*Node@ planeNode = _scene.CreateChild("Plane");
  planeNode.scale = Vector3(100.0f, 1.0f, 100.0f);
  StaticModel@ planeObject = planeNode.CreateComponent("StaticModel");
  planeObject.model = cache.GetResource("Model", "Models/Plane.mdl");
  planeObject.material = cache.GetResource("Material", "Materials/StoneTiled.xml");*/

  // Create a directional light to the world. Enable cascaded shadows on it
  Node@ lightNode = _scene.CreateChild("DirectionalLight");
  lightNode.direction = Vector3(0.6f, -1.0f, 0.8f);
  Light@ light = lightNode.CreateComponent("Light");
  light.lightType = LIGHT_DIRECTIONAL;
  light.castShadows = true;
  light.shadowBias = BiasParameters(0.00025f, 0.5f);
  // Set cascade splits at 10, 50 and 200 world units, fade shadows out at 80% of maximum shadow distance
  light.shadowCascade = CascadeParameters(10.0f, 50.0f, 200.0f, 0.0f, 0.8f);

  //this is going to be my graph node
  //I should make the graph node make both the custom geo and make the script object,
  //inside of the child that it creates also
  //maybe, maybe that isnt such a good idea
  //then i need to find a way to get access to the custom geo, because they are going to be on the same level
  Node@ graphNode = _scene.CreateChild("Graph");
  //CustomGeometry@ graphGeo = graphNode.CreateComponent("CustomGeometry");
  Graph@ graph = cast<Graph>(graphNode.CreateScriptObject(scriptFile, "Graph"));
  graph.SetParameters();

  _cameraNode = _scene.CreateChild("Camera");
  Camera@ camera = _cameraNode.CreateComponent("Camera");
  camera.farClip = 300.0f;

  // Set an initial position for the camera scene node above the plane
  _cameraNode.position = Vector3(0.0f, 5.0f, -5.0f);
}

void CreateUI()
{
    // Create a Cursor UI element because we want to be able to hide and show it at will. When hidden, the mouse cursor will
    // control the camera, and when visible, it will point the raycast target
    XMLFile@ style = cache.GetResource("XMLFile", "UI/DefaultStyle.xml");
    Cursor@ cursor = Cursor();
    cursor.SetStyleAuto(style);
    ui.cursor = cursor;
    // Set starting position of the cursor at the rendering window center
    cursor.SetPosition(graphics.width / 2, graphics.height / 2);

    // Construct new Text object, set string to display and font to use
    Text@ instructionText = ui.root.CreateChild("Text");
    instructionText.text =
        "Use WASD keys to move, RMB to rotate view\n"
        "LMB to set destination, SHIFT+LMB to teleport\n"
        "MMB to add or remove obstacles\n"
        "Space to toggle debug geometry";
    instructionText.SetFont(cache.GetResource("Font", "Fonts/Anonymous Pro.ttf"), 15);
    // The text has multiple rows. Center them in relation to each other
    instructionText.textAlignment = HA_CENTER;

    // Position the text relative to the screen center
    instructionText.horizontalAlignment = HA_CENTER;
    instructionText.verticalAlignment = VA_CENTER;
    instructionText.SetPosition(0, ui.root.height / 4);
}

void SetupViewport(){
    // Set up a viewport to the Renderer subsystem so that the 3D scene can be seen
    Viewport@ viewport = Viewport(_scene, _cameraNode.GetComponent("Camera"));
    renderer.viewports[0] = viewport;
}

void CreateText(){
  Text@ helloText = Text();// Construct new Text object
  helloText.text = "grid class loaded";// Set String to display
  helloText.SetFont(cache.GetResource("Font", "Fonts/Anonymous Pro.ttf"), 30);// Set font and text color
  helloText.color = Color(0.0f, 1.0f, 0.0f);
  helloText.horizontalAlignment = HA_CENTER;  // Align Text center-screen
  helloText.verticalAlignment = VA_CENTER;
  ui.root.AddChild(helloText);// Add Text instance to the UI root element
}
//void BuildGraph(){
  //_grid = grid();
  ////_grid.set_scene(_scene);
//}

void MoveCamera(float timeStep){
    // Right mouse button controls mouse cursor visibility: hide when pressed
    ui.cursor.visible = !input.mouseButtonDown[MOUSEB_RIGHT];

    // Do not move if the UI has a focused element (the console)
    if (ui.focusElement !is null)
        return;

    // Movement speed as world units per second
    const float MOVE_SPEED = 20.0f;
    // Mouse sensitivity as degrees per pixel
    const float MOUSE_SENSITIVITY = 0.1f;

    // Use this frame's mouse motion to adjust camera node yaw and pitch. Clamp the pitch between -90 and 90 degrees
    // Only move the camera when the cursor is hidden
    if (!ui.cursor.visible){
        IntVector2 mouseMove = input.mouseMove;
        yaw += MOUSE_SENSITIVITY * mouseMove.x;
        pitch += MOUSE_SENSITIVITY * mouseMove.y;
        pitch = Clamp(pitch, -90.0f, 90.0f);

        // Construct new orientation for the camera scene node from yaw and pitch. Roll is fixed to zero
        _cameraNode.rotation = Quaternion(pitch, yaw, 0.0f);
    }

    // Read WASD keys and move the camera scene node to the corresponding direction if they are pressed
    if (input.keyDown['W'])
        _cameraNode.Translate(Vector3(0.0f, 0.0f, 1.0f) * MOVE_SPEED * timeStep);
    if (input.keyDown['S'])
        _cameraNode.Translate(Vector3(0.0f, 0.0f, -1.0f) * MOVE_SPEED * timeStep);
    if (input.keyDown['A'])
        _cameraNode.Translate(Vector3(-1.0f, 0.0f, 0.0f) * MOVE_SPEED * timeStep);
    if (input.keyDown['D'])
        _cameraNode.Translate(Vector3(1.0f, 0.0f, 0.0f) * MOVE_SPEED * timeStep);

    //if (input.mouseButtonPress[MOUSEB_LEFT])
      //  SetPathPoint();
}


void SubscribeToEvents(){
  SubscribeToEvent("Update", "HandleUpdate");// Subscribe HandleUpdate() function for processing update events
  SubscribeToEvent("PostRenderUpdate", "HandlePostRenderUpdate");
}

void HandleUpdate(StringHash eventType, VariantMap& eventData){
  float timeStep = eventData["TimeStep"].GetFloat();
  MoveCamera(timeStep);
}
void HandlePostRenderUpdate(StringHash eventType, VariantMap& eventData){
  //DebugRenderer@ debug = _scene.debugRenderer;
  //debug.AddBoundingBox( BoundingBox(_hitpos - Vector3(0.2f,0.2f,0.2f), _hitpos + Vector3(0.2f,0.2f,0.2f)) ,Color(1.0f, 0.0f, 0.0f));
  //_grid.draw();
}


//--------------------
