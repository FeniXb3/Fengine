InputManager = class extends BaseEntity
  getInstance = function()
    if not InputManager.instance then
      InputManager.instance = new InputManager()
    end
    
    return InputManager.instance
  end
  
  
end