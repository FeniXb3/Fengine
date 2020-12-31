ActualExpected = class extends BaseEntity
  constructor = function(actual, expected, onReached, onChanged)
    this.actual = actual
    this.expected = expected
    this.onReached = onReached
    this.onChanged = onChanged
    this.allowExcess = true
  end
  
  setAllowExcess = function(value)
    allowExcess = value
  end
  
  isReached = function()
    return actual >= expected
  end
  
  willExceed = function(value)
    return actual+value > expected
  end
  
  handleChange = function()
    onChanged(actual, expected)
    
    if isReached() then
      onReached()
    end
  end
  
  changeBy = function(value)
    if not allowExcess and willExceed(value) then
      return false
    end
    
    actual += value
    handleChange()
    
    return true
  end
  
  setTo = function(value)
    actual = value
    handleChange()
  end
end