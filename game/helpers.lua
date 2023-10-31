function randomCoordinate()
  return { math.random(45, display.contentWidth - 45), math.random(45, display.contentHeight - 45) };
end

function findSpot(refs)
  if math.random(1, 2) == 1 then
    for i = 1, #refs do
      if not refs[i].isBurned and not refs[i].hasFire then
        return i
      end
    end
  else
    for i = #refs, 1, -1 do
      if not refs[i].isBurned and not refs[i].hasFire then
        return i
      end
    end
  end
  -- for i,value in ipairs(refs) do
  --   if not value.isBurned and not value.hasFire then
  --     return i
  --   end
  -- end
  return nil
end

-- returns the degrees between (0,0) and pt (note: 0 degrees is 'east')
function angleOfPoint( pt )
  local x, y = pt.x, pt.y
  local radian = math.atan2(y,x)
  local angle = radian*180/math.pi
  if angle < 0 then angle = 360 + angle end
  return angle
end

-- returns the degrees between two points (note: 0 degrees is 'east')
function angleBetweenPoints( a, b )
  local x, y = b.x - a.x, b.y - a.y
  return angleOfPoint( { x=x, y=y } )
end
