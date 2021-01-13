Tween = class
  constructor = function(theObject, getter, setter, targetValue, duration)
    this.theObject = theObject 
    this.getter = getter
     this.setter = setter
     this.targetValue = targetValue
     if this.theObject[this.getter]().copy then
      this.startValue = this.theObject[this.getter]().copy()
     else
      this.startValue = this.theObject[this.getter]()
     end
     this.duration = duration
     this.startTime = system.time()
     this.lastUpdateTime = system.time()
     this.plannedFinishTime = this.startTime + duration * 1000
     this.finished = false
     this.secondsPassed = 0
     this.ease = "linear"
     this.delay = 0

     if this.startValue.subtract then
        this.diff = this.targetValue.subtract(this.startValue)
    else
        this.diff = this.targetValue - this.startValue
    end
  end

  setEase = function(ease)
    this.ease = ease

    return this
  end

  setDelay = function(delay)
    this.delay = delay

    return this
  end

  setOnFinished = function(onFinished)
    this.onFinished = onFinished

    return this
  end

  update = function()
    currentTime = system.time()
    secondsPassed = ((currentTime - startTime) / 1000) - delay
    if secondsPassed < 0 then
      return
    end

    if secondsPassed >= duration and not finished then
        finished = true
        theObject[setter](targetValue)
        onFinished(theObject)
        return
    elsif not finished then
        fractionDone = EaseType[ease](secondsPassed/duration)
        currentValue = theObject[getter]()

        if startValue.add then
            theObject[setter](startValue.add(diff.multiplyByScalar(fractionDone)))
        else
            theObject[setter](startValue + (diff*fractionDone))
        end
    end
  end
end