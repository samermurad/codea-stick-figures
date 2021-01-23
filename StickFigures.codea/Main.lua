-- StickFigures
-- Use this function to perform your initial setup

function stickman()
    local pelvis = Circle{
        r = 17,
        rot = 90
    }
    local waist = Stick{
        parent = pelvis,
        pos = vec2(0, 0),
        length = 50,
      --  rot = 90
    }
    local torso = Stick{
        parent = waist,
        pos = vec2(50, 0),
        length = 50,
       -- rot = -90
    }
    local neck = Circle{
        parent = torso,
        pos = vec2(60,0),
        color = color(233, 89, 80),
        r = 10,
    }
    local head = Circle{
        parent = neck,
        pos = vec2(25, 0),
        r = 70,
        rot = -90
    }
    
    local leftArm = Stick{
        parent = torso,
        pos = vec2(50,0),
        rot = 135,
        length = 70
    }
    
    local leftLowerArm = Stick{
        parent = leftArm,
        pos = vec2(70,0),
        rot = 75,
        length = 50
    }
    
    local rightArm = Stick{
    parent = torso,
    pos = vec2(50,0),
    rot = -135,
    length = 70
    }
    local rightLowerArm = Stick{
    parent = rightArm,
    pos = vec2(70,0),
    rot = 75,
    length = 50
    }
    
    
    local leftThigh = Stick{
    parent = pelvis,
    pos = vec2(0,0),
    rot = -180,
    length = 70
    }
    
    local lefLeg = Stick{
    parent = leftThigh,
    pos = vec2(70,0),
    rot = -75,
    length = 70
    }
    
    
    local rightThigh = Stick{
    parent = pelvis,
    pos = vec2(0,0),
    rot = -135,
    length = 70
    }
    
    local rightLeg = Stick{
    parent = rightThigh,
    pos = vec2(70,0),
    rot = -75,
    length = 70
    }
    
    return pelvis, waist, torso, neck, head, leftArm, leftLowerArm, rightArm, rightLowerArm, leftThigh, lefLeg, rightThigh, rightLeg
end

function club()
    local bCol = color(50)
    local mCol = color(161, 193, 199)
    local base = Stick{
        pos = vec2(WIDTH / 2 + 150, HEIGHT / 2),
        color = bCol
    }
    local head = Circle{
        r = 10,
        color = bCol,
        pos = vec2(base.length, 0),
        parent = base,
    }
    local mace1 = Circle{
        r = 75,
        scale = vec2(0.2, 1),
        parent = head,
        color = mCol,
    
    }
    local mace2 = Circle{
        r = 75,
        scale = vec2(0.2, 1),
        color = mCol,
        pos = vec2(mace1.r * mace1.scale.x, 0),
        parent = head
    }
    return base, head, mace1, mace2
end
function concat(t1, t2)
    for _,v in ipairs(t2) do
        table.insert(t1, v)
    end
end
function setup()
    stick = Stick()
    stick2 = Stick{
    parent = stick,
    pos = vec2(150, 0)
    }
    boneOne = Bone()
    boneTwo = Bone({
    parent = boneOne,
    pos = vec2(150, 0)
    })
    list = {
    --[[
    stick,
    stick2,
    Stick{
    parent = stick2,
    connected = false,
    pos = vec2(160, 0)
    },
    --[[
    DottedCircle({
    cx = WIDTH * 7/8,
    CY = HEIGHT * 2/3
    }),
    --]]
    --[[
    boneOne,
    boneTwo,
    Bone({
    parent = boneTwo,
    pos = vec2(150, 0)
    }),
    Circle{
        parent = boneTwo,
        pos = vec2(0, 80)
    },
]]--
    stickman()
   -- {club()}
    }
    concat(list, {club()})

    
    touches.addHandler(list)
    local colors = {}
    for i, v in ipairs(list) do
        local rnd = list[i].color or color(math.random(50, 255), math.random(50, 255), math.random(60, 255))
        table.insert(colors, rnd)
    end
    function list:draw()
        for i, v in ipairs(self) do
            if i == selected_idx then
                v.color = color(202, 163, 16)
            else
                v.color = colors[i]
            end
            pushMatrix()
            zLevel(i)
            v:draw()
            popMatrix()
        end
    end
    function list:touched(touch)
        if touch.state == BEGAN then
            for i, v in ipairs(self) do
                if v:inBounds(touch) then
                    v:touched(touch)
                end
            end
        end
    end
    
    parameter.integer('selected_idx', 1, #list, function()
        itemRot = list[selected_idx].rot
        itemX, itemY = list[selected_idx].pos:unpack()
        scaleX, scaleY = list[selected_idx].scale:unpack()
    end)
    parameter.integer('itemRot', -360, 360, list[selected_idx].rot, function(val) list[selected_idx].rot = val end)
    
    parameter.number('itemX', -WIDTH, WIDTH, WIDTH / 2, function(val)
        list[selected_idx].pos.x = val
    end)
    parameter.number('itemY', -HEIGHT, HEIGHT, HEIGHT / 2, function(val)
        list[selected_idx].pos.y = val
    end)
    
    parameter.number('scaleX', 0.1, 5, 1, function(val)
        list[selected_idx].scale.x = val
    end)
    parameter.number('scaleY',0.1, 5, 1, function(val)
        list[selected_idx].scale.y = val
    end)
    parameter.action('clear', function()
        output.clear()
    end)
    parameter.action('print rot pos', function()
        print('rot: ', list[selected_idx].rot)
        print('pos: ', list[selected_idx].pos)
    end)
    
    parameter.watch('_editor.sTransform.mtx')
    _editor = T2DEditor()
    print(projectionMatrix())
  --  print(true or false)
end

function draw()
    background(128)
    list:draw()
    _editor:draw()
end

--[[
function touched(touch)
    list:touched(touch)
    _editor:touched(touch)
end
]]--
