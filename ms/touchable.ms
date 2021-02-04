Touchable = class extends BaseEntity
  constructor = function(position, translation, size, scale, anchor, onPress, onHold, onRelease)
    this.bounds = new Bounds(position, translation, size, scale, anchor)
    this.onPress = onPress
    this.onHold = onHold
    this.onRelease = onRelease  
  end

  setOnPress = function(onPress)
    this.onPress = onPress
    return this
  end

  setOnHold = function(onHold)
    this.onHold = onHold
    return this
  end

  setOnRelease = function(onRelease)
    this.onRelease = onRelease
    return this
  end
end