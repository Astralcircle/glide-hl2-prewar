-- PLEASE NOTE: THIS IS SHIT
-- ITS A VERY HAPHAZARD PORT OF WEAPONS FROM THE OLD SYSTEM TO THE NEW
-- DO NOT TRY TO LEARN FROM IT

VSWEP.Base = "base"
VSWEP.Name = "#glide.weapons.cannon"

if SERVER then
    VSWEP.ReloadDelay = math.huge -- BIG HACK

    function VSWEP:PrimaryAttack()
        local vehicle = self.Vehicle

        local attacker = vehicle:GetSeatDriver( 1 )

        if not IsValid( attacker ) then return end

        if vehicle:WaterLevel() > 2 then return end

        if vehicle.isCannonInsideWall then
            return
        end

        self:TakePrimaryAmmo( 1 )
        self:SetNextPrimaryFire( CurTime() + self.FireDelay )
        -- self:IncrementProjectileIndex()
        self:ShootEffects()

        local aimPos = vehicle:GetTurretAimPosition()
        local projectilePos = vehicle:GetProjectileStartPos()

        -- Make the projectile point towards the direction the
        -- turret is aiming at, no matter where it spawned.
        local dir = aimPos - projectilePos
        dir:Normalize()

        vehicle:FireBullet( {
            pos = projectilePos,
            ang = dir:Angle(),
            attacker = attacker,
            isExplosive = true,
            spread = 0.3
        } )

        vehicle:EmitSound( "Glide.ConscriptAPC.Fire" )

        if self.ammo == 0 then
            self:CustomReload( self, true )
        end
    end

    function VSWEP:CustomReload( forced )
        if !forced and CurTime() < self.nextFire then return end
        self.ammo = self.MaxAmmo
        self.Vehicle:EmitSound( "Glide.ConscriptAPC.Reload" )
        self:SetNextPrimaryFire( CurTime() + 2 )
    end

    function VSWEP:ShootEffects()

    end
end

if CLIENT then
    local DrawWeaponCrosshair = Glide.DrawWeaponCrosshair

    VSWEP.CrosshairImage = "glide/aim_tank.png"
    VSWEP.CrosshairSize = 0.14

    function VSWEP:DrawCrosshair()
        if self.CrosshairImage == "" then return end

        DrawWeaponCrosshair( ScrW() / 2, ScrH() / 2, self.CrosshairImage, self.CrosshairSize, color )
    end
end