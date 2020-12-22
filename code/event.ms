Event = class extends BaseEntity
  constructor = function(eventType)
    this.eventType = eventType
    this.listeners = []
  end
  
  addListener = function(listenerName, target)
    if not listenerName or not target then
      logError("Event listener name or target is wrong or missing for event <" + eventType +">.")
    else
      this.listeners.push(object 
        name = listenerName
        target = target
      end)
    end
  end
  
  // removeListener = function(listener)
  //   this.listeners.removeElement(listener)
  // end
    
  trigger = function(data)
    for l in listeners
        l.target[l.name](data)
    end
  end
end