-- Example car class
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"

ENT.PrintName = "HL2 GAZ52"

ENT.GlideCategory = "HL2Prewar"
ENT.ChassisModel = "models/blu/gaz52/gaz52_r.mdl"
ENT.MaxChassisHealth = 1500

if CLIENT then
    ENT.CameraCenterOffset = Vector( 0, 0, 96 )
    ENT.CameraOffset = Vector( -350, 0, 36 )

    ENT.EngineSmokeStrips = {
        { offset = Vector( 85, 0, 43 ), angle = Angle(), width = 36 }
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( 61.23, 0, 76.81 ), angle = Angle() }
    }

    ENT.Headlights = {
        {
            offset = Vector( 87.269989, 36.329990, 46.669994 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            offset = Vector( 87.859993, -36.870003, 47.319996 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
    }

    ENT.LightSprites = {
        {
            type = "brake",
            offset = Vector( -193.999985, 43.040012, 21.049997 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "brake",
            offset = Vector( -193.999985, -43.039982, 21.049997 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "headlight",
            offset = Vector( 87.269989, 36.329990, 46.669994 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            type = "headlight",
            offset = Vector( 87.859993, -36.870003, 47.319996 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
    }

    function ENT:OnCreateEngineStream( stream )
        stream:AddLayer( "idle", "vehicles/crane/crane_startengine1.wav", {
            { "throttle", 0.2, 1, "volume", 1, 0 },
            { "rpmFraction", 0, 1, "pitch", 1, 1.2 },
        } )

        stream:AddLayer( "low1", "simulated_vehicles/generic2/generic2_low.wav", {
            { "throttle", 0, 1, "volume", 0, 0.5 },
            { "rpmFraction", 0, 1, "pitch", 0.2, 0.42 },
            { "rpmFraction", 0.4, 0.5, "volume", 1, 0 },
        } )

        stream:AddLayer( "low2", "vehicles/crane/crane_startengine1.wav", {
            { "throttle", 0, 1, "volume", 0, 1 },
            { "rpmFraction", 0, 1, "pitch", 1, 1.2 },
            { "rpmFraction", 0, 1, "volume", 0.7, 1 },
            { "rpmFraction", 0.3, 0.6, "volume", 1, 0 },
        } )

        stream:AddLayer( "mid", "simulated_vehicles/alfaromeo/alfaromeo_mid.wav", {
            { "rpmFraction", 0.4, 0.5, "volume", 0, 1 },
            { "throttle", 0, 1, "volume", 0, 1 },
            { "rpmFraction", 0, 1, "pitch", 0.2, 0.6 },
        } )
    end
end

if SERVER then
    ENT.SpawnPositionOffset = Vector( 0, 0, 40 )
    ENT.ChassisMass = 2250
    ENT.BurnoutForce = 0

    ENT.LightBodygroups = {
        { type = "brake", bodyGroupId = 19, subModelId = 1 },
        { type = "reverse", bodyGroupId = 20, subModelId = 1 },
        { type = "headlight", bodyGroupId = 21, subModelId = 1 }, -- Tail lights
        { type = "headlight", bodyGroupId = 22, subModelId = 1 }  -- Headlights
    }

    function ENT:CreateFeatures()

        self:CreateSeat( Vector( -10, 20, 50 ), Angle( 0, -90, 5 ), Vector( 5, 89, 8 ), true )
        self:CreateSeat( Vector( 0, -22, 50 ), Angle( 0, -90, 5 ), Vector( 5, -89, 8 ), true )

        self:SetMinRPM( 1000 )
        self:SetMaxRPM( 5800 )
        self:SetMinRPMTorque( 1500 )
        self:SetMaxRPMTorque( 1750 )

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

        self:CreateWheel( Vector( 55, -40, 33 ), {
            model = "models/salza/gaz52/gaz52_wheel_r.mdl",
            modelAngle = Angle( 0, 0, 0 ),
            steerMultiplier = 1,
            useModelSize = true
        } )

        self:CreateWheel( Vector( 55.000000, 40, 33 ), {
            model = "models/salza/gaz52/gaz52_wheel_r.mdl",
            modelAngle = Angle( 0, -180, 0 ),
            steerMultiplier = 1,
            useModelSize = true
        } )

        self:CreateWheel( Vector( -120.000000, -45, 33 ), {
            model = "models/salza/gaz52/gaz52_wheel_r.mdl",
            modelAngle = Angle( 0, 0, 0 ),
            useModelSize = true
        } )

        self:CreateWheel( Vector( -120, 45, 33 ), {
            model = "models/salza/gaz52/gaz52_wheel_r.mdl",
            modelAngle = Angle( 0, -180, 0 ),
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