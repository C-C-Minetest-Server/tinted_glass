-- tinted_glass/init.lua
-- Colored glass
--[[
    Copyright (c) 2018-2020  Och Noe
    Copyright (c) 2024  1F616EMO

    This software is provided 'as-is', without any express or implied
    warranty. In no event will the authors be held liable for any damages
    arising from the use of this software.

    Permission is granted to anyone to use this software for any purpose,
    including commercial applications, and to alter it and redistribute it
    freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not
    claim that you wrote the original software. If you use this software
    in a product, an acknowledgment in the product documentation would be
    appreciated but is not required.
    2. Altered source versions must be plainly marked as such, and must not be
    misrepresented as being the original software.
    3. This notice may not be removed or altered from any source distribution.
]]

local S = minetest.get_translator("tinted_glass")
local MP_advtrains_doors = minetest.get_modpath("advtrains_doors")
local lifo_compact = minetest.settings:get_bool("tinted_glass.lifo_compact", false)

local glasses = {
    blue = {
        name = S("Blue"),
    },
    cyan = {
        name = S("Cyan"),
    },
    green = {
        name = S("Green"),
    },
    grey = {
        name = S("Grey"),
    },
    red = {
        name = S("Red"),
    },
    magenta = {
        name = S("Magenta"),
    },
    white = {
        name = S("White"),
    },
    yellow = {
        name = S("Yellow"),
    },
    brown = {
        name = S("Brown"),
    },
    dark_green = {
        name = S("Dark Green"),
    },
    dark_grey = {
        name = S("Dark Grey"),
    },
    orange = {
        name = S("Orange"),
    },
    pink = {
        name = S("Pink"),
    },
    violet = {
        name = S("Violet"),
    },
    -- tinted glass from dyes + black
    dark_magenta = {
        name = S("Dark Magenta"),
        dark = true,
        dye  = "magenta",
    },
    dark_orange = {
        name = S("Dark Orange"),
        dark = true,
        dye  = "orange",
    },
    dark_pink = {
        name = S("Dark Pnk"),
        dark = true,
        dye  = "pink",
    },
    dark_red = {
        name = S("Dark Red"),
        dark = true,
        dye  = "red",
    },
    dark_violet = {
        name = S("Dark Violet"),
        dark = true,
        dye  = "violet",
    },
    dark_yellow = {
        name = S("Dark Yellow"),
        dark = true,
        dye  = "yellow",
    },
}

for name, def in pairs(glasses) do
    minetest.register_node("tinted_glass:glass_" .. name, {
        description = S("@1 Tinted Glass", def.name),
        tiles = { "tinted_glass_" .. name .. ".png^moreblocks_clean_glass.png" },
        drawtype = "glasslike_framed_optional",
        use_texture_alpha = "blend",

        paramtype = "light",
        sunlight_propagates = true,

        groups = { cracky = 3, oddly_breakable_by_hand = 3 },
        sounds = default.node_sound_glass_defaults(),
    })

    stairsplus:register_all("tinted_glass", "glass_" .. name, "tinted_glass:glass_" .. name, {
        description = S("@1 Tinted Glass", def.name),
        tiles = { "tinted_glass_" .. name .. ".png^moreblocks_clean_glass.png" },
        groups = { cracky = 3, oddly_breakable_by_hand = 3 },
        sounds = default.node_sound_glass_defaults(),
        paramtype = "light",
        sunlight_propagates = true,
        use_texture_alpha = "blend",
    })

    -- Alias to LIFO's moreblocks undo
    if lifo_compact then
        minetest.register_alias("moreblocks:" .. name .. "_tinted_glass", "tinted_glass:glass_" .. name)
        stairsplus:register_alias_all("moreblocks", name .. "_tinted_glass", "tinted_glass", "glass_" .. name)
    end

    if def.dark then
        minetest.register_craft({
            type = "shapeless",
            output = "tinted_glass:glass_" .. name .. " 7",
            recipe = {
                "default:glass", "default:glass", "default:glass",
                "default:glass", "dye:" .. (def.dye or name), "default:glass",
                "default:glass", "dye:black", "default:glass"
            }
        })
    else
        minetest.register_craft({
            type = "shapeless",
            output = "tinted_glass:glass_" .. name .. " 8",
            recipe = { "default:glass", "default:glass", "default:glass",
                "default:glass", "dye:" .. (def.dye or name), "default:glass",
                "default:glass", "default:glass", "default:glass"
            }
        })
    end

    -- Regitster platform screen doors if possible
    if MP_advtrains_doors then
        advtrains_doors.register_platform_gate("tinted_glass:glass_" .. name)
    end

    -- xpanes
    xpanes.register_pane("tinted_glass_" .. name, {
        description = S("@1 Tinted Glass Pane", def.name),
        textures = {
            "tinted_glass_" .. name .. ".png^moreblocks_clean_glass.png", "",
            "moreblocks_clean_glass.png^[verticalframe:16:0"
        },
        inventory_image = "tinted_glass_" .. name .. ".png^moreblocks_clean_glass.png",
        wield_image = "tinted_glass_" .. name .. ".png^moreblocks_clean_glass.png",
        sounds = default.node_sound_glass_defaults(),
        groups = { cracky = 3, oddly_breakable_by_hand = 3 },
        recipe = {
            { "tinted_glass:glass_" .. name, "tinted_glass:glass_" .. name, "tinted_glass:glass_" .. name },
            { "tinted_glass:glass_" .. name, "tinted_glass:glass_" .. name, "tinted_glass:glass_" .. name },
        },
        use_texture_alpha = true,
    })
end
