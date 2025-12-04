local mod = dmhub.GetModLoading()

local FRANK_DEBUG_BG = false
local FRANK_NAME = "Build A Monster!"

Frankenstein = RegisterGameType("Frankenstein")
Frankenstein.bands = {}
Frankenstein.levels = { min = 1, max = 10 }
Frankenstein.organizations = {"Minion", "Horde", "Platoon", "Elite", "Leader", "Solo"}
Frankenstein.roles = {"Ambusher", "Artillery", "Brute", "Controller", "Defender", "Harrier", "Hexer", "Mount", "Support"}

function Frankenstein._listToDropdownList(list)
    local dropdownList = {}
    for _,item in ipairs(list) do
        dropdownList[#dropdownList + 1] = { id = item, text = item }
    end
    return dropdownList
end

function Frankenstein._loadBands()
    if not Frankenstein.bands then Frankenstein.bands = {} end
    if #Frankenstein.bands == 0 then
        for k,item in pairs(dmhub.GetTableVisible(MonsterGroup.tableName)) do
            Frankenstein.bands[#Frankenstein.bands+1] = { id = k, text = item.name }
        end
        table.sort(Frankenstein.bands, function(a,b) return a.text < b.text end)
    end
    return Frankenstein.bands
end

function Frankenstein.DialogStyles()
    return {
        {
            selectors = {"frank-base"},
            fontSize = 14,
            fontFace = "Berling",
            color = Styles.textColor,
            height = 24,
        },

        -- Main Dialog
        {
            selectors = {"frank-dlg", "frank-base"},
            halign = "center",
            valign = "center",
            flow = "vertical",
            pad = 8,
            cornerRadius = 6,
            bgimage = true,
            bgcolor = "#111111ff",
            borderColor = Styles.textColor,
            borderWidth = 2,
            border = 1,
        },

        -- Panels
        {
            selectors = {"frank-panel", "frank-base"},
            width = "98%",
            height = "auto",
            halign = "center",
            valign = "top",
            margin = 2,
            pad = 2,
            flow = "horizontal",
            bgimage = FRANK_DEBUG_BG,
            borderWidth = 1,
            border = FRANK_DEBUG_BG and 1 or 0,
        },
        {
            selectors = {"border-panel", "frank-panel", "frank-base"},
            bgimage = true,
            borderColor = Styles.textColor,
            borderWidth = 1,
            cornerRadius = 4,
        },

        -- Controls
        {
            selectors = {"frank-label", "frank-base"},
            bold = true,
            halign = "left",
            textAlignment = "left",
            cornerRadius = 2,
        },
        {
            selectors = {"frank-control", "frank-base"},
            height = 30,
            bold = false,
            bgimage = true,
            bgcolor = Styles.backgroundColor,
            cornerRadius = 2,
            borderColor = Styles.textColor,
            borderWidth = 1,
        },
    }
end

function Frankenstein.CreatePanel()
    local dialog

    local header = gui.Panel{
        classes = {"frank-panel", "frank-base"},
        width = "80%",
        height = "auto",
        halign = "center",
        flow = "vertical",
        borderColor = "red",
        gui.Label{
            classes = {"frank-label", "frank-base"},
            text = FRANK_NAME,
            width = "100%",
            height = 30,
            fontSize = 24,
            textAlignment = "center",
            halign = "center",
            valign = "top"
        },
        gui.Divider{
            width = "100%",
            layout = "dot",
            height = 12,
        },
    }

    local nameField = gui.Panel {
        classes = {"frank-panel", "frank-base"},
        width = "60%",
        halign = "left",
        flow = "vertical",
        gui.Label{
            classes = {"frank-label", "frank-base"},
            text = "Name:",
            valign = "top",
        },
        gui.Input{
            classes = {"frank-control", "frank-base"},
            width = "90%",
            height = 24,
            editlag = 0.5,
            change = function(element)
            end,
            edit = function(element)
                element:FireEvent("change")
            end,
        }
    }

    local bandField = gui.Panel{
        classes = {"frank-panel", "frank-base"},
        width = "40%",
        halign = "left",
        flow = "vertical",
        gui.Label{
            classes = {"frank-label", "frank-base"},
            text = "Band:",
            valign = "top",
        },
        gui.Dropdown{
            classes = {"frank-control", "frank-base"},
            width = "90%",
            valign = "bottom",
            hasSearch = true,
            options = Frankenstein._loadBands(),
            idChosen = Frankenstein.bands[1].id,
            data = {
                band = Frankenstein.bands[1].id,
            },
            change = function(element)
                element.data.band = element.idChosen
            end
        },
    }

    local nameBandPanel = gui.Panel{
        classes = {"frank-panel", "frank-base"},
        width = "100%",
        valign = "top",
        flow = "horizontal",
        nameField,
        bandField,
    }

    local levelField = gui.Panel{
        classes = {"frank-panel", "frank-base"},
        width = "33%",
        halign = "left",
        flow = "vertical",
        gui.Label{
            classes = {"frank-label", "frank-base"},
            text = "Level:",
            valign = "top",
        },
        gui.Label{
            id = "levelInput",
            classes = {"frank-control", "frank-base"},
            width = "90%",
            text = Frankenstein.levels.min,
            textAlignment = "center",
            numeric = true,
            editable = true,
            characterLimit = 2,
            swallowPress = true,
            change = function(element)
                local prevValue = element.text
                local value = tonumber(prevValue) or 0
                if value < Frankenstein.levels.min then value = Frankenstein.levels.min end
                if value > Frankenstein.levels.max then value = Frankenstein.levels.max end
                element.text = tostring(value)
            end
        }
    }

    local organizationField = gui.Panel{
        classes = {"frank-panel", "frank-base"},
        width = "33%",
        halign = "left",
        flow = "vertical",
        gui.Label{
            classes = {"frank-label", "frank-base"},
            text = "Organization:",
            valign = "top",
        },
        gui.Dropdown{
            classes = {"frank-control", "frank-base"},
            width = "90%",
            valign = "bottom",
            options = Frankenstein._listToDropdownList(Frankenstein.organizations),
            idChosen = Frankenstein.organizations[1],
            data = {
                organization = Frankenstein.organizations[1],
            },
            change = function(element)
                element.data.organization = element.idChosen
            end
        },
    }

    local roleField = gui.Panel{
        classes = {"frank-panel", "frank-base"},
        width = "33%",
        halign = "left",
        flow = "vertical",
        gui.Label{
            classes = {"frank-label", "frank-base"},
            text = "Role:",
            valign = "top",
        },
        gui.Dropdown{
            classes = {"frank-control", "frank-base"},
            width = "90%",
            valign = "bottom",
            options = Frankenstein._listToDropdownList(Frankenstein.roles),
            idChosen = Frankenstein.roles[1],
            data = {
                role = Frankenstein.roles[1],
            },
            change = function(element)
                element.data.role = element.idChosen
            end
        },
    }
    
    local levelOrgRolePanel = gui.Panel{
        classes = {"frank-panel", "frank-base"},
        width = "100%",
        valign = "top",
        flow = "horizontal",
        levelField,
        organizationField,
        roleField,
    }

    local step1 = gui.Panel{
        classes = {"step1", "frank-panel", "frank-base"},
        height = "auto",
        flow = "vertical",
        nameBandPanel,
        levelOrgRolePanel,
    }

    dialog = gui.Panel{
        styles = Frankenstein.DialogStyles(),
        classes = {"frank-dlg", "frank-base"},
        width = 600,
        height = 800,

        header,
        step1,
        gui.MCDMDivider { width = "80%", layout = "vdot" }
    }

    return dialog
end

LaunchablePanel.Register{
    name = FRANK_NAME,
    menu = "tools",
    icon = "icons/standard/Icon_App_Bestiary.png",
    halign = "center",
    valign = "center",
    content = function()
        return Frankenstein.CreatePanel()
    end
}