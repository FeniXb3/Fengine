Vector2 = class extends BaseEntity
  constructor = function(x, y)
    this.x = x
    this.y = y
  end
  
  make = function(x, y)
    return new Vector2(x, y)
  end

  makeZero = function()
    return new Vector2(0, 0)
  end
  
  makeOne = function()
    return new Vector2(1, 1)
  end
  
  changeBy = function(change)
    this.x += change.x
    this.y += change.y
  end
  
  setTo = function(value)
    this.x = value.x
    this.y = value.y
  end
  
  subtract = function(other)
    return new Vector2(x - other.x, y - other.y)
  end
  
  getDistanceTo = function(other)
    return sqrt((x-other.x)^2 + (y-other.y)^2)
  end
  
  divideByScalar = function(value)
    return new Vector2(x/value, y/value)
  end
end
