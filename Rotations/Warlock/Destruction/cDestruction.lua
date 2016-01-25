--- Windwalker Class
-- Inherit from: ../cCharacter.lua and ../cMonk.lua
if select(2, UnitClass("player")) == "WARLOCK" then

    cDestruction = {}

    -- Creates Windwalker Monk
    function cDestruction:new()
        local self = cWarlock:new("Destruction")

        local player = "player" -- if someone forgets ""

        -----------------
        --- VARIABLES ---
        -----------------

        self.enemies = {
            yards5,
            yards8,
            yards12,
            yards40,
        }
        self.destructionSpell = {
            -- Ability - Defensive
            emberTap                        = 114635,
            
            -- Ability - Offensive
            chaosBolt                       = 116858,
            conflagrate                     = 17962,
            darkSoulInstability             = 113858,
            fireandBrimstone                = 108683,
            flamesofXoroth                  = 120451,
            havoc                           = 80240,
            immolate                        = 348,
            incinerate                      = 29722,
            rainofFire                      = 104232,
            shadowburn                      = 17877,


            -- Buff - Defensive
            
            -- Buff - Offensive
            darkSoulInstabilityBuff         = 113858,
            fireandBrimstoneBuff            = 108683,
            
            -- Buff - Stacks
            
            -- Debuff - Offensive
            immolateDebuff                  = 348,

            -- Glyphs
            
            -- Perks

            -- Talent
        }
        -- Merge all spell tables into self.spell
        self.spell = {}
        self.spell = mergeSpellTables(self.spell, self.characterSpell, self.warlockSpell, self.destructionSpell)

        ------------------
        --- OOC UPDATE ---
        ------------------

        function self.updateOOC()
            -- Call classUpdateOOC()
            self.classUpdateOOC()

            self.getGlyphs()
            self.getPerks()
            self.getTalents()
        end

        --------------
        --- UPDATE ---
        --------------

        function self.update()
            -- Call Base and Class update
            self.classUpdate()
            -- Updates OOC things
            if not UnitAffectingCombat("player") then self.updateOOC() end

            self.getBuffs()
            self.getBuffsDuration()
            self.getBuffsRemain()
            self.getCharges()
            self.getDynamicUnits()
            self.getDebuffs()
            self.getDebuffsDuration()
            self.getDebuffsRemain()
            self.getCooldowns()
            self.getEnemies()
            self.getRotation()


            -- Casting and GCD check
            -- TODO: -> does not use off-GCD stuff like pots, dp etc
            if castingUnit() then
                return
            end


            -- Start selected rotation
            self:startRotation()
        end

        -------------
        --- BUFFS ---
        -------------
        function self.getBuffs()
            local UnitBuffID = UnitBuffID

            self.buff.darkSoulInstability       = UnitBuffID("player",self.spell.darkSoulInstabilityBuff)~=nil or false
            self.buff.fireandBrimstone          = UnitBuffID("player",self.spell.fireandBrimstoneBuff)~=nil or false
        end

        function self.getBuffsDuration()
            local getBuffDuration = getBuffDuration

            self.buff.duration.darkSoulInstability = getBuffDuration("player",self.spell.darkSoulInstabilityBuff) or 0
            self.buff.duration.fireandBrimstone    = getBuffDuration("player",self.spell.fireandBrimstoneBuff) or 0
        end

        function self.getBuffsRemain()
            local getBuffRemain = getBuffRemain

            self.buff.remain.darkSoulInstability        = getBuffRemain("player",self.spell.darkSoulInstabilityBuff) or 0
            self.buff.remain.fireandBrimstone           = getBuffRemain("player",self.spell.fireandBrimstoneBuff) or 0
        end

        function self.getCharges()
            local getBuffStacks = getBuffStacks
            local getCharges = getCharges

            self.charges.conflagrate               = getCharges(self.spell.conflagrate) or 0
            self.charges.darkSoulInstability       = getCharges(self.spell.darkSoulInstability) or 0
        end

        ---------------
        --- DEBUFFS ---
        ---------------
        function self.getDebuffs()
            local UnitDebuffID = UnitDebuffID

            self.debuff.immolate = UnitDebuffID(self.units.dyn40,self.spell.immolateDebuff,"player")~=nil or false
        end

        function self.getDebuffsDuration()
            local getDebuffDuration = getDebuffDuration

            self.debuff.duration.immolate = getDebuffDuration(self.units.dyn40,self.spell.immolateDebuff,"player") or 0
        end

        function self.getDebuffsRemain()
            local getDebuffRemain = getDebuffRemain

            self.debuff.remain.immolate = getDebuffRemain(self.units.dyn40,self.spell.immolateDebuff,"player") or 0
        end
        -----------------
        --- COOLDOWNS ---
        -----------------

        function self.getCooldowns()
            local getSpellCD = getSpellCD

            self.cd.flamesofXoroth      = getSpellCD(self.spell.flamesofXoroth)
            self.cd.havoc               = getSpellCD(self.spell.havoc)
        end

        --------------
        --- GLYPHS ---
        --------------

        function self.getGlyphs()
            local hasGlyph = hasGlyph

        end

        ---------------
        --- TALENTS ---
        ---------------

        function self.getTalents()
            local getTalent = getTalent

        end

        -------------
        --- PERKS ---
        -------------

        function self.getPerks()
            local isKnown = isKnown

            -- self.perk.empoweredEnvenom          = isKnown(self.spell.empoweredEnvenom)
        end

        ---------------------
        --- DYNAMIC UNITS ---
        ---------------------

        function self.getDynamicUnits()
            local dynamicTarget = dynamicTarget

            -- Normal
            self.units.dyn8     = dynamicTarget(8, true)
            self.units.dyn15    = dynamicTarget(15, true)
            self.units.dyn20    = dynamicTarget(20, true)

            -- AoE
            self.units.dyn8AoE  = dynamicTarget(8,false)
            self.units.dyn20AoE = dynamicTarget(20,false)
        end

        ---------------
        --- ENEMIES ---
        ---------------

        function self.getEnemies()
            local getEnemies = getEnemies

            self.enemies.yards5     = #getEnemies("player", 5)
            self.enemies.yards8     = #getEnemies("player", 8)
            self.enemies.yards12    = #getEnemies("player", 12)
            self.enemies.yards40    = #getEnemies("player", 40)
        end

        ----------------------
        --- START ROTATION ---
        ----------------------

        function self.startRotation()
            if self.rotation == 1 then
                self:DestructionKuu()
                --elseif self.rotation == 2 then
                --    self:WindwalkerDef()
                --elseif self.rotation == 3 then
                --    self:WindwalkerOld()
            else
                ChatOverlay("No ROTATION ?!", 2000)
            end
        end

        
        --------------
        --- SPELLS ---
        --------------
            
        -- Ember Tap
        function self.castEmberTap()
            if self.ember.count>=1 then
                if castSpell("player",self.spell.emberTap,false,false,false) then return end
            end
        end
        -- Chaos Bolt
        function self.castChaosBolt(thisUnit)
            if self.ember.count >= 1 and getDistance(thisUnit) < 40 then
                if castSpell(thisUnit,self.spell.chaosBolt,true,false,false) then return end
            end
        end
        -- Conflagrate
        function self.castConflagrate(thisUnit)
            if self.charges.conflagrate >=1 and getDistance(thisUnit)< 40 then
                if castSpell(thisUnit,self.spell.conflagrate,true,false,false) then return end
            end
        end
        -- Dark Soul: Instability
        function self.castDarkSoulInstability()
            if self.charges.darkSoulInstability >= 1 then
                if castSpell("player",self.spell.darkSoulInstability,false,false,false) then return end
            end
        end
        --Fire and Brimstone
        function self.castFireandBrimstone()
            if castSpell("player",self.spell.fireandBrimstone,false,false,false) then return end
        end
        -- Flames of Xoroth
        function self.castFlamesofXoroth()
            if not UnitExists("pet") and not self.buff.grimoireofSacrifice and self.ember.count >= 1 and self.cd.flamesofXoroth then
                if castSpell("player",self.spell.flamesofXoroth,false,false,false) then return end
            end
        end
        -- Havoc
        function self.castHavoc(thisUnit)
            if self.cd.havoc and getDistance(thisUnit)< 40 then
                if castSpell(thisUnit,self.spell.havoc,true,false,false) then return end
            end
        end
        --Immolate
        function self.castImmolate(thisUnit)
            if getDistance(thisUnit)< 40 then
                if castSpell(thisUnit,self.spell.immolate,true,false,false) then return end
            end
        end
        -- Incinerate
        function self.castIncinerate(thisUnit)
            if getDistance(thisUnit)< 40 then
                if castSpell(thisUnit,self.spell.incinerate,false,false,false) then return end
            end
        end
        -- Rain of Fire
        function self.castRainofFire()
            if getDistance(self.units.dyn40)< 35 then
                if castGoundAtBestLocation(self.spell.rainofFire, 8, 3, 35, 5) then return end
            end
        end
        -- Shadowburn
        function self.castShadowburn(thisUnit)
            if self.ember.count >= 1 and getDistance(thisUnit) < 40 then
                if castSpell(thisUnit,self.spell.shadowburn,true,false,false) then return end
            end
        end

        -- Return
        return self
    end-- cDestruction
end-- select Warlock