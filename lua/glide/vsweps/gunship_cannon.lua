-- PLEASE NOTE: THIS IS SHIT
-- ITS A VERY HAPHAZARD PORT OF WEAPONS FROM THE OLD SYSTEM TO THE NEW
-- DO NOT TRY TO LEARN FROM IT

VSWEP.Base = "base"
VSWEP.Name = "#glide.weapons.cannon"

if SERVER then
	function VSWEP:PrimaryAttack()
		local vehicle = self.Vehicle

		local attacker = vehicle:GetSeatDriver( 1 )

		if not IsValid( attacker ) then return end

		self:TakePrimaryAmmo( 1 )
		self:SetNextPrimaryFire( CurTime() + self.FireDelay )
		-- self:IncrementProjectileIndex()
		self:ShootEffects()

		local att = vehicle:GetAttachment( vehicle.muzzle )
		local pos = att.Pos
		local aimPos = attacker:GlideGetAimPos()

		local dir = aimPos - pos
		dir:Normalize()

		if dir:Dot( vehicle:GetForward() ) < 0.9 then
			vehicle:SetFiringGun( false )
			return
		end

		vehicle:SetFiringGun( true )

		local bullet = {}
		bullet.Num = 1
		bullet.Src = pos
		bullet.Dir = dir
		bullet.Spread = Vector( 0.02, 0.02, 0 )
		bullet.Tracer = 1
		bullet.TracerName = "HelicopterTracer"
		bullet.Force = 200
		bullet.Damage = 20
		bullet.Attacker = attacker
		bullet.Callback = function( _, trace, dmginfo )
			dmginfo:SetDamageType( DMG_AIRBOAT )
		end

		vehicle:FireBullets( bullet )

		local effectData = EffectData()
		effectData:SetAttachment( vehicle.muzzle )
		effectData:SetEntity( vehicle )

		util.Effect( "GunshipMuzzleFlash", effectData )
	end

	function VSWEP:ShootEffects()

	end
end

if CLIENT then
	local DrawWeaponCrosshair = Glide.DrawWeaponCrosshair

	function VSWEP:DrawCrosshair()
		if self.CrosshairImage == "" then return end

		DrawWeaponCrosshair( ScrW() / 2, ScrH() / 2, self.CrosshairImage, self.CrosshairSize, color )
	end
end
