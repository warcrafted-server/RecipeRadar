
-- Broker.lua: LibDataBroker feed, so plugin bars (Titan Panel, etc.) can
-- list Recipe Radar and toggle it like they do any other data source.

local LDB = LibStub and LibStub("LibDataBroker-1.1", true)

if (LDB) then

   LDB:NewDataObject("RecipeRadar", {
      type = "launcher",
      text = RRS("Recipe Radar"),
      icon = "Interface\\AddOns\\RecipeRadar\\Images\\Misc\\Scroll",
      OnClick = function()
         RecipeRadar_Toggle()
      end,
      OnTooltipShow = function(tooltip)
         tooltip:AddLine(RRS("Recipe Radar"))
         tooltip:AddLine(RRS("Click to toggle."), 1, 1, 1)
      end,
   })

end
