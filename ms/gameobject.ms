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
    this.gameObject = this
  end 
  
  getPosition = function()
    return position
  end

  setPosition = function(value)
    position.setTo(value)
  end

  getEnabled = function()
    return this.enabled
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
  
  addMap = function(mapName)
    if maps[mapName] then
      this.renderable = new Map(mapName)
      this.renderable.gameObject = this
      return this.renderable
    else
      logError("Cannot create map <" + mapName + ">")
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
  
  addTouchableOnRenderable = function(onPress, onHold, onRelease)
    if renderable then
      return addTouchable(position, parent.position, renderable.size, renderable.scale, renderable.anchor, onPress, onHold, onRelease)
    else
      logError("The object <" + name + "> has no renderable.")
    end
  end

  addTouchableOnSprite = function(onPress, onHold, onRelease)
    if renderable.class == Sprite then
      return addTouchable(position, parent.position, renderable.size, renderable.scale, renderable.anchor, onPress, onHold, onRelease)
    else
      logError("Renderable of the object <" + name + "> is not a sprite.")
    end
  end
  
  addTouchableOnText = function(onPress, onHold, onRelease)
    if renderable.class == Text then
      return addTouchable(position, parent.position, renderable.size, renderable.scale, renderable.anchor, onPress, onHold, onRelease)
    else
      logError("Renderable of the object <" + name + "> is not a text.")
    end
  end
  
  addTouchableOnMap = function(onPress, onHold, onRelease)
    if renderable.class == Map then
      return addTouchable(position, parent.position, renderable.size, renderable.scale, renderable.anchor, onPress, onHold, onRelease)
    else
      logError("Renderable of the object <" + name + "> is not a map.")
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

  addColliderOnRenderable  = function(onCollision)
    if renderable then
      return addCollider(position, parent.position, renderable.size, renderable.scale, renderable.anchor, onCollision)
    else
      logError("The object <" + name + "> has no renderable.")
    end
  end
  
  addColliderOnSprite = function(onCollision)
    if renderable.class == Sprite then
      return addCollider(position, parent.position, renderable.size, renderable.scale, renderable.anchor, onCollision)
    else
      logError("Renderable of the object <" + name + "> is not a sprite.")
    end
  end
  
  addCollider = function(position, translation, size, scale, anchor, onCollision)
    if size and scale and anchor then
      this.collider = new Collider(position, translation, size, scale, anchor, onCollision)
      this.collider.gameObject = this
      return this.collider
    else
      logError("Adding collider to game object <" + name + "> was not possible. "
        + "Provided values: size=" + size.getInfo() + " scale=" + scale.getInfo() + " anchor="+anchor.getInfo())
    end
  end
  
  addRigidBody = function()
    this.rigidBody = new RigidBody()
    this.rigidBody.gameObject = this
    return this.rigidBody
  end

  addInputHandler = function()
    this.inputHandler = new InputHandler()
    this.inputHandler.gameObject = this
    return this.inputHandler
  end

  addAnimator = function(name)
    this.renderable = new Animator(name)
    this.renderable.gameObject = this
    return this.renderable
  end
  
  addRectangle = function(size=Vector2.make(screen.width, screen.height))
    this.renderable = new Rectangle(size)
    this.renderable.gameObject = this
    return this.renderable
  end

  addRound = function(size)
    this.renderable = new Round(size)
    this.renderable.gameObject = this
    return this.renderable
  end
  
  update = function()
    onUpdate()
    enableChangeAction()
  end
  
  draw = function()
    renderable.render(position, parent.position)
  end
end
