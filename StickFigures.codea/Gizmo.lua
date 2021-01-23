Gizmo = class(Transform)

function Gizmo:init(opt)
    opt = opt or {}
    Transform.init(self, opt)
    self.target = nil
    -- you can accept and set parameters here
end

function Gizmo:setTarget(target)
end
function Gizmo:update()
    self.scale = vec2(1,1)
    Transform.update(self)
end
function Gizmo:onDraw()
    -- Y Axis
    stroke(58, 122, 232)
    strokeWidth(2)
    line(0, 0, 0, 75)
    fill(58, 122, 232)
    text("Y <- ->", 0, 90)

    line(0, 25, 25, 25)
    -- X Axis
    stroke(235, 91, 59)
    fill(227, 86, 54)
    line(0, 0, 75, 0)
    text("X <- ->", 110, 0)
    
    line(25, 0, 25, 25)
    -- Rotation
    noFill()
    stroke(229, 232, 49)
    
    ellipse(0,0, 55)
    -- Codea does not automatically call this method
end

function Gizmo:touched(touch)
    -- noop
end
