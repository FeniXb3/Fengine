game210109 = object
  init = function(engine)
    local infoText = engine.addGameObject("infoText")
    infoText.addText("Is Warsaw the capital of Poland?", 15, "white")
      .withShadow(Shadow.make("purple"))
    infoText.position.setTo(Vector2.make(0, 70))

    local gameplay = engine.addGameObject("gameplay")
    gameplay.onAnswer = function(answer)
      if answer == "yes" then
        triggerWin()
      end
    end

    local vote = engine.addGameObject("vote")
    vote.addAnimator("vote")
      .withScale(Vector2.make(2, 2))
      .addClip("yes")
      .addClip("no")
      .play("sequence")

      engine.eventManager.addListener("answer", "play", vote.renderable)
      engine.eventManager.addListener("answer", "onAnswer", gameplay)

    local onYesButtonRelease = function()
      gameObject.renderable.playDefault()
      Fengine.getInstance().eventManager.triggerEvent("answer", "yes")
    end
    local onNoButtonRelease = function()
      gameObject.renderable.playDefault()
      Fengine.getInstance().eventManager.triggerEvent("answer", "no")
    end
    prepareButton("yes", "Yes", Vector2.make(-50, -50), onYesButtonRelease)
    prepareButton("no", "No", Vector2.make(50, -50), onNoButtonRelease)

    local winText = engine.addWinTextObject()
    winText.position.setTo(Vector2.make(0, 40))
    winText.renderable.withShadow(Shadow.make("purple"))
  end

  prepareButton = function(name, text, position, onButtonRelease)
    local onButtonPress = function()
      gameObject.renderable.play("holding")
    end

    local button = engine.addGameObject(name+"Button")
    button.setPosition(position)
    button.addAnimator("button")
      .withScale(Vector2.make(2.5, 2))
      .addClip("holding")
    button.addTouchableOnRenderable(onButtonPress, 0, onButtonRelease)
    local buttonText = engine.addGameObject(name+"Text")
    buttonText.addText(text, 15, "black")
    button.addChild(buttonText)
  end
end