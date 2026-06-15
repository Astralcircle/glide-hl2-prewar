VSWEP.Base = "base"
VSWEP.Name = "Belly Cannon"
VSWEP.Icon = "glide/aim_dot.png"

if SERVER then
	function VSWEP:PrimaryAttack()
		self:TakePrimaryAmmo( 1 )
		self:SetNextPrimaryFire( CurTime() + self.FireDelay )

		local vehicle = self.Vehicle

		local ef = EffectData()
		ef:SetEntity( vehicle )
		util.Effect( "ef_gunship_bellycannon_charge", ef )
		vehicle:EmitSound( "NPC_Strider.Charge" )

		local attacker = vehicle:GetSeatDriver( 1 )

		timer.Simple( 2, function()
			if not IsValid( vehicle ) then return end

			vehicle:GetPhysicsObject():AddVelocity( vehicle:GetUp() * 256 )

			vehicle:EmitSound( "NPC_Strider.Shoot" )

			local startPos = vehicle:GetAttachment( vehicle.bellyCannon ).Pos

			local tr = util.TraceLine( {
				start = startPos,
				endpos = startPos - vehicle:GetUp() * 32768,
				filter = vehicle
			} )

			local ef = EffectData()
			ef:SetOrigin( tr.HitPos + tr.HitNormal * 4 )
			ef:SetNormal( tr.HitNormal )
			ef:SetRadius( 256 )
			util.Effect( "AR2Explosion", ef )

			local dmginfo = DamageInfo()
			dmginfo:SetDamage( 2000 )
			dmginfo:SetAttacker( attacker )
			dmginfo:SetInflictor( vehicle )
			dmginfo:SetDamageType( DMG_BLAST + DMG_DISSOLVE )

			util.BlastDamageInfo( dmginfo, tr.HitPos, 256 )
			dmginfo:SetDamage( 2000 )
			tr.Entity:TakeDamageInfo( dmginfo )
		end)
	end
end

if CLIENT then
	VSWEP.LocalCrosshairOrigin = Vector( 38.7, 0, -21 )
	VSWEP.LocalCrosshairAngle = Angle( 90, 0, 0 )
end
