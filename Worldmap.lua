
-- Worldmap.lua: worldmap vendor plotting code
-- $Id: Worldmap.lua 1031 2008-03-27 05:41:46Z jnmiller $

-- Initializes the state of the worldmap overlays and settings.
function RecipeRadar_Worldmap_Init()

   for i = 1, RECIPERADAR_MAPPED_VENDORS_MAX do
      getglobal("RecipeRadarWorldmapIcon" .. i):Hide()
   end
   
end

-- Pins hang from an overlay on WorldMapButton, which inherits the scale of
-- the map. Parented to WorldMapFrame and anchored to WorldMapDetailFrame, the
-- pixel offset is not scaled with the map, so zoom addons (Magnify) displace it.
local function GetOverlay()

   if (not RecipeRadarWorldmapOverlay) then
      local overlay = CreateFrame("Frame", "RecipeRadarWorldmapOverlay",
            WorldMapButton)
      overlay:SetAllPoints(WorldMapButton)
   end
   return RecipeRadarWorldmapOverlay

end

-- Map the given icon to the given vendor.
function RecipeRadar_Worldmap_AddVendor(id, vendor, region, continent)

   local button = getglobal("RecipeRadarWorldmapIcon" .. id)
   local overlay = GetOverlay()
   if (button:GetParent() ~= overlay) then
      button:SetParent(overlay)
      button:SetFrameLevel(overlay:GetFrameLevel() + 2)
   end
   button.Vendor = vendor
   button.Continent = continent
   button.RegionID = RecipeRadar_RegionNameToID(region, continent)
   button.IsMapped = true

   RecipeRadar_Worldmap_UpdateButton(button)
   
end

-- Resets and unmaps the given icon.
function RecipeRadar_Worldmap_RemoveVendor(id)

   local button = getglobal("RecipeRadarWorldmapIcon" .. id)
   button.Vendor = nil
   button.RegionID = nil
   button.Continent = nil
   button.IsMapped = false
   button:Hide()

end

-- Draw the supplied button on the world map.
function RecipeRadar_Worldmap_UpdateButton(button)

   local Astrolabe = DongleStub("Astrolabe-0.4")
   Astrolabe:PlaceIconOnWorldMap(GetOverlay(),
         button, button.Continent, button.RegionID,
         button.Vendor.Coordinates[1].x, button.Vendor.Coordinates[1].y)

end

-- Redraw buttons on the current world map.
function RecipeRadar_Worldmap_UpdateButtons()

   for i = 1, RECIPERADAR_MAPPED_VENDORS_MAX do
      local button = getglobal("RecipeRadarWorldmapIcon" .. i)
      if (button.IsMapped) then
         RecipeRadar_Worldmap_UpdateButton(button)
      end
   end

end
