-- Example car class
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"

ENT.PrintName = "Liaz"

ENT.GlideCategory = "HL2Prewar"
ENT.ChassisModel = "models/blu/skoda_liaz/skoda_liaz_r.mdl"
ENT.MaxChassisHealth = 2000

if CLIENT then
    ENT.CameraCenterOffset = Vector( 0, 0, 64 )
    ENT.CameraOffset = Vector( -400, 0, 72 )

    ENT.ExhaustOffsets = {}

    ENT.EngineSmokeStrips = {
        { offset = Vector( -1.75, -0.56,51.17 ), angle = Angle(), width = 40 }
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( -1.75, -0.56,51.17 ), angle = Angle() }
    }

    ENT.Headlights = {
        {
            offset = Vector( 118.879997, -32.150002, 45.130001 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            offset = Vector( 121.349998, 36.740002, 45.430000 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
    }

    ENT.LightSprites = {
        {
            type = "brake",
            offset = Vector( -133.970001, 47.000000, 28.139999 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "brake",
            offset = Vector( -134.419998, -44.130001, 27.340000 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "reverse",
            offset = Vector( -134.110001, -32.330002, 27.340000 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "reverse",
            offset = Vector( -134.110001, -32.330002, 27.340000 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "headlight",
            offset = Vector( 118.879997, -32.150002, 45.130001 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            type = "headlight",
            offset = Vector( 121.349998, 36.740002, 45.430000 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
    }


    function ENT:OnCreateEngineStream( stream )

        stream.volume = 0.75

        stream:AddLayer( "low", "vehicles/crane/crane_startengine1.wav", {
            { "rpmFraction", 0.2, 1, "volume", 0.8, 0 },
            -- { "rpmFraction", 0, 1, "pitch", 1, 1.5 },
        } )

        stream:AddLayer( "mid", "simulated_vehicles/alfaromeo/alfaromeo_low.wav", {
            { "rpmFraction", 0.2, 1, "volume", 0, 0.8 },
            { "rpmFraction", 0, 1, "pitch", 0.2, 0.65 },
            { "throttle", 0, 0.8, "volume", 0.7, 1 },
        } )

    end
end

if SERVER then
    ENT.SpawnPositionOffset = Vector( 0, 0, 40 )
    ENT.ChassisMass = 3000
    ENT.IsHeavyVehicle = true

    ENT.Sockets = {
        { offset = Vector(-43, -2.5, 45 ), id = "TruckSocket", isReceptacle = true }
    }

    function ENT:CreateFeatures()
        self:CreateSeat( Vector( 48, 28, 55 ), Angle( 0, -90, -5 ), Vector( 53, 110, 5 ), true )
        self:CreateSeat( Vector( 58, -27, 55 ), Angle( 0, -90, -5 ), Vector( 53, -110, 5 ), true )

        self:SetSuspensionLength( 14 )
        self:SetSpringStrength( 1500 )
        self:SetSpringDamper( 8000 )

        self:SetSideTractionMultiplier( 90 )
        self:SetForwardTractionMax( 6000 )
        self:SetSideTractionMax( 4000 )
        self:SetSideTractionMin( 5500 )

        self:SetDifferentialRatio( 2.7 )
        self:SetPowerDistribution( -0.7 )

        self:SetMinRPM( 1000 )
        self:SetMaxRPM( 6000 )
        self:SetMinRPMTorque( 2400 )
        self:SetMaxRPMTorque( 3000 )

        self:SetBrakePower( 4800 )

        self:CreateWheel( Vector( 57, 44, 35 ), {
            model = "models/salza/skoda_liaz/skoda_liaz_fwheel_r.mdl",
            modelAngle = Angle( -0.000000, 180, 0.000000 ),
            steerMultiplier = 1,
            useModelSize = true
        } )

        self:CreateWheel( Vector( 57, -40, 35 ), {
            model = "models/salza/skoda_liaz/skoda_liaz_fwheel_r.mdl",
            modelAngle = Angle( -0.000000, 0, 0.000000 ),
            steerMultiplier = 1,
            useModelSize = true
        } )

        self:CreateWheel( Vector( -98, 50, 35 ), {
            model = "models/salza/skoda_liaz/skoda_liaz_rwheel_r.mdl",
            modelAngle = Angle( -0.000000, 180, 0.000000 ),
            useModelSize = true
        } )

        self:CreateWheel( Vector( -98, -47, 35 ), {
            model = "models/salza/skoda_liaz/skoda_liaz_rwheel_r.mdl",
            modelAngle = Angle( -0.000000, 0, 0.000000 ),
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