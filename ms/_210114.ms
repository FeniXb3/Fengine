game210114 = object
  init = function(engine)
    screen.bounds = engine.getScreenBounds()

    local ground = engine.addGameObject("ground")
    ground.setPosition(Vector2.make(20, screen.bounds.bottom))
    ground.addSprite("ground")
    ground.addColliderOnSprite()

    local ground = engine.addGameObject("ground")
    ground.setPosition(Vector2.make(screen.bounds.left*0.4, screen.bounds.bottom*0.7))
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

    local startingPosition = Vector2.make(screen.bounds.left, 0)
    local player = engine.addGameObject("player")
    player.setPosition(startingPosition)//ground.collider.bounds.calculate.top + 5))
    player.startingPosition = startingPosition
    player.addSprite("player1")
    player.addColliderOnSprite()
    player.addRigidBody()

    player.addInputHandler()
      .reactOn("jump", "press", function()
        if this.gameObject.rigidBody.grounded then
          this.gameObject.position.changeBy(Vector2.make(0, 1))
          this.gameObject.rigidBody.velocity.changeBy(Vector2.make(0, 4))
        end
      end)
      .reactOn("move_right", "hold", function()
        if this.gameObject.rigidBody.grounded then
          local currentVelocity = this.gameObject.rigidBody.velocity
          this.gameObject.rigidBody.setVelocity(Vector2.make(2, currentVelocity.y))
        end
      end)
      .reactOn("move_left", "hold", function()
        if this.gameObject.rigidBody.grounded then
          local currentVelocity = this.gameObject.rigidBody.velocity
          this.gameObject.rigidBody.setVelocity(Vector2.make(-2, currentVelocity.y))
        end
      end)

      local raycastLine = engine.addGameObject("raycastLine")
      raycastLine.addLine(player.position, Vector2.make(0,0), "green")
      raycastLine.setEnabled(false)
      player.addChild(raycastLine)

      player.onUpdate = function()
        if position.y < screen.bounds.bottom then
          position.setTo(startingPosition)
        end
        
        local bounds = collider.bounds.calculate()
        local leftOrigin = Vector2.make(bounds.left, bounds.bottom)
        local rightOrigin = Vector2.make(bounds.right, bounds.bottom) 
        if PhysicsManager.getInstance().raycast(leftOrigin, Vector2.make(0, -1), 15, "ground") then
          rigidBody.grounded = true
        elsif PhysicsManager.getInstance().raycast(rightOrigin, Vector2.make(0, -1), 15, "ground") then
          rigidBody.grounded = true
        else
          rigidBody.grounded = false
        end
        
        //this.rigidBody.grounded = PhysicsManager.getInstance().raycast(this.position, Vector2.make(0, -1), 10, "ground")
        local targetPoint = this.position.add(Vector2.make(0, -1).multiplyByScalar(15))
        this.children[0].renderable.finish = targetPoint
      end
    
      engine.inputManager.remap("jump", "SPACE")
      engine.inputManager.remap("move_right", "RIGHT")
      engine.inputManager.remap("move_left", "LEFT")
    local winText = engine.addWinTextObject()
    winText.position.setTo(Vector2.make(0, 40))
    winText.renderable.withShadow(Shadow.make("purple"))
  end
end