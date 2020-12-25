game201224 = object
  init = function(engine)
    local animalsToFeed = 2
    expectedAnimals = engine.addGameObject("expectedAnimals")
    expectedAnimals.addActualExpected(0, animalsToFeed, function()
        Fengine.getInstance()
          .eventManager.triggerEvent("won", true)
      end)
    
    sheeps = prepareElements("sheep", animalsToFeed)
    food = prepareElements("food", animalsToFeed)
    winText = prepareWinText(engine)
      
    engine.eventManager
    .addListener("sheepTouched", 
      "feed", this)
      
    engine.eventManager
    .addListener("foodTouched", 
      "collect", this)
  end
  
  collect = function(data)
    if not holdingFood then
      data.setEnabled(false)
      holdingFood = true
    end
  end
  
  feed = function(data)
    if holdingFood then
      expectedAnimals.actualExpected.changeBy(1)
      data.setEnabled(false)
      holdingFood = false
    end
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
    
    local position = getRandomPosition()
    element.position.setTo(position)
    
    local onPress = function() 
      local go = this.gameObject
      local spriteName = go.renderable.image.name
      Fengine.getInstance().eventManager
        .triggerEvent(spriteName + "Touched", go)
    end
    element.addTouchableOnSprite(onPress)
    
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