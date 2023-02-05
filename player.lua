_base_vel = 1
player = {
  x = 58,
  y = 58,
  health = 6,
  ittl = 0,
  collr = 4,
  direction = 0,
  vx = 0,
  vy=0,
  draw = function(p, dt)
    palt(0,false)
    palt(15,true)

    if p.ittl == 0 or flr((dt*100)) % 2 == 0 then
      spr(5+p.health,p.x-4,p.y-4,1,1,(p.direction == 0 and true or false))
    end
    if _debug then
      circ(p.x,p.y,p.collr,7)
    end
    pal()
  end,
  update = function(p,dt)
    local vel_x,vel_y = p.vx,p.vy
    if btn(0) then --left
      vel_x = -_base_vel
      p.direction = 1
    end
    if btn(1) then --right
      vel_x = _base_vel
      p.direction = 0
    end
    if btn(2) then --right
      vel_y = -_base_vel
    end
    if btn(3) then --right
      vel_y = _base_vel
    end

    -- Map collision
    local tile_x = mget((p.x + vel_x) \ 8, (p.y - _map_y_offset) \ 8)
    local tile_y = mget(p.x \ 8, (p.y + vel_y - _map_y_offset) \ 8)
    if fget(tile_x, 0) then
      vel_x = 0 
    end
    if fget(tile_y, 0) then
      vel_y = 0 
    end

    p.x += vel_x
    p.y += vel_y
    -- reset stored velocities
    p.vx,p.vy = 0,0

    if p.x > 128 then p.x = 128 end
    if p.x < 0 then p.x = 0 end
    if p.y > 128 then p.y = 128 end
    if p.y < 16 then p.y = 16 end

    if p.ittl > 0 then
      p.ittl -= dt
      if p.ittl < 0 then p.ittl = 0 end
    end
  end,
  handle_collision = function(p,ex,ey)
    if p.ittl > 0 then
      return
    else
      _particles.pos_x = p.x
      _particles.pos_y = p.y
      for i=0,40 do
        _particles.add(4, 4, true, true, 59) 
      end
      p.ittl = 2
      p.health -= 1
      if p.health == 0 then
        sword.ttl = 0
      end

      local v = vtoward(p.x,p.y,ex,ey)
      p.vx = v.x*8
      p.vy = v.y*8

      if p.health < 0 then
        __draw = defeat_draw
        __update = defeat_update
        music(-1, 1000)
      end
    end


  end
}

_sword_frame_cycle = 0.05
sword = {
  ttl = 0,
  direction = 0,
  collr = 4,
  frames = {16,17,18},
  offset_y = {-6,0,4},
  offset_x = {-4,0,2},
  curr_frame = 1,
  frame_time = 0,
  draw = function(s)
    if s.ttl > 0 then
      palt(0, false)
      palt(15, true)
      spr(s.frames[s.curr_frame],s.x-4,s.y-4,1,1,s.direction == 1 and true or false)
      pal()
      if _debug then
        circ(s.x,s.y,4,7)
      end
    end
  end,
  update = function(s, dt, x, y)
    s.frame_time += dt
    if s.frame_time > _sword_frame_cycle then
      s.curr_frame += 1
      if s.curr_frame > #s.frames then
        s.curr_frame = 1
      end
      s.frame_time = 0
    end
    s.x,s.y = (s.direction == 1 and x + 8 or x - 8), (y + s.offset_y[s.curr_frame])
    if s.ttl > 0 then
      s.ttl -= dt
      if s.ttl < 0 then s.ttl = 0 end
    end
  end,
  fire = function(s)
    s.ttl = _sword_cycle_time * 0.9
    s.direction = s.direction == 0 and 1 or 0
  end,
}
