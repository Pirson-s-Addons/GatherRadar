local ADDON_NAME, ns = ...

-- ==========================================
-- LO QUE ESTA AHORA
-- ==========================================
-- Nodos que se sabe que estan ahi ahora: los que avisa el grupo
-- (Core/Comm.lua). En el minimapa salen con su icono; lo recordado, como un
-- aro hueco (UI/MinimapPins.lua). Al recogerlo deja de estar (Core/Collector.lua).
--
-- PENDIENTE (cuando la API lo permita): Blizzard ya no deja a los addons leer
-- el minimapa. C_TooltipInfo.GetMinimapMouseover da el nombre secreto con un
-- raton falso (Minimap:UpdateMouseoverAtPoint) y tambien con el raton de
-- verdad (probado en Forever, noviembre de 2026). Si vuelve a dar el nombre,
-- volver a la deteccion automatica: el escaner de rejilla de 75631cb
-- (Core/Scanner.lua, opciones "scan" y "saveSeen") y el minimapa con solo lo
-- detectado ahora (3827ebd, UI/MinimapPins.lua). La lectura al pasar el raton
-- esta en 749ec5f. ns.AddNode(..., "seen") sigue lista para eso.

local LIVE = 180 -- segundos que un nodo cuenta como "esta ahi ahora"

ns.live = {}

local function LiveKey(kind, map, coord) return kind .. map .. ":" .. coord end

function ns.IsLive(kind, map, coord)
    local t = ns.live[LiveKey(kind, map, coord)]
    return t and GetTime() - t < LIVE
end

function ns.MarkLive(kind, map, coord) ns.live[LiveKey(kind, map, coord)] = GetTime() end
function ns.ClearLive(kind, map, coord) ns.live[LiveKey(kind, map, coord)] = nil end
