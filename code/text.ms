Text = class extends Drawable
  constructor = function(content, height, color, font="BitCell")
    local width = screen.textWidth(content, height)
    this.content = content
    // TODO: Handle changing font before measuring text
    this.size = new Vector2(width, height)
    this.color = color
    this.font = font
    super()
  end
  
  draw = function(position, translation)
    screen.setFont(font)
    if shadow.enabled then
      screen.setAlpha(this.alpha*shadow.alpha)
      screen.drawText(content, position.x+shadow.position.x, 
        position.y+shadow.position.y, size.y, shadow.color)
      screen.setAlpha(this.alpha)
    end
      
    screen.drawText(content, position.x, position.y, size.y, color)
  end
  
  withShadow = function(shadow)
    this.shadow = shadow
    return this
  end
end