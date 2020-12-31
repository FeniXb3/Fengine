Line = class extends Drawable
  constructor = function(start, finish, color="white")
    this.start = start
    this.finish = finish
    this.color = color
    super()
  end
  
  render = function(position, translation)
    screen.drawLine(start.x, start.y, finish.x, finish.y, color)
  end
end