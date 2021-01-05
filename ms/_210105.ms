game210105 = object
  init = function(engine)
    screen.bounds = engine.getScreenBounds()

    gameplay = engine.addGameObject("gameplay")
    gameplay.addActualExpected(0, 4, function()
        Fengine.getInstance().eventManager.triggerEvent("won", true)
    end)
    gameplay.onItemPressed = function(data)
        local state = this.actualExpected
        if data == state.actual+1 then
            state.changeBy(1)
        else
            state.setTo(0)
            audio.beep("C1")
        end
    end

    engine.eventManager.addListener("itemPressed", "onItemPressed", gameplay)

    
    boat1 = prepareBoat("boat1", "boat1")
    boat1.position.setTo(Vector2.make(50, 50))
    boat1.number = 1
    boat2 = prepareBoat("boat2", "boat2")
    boat2.position.setTo(Vector2.make(-50, 50))
    boat2.number = 2
    boat3 = prepareBoat("boat3", "boat3")
    boat3.position.setTo(Vector2.make(-50, -50))
    boat3.number = 3
    boat4 = prepareBoat("boat4", "boat4")
    boat4.position.setTo(Vector2.make(50, -50))
    boat4.number = 4
    
    winText = engine.addWinTextObject()
    // engine.eventManager.triggerEvent("won", true)
  end
  
  prepareBoat = function(name, spriteName)
    local boat = engine.addGameObject(name)
    boat.addSprite(spriteName)
    boat.addTouchableOnSprite(function() 
        audio.beep("A"+ this.gameObject.number)
        Fengine.getInstance().eventManager.triggerEvent("itemPressed", this.gameObject.number)
    end)
    
    return boat
  end
end