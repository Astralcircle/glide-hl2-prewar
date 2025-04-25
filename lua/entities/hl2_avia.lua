-- Example car class
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"

ENT.PrintName = "Avia"

ENT.GlideCategory = "HL2Prewar"
ENT.ChassisModel = "models/blu/avia/avia.mdl"
ENT.MaxChassisHealth = 1200

if CLIENT then
    ENT.CameraCenterOffset = Vector( 0, 0, 64 )
    ENT.CameraOffset = Vector( -270, 0, 36 )

    ENT.EngineSmokeStrips = {
        { offset = Vector( 110, -2.41, 40.13 ), angle = Angle(), width = 40 }
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( 120, -2.41, 40.13 ), angle = Angle() }
    }

    ENT.Headlights = {
        {
            offset = Vector( 118.800003, -35.000000, 41.799999 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            offset = Vector( 118.800003, 30.500000, 41.799999 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
    }

    ENT.LightSprites = {
        {
            type = "headlight",
            offset = Vector( 118.800003, -35.000000, 41.799999 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            type = "headlight",
            offset = Vector( 118.800003, 30.500000, 41.799999 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
    }

    function ENT:OnCreateEngineStream( stream )
        stream:AddLayer( "idle", "simulated_vehicles/jeep/jeep_idle.wav", {
            { "throttle", 0.2, 1, "volume", 1, 0 },
            { "rpmFraction", 0, 1, "pitch", 1, 1.04 },
        } )

        stream:AddLayer( "low1", "simulated_vehicles/jeep/jeep_low.wav", {
            { "throttle", 0, 1, "volume", 0, 0.5 },
            { "rpmFraction", 0, 1, "pitch", 0.2, 0.94 },
            { "rpmFraction", 0.4, 0.5, "volume", 1, 0 },
        } )

        stream:AddLayer( "low2", "simulated_vehicles/jeep/jeep_idle.wav", {
            { "throttle", 0, 1, "volume", 0, 1 },
            { "rpmFraction", 0, 1, "pitch", 1, 1.04 },
            { "rpmFraction", 0, 1, "volume", 0.7, 1 },
            { "rpmFraction", 0.3, 0.6, "volume", 1, 0 },
        } )

        stream:AddLayer( "mid", "simulated_vehicles/jeep/jeep_mid.wav", {
            { "rpmFraction", 0.4, 0.5, "volume", 0, 1 },
            { "throttle", 0, 1, "volume", 0, 1 },
            { "rpmFraction", 0, 1, "pitch", 0.2, 1 },
        } )
    end
end

if SERVER then
    ENT.SpawnPositionOffset = Vector( 0, 0, 40 )
    ENT.ChassisMass = 1800
    ENT.BurnoutForce = 0

    ENT.LightBodygroups = {
        { type = "brake", bodyGroupId = 19, subModelId = 1 },
        { type = "reverse", bodyGroupId = 20, subModelId = 1 },
        { type = "headlight", bodyGroupId = 21, subModelId = 1 }, -- Tail lights
        { type = "headlight", bodyGroupId = 22, subModelId = 1 }  -- Headlights
    }

    function ENT:CreateFeatures()
        self:CreateSeat( Vector( 69.000000, 21.000000, 43.000000 ), Angle( 0, -90, -5 ), Vector( 60, 80, 10 ), true )
        self:CreateSeat( Vector( 79.000000, -21.000000, 45.000000 ), Angle( 0.000000, -90.000000, 0.000000 ), Vector( 60.000000, -80.000000, 10.000000 ), true )

        self:SetMinRPM( 1000 )
        self:SetMaxRPM( 6000 )
        self:SetMinRPMTorque( 1600 )
        self:SetMaxRPMTorque( 1900 )

        self:SetSpringStrength( 1500 )
        self:SetSpringDamper( 5000 )

        self:SetBrakePower( 4000 )
        self:SetMaxSteerAngle( 40 )
        self:SetSteerConeChangeRate( 8 )
        self:SetSteerConeMaxSpeed( 800 )
        self:SetSteerConeMaxAngle( 0.4 )
        self:SetCounterSteer( 0.2 )

        self:SetDifferentialRatio( 2.7 )
        self:SetPowerDistribution( -0.7 )

        self:SetSideTractionMultiplier( 90 )
        self:SetForwardTractionMax( 4000 )
        self:SetSideTractionMax( 3800 )
        self:SetSideTractionMin( 1200 )

        self:CreateWheel( Vector( 78.000000, 37.000000, 25.000000 ), {
            model = "models/salza/avia/avia_wheel_r.mdl",
            modelAngle = Angle( 0.000000, 0, 0.000000 ),
            steerMultiplier = 1,
            useModelSize = true
        } )
        self:CreateWheel( Vector( 78.000000, -40.000000, 25.000000 ), {
            model = "models/salza/avia/avia_wheel_r.mdl",
            modelAngle = Angle( -0.000000, -180.000000, -0.000000 ),
            steerMultiplier = 1,
            useModelSize = true
        } )
        self:CreateWheel( Vector( -55.000000, 38.500000, 25.000000 ), {
            model = "models/salza/avia/avia_wheel_r.mdl",
            modelAngle = Angle( 0.000000, 0, 0.000000 ),
            useModelSize = true
        } )
        self:CreateWheel( Vector( -55.000000, -37.000000, 25.000000 ), {
            model = "models/salza/avia/avia_wheel_r.mdl",
            modelAngle = Angle( -0.000000, -180.000000, -0.000000 ),
            useModelSize = true
        } )
    end

    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( 0, 0, 32 ) )
    end
end

function ENT:GetSpawnColor()
    return Color( 255, 255, 255 )
end