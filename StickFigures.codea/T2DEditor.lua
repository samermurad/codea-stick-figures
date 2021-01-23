T2DEditor = class()

function T2DEditor:init()
    self.sTransform = nil
    
    self.pos = vec2(WIDTH - 300, HEIGHT/2 - 300)
  
    self.doDraw = false
    self.gizmo = Gizmo()
  --  touches.addHandler(self)
end

function T2DEditor:select(transform)
    if self.sTransform ~= transform and transform ~= nil then
        print('new selection', transform.globalPos, transform.name)
        self.sTransform = transform
        self.doDraw = self.sTransform ~= nil
        print('should draw', self.doDraw)
    end
end

function T2DEditor:calculateGizmoPos()
    
end
function T2DEditor:update()
    self.doDraw = self.sTransform ~= nil
    self.gizmo:update()
    if self.sTransform ~= nil then
     --   print('seetting the gizmo', self.sTransform.globalPos)
        self.gizmo.pos = Transform.PosToScreenPos(self.sTransform)
    end
    
end
function T2DEditor:draw()
    self:update()
    if self.doDraw then
        self.gizmo:draw()
    end
    pushMatrix() pushStyle()
    resetMatrix()
    popMatrix() popStyle()
    -- Codea does not automatically call this method
end

--function T2DEditor:touched(touch)
    -- Codea does not automatically call this method
  --  print('yes')
    -- self.panel:touched(touch)
--end

function rRect(w,h,r,c)
    strokeWidth(0)
    fill(c.r, c.g, c.b, c.a)
    ellipse(r/2,h-r/2,r) ellipse(w-r/2,h-r/2,r)
    ellipse(r/2,r/2,r) ellipse(w-r/2,r/2,r)
    rect(0,r/2,w,h-r) rect(r/2,0,w-r,h)
end