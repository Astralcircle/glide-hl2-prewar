-- Example car class
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"

ENT.PrintName = "HL2 Volga"

ENT.GlideCategory = "HL2Prewar"
ENT.ChassisModel = "models/blu/volga/volga.mdl"

if CLIENT then
    ENT.CameraCenterOffset = Vector( 0, 0, 64 )
    ENT.CameraOffset = Vector( -270, 0, 6 )

    ENT.HornSound = "simulated_vehicles/horn_5.wav"

    ENT.EngineSmokeStrips = {
        { offset = Vector( 90, 0, 33 ), angle = Angle(), width = 40 }
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( 65.39, 0, 44.84 ), angle = Angle() }
    }

    ENT.Headlights = {
        {
            offset = Vector( 91.330002, -30.440001, 30.629999 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            offset = Vector( 91.330002, 30.440001, 30.629999 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
    }

    ENT.LightSprites = {
        {
            type = "brake",
            offset = Vector( -102.230003, -30.000000, 35.849998 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "brake",
            offset = Vector( -102.230003, 30.000000, 35.849998 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "reverse",
            offset = Vector( -101.800003, -29.400000, 30.700001 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "reverse",
            offset = Vector( -101.800003, 29.400000, 30.700001 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "headlight",
            offset = Vector( 91.330002, -30.440001, 30.629999 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            type = "headlight",
            offset = Vector( 91.330002, 30.440001, 30.629999 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
    }

    function ENT:OnCreateEngineStream( stream )
        stream:AddLayer( "idle", "simulated_vehicles/generic2/generic2_idle.wav", {
            { "throttle", 0.2, 1, "volume", 1, 0 },
            { "rpmFraction", 0, 1, "pitch", 1, 1.4 },
        } )

        stream:AddLayer( "low1", "simulated_vehicles/generic2/generic2_low.wav", {
            { "throttle", 0, 1, "volume", 0, 0.5 },
            { "rpmFraction", 0, 1, "pitch", 0.2, 1.4 },
            { "rpmFraction", 0.4, 0.5, "volume", 1, 0 },
        } )

        stream:AddLayer( "low2", "simulated_vehicles/generic2/generic2_idle.wav", {
            { "throttle", 0, 1, "volume", 0, 1 },
            { "rpmFraction", 0, 1, "pitch", 1, 1.4 },
            { "rpmFraction", 0, 1, "volume", 0.7, 1 },
            { "rpmFraction", 0.3, 0.6, "volume", 1, 0 },
        } )

        stream:AddLayer( "mid", "simulated_vehicles/generic2/generic2_mid.wav", {
            { "rpmFraction", 0.4, 0.5, "volume", 0, 1 },
            { "throttle", 0, 1, "volume", 0, 1 },
            { "rpmFraction", 0, 1, "pitch", 0.2, 1.54 },
        } )
    end
end

if SERVER then

    ENT.SpawnPositionOffset = Vector( 0, 0, 40 )
    ENT.ChassisMass = 900
    ENT.BurnoutForce = 35

    ENT.LightBodygroups = {
        { type = "brake", bodyGroupId = 19, subModelId = 1 },
        { type = "reverse", bodyGroupId = 20, subModelId = 1 },
        { type = "headlight", bodyGroupId = 21, subModelId = 1 }, -- Tail lights
        { type = "headlight", bodyGroupId = 22, subModelId = 1 }  -- Headlights
    }

    function ENT:CreateFeatures()
        self:CreateSeat( Vector( -12.000000, 17.500000, 20.000000 ), Angle( 0, -90, -5 ), Vector( 40, 80, 0 ), true )
        self:CreateSeat( Vector( 6.000000, -17.500000, 18.500000 ), Angle( 0.000000, -90.000000, 12.000000 ), Vector( 40.000000, -80.000000, 0.000000 ), true )
        self:CreateSeat( Vector( 6.000000, 0.000000, 18.500000 ), Angle( 0.000000, -90.000000, 12.000000 ), Vector( -40.000000, 80.000000, 0.000000 ), true )
        self:CreateSeat( Vector( -30.000000, -17.500000, 18.500000 ), Angle( 0.000000, -90.000000, 12.000000 ), Vector( -40.000000, -80.000000, 0.000000 ), true )
        self:CreateSeat( Vector( -30.000000, 17.500000, 18.500000 ), Angle( 0.000000, -90.000000, 12.000000 ), Vector( -80.000000, 80.000000, 0.000000 ), true )
        self:CreateSeat( Vector( -30.000000, -0.000000, 18.500000 ), Angle( 0.000000, -90.000000, 12.000000 ), Vector( -80.000000, -80.000000, 0.000000 ), true )

        self:SetMinRPM( 2000 )
        self:SetMaxRPM( 10500 )
        self:SetMinRPMTorque( 1000 )
        self:SetMaxRPMTorque( 1200 )

        self:CreateWheel( Vector( 64.000000, 34.000000, 13.000000 ) + vector_up * 6.5, {
            model = "models/salza/volga/volga_wheel.mdl",
            modelAngle = Angle( 0.000000, 0.000000, 0.000000 ),
            steerMultiplier = 1,
            useModelSize = true
        } )
        self:CreateWheel( Vector( 64.000000, -34.000000, 13.000000 ) + vector_up * 6.5, {
            model = "models/salza/volga/volga_wheel.mdl",
            modelAngle = Angle( -0.000000, 180.000000, -0.000000 ),
            steerMultiplier = 1,
            useModelSize = true
        } )
        self:CreateWheel( Vector( -55.000000, 34.000000, 13.000000 ) + vector_up * 6.5, {
            model = "models/salza/volga/volga_wheel.mdl",
            modelAngle = Angle( 0.000000, 0.000000, 0.000000 ),
            useModelSize = true
        } )
        self:CreateWheel( Vector( -55.000000, -34.000000, 13.000000 ) + vector_up * 6.5, {
            model = "models/salza/volga/volga_wheel.mdl",
            modelAngle = Angle( -0.000000, 180.000000, -0.000000 ),
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