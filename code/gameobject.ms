GameObject = class extends BaseEntity
  constructor = function(name, x, y, onUpdate, enableChangeAction)
    this.name = name
    this.position = new Vector2(x, y)
    this.children = []
    // TODO: Add setEnable(value) function to handle possible animations
    // or other cool stuff before disabling/after enabling
    this.enabled = true
    this.enableChangeAction = enableChangeAction
    this.onUpdate = onUpdate
  end
  
  setEnabled = function(value)
    this.enabled = value
  end
  
  addSprite = function(spriteName)
    if sprites[spriteName] then
      this.renderable = new Sprite(spriteName)
      this.renderable.gameObject = this
      return this.renderable
    else
      logError("Cannot create sprite <" + spriteName + ">")
    end
  end
  
  addLine = function(start, finish, color="white")
    this.renderable = new Line(start, finish, color)
    this.renderable.gameObject = this
    
    return this.renderable
  end
  
  addText = function(content, height, color, font="BitCell")
    this.renderable = new Text(content, height, color, font)
    this.renderable.gameObject = this
    return this.renderable
  end
  
  // TODO: Think of better name for actualExpected
  addActualExpected = function(actual, expected, onReached, onChanged)
    this.actualExpected = new ActualExpected(actual, expected, onReached, onChanged)
    this.actualExpected.gameObject = this
    return actualExpected
   end
  
  addChild = function(child)
    children.push(child)
    child.setParent(this)
  end
  
  setParent = function(go)
    this.parent = go
    // TODO: Handle it in more generic way
    if this.touchable then
      this.touchable.bounds.translation = parent.position
      //getTranslation()
    end
  end
  
  // TODO: Fix
  getTranslation = function()
    local current = this
    local translation = Vector2()
    while current.parent
      translation.changeBy(current.parent.position)
      current = current.parent
    end
    
    return translation
  end
  
  addTouchableOnSprite = function(onPress, onHold, onRelease)
    if renderable.class == Sprite then
      return addTouchable(position, parent.position, renderable.size, renderable.scale, renderable.anchor, onPress, onHold, onRelease)
    else
      logError("Renderable of the object <" + name + "> is not a sprite.")
    end
  end
  
  addTouchable = function(position, translation, size, scale, anchor, onPress, onHold, onRelease)
    if size and scale and anchor then
      this.touchable = new Touchable(position, translation, size, scale, anchor, onPress, onHold, onRelease)
      this.touchable.gameObject = this
      return this.touchable
    else
      logError("Adding touchable to game object <" + name + "> was not possible. "
        + "Provided values: size=" + size.getInfo() + " scale=" + scale.getInfo() + " anchor="+anchor.getInfo())
    end
  end
 
  checkTouch = function()
    if this.touchable then
      local bounds = this.touchable.bounds
      if touch.press and bounds.isPointInside(touch) then
        this.touchable.onPress()
      elsif touch.touching and bounds.isPointInside(touch) then
        this.touchable.onHold()
      elsif touch.release and bounds.isPointInside(touch) then
        this.touchable.onRelease()
      end
    end
  end  
  
  update = function()
    onUpdate()
    enableChangeAction()
    
    if enabled then
      checkTouch()
    end
  end
  
  draw = function()
    renderable.render(position, parent.position)
  end
end
