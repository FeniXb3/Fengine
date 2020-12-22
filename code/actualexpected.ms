ActualExpected = class extends BaseEntity
  constructor = function(actual, expected, onReached, onChanged)
    this.actual = actual
    this.expected = expected
    this.onReached = onReached
    this.onChanged = onChanged
  end
  
  isReached = function()
    return actual >= expected
  end
  
  handleChange = function()
    onChanged(actual, expected)
    
    if isReached() then
      onReached()
    end
  end
  
  changeBy = function(value)
    actual += value
    handleChange()
  end
  
  setTo = function(value)
    actual = value
    handleChange()
  end
end