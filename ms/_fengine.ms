Fengine = class

  getInstance = function()
    if not Fengine.instance then
      Fengine.instance = new Fengine()
    end
    
    return Fengine.instance
  end
  
  constructor = function()
    this.gameObjects = []
    this.clearColor = "black"
    this.logger = new Logger()
    this.eventManager = EventManager.getInstance()
    this.inputManager = InputManager.getInstance()
    this.physicsManager = PhysicsManager.getInstance()
  end
  
  addGameObject = function(name, x, y)
    local go = new GameObject(name, x, y)
    gameObjects.push(go)
    
    return go
  end
  
  addWinTextObject = function(content="You win!")
    local text = addGameObject("winText")
    text.addText(content, 30, "white")
      .withShadow()
    text.setEnabled(false)
    
    eventManager
      .addListener("won", "setEnabled", text)
    
    return text
  end
  
  // findGameObject = function(name)
  //   for go in gameObjects
  //     if go.name == name then
  //       logger.logInfo(go.getInfo())
  //       return go
  //     end
  //   end
    
  //   logger.logError("The game object <" +name + "> does not exist.")
  // end
  
  
  findGameObject = function(name)
    local result = 0
    for go in gameObjects
      if go.name == name then
        result = go
      end
    end
    
    if not result then
      logger.logError("The game object <" +name + "> does not exist.")
    end
    
    return result
  end  
  
  findAllGameObjects = function(name)
    local result = []
    for go in gameObjects
      if go.name == name then
        result.push(go)
      end
    end
    
    if not result.length then
      logger.logError("The game object <" +name + "> does not exist.")
    end
    
    return result
  end  
  
  update = function()
    Tweener.update()
    inputManager.update(gameObjects)
    physicsManager.update(gameObjects)
    // TODO: Make separate loops for handling different components
    for go in gameObjects
      go.update()
      if go.enabled then
        checkTouch(go)
        move(go)
        
        if go.collider and go.rigidBody then
          for other in gameObjects
            if not (other != go and other.enabled and other.collider) then
              continue
            end

            if not checkCollision(go, other) then
              if go.collider.collidingObjects.contains(other) then
                go.collider.collidingObjects.removeElement(other)
                go.collider.onCollisionExit(other)
              end
              if other.collider.collidingObjects.contains(go) then
                other.collider.collidingObjects.removeElement(go)
                other.collider.onCollisionExit(go)
              end
            else
              if not go.collider.collidingObjects.contains(other) then
                go.collider.collidingObjects.push(other)
              end
              if not other.collider.collidingObjects.contains(go) then
                other.collider.collidingObjects.push(go)
              end
              // TODO: Fix it to not fire collision events twice
              go.collider.onCollision(other)
              other.collider.onCollision(go)
              
              // TODO: Handle bounce on collision
              if not go.collider.isTrigger and not other.collider.isTrigger then
                local velocity = go.rigidBody.velocity
                local reverse = velocity.multiplyByScalar(-1).divideByScalar(velocity.getLength())

                while checkCollision(go, other)
                  go.position.changeBy(reverse)
                end

                go.rigidBody.velocity.setTo(physicsManager.gravity.multiplyByScalar(-1))
                // go.rigidBody.velocity.setTo(0, 0)
                other.rigidBody.velocity.setTo(0, 0)
              end
            end
          end
        end
      end
    end
  end
  
  checkTouch = function(go)
    if go.touchable then
      local bounds = go.touchable.bounds
      if touch.press and bounds.isPointInside(touch) then
        go.touchable.onPress()
      elsif touch.touching and bounds.isPointInside(touch) then
        go.touchable.onHold()
      elsif touch.release and bounds.isPointInside(touch) then
        go.touchable.onRelease()
      end
    end
  end  
  
  move = function(go)
    if not go.rigidBody then
      return
    end 
    
    go.position.changeBy(go.rigidBody.velocity)
  end
  
  checkCollision = function(go, other)
    if not shouldCheckCollision(go, other) then
      return false
    end

    return areOverlapping(go, other)
  end

  shouldCheckCollision = function(go, other)
    return go.position.getDistanceTo(other.position)
      <= go.collider.radius + other.collider.radius
  end

  areOverlapping = function(go, other)
    local thisBounds = go.collider.bounds.calculate()
    local otherBounds = other.collider.bounds.calculate()
    local collisionBounds = getCollisionBounds(go, other)

    return collisionBounds.left < collisionBounds.right
      and collisionBounds.bottom < collisionBounds.top
  end


  getCollisionBounds = function(go, other)
    local firstBounds = go.collider.bounds.calculate()
    local otherBounds = other.collider.bounds.calculate()

    return object
      left = max(firstBounds.left, otherBounds.left)
      right = min(firstBounds.right, otherBounds.right)
      bottom = max(firstBounds.bottom, otherBounds.bottom)
      top = min(firstBounds.top, otherBounds.top)
    end
  end
  
  
  draw = function()
    clearScreen()
    for go in gameObjects
      if go.enabled and go.renderable then
        go.draw()
      end
    end
  end
  
  clearScreen = function()
    screen.fillRect(0,0, screen.width, screen.height, clearColor)
  end
  
  getScreenBounds = function()
    local widthHalf = screen.width/2
    local heightHalf = screen.height/2
    
    local bounds = object end
    bounds.left = 0 - widthHalf - (widthHalf * screen.anchor.x)
    bounds.right = bounds.left + screen.width
    bounds.bottom = 0 - heightHalf - (heightHalf * screen.anchor.y)
    bounds.top = bounds.bottom + screen.height
     
     return bounds
  end
end