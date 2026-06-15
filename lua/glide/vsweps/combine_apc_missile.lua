VSWEP.Base = "base"
VSWEP.Name = "#glide.weapons.missiles"
VSWEP.Icon = "glide/icons/rocket.png"

if SERVER then
	VSWEP.FireDelay = 1
	VSWEP.MuzzleAtt = 0
	VSWEP.MaxAmmo = 1
	VSWEP.ReloadDelay = 5
	VSWEP.SingleShotSound = "PropAPC.FireRocket"
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
		if IsValid( self.ActiveMissile ) then return end

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

		local missile = ents.Create( "rpg_missile" )
		missile:SetPos( att.Pos )
		missile:SetAngles( att.Ang )
		missile:SetOwner( vehicle )
		missile:SetSaveValue( "m_flDamage", 150 )
		missile:Spawn()
		missile:Activate()
		missile:NextThink( CurTime() )

		self.ActiveMissile = missile
	end
end
