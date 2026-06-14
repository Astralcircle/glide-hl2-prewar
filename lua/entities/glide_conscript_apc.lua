AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_apc"
ENT.Author = ".kkrill"
ENT.PrintName = "Conscript APC"

ENT.GlideCategory = "HL2"
ENT.ChassisModel = "models/kkrill/apc001.mdl"

ENT.MaxChassisHealth = 4500

DEFINE_BASECLASS( "base_glide_apc" )

sound.Add( {
    name = "Glide.ConscriptAPC.Reload",
    sound = "kkrill/apc/apc_reload.wav"
} )

sound.Add( {
    name = "Glide.ConscriptAPC.Fire",
    channel = CHAN_WEAPON,
    volume = 1.0,
    level = 110,
    pitch = { 90, 110 },
    sound = "^kkrill/apc/apc_fire.wav"
} )

if CLIENT then
    ENT.CameraOffset = Vector( -380, 0, 150 )

    ENT.EngineFireOffsets = {
        { offset = Vector( -38, -27, 47 ), angle = Angle( 0, 90, 0 ), scale = 1.5 }
    }

    ENT.EngineSmokeStrips = {
        { offset = Vector( -80, 17, 44 ), angle = Angle( -10, 180, 0 ), width = 40 },
        { offset = Vector( -70, 17, 47 ), angle = Angle( -10, 180, 0 ), width = 40 },
    }

    function ENT:OnActivateMisc()
        BaseClass.OnActivateMisc( self )
        -- Turret
        self.turretBase = self:LookupBone( "turret_yaw" )
        self.cannonBase = self:LookupBone( "turret_pitch" )
    end

    function ENT:OnCreateEngineStream( stream )
        stream.volume = 0.6

        stream:AddLayer( "apc_mid", "kkrill/apc/apc_mid.wav", {
            { "rpmFraction", 0, 0.8, "volume", 0, 1 },
            { "throttle", 0, 1, "volume", 0.7, 1 },
            { "rpmFraction", 0, 1, "pitch", 1, 1.2 },
            { "rpmFraction", 0.8, 1, "volume", 1, 0.4 },
        } )

        stream:AddLayer( "apc_low", "kkrill/apc/apc_low.wav", {
            { "rpmFraction", 0.2, 0.5, "volume", 0.8, 0 },
            { "rpmFraction", 0, 1, "pitch", 1, 1.2 },
        } )

        stream:AddLayer( "apc_high", "kkrill/apc/apc_high.wav", {
            { "throttle", 0, 1, "volume", 0.4, 1 },
            { "rpmFraction", 0.8, 1, "volume", 0, 0.6 },
            { "rpmFraction", 0, 1, "pitch", 0.65, 0.75 },
        } )

    end

    ENT.Headlights = {
        {
            offset =  Vector( 146, -42, 21 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            offset = Vector( 146, 42, 21 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
    }

    ENT.LightSprites = {
        {
            type = "headlight",
            offset = Vector( 146, -38, 21 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            type = "headlight",
            offset = Vector( 146, 38, 21 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            type = "headlight",
            offset = Vector( 146, -46, 21 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            type = "headlight",
            offset = Vector( 146, 46, 21 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            type = "brake",
            offset = Vector( -145, 45.503452301025, 27.027805328369 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "brake",
            offset = Vector( -145, -45.503452301025, 27.027805328369 ),
            dir = Vector( -1, 0, 0 )
        },
    }
end

if SERVER then
    ENT.SpawnPositionOffset = Vector( 0, 0, 50 )

    ENT.ExplosionGibs = {
        "models/props_vehicles/apc001_base.mdl",
        "models/props_vehicles/apc001_turret.mdl",
    }

    function ENT:CreateFeatures()
        self:CreateSeat( Vector( 90, 0, -10 ), Angle( 0, 270, 30 ), Vector( 60, 100, -40 ), true )
        self:CreateSeat( Vector( 90, 0, -10 ), Angle( 0, 270, 30 ), Vector( 60, 100, -40 ), true )
        self:CreateSeat( Vector( 90, 0, -10 ), Angle( 0, 270, 30 ), Vector( 60, 100, -40 ), true )
        self:CreateSeat( Vector( 90, 0, -10 ), Angle( 0, 270, 30 ), Vector( 60, 100, -40 ), true )
        self:CreateSeat( Vector( 90, 0, -10 ), Angle( 0, 270, 30 ), Vector( 60, 100, -40 ), true )
        self:CreateSeat( Vector( 90, 0, -10 ), Angle( 0, 270, 30 ), Vector( 60, 100, -40 ), true )
        self:CreateSeat( Vector( 90, 0, -10 ), Angle( 0, 270, 30 ), Vector( 60, 100, -40 ), true )
        self:CreateSeat( Vector( 90, 0, -10 ), Angle( 0, 270, 30 ), Vector( 60, 100, -40 ), true )
        self:CreateSeat( Vector( 90, 0, -10 ), Angle( 0, 270, 30 ), Vector( 60, 100, -40 ), true )
        self:CreateSeat( Vector( 90, 0, -10 ), Angle( 0, 270, 30 ), Vector( 60, 100, -40 ), true )

        self:SetSpringStrength( 1900 )
        self:SetSpringDamper( 8000 )

        self:SetSideTractionMultiplier( 90 )
        self:SetForwardTractionMax( 9000 )
        self:SetSideTractionMax( 6000 )
        self:SetSideTractionMin( 7500 )

        self:SetMinRPM( 1000 )
        self:SetMaxRPM( 4000 )
        self:SetMinRPMTorque( 4500 )
        self:SetMaxRPMTorque( 5000 )
        self:SetDifferentialRatio( 1.9 )

        self:SetBrakePower( 8000 )

        -- Front left
        self:CreateWheel( Vector( 77, 45, -22 ), {
            model = "models/kkrill/apc_tire001.mdl",
            useModelSize = true,
            -- modelAngle = Angle( 0, 90, 0 ),
            steerMultiplier = 1
        } )

        -- Rear left
        self:CreateWheel( Vector( -74, 45, -22 ), {
            model = "models/kkrill/apc_tire001.mdl",
            useModelSize = true,
            -- modelAngle = Angle( 0, 90, 0 ),
        } )

        -- Front right
        self:CreateWheel( Vector( 77, -45, -22 ), {
            model = "models/kkrill/apc_tire001.mdl",
            useModelSize = true,
            modelAngle = Angle( 0, 180, 0 ),
            steerMultiplier = 1
        } )


        -- Rear right
        self:CreateWheel( Vector( -74, -45, -22 ), {
            model = "models/kkrill/apc_tire001.mdl",
            useModelSize = true,
            modelAngle = Angle( 0, 180, 0 ),
        } )

        self:CreateWeapon( "apc_cannon", {
            MaxAmmo = 30,
            FireDelay = 0.2
        } )

        -- Manipulate these on the server side only, to allow
        -- spawning projectiles on the correct position.
        self.turretBase = self:LookupBone( "turret_yaw" )
        self.cannonBase = self:LookupBone( "turret_pitch" )
        self.cannonMuzzle = self:LookupBone( "muzzle_l" )
    end

    function ENT:GetProjectileStartPos()
        if self.cannonMuzzle then
            return self:GetBoneMatrix( self.cannonMuzzle ):GetTranslation()
        end

        return BaseClass.GetProjectileStartPos( self )
    end

    function ENT:GetSpawnColor()
        return Color( 255, 255, 255 )
    end

    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( -1.0243746042252, 0, -28 ) )
    end

    function ENT:OnSeatInput( seatIndex, action, pressed )
        if seatIndex == 1 and action == "horn" and pressed then
            self.weapons[ 1 ]:CustomReload()
            return
        end
        BaseClass.OnSeatInput( self, seatIndex, action, pressed )
    end
end

local ang = Angle()

function ENT:ManipulateTurretBones( turretAng )
    if not self.turretBase then return end

    ang[1] = turretAng[2]
    ang[2] = 0
    ang[3] = 0

    self:ManipulateBoneAngles( self.turretBase, ang, false )

    ang[1] = 0
    ang[2] = -turretAng[1]
    ang[3] = 0

    self:ManipulateBoneAngles( self.cannonBase, ang, false )
end

function ENT:GetFirstPersonOffset()
    return Vector( 22, 0, 90 )
end