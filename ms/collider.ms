Collider = class extends BaseEntity
  constructor = function(position, translation, size, scale, anchor, onCollision)
    this.bounds = new Bounds(position, translation, size, scale, anchor)
    this.onCollision = onCollision
    this.isTrigger = false
    // TODO: Handle scale
    this.radius = sqrt(size.x^2+size.y^2)/2
  end

  setIsTrigger = function(value)
    this.isTrigger = value
    return this
  end

  setOnCollision = function(value)
    this.onCollision = value
    return this
  end
end