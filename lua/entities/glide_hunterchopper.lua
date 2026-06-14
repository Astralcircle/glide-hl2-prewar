AddCSLuaFile()

ENT.GlideCategory = "HL2"

ENT.Type = "anim"
ENT.Base = "base_glide_heli"
ENT.Author = ".kkrill"
ENT.PrintName = "Hunter-Chopper"

DEFINE_BASECLASS( "base_glide_heli" )

ENT.MainRotorOffset = Vector( 20, 0, 65 )
ENT.MainRotorAngle = Angle( 15, 0, 0 )
ENT.TailRotorOffset = Vector( -218, 4, -1.8 )
ENT.TailRotorAngle = Angle( 90, 0, 0 )

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()
    BaseClass.SetupDataTables( self )

    self:NetworkVar( "Bool", "FiringGun" )
end

if CLIENT then

    ENT.CameraOffset = Vector( -700, 0, 150 )

    ENT.DistantSoundPath = "NPC_AttackHelicopter.Rotors"
    ENT.TailSoundPath = "NPC_AttackHelicopter.Rotors"

    -- ENT.JetSoundPath = "glide/helicopters/jet_1.wav"
    -- ENT.JetSoundLevel = 65
    -- ENT.JetSoundVolume = 0.15

    ENT.BassSoundSet = "Glide.MilitaryRotor.Bass"
    ENT.MidSoundSet = "Glide.MilitaryRotor.Mid"
    ENT.HighSoundSet = "Glide.MilitaryRotor.High"

    ENT.ExhaustPositions = {
        Vector( 20, 0, 45 ),
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( 0, 0, 80 ), angle = Angle( 300, 0, 0 ) }
    }

    ENT.StrobeLights = {
        { offset = Vector( -12, 93, -55 ), blinkTime = 0 },
        { offset = Vector( -12, -93, -55 ), blinkTime = 0.1 },
        { offset = Vector( -246, 3, 20.5 ), blinkTime = 0.6 }
    }

    ENT.StrobeLightColors = { -- FUCKING BASECLASSES
        Color( 255, 0, 0 ),
        Color( 255, 0, 0 ),
        Color( 255, 0, 0 ),
    }

    ENT.RotorBeatInterval = 0.09

    local ang = Angle( 0, 0, 0 )

    function ENT:OnActivateMisc()
        BaseClass.OnActivateMisc( self )

        self.rotorHull = self:LookupBone( "Chopper.Blade_Hull" )
        self.rotorTail = self:LookupBone( "Chopper.Blade_Tail" )
        self.rotorMain = self:LookupBone( "Chopper.Rotor_Blur" )
    end

    ENT.SpinAngleMain = Angle()
    ENT.SpinAngleTail = Angle()

    -- Do it in Think() instead of UpdateMisc() so it runs regardless of distance
    function ENT:Think()
        if self.rotorMain then
            local dt = FrameTime()

            self.SpinAngleMain.p = ( self.SpinAngleMain.p + 2000 * self:GetPower() * dt ) % 360

            self:ManipulateBoneAngles( self.rotorMain, self.SpinAngleMain )
            self:ManipulateBoneAngles( self.rotorHull, self.SpinAngleMain )

            self.SpinAngleTail.r = ( self.SpinAngleTail.r + 2000 * self:GetPower() * dt ) % 360

            self:ManipulateBoneAngles( self.rotorTail, self.SpinAngleTail )
        end

        return BaseClass.Think( self )
    end

    function ENT:OnUpdateSounds()
        BaseClass.OnUpdateSounds( self )

        local sounds = self.sounds

        if self:GetFiringGun() then
            if not sounds.gunFire then
                local gunFire = self:CreateLoopingSound( "gunFire", "NPC_AttackHelicopter.FireGun", 95, self )
                gunFire:PlayEx( 1.0, 100 )
            end

        elseif sounds.gunFire then
            sounds.gunFire:Stop()
            sounds.gunFire = nil

            -- self:EmitSound( ")glide/weapons/b11_turret_loop_end.wav", 95, 100, 1.0 )
        end
    end

end

