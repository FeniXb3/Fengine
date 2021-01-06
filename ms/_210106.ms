game210106 = object
  init = function(engine)
    screen.bounds = engine.getScreenBounds()

    gameplay = engine.addGameObject("gameplay")
    gameplay.onButtonPressed = function(data)
      if not this.buttonsPressed[data] then
        this.pressedCount += 1
      end

      this.buttonsPressed[data] = 1

      if this.pressedCount == 16 then
        engine.eventManager.triggerEvent("won", true)
      end
    end

    engine.eventManager.addListener("buttonPressed", "onButtonPressed", gameplay)
    
    boat1 = prepareBoat("boat1", "boat1")
    boat1.position.setTo(Vector2.make(50, 50))
    boat1.number = 1
    engine.inputManager.remap("boat1_left", "A")
    engine.inputManager.remap("boat1_right", "D")
    engine.inputManager.remap("boat1_down", "S")
    engine.inputManager.remap("boat1_up", "W")

    boat2 = prepareBoat("boat2", "boat2")
    boat2.position.setTo(Vector2.make(-50, 50))
    boat2.number = 2
    engine.inputManager.remap("boat2_left", "F")
    engine.inputManager.remap("boat2_right", "H")
    engine.inputManager.remap("boat2_down", "G")
    engine.inputManager.remap("boat2_up", "T")

    boat3 = prepareBoat("boat3", "boat3")
    boat3.position.setTo(Vector2.make(-50, -50))
    boat3.number = 3
    engine.inputManager.remap("boat3_left", "J")
    engine.inputManager.remap("boat3_right", "L")
    engine.inputManager.remap("boat3_down", "K")
    engine.inputManager.remap("boat3_up", "I")

    boat4 = prepareBoat("boat4", "boat4")
    boat4.position.setTo(Vector2.make(50, -50))
    boat4.number = 4
    engine.inputManager.remap("boat4_left", "ARROW_LEFT")
    engine.inputManager.remap("boat4_right", "ARROW_RIGHT")
    engine.inputManager.remap("boat4_down", "ARROW_DOWN")
    engine.inputManager.remap("boat4_up", "ARROW_UP")
    
    winText = engine.addWinTextObject()
    // engine.eventManager.triggerEvent("won", true)
  end
  
  prepareBoat = function(name, spriteName)
    local boat = engine.addGameObject(name)
    boat.addSprite(spriteName)
    boat.speed = 10
    boat.addInputHandler()
      .reactOn(name+"_left", "hold", function()
        this.gameObject.position.changeBy(Vector2.make(-this.gameObject.speed, 0))
        Fengine.getInstance().eventManager.triggerEvent("buttonPressed", this.gameObject.name+"_left")
      end)
      .reactOn(name+"_right", "hold", function()
        this.gameObject.position.changeBy(Vector2.make(this.gameObject.speed, 0))
        Fengine.getInstance().eventManager.triggerEvent("buttonPressed", this.gameObject.name+"_right")
      end)
      .reactOn(name+"_down", "hold", function()
        this.gameObject.position.changeBy(Vector2.make(0, -this.gameObject.speed))
        Fengine.getInstance().eventManager.triggerEvent("buttonPressed", this.gameObject.name+"_down")
      end)
      .reactOn(name+"_up", "hold", function()
        this.gameObject.position.changeBy(Vector2.make(0, this.gameObject.speed))
        Fengine.getInstance().eventManager.triggerEvent("buttonPressed", this.gameObject.name+"_up")
      end)
    
    return boat
  end
end