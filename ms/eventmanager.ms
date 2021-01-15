EventManager = class extends BaseEntity
  getInstance = function()
    if not EventManager.instance then
      EventManager.instance = new EventManager()
    end
    
    return EventManager.instance
  end
  
  constructor = function()
    this.events = object end
  end

  reset = function()
    this.events = object end
  end
  
  addListener = function(eventType, listenerName, target)
    if not hasEvent(eventType) then
      events[eventType] = new Event(eventType)
    end
    
    events[eventType].addListener(listenerName, target)
  end
  
  // removeListener = function(eventType, listener)
    
  // end
  
  triggerEvent = function(eventType, data)
    if hasEvent(eventType) then
      local event = events[eventType]
      event.trigger(data)
    else
      logError("Event <"+eventType+"> does not exist")
    end  
  end
  
  hasEvent = function(eventType)
    return events[eventType]
  end
end