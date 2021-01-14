RigidBody = class extends BaseEntity
  constructor = function()
    this.velocity = Vector2.make(0, 0)
    this.mass = 1
    this.grounded = false
  end

  setVelocity = function(value)
    this.velocity.setTo(value)
    return this
  end

  setMass = function(value)
    this.mass = value
    return this
  end
end