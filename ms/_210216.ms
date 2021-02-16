game210216 = object

  init = function(engine)
    screen.bounds = engine.getScreenBounds()
    engine.inputManager.remap("move_left", "LEFT")
    engine.inputManager.remap("move_right", "RIGHT")
    engine.inputManager.remap("jump", "SPACE")

    local jumpReminder = engine.addGameObject("jumpReminder")
    jumpReminder.setPosition(new Vector2(0, screen.bounds.bottom))
    jumpReminder.addText("Myślałeś, że zapomnę Ci ten skok?", 20, "red")
      .withAnchor(new Vector2(0, -1))
    jumpReminder.setEnabled(false)
    jumpReminder.addColliderOnRenderable()
    engine.eventManager.addListener("fallen", "setEnabled", jumpReminder)

    local happy = engine.addGameObject("jumpReminder")
    happy.setPosition(new Vector2(0, screen.bounds.top))
    happy.addText("Najlepszego!", 15, "gold")
      .withAnchor(new Vector2(0, 1))
    happy.setEnabled(false)
    engine.eventManager.addListener("won", "setEnabled", happy)


    local player = engine.addGameObject("player")
    player.addSprite("player1")
    player.addRigidBody()
    player.addColliderOnRenderable().setOnCollision(function(other)
      print(other)
      if other.name == "cake" and not other.eaten then
        other.eaten = true
        Tweener.to(other.renderable, "getAlpha", "setAlpha", 0, 1.5)
          .setOnFinished(function(target)
            target.gameObject.triggerWin()
          end)
      end
    end)

    player.onUpdate = function()
      if position.y < screen.bounds.bottom then
          Fengine.getInstance().eventManager.triggerEvent("fallen", true)
          position.setTo(startingPosition)
      end
      rigidBody.checkGrounded()
    end
    player.jumpPower = 5
    player.moveSpeed = 1.5
    player.jump = function()
      if this.gameObject.rigidBody.grounded then
        this.gameObject.rigidBody.velocity.changeBy(Vector2.make(0, gameObject.jumpPower))
      end
    end
    player.move = function(direction)
        local currentVelocity = this.gameObject.rigidBody.velocity
        this.gameObject.rigidBody.setVelocity(Vector2.make(gameObject.moveSpeed*direction, currentVelocity.y))
    end
    player.moveLeft = function() this.gameObject.move(-1) end
    player.moveRight = function() this.gameObject.move(1) end

    player.addInputHandler()
    .reactOn("move_left", "hold", player.moveLeft)
    .reactOn("move_right", "hold", player.moveRight)
    .reactOn("jump", "release", player.jump)


    local ground = engine.addGameObject("ground")
    ground.position.setTo(new Vector2(0, -50))
    ground.addSprite("ground")
    ground.addColliderOnRenderable()

    ground = engine.addGameObject("ground2")
    ground.position.setTo(new Vector2(screen.bounds.right*0.8, -50))
    ground.addSprite("ground")
    ground.addColliderOnRenderable()



    local cake = engine.addGameObject("cake")
    cake.position.setTo(new Vector2(screen.bounds.right*0.9, 0))
    cake.startingPosition = cake.position.copy()
    cake.addSprite("cake")
    cake.addColliderOnRenderable().setIsTrigger(true)
    cake.onUpdate = function()
      this.tick += 0.05
      local x = this.startingPosition.x + sin(tick*5) * 0.7
      local y = this.startingPosition.y + sin(tick) * 2.5
      this.position.setTo(Vector2.make(x, y))
    end

    local winText = engine.addWinTextObject("The cake is a lie!")
    //winText.addColliderOnRenderable()

  end

end