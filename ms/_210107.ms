game210107 = object
  init = function(engine)
    screen.bounds = engine.getScreenBounds()
    prepareSea()
    prepareBoat()
    fader = engine.addGameObject("fader")
    fader.addRectangle().withFill("black")
    fader.setEnabled(false)
    fader.onWinningSequence = function(step)
      if step != 1 and step != 3 then
        return
      end

      setEnabled(true)
      local startingValue = 0
      local targetValue = 0.5
      local onFinish = 0
      if step == 3 then
        startingValue += targetValue
        targetValue = startingValue - targetValue
      elsif step == 1 then
        onFinish = function()
          Fengine.getInstance().eventManager.triggerEvent("startWinningSequence", 2)
        end
      end
      renderable.setAlpha(startingValue)
      Tweener.to(renderable, "getAlpha", "setAlpha", targetValue, 2)
      .onFinished = onFinish
    end
    engine.eventManager.addListener("startWinningSequence", "onWinningSequence", fader)

    prepareBase()
    prepareCollectedFish()
    prepareDeliveredFish()

    engine.addWinTextObject()
  end

  prepareSea = function()
    prepareStuff()
    prepareMap("sea", Vector2.make(2, 2), 0.8)
    prepareMap("obstacles")
    prepareMap("waves").onUpdate = function()
      this.tick += 0.05
      local x = sin(tick) * 0.7
      local y = sin(tick) * 0.4
      this.position.setTo(Vector2.make(x, y))
    end
  end

  prepareBase = function()
    local base = engine.addGameObject("base")
    base.position.setTo(Vector2.make(0, screen.bounds.bottom))
    base.addAnimator("base")
      .withScale(Vector2.make(2, 2))
      .withAnchor(Vector2.make(0, -1))
      .addClip("empty")
      .addClip("start")
      .addClip("flag")
      .play("empty")
    base.onWinningSequence = function(step)
      if step != 2 then
        return
      end

      renderable.play("start", 1, function()
        Fengine.getInstance().eventManager.triggerEvent("startWinningSequence", 3)
        play("flag")
        triggerWin()
      end)
    end

    engine.eventManager.addListener("startWinningSequence", "onWinningSequence", base)

    base.addTouchableOnRenderable(function()
        Fengine.getInstance().eventManager.triggerEvent("goToBase", Vector2.make(touch.x, touch.y))
    end)
  end

  prepareBoat = function()
    local boat = engine.addGameObject("boat")
    boat.addAnimator("boat")
      .addClip("sail")

    local goToBase = function(data)
      local distance = this.position.getDistanceTo(data)
      local maxDistance = 100

      if distance <= maxDistance then
        renderable.play("sail")
        local maxDuration = 3
        local duration = maxDuration * (distance/maxDistance)
        Tweener.to(this, "getPosition", "setPosition", data, duration)
        .onFinished = function(target)
          target.renderable.play("__default__")
          Fengine.getInstance().eventManager.triggerEvent("passFish")
        end
      end
    end

    local goToSea = function(data)
      local distance = this.position.getDistanceTo(data)
      local maxDistance = 100

      if distance <= maxDistance then
        renderable.play("sail")
        local maxDuration = 3
        local duration = maxDuration * (distance/maxDistance)
        Tweener.to(this, "getPosition", "setPosition", data, duration)
        .onFinished = function(target)
          target.renderable.play("__default__")
          Fengine.getInstance().eventManager.triggerEvent("checkForFish", this.targetValue)
        end
      end
    end

    boat.onGoToSea = goToSea
    boat.onGoToBase = goToBase
    engine.eventManager.addListener("goToBase", "onGoToBase", boat)
    engine.eventManager.addListener("goToSea", "onGoToSea", boat)
  end


  prepareStuff = function()
    local stuff = prepareMap("stuff")
    stuff.onUpdate = function()
      this.tick += 0.05
      local x = cos(tick) * 0.3
      local y = cos(tick) * 0.5
      this.position.setTo(Vector2.make(x, y))
    end
    stuff.addTouchableOnMap(function()
        Fengine.getInstance().eventManager.triggerEvent("goToSea", Vector2.make(touch.x, touch.y))
    end)

    stuff.onCheckForFish = checkForFish
    engine.eventManager.addListener("checkForFish", "onCheckForFish", stuff)

    return stuff
  end

  checkForFish = function(data)
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

  prepareCollectedFish = function()
    local passFish = function()
      local fishState = this.actualExpected
      Fengine.getInstance().eventManager.triggerEvent("deliverFish", fishState.actual)
    end

    local collectFish = function(data)
      local fishState = this.actualExpected
      if fishState.changeBy(data.amount) then
         data.map.clearAt(data.coords)
      end
    end

    local collectedFish = prepareActualExpectedWithText(
      "collectedFish", 5,"Collected: ", "collectFish",
      Vector2.make(screen.bounds.left, screen.bounds.top), Vector2.make(-1, 1), false)
    collectedFish.collectFish = collectFish
    collectedFish.passFish = passFish
    engine.eventManager.addListener("passFish", "passFish", collectedFish)
    engine.eventManager.addListener("fishDelivered", "changeBy", collectedFish.actualExpected)
  end

  prepareDeliveredFish = function()
    local onDeliveredFishReached = function()
      Fengine.getInstance().eventManager.triggerEvent("startWinningSequence", 1)
    end

    local deliveredFish = prepareActualExpectedWithText(
      "deliveredFish", 1,"Delivered: ", "deliverFish",
      Vector2.make(screen.bounds.left, screen.bounds.bottom),
      Vector2.make(-1, -1), true, onDeliveredFishReached)
    deliveredFish.deliverFish = function(data)
      local fishState = this.actualExpected
      if fishState.changeBy(data) then
         Fengine.getInstance().eventManager.triggerEvent("fishDelivered", -data)
      end
    end
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

  prepareMap = function(mapName, scale=Vector2.make(1,1), alpha=1)
    local map = engine.addGameObject(mapName)
    map.addMap(mapName).withScale(scale).withAlpha(alpha)

    return map
  end
end