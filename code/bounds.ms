Bounds = class extends BaseEntity
  constructor = function(position, translation, size, scale, anchor)
    this.position = position
    this.translation = translation
    this.size = size
    this.scale = scale
    this.anchor = anchor
  end
  
  // TODO: Handle rotation
  calculate = function()
    local widthHalf = (size.x * scale.x)/2
    local heightHalf = (size.y * scale.y)/2
    local bounds = object end
    bounds.left = position.x + translation.x
      - widthHalf - (widthHalf * anchor.x)
    bounds.right = bounds.left + (size.x * scale.x)
    bounds.bottom = position.y + translation.y
      - heightHalf - (heightHalf * anchor.y)
    bounds.top = bounds.bottom + (size.y * scale.y)
     
    return bounds
  end
  
  isPointInside = function(point)
    local bounds = calculate()
    
    return point.x >= bounds.left and point.x <= bounds.right
      and point.y >= bounds.bottom and point.y <= bounds.top
  end
end