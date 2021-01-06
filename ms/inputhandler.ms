InputHandler = class extends BaseEntity
  constructor = function()
  end

  reactOn = function(name, type, handler)
    local handlerName  = name+"_"+type
    this[handlerName] = handler

    return this
  end
end