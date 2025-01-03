-- Example car class
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"

ENT.PrintName = "HL2 Moskvich"

ENT.GlideCategory = "HL2Prewar"
ENT.ChassisModel = "models/blu/moskvich/moskvich.mdl"

if CLIENT then
    ENT.CameraCenterOffset = Vector( 0, 0, 64 )
    ENT.CameraOffset = Vector( -270, 0, 6 )

    ENT.HornSound = "simulated_vehicles/horn_5.wav"

    ENT.ExhaustOffsets = {
        {
            pos = Vector( -50.273197174072, -23.148115158081, 12.478518486023 )
        },
    }

    ENT.EngineSmokeStrips = {
        { offset = Vector( 77, 0, 33 ), angle = Angle(), width = 40 }
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( 55.76, 0, 44.4 ), angle = Angle() }
    }

    ENT.Headlights = {
        {
            offset = Vector( 75.699997, -28.090000, 31.280001 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            offset = Vector( 75.699997, 28.090000, 31.280001 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
    }

    ENT.LightSprites = {
        {
            type = "brake",
            offset = Vector( -99.800003, 21.570000, 29.930000 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "brake",
            offset = Vector( -99.800003, -21.570000, 29.930000 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "reverse",
            offset = Vector( -99.980003, 27.410000, 30.760000 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "reverse",
            offset = Vector( -99.980003, -27.410000, 30.760000 ),
            dir = Vector( -1, 0, 0 )
        },
        {
            type = "headlight",
            offset = Vector( 75.699997, -28.090000, 31.280001 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
        {
            type = "headlight",
            offset = Vector( 75.699997, 28.090000, 31.280001 ),
            dir = Vector( 1, 0, 0 ),
            color = Glide.DEFAULT_HEADLIGHT_COLOR
        },
    }

    -- { type = "headlight", offset = Vector( 106, -29, -1 ), dir = Vector( 1, 0, 0 ), color = Glide.DEFAULT_HEADLIGHT_COLOR },
    -- { type = "headlight", offset = Vector( 106, -22, -1 ), dir = Vector( 1, 0, 0 ), color = Glide.DEFAULT_HEADLIGHT_COLOR }

    function ENT:OnCreateEngineStream( stream )
        stream:LoadPreset( "hl2_volga" )
    end

    function ENT:GetGears()
        return {
            [-1] = 10, -- Reverse
            [0] = 0, -- Neutral (this number has no effect)
            [1] = 10,
            [2] = 5.55,
            [3] = 3.84,
            [4] = 2.94,
            [5] = 2.38,
        }
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
        self:CreateSeat( Vector( -20.000000, 16.000000, 17.000000 ), Angle( 0, -90, -5 ), Vector( 40, 80, 0 ), true )
        self:CreateSeat( Vector( -4.000000, -16.000000, 17.500000 ), Angle( 0.000000, -90.000000, 10.000000 ), Vector( 40.000000, -80.000000, 0.000000 ), true )
        self:CreateSeat( Vector( -40.000000, 16.000000, 19.000000 ), Angle( 0.000000, -90.000000, 10.000000 ), Vector( -40.000000, 80.000000, 0.000000 ), true )
        self:CreateSeat( Vector( -40.000000, -16.000000, 19.000000 ), Angle( 0.000000, -90.000000, 10.000000 ), Vector( -40.000000, -80.000000, 0.000000 ), true )

        self:SetMinRPM( 1500 )
        self:SetMaxRPM( 12000 )
        self:SetMinRPMTorque( 1000 )
        -- self:SetSideTractionMultiplier( 15 )

        self:SetMaxRPMTorque( 1200 )
        self:CreateWheel( Vector( 52.000000, 32.000000, 18.500000 ), {
            model = "models/salza/moskvich/moskvich_wheel.mdl",
            modelAngle = Angle( 0.000000, -90.000000, 0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 0.35, 1, 1 )
        } )
        self:CreateWheel( Vector( 52.000000, -32.000000, 18.500000 ), {
            model = "models/salza/moskvich/moskvich_wheel.mdl",
            modelAngle = Angle( -0.000000, 90.000000, -0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 0.35, 1, 1 )
        } )
        self:CreateWheel( Vector( -55.000000, 29.500000, 18.500000 ), {
            model = "models/salza/moskvich/moskvich_wheel.mdl",
            modelAngle = Angle( 0.000000, -90.000000, 0.000000 ),
            modelScale = Vector( 0.35, 1, 1 )
        } )
        self:CreateWheel( Vector( -55.000000, -29.500000, 18.500000 ), {
            model = "models/salza/moskvich/moskvich_wheel.mdl",
            modelAngle = Angle( -0.000000, 90.000000, -0.000000 ),
            modelScale = Vector( 0.35, 1, 1 )
        } )

        self:ChangeWheelRadius( 15 )
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