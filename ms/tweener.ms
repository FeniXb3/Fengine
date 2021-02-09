Tweener = class extends BaseEntity
  tweens = object end

  reset = function()
    this.tweens = object end
  end

  to = function(theObject, getter, setter, targetValue, duration)
    local tween = new Tween(theObject, getter, setter, targetValue, duration)
    // TODO: Handle this in general way
    local goName = if theObject.gameObject then theObject.gameObject.name else theObject.name end
    if not goName then
      logError("[Tweener] Could not get name for the object " theObject)
    end

    local tweenName = goName+"_"+getter+"_"+setter
    if tweens[tweenName] then
      tweens[tweenName].finished = true
    end
    tweens[tweenName] = tween

    return tween
  end

  stop = function(tweenName)
    if tweens[tweenName] then
      tweens[tweenName] = 0
    end
  end

  update = function()
    for t in tweens
      if tweens[t].finished then
        tweens[t] = 0
      end
      if not tweens[t] then
        continue
      end

      tweens[t].update()
    end
  end
end