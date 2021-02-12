game210211 = object
  init = function(engine)
    local infoText = engine.addGameObject("infoText")
    infoText.addText("Choose wisely to open Patronite profile", 15, "white")
      .withShadow(Shadow.make("purple"))
    infoText.position.setTo(Vector2.make(0, 70))

   
    local onPauseButtonRelease = function()
      gameObject.renderable.playDefault()
      
      openURL("patronite.pl/konradgadzina")
      gameObject.triggerWin()
    end
    local onResumeButtonRelease = function()
      gameObject.renderable.playDefault()
      
      local infoText = engine.addGameObject("lostText")
      infoText.addText("Wrong!", 30, "white")
        .withShadow(Shadow.make("purple"))
      infoText.position.setTo(Vector2.make(0, 0))
    end
    prepareButton("pause", "Option 1", Vector2.make(-50, -50), onPauseButtonRelease)
    prepareButton("resume", "Option 2", Vector2.make(50, -50), onResumeButtonRelease)

    local winText = engine.addWinTextObject("Now go and support me!")
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