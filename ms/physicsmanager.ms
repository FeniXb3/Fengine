PhysicsManager = class extends BaseEntity
  getInstance = function()
    if not PhysicsManager.instance then
      PhysicsManager.instance = new PhysicsManager()
    end
    
    return PhysicsManager.instance
  end

  constructor = function()
    this.metersPerUnit = 100
    this.gravity = Vector2.make(0, -9.81).divideByScalar(metersPerUnit)
    this.drag = 0.99
  end

  update = function(gameObjects)
    for go in gameObjects
      if not go.rigidBody or not go.rigidBody.mass then
        continue 
      end

      local gravityForce = this.gravity.multiplyByScalar(go.rigidBody.mass) 
      go.rigidBody.setVelocity(go.rigidBody.velocity.multiplyByScalar(drag).add(this.gravity))
    end
  end
end