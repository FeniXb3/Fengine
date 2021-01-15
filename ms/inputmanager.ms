InputManager = class extends BaseEntity
  getInstance = function()
    if not InputManager.instance then
      InputManager.instance = new InputManager()
    end
    
    return InputManager.instance
  end

  constructor = function()
    this.devices = generateDevices()
    this.keyMapping = getKeyMapping()
  end

  reset = function()
    this.devices = generateDevices()
    this.keyMapping = getKeyMapping()
  end

  generateDevices = function()
    return object
      get_keyboard = function()
        return keyboard
      end
      get_gamepad = function()
        return gamepad
      end
      get_touch = function()
        return touch
      end
      get_mouse = function()
        return mouse
      end
    end
  end

  getDevice = function(name)
    return devices["get_"+name]()
  end

  getKeyMapping = function()
    return object
      "A" = "left"
      "D" = "right"
      "W" = "up"
      "S" = "down"
    end
  end

  remap = function(role, key)
    keyMapping[key] = role
  end

  update = function(gameObjects)
    device = getDevice("keyboard")
    for key in keyMapping
      for go in gameObjects
        if device.press[key] then
          go.inputHandler[keyMapping[key]+"_press"]()
        end
        if device.release[key] then
          go.inputHandler[keyMapping[key]+"_release"]()
        end
        if device[key] then
          go.inputHandler[keyMapping[key]+"_hold"]()
        end
      end
    end
  end
end