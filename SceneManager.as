#include "Scripts/outlyer/CameraLogic.as"

class SceneManager{

  Scene@ _scene;
  Node@ _camera_node;
  Viewport@ _viewport;

  SceneManager(){
    Image@ icon = cache.GetResource("Image", "Textures/UrhoIcon.png");
    graphics.windowIcon = icon;
    graphics.windowTitle = "outlyer";
    //---
    // Get default style
    XMLFile@ xmlFile = cache.GetResource("XMLFile", "UI/DefaultStyle.xml");
    if (xmlFile is null)
        return;

    // Create console
    Console@ console = engine.CreateConsole();
    console.defaultStyle = xmlFile;

    // Create debug HUD
    DebugHud@ debugHud = engine.CreateDebugHud();
    debugHud.defaultStyle = xmlFile;

    //create UI
    XMLFile@ style = cache.GetResource("XMLFile", "UI/DefaultStyle.xml");
    Cursor@ cursor = Cursor();
    cursor.SetStyleAuto(style);
    ui.cursor = cursor;
    // Set starting position of the cursor at the rendering window center
    cursor.SetPosition(graphics.width / 2, graphics.height / 2);

    //create scene
    _scene = Scene();
    _scene.CreateComponent("Octree");// Create octree, use default volume (-1000, -1000, -1000) to (1000, 1000, 1000)
    _scene.CreateComponent("DebugRenderer");// Also create a DebugRenderer component so that we can draw debug geometry
    _scene.CreateComponent("PhysicsWorld");

    //create camera
    _camera_node = _scene.CreateChild("Camera");
    Camera@ camera = _camera_node.CreateComponent("Camera");
    camera.farClip = 300.0f;
    CameraLogic@ camera_logic = cast<CameraLogic>(_camera_node.CreateScriptObject(scriptFile,"CameraLogic"));
    camera_logic.set_parameters();

    //create viewport
    _viewport = Viewport(_scene, _camera_node.GetComponent("Camera"));
    renderer.viewports[0] = _viewport;

  }

}
