class InputBasics{

  InputBasics(uint i = 0){
    SubscribeToEvent("KeyDown", "HandleKeyDown");
  }

  //---------------
  void HandleKeyDown(StringHash eventType, VariantMap& eventData){
    int key = eventData["Key"].GetInt();

    // Close console (if open) or exit when ESC is pressed
    if (key == KEY_ESC){
      if (!console.visible)
        engine.Exit();
      else
        console.visible = false;
    }else if (key == KEY_F1){// Toggle console with F1
      console.Toggle();
    }else if (key == KEY_F2){// Toggle debug HUD with F2
      debugHud.ToggleAll();
    }

    // Common rendering quality controls, only when UI has no focused element
    if (ui.focusElement is null){// Texture quality
      if (key == '1'){
        int quality = renderer.textureQuality;
        ++quality;
        if (quality > QUALITY_HIGH)
          quality = QUALITY_LOW;
        renderer.textureQuality = quality;
      }else if (key == '2'){  // Material quality
        int quality = renderer.materialQuality;
        ++quality;
        if (quality > QUALITY_HIGH)
          quality = QUALITY_LOW;
        renderer.materialQuality = quality;
      }else if (key == '3'){  // Specular lighting
        renderer.specularLighting = !renderer.specularLighting;
      }else if (key == '4'){// Shadow rendering
        renderer.drawShadows = !renderer.drawShadows;
      }else if (key == '5'){// Shadow map resolution
        int shadowMapSize = renderer.shadowMapSize;
        shadowMapSize *= 2;
        if (shadowMapSize > 2048)
          shadowMapSize = 512;
        renderer.shadowMapSize = shadowMapSize;
      }else if (key == '6'){// Shadow depth and filtering quality
        int quality = renderer.shadowQuality;
        ++quality;
        if (quality > SHADOWQUALITY_HIGH_24BIT)
          quality = SHADOWQUALITY_LOW_16BIT;
        renderer.shadowQuality = quality;
      }else if (key == '7'){// Occlusion culling
        bool occlusion = renderer.maxOccluderTriangles > 0;
        occlusion = !occlusion;
        renderer.maxOccluderTriangles = occlusion ? 5000 : 0;
      }else if (key == '8'){// Instancing
        renderer.dynamicInstancing = !renderer.dynamicInstancing;
      }else if (key == '9'){// Take screenshot
        Image@ screenshot = Image();
        graphics.TakeScreenShot(screenshot);
        // Here we save in the Data folder with date and time appended
        screenshot.SavePNG(fileSystem.programDir + "Data/Screenshot_" +
          time.timeStamp.Replaced(':', '_').Replaced('.', '_').Replaced(' ', '_') + ".png");
      }
    }
  }
  //---------------
}
