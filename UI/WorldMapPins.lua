local ADDON_NAME, ns = ...
local L = ns.L

-- ==========================================
-- PINES DEL MAPA DEL MUNDO
-- ==========================================
-- Un proveedor de datos del mapa (MapCanvasDataProviderMixin), como en
-- DungeonQuestAtlas: todos los nodos guardados del mapa que estas viendo.
-- Mayus + clic derecho en un pin lo borra (un nodo mal puesto).
-- ponytail: en el mapa del continente no salen los nodos de sus zonas.

local TEMPLATE = "GatherRadarWorldMapPinTemplate"
local provider

local function CreatePinMixin()
    GatherRadarWorldMapPinMixin = CreateFromMixins(MapCanvasPinMixin)
    local mixin = GatherRadarWorldMapPinMixin

    function mixin:OnLoad()
        self:UseFrameLevelType("PIN_FRAME_LEVEL_AREA_POI")
        self:SetScalingLimits(1, 1.0, 1.2)
        ns.AddPinArt(self)
    end

    function mixin:OnAcquired(kind, map, coord, id)
        self.kind, self.map, self.coord, self.id = kind, map, coord, id
        ns.SetPinArt(self, id, ns.db.worldMapSize)
        self:SetPosition(ns.Decode(coord))
    end

    function mixin:OnMouseEnter()
        local x, y = ns.Decode(self.coord)
        ns.NodeTooltip(self, self.id, ("%.1f, %.1f"):format(x * 100, y * 100) .. "\n" .. L.PIN_DELETE)
    end

    function mixin:OnMouseLeave() GameTooltip:Hide() end

    function mixin:ShouldMouseButtonBePassthrough() return false end
    -- AcquirePin la llama siempre y en combate es protegida (ver DungeonQuestAtlas)
    mixin.SetPassThroughButtons = function() end

    function mixin:OnMouseClickAction(button)
        if button == "RightButton" and IsShiftKeyDown() then
            ns.RemoveNode(self.kind, self.map, self.coord)
        end
    end
end

local function CreateProvider()
    provider = CreateFromMixins(MapCanvasDataProviderMixin)

    function provider:RemoveAllData()
        self:GetMap():RemoveAllPinsByTemplate(TEMPLATE)
    end

    function provider:RefreshAllData()
        self:RemoveAllData()
        local map = self:GetMap():GetMapID()
        if not (map and ns.db.worldMap) then return end
        for _, kind in ipairs(ns.KIND_ORDER) do
            if ns.db.kinds[kind] then
                ns.EachNode(kind, map, function(coord, id)
                    self:GetMap():AcquirePin(TEMPLATE, kind, map, coord, id)
                end)
            end
        end
    end

    WorldMapFrame:AddDataProvider(provider)
end

function ns.RefreshWorldMap()
    if provider and provider:GetMap() and provider:GetMap():IsShown() then provider:RefreshAllData() end
end

-- El mapa del mundo puede cargarse despues que el addon
function ns.SetupWorldMapPins()
    local function Setup()
        CreatePinMixin()
        CreateProvider()
    end
    if WorldMapFrame and MapCanvasDataProviderMixin then
        Setup()
    elseif EventUtil and EventUtil.ContinueOnAddOnLoaded then
        EventUtil.ContinueOnAddOnLoaded("Blizzard_WorldMap", Setup)
    end
end
