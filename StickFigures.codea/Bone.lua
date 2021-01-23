Bone = class(Transform)

function Bone:init(opt)
    opt = opt or {}
    Transform.init(self, opt)
    self.color = opt.color or color(131, 225, 148)
    self.forward = vec2(0, 1)
end

function Bone:update()
    Transform.update(self)
end

function Bone:onDraw()
    stroke(self.color)
    fill(self.color)
    strokeWidth(5)
    line(0, 0, 15, 0)
    ellipse(0, 0, 25)
end

function Bone:touched(touch)
    Transform.touched(self, touch)
end
