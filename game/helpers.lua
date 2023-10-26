function randomCoordinate()
  return { math.random(0, display.contentWidth), math.random(0, display.contentHeight) };
end

function findSpot(refs)
  for i,value in ipairs(refs) do
    if not value.isBurned and not value.hasFire then
      return i
    end
  end
  return nil
end
