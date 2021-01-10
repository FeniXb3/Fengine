// Functions based on the code from https://easings.net/

EaseType = object
  linear = function(x)
    return x
  end

  easeInSine = function(x)
    return 1 - cos((x * PI) / 2)
  end

  easeOutSine = function(x)
    return sin((x * PI) / 2)
  end
  
  easeInOutSine = function(x)
    return -(cos(PI * x) - 1) / 2
  end
  
  easeInQuad = function(x)
    return x^2
  end
  
  easeOutQuad = function(x)
    return 1 - (1 - x)^2
  end
  
  easeInOutQuad = function(x)
    return if x < 0.5 then 2 * x^2 else 1 - (-2 * x + 2)^2 / 2 end
  end

  easeInCubic = function(x)
    return x^3
  end
  
  easeOutCubic = function(x)
    return 1 - (1 - x)^3
  end
  
  easeInOutCubic = function(x)
    return if x < 0.5 then 4 * x^3 else 1 - (-2 * x + 2)^3 / 2 end
  end
  
  easeInQuart = function(x)
    return x^4
  end
  
  easeOutQuart = function(x)
    return 1 - (1 - x)^4
  end
  
  easeInOutQuart = function(x)
    return if x < 0.5 then 8 * x^4 else 1 - (-2 * x + 2)^4 / 2 end
  end
  
  easeInQuint = function(x)
    return x^5
  end
  
  easeOutQuint = function(x)
    return 1 - (1 - x)^5
  end
  
  easeInOutQuint = function(x)
    return if x < 0.5 then 16 * x^5 else 1 - (-2 * x + 2)^5 / 2 end
  end
  
  easeInExpo = function(x)
    return if x == 0 then 0 else pow(2, 10 * x - 10) end
  end
  
  easeOutExpo = function(x)
    return if x == 1 then 1 else 1- pow(2, -10 * x) end
  end
  
  easeInOutExpo = function(x)
    return if x == 0 then 0
      elsif x == 1 then 1
      elsif x < 0.5 then pow(2, 20 * x - 10) / 2
      else (2 - pow(2, -20 * x + 10)) / 2 end
  end
  
  easeInCirc = function(x)
    return 1 - sqrt(1 - pow(x, 2))
  end
  
  easeOutCirc = function(x)
    return sqrt(1 - pow(x - 1, 2))
  end
  
  easeInOutCirc = function(x)
    return if x < 0.5 then (1 - sqrt(1 - pow(2 * x, 2))) / 2
      else(sqrt(1 - pow(-2 * x + 2, 2)) + 1) / 2 end
  end
  
  easeInBack = function(x)
    local c1 = 1.70158
    local c3 = c1 + 1

    return c3 * x^3 - c1 * x^2 
  end
  
  easeOutBack = function(x)
    local c1 = 1.70158
    local c3 = c1 + 1

    return 1 + c3 * pow(x - 1, 3) + c1 * pow(x - 1, 2)
  end
  
  easeInOutBack = function(x)
    local c1 = 1.70158
    local c2 = c1 * 1.525

    return if x < 0.5 then (pow(2 * x, 2) * ((c2 + 1) * 2 * x - c2)) / 2
      else (pow(2 * x - 2, 2) * ((c2 + 1) * (x * 2 - 2) + c2) + 2) / 2 end
  end

  
  easeInElastic = function(x)
    local c4 = (2 * PI) / 3
    return if x == 0 then 0
      elsif x == 1 then 1
      else -pow(2, 10 * x - 10) * sin((x * 10 - 10.75) * c4) end
  end

  easeOutElastic = function(x)
    local c4 = (2 * PI) / 3
    return if x == 0 then 0
      elsif x == 1 then 1
      else pow(2, -10 * x) * sin((x * 10 - 0.75) * c4) + 1 end
  end

  
  easeInOutElastic = function(x)
    local c5 = (2 * PI) / 4.5
    return if x == 0 then 0
      elsif x == 1 then 1
        elsif x < 0.5 then -(pow(2, 20 * x - 10) * sin((20 * x - 11.125) * c5)) / 2
      else (pow(2, -20 * x + 10) * sin((20 * x - 11.125) * c5)) / 2 + 1 end
  end

  easeInBounce = function(x)
    return 1 - easeOutBounce(1 - x)
  end

  easeOutBounce = function(x)
    local n1 = 7.5625
    local d1 = 2.75
    
    if x < 1 / d1 then
      return n1 * x * x
    elsif x < 2 / d1 then
      return n1 * (x -= 1.5 / d1) * x + 0.75
    elsif x < 2.5 / d1 then
      return n1 * (x -= 2.25 / d1) * x + 0.9375
    else
      return n1 * (x -= 2.625 / d1) * x + 0.984375
    end    
  end
  
  easeInOutBounce = function(x)
    return if x < 0.5 then (1 - easeOutBounce(1 - 2 * x)) / 2
    else (1 + easeOutBounce(2 * x - 1)) / 2 end
  end

end