Bone = class(Transform)

function Bone:init(opt)
    opt = opt or {}
    Transform.init(self, opt)
    self.color = opt.color or color(131, 225, 148)
    self.forward = vec2(0, 1)
end

function Bone:update()
   -- print('shoyld upadate')
    Transform.update(self)
    --print('wot')
end

function Bone:draw()
   -- Transform.draw(self)
    self:update()
    pushMatrix() pushStyle()
    resetMatrix()
    modelMatrix(self.mtx)
    --zLevel(1)
    stroke(self.color)
    fill(self.color)
    strokeWidth(5)
    line(0, 0, 15, 0)
    ellipse(0, 0, 25)
    popMatrix() popStyle()
    -- Codea does not automatically call this method
end

function Bone:touched(touch)
    Transform.touched(self, touched)
    -- Codea does not automatically call this method
end
