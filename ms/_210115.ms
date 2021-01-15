game210115 = object
  init = function(engine)
    screen.bounds = engine.getScreenBounds()

    prepareGround()

    local target = engine.addGameObject("target")
    target.setPosition(Vector2.make(screen.bounds.right*0.7, 0))
    target.addSprite("target")
    target.addColliderOnSprite().setIsTrigger(true).setOnCollision(function(other)
      if other.name == "player" then
        triggerWin()
      end
    end)

    local train = makePhysicsSpriteAt("train", "train", Vector2.make(0, 0))
    train.onUpdate = function()
      rigidBody.checkGrounded()
    end

    local player = makePhysicsSpriteAt("player", "player1", Vector2.make(screen.bounds.left, 0))
    player.onUpdate = function()
      if position.y < screen.bounds.bottom then
        position.setTo(startingPosition)
      end
      rigidBody.checkGrounded()
    end
    addMovementTo(player)

    engine.inputManager.remap("jump", "SPACE")
    engine.inputManager.remap("move_right", "RIGHT")
    engine.inputManager.remap("move_left", "LEFT")
    
    local winText = engine.addWinTextObject()
    winText.position.setTo(Vector2.make(0, 40))
    winText.renderable.withShadow(Shadow.make("purple"))
  end

  addMovementTo = function(go)
    go.jumpPower = 4
    go.moveSpeed = 1
    go.jump = function()
      if this.gameObject.rigidBody.grounded then
        this.gameObject.position.changeBy(Vector2.make(0, 1))
        this.gameObject.rigidBody.velocity.changeBy(Vector2.make(0, gameObject.jumpPower))
      end
    end
    go.move = function(direction)
      local currentVelocity = this.gameObject.rigidBody.velocity
      this.gameObject.rigidBody.setVelocity(Vector2.make(gameObject.moveSpeed*direction, currentVelocity.y))
    end
    go.moveLeft = function() this.gameObject.move(-1) end
    go.moveRight = function() this.gameObject.move(1) end

    go.addInputHandler()
      .reactOn("jump", "press", go.jump)
      .reactOn("move_right", "hold", go.moveRight)
      .reactOn("move_left", "hold", go.moveLeft)
  end

  makePhysicsSpriteAt = function(name, spriteName, startingPosition)
    local go = engine.addGameObject(name)
    go.startingPosition = startingPosition
    go.setPosition(startingPosition)
    go.addSprite(spriteName)
    go.addColliderOnSprite()
    go.addRigidBody()

    return go
  end

  prepareGround = function()
    makeSinglePlatformAt(Vector2.make(20, screen.bounds.bottom))
    makeSinglePlatformAt(Vector2.make(screen.bounds.left*0.4, screen.bounds.bottom*0.7))
    makeSinglePlatformAt(Vector2.make(screen.bounds.left, screen.bounds.bottom))
  end

  makeSinglePlatformAt = function(position)
    local ground = engine.addGameObject("ground")
    ground.setPosition(position)
    ground.addSprite("ground")
    ground.addColliderOnSprite()
  end
end