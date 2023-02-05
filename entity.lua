entitydef = {
  {
    s = 3,
    update = function() end,
    draw = function(e)
    end,
  }
}
_baddie_frame_cycle = 0.06
ent_m = {
  ents = {},
  draw = function(em)
    foreach(em.ents, function(e) e:draw() end)
  end,
  update = function(em,dt)
    foreach(em.ents, function(e) 
      e:update(dt)
      -- unset if way off screen
      if e.x > 140 or e.x < -16 then
        del(em.ents, e)
      end
      if e.y > 140 or e.y < -16 then
        del(em.ents, e)
      end
    end)
  end,
  add = function(em,s,x,y,vx,vy)
    local e = {
      x=x,
      y=y,
      vx=vx,
      vy=vy,
      s=s,
      frames = {2,3,4},
      offset_y = {0,0,0},
      offset_x = {0,0,0},
      curr_frame = 1,
      frame_time = 0,
      state="live",
      collr=4,
      draw = function(e)
        palt(0, false)
        palt(15, true)
        if e.state == "live" then
          spr(e.s,e.x-4,e.y-4)
        else
          spr(e.frames[e.curr_frame],e.x-4,e.y-4)
        end
        pal()
        if _debug then
          circ(e.x,e.y,e.collr,7)
        end
      end,
      update = function(e, dt)
        if e.state == "live" then
          local downtown = rnd()
          if e.x > 32 and e.x < 96 and downtown > 0.98 then
            e.vx = 0 
            e.vy = 1
          end
        else
          e.frame_time += dt
          if e.frame_time > _baddie_frame_cycle then
            e.curr_frame += 1
            if e.curr_frame > #e.frames then
              e.curr_frame = 1
              del(ent_m.ents, e)
              -- baddie death
              _year_cycle_time = max(1, _year_cycle_time * 0.9)
            else
              e.frame_time = 0
            end
          end
        end
        e.x += e.vx * (_mods.slow_baddies and 0.2 or 1)
        e.y += e.vy * (_mods.slow_baddies and 0.2 or 1)
      end
    }
    -- setmetatable(e,{__index=1})
    add(em.ents, e)
  end,
  handle_collision = function(em, e)
    e.state = "dead"
    e.vy = -e.vy
    e.vx = -e.vx 
  end,
}

spawn = {
  update = function(sp, dt)
  -- based on dt, spawn some enemy
  end
}
