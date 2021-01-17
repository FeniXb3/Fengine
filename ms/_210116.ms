game210116 = object
  init = function(engine)
    engine.reset()
    baseY = 70
    screen.bounds = engine.getScreenBounds()

    prepareGround()

    local target = engine.addGameObject("target")
    target.setPosition(Vector2.make(screen.bounds.right, 0))
    target.addSprite("target")
    target.addColliderOnSprite().setIsTrigger(true).setOnCollision(function(other)
      if other.name == "train" then
        triggerWin()
      end
    end)

    local train = makePhysicsSpriteAt("train", "train", Vector2.make(-10, baseY), 20)
    train.onUpdate = function()
      rigidBody.checkGrounded()
    end
    local item = makePhysicsSpriteAt("item1", "item1", Vector2.make(50, baseY), 25)
    item.onUpdate = function()
      rigidBody.checkGrounded()
    end

    local player = makePhysicsSpriteAt("player", "player1", Vector2.make(screen.bounds.left, baseY))
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

    local gameplay = engine.addGameObject("gameplay")
    gameplay.game = this
    gameplay.reset = function()
      gameObject.game.init(Fengine.getInstance())
    end
    gameplay.addInputHandler()
      .reactOn("reset", "press", gameplay.reset)
    engine.inputManager.remap("reset", "R")
    
    local winText = engine.addWinTextObject()
    winText.position.setTo(Vector2.make(0, 40))
    winText.renderable.withShadow(Shadow.make("purple"))
  end

  addMovementTo = function(go)
    go.jumpPower = 5
    go.moveSpeed = 0.5
    go.jump = function()
      if this.gameObject.rigidBody.grounded then
        this.gameObject.rigidBody.addForce(Vector2.make(0, gameObject.jumpPower))
      end
    end
    go.move = function(direction)
      local currentVelocity = this.gameObject.rigidBody.velocity
      if currentVelocity.getLength() < 2 then
        this.gameObject.rigidBody.addForce(Vector2.make(gameObject.moveSpeed*direction, 0))
      end  
    end
    go.moveLeft = function() this.gameObject.move(-1) end
    go.moveRight = function() this.gameObject.move(1) end

    go.addInputHandler()
      .reactOn("jump", "press", go.jump)
      .reactOn("move_right", "hold", go.moveRight)
      .reactOn("move_left", "hold", go.moveLeft)
  end

  makePhysicsSpriteAt = function(name, spriteName, startingPosition, mass=1)
    local go = engine.addGameObject(name)
    go.startingPosition = startingPosition
    go.setPosition(startingPosition)
    go.addSprite(spriteName)
    go.addColliderOnSprite()
    go.addRigidBody()
      .setMass(mass)

    return go
  end

  prepareGround = function()
    // makeSinglePlatformAt(Vector2.make(screen.bounds.left, screen.bounds.bottom+baseY))
    // makeSinglePlatformAt(Vector2.make(screen.bounds.left*0.4, screen.bounds.bottom*0.7+baseY), Vector2.make(0.7, 1))
    // makeSinglePlatformAt(Vector2.make(screen.bounds.right*0.39, screen.bounds.bottom+baseY), Vector2.make(2.5, 1))
    makeSinglePlatformAt(Vector2.make(0, screen.bounds.bottom+baseY), Vector2.make(7, 1))
  end

  makeSinglePlatformAt = function(position, scale=Vector2.make(1, 1))
    local ground = engine.addGameObject("ground")
    ground.setPosition(position)
    ground.addSprite("ground")
      .withScale(scale)
    ground.addColliderOnSprite()
  end
end