game201226 = object
  // You have to go through door, but you cannot pass them
  // without key. They will open when you get the key.

  init = function(engine)
     sheep = prepareSingleElement("sheep", "player")
     sheep.collider.onCollision = function(other)
      if other.name.startsWith("key") then
        this.gameObject.addChild(other)
        other.position.setTo(Vector2.make(6, 0))
        other.collider = 0
      end
    end
    
    door = engine.addGameObject("door")
    door.addSprite("door")
    door.addColliderOnSprite(function(other)
      if other.name != "player" then
        return
      end
      
      for child in other.children
        if child.name == "key" then
          other.children.removeElement(child)
          child.setEnabled(false)
          other.setEnabled(false)
          this.gameObject.addSprite("door_open")
          this.setIsTrigger(true)
          Fengine.getInstance()
          .eventManager.triggerEvent("won", true)
        end
      end
    end)
    
    key = engine.addGameObject("key", -30, 50)
    key.addSprite("key")
    key.addColliderOnSprite()
    
    winText = prepareWinText(engine)
      
    engine.eventManager
    .addListener("sheepTouched", 
      "push", this)
  end
  
  push = function(data)
    local touchPoint = Vector2.make(touch.x, touch.y)
    local direction = data.position.subtract(touchPoint)
      .divideByScalar(4)
    data.rigidBody.velocity.setTo(direction)
  end
  
  prepareSingleElement = function(spriteName, name)
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
    element.addColliderOnSprite()
    
    return element
  end
  
  getRandomPosition = function()
    local x = random.nextInt(screen.width)
      - (screen.width/2)
      local y = random.nextInt(screen.height)
      - (screen.height/2)
      
    return new Vector2(x, y)
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