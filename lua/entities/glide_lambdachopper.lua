AddCSLuaFile()

ENT.GlideCategory = "HL2"

ENT.Type = "anim"
ENT.Base = "glide_hunterchopper"
ENT.Author = ".kkrill"
ENT.PrintName = "Lambda-Chopper"

DEFINE_BASECLASS( "glide_hunterchopper" )

function ENT:CreateFeatures()
	BaseClass.CreateFeatures( self )

	self:SetSubMaterial( 0, "models/resist/combine_helicopter01" )
end