if SERVER then
    ENT.ChassisMass = 500
    ENT.ChassisModel = "models/Combine_Helicopter.mdl"

    ENT.MainRotorRadius = 310
    ENT.TailRotorRadius = 25

    ENT.MainRotorModel = "models/hunter/blocks/cube025x025x025.mdl" -- leaving it as "" causes rotor entities to not spawn, so we use a dummy model and hide them later
    ENT.MainRotorFastModel = ""

    ENT.TailRotorModel = "models/hunter/blocks/cube025x025x025.mdl"
    ENT.TailRotorFastModel = ""

    ENT.ExplosionGibs = {
        "models/gibs/helicopter_brokenpiece_01.mdl",
        "models/gibs/helicopter_brokenpiece_02.mdl",
        "models/gibs/helicopter_brokenpiece_03.mdl",
        "models/gibs/helicopter_brokenpiece_06_body.mdl",
        "models/gibs/helicopter_brokenpiece_04_cockpit.mdl",
        "models/gibs/helicopter_brokenpiece_05_tailfan.mdl",
    }

    function ENT:CreateFeatures()
        self:CreateSeat( Vector( 135, 0, -48 ), nil, Vector( 112, 76, -90 ), true )
        -- self:CreateSeat( Vector( 70, -18, -8 ), nil, Vector( 76, -80, 0 ), true )
        -- self:CreateSeat( Vector( -35, 21, -8 ), nil, Vector( 20, 90, 0 ), true )
        -- self:CreateSeat( Vector( -35, -21, -8 ), nil, Vector( -20, -90, 0 ), true )
        -- self:CreateSeat( Vector( -35, 0, -8 ), nil, Vector( -20, -110, 0 ), true )

        self:CreateWeapon( "hc_mg", {
            FireDelay = 0.02,
        } )

        self:CreateWeapon( "hc_bombs", {
            FireDelay = 0.6,
            MaxAmmo = 10,
            ReloadDelay = 15
        } )

        self:CreateWeapon( "hc_missile", {
            FireDelay = 1,
            MaxAmmo = 2,
            ReloadDelay = 4,
            ProjectileOffsets = {
                Vector( 0, 80, -80 ),
                Vector( 0, -80, -80 )
            }
        } )

        for k, v in pairs( self.rotors ) do
            v:SetNoDraw( true )
        end

        self:SetSubMaterial( 1, "phoenix_storms/glass" )

        self.muzzle = self:LookupAttachment( "muzzle" )
    end

    function ENT:OnPostThink( dt, selfTbl )
        BaseClass.OnPostThink( self, dt, selfTbl )

        local ply = self:GetSeatDriver( 1 )

        local pitch = 0
        local yaw = 0

        if IsValid( ply ) then
            local dir = ply:GlideGetAimPos() - self:GetAttachment( 1 ).Pos
            dir:Normalize()

            local _, ang = WorldToLocal( ply:GlideGetAimPos(), dir:Angle(), self:GetAttachment( 1 ).Pos, self:GetAngles() )
            pitch = -ang.p
            yaw = ang.y
        end

        local pitchMin, pitchMax = self:GetPoseParameterRange( 0 )
        local yawMin, yawMax = self:GetPoseParameterRange( 2 )

        pitch = math.Clamp( pitch, pitchMin, pitchMax )
        yaw = math.Clamp( yaw, yawMin, yawMax )

        self:SetPoseParameter( "weapon_pitch", pitch )
        self:SetPoseParameter( "weapon_yaw", yaw )
    end

    function ENT:OnWeaponFire( weapon, weaponIndex )
        if weaponIndex == 1 then
            if CurTime() < self.NextWeaponFire then return false end

            if self.NextWeaponFire == 0 then
                self.NextWeaponFire = CurTime() + 1.6
                self:EmitSound("NPC_AttackHelicopter.ChargeGun")
                return false
            end
        end

        return true
    end

    function ENT:OnWeaponStop( weapon, weaponIndex )
        if weaponIndex == 1 then
            self.NextWeaponFire = 0
            self:SetFiringGun( false )
        end
    end

    function ENT:GetSpawnColor()
        return Color( 255, 255, 255 )
    end
end
