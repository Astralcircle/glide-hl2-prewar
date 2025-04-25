-- Example car class
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.PrintName = "HL2 Golf"

ENT.GlideCategory = "HL2Prewar"
ENT.ChassisModel = "models/blu/hatchback/pw_hatchback.mdl"

if CLIENT then
    ENT.CameraCenterOffset = Vector( 0, 0, 64 )
    ENT.CameraOffset = Vector( -270, 0, 6 )

    ENT.EngineSmokeStrips = {
        { offset = Vector( 70, 0, 30 ), angle = Angle(), width = 40 }
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( 54.27, 0, 37.26 ), angle = Angle() }
    }

    ENT.Headlights = {
        {
            offset = Vector( 71.070000, -23.150000, 27.950001 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            offset = Vector( 71.150002, 23.260000, 27.920000 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
    }


    ENT.LightSprites = {
        {
            type = "brake",
            offset = Vector( -72.000000, 22.000000, 29.000000 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "brake",
            offset = Vector( -72.000000, -22.000000, 29.000000 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "headlight",
            offset = Vector( 71.070000, -23.150000, 27.950001 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            type = "headlight",
            offset = Vector( 71.150002, 23.260000, 27.920000 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
    }

    function ENT:OnCreateEngineStream( stream )
        stream.volume = 0.7

        stream:AddLayer( "idle", "simulated_vehicles/generic3/generic3_idle.wav", {
            { "throttle", 0.2, 1, "volume", 1, 0 },
            { "rpmFraction", 0, 1, "pitch", 1, 1.44 },
        } )

        stream:AddLayer( "low1", "simulated_vehicles/generic3/generic3_low.wav", {
            { "throttle", 0, 1, "volume", 0, 0.5 },
            { "rpmFraction", 0, 1, "pitch", 0.2, 1.29 },
            { "rpmFraction", 0.4, 0.5, "volume", 1, 0 },
        } )

        stream:AddLayer( "low2", "simulated_vehicles/generic3/generic3_idle.wav", {
            { "throttle", 0, 1, "volume", 0, 1 },
            { "rpmFraction", 0, 1, "pitch", 1, 1.44 },
            { "rpmFraction", 0, 1, "volume", 0.7, 1 },
            { "rpmFraction", 0.3, 0.6, "volume", 1, 0 },
        } )

        stream:AddLayer( "mid", "simulated_vehicles/generic3/generic3_mid.wav", {
            { "rpmFraction", 0.4, 0.5, "volume", 0, 1 },
            { "throttle", 0, 1, "volume", 0, 1 },
            { "rpmFraction", 0, 1, "pitch", 0.2, 1.15 },
        } )
    end
end

if SERVER then

    ENT.SpawnPositionOffset = Vector( 0, 0, 40 )
    ENT.ChassisMass = 600
    ENT.BurnoutForce = 35

    ENT.LightBodygroups = {
        { type = "brake", bodyGroupId = 19, subModelId = 1 },
        { type = "reverse", bodyGroupId = 20, subModelId = 1 },
        { type = "headlight", bodyGroupId = 21, subModelId = 1 }, -- Tail lights
        { type = "headlight", bodyGroupId = 22, subModelId = 1 }  -- Headlights
    }

    function ENT:CreateFeatures()
        self:CreateSeat( Vector( -16.500000, 16.000000, 12.000000 ), Angle( 0, -90, -5 ), Vector( 40, 80, 0 ), true )
        self:CreateSeat( Vector( 5.000000, -16.000000, 14.000000 ), Angle( 0.000000, -90.000000, 20.000000 ), Vector( 40.000000, -80.000000, 0.000000 ), true )
        self:CreateSeat( Vector( -24.000000, -16.000000, 14.000000 ), Angle( 0.000000, -90.000000, 20.000000 ), Vector( -40.000000, 80.000000, 0.000000 ), true )
        self:CreateSeat( Vector( -24.000000, 16.000000, 14.000000 ), Angle( 0.000000, -90.000000, 20.000000 ), Vector( -40.000000, -80.000000, 0.000000 ), true )

        self:SetMinRPM( 2000 )
        self:SetMaxRPM( 9500 )
        self:SetMinRPMTorque( 750 )
        self:SetMaxRPMTorque( 950 )
        self:SetSteerConeMaxSpeed( 900 )
        self:SetForwardTractionMax( 2600 )
        self:SetDifferentialRatio( 1.9 )

        self:CreateWheel( Vector( 44.500000, 28.000000, 18.500000 ), {
            model = "models/salza/hatchback/hatchback_wheel.mdl",
            modelAngle = Angle( 0.000000, 0.000000, 0.000000 ),
            steerMultiplier = 1,
            useModelSize = true
        } )
        self:CreateWheel( Vector( 44.500000, -28.000000, 18.500000 ), {
            model = "models/salza/hatchback/hatchback_wheel.mdl",
            modelAngle = Angle( -0.000000, -0.000000, -0.000000 ),
            steerMultiplier = 1,
            useModelSize = true
        } )
        self:CreateWheel( Vector( -46.000000, 29.500000, 18.500000 ), {
            model = "models/salza/hatchback/hatchback_wheel.mdl",
            modelAngle = Angle( 0.000000, 0.000000, 0.000000 ),
            useModelSize = true
        } )
        self:CreateWheel( Vector( -46.000000, -29.500000, 18.500000 ), {
            model = "models/salza/hatchback/hatchback_wheel.mdl",
            modelAngle = Angle( -0.000000, -0.000000, -0.000000 ),
            useModelSize = true
        } )
    end

    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( 0, 0, 8 ) )
    end
end

function ENT:GetSpawnColor()
    return Color( 255, 255, 255 )
end