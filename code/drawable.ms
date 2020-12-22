Drawable = class extends BaseEntity
  constructor = function(alpha=1, scale=Vector2.makeOne(), angle=0, anchor=Vector2.makeZero())
    this.alpha = alpha
    this.angle = angle
    this.scale = scale
    this.anchor = anchor
  end
  
  withAlpha = function(alpha)
    this.alpha = alpha
    return this
  end
  
  withScale = function(scale)
    this.scale = scale
    return this
  end
  
  withAngle = function(angle)
    this.angle = angle
    return this
  end
  
  withAnchor = function(anchor)
    this.anchor = anchor
    return this
  end
  
  
  render = function(position, translation)
    setupScreen(translation)
    draw(position, translation)
    resetScreen()
  end
  
  setupScreen = function(translation)
    screen.setTranslation(translation.x, translation.y)
    screen.setDrawRotation(angle)
    screen.setAlpha(alpha)
    screen.setDrawAnchor(anchor.x, anchor.y)
    screen.setDrawScale(scale.x, scale.y)
  end
  
  resetScreen = function()
    screen.setDrawScale(1, 1)
    screen.setDrawAnchor(0, 0)
    screen.setAlpha(1)
    screen.setDrawRotation(0)
    screen.setTranslation(0, 0)
  end
end