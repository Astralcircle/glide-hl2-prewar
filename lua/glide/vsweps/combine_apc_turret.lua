VSWEP.Base = "base"
VSWEP.Name = "#glide.weapons.cannon"
VSWEP.Icon = "glide/icons/bullets.png"

if SERVER then
	VSWEP.FireDelay = 0.12
	VSWEP.MuzzleAtt = 0
	VSWEP.SingleShotSound = "Weapon_AR2.Single"
end

if CLIENT then
	VSWEP.CrosshairImage = "glide/aim_dot.png"

	local DrawWeaponCrosshair = Glide.DrawWeaponCrosshair

	function VSWEP:DrawCrosshair()
		if self.CrosshairImage == "" then return end

		DrawWeaponCrosshair( ScrW() / 2, ScrH() / 2, self.CrosshairImage, self.CrosshairSize, color )
	end
end

if SERVER then
	function VSWEP:PrimaryAttack()
		self:TakePrimaryAmmo( 1 )
		self:SetNextPrimaryFire( CurTime() + self.FireDelay )
		self:IncrementProjectileIndex()
		self:ShootEffects()

		local vehicle = self.Vehicle
		local driver = vehicle:GetSeatDriver( 1 )

		local att = vehicle:GetAttachment( self.MuzzleAtt )
		local pos = att.Pos

		local aimPos = driver:GlideGetAimPos()

		local dir = aimPos - pos
		dir:Normalize()

		local bullet = {}
		bullet.Num = 1
		bullet.Src = pos
		bullet.Dir = dir
		bullet.Spread = Vector( 0.015, 0.015, 0 )
		bullet.Tracer = 1
		bullet.TracerName = "HelicopterTracer"
		bullet.Force = 20
		bullet.Damage = self.Damage
		bullet.Attacker = driver
		bullet.Callback = function( _, trace, dmginfo )
			if not trace.HitPos or not trace.HitNormal then return end

			dmginfo:SetDamageType( DMG_BULLET + DMG_AIRBOAT )

			local e = EffectData()
			e:SetOrigin( trace.HitPos )
			e:SetNormal( trace.HitNormal )
			util.Effect( "AR2Impact", e )
		end

		vehicle:FireBullets( bullet )

		local effectData = EffectData()
		effectData:SetAttachment( self.MuzzleAtt )
		effectData:SetEntity( vehicle )
		-- effectData:SetOrigin( po )
		effectData:SetFlags( 0 )

		util.Effect( "AirboatMuzzleFlash", effectData )
	end
end
