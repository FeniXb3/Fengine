game201225 = object
  init = function(engine)
    local animalsToHandle = 2
    expectedAnimals = engine.addGameObject("expectedAnimals")
    expectedAnimals.addActualExpected(0, animalsToHandle, function()
        Fengine.getInstance()
          .eventManager.triggerEvent("won", true)
      end)
    
    sheeps = prepareElements("sheep", animalsToHandle)
    targets = prepareTargets(engine)
    winText = prepareWinText(engine)
      
    engine.eventManager
    .addListener("sheepTouched", 
      "push", this)
    
    engine.eventManager
    .addListener("sheepHandled", 
      "handle", this)
  end
  
  handle = function(data)
    expectedAnimals.actualExpected.changeBy(1)
  end
  
  push = function(data)
    local touchPoint = Vector2.make(touch.x, touch.y)
    local direction = data.position.subtract(touchPoint)
      .divideByScalar(4)
    data.rigidBody.velocity.setTo(direction)
  end
  
  prepareElements = function(spriteName, amount)
    local elements = []
    for i = 1 to amount
      local element = prepareSingleElement(spriteName, i)
      
      elements.push(element)
    end
    
    return elements
  end
  
  prepareSingleElement = function(spriteName, index)
    local name = spriteName + index
    local element = engine.addGameObject(name)
    element.addSprite(spriteName)
    element.addRigidBody()
    
    local position = getRandomPosition()
    element.position.setTo(position)
    
    local onPress = function() 
      local go = this.gameObject
      local spriteName = go.renderable.image.name
      Fengine.getInstance().eventManager
        .triggerEvent(spriteName + "Touched", go)
    end
    element.addTouchableOnSprite(onPress)
    element.addColliderOnSprite(function(other)
      if other.name.startsWith("target") then
        Fengine.getInstance().eventManager
          .triggerEvent("sheepHandled", this.gameObject)
        this.gameObject.setEnabled(false)
        other.setEnabled(false)
      end
    end)
    
    return element
  end
  
  getRandomPosition = function()
    local x = random.nextInt(screen.width)
      - (screen.width/2)
      local y = random.nextInt(screen.height)
      - (screen.height/2)
      
    return new Vector2(x, y)
  end
  
  prepareTargets = function(engine)
    local targets = []
    local positions = [
      new Vector2(-screen.width/2, -screen.height/2),
      new Vector2(screen.width/2, screen.height/2),
    ]

    for i = 1 to 2
      
      local target = engine.addGameObject("target" + 1)
      target.addSprite("target")
      target.position.setTo(positions[i-1])
      target.addColliderOnSprite()
      
      targets.push(target)
    end
    
    return targets
  end
  end
  
  prepareWinText = function(engine)
    local text = engine.addGameObject("winText")
    text.addText("You win!", 30, "grey", "VeniceClassic")
    text.setEnabled(false)
    engine.eventManager
      .addListener("won", "setEnabled", text)
    
    return text
  end
end