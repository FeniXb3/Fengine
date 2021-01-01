Tweener = class
  tweens = []
  to = function(theObject, getter, setter, targetValue, duration)
    local tween = new Tween(theObject, getter, setter, targetValue, duration)
     tweens.push(tween)

     return tween
  end

  update = function()
    for t in tweens
      t.update()
    end
  end
end