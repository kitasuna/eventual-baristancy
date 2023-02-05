dad = {
  state = "sleep",
  ttl = 0,
  draw = function(d)
    if d.state == "sleep" then return end
    palt(15, true)
    palt(0, false)
    spr(19,88,15)
    pal()
  end,
  update = function(d,dt)
    if d.state == "sleep" then return end
    d.ttl -= dt

    if d.ttl <=4.5 and d.state == "wake" then
      d.state = "throw"
      powerup.state = "wake"
    end

    if d.ttl <= 0 then
      d.state = "sleep"
      d.ttl = 0
    end
  end,
}

powerup = {
  ttl = 3,
  x=96,
  y=16,
  collr=4,
  state = "sleep",
  draw = function(p)
    if p.state == "sleep" then return end
    palt(0,false)
    palt(15,true)
    spr(20,p.x,p.y)
    pal()
  end,
  update = function(p,dt)
    if p.state == "sleep" then return end
    p.ttl -= dt
    if p.ttl <= 0 then
      p.state = "sleep"
      p.ttl = 3
    end
  end,
  handle_collision = function(p)
    p.ttl = 3
    p.state = "sleep"
    _mods.slow_baddies = true
    _mods.rand_sword = true
    add(_mod_timers, {ttl=7, cb = function()
      _mods.slow_baddies = false
      _mods.rand_sword = false
      _sword_cycle_time = 1.5
    end})
  end,
}
