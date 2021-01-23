Circle = class(Transform)

function Circle:init(opt)
    -- you can accept and set parameters here
    opt = opt or {}
    opt.name = opt.name or 'Circle'
    Transform.init(self, opt)
    self.r = opt.r or 50
    self.pivot = vec2(0.5, 0.5)
    self.color = opt.color or color(255)
    self.forward = vec2(0, 1)
end

function Circle:draw()
    self:update()
    pushMatrix() pushStyle()
    resetMatrix()
    modelMatrix(self.mtx)
   -- zLevel(1)
    stroke(self.color)
    fill(self.color)
    strokeWidth(5)
    ellipse(0,0, self.r)
    pushMatrix()
    resetMatrix()
    fill(255, 14, 0)
    popMatrix()
    popMatrix() popStyle()
--[[
    pushMatrix() pushStyle()
    local bbox = self:boundingBox()
    resetMatrix()
    strokeWidth(2)
    fill(15, 44, 78, 122)
    rect(bbox.x, bbox.y, bbox.w, bbox.h)
    stroke(255, 14, 0)
    line(bbox.x, bbox.y, bbox.x + self.forward.x * 25, bbox.y + self.forward.y * 25)
    fill(255)
    text('' .. tostring(self.globalScale), bbox.x + bbox.w / 2, bbox.y + bbox.h / 2)
    popMatrix() popStyle()
--]]
end

function Circle:boundingBox()
    local x,y = Transform.PosToScreenPos(self):unpack()
    local w, h = self.r, self.r -- dummy size for base transform

    if self.mode == CENTER then
         x = x - (w / 2)
         y = y - (h / 2)
    end
    return {x = x, y = y, w = w * self.scale.x, h = h * self.scale.y}
end

function Circle:inBounds(t)
    return Transform.inBounds(self, t)
end

function Circle:touched(touch)
    Transform.touched(self, touch)
end
