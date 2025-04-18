-- Example car class
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"

ENT.PrintName = "ZAZ"

ENT.GlideCategory = "HL2Prewar"
ENT.ChassisModel = "models/blu/zaz/zaz.mdl"

if CLIENT then
    ENT.CameraCenterOffset = Vector( 0, 0, 64 )
    ENT.CameraOffset = Vector( -270, 0, 6 )

    ENT.ExhaustOffsets = {
        {
            pos = Vector( -50.273197174072, -23.148115158081, 12.478518486023 )
        },
    }

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
        stream:LoadPreset( "hl2_golf" )
    end

    function ENT:GetGears()
        return {
            [-1] = 10, -- Reverse
            [0] = 0, -- Neutral (this number has no effect)
            [1] = 10,
            [2] = 5.88,
            [3] = 4.16,
            [4] = 2.7,
            [5] = 2.43
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
        self:CreateSeat( Vector( -11.000000, 17.500000, 22.000000 ), Angle( 0, -90, -5 ), Vector( 40, 80, 0 ), true )
        self:CreateSeat( Vector( 6.000000, -17.500000, 20.000000 ), Angle( 0.000000, -90.000000, 12.000000 ), Vector( 40.000000, -80.000000, 0.000000 ), true )
        self:CreateSeat( Vector( -30.000000, -17.500000, 24.000000 ), Angle( 0.000000, -90.000000, 12.000000 ), Vector( -40.000000, 80.000000, 0.000000 ), true )
        self:CreateSeat( Vector( -30.000000, 17.500000, 24.000000 ), Angle( 0.000000, -90.000000, 12.000000 ), Vector( -40.000000, -80.000000, 0.000000 ), true )
        self:CreateSeat( Vector( -30.000000, 0.000000, 24.000000 ), Angle( 0.000000, -90.000000, 12.000000 ), Vector( -80.000000, 80.000000, 0.000000 ), true )

        self:SetMinRPM( 1500 )
        self:SetMaxRPM( 14500 )
        self:SetMinRPMTorque( 1000 )
        self:SetMaxRPMTorque( 1200 )
        -- self:SetSideTractionMultiplier( 15 )

        self:CreateWheel( Vector( 61.000000, 32.000000, 23.500000 ), {
            model = "models/salza/zaz/zaz_wheel.mdl",
            modelAngle = Angle( 0.000000, 180.000000, 0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 1, 0.35, 1 )
        } )
        self:CreateWheel( Vector( 61.000000, -34.000000, 23.500000 ), {
            model = "models/salza/zaz/zaz_wheel.mdl",
            modelAngle = Angle( -0.000000, 0.000000, -0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 1, 0.35, 1 )
        } )
        self:CreateWheel( Vector( -53.000000, 32.000000, 23.500000 ), {
            model = "models/salza/zaz/zaz_wheel.mdl",
            modelAngle = Angle( 0.000000, 180.000000, 0.000000 ),
            modelScale = Vector( 1, 0.35, 1 )
        } )
        self:CreateWheel( Vector( -53.000000, -34.000000, 23.500000 ), {
            model = "models/salza/zaz/zaz_wheel.mdl",
            modelAngle = Angle( -0.000000, 0.000000, -0.000000 ),
            modelScale = Vector( 1, 0.35, 1 )
        } )

        self:ChangeWheelRadius( 15 )
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