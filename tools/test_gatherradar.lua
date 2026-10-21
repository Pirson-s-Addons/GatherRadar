-- Carga el addon con la API de WoW simulada (todo global desconocido es un
-- objeto que acepta cualquier llamada), dispara ADDON_LOADED y prueba la base
-- de datos: duplicados, importar sin pisar, limpiar y lo que llega del grupo.
-- Se lanza desde la carpeta del addon con un Lua 5.1:  lua tools/test_gatherradar.lua [locale]
local function anything()
    return setmetatable({}, {
        __index = function() return anything() end,
        __call = function() return anything() end,
        __concat = function() return "x" end,
    })
end
local handlers = {}
CreateFrame = function()
    local f = anything()
    rawset(f, "SetScript", function(_, name, fn) if name == "OnEvent" then table.insert(handlers, fn) end end)
    return f
end
GetLocale = function() return arg and arg[1] or "esES" end
issecretvalue = function() return false end
wipe = function(t) for k in pairs(t) do t[k] = nil end return t end
GetTime = function() return 100 end
C_Timer = { After = function() end }
C_AddOns = { GetAddOnMetadata = function() return "1.00" end }
C_Map = { GetMapWorldSize = function() return 1000, 1000 end }
StaticPopupDialogs = {}
setmetatable(_G, { __index = function(_, k) if k:match("DB$") then return nil end return anything() end })

local ns = {}
for line in io.lines("GatherRadar_Camelot.toc") do
    if line:match("%.lua$") then
        local f = io.open(line)
        assert(f or line:match("^Locales/"), "falta " .. line)
        if f then f:close() assert(loadfile(line))("GatherRadar", ns) else print("aviso: falta " .. line) end
    end
end
for _, fn in ipairs(handlers) do fn(anything(), "ADDON_LOADED", "GatherRadar") end
assert(ns.db and ns.db.dedupe == 15, "db no inicializada")

-- Todas las claves L usadas existen
local required = {}
for line in io.lines("GatherRadar_Camelot.toc") do
    if line:match("^[CU].*%.lua$") then
        for key in io.open(line):read("*a"):gmatch("L%.([%u_]+)") do required[key] = true end
    end
end
for _, kind in ipairs(ns.KIND_ORDER) do required["KIND_" .. kind:upper()] = true end
for key in pairs(required) do assert(rawget(ns.L, key), "falta L." .. key) end
print("ok carga", GetLocale())

-- Coordenadas como GatherMate2
local c = ns.Encode(0.357, 0.284)
assert(c == 3570284000, c)
local x, y = ns.Decode(c)
assert(math.abs(x - 0.357) < 1e-9 and math.abs(y - 0.284) < 1e-9)

-- Duplicados (mapa de 1000 yardas: 0.01 = 10 yardas; radio 15)
ns.db.saveSeen = true
local c1, new1 = ns.AddNode("herb", 1, 0.50, 0.50, 401, "seen")
assert(new1)
local c2, new2 = ns.AddNode("herb", 1, 0.51, 0.50, 402, "seen") -- 10 yd: el mismo sitio
assert(c2 == c1 and not new2 and ns.db.nodes.herb[1][c1] == 402, "visto actualiza el id, no mueve")
local _, new3 = ns.AddNode("ore", 1, 0.51, 0.50, 201, "seen") -- otro tipo: no es duplicado
assert(new3)
local c4 = ns.AddNode("herb", 1, 0.505, 0.505, 401, "gathered") -- recogido: la posicion buena
assert(c4 == ns.Encode(0.505, 0.505) and ns.db.nodes.herb[1][c1] == nil, "recogido mueve el nodo")
ns.AddNode("herb", 1, 0.50, 0.50, 403, "shared")
assert(ns.db.nodes.herb[1][c4] == 401, "lo del grupo no pisa")

-- Vistos sin guardar: a ns.temp
ns.db.saveSeen = false
local _, newT, temp = ns.AddNode("herb", 1, 0.9, 0.9, 401, "seen")
assert(newT and temp and ns.temp.herb[1][ns.Encode(0.9, 0.9)] == 401 and not ns.db.nodes.herb[1][ns.Encode(0.9, 0.9)])
ns.db.saveSeen = true

-- Importar: solo lo que falta, sin duplicar entre si ni con lo tuyo, ids conocidos
local added = ns.ImportKind("herb", {
    [1] = {
        [ns.Encode(0.506, 0.506)] = 404, -- junto al recogido: fuera
        [ns.Encode(0.2, 0.2)] = 404, -- nuevo
        [ns.Encode(0.201, 0.2)] = 404, -- 1 yarda del anterior: fuera
        [ns.Encode(0.7, 0.7)] = 999, -- id desconocido: fuera
    },
    [2] = { [ns.Encode(0.3, 0.3)] = 401 },
}, function(id) return ns.NODES[id] ~= nil end)
assert(added == 2, "importados " .. added)
assert(ns.db.nodes.herb[1][c4] == 401, "importar no pisa")

-- Limpiar duplicados que ya hubiera (meter dos a mano juntos)
ns.db.nodes.herb[3] = { [ns.Encode(0.1, 0.1)] = 401, [ns.Encode(0.105, 0.1)] = 401, [ns.Encode(0.5, 0.5)] = 401 }
assert(ns.Cleanup() == 1, "limpiar")

-- Lo que llega del grupo se valida
assert(ns.ParseShared("h,1411,3570284000,401") == "herb")
assert(ns.ParseShared("o,1411,3570284000,401") == nil, "tipo que no cuadra")
assert(ns.ParseShared("h,1411,3570284001,401") == nil, "coordenada mal codificada")
assert(ns.ParseShared("h,1411,3570284000,99999") == nil, "id desconocido")
assert(ns.ParseShared("x;drop") == nil)

-- Nombres: ingles y aprendidos
assert(ns.IdByName("Copper Vein") == 201)
ns.LearnName(201, "Filón de cobre")
assert(ns.IdByName("filón de cobre") == 201 and ns.NodeName(201) == "Filón de cobre")
assert(ns.KindOf(ns.NewLearnedId("herb", "Raíz lunar", 123)) == "herb")
print("ok base de datos")
