game210102 = object

  init = function(engine)
    screen.bounds = engine.getScreenBounds()
    
    water = prepareMap("sea", Vector2.make(2, 2), 0.8)
    water.addTouchableOnMap(function()
        Fengine.getInstance().eventManager.triggerEvent("goToSea", Vector2.make(touch.x, touch.y))
    end)
    waves = prepareMap("waves", Vector2.make(2, 2))
    waves.onUpdate = function()
      this.tick += 0.05
      local x = sin(tick) * 0.7
      local y = sin(tick) * 0.4
      this.position.setTo(Vector2.make(x, y))
    end

    boat1 = prepareBoat("boat1", "boat1")
    boat1.position.setTo(Vector2.make(50, 50))
    boat2 = prepareBoat("boat2", "boat2")
    boat2.position.setTo(Vector2.make(-50, 50))
    boat3 = prepareBoat("boat3", "boat3")
    boat3.position.setTo(Vector2.make(-50, -50))
    boat4 = prepareBoat("boat4", "boat4")
    boat4.position.setTo(Vector2.make(50, -50))
    
    winText = engine.addWinTextObject()
  end
  
  prepareBoat = function(name, spriteName)
    local boat = engine.addGameObject(name)
    boat.addSprite(spriteName)
    boat.onGoToSea = function(data)
        local distance = this.position.getDistanceTo(data)
        local maxDistance = 50

        if distance <= maxDistance then
            local maxDuration = 3
            local duration = maxDuration * (distance/maxDistance)
            Tweener.to(this, "getPosition", "setPosition", data, duration)
        end
    end
    
    engine.eventManager.addListener("goToSea", "onGoToSea", boat)
    
    return boat
  end
  
  prepareMap = function(mapName, scale=Vector2.make(1,1), alpha=1)
    local map = engine.addGameObject(mapName)
    map.addMap(mapName).withScale(scale).withAlpha(alpha)
    
    return map
  end
end