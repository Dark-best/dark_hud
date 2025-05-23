include("sh_config.lua") -- Assure-toi que HUD_IMAGES et HUD_COLORS sont bien définis ici

-- Création d'une police
surface.CreateFont("HUD_Font", {
    font = "Arial",
    extended = false,
    size = 25,
    weight = 500,
})

-- Chargement des matériaux
local heartImage = Material(HUD_IMAGES.heart)
local giletImage = Material(HUD_IMAGES.armor)
local foodImage  = Material(HUD_IMAGES.food)



-- Fonction : Dessiner un arc circulaire (cercle partiel)
local function DrawArc(x, y, radius, thickness, startAng, endAng, color)
    surface.SetDrawColor(color)

    local segments = 100
    local step = (endAng - startAng) / segments

    for i = 0, segments - 1 do
        local angle = math.rad(startAng + i * step)
        local nextAngle = math.rad(startAng + (i + 1) * step)

        local cx1 = math.cos(angle) * radius + x
        local cy1 = math.sin(angle) * radius + y
        local cx2 = math.cos(nextAngle) * radius + x
        local cy2 = math.sin(nextAngle) * radius + y

        local ix1 = math.cos(angle) * (radius - thickness) + x
        local iy1 = math.sin(angle) * (radius - thickness) + y
        local ix2 = math.cos(nextAngle) * (radius - thickness) + x
        local iy2 = math.sin(nextAngle) * (radius - thickness) + y

        surface.DrawPoly({
            {x = cx1, y = cy1},
            {x = cx2, y = cy2},
            {x = ix2, y = iy2},
            {x = ix1, y = iy1}
        })
    end
end

-- Fonction : Dessiner un cercle de statistique avec fond noir et icône
local function DrawCircleStat(x, y, percent, color, icon)
    local radius = 40
    local thickness = 20
    local startAngle = 270
    local endAngle = startAngle + (percent * 360)

    -- Fond noir (100%)
    DrawArc(x, y, radius, thickness, startAngle, startAngle + 360, Color(0, 0, 0, 200))

    -- Arc de valeur
    DrawArc(x, y, radius, thickness, startAngle, endAngle, color)

    -- Icône au centre
    surface.SetMaterial(icon)
    surface.SetDrawColor(255, 255, 255)
    surface.DrawTexturedRect(x - 16, y - 16, 32, 32)
end


-- Hook : Dessin du HUD
hook.Add("HUDPaint", "CustomHUD", function()
    local ply = LocalPlayer()
    if not IsValid(ply) then return end

    -- Données du joueur
    local health = math.Clamp(ply:Health(), 0, 100)
    local armor  = math.Clamp(ply:Armor(), 0, 150)
    local hunger = math.Clamp(ply:getDarkRPVar("Energy") or 0, 0, 100)

    local money  = ply:getDarkRPVar("money")
    local salary = ply:getDarkRPVar("salary")
    local job    = ply:getDarkRPVar("job")
    local name   = ply:getDarkRPVar("rpname")
    print(armor)

    -- Fond général
    draw.RoundedBox(25, 10, ScrH() - 260, 375, 250, HUD_COLORS.background)

    -- Infos texte
    draw.SimpleText("Nom : " .. name,   "HUD_Font", 28, ScrH() - 245, HUD_COLORS.text)
    draw.SimpleText("Métier : " .. job, "HUD_Font", 28, ScrH() - 212.5, HUD_COLORS.text)
    draw.SimpleText("Salaire : " .. salary .. "€", "HUD_Font", 28, ScrH() - 182.75, HUD_COLORS.text)
    draw.SimpleText("Argent : " .. money .. "€",   "HUD_Font", 28, ScrH() - 150, HUD_COLORS.text)

    -- Cercles de stats
    local baseX = 75
    local baseY = ScrH() - 67.5
    local spacing = 100
    

    DrawCircleStat(baseX, baseY, armor / 150, HUD_COLORS.health, heartImage)
    DrawCircleStat(baseX + spacing, baseY, armor / 100, HUD_COLORS.armor, giletImage)
    DrawCircleStat(baseX + spacing * 2, baseY, hunger / 100, HUD_COLORS.hunger, foodImage)
end)

-- Masquer les éléments HUD par défaut
local elementsToHide = {
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true,
    ["DarkRP_HUD"] = true,
    ["DarkRP_EntityDisplay"] = true,
    ["DarkRP_LocalPlayerHUD"] = true,
    ["DarkRP_Hungermod"] = true,
    ["DarkRP_Agenda"] = true,
    ["DarkRP_LockdownHUD"] = true,
    ["DarkRP_ArrestedHUD"] = true,
    ["DarkRP_ChatReceivers"] = true,
}

hook.Add("HUDShouldDraw", "HideDefaultHUD", function(name)
    if elementsToHide[name] then return false end
end)
