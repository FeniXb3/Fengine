game210110 = object
  init = function(engine)
    screen.bounds = engine.getScreenBounds()
    local index = 0
    local startingY = screen.bounds.top
    local size = 5
    local gameplay = engine.addGameObject("gameplay")
    gameplay.addActualExpected(0, 0, function()
      triggerWin()
    end)

    engine.eventManager.addListener("easeUsed", "changeBy", gameplay.actualExpected)

    for ease in EaseType
      local easeText = engine.addGameObject("easeText_"+ease)
      easeText.addText(ease, size, "white")
        .withShadow(Shadow.make("purple", Vector2.make(0.5, -0.5)))
        .withAnchor(Vector2.make(-1, 1))
      easeText.position.setTo(Vector2.make(screen.bounds.left + size, startingY - size*1.2*index))
      easeText.addTouchableOnRenderable(function()
        if not gameObject.used then
          Fengine.getInstance().eventManager.triggerEvent("easeUsed", 1)
          gameObject.used = 1
        end

        Tweener.to(gameObject, "getPosition", "setPosition", Vector2.make(screen.bounds.right-gameObject.renderable.size.x, gameObject.position.y), 1)
        .setEase(gameObject.renderable.content)
        .setDelay(2)

        Fengine.getInstance().eventManager.triggerEvent("move", object
          ease = gameObject.renderable.content
          duration = 2
        end)
      end)
      index += 1
    end
    gameplay.actualExpected.expected = index

    local player = engine.addGameObject("player")
    player.addSprite("player1")
    .withScale(Vector2.make(2,2))
    player.move = function(data)
      setPosition(Vector2.make(0, screen.bounds.top*0.7))
      Tweener.to(this, "getPosition", "setPosition", Vector2.make(0, screen.bounds.bottom*0.7), data.duration)
        .setEase(data.ease)
    end

    engine.eventManager.addListener("move", "move", player)

    local winText = engine.addWinTextObject("You win with ease!")
    winText.position.setTo(Vector2.make(0, 40))
    winText.renderable.withShadow(Shadow.make("purple"))
  end
end