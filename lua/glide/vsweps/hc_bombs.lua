VSWEP.Base = "base"
VSWEP.Name = "Bombs"
VSWEP.Icon = "glide/aim_dot.png"

if SERVER then
	function VSWEP:CreateBomb( vehicle, velocity )
		local attacker = vehicle:GetSeatDriver( 1 )

		local bomb = ents.Create( "grenade_helicopter" )
		bomb:SetPos( vehicle:GetAttachment( 3 ).Pos - vehicle:GetUp() * 32 )
		bomb:SetOwner( attacker )
		bomb:Spawn()

		bomb:GetPhysicsObject():SetVelocity( velocity )
		bomb:GetPhysicsObject():SetBuoyancyRatio( 1 )
	end

	function VSWEP:PrimaryAttack()
		self:TakePrimaryAmmo( 1 )
		self:SetNextPrimaryFire( CurTime() + self.FireDelay )

		local vehicle = self.Vehicle

		local velocity = vehicle:GetVelocity()
		local velocityAcross = vehicle:GetRight()

		velocityAcross = velocityAcross * math.Rand( 300, 500 )

		velocity.z = math.min( 0, velocity.z )

		self:CreateBomb( vehicle, velocity )
		self:CreateBomb( vehicle, velocity + velocityAcross )
		self:CreateBomb( vehicle, velocity - velocityAcross )

		vehicle:EmitSound( "NPC_AttackHelicopter.DropMine" )
	end
end

if CLIENT then
	VSWEP.CrosshairImage = "glide/aim_square.png"

	VSWEP.LocalCrosshairOrigin = Vector( 0, 0, -80 )
	VSWEP.LocalCrosshairAngle = Angle( 90, 0, 0 )
end
