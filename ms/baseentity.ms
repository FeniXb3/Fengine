BaseEntity = class
  // TODO: Implement
  checkPrerequisites = function()
    
  end
  
  // TODO: Handle formatting text like "GameObject {0} does not exist"
  logError = function(text)
    Fengine.getInstance().logger.logError(text)
  end
  
  logInfo = function(text)
    Fengine.getInstance().logger.logInfo(text)
  end
  
  getInfo = function(depth)
    local info = "{"
    for key in this
      fieldsCount += 1
      local value =  if key == "class" then getClassName() 
        else getFieldValue(key, depth) end
      info += key + "=" + value + " "
    end
    info += "}"
    
    return if fieldsCount then info end
  end
  
  getClassName = function()
    for key in global
      if this.class == global[key] then
        return key
      end
    end
  end
  
  getFieldValue = function(key, depth)
    local value = if depth then this[key].getInfo(depth-1) else this[key] end
    
    return if not value then this[key] else value end
  end
end