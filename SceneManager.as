#include "Scripts/shmup/CameraLogic.as"

class SceneManager{

  Scene@ scene_;
  Node@ camera_node_;
  Viewport@ viewport_;

  SceneManager(uint i){
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
    scene_ = Scene();
    scene_.CreateComponent("Octree");// Create octree, use default volume (-1000, -1000, -1000) to (1000, 1000, 1000)
    scene_.CreateComponent("DebugRenderer");// Also create a DebugRenderer component so that we can draw debug geometry
    scene_.CreateComponent("PhysicsWorld");

    //create camera
    camera_node_ = scene_.CreateChild("Camera");
    Camera@ camera = camera_node_.CreateComponent("Camera");
    camera.farClip = 300.0f;
    CameraLogic@ camera_logic = cast<CameraLogic>(camera_node_.CreateScriptObject(scriptFile,"CameraLogic"));
    camera_logic.set_parameters();

    //create viewport
    viewport_ = Viewport(scene_, camera_node_.GetComponent("Camera"));
    renderer.viewports[0] = viewport_;

  }

  void set_camera_target(Node@ node){
    CameraLogic@ camera_logic_ = cast<CameraLogic>(camera_node_.GetScriptObject("CameraLogic"));
    camera_logic_.set_target(node);
  }

}
