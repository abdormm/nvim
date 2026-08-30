local M = {}

M.status = function()
    local percentage, is_plugged
    local percentage_file = io.open("/sys/class/power_supply/BAT0/capacity")
    if percentage_file then
        percentage = percentage_file:read("*l")
        percentage_file:close()
    end
    local is_plugged_file = io.open("/sys/class/power_supply/AC0/online")
    if is_plugged_file then
        is_plugged = is_plugged_file:read("*l") == "1"
        is_plugged_file:close()
    end
    return tonumber(percentage), is_plugged
end

return M
