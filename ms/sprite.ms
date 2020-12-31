Sprite = class extends Drawable
  constructor = function(name)
    this.image = sprites[name]
    this.size = new Vector2(this.image.width, this.image.height)
    super()
  end
 
  draw = function(position, translation)
    screen.drawSprite(image, position.x, position.y, size.x, size.y)
  end
end