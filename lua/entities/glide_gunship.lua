AddCSLuaFile()

ENT.GlideCategory = "HL2"

ENT.Type = "anim"
ENT.Base = "base_glide_heli"
ENT.PrintName = "Combine Gunship"
ENT.Author = ".kkrill"

DEFINE_BASECLASS( "base_glide_heli" )

ENT.MainRotorOffset = Vector( 20, 0, 65 )
ENT.MainRotorAngle = Angle( 15, 0, 0 )
ENT.TailRotorOffset = Vector( -218, 4, -1.8 )
ENT.TailRotorAngle = Angle( 90, 0, 0 )

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:SetupDataTables()
    BaseClass.SetupDataTables( self )

    self:NetworkVar( "Bool", "FiringGun" )
end

if CLIENT then

    ENT.CameraOffset = Vector( -700, 0, 150 )

    ENT.DistantSoundPath = "NPC_CombineGunship.RotorSound"
    ENT.TailSoundPath = "NPC_CombineGunship.RotorSound"

    ENT.BassSoundSet = "Glide.MilitaryRotor.Bass"
    ENT.MidSoundSet = "Glide.MilitaryRotor.Mid"
    ENT.HighSoundSet = "Glide.MilitaryRotor.High"

    ENT.ExhaustPositions = {
        Vector( -65, 0, -8 )
    }

    ENT.EngineFireOffsets = {
        { offset = Vector( -65, 0, -8 ), angle = Angle( -90, 0, 0 ) }
    }

    ENT.RotorBeatInterval = 0.09

    function ENT:OnActivateMisc()
        BaseClass.OnActivateMisc( self )

        self.rotorMain = self:LookupBone( "Gunship.Propeller" )
    end

    ENT.SpinAngleMain = Angle()

    function ENT:Think()
        if self.rotorMain then
            local dt = FrameTime()

            self.SpinAngleMain.p = ( self.SpinAngleMain.p + 2000 * self:GetPower() * dt ) % 360

            self:ManipulateBoneAngles( self.rotorMain, self.SpinAngleMain )
        end

        return BaseClass.Think( self )
    end

    function ENT:OnUpdateSounds()
        BaseClass.OnUpdateSounds( self )

        local sounds = self.sounds

        if self:GetFiringGun() then
            if not sounds.gunFire then
                local gunFire = self:CreateLoopingSound( "gunFire", "NPC_CombineGunship.CannonSound", 95, self )
                gunFire:PlayEx( 1.0, 100 )
            end

        elseif sounds.gunFire then
            sounds.gunFire:Stop()
            sounds.gunFire = nil
        end
    end

    function ENT:AllowFirstPersonMuffledSound() return false end
end

