function stickman(col)
    col = col or color(255)
    local pelvis = Circle{
    r = 17,
    rot = 90,
    color = col
    }
    local waist = Stick{
    parent = pelvis,
    pos = vec2(0, 0),
    length = 50,
    color = col
    }
    local torso = Stick{
    parent = waist,
    pos = vec2(50, 0),
    length = 50,
    color = col
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
    rot = -90,
    color = col
    }
    
    local leftArm = Stick{
    parent = torso,
    pos = vec2(50,0),
    rot = 135,
    length = 50,
    color = col
    }
    
    local leftLowerArm = Stick{
    parent = leftArm,
    pos = vec2(50,0),
    rot = 75,
    length = 50,
    color = col
    }
    
    local rightArm = Stick{
    parent = torso,
    pos = vec2(50,0),
    rot = -135,
    length = 50,
    color = col
    }
    local rightLowerArm = Stick{
    parent = rightArm,
    pos = vec2(50,0),
    rot = 75,
    length = 50,
    color = col
    }
    
    
    local leftThigh = Stick{
    parent = pelvis,
    pos = vec2(0,0),
    rot = -180,
    length = 70,
    color = col
    }
    
    local lefLeg = Stick{
    parent = leftThigh,
    pos = vec2(70,0),
    rot = -75,
    length = 70,
    color = col
    }
    
    
    local rightThigh = Stick{
    parent = pelvis,
    pos = vec2(0,0),
    rot = -135,
    length = 70,
    color = col
    }
    
    local rightLeg = Stick{
    parent = rightThigh,
    pos = vec2(70,0),
    rot = -75,
    length = 70,
    color = col
    }
    
    return pelvis, waist, torso, neck, head, leftArm, leftLowerArm, rightArm, rightLowerArm, leftThigh, lefLeg, rightThigh, rightLeg
end

function sword(col)
    local bCol = col or color(50)
    local mCol = col or color(161, 193, 199)
    local base = Stick{
    pos = vec2(WIDTH / 2 + 150, HEIGHT / 2),
    color = bCol,
    width = 7
    }
    local head = Circle{
    r = 10,
    color = bCol,
    pos = vec2(0.2, 0),
    parent = base,
    }
    local mace1 = Circle{
    r = 75,
    scale = vec2(0.2, 0.15),
    parent = head,
    color = mCol,
    
    }
    local mace2 = Circle{
    r = 45,
    scale = vec2(0.2, 1),
    color = mCol,
    pos = vec2(mace1.r * mace1.scale.x, 0),
    parent = head
    }
    return base, head, mace1, mace2
end