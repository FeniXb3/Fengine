Shadow = class extends BaseEntity
  constructor = function(color="black", position=Vector2.make(1, -1), alpha=1, enabled=true)
    this.color = color
    this.position = position
    this.enabled = enabled
    this.alpha = alpha
  end
  
  make = function(color="black", position=Vector2.make(1, -1), alpha=1, enabled=true)
    return new Shadow(color, position, alpha, enabled)
  end
end