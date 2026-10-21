local ADDON_NAME, ns = ...
local L = ns.L

-- ==========================================
-- IMPORTAR GATHERMATE2_DATA
-- ==========================================
-- Solo si el jugador lo tiene instalado y lo pide (boton en Opciones o
-- /gr import), como en GatherMate2. GatherMate2_Data se carga bajo demanda y
-- deja sus nodos en globales (GatherMateData2HerbDB...) con el mismo formato
-- que nuestra base de datos. Solo se anaden los que faltan: lo que ya tienes no
-- se toca y lo que cae cerca de un nodo tuyo se descarta.
--
-- GatherMate2_Data depende de GatherMate2: sin el, el juego no lo carga. Si
-- GatherMate2 ya lo importo y borro esas globales, se leen sus propias bases
-- (GatherMate2HerbDB...), que tienen el mismo formato.

local DATA_ADDON = "GatherMate2_Data"
local GM2_DBS = { herb = "GatherMate2HerbDB", ore = "GatherMate2MineDB", treasure = "GatherMate2TreasureDB", fish = "GatherMate2FishDB" }

local function Known(kind)
    return function(id) return ns.NODES[id] ~= nil and ns.NODES[id].kind == kind end
end

function ns.ImportGatherMate()
    local loaded, reason = C_AddOns.LoadAddOn(DATA_ADDON)
    local found = false
    local lines = {}
    for _, kind in ipairs(ns.KIND_ORDER) do
        local source = loaded and _G[ns.KINDS[kind].gm2] or _G[GM2_DBS[kind]]
        if ns.db.kinds[kind] and type(source) == "table" then
            found = true
            local added = ns.ImportKind(kind, source, Known(kind))
            table.insert(lines, L["KIND_" .. kind:upper()] .. ": " .. added)
        end
    end
    if not found then
        local why = reason and _G["ADDON_" .. reason] or reason or "?"
        print(ns.PREFIX .. L.IMPORT_FAILED:format(why))
        return
    end
    print(ns.PREFIX .. L.IMPORT_DONE .. " " .. table.concat(lines, ", "))
end
