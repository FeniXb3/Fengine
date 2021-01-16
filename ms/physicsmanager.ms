PhysicsManager = class extends BaseEntity
  getInstance = function()
    if not PhysicsManager.instance then
      PhysicsManager.instance = new PhysicsManager()
    end
    
    return PhysicsManager.instance
  end

  constructor = function()
    this.metersPerUnit = 100
    this.fps = 60
    this.gravity = Vector2.make(0, -9.81).divideByScalar(fps)
    this.drag = 0.98
    this.velocityDelta = 0.00001
  end

  update = function(gameObjects)
    for go in gameObjects
      if not go.rigidBody or not go.rigidBody.mass then
        continue 
      end

      local gravityForce = this.gravity.multiplyByScalar(go.rigidBody.mass) 
      local targetVelocity = go.rigidBody.velocity.multiplyByScalar(drag)
      
      if targetVelocity.getLength() < velocityDelta then
        targetVelocity = Vector2.make(0, 0)
      end


      go.rigidBody.setVelocity(targetVelocity)

      if not go.rigidBody.grounded then
        go.rigidBody.applyGravity(gravityForce)
      end

    end
    moveAndHandleCollisions(gameObjects)
  end

  // TODO: Handle it in more optimal way
  moveAndHandleCollisions = function(gameObjects)
    for go in gameObjects
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
              go.collider.onCollision(other)
            end
            if not other.collider.collidingObjects.contains(go) then
              other.collider.collidingObjects.push(go)
              other.collider.onCollision(go)
            end
            
            // TODO: Handle bounce on collision
            if not go.collider.isTrigger and not other.collider.isTrigger then
              local velocity = go.rigidBody.velocity
              local reverse = velocity.multiplyByScalar(-1).divideByScalar(velocity.getLength())

              // TODO: Make it more generic. It should help avoid timeouts here
              local loopIndex = 0
              while checkCollision(go, other) and loopIndex < 10
                go.position.changeBy(reverse)
                loopIndex += 1
              end

              if not other.rigidBody then
                go.rigidBody.velocity.setTo(physicsManager.gravity.multiplyByScalar(-1))
              else
                local force = go.rigidBody.velocity.multiplyByScalar(go.rigidBody.mass)
                other.rigidBody.addForce(force)
              end
            end
          end
        end
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

  raycast = function(origin, direction, distance, name)
    local targetPoint = origin.add(direction.multiplyByScalar(distance))
    local matchingObjects = Fengine.getInstance().findAllGameObjects(name)
    local result = false

    for go in matchingObjects
      if go.collider.bounds.isPointInside(targetPoint) then
        result = true
      end
    end

    return result
  end
  
  // raycast = function(origin, direction, distance, name)
  //   local targetPoint = origin.add(direction.multiplyByScalar(distance))
  //   local matchingObjects = Fengine.getInstance().findAllGameObjects(name)

  //   for go in matchingObjects
  //     if go.collider.bounds.isPointInside(targetPoint) then
  //       return true
  //     end
  //   end

  //   return false
  // end
end