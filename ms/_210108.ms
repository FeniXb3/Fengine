game210108 = object
  init = function(engine)
    local infoText = engine.addGameObject("infoText")
    infoText.addText("Pause animation when maximum stars are shown.", 15, "white")
      .withShadow(Shadow.make("purple"))
    infoText.position.setTo(Vector2.make(0, 70))

    local star = engine.addGameObject("star")
    star.addAnimator("star")
      .withScale(Vector2.make(2, 2))
      .addClip("sequence")
      .play("sequence")

    engine.eventManager.addListener("pauseAnimation", "pause", star.renderable)
    engine.eventManager.addListener("resumeAnimation", "resume", star.renderable)

    local onPauseButtonRelease = function()
      gameObject.renderable.playDefault()
      Fengine.getInstance().eventManager.triggerEvent("pauseAnimation", "star")
    end
    local onResumeButtonRelease = function()
      gameObject.renderable.playDefault()
      Fengine.getInstance().eventManager.triggerEvent("resumeAnimation", "star")
    end
    prepareButton("pause", "Pause", Vector2.make(-50, -50), onPauseButtonRelease)
    prepareButton("resume", "Resume", Vector2.make(50, -50), onResumeButtonRelease)

    Fengine.getInstance().eventManager.addListener("animationPaused", "onAnimationPaused", this)

    local winText = engine.addWinTextObject()
    winText.position.setTo(Vector2.make(0, 40))
    winText.renderable.withShadow(Shadow.make("purple"))
  end

  onAnimationPaused = function(animator)
    if animator.name == "star" and not animator.isPlaying and animator.currentFrameIndex == 9 then
      animator.triggerWin()
    end
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