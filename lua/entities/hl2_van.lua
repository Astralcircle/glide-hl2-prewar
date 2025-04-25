-- Example car class
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.PrintName = "HL2 Van"

ENT.GlideCategory = "HL2Prewar"
ENT.ChassisModel = "models/blu/van/pw_van.mdl"

if CLIENT then
    ENT.CameraCenterOffset = Vector( 0, 0, 80 )
    ENT.CameraOffset = Vector( -330, 0, 6 )

    ENT.EngineSmokeStrips = {
        { offset = Vector( 95, 0, 40 ), angle = Angle(), width = 40 }
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( 89.98, 0, 51.3 ), angle = Angle() }
    }

    ENT.Headlights = {
        {
            offset = Vector( 97.230003, -36.189999, 37.029999 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            offset = Vector( 97.449997, 36.169998, 37.080002 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
    }


    ENT.LightSprites = {
        {
            type = "brake",
            offset = Vector( -117.000000, -32.500000, 41.000000 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "brake",
            offset = Vector( -117.000000, 32.500000, 41.000000 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "reverse",
            offset = Vector( -117.000000, -32.500000, 45.000000 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "reverse",
            offset = Vector( -117.000000, 32.500000, 45.000000 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "headlight",
            offset = Vector( 97.230003, -36.189999, 37.029999 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            type = "headlight",
            offset = Vector( 97.449997, 36.169998, 37.080002 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
    }

    -- { type = "headlight", offset = Vector( 106, -29, -1 ), dir = Vector( 1, 0, 0 ), color = Glide.DEFAULT_HEADLIGHT_COLOR },
    -- { type = "headlight", offset = Vector( 106, -22, -1 ), dir = Vector( 1, 0, 0 ), color = Glide.DEFAULT_HEADLIGHT_COLOR }

    function ENT:OnCreateEngineStream( stream )
        stream:AddLayer( "idle", "simulated_vehicles/generic3/generic3_idle.wav", {
            { "throttle", 0.2, 1, "volume", 1, 0 },
            { "rpmFraction", 0, 1, "pitch", 1, 1.2 },
        } )

        stream:AddLayer( "low1", "simulated_vehicles/generic3/generic3_low.wav", {
            { "throttle", 0, 1, "volume", 0, 0.5 },
            { "rpmFraction", 0, 1, "pitch", 0.2, 0.9 },
            { "rpmFraction", 0.4, 0.5, "volume", 1, 0 },
        } )

        stream:AddLayer( "low2", "simulated_vehicles/generic3/generic3_idle.wav", {
            { "throttle", 0, 1, "volume", 0, 1 },
            { "rpmFraction", 0, 1, "pitch", 1, 1.08 },
            { "rpmFraction", 0, 1, "volume", 0.7, 1 },
            { "rpmFraction", 0.3, 0.6, "volume", 1, 0 },
        } )

        stream:AddLayer( "mid", "simulated_vehicles/generic3/generic3_mid.wav", {
            { "rpmFraction", 0.4, 0.5, "volume", 0, 1 },
            { "throttle", 0, 1, "volume", 0, 1 },
            { "rpmFraction", 0, 1, "pitch", 0.2, 1.2 },
        } )
    end
end

if SERVER then
    ENT.SpawnPositionOffset = Vector( 0, 0, 40 )
    ENT.ChassisMass = 1300
    ENT.BurnoutForce = 35

    ENT.LightBodygroups = {
        { type = "brake", bodyGroupId = 19, subModelId = 1 },
        { type = "reverse", bodyGroupId = 20, subModelId = 1 },
        { type = "headlight", bodyGroupId = 21, subModelId = 1 }, -- Tail lights
        { type = "headlight", bodyGroupId = 22, subModelId = 1 }  -- Headlights
    }

    function ENT:CreateFeatures()
        self:CreateSeat( Vector( 28.000000, 23.000000, 40.000000 ), Angle( 0, -90, -5 ), Vector( 40, 80, 10 ), true )
        self:CreateSeat( Vector( 45.000000, -27.000000, 33.000000 ), Angle( 0.000000, -90.000000, 9.000000 ), Vector( 40.000000, -80.000000, 10.000000 ), true )
        self:CreateSeat( Vector( 45.000000, 0.000000, 33.000000 ), Angle( 0.000000, -90.000000, 9.000000 ), Vector( -40.000000, 80.000000, 10.000000 ), true )
        self:CreateSeat( Vector( -38.000000, -29.000000, 28.000000 ), Angle( 0.000000, 0.000000, 0.000000 ), Vector( -40.000000, -80.000000, 10.000000 ), true )

        self:SetSuspensionLength( 6 )

        self:SetSpringStrength( 1300 )
        self:SetSpringDamper( 5000 )

        self:SetMinRPM( 2000 )
        self:SetMaxRPM( 9000 )
        self:SetMinRPMTorque( 950 )
        self:SetMaxRPMTorque( 1150 )

        self:SetSideTractionMultiplier( 30 )
        self:SetForwardTractionMax( 3500 )
        self:SetSideTractionMax( 3400 )
        self:SetSideTractionMin( 1000 )
        self:SetForwardTractionMax( 2600 )
        self:SetDifferentialRatio( 1.9 )

        self:CreateWheel( Vector( 45.000000, 44.000000, 20.000000 ), {
            model = "models/salza/van/van_wheel.mdl",
            modelAngle = Angle( 0.000000, 0.000000, 0.000000 ),
            steerMultiplier = 1,
            useModelSize = true
        } )
        self:CreateWheel( Vector( 45.000000, -44.000000, 20.000000 ), {
            model = "models/salza/van/van_wheel.mdl",
            modelAngle = Angle( -0.000000, 180.000000, -0.000000 ),
            steerMultiplier = 1,
            useModelSize = true
        } )
        self:CreateWheel( Vector( -72.000000, 44.000000, 20.000000 ), {
            model = "models/salza/van/van_wheel.mdl",
            modelAngle = Angle( 0.000000, 0.000000, 0.000000 ),
            useModelSize = true
        } )
        self:CreateWheel( Vector( -72.000000, -44.000000, 20.000000 ), {
            model = "models/salza/van/van_wheel.mdl",
            modelAngle = Angle( -0.000000, 180.000000, -0.000000 ),
            useModelSize = true
        } )
    end

    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( 0, 0, 14 ) )
    end
end

function ENT:GetSpawnColor()
    return Color( 255, 255, 255 )
end