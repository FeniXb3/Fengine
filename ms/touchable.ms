Touchable = class extends BaseEntity
  constructor = function(position, translation, size, scale, anchor, onPress, onHold, onRelease)
    this.bounds = new Bounds(position, translation, size, scale, anchor)
    this.onPress = onPress
    this.onHold = onHold
    this.onRelease = onRelease  
  end
end