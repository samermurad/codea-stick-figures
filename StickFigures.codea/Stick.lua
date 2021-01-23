Stick = class(Transform)

function Stick:init(opt)
    -- you can accept and set parameters here
    opt = opt or {}
    opt.name = opt.name or 'Stick'
    Transform.init(self, opt)
    self.length = opt.length or 150
    self.width = opt.width or 15
    self.color = opt.color or color(255)
    self.polygonPoints = self:calculatePolygonPoints()
    
    self.connected = type(opt.connected) ~= 'boolean' and true or opt.connected

end

function Stick:update()
    self.mode = CORNER
    local didUpdate = Transform.update(self)
    if didUpdate then
        self.polygonPoints = self:calculatePolygonPoints()
    end
end

function Stick:onDraw()
    if self.width <= 3 then
        noSmooth()
    else
        smooth()
    end
    lineCapMode(ROUND)


    strokeWidth(self.width)
    stroke(self.color)
    line(0, 0, self.length, 0)
    
    
    pushMatrix() pushStyle()
    local bbox = self:boundingBox()
    local cx = bbox.x + bbox.z / 2
    local cy = bbox.y + bbox.w / 2
    local gx, gy = Transform.PosToScreenPos(self):unpack()
    
    resetMatrix()
    strokeWidth(2)

    local p = self.polygonPoints
    local first
    for i, v in pairs(p) do
        stroke(153, 233, 80)
        strokeWidth(2)
        if i == 1 then
            first = v
            line(first.x, first.y, p[#p].x, p[#p].y)
        end
        if first then
            line(first.x, first.y, v.x, v.y)
            first = v
        end
    end
    
    popMatrix() popStyle()
end

function pointIsInPoly(p, polygon)
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

function Stick:calculatePolygonPoints()
    local d = self.width / 2
    local d2 = d + self.length

    local ts = {
        vec2(-d, d),
        vec2(-d, -d),
        vec2(d2, -d),
        vec2(d2, d)
    }
    
    local p = {}
    for _, t in ipairs(ts) do
        local m = matrix()
        m = m:translate(t.x, t.y)
        m = m * self.mtx
        table.insert(p, vec2(m[13], m[14]))
    end
    
    return p
end
function Stick:boundingBox()
    local x,y = Transform.PosToScreenPos(self):unpack()

    local fx, fy = self.forward:unpack()
    local angle = math.atan2(self.mtx[2], self.mtx[1])
    local w, h = self.length, self.width -- dummy size for base transform
    if self.mode == CENTER then
        x = x - (w * self.scale.x / 2)
        y = y - (h * self.scale.y / 2)
    end
    w = w * self.scale.x
    h = h * self.scale.y
    local endMtx = self.mtx * vec4(w, 0, 0, 1)
    w = (self.mtx[1]) * self.length
    
    h = (self.mtx[2]) * self.length
    local yOffset = self.width / 2
    local x2 = x+ w
    local y2 = y+ h
    return vec4(x - yOffset, y - yOffset, x2, y2 + yOffset)
end
function Stick:inBounds(t)
    return pointIsInPoly(t.pos, self.polygonPoints)
    --[[
    local bbox = self:boundingBox()
    local x = math.min(bbox.x, bbox.z)
    local y = math.min(bbox.y, bbox.w)
    local x2 = math.max(bbox.x, bbox.z)
    local y2 = math.max(bbox.y, bbox.w)
    print('inbounds', x, y, x2, y2, t)
    return t.pos.x >= x and t.pos.x <= x2 and t.pos.y >= y and t.pos.y <= y2
    ]]--
end
--[[
function Stick:draw()
    self:update()
    pushMatrix() pushStyle()
    modelMatrix(self.mtx)
    popMatrix() popStyle()
    -- Codea does not automatically call this method
end
]]--
function Stick:touched(touch)
    Transform.touched(self, touch)
    -- Codea does not automatically call this method
end