if SERVER then
    ENT.ChassisMass = 500
    ENT.ChassisModel = "models/gunship.mdl"

    ENT.MainRotorRadius = 5
    ENT.TailRotorRadius = 5

    ENT.MainRotorModel = ""
    ENT.MainRotorFastModel = ""

    ENT.TailRotorModel = ""
    ENT.TailRotorFastModel = ""

    ENT.ExplosionGibs = {
        "models/gibs/gunship_gibs_engine.mdl",
        "models/gibs/gunship_gibs_eye.mdl",
        "models/gibs/gunship_gibs_eye.mdl",
        "models/gibs/gunship_gibs_headsection.mdl",
        "models/gibs/gunship_gibs_midsection.mdl",
        "models/gibs/gunship_gibs_nosegun.mdl",
        "models/gibs/gunship_gibs_sensorarray.mdl",
        "models/gibs/gunship_gibs_tailsection.mdl",
        "models/gibs/gunship_gibs_wing.mdl"
    }

    ENT.HelicopterParams = {
        -- basePower = 0,

        -- drag = Vector( 0.3, 0.5, 0.5 ),
        -- maxForwardDrag = 200,
        -- maxSideDrag = 300,

        -- turbulanceForce = 50,
        -- pushUpForce = 250,
        -- pitchForce = 1000,
        -- yawForce = 1000,
        -- rollForce = 1000,

        -- pushForwardForce = 10,
        -- maxSpeed = 2500,

        -- uprightForce = 1000,
        maxPitch = 70,
        -- maxRoll = 85
    }

    function ENT:CreateFeatures()
        self:CreateSeat( Vector( 0, 0, 0 ), nil,Vector( 146, 93, -49 ), true )

        for k, v in pairs( self.rotors ) do
            v:SetNoDraw( true )
        end

        self:CreateWeapon( "gunship_cannon", {
            FireDelay = 0.1,
        } )

        self:CreateWeapon( "gunship_belly_cannon", {
            FireDelay = 5,
        } )

        self.muzzle = self:LookupAttachment( "muzzle" )
        self.bellyCannon = self:LookupAttachment( "bellygun" )
    end

    ENT.NextWeaponFire = 0

    function ENT:FireBellyCannon( attacker )
        local ef = EffectData()
        ef:SetEntity( self )
        util.Effect( "ef_gunship_bellycannon_charge", ef )
        self:EmitSound( "NPC_Strider.Charge" )

        timer.Simple( 2, function()
            if not IsValid( self ) then return end

            self:GetPhysicsObject():AddVelocity( self:GetUp() * 256 )

            self:EmitSound( "NPC_Strider.Shoot" )

            local startPos = self:GetAttachment( self.bellyCannon ).Pos

            local tr = util.TraceLine( {
                start = startPos,
                endpos = startPos - self:GetUp() * 32768,
                filter = self
            } )

            local ef = EffectData()
            ef:SetOrigin( tr.HitPos + tr.HitNormal * 4 )
            ef:SetNormal( tr.HitNormal )
            ef:SetRadius( 256 )
            util.Effect( "AR2Explosion", ef )

            local dmginfo = DamageInfo()
            dmginfo:SetDamage( 1000 )
            dmginfo:SetAttacker( attacker )
            dmginfo:SetInflictor( self )
            dmginfo:SetDamageType( DMG_BLAST + DMG_DISSOLVE )

            util.BlastDamageInfo( dmginfo, tr.HitPos, 256 )
            dmginfo:SetDamage( 1000 )
            tr.Entity:TakeDamageInfo( dmginfo )
        end )
    end

    function ENT:OnWeaponFire( weapon, weaponIndex )
        if weaponIndex == 1 then
            if CurTime() < self.NextWeaponFire then return false end

            if self.NextWeaponFire == 0 then
                self.NextWeaponFire = CurTime() + 0.6
                self:EmitSound("NPC_CombineGunship.CannonStartSound")
                return false
            end
        end

        return true
    end

    function ENT:OnWeaponStop( weapon, weaponIndex )
        if weaponIndex == 1 then
            self.NextWeaponFire = 0
            self:SetFiringGun( false )
            self:EmitSound( "NPC_CombineGunship.CannonStopSound" )
        end
    end

    ENT.BodyPitch = 0
    ENT.BodyYaw = 0
    ENT.FinPitch = 0
    ENT.FinRoll = 0

    function ENT:AnimateBody( inputPitch, inputRoll )
        local ply = self:GetSeatDriver( 1 )

        local pitch = 0
        local yaw = 0

        if IsValid( ply ) then
            local dir = ply:GlideGetAimPos() - self:GetAttachment( 1 ).Pos
            dir:Normalize()

            local _, ang = WorldToLocal( ply:GlideGetAimPos(), dir:Angle(), self:GetAttachment( 1 ).Pos, self:GetAngles() )
            pitch = ang.p
            yaw = ang.y
        end

        local pitchMin, pitchMax = self:GetPoseParameterRange( 0 )
        local yawMin, yawMax = self:GetPoseParameterRange( 1 )

        pitch = math.Clamp( pitch, pitchMin, pitchMax )
        yaw = math.Clamp( yaw, yawMin, yawMax )

        local dt = FrameTime()

        self.BodyPitch = self.BodyPitch + ( pitch - self.BodyPitch ) * dt * 10
        self.BodyYaw = self.BodyYaw + ( yaw - self.BodyYaw ) * dt * 10
        self.FinPitch = self.FinPitch + ( inputPitch - self.FinPitch ) * dt * 5
        self.FinRoll = self.FinRoll + ( inputRoll - self.FinRoll ) * dt * 5

        self:SetPoseParameter( 0, self.BodyPitch )
        self:SetPoseParameter( 1, self.BodyYaw )
        self:SetPoseParameter( 2, self.FinPitch )
        self:SetPoseParameter( 3, self.FinRoll )
    end

    function ENT:OnPostThink( dt, selfTbl )
        BaseClass.OnPostThink( self, dt, selfTbl )

        self:AnimateBody( selfTbl.inputPitch, selfTbl.inputRoll )
    end

    function ENT:OnTakeDamage( dmginfo )
        local oldHealth = self:GetChassisHealth() / self.MaxChassisHealth

        BaseClass.OnTakeDamage( self, dmginfo )

        local newHealth = self:GetChassisHealth() / self.MaxChassisHealth

        if oldHealth > 0 and newHealth < 0 then
            self:EmitSound( "NPC_CombineGunship.Explode" )
            return
        end

        if oldHealth > 0.33 and newHealth < 0.33 then
            self:EmitSound( "NPC_CombineGunship.Pain" )
            return
        end

        if oldHealth > 0.66 and newHealth < 0.66 then
            self:EmitSound( "NPC_CombineGunship.Pain" )
            return
        end

    end

    function ENT:GetSpawnColor()
        return Color( 255, 255, 255 )
    end
end

function ENT:GetFirstPersonOffset()
    return Vector( 120, 0, 60 )
end