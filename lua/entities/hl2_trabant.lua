-- Example car class
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"

ENT.PrintName = "HL2 Trabant"

ENT.GlideCategory = "HL2Prewar"
ENT.ChassisModel = "models/blu/trabant/trabant_r.mdl"

if CLIENT then
    ENT.CameraCenterOffset = Vector( 0, 0, 64 )
    ENT.CameraOffset = Vector( -270, 0, 6 )

    ENT.HornSound = "simulated_vehicles/horn_5.wav"

    ENT.EngineSmokeStrips = {
        { offset = Vector( 69, 0, 22 ), angle = Angle(), width = 40 }
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( 56.38, 0, 38.7 ), angle = Angle() }
    }

    ENT.Headlights = {
        {
            offset = Vector( 70.769989, -29.129995, 30.579998 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            offset = Vector( 70.689995, 28.769997, 30.729998 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
    }

    ENT.LightSprites = {
        {
            type = "brake",
            offset = Vector( -78.439995, -30.829996, 23.999998 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "brake",
            offset = Vector( -78.499992, 30.829996, 23.999998 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "reverse",
            offset = Vector( -76.389992, -30.769997, 20.089998 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "reverse",
            offset = Vector( -76.139992, 31.009996, 20.289999 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "headlight",
            offset = Vector( 70.769989, -29.129995, 30.579998 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            type = "headlight",
            offset = Vector( 70.689995, 28.769997, 30.729998 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
    }

    function ENT:OnCreateEngineStream( stream )
        stream:AddLayer( "idle", "simulated_vehicles/generic5/generic5_idle.wav", {
            { "throttle", 0.2, 1, "volume", 1, 0 },
            { "rpmFraction", 0, 1, "pitch", 1, 1.53 },
        } )

        stream:AddLayer( "low1", "simulated_vehicles/generic5/generic5_low.wav", {
            { "throttle", 0, 1, "volume", 0, 0.5 },
            { "rpmFraction", 0, 1, "pitch", 0.2, 0.7 },
            { "rpmFraction", 0.4, 0.5, "volume", 1, 0 },
        } )

        stream:AddLayer( "low2", "simulated_vehicles/generic5/generic5_idle.wav", {
            { "throttle", 0, 1, "volume", 0, 1 },
            { "rpmFraction", 0, 1, "pitch", 1, 1.07 },
            { "rpmFraction", 0, 1, "volume", 0.7, 1 },
            { "rpmFraction", 0.3, 0.6, "volume", 1, 0 },
        } )

        stream:AddLayer( "mid", "simulated_vehicles/generic5/generic5_mid.wav", {
            { "rpmFraction", 0.4, 0.5, "volume", 0, 1 },
            { "throttle", 0, 1, "volume", 0, 1 },
            { "rpmFraction", 0, 1, "pitch", 0.2, 1.07 },
        } )
    end
end

if SERVER then

    ENT.SpawnPositionOffset = Vector( 0, 0, 40 )
    ENT.ChassisMass = 637
    ENT.BurnoutForce = 35

    ENT.LightBodygroups = {
        { type = "brake", bodyGroupId = 19, subModelId = 1 },
        { type = "reverse", bodyGroupId = 20, subModelId = 1 },
        { type = "headlight", bodyGroupId = 21, subModelId = 1 }, -- Tail lights
        { type = "headlight", bodyGroupId = 22, subModelId = 1 }  -- Headlights
    }

    function ENT:CreateFeatures()
        self:CreateSeat( Vector( -2, 15, 12 ), Angle( 0, -90, 5 ), Vector( 6, 76, 4 ), true )
        self:CreateSeat( Vector( -2, -15, 12.5 ), Angle( -0.000000, -90, 8 ), Vector( 6, -76, 4 ), true )
        self:CreateSeat( Vector( -2, -0.000000, 12.5 ), Angle( -0.000000, -90, 8 ), Vector( 6, -76, 4 ), true )

        self:SetMinRPM( 1500 )
        self:SetMaxRPM( 8000 )
        self:SetMinRPMTorque( 800 )
        self:SetMaxRPMTorque( 1000 )
        self:SetForwardTractionMax( 2600 )
        self:SetDifferentialRatio( 1.9 )

        self:CreateWheel( Vector( 50, 32, 19 ), {
            model = "models/salza/trabant/trabant_wheel_r.mdl",
            modelAngle = Angle( -0.000000, 0, 0.000000 ),
            steerMultiplier = 1,
            useModelSize = true
        } )
        self:CreateWheel( Vector( 50, -32, 19 ), {
            model = "models/salza/trabant/trabant_wheel_r.mdl",
            modelAngle = Angle( -0.000000, 180, 0.000000 ),
            steerMultiplier = 1,
            useModelSize = true
        } )
        self:CreateWheel( Vector( -41.5, 32, 19 ), {
            model = "models/salza/trabant/trabant_wheel_r.mdl",
            modelAngle = Angle( -0.000000, 0, 0.000000 ),
            useModelSize = true
        } )
        self:CreateWheel( Vector( -41.5, -32, 19 ), {
            model = "models/salza/trabant/trabant_wheel_r.mdl",
            modelAngle = Angle( -0.000000, 180, 0.000000 ),
            useModelSize = true
        } )
    end

    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( 0, 0, 10 ) )
    end
end

function ENT:GetSpawnColor()
    return Color( 255, 255, 255 )
end