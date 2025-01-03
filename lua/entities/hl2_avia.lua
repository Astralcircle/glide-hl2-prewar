-- Example car class
AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"

ENT.PrintName = "HL2 Avia"

ENT.GlideCategory = "HL2Prewar"
ENT.ChassisModel = "models/blu/avia/avia.mdl"

if CLIENT then
    ENT.CameraCenterOffset = Vector( 0, 0, 64 )
    ENT.CameraOffset = Vector( -270, 0, 36 )

    ENT.ExhaustOffsets = {
        {
            pos = Vector( -50.273197174072, -23.148115158081, 12.478518486023 )
        },
    }

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
        stream:LoadPreset( "hl2_avia" )
    end

    function ENT:GetGears()
        return {
            [-1] = 6.66, -- Reverse
            [0] = 0, -- Neutral (this number has no effect)
            [1] = 6.66,
            [2] = 4,
            [3] = 2.85,
            [4] = 2.22,
            [5] = 1.92
        }
    end
end

if SERVER then
    ENT.SpawnPositionOffset = Vector( 0, 0, 40 )
    ENT.ChassisMass = 1400
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

        self:SetMinRPM( 1500 )
        self:SetMaxRPM( 8400 )
        self:SetMinRPMTorque( 1100 )
        self:SetMaxRPMTorque( 1200 )
        -- self:SetSideTractionMultiplier( 15 )

        self:SetSpringStrength( 1500 )

        self:CreateWheel( Vector( 78.000000, 37.000000, 25.000000 ), {
            model = "models/salza/avia/avia_wheel.mdl",
            modelAngle = Angle( 0.000000, 90.000000, 0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 0.35, 1, 1 )
        } )
        self:CreateWheel( Vector( 78.000000, -40.000000, 25.000000 ), {
            model = "models/salza/avia/avia_wheel.mdl",
            modelAngle = Angle( -0.000000, -90.000000, -0.000000 ),
            steerMultiplier = 1,
            modelScale = Vector( 0.35, 1, 1 )
        } )
        self:CreateWheel( Vector( -55.000000, 38.500000, 25.000000 ), {
            model = "models/salza/avia/avia_wheel.mdl",
            modelAngle = Angle( 0.000000, 90.000000, 0.000000 ),
            modelScale = Vector( 0.35, 1, 1 )
        } )
        self:CreateWheel( Vector( -55.000000, -37.000000, 25.000000 ), {
            model = "models/salza/avia/avia_wheel.mdl",
            modelAngle = Angle( -0.000000, -90.000000, -0.000000 ),
            modelScale = Vector( 0.35, 1, 1 )
        } )

        self:ChangeWheelRadius( 15 )
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