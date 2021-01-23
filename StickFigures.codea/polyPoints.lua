function isPointInPoly(p, polygon)
    local isInside = false;
    local minX, maxX = polygon[1].x, polygon[1].x
    local minY, maxY = polygon[1].y, polygon[1].y
    for n = 2, #polygon, 1 do
        local q = polygon[n]
        minX = math.min(q.x, minX)
        maxX = math.max(q.x, maxX)
        minY = math.min(q.y, minY)
        maxY = math.max(q.y, maxY)
    end
    
    if (p.x < minX or p.x > maxX or p.y < minY or p.y > maxY) then
        return false
    end
    
    local i, j = 1, #polygon
    for n = 1, #polygon, 1 do
        if (
        (polygon[i].y > p.y) ~= (polygon[j].y > p.y)
        and p.x < (polygon[j].x - polygon[i].x) * (p.y - polygon[i].y) / (polygon[j].y - polygon[i].y) + polygon[i].x
        ) then
            isInside = (not isInside)
        end
        i = n + 1
        j = n
    end
    
    return isInside;
end
