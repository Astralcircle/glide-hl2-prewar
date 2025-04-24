-- Example car class
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"

ENT.PrintName = "HL2 ZAZ"

ENT.GlideCategory = "HL2Prewar"
ENT.ChassisModel = "models/blu/zaz/zaz.mdl"

if CLIENT then
    ENT.CameraCenterOffset = Vector( 0, 0, 64 )
    ENT.CameraOffset = Vector( -270, 0, 6 )

    ENT.EngineSmokeStrips = {
        { offset = Vector( 85, 0, 40 ), angle = Angle(), width = 40 }
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( 63.64, 0, 47.96 ), angle = Angle() }
    }

    ENT.Headlights = {
        {
            offset = Vector( 87.339996, -31.760000, 35.520000 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            offset = Vector( 87.300003, 29.590000, 35.419998 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
    }


    ENT.LightSprites = {
        {
            type = "brake",
            offset = Vector( -95.500000, 15.500000, 34.799999 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "brake",
            offset = Vector( -95.500000, -18.000000, 34.799999 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "reverse",
            offset = Vector( -95.500000, 18.250000, 34.799999 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "reverse",
            offset = Vector( -95.500000, -20.750000, 34.799999 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "headlight",
            offset = Vector( 87.339996, -31.760000, 35.520000 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            type = "headlight",
            offset = Vector( 87.300003, 29.590000, 35.419998 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
    }

    function ENT:OnCreateEngineStream( stream )
        stream:AddLayer( "idle", "simulated_vehicles/generic3/generic3_idle.wav", {
            { "throttle", 0.2, 1, "volume", 1, 0 },
            { "rpmFraction", 0, 1, "pitch", 1, 1.65 },
        } )

        stream:AddLayer( "low1", "simulated_vehicles/generic3/generic3_low.wav", {
            { "throttle", 0, 1, "volume", 0, 0.5 },
            { "rpmFraction", 0, 1, "pitch", 0.2, 1.48 },
            { "rpmFraction", 0.4, 0.5, "volume", 1, 0 },
        } )

        stream:AddLayer( "low2", "simulated_vehicles/generic3/generic3_idle.wav", {
            { "throttle", 0, 1, "volume", 0, 1 },
            { "rpmFraction", 0, 1, "pitch", 1, 1.65 },
            { "rpmFraction", 0, 1, "volume", 0.7, 1 },
            { "rpmFraction", 0.3, 0.6, "volume", 1, 0 },
        } )

        stream:AddLayer( "mid", "simulated_vehicles/generic3/generic3_mid.wav", {
            { "rpmFraction", 0.4, 0.5, "volume", 0, 1 },
            { "throttle", 0, 1, "volume", 0, 1 },
            { "rpmFraction", 0, 1, "pitch", 0.2, 1.48 },
        } )
    end
end

if SERVER then
    ENT.SpawnPositionOffset = Vector( 0, 0, 40 )
    ENT.ChassisMass = 800
    ENT.BurnoutForce = 35

    ENT.LightBodygroups = {
        { type = "brake", bodyGroupId = 19, subModelId = 1 },
        { type = "reverse", bodyGroupId = 20, subModelId = 1 },
        { type = "headlight", bodyGroupId = 21, subModelId = 1 }, -- Tail lights
        { type = "headlight", bodyGroupId = 22, subModelId = 1 }  -- Headlights
    }

    function ENT:CreateFeatures()
        self:CreateSeat( Vector( -11.000000, 17.500000, 22.000000 ), Angle( 0, -90, -5 ), Vector( 12, 76, 12 ), true )
        self:CreateSeat( Vector( 6.000000, -17.500000, 20.000000 ), Angle( 0.000000, -90, 12 ), Vector( 12, -76, 12 ), true )
        self:CreateSeat( Vector( -30.000000, -17.500000, 24.000000 ), Angle( 0.000000, -90, 12 ), Vector( -20, 76, 12 ), true )
        self:CreateSeat( Vector( -30.000000, 17.500000, 24.000000 ), Angle( 0.000000, -90, 12 ),Vector( -20, -76, 12 ), true )
        self:CreateSeat( Vector( -30.000000, 0.000000, 24.000000 ), Angle( 0.000000, -90, 12 ), Vector( -20, -76, 12 ), true )

        self:SetMinRPM( 2000 )
        self:SetMaxRPM( 9000 )
        self:SetMinRPMTorque( 600 )
        self:SetMaxRPMTorque( 800 )
        self:SetSideTractionMultiplier( 15 )

        self:CreateWheel( Vector( 61.000000, 32.000000, 23.500000 ), {
            model = "models/salza/zaz/zaz_wheel.mdl",
            modelAngle = Angle( 0.000000, 180.000000, 0.000000 ),
            steerMultiplier = 1,
            useModelSize = true
        } )
        self:CreateWheel( Vector( 61.000000, -34.000000, 23.500000 ), {
            model = "models/salza/zaz/zaz_wheel.mdl",
            modelAngle = Angle( -0.000000, 0.000000, -0.000000 ),
            steerMultiplier = 1,
            useModelSize = true
        } )
        self:CreateWheel( Vector( -53.000000, 32.000000, 23.500000 ), {
            model = "models/salza/zaz/zaz_wheel.mdl",
            modelAngle = Angle( 0.000000, 180.000000, 0.000000 ),
            useModelSize = true
        } )
        self:CreateWheel( Vector( -53.000000, -34.000000, 23.500000 ), {
            model = "models/salza/zaz/zaz_wheel.mdl",
            modelAngle = Angle( -0.000000, 0.000000, -0.000000 ),
            useModelSize = true
        } )
    end

    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( 0, 0, 12 ) )
    end
end

function ENT:GetSpawnColor()
    return Color( 255, 255, 255 )
end