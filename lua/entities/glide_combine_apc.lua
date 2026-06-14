AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_glide_car"
ENT.PrintName = "Combine APC"
ENT.Author = ".kkrill"

ENT.GlideCategory = "HL2"
ENT.ChassisModel = "models/kkrill/combine_apc.mdl"
ENT.CanSwitchSiren = true

ENT.MaxChassisHealth = 3000

ENT.CanSwitchHeadlights = true

ENT.VehicleType = Glide.VEHICLE_TYPE.TANK

DEFINE_BASECLASS( "base_glide_car" )

function ENT:SetupDataTables()
    BaseClass.SetupDataTables( self )

    self:NetworkVar( "Angle", "AimAng" )
end

if CLIENT then
    ENT.CameraOffset = Vector( -380, 0, 90 )
    ENT.CameraCenterOffset = Vector( 0, 0, 60 )

    ENT.HornSound = ""

    ENT.SirenLoopSound = ")ambient/alarms/apc_alarm_loop1.wav"
    ENT.SirenLoopAltSound = ")glide/horns/police_horn_2.wav"
    ENT.SirenInterruptSound = ""
    ENT.SirenVolume = 1.25

    ENT.StartSound = "apc_engine_start"

    ENT.EngineFireOffsets = {
        { offset = Vector( -70, 0, 103 ), angle = Angle( 0, 0, 0 ), scale = 1.5 }
    }
    ENT.EngineSmokeStrips = {
        { offset = Vector( -51.35, -22, 101.63 ), angle = Angle( 0, -90, 0 ), width = 5 },
        { offset = Vector( -51.35, 22, 101.63 ), angle = Angle( 0, 90, 0 ), width = 5 },
        { offset = Vector( -75.33, -22, 101.63 ), angle = Angle( 0, -90, 0 ), width = 5 },
        { offset = Vector( -75.35, 22, 101.63 ), angle = Angle( 0, 90, 0 ), width = 5 },
    }

    function ENT:OnActivateMisc()
        BaseClass.OnActivateMisc( self )

        -- self.frontLeftBoneId = self:LookupBone( "APC.Wheel_FL_Rotate" )
        -- self.frontRightBoneId = self:LookupBone( "APC.Wheel_FR_Rotate" )
        -- self.rearLeftBoneId = self:LookupBone( "APC.Wheel_RL_Rotate" )
        -- self.rearRightBoneId = self:LookupBone( "APC.Wheel_RR_Rotate" )

        -- Turret
        self.piston = self:LookupBone( "APC.piston" )
        self.turret = self:LookupBone( "APC.Gun_Base" )
        self.muzzle = self:LookupAttachment( "muzzle" )
    end

    -- local spinAng = Angle()
    -- local susVec = Vector()

    function ENT:OnUpdateAnimations()
        -- Call the base class' `OnUpdateAnimations`
        -- to automatically update the steering pose parameter.
        BaseClass.OnUpdateAnimations( self )

        if not self.muzzle then return end

        local driver = self:GetDriver()

        if driver == LocalPlayer() then
            local att = self:GetAttachment( self.muzzle )
            local pos = att.Pos
            local aimPos = Glide.GetCameraAimPos()

            local dir = aimPos - pos
            local ang = dir:Angle()
            ang = self:WorldToLocalAngles( ang )

            self:ManipulateTurretBones( ang )
        else
            self:ManipulateTurretBones( self:GetAimAng() )
        end

        -- local steer = self:GetSteering()

        -- -- The wheels are part of the model, so we have to
        -- -- rotate their bones to match the actual wheels.
        -- spinAng[1] = -steer * 30
        -- spinAng[3] = -self:GetWheelSpin( 1 )
        -- susVec[2] = self:GetWheelOffset( 1 )
        -- self:ManipulateBoneAngles( self.frontLeftBoneId, spinAng, false )
        -- self:ManipulateBonePosition( self.frontLeftBoneId, susVec )

        -- spinAng[1] = -steer * 30
        -- spinAng[3] = self:GetWheelSpin( 2 )
        -- susVec[2] = self:GetWheelOffset( 2 )
        -- self:ManipulateBoneAngles( self.frontRightBoneId, spinAng, false )
        -- self:ManipulateBonePosition( self.frontRightBoneId, susVec )
    end

    function ENT:OnCreateEngineStream( stream )

        stream:AddLayer( "apc_firstgear_loop1", "vehicles/apc/apc_drive_loop.wav", {
            { "rpmFraction", 0, 0.5, "volume", 0, 1.3 },
            { "throttle", 0, 1, "pitch", 0.9, 1.1 },
            { "rpmFraction", 0.5, 1, "pitch", 1, 1.3 },
        } )

        stream:AddLayer( "apc_idle1", "vehicles/apc/apc_idle1.wav", {
            { "rpmFraction", 0, 0.5, "volume", 1, 0 },
            { "throttle", 0, 1, "pitch", 1, 2.5 },
        } )

    end

    ENT.Headlights = {}

    ENT.LightSprites = {}

    function ENT:AllowFirstPersonMuffledSound( seat )
        return seat != 1
    end

    local headlightColor = Glide.DEFAULT_HEADLIGHT_COLOR

    local IsValid = IsValid
    local DrawLightSprite = Glide.DrawLightSprite
    local LocalToWorld = LocalToWorld

    local offset = Vector( -20, 0, -2.5 )

    function ENT:UpdateLights( selfTbl )
        local headlightState = self:GetHeadlightState()

        if not selfTbl.muzzle then return end

        local att = self:GetAttachment( selfTbl.muzzle )

        if selfTbl.headlightState ~= headlightState then
            selfTbl.headlightState = headlightState
            self:RemoveHeadlights()

            if headlightState == 0 then return end

            self:CreateHeadlight( 1, vector_origin, angle_zero, headlightColor )
        end

        local pos = att.Pos
        local ang = att.Ang
        local dir = ang:Forward()

        if headlightState > 0 and selfTbl.shouldThinkNow then
            local l, hasLight

            l = selfTbl.activeHeadlights[1]
            hasLight = IsValid( l )

            if hasLight then
                l:SetPos( pos )
                l:SetAngles( ang )
                l:Update()
            end
        end

        local offsetPos = LocalToWorld( offset, angle_zero, pos, ang )

        -- Handle sprites
        if headlightState > 0 then
            DrawLightSprite( offsetPos, dir, headlightState == 1 and 30 or 40, headlightColor )
        end
    end
