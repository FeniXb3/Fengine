game210101 = object

  init = function(engine)
    screen.bounds = engine.getScreenBounds()
    
    stuff = prepareMap("stuff")
    stuff.onUpdate = function()
      this.tick += 0.05
      local x = cos(tick) * 0.3
      local y = cos(tick) * 0.5
      this.position.setTo(Vector2.make(x, y))
    end
    stuff.addTouchableOnMap(function()
        Fengine.getInstance().eventManager.triggerEvent("goToSea", Vector2.make(touch.x, touch.y))
    end)
    stuff.onCheckForFish = function(data)
        local map = this.renderable
        local coords = map.getCoords(touch)
        local tileName = map.get(coords)
        if tileName.startsWith("fish") then
          local stuffAmount = floor(tileName[tileName.length-1])
          Fengine.getInstance().eventManager.triggerEvent("collectFish", 
          object
            map = map
            coords = coords
            amount = stuffAmount
          end)
        end
    end    
    engine.eventManager.addListener("checkForFish", "onCheckForFish", stuff)
    
    water = prepareMap("sea", Vector2.make(2, 2), 0.8)
    obstacles = prepareMap("obstacles")
    waves = prepareMap("waves")
    waves.onUpdate = function()
      this.tick += 0.05
      local x = sin(tick) * 0.7
      local y = sin(tick) * 0.4
      this.position.setTo(Vector2.make(x, y))
    end
    
    base = engine.addGameObject("base")
    base.position.setTo(Vector2.make(0, screen.bounds.bottom))
    base.addSprite("base_flag")
      .withAnchor(Vector2.make(0, -1))
    base.addTouchableOnSprite(function()
        Fengine.getInstance().eventManager.triggerEvent("goToBase", Vector2.make(touch.x, touch.y))
    end)

    boat = engine.addGameObject("boat")
    boat.addSprite("player1")
    boat.onGoToSea = function(data)
        Tweener.to(this, "getPosition", "setPosition", data, 0.4)
            .onFinished = function()
                Fengine.getInstance().eventManager.triggerEvent("checkForFish",
                    this.targetValue)
            end
    end

    boat.onGoToBase = function(data)
        Tweener.to(this, "getPosition", "setPosition", data, 0.4)
            .onFinished = function()
                Fengine.getInstance().eventManager.triggerEvent("passFish")
            end
    end


    
    engine.eventManager.addListener("goToBase", "onGoToBase", boat)
    engine.eventManager.addListener("goToSea", "onGoToSea", boat)
    
    
    collectedFish = prepareActualExpectedWithText(
      "collectedFish", 5,"Collected: ", "collectFish", 
      Vector2.make(screen.bounds.left, screen.bounds.top), Vector2.make(-1, 1), false)
    collectedFish.collectFish = function(data)
      local fishState = this.actualExpected
      if fishState.changeBy(data.amount) then
         data.map.clearAt(data.coords)
      end
    end
    collectedFish.passFish = function()
      local fishState = this.actualExpected
      Fengine.getInstance().eventManager.triggerEvent("deliverFish", fishState.actual)
    end
    engine.eventManager.addListener("passFish", "passFish", collectedFish)
    engine.eventManager.addListener("fishDelivered", "changeBy", collectedFish.actualExpected)
    
    
    local onDeliveredFishReached = function()
      Fengine.getInstance().eventManager.triggerEvent("won", true)
    end
    
    deliveredFish = prepareActualExpectedWithText(
      "deliveredFish", 21,"Delivered: ", "deliverFish", 
      Vector2.make(screen.bounds.left, screen.bounds.bottom),
      Vector2.make(-1, -1), true, onDeliveredFishReached)
    deliveredFish.deliverFish = function(data)
      local fishState = this.actualExpected
      if fishState.changeBy(data) then
         Fengine.getInstance().eventManager.triggerEvent("fishDelivered", -data)
      end
    end
    
    winText = engine.addWinTextObject()
  end
  
  prepareActualExpectedWithText = function(name, expected, textPart, addingEventName, position, anchor, allowExcess, onReached)
    local ae = engine.addGameObject(name)
    ae.textPart = textPart
    ae.position.setTo(position)
    ae.addActualExpected(0, expected, onReached,
    function()
      Fengine.getInstance().eventManager.triggerEvent("set"+this.gameObject.name+"Text",
        this.gameObject.textPart+this.actual+"/"+this.expected)
    end)
      .setAllowExcess(allowExcess)
    
    ae.addText(textPart+ae.actualExpected.actual+"/"+ae.actualExpected.expected, 15, "white")
      .withShadow()
      .withAnchor(anchor)
    
    
    engine.eventManager.addListener(addingEventName,
      addingEventName, ae)
    
    engine.eventManager.addListener("set"+name+"Text",
      "setContent", ae.renderable)
    
    return ae
  end
  
  getRandomPosition = function()
    local x = random.nextInt(screen.width)
      - (screen.width/2)
      local y = random.nextInt(screen.height)
      - (screen.height/2)
      
    return new Vector2(x, y)
  end
  
  prepareMap = function(mapName, scale=Vector2.make(1,1), alpha=1)
    local map = engine.addGameObject(mapName)
    map.addMap(mapName).withScale(scale).withAlpha(alpha)
    
    return map
  end
end