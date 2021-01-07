game210107 = object
  init = function(engine)
    screen.bounds = engine.getScreenBounds()
    engine.clearColor = "blue"

    gameplay = engine.addGameObject("gameplay")

    base = engine.addGameObject("base")
    base.addAnimator("base")
      .withScale(Vector2.make(2, 2))
      .addClip("flag")
      .addClip("empty")
      .addClip("start")

    base.renderable.play("start", 1, function() 
      this.play("flag")
    end)

    engine.addWinTextObject()
  end
end