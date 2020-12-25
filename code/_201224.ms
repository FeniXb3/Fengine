game201224 = object
  init = function(engine)
    animalsToFeed = 7
    animalsFed = 0
    
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
      animalsFed += 1
      data.setEnabled(false)
      holdingFood = false
    end
    
    if animalsFed == animalsToFeed then
      Fengine.getInstance()
        .eventManager.triggerEvent("won", true)
      end
  end
  
  prepareElements = function(spriteName, amount)
    local elements = []
    for i = 1 to amount
      local name = spriteName + i
      local element = engine.addGameObject(name)
      element.addSprite(spriteName)
      
      local x = random.nextInt(screen.width)
      - (screen.width/2)
      local y = random.nextInt(screen.height)
      - (screen.height/2)
      element.position.setTo(Vector2.make(x, y))
      
      element.addTouchableOnSprite(function() 
        local go = this.gameObject
        local spriteName = go.renderable.image.name
        Fengine.getInstance().eventManager
          .triggerEvent(spriteName + "Touched", go)
      end)
      
      elements.push(element)
    end
    
    return elements
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