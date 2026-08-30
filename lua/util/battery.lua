local M = {}

M.icons = {
    unplugged = {"󰁺","󰁻","󰁼","󰁽","󰁾","󰁿","󰂀","󰂁","󰂂","󰁹"},
    plugged = {"󰢜", "󰂆", "󰂇","󰂈","󰢝","󰂉","󰢞","󰂊","󰂋","󰂅"},
}

M.string = function ()
    local battery = require("platform").battery
    local percent, is_plugged = battery.status()
    local index = math.max(math.floor(percent / 10), 1)
    local icon = (is_plugged and M.icons.plugged or M.icons.unplugged)[index]
    return string.format("%d %s", percent, icon)
end

return M
