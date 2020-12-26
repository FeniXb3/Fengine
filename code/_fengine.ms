Fengine = class

  getInstance = function()
    if not Fengine.instance then
      Fengine.instance = new Fengine()
    end
    
    return Fengine.instance
  end
  
  constructor = function()
    this.gameObjects = []
    this.clearColor = "black"
    this.logger = new Logger()
    this.eventManager = EventManager.getInstance()
  end
  
  addGameObject = function(name, x, y)
    local go = new GameObject(name, x, y)
    gameObjects.push(go)
    
    return go
  end
  
  // findGameObject = function(name)
  //   for go in gameObjects
  //     if go.name == name then
  //       logger.logInfo(go.getInfo())
  //       return go
  //     end
  //   end
    
  //   logger.logError("The game object <" +name + "> does not exist.")
  // end
  
  
  findGameObject = function(name)
    local result = 0
    for go in gameObjects
      if go.name == name then
        result = go
      end
    end
    
    if not result then
      logger.logError("The game object <" +name + "> does not exist.")
    end
    
    return result
  end  
  
  update = function()
    // TODO: Make separate loops for handling different components
    for go in gameObjects
      go.update()
    end
  end
  
  draw = function()
    clearScreen()
    for go in gameObjects
      if go.enabled and go.renderable then
        go.draw()
      end
    end
  end
  
  clearScreen = function()
    screen.fillRect(0,0, screen.width, screen.height, clearColor)
  end
  
  getScreenBounds = function()
    local widthHalf = screen.width/2
    local heightHalf = screen.height/2
    
    local bounds = object end
    bounds.left = 0 - widthHalf - (widthHalf * screen.anchor.x)
    bounds.right = bounds.left + screen.width
    bounds.bottom = 0 - heightHalf - (heightHalf * screen.anchor.y)
    bounds.top = bounds.bottom + screen.height
     
     return bounds
  end
end