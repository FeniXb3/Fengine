Collider = class extends BaseEntity
  constructor = function(position, translation, size, scale, anchor, onCollision)
    this.bounds = new Bounds(position, translation, size, scale, anchor)
    this.onCollision = onCollision
    
    // TODO: Handle scale
    this.radius = sqrt(size.x^2+size.y^2)/2
  end
end