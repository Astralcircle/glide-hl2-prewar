include( "shared.lua" )

DEFINE_BASECLASS( "base_glide_car" )

--- Implement this base class function.
function ENT:AllowFirstPersonMuffledSound()
    return false
end

--- Implement this base class function.
function ENT:OnPostInitialize()
    BaseClass.OnPostInitialize( self )

    self.currentTurretAng = Angle()
    self.targetTurretAng = Angle()
end

--- Override this base class function.
function ENT:OnLocalPlayerEnter( seatIndex )
    BaseClass.OnLocalPlayerEnter( self, seatIndex )
    self.isPredicted = seatIndex == 1
end

--- Override this base class function.
function ENT:OnLocalPlayerExit()
    BaseClass.OnLocalPlayerExit( self )
    self.isPredicted = false
end

--- Override this base class function.
function ENT:DeactivateMisc()
    BaseClass.DeactivateMisc( self )

    if self.turretSound then
        self.turretSound:Stop()
        self.turretSound = nil
    end
end

local Abs = math.abs
local Clamp = math.Clamp
local FrameTime = FrameTime
local ExpDecayAngle = Glide.ExpDecayAngle

--- Implement this base class function.
function ENT:OnUpdateMisc()
    BaseClass.OnUpdateMisc( self )

    local dt = FrameTime()
    local driver = self:GetDriver()
    local lastYaw = self.currentTurretAng[2]

    if self.isPredicted and IsValid( driver ) then
        self.currentTurretAng = self:UpdateTurret( driver, dt, self.currentTurretAng )
    else
        local curAng = self.currentTurretAng
        local targetAng = self:GetTurretAngle()

        curAng[1] = ExpDecayAngle( curAng[1], targetAng[1], 30, dt )
        curAng[2] = ExpDecayAngle( curAng[2], targetAng[2], 30, dt )
    end

    self:ManipulateTurretBones( self.currentTurretAng )

    local yawSpeed = Abs( lastYaw - self.currentTurretAng[2] ) / dt
    local turretVolume = Clamp( yawSpeed * 0.05, 0, 1 )

    if turretVolume > 0 then
        turretVolume = turretVolume - dt

        if self.turretSound then
            self.turretSound:ChangeVolume( turretVolume * self.TurrentMoveVolume )
        else
            self.turretSound = CreateSound( self, self.TurrentMoveSound )
            self.turretSound:SetSoundLevel( 80 )
            self.turretSound:PlayEx( turretVolume * self.TurrentMoveVolume, 100 )
        end

    elseif self.turretSound then
        self.turretSound:Stop()
        self.turretSound = nil
    end

    self:OnUpdateAnimations()
end

do
    local Camera = Glide.Camera
    local DrawWeaponCrosshair = Glide.DrawWeaponCrosshair

    local SetColor = surface.SetDrawColor
    local SetMaterial = surface.SetMaterial
    local DrawTexturedRectRotated = surface.DrawTexturedRectRotated

    local crosshairColor = {
        [true] = Color( 255, 255, 255, 255 ),
        [false] = Color( 150, 150, 150, 100 )
    }

    local matBody = Material( "materials/glide/tank_body.png", "smooth" )
    local matTurret = Material( "materials/glide/tank_turret.png", "smooth" )

    --- Override this base class function.
    function ENT:DrawVehicleHUD( screenW, screenH )
        BaseClass.DrawVehicleHUD( self, screenW, screenH )

        if not Camera.isInFirstPerson then return end

        local ang = 0

        if Camera:IsFixed() then
            ang = -Camera.angles[2]
        else
            ang = -self:WorldToLocalAngles( Camera.angles )[2]
        end

        local x, y = screenW * 0.5, screenH * 0.92
        local size = screenH * 0.15

        SetColor( 255, 255, 255, 255 )

        SetMaterial( matBody )
        DrawTexturedRectRotated( x, y, size, size, ang )

        ang = ang + self.currentTurretAng[2]

        SetMaterial( matTurret )
        DrawTexturedRectRotated( x, y, size, size, ang )
    end
end