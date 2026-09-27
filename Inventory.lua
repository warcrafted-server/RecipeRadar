
-- Inventory.lua: tracks which recipe items the character is currently
-- carrying in bags or bank, so an unlearned-but-owned recipe isn't shown
-- as missing.

-- Bag scanning runs on every BAG_UPDATE, so it always reflects live bag
-- contents. The bank can only be read while its frame is open (no API
-- exists to peek at a closed bank in this client), so its slots are
-- scanned on BANKFRAME_OPENED/PLAYERBANKSLOTS_CHANGED and the result is
-- cached in the SavedVariable until the player opens the bank again.
--
-- Bags and bank are kept as separate sets (not merged into one) so that
-- selling a recipe from bags doesn't wipe out a copy still sitting in the
-- last-known bank contents, and vice versa.
local BAG_SLOTS = { 0, -1, 0, 1, 2, 3, 4 }
local BANK_SLOTS = { -1, 5, 6, 7, 8, 9, 10 }

function RecipeRadar_Inventory_Init()

   local db = RecipeRadar_SkillDB_GetSafePlayerDB()
   if (not db.BagRecipes) then db.BagRecipes = { } end
   if (not db.BankRecipes) then db.BankRecipes = { } end

   RecipeRadar_Inventory_ScanBags()

end

-- Scans the given list of container ids (bag or bank slots) and returns
-- a set of the recipe item IDs found.
function RecipeRadar_Inventory_ScanContainers(bag_ids)

   local recipes_by_id = RecipeRadar_GetRecipesByID()
   local found = { }

   for _, bag in pairs(bag_ids) do

      local slots = GetContainerNumSlots(bag)
      for slot = 1, slots do

         local item_id = GetContainerItemID(bag, slot)
         if (item_id and recipes_by_id[item_id]) then
            found[item_id] = true
         end

      end

   end

   return found

end

function RecipeRadar_Inventory_ScanBags()

   local db = RecipeRadar_SkillDB_GetSafePlayerDB()
   db.BagRecipes = RecipeRadar_Inventory_ScanContainers(BAG_SLOTS)

   RecipeRadar_FrameUpdate()

end

function RecipeRadar_Inventory_ScanBank()

   local db = RecipeRadar_SkillDB_GetSafePlayerDB()
   db.BankRecipes = RecipeRadar_Inventory_ScanContainers(BANK_SLOTS)

   RecipeRadar_FrameUpdate()

end

-- Boolean test for whether the given player already holds the recipe
-- item in bags or (last-known) bank contents.
function RecipeRadar_Inventory_HasRecipe(player, recipe)

   local db = RecipeRadar_SkillDB_GetSafePlayerDB(player)
   return (db.BagRecipes and db.BagRecipes[recipe.ID] == true) or
         (db.BankRecipes and db.BankRecipes[recipe.ID] == true)

end
