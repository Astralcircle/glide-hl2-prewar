AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

DEFINE_BASECLASS( "base_glide_car" )

--- Implement this base class function.
function ENT:OnPostInitialize()
	BaseClass.OnPostInitialize( self )

	-- Setup variables used on all tanks

	self.isCannonInsideWall = false

	self:SetTurretAngle( Angle() )
	self:SetIsAimingAtTarget( false )
end

--- Override this base class function.
function ENT:OnTakeDamage( dmginfo )
	if dmginfo:IsDamageType( 64 ) then -- DMG_BLAST
		local inflictor = dmginfo:GetInflictor()

		-- Increase damage taken by Half-life 2 RPGs
		if IsValid( inflictor ) and inflictor:GetClass() == "rpg_missile" then
			dmginfo:SetDamage( dmginfo:GetDamage() * 2.5 )
		end
	end

	BaseClass.OnTakeDamage( self, dmginfo )

	if self:GetEngineHealth() <= 0 and self:GetEngineState() == 2 then
		self:TurnOff()
	end
end

function ENT:GetTurretOrigin()
	return self:LocalToWorld( self.TurretOffset )
end

function ENT:GetTurretAimDirection()
	local origin = self:GetTurretOrigin()
	local ang = self:LocalToWorldAngles( self:GetTurretAngle() )

	-- Use the driver's aim position directly when
	-- the turret is aiming close enough to it.
	local driver = self:GetDriver()

	if IsValid( driver ) and self:GetIsAimingAtTarget() then
		local dir = driver:GlideGetAimPos() - origin
		dir:Normalize()
		ang = dir:Angle()
	end

	return ang:Forward()
end

local TraceLine = util.TraceLine

function ENT:GetTurretAimPosition()
	local origin = self:GetTurretOrigin()
	local target = origin + self:GetTurretAimDirection() * 50000
	local tr = TraceLine( self:GetTraceData( origin, target ) )

	if tr.Hit then
		target = tr.HitPos
	end

	return target
end

--- Implement this base class function.
function ENT:OnPostThink( dt, selfTbl )
	BaseClass.OnPostThink( self, dt, selfTbl )

	-- Update turret angles, if we have a driver
	local driver = self:GetDriver()

	if IsValid( driver ) and self:WaterLevel() < 2 then
		local newAng, isAimingAtTarget = self:UpdateTurret( driver, dt, self:GetTurretAngle() )

		-- Don't let it shoot while inside walls
		local origin = self:GetTurretOrigin()
		local projectilePos = self:GetProjectileStartPos()
		local tr = TraceLine( self:GetTraceData( origin, projectilePos ) )

		selfTbl.isCannonInsideWall = tr.Hit

		if selfTbl.isCannonInsideWall then
			isAimingAtTarget = false
		end

		self:SetTurretAngle( newAng )
		self:SetIsAimingAtTarget( isAimingAtTarget )
		self:ManipulateTurretBones( newAng )
	end
end
