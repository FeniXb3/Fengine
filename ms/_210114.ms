game210114 = object
  init = function(engine)
    screen.bounds = engine.getScreenBounds()

    local ground = engine.addGameObject("ground")
    ground.setPosition(Vector2.make(0, screen.bounds.bottom))
    ground.addSprite("ground")
    ground.addColliderOnSprite()

    local ground = engine.addGameObject("ground")
    ground.setPosition(Vector2.make(screen.bounds.left*0.5, 0))
    ground.addSprite("ground")
    ground.addColliderOnSprite()

    local ground = engine.addGameObject("ground")
    ground.setPosition(Vector2.make(screen.bounds.left, screen.bounds.bottom))
    ground.addSprite("ground")
    ground.addColliderOnSprite()

    local target = engine.addGameObject("target")
    target.setPosition(Vector2.make(screen.bounds.right*0.7, 0))
    target.addSprite("target")
    target.addColliderOnSprite().setIsTrigger(true).setOnCollision(function(other)
      if other.name == "player" then
        triggerWin()
      end
    end)

    local player = engine.addGameObject("player")
    player.setPosition(Vector2.make(screen.bounds.left, 0))//ground.collider.bounds.calculate.top + 5))
    player.addSprite("player1")
    player.addColliderOnSprite()
    player.addRigidBody()
    //   .setVelocity(Vector2.make(3, 5))

    player.addInputHandler()
      .reactOn("jump", "press", function()
        this.gameObject.position.changeBy(Vector2.make(0, 1))
        this.gameObject.rigidBody.velocity.changeBy(Vector2.make(0, 5))
      end)
      .reactOn("move_right", "hold", function()
        local currentVelocity = this.gameObject.rigidBody.velocity
        this.gameObject.rigidBody.setVelocity(Vector2.make(2, currentVelocity.y))
      end)
      .reactOn("move_left", "hold", function()
        local currentVelocity = this.gameObject.rigidBody.velocity
        this.gameObject.rigidBody.setVelocity(Vector2.make(-2, currentVelocity.y))
      end)

    
      engine.inputManager.remap("jump", "SPACE")
      engine.inputManager.remap("move_right", "RIGHT")
      engine.inputManager.remap("move_left", "LEFT")
    local winText = engine.addWinTextObject()
    winText.position.setTo(Vector2.make(0, 40))
    winText.renderable.withShadow(Shadow.make("purple"))
  end
end