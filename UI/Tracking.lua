local ADDON_NAME, ns = ...
local L = ns.L

-- ==========================================
-- AVISO DE RASTREO
-- ==========================================
-- Sin Buscar hierbas / Buscar minerales los aros del minimapa salen vacios.
-- Al entrar o al revivir, si conoces uno de esos rastreos y no hay ninguno de
-- recoleccion activo, avisa en el chat. Mientras falte, un boton lo vuelve a
-- lanzar con un clic (el ultimo que tuviste). Un addon no puede lanzarlo solo:
-- es un hechizo y eso pide el clic del jugador (boton seguro).
-- El boton se mueve arrastrando con la posicion desbloqueada (opciones);
-- desbloqueado se ve siempre, para colocarlo.

local SIZE = 36
local button, pendingAlert, pendingUpdate

local function SpellName(id)
    if C_Spell and C_Spell.GetSpellName then return C_Spell.GetSpellName(id) end
    return (GetSpellInfo(id))
end

local function SpellIcon(id)
    if C_Spell and C_Spell.GetSpellTexture then return C_Spell.GetSpellTexture(id) end
    return GetSpellTexture(id)
end

-- Nombres de los rastreos activos del minimapa; nil si son secretos
local function ActiveTracking()
    local active = {}
    local count = C_Minimap and C_Minimap.GetNumTrackingTypes and C_Minimap.GetNumTrackingTypes() or 0
    for i = 1, count do
        local name, _, on = C_Minimap.GetTrackingInfo(i)
        if type(name) == "table" then name, on = name.name, name.active end
        if issecretvalue(name) or issecretvalue(on) then return nil end
        if on and name then active[name] = true end
    end
    return active
end

-- Rastreo que lanza el boton (o nil si no conoces ninguno de recoleccion) y
-- si falta. Si no se puede saber, no falta: mejor callar que avisar de mas.
local function State()
    local active = ActiveTracking()
    if not active then return nil, false end
    local need, first
    for _, kind in ipairs(ns.KIND_ORDER) do
        local id = ns.KINDS[kind].finder
        if IsPlayerSpell(id) then
            local on = active[SpellName(id)]
                or (C_UnitAuras and C_UnitAuras.GetPlayerAuraBySpellID and C_UnitAuras.GetPlayerAuraBySpellID(id))
            if on then
                ns.db.lastFinder = id
                return id, false
            end
            -- Tesoros (racial de enano) vale como activo, pero no hace falta tenerlo
            if ns.KINDS[kind].skill then
                need = true
                first = first or id
            end
        end
    end
    if not need then return nil, false end
    local last = ns.db.lastFinder
    return (last and IsPlayerSpell(last)) and last or first, true
end

local function SavePosition()
    button:StopMovingOrSizing()
    local pos = ns.db.trackingPos
    local point, _, relPoint, x, y = button:GetPoint()
    pos.point, pos.relPoint, pos.x, pos.y = point, relPoint, x, y
end

local function CreateButton()
    button = CreateFrame("Button", "GatherRadarTrackingButton", UIParent, "SecureActionButtonTemplate")
    button:SetSize(SIZE, SIZE)
    local pos = ns.db.trackingPos
    button:SetPoint(pos.point or "TOPRIGHT", UIParent, pos.relPoint or "TOPRIGHT", pos.x or -230, pos.y or -60)
    button:SetClampedToScreen(true)
    button:SetMovable(true)
    button:RegisterForClicks("AnyUp", "AnyDown") -- el boton seguro filtra segun ActionButtonUseKeyDown
    button:SetAttribute("type", "spell")
    button:SetScript("OnDragStart", button.StartMoving)
    button:SetScript("OnDragStop", SavePosition)

    button.icon = button:CreateTexture(nil, "ARTWORK")
    button.icon:SetAllPoints()
    button.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
    button:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")

    button.glow = button:CreateTexture(nil, "BACKGROUND")
    button.glow:SetTexture("Interface\\Cooldown\\star4")
    button.glow:SetBlendMode("ADD")
    button.glow:SetPoint("CENTER")
    button.glow:SetSize(SIZE * 2, SIZE * 2)
    button.glow:SetVertexColor(0.84, 0.59, 1)

    button.label = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    button.label:SetPoint("TOP", button, "BOTTOM", 0, -3)

    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
        GameTooltip:AddLine("|cffd597ffGatherRadar|r")
        GameTooltip:AddLine(ns.db.trackingLocked and L.TRACKING_BUTTON_TOOLTIP or L.TRACKING_DRAG_TOOLTIP, 1, 1, 1, true)
        GameTooltip:Show()
    end)
    button:SetScript("OnLeave", function() GameTooltip:Hide() end)
end

-- Boton seguro: en combate no se puede mostrar, ocultar ni cambiar; se hace al salir
local function UpdateButton(id, missing)
    if InCombatLockdown() then
        pendingUpdate = true
        return
    end
    pendingUpdate = false
    local unlocked = not ns.db.trackingLocked
    local dead = UnitIsDeadOrGhost("player")
    local show = ns.db.trackingButton and (unlocked or (missing and not dead))
    if not show then
        if button then button:Hide() end
        return
    end
    if not button then CreateButton() end
    id = id or ns.KINDS.herb.finder
    button:SetAttribute("spell", id)
    button.icon:SetTexture(SpellIcon(id))
    button.label:SetText(unlocked and L.TRACKING_DRAG or SpellName(id))
    button.glow:SetShown(missing)
    if unlocked then button:RegisterForDrag("LeftButton") else button:RegisterForDrag() end
    button:Show()
end

local function Check()
    if not ns.db then return end
    local id, missing = State()
    local alive = not UnitIsDeadOrGhost("player")
    if pendingAlert and alive then
        pendingAlert = false
        if missing and ns.db.trackingAlert then
            local text = L.TRACKING_OFF:format(SpellName(id))
            print(ns.PREFIX .. text)
            UIErrorsFrame:AddMessage(text, 1, 0.82, 0)
        end
    end
    UpdateButton(id, missing)
end

-- El rastreo tarda un poco en estar listo al entrar o revivir
local function CheckSoon() C_Timer.After(1, Check) end

function ns.UpdateTracking()
    if not ns.db then return end
    if InCombatLockdown() then
        pendingUpdate = true
        return
    end
    Check()
end

function ns.SetupTracking()
    local frame = CreateFrame("Frame")
    frame:RegisterEvent("PLAYER_ENTERING_WORLD")
    frame:RegisterEvent("PLAYER_ALIVE")
    frame:RegisterEvent("PLAYER_UNGHOST")
    frame:RegisterEvent("PLAYER_DEAD")
    frame:RegisterEvent("MINIMAP_UPDATE_TRACKING")
    frame:RegisterEvent("PLAYER_REGEN_ENABLED")
    frame:SetScript("OnEvent", function(_, event, isLogin, isReload)
        if event == "PLAYER_REGEN_ENABLED" then
            if pendingUpdate then Check() end
        elseif event == "PLAYER_ALIVE" or event == "PLAYER_UNGHOST"
            or (event == "PLAYER_ENTERING_WORLD" and (isLogin or isReload)) then -- no en cada pantalla de carga
            pendingAlert = true
            CheckSoon()
        else
            CheckSoon()
        end
    end)
end