end

if SERVER then
    ENT.IsHeavyVehicle = true
    ENT.ChassisMass = 2500

    ENT.SpawnPositionOffset = Vector( 0, 0, 50 )

    ENT.BlastDamageMultiplier = 3
    ENT.BlastForceMultiplier = 0.005
    ENT.CollisionDamageMultiplier = 3
    ENT.BulletDamageMultiplier = 0.25

    ENT.ExplosionGibs = {
        "models/kkrill/combine_apc_destroyed_giblet.mdl",
        "models/combine_apc_destroyed_gib02.mdl",
        "models/combine_apc_destroyed_gib03.mdl",
        "models/combine_apc_destroyed_gib04.mdl",
        "models/combine_apc_destroyed_gib05.mdl",
    }

    function ENT:CreateFeatures()
        self:CreateSeat( Vector( -30, 0, 70 ), Angle( 0, 270, 0 ), Vector( 2, 100, 8 ), true )
        self:CreateSeat( Vector( -30, 0, 50 ), Angle( 0, 0, 0 ), Vector( -157, 38, 8 ), true )
        self:CreateSeat( Vector( -30, 0, 50 ), Angle( 0, 0, 0 ), Vector( -157, -38, 8 ), true )
        self:CreateSeat( Vector( -30, 0, 50 ), Angle( 0, 0, 0 ), Vector( -180, 38, 8 ), true )
        self:CreateSeat( Vector( -30, 0, 50 ), Angle( 0, 0, 0 ), Vector( -180, -38, 8 ), true )

        self:SetBrakePower( 4600 )
        self:SetDifferentialRatio( 0.9 )
        self:SetPowerDistribution( -0.4 )

        self:SetMaxRPM( 5500 )
        self:SetMinRPMTorque( 7000 )
        self:SetMaxRPMTorque( 8500 )

        self:SetMaxSteerAngle( 30 )
        self:SetSteerConeMaxSpeed( 1100 )

        self:SetSuspensionLength( 7 )
        self:SetSpringStrength( 900 )
        self:SetSpringDamper( 3500 )

        self:SetSideTractionMultiplier( 38 )
        self:SetForwardTractionMax( 4700 )
        self:SetSideTractionMax( 4500 )
        self:SetSideTractionMin( 2000 )

        -- Front left
        self:CreateWheel( Vector( 66, -55, 29 ), {
            model = "models/kkrill/combine_apc_wheel.mdl",
            useModelSize = true,
            modelAngle = Angle( 0, 0, 0 ),
            steerMultiplier = 1,
            isBulletProof = true
        } )

        -- Front right
        self:CreateWheel( Vector( 66, 55, 29 ), {
            model = "models/kkrill/combine_apc_wheel.mdl",
            useModelSize = true,
            modelAngle = Angle( 0, 180, 0 ),
            steerMultiplier = 1,
            isBulletProof = true
        } )

        -- Rear left
        self:CreateWheel(Vector( -77, -55, 29 ), {
            model = "models/kkrill/combine_apc_wheel.mdl",
            useModelSize = true,
            modelAngle = Angle( 0, 0, 0 ),
            isBulletProof = true
        } )

        -- Rear right
        self:CreateWheel( Vector( -77, 55, 29 ), {
            model = "models/kkrill/combine_apc_wheel.mdl",
            useModelSize = true,
            modelAngle = Angle( 0, 180, 0 ),
            isBulletProof = true
        } )

        -- Since the model already has a visual representation
        -- for the wheels, hide the actual wheels.
        -- for _, w in ipairs( self.wheels ) do
        --     Glide.HideEntity( w, true )
        -- end

        -- self:ChangeWheelRadius( 28 )

        self.piston = self:LookupBone( "APC.piston" )
        self.turret = self:LookupBone( "APC.Gun_Base" )
        self.muzzle = self:LookupAttachment( "muzzle" )
        self.cannonMuzzle = self:LookupAttachment( "cannon_muzzle" )

        self:CreateWeapon( "combine_apc_turret", {
            MuzzleAtt = self.muzzle,
            Damage = 25,
        } )

        self:CreateWeapon( "combine_apc_missile", {
            MuzzleAtt = self.cannonMuzzle,
        } )

        -- Laser dot for the homing rpg weapon

        local laser = ents.Create( "env_laserdot" )
        laser:SetOwner( self )
        laser:SetPos( self:GetPos() )
        laser:Spawn()

        self.LaserDot = laser

        self:DeleteOnRemove( laser )
    end

    function ENT:ChangeSirenState( state )

        if state == 1 then
            state = 2
        end

        return BaseClass.ChangeSirenState( self, state )
    end

    function ENT:OnPostThink( dt, selfTbl )
        BaseClass.OnPostThink( self, dt, selfTbl )

        local driver = self:GetDriver()

        if IsValid( driver ) then
            local att = self:GetAttachment( self.muzzle )
            local pos = att.Pos
            local aimPos = driver:GlideGetAimPos()

            local dir = aimPos - pos
            local ang = dir:Angle()
            ang = self:WorldToLocalAngles( ang )
            self:SetAimAng( ang )

            self:ManipulateTurretBones( ang )

            self.LaserDot:SetPos( aimPos )
        end
    end

    function ENT:GetSpawnColor()
        return Color( 255, 255, 255 )
    end

    function ENT:InitializePhysics()
        self:SetSolid( SOLID_VPHYSICS )
        self:SetMoveType( MOVETYPE_VPHYSICS )
        self:PhysicsInit( SOLID_VPHYSICS, Vector( -17.5, 0, 21 ) )
    end

    -- function ENT:OnSeatInput( seatIndex, action, pressed )
    --     if seatIndex == 1 and action == "horn" and pressed then
    --         self.weapons[ 1 ]:CustomReload()
    --         return
    --     end
    --     BaseClass.OnSeatInput( self, seatIndex, action, pressed )
    -- end

    -- Damage function from tank base
    function ENT:OnTakeDamage( dmginfo )
        if dmginfo:IsDamageType( 64 ) then -- DMG_BLAST
            local inflictor = dmginfo:GetInflictor()

            -- Increase damage taken by Half-life 2 RPGs
            if IsValid( inflictor ) and inflictor:GetClass() == "rpg_missile" then
                dmginfo:SetDamage( dmginfo:GetDamage() * 2.5 )
            end
        end

        BaseClass.OnTakeDamage( self, dmginfo )
    end
end

local ang = Angle()
local pos = Vector()

function ENT:ManipulateTurretBones( turretAng )
    if not self.turret then return end

    local rotation = 180 - math.abs( ( turretAng[2] + 270 ) % 360 - 180 )

    ang[1] = turretAng[2]
    ang[2] = 0
    ang[3] = turretAng[1]

    pos[2] = rotation / 180 * 24

    self:ManipulateBoneAngles( self.turret, ang, false )
    self:ManipulateBonePosition( self.piston, pos, false )
end

local firstPersonOffset = Vector( 0, 0, 126 )

function ENT:GetFirstPersonOffset()
    return firstPersonOffset
end