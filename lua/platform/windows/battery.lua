local M = {}

local ffi = require("ffi")

---@class platform.windows.SYSTEM_POWER_STATUS
---@field ACLineStatus integer
---@field BatteryFlag integer
---@field BatteryLifePercent integer
---@field SystemStatusFlag integer
---@field BatteryLifeTime integer
---@field BatteryFullLifeTime integer

ffi.cdef[[
    typedef struct {
        uint8_t ACLineStatus;
        uint8_t BatteryFlag;
        uint8_t BatteryLifePercent;
        uint8_t SystemStatusFlag;
        uint32_t BatteryLifeTime;
        uint32_t BatteryFullLifeTime;
    } SYSTEM_POWER_STATUS, *LPSYSTEM_POWER_STATUS;

    int GetSystemPowerStatus(LPSYSTEM_POWER_STATUS lpSystemPowerStatus);
]]

M.status = function()
    local status = ffi.new("SYSTEM_POWER_STATUS") --[[@as platform.windows.SYSTEM_POWER_STATUS]]
    ffi.C.GetSystemPowerStatus(status)
    return status.BatteryLifePercent, status.ACLineStatus == 1
end

return M
