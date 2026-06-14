local beamFX = Material("sprites/bluelaser1")

EFFECT.LifeTime = 2.125
EFFECT.DieTime = 0
EFFECT.Attachment = 0

function EFFECT:Init( data )
    self.Entity = data:GetEntity()
    self.Attachment = self.Entity:LookupAttachment( "bellygun" )
    self.DieTime = CurTime() + self.LifeTime

    local pos = self.Entity:GetPos()
    self:SetRenderBoundsWS( pos, pos - self.Entity:GetUp() * 32768 )
end

function EFFECT:Think()
    if CurTime() > self.DieTime then return false end

    return true
end

-- local function lerp( x )
--     return ( ( ( x - 0.5 ) * 4 ) ^ 3 ) * 0.0625 + 0.5
-- end

local lerp = math.ease.InExpo

function EFFECT:Render()
    if !IsValid( self.Entity ) then return end

    local muzzle = self.Entity:GetAttachment( self.Attachment )

    local progress = self.LifeTime - ( self.DieTime - CurTime() )

    local delta

    if progress < 2 then
        delta = lerp( progress / 2 )
    else
        delta = -( ( progress - 2 ) * 8 ) ^ 2 + 1
    end

    local tr = util.TraceLine( {
        start = muzzle.Pos,
        endpos = muzzle.Pos - self.Entity:GetUp() * 32768,
        filter = self.Entity
    } )

    self:SetRenderBoundsWS( muzzle.Pos, tr.HitPos )

    render.SetMaterial( beamFX )
    render.DrawBeam( muzzle.Pos, tr.HitPos, delta * 196, 0, 1, color_white )
end