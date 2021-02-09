Rectangle = class extends Drawable
  constructor = function(size=Vector2.make(screen.width, screen.height))
    this.fillColor = 0
    this.outlineColor = 0
    this.size = size
    super()
  end

  withFill = function(color)
    fillColor = color
    return this
  end

  outlineWith = function(color)
    outlineColor = color
    return this
  end
  
  draw = function(position, translation)
    if fillColor then
      screen.fillRect(position.x, position.y, size.x, size.y, fillColor)
    end
    if outlineColor then
      screen.drawRect(position.x, position.y, size.x, size.y, outlineColor)
    end
  end
end