gamePirateBay = object
  init = function(engine)
    engine.reset()
    local multiplier = storage.get("level_number") + 1
    local gameplay = engine.addGameObject("gameplay")
    gameplay.game = this
    gameplay.reset = function()
      gameObject.game.init(Fengine.getInstance())
    end
    gameplay.addInputHandler()
      .reactOn("reset", "press", gameplay.reset)
    engine.inputManager.remap("reset", "R")
    engine.inputManager.remap("reset", "ENTER")
    engine.eventManager.addListener("reset", "reset", gameplay)

    screen.bounds = engine.getScreenBounds()
    prepareSea()

    local quadrants = [
      Vector2.make(1, 1),
      Vector2.make(1, -1),
      Vector2.make(-1, -1),
      Vector2.make(-1, 1)
    ]

    for i = 1 to multiplier
      local q = quadrants[i%quadrants.length]
      local offset = ceil(i / quadrants.length)
      local boat = prepareBoat("boat_"+i, "boat", Vector2.make(offset*40*q.x, offset*40*q.y))
      boat.addChild(prepareCollectedFish("", Vector2.makeZero(), Vector2.makeZero(), i))
    end

    prepareCallCircle()

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

    fader.onLost = function(value)
      setEnabled(true)
      renderable.setAlpha(0)
      Tweener.to(renderable, "getAlpha", "setAlpha", 0.5, 1)
        .setOnFinished(function(theObject)
          local lostText = Fengine.getInstance().addGameObject("lostText")
          lostText.addText("You lost!", 30, "white")
            .withShadow()

          local resetText = Fengine.getInstance().addGameObject("resetText")
          resetText.setPosition(Vector2.make(0, -25))
          local content = " to restart."
          if system.inputs.touch then
            content = "Tap anywhere"+content
          elsif system.inputs.mouse then
            content = "Click anywhere"+content
          elsif system.inputs.keyboard then
            content = "Press R"+content
          end

          resetText.addText(content, 15, "skyblue")
            .withShadow()
          //storage.set("level_number", 0)
          resetText.addTouchableOnRenderable()
            .setOnPress(function()
              Fengine.getInstance().eventManager.triggerEvent("reset")
            end)
          theObject.gameObject.addTouchableOnRenderable()
            .setOnPress(function()
              Fengine.getInstance().eventManager.triggerEvent("reset")
            end)
        end)
    end
    engine.eventManager.addListener("lost", "onLost", fader)

    prepareBase()
    //prepareCollectedFish()
    prepareDeliveredFish()

    local levelNumber = storage.get("level_number") + 1
    engine.addWinTextObject("You win level " + levelNumber+"!")
  end

  prepareCallCircle = function()
    local callCircle = engine.addGameObject("callCircle")
    callCircle.addRound(new Vector2(100, 100))
      .outlineWith("skyblue")
      .withScale(Vector2.makeZero())

    callCircle.onClick = function(data)
      this.position.setTo(data.target)
      Tweener.to(renderable, "getScale", "setScale", new Vector2(1, 1), 0.5)
        .setOnFinished(function(theObject)
          theObject.setScale(Vector2.makeZero())
        end)
        .setEase("easeInOutBounce")
    end
    engine.eventManager.addListener("goToBase", "onClick", callCircle)
    engine.eventManager.addListener("goToSea", "onClick", callCircle)

    local splash = engine.addGameObject("splash")
    splash.addAnimator("splash")
      .addClip("splash")

    splash.playOnSea = function(data)
      this.position.setTo(data.target)
      this.renderable.play("splash", 1, function()
        playDefault()
      end)
    end
    engine.eventManager.addListener("goToSea", "playOnSea", splash)
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

        local content = " to continue."
        if system.inputs.touch then
          content = "Tap here"+content
        elsif system.inputs.mouse then
          content = "Click here"+content
        elsif system.inputs.keyboard then
          content = "Press R"+content
        end
        local continueText = Fengine.getInstance().addGameObject("continueText")
        continueText.setPosition(Vector2.make(0, -25))
        continueText.addText(content, 15, "skyblue")
          .withShadow()

        continueText.addTouchableOnRenderable()
          .setOnPress(function()
            Fengine.getInstance().eventManager.triggerEvent("reset")
          end)
        local levelNumber = storage.get("level_number")
        storage.set("level_number", levelNumber+1)
      end)
    end

    engine.eventManager.addListener("startWinningSequence", "onWinningSequence", base)

    base.addTouchableOnRenderable(function()
        local data = object
          target =  Vector2.make(touch.x, touch.y)
        end
        Fengine.getInstance().eventManager.triggerEvent("goToBase", data)
    end)
  end

  prepareBoat = function(name, spriteName, position=Vector2.makeZero())
    local boat = engine.addGameObject(name)
    boat.position.setTo(position)
    boat.addAnimator(spriteName)
      .addClip("sail")
      .addClip("turn_left")
      .addClip("turn_right")
    boat.addColliderOnRenderable()
      .setOnCollision(function(other)
        gameObject.rigidBody = 0
        Tweener.to(gameObject.renderable, "getScale", "setScale", Vector2.make(0, 0), 1)
        Fengine.getInstance().eventManager.triggerEvent("lost", true)
      end)
    boat.addRigidBody()
      .setMass(0)

    boat.rotate = function(data)
      local targetAngle = position.getAngleTo(data)-90
      if targetAngle > 180 then
        targetAngle -= 360
      elsif targetValue < -180 then
        targetAngle += 360
      end

      local angleDiff = targetAngle - renderable.angle

      if abs(angleDiff)%360 > 180 then
        print(angleDiff)
        print(targetAngle)
        print(renderable.angle)
        if renderable.angle > 180 then
          renderable.angle -= 360
          print("Minus CURRENT 360:" +renderable.angle)
        elsif renderable.angle < -180 then
          renderable.angle += 360
          print("Plus CURRENT 360:" +renderable.angle)
        elsif targetAngle > 180 then
          targetAngle -= 360
          print("Minus TARGET 360:" +targetAngle)
        elsif targetAngle < -180 then
          targetAngle += 360
          print("Plus TARGET 360:" +targetAngle)
        end

        angleDiff = targetAngle - renderable.angle
        if abs(angleDiff) > 180 then
          print(":(")
        end
      end
      if angleDiff > 0 then
        renderable.play("turn_left")
      elsif angleDiff < 0 then
        renderable.play("turn_right")
      end

      local rotationDuration = abs(angleDiff)/45 * 0.3
      Tweener.to(this.renderable, "getAngle", "setAngle", targetAngle, rotationDuration)
      .setEase("easeInOutSine")
      .setOnFinished(function(target)
        target.play("sail")
      end)

      return rotationDuration
    end

    local goToBase = function(data)
      if this.blocked then
        return
      end

      local distance = this.position.getDistanceTo(data.target)
      local maxDistance = 80

      if distance <= maxDistance then
        local rotationDuration = rotate(data.target)

        local maxDuration = 3
        local duration = maxDuration * (distance/maxDistance)
        Tweener.to(this, "getPosition", "setPosition", data.target, duration)
        .setEase("easeInOutCubic")
        .setOnFinished( function(target)
          target.renderable.play("__default__")
          Fengine.getInstance().eventManager.triggerEvent("passFish", object
            boat = this.theObject
          end)
        end)
        .setDelay(rotationDuration)
      end
    end

    local goToSea = function(data)
      if this.blocked then
        return
      end

      local distance = this.position.getDistanceTo(data.target)
      local maxDistance = 80

      if distance <= maxDistance then
        local rotationDuration = rotate(data.target)

        local maxDuration = 3
        local duration = maxDuration * (distance/maxDistance)
        this.eventData = data
        Tweener.to(this, "getPosition", "setPosition", data.target, duration)
        .setEase("easeInOutCubic")
        .setOnFinished( function(target)
          target.renderable.play("__default__")
          Fengine.getInstance().eventManager.triggerEvent("checkForFish", object
            position = this.targetValue
            boat = this.theObject
            eventData = this.theObject.eventData
          end)
          this.theObject.eventData = 0
        end)
        .setDelay(rotationDuration)
      end
    end

    boat.disableMoving = function()
      local moveTweenName = this.name + "_getPosition_setPosition"
      Tweener.stop(moveTweenName)
      this.renderable.playDefault()

      this.blocked = true
    end

    engine.eventManager.addListener("startWinningSequence", "disableMoving", boat)
    engine.eventManager.addListener("lost", "disableMoving", boat)

    boat.onGoToSea = goToSea
    boat.onGoToBase = goToBase
    engine.eventManager.addListener("goToBase", "onGoToBase", boat)
    engine.eventManager.addListener("goToSea", "onGoToSea", boat)

    return boat
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
        local map = this.gameObject.renderable
        local coords = map.getCoords(Vector2.make(touch.x, touch.y))
        local data = object
          target = Vector2.make(touch.x, touch.y)
          coords = coords
        end
        Fengine.getInstance().eventManager.triggerEvent("goToSea", data)
    end)

    stuff.onCheckForFish = checkForFish
    engine.eventManager.addListener("checkForFish", "onCheckForFish", stuff)

    return stuff
  end

  checkForFish = function(data)
    local map = this.renderable
    local coords = data.eventData.coords
    local tileName = map.get(coords)
    if tileName.startsWith("fish") then
      local stuffAmount = floor(tileName[tileName.length-1])
      Fengine.getInstance().eventManager.triggerEvent("collectFish",
      object
        map = map
        coords = coords
        amount = stuffAmount
        boat = data.boat
      end)
    end
  end

  prepareCollectedFish = function(baseText="Collected: ", position=Vector2.make(screen.bounds.left, screen.bounds.top), anchor=Vector2.make(-1, 1), index=0)
    local passFish = function(data)
      local fishState = this.actualExpected
      if this.parent == data.boat then
        Fengine.getInstance().eventManager.triggerEvent("deliverFish", object
          amount = fishState.actual
          boat = data.boat
        end)
      end
    end

    local collectFish = function(data)
      local fishState = this.actualExpected
      if this.parent == data.boat then
        if fishState.changeBy(data.amount) then
          data.map.clearAt(data.coords)
        end
      end
    end

    local onFishDelivered = function(data)
      local fishState = this.actualExpected
      if this.parent == data.boat then
        fishState.changeBy(data.amount)
      end
    end

    local collectedFish = prepareActualExpectedWithText(
      "collectedFish_"+index, 4, baseText, "collectFish",
      position, anchor, false)
    collectedFish.collectFish = collectFish
    collectedFish.passFish = passFish
    collectedFish.onFishDelivered = onFishDelivered
    engine.eventManager.addListener("passFish", "passFish", collectedFish)
    engine.eventManager.addListener("fishDelivered", "onFishDelivered", collectedFish)

    return collectedFish
  end

  prepareDeliveredFish = function()
    local onDeliveredFishReached = function()
      Fengine.getInstance().eventManager.triggerEvent("startWinningSequence", 1)
    end

    local multiplier = storage.get("level_number") + 1

    local deliveredFish = prepareActualExpectedWithText(
      "deliveredFish", 6*multiplier,"Delivered: ", "deliverFish",
      Vector2.make(screen.bounds.left, screen.bounds.bottom),
      Vector2.make(-1, -1), true, onDeliveredFishReached)
    deliveredFish.deliverFish = function(data)
      local fishState = this.actualExpected
      if fishState.changeBy(data.amount) then
        Fengine.getInstance().eventManager.triggerEvent("fishDelivered", object
          amount = -data.amount
          boat = data.boat
        end)
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