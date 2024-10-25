local lib = LibStub:NewLibrary("CraftIDToProfessionInfo",1)
if not lib then return end

local spellList = {
	[131686] = { --Facets of Research
		["Profession"] = "JewelCrafting",
		["Name"] = "Facets of Research",
		["Ingredients"] = "Primordial Ruby",
		},
	[53771] = { --Eternal Shadow
		["Profession"] = "Alchemy",
		["Name"] = "Eternal Shadow",
		["Ingredients"] = "From Eternal Life",
		},
	[53773] = { --Eternal Fire
		["Profession"] = "Alchemy",
		["Name"] = "Eternal Fire",
		["Ingredients"] = "From Eternal Life",
		},
	[53775] = { --Eternal Life
		["Profession"] = "Alchemy",
		["Name"] = "Eternal Life",
		["Ingredients"] = "From Eternal Fire",
		},
	[131695] = { --Facets of Research
		["Profession"] = "JewelCrafting",
		["Name"] = "Facets of Research",
		["Ingredients"] = "Sun's Radiance",
		},
	[53779] = { --Eternal Earth
		["Profession"] = "Alchemy",
		["Name"] = "Eternal Earth",
		["Ingredients"] = "From Eternal Shadow",
		},
	[53781] = { --Eternal Air
		["Profession"] = "Alchemy",
		["Name"] = "Eternal Air",
		["Ingredients"] = "From Eternal Earth",
		},
	[131593] = { --Facets of Research
		["Profession"] = "JewelCrafting",
		["Name"] = "Facets of Research",
		["Ingredients"] = "River's Heart",
		},
	[131688] = { --Facets of Research
		["Profession"] = "JewelCrafting",
		["Name"] = "Facets of Research",
		["Ingredients"] = "Wild Jade",
		},
	[86654] = { --Forged Documents Horde
		["Profession"] = "Inscription",
		["Name"] = "Forged Documents",
		["Ingredients"] = "Horde",
		},
	[89244] = { --Forged Documents Alliance
		["Profession"] = "Inscription",
		["Name"] = "Forged Documents",
		["Ingredients"] = "Alliance",
		},
	[112996] = { --Scroll of Wisdom
		["Profession"] = "Inscription",
		["Name"] = "Scroll of Wisdom",
		},
	[75141] = {--Dreamcloth
		["Profession"] = "Tailoring",
		["Name"] = "Dreamcloth",
		["Ingredients"] = "Volatile Air",
		},
	[75145] = { --Dreamcloth
		["Profession"] = "Tailoring",
		["Name"] = "Dreamcloth",
		["Ingredients"] = "Volatile Fire",
		},
	[78866] = { --Random Volatile Element
		["Profession"] = "Alchemy",
		["Name"] = "Random Volatile Element",
		},
	[114780] = { --Living Steel
		["Profession"] = "Alchemy",
		["Name"] = "Living Steel",
		},
	[125557] = { --Silkworm Cocoon
		["Profession"] = "Tailoring",
		["Name"] = "Silkworm Cocoon",
		},
	[66660] = {--King's Amber
		["Profession"] = "Alchemy",
		["Name"] = "King's Amber",
		},
	[66664] = {--Eye of Zul
		["Profession"] = "Alchemy",
		["Name"] = "Eye of Zul",
		},
	[17559] = { --Essence of Fire
		["Profession"] = "Alchemy",
		["Name"] = "Essence of Fire",
		},
	[131690] = { --Facets of Research
		["Profession"] = "JewelCrafting",
		["Name"] = "Facets of Research",
		["Ingredients"] = "Vermillion Onyx",
		},
	[17562] = { --Essence of Air
		["Profession"] = "Alchemy",
		["Name"] = "Essence of Air",
		},
	[75142] = { --Dreamcloth
		["Profession"] = "Tailoring",
		["Name"] = "Dreamcloth",
		["Ingredients"] = "Volatile Earth",
		},
	[75146] = { --Dreamcloth
		["Profession"] = "Tailoring",
		["Name"] = "Dreamcloth",
		["Ingredients"] = "Volatile Water",
		},
	[53774] = { --Eternal Water
		["Profession"] = "Alchemy",
		["Name"] = "Eternal Water",
		["Ingredients"] = "From Eternal Fire",
		},
	[131691] = { --Facets of Research
		["Profession"] = "JewelCrafting",
		["Name"] = "Facets of Research",
		["Ingredients"] = "Imperial Amethyst",
		},
	[53780] = { --Eternal Life
		["Profession"] = "Alchemy",
		["Name"] = "Eternal Life",
		["Ingredients"] = "From Eternal Shadow",
		},
	[53782] = {  --Eternal Shadow
		["Profession"] = "Alchemy",
		["Name"] = "Eternal Shadow",
		["Ingredients"] = "From Eternal Earth",
		},
	[53784] = { --Eternal Fire
		["Profession"] = "Alchemy",
		["Name"] = "Eternal Fire",
		["Ingredients"] = "From Eternal Water",
		},
	[53783] = { --Eternal Air
		["Profession"] = "Alchemy",
		["Name"] = "Eternal Air",
		["Ingredients"] = "From Eternal Water",
		},
	[53776] = { --Eternal Water
		["Profession"] = "Alchemy",
		["Name"] = "Eternal Water",
		["Ingredients"] = "From Eternal Air",
		},
	[138646] = { --Lightning Steel Ingot
		["Profession"] = "Blacksmithing",
		["Name"] = "Lightning Steel Ingot",
		},
	[66663] = { --Majestic Zircon
		["Profession"] = "Alchemy",
		["Name"] = "Majestic Zircon",
		},
	[139176] = { --Jard's Peculiar Energy Source
		["Profession"] = "Engineering",
		["Name"] = "Jard's Peculiar Energy Source",
		}, 
	[75144] = { --Dreamcloth
		["Name"] = "Dreamcloth",
		["Profession"] = "Tailoring",
		["Ingredients"] = "Volatile Life",
		},
	[140050] = { --Serpent's Heart
		["Profession"] = "JewelCrafting",
		["Name"] = "Serpent's Heart",
		},
	[11480] = { --Truesilver Bar
		["Profession"] = "Alchemy",
		["Name"] = "Truesilver Bar",
		},
	[11479] = { --Gold Bar
		["Profession"] = "Alchemy",
		["Name"] = "Gold Bar",
		},
	[66658] = { --Ametrine
		["Profession"] = "Alchemy",
		["Name"] = "Ametrine",
		},
	[66662] = { --Dreadstone
		["Profession"] = "Alchemy",
		["Name"] = "Dreadstone",
		},
	[116499] = { --Sha Crystal
		["Profession"] = "Enchanting",
		["Name"] = "Sha Crystal",
		},
	[53777] = { --Eternal Earth
		["Name"] = "Eternal Earth",
		["Profession"] = "Alchemy",
		["Ingredients"] = "From Eternal Air",
		},
	[73478] = { -- Fire Prism
		["Name"] = "Fire Prism",
		["Profession"] = "JewelCrafting",
		},
	[80244]  = { -- Pyrium Bar
		["Name"] = "Pyrium Bar",
		["Profession"] = "Alchemy",
		},
	[140040] = { -- Magnificence of Leather
		["Profession"] = "Leatherworking",
		["Name"] = "Magnificence of Leather",
		},
	[140041] = { -- Magnificence of Scales
		["Profession"] = "Leatherworking",
		["Name"] = "Magnificence of Scales",
		},
	[143011] = { --Celestial Cloth
		["Profession"] = "Tailoring",
		["Name"] = "Celestial Cloth",
        },
	[17561] = { --Essence of Water
		["Profession"] = "Alchemy",
		["Name"] = "Essence of Water",
		},

	[143255] = { --Balanced Trillium Ingot
		["Profession"] = "Blacksmithing",
		["Name"] = "Balanced Trillium Ingot",
		},

	[142976] = { -- Hardened Magnificent Hide
		["Profession"] = "Leatherworking",
		["Name"] = "Hardened Magnificent Hide",
		},
	[66659] = { -- Cardinal Ruby
		["Profession"] = "Alchemy",
		["Name"] = "Cardinal Ruby",
		},
	[28569] = {--Primal Air
		["Profession"] = "Alchemy",
		["Name"] = "Primal Air",
		["Ingredients"] = "From Primal Water",
		},
	[56005] = {--Glacial Bag
		["Profession"] = "Tailoring",
		["Name"] = "Glacial Bag",
		},
	[28581] = {--Primal Shadow
		["Profession"] = "Alchemy",
		["Name"] = "Primal Shadow",
		["Ingredients"] = "From Primal Water",
		},
	[28583] = {--Primal Mana
		["Profession"] = "Alchemy",
		["Name"] = "Primal Mana",
		["Ingredients"] = "From Primal Fire",
		},
	[28585] = {--Primal Life
		["Profession"] = "Alchemy",
		["Name"] = "Primal Life",
		["Ingredients"] = "From Primal Earth",
		},
	[28566] = {--Primal Fire
		["Profession"] = "Alchemy",
		["Name"] = "Primal Fire",
		["Ingredients"] = "From Primal Air",
		},
	[28568] = {--Primal Earth
		["Profession"] = "Alchemy",
		["Name"] = "Primal Earth",
		["Ingredients"] = "From Primal Fire",
		},
	[17564] = {--Essence of Undeath
		["Profession"] = "Alchemy",
		["Name"] = "Essence of Undeath",
		["Ingredients"] = "From Essence of Water",
		},
	[17566] = {--Living Essence
		["Profession"] = "Alchemy",
		["Name"] = "Living Essence",
		["Ingredients"] = "From Essence of Earth",
		},
	[28580] = {--Primal Water
		["Profession"] = "Alchemy",
		["Name"] = "Primal Water",
		["Ingredients"] = "From Primal Shadow",
		},
	[28582] = {--Primal Fire
		["Profession"] = "Alchemy",
		["Name"] = "Primal Fire",
		["Ingredients"] = "From Primal Water",
		},
	[28584] = {--Primal Earth
		["Profession"] = "Alchemy",
		["Name"] = "Primal Earth",
		["Ingredients"] = "From Primal Life",
		},
	[28567] = {--Primal Water
		["Profession"] = "Alchemy",
		["Name"] = "Primal Water",
		["Ingredients"] = "From Primal Earth",
		},
	[17560] = { -- Transmute: Fire to earth
		["Profession"] = "Alchemy",
		["Name"] = "Transmute: Fire to Earth",
		},
	[17563] = { -- Transmute: Undeath to Water
		["Profession"] = "Alchemy",
		["Name"] = "Transmute: Undeath to Water",
		},
	[17565] = { -- Transmute: Life to Earth
		["Profession"] = "Alchemy",
		["Name"] = "Transmute: Life to Earth",
		},
	}

function lib:spellIDToProfession(spellID)
	if spellList[spellID]then
		if spellList[spellID]["Profession"] then
			local Profession = spellList[spellID]["Profession"]
			return Profession
		else
			return
		end
	end
end

function lib:spellIDToName(spellID)
	if spellList[spellID]then
		local Name = spellList[spellID]["Name"]
		return Name
	end
end

function lib:spellIDToIngredients(spellID)
	if spellList[spellID]then
		if spellList[spellID]["Ingredients"] then
			local Ingredients = spellList[spellID]["Ingredients"]
			return Ingredients
		else 
			return ""
		end
	end
end

function lib:spellIDToSharedCD(spellID)
	-- NYI Will return Table containing Items.
end