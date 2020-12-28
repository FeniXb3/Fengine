Map = class extends Drawable
  constructor = function(name)
    this.tileMap = maps[name]
    this.mapSize = new Vector2(this.tileMap.width, this.tileMap.height)
    this.blockSize = new Vector2(this.tileMap.block_width, this.tileMap.block_width)
    this.size = this.mapSize.multiply(this.blockSize)
    super()
  end
 
  draw = function(position, translation)
    screen.drawMap(tileMap, position.x, position.y, size.x, size.y)
  end
  
  getCoords = function(point)
    local indexX = floor((point.x + size.x/2) / (blockSize.x * scale.x))
    local indexY = floor((point.y + size.y/2) / (blockSize.y * scale.y))
    
    return new Vector2(indexX, indexY)
  end
  
  get = function(coords)
    return tileMap.get(coords.x, coords.y)
  end
  
  set = function(coords, name)
    tileMap.set(coords.x, coords.y, name)
  end
  
  clearAt = function(coords)
    set(coords, "")
  end
end