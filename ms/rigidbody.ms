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

  checkGrounded = function()
    local wasGrounded = grounded
    local bounds = gameObject.collider.bounds.calculate()
    local leftOrigin = Vector2.make(bounds.left, bounds.bottom)
    local rightOrigin = Vector2.make(bounds.right, bounds.bottom)
    local raycastLength = 1

    if PhysicsManager.getInstance().raycast(leftOrigin, Vector2.make(0, -1), raycastLength, "ground") then
      grounded = true
    elsif PhysicsManager.getInstance().raycast(rightOrigin, Vector2.make(0, -1), raycastLength, "ground") then
      grounded = true
    else
      grounded = false
    end

    if not wasGrounded and grounded then
      velocity.setTo(Vector2(0,0))
    end
  end
end