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
      
      if not go.rigidBody.grounded then
        targetVelocity = targetVelocity.add(this.gravity)
      end
      if targetVelocity.getLength() < velocityDelta then
        targetVelocity = Vector2.make(0, 0)
      end

      go.rigidBody.setVelocity(targetVelocity)
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