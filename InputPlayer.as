#include "Scripts/outlyer/InputBasics.as"
#include "Scripts/outlyer/Controller.as"

class InputPlayer : InputBasics{
//class InputPlayer{

  Controller@ _controller;

  InputPlayer(uint i){
    super(i);
    SubscribeToEvent("Update", "update");
  }

  void update(StringHash eventType, VariantMap& eventData){
    float timeStep = eventData["TimeStep"].GetFloat();
    ui.cursor.visible = !input.mouseButtonDown[MOUSEB_RIGHT];
    Vector3 direction = Vector3(0.0f,0.0f,0.0f);

    // Do not move if the UI has a focused element (the console)
    if (ui.focusElement !is null)
        return;

    // Use this frame's mouse motion to adjust camera node yaw and pitch. Clamp the pitch between -90 and 90 degrees
    // Only move the camera when the cursor is hidden
    if (!ui.cursor.visible){//this makes it update only on right mouse down
      move_mouse(input.mouseMove);
    }

    if (input.mouseButtonPress[MOUSEB_LEFT])
        left_mouse();

    // Read WASD keys and move the camera scene node to the corresponding direction if they are pressed
    if (input.keyDown['W'])
      direction+=Vector3(0.0f, 0.0f, 1.0f);
    if (input.keyDown['S'])
      direction+=Vector3(0.0f, 0.0f, -1.0f);
    if (input.keyDown['A'])
      direction+=Vector3(-1.0f, 0.0f, 0.0f);
    if (input.keyDown['D'])
      direction+=Vector3(1.0f, 0.0f, 0.0f);

    if(direction.length>0.5)
      move(direction.Normalized(),timeStep);

  }
  void set_controller(Controller@ controller){
    _controller = controller;
  }
  //---------what to do with inputs, send to the controller
  void move( Vector3 direction, float timeStep){
    if(_controller is null)
      return;
    _controller.move( direction, timeStep);
  }
  void move_mouse(IntVector2 mousemove){
    if(_controller is null)
      return;
    _controller.move_mouse(mousemove);
  }
  void left_mouse(){
    if(_controller is null)
      return;
    _controller.left_mouse();
  }
}
