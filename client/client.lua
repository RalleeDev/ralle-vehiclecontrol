if Config.toggleEngine == true then
    RegisterCommand(Config.toggleEngineCommand, function (source, args, rawCommand)
        local playerPed = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        if vehicle > 0 then
            local EngineRunning = GetIsVehicleEngineRunning(vehicle)
            if EngineRunning == 1 then
                SetVehicleEngineOn(vehicle, false, false, true)
            else
                SetVehicleEngineOn(vehicle, true, false, true)
            end
        end
    end, false)

    Citizen.CreateThread(function ()
        while true do
            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if vehicle > 0 then
                local EngineRunning = GetIsVehicleEngineRunning(vehicle)
                if EngineRunning == false then
                    DisableControlAction(0, 71, true) -- Disable W (acceleration)
                    DisableControlAction(0, 72, true) -- Disable S (brake/reverse)
                    DisableControlAction(0, 63, true) -- Disable A (left)
                    DisableControlAction(0, 64, true) -- Disable D (right)
                end
            end
            Citizen.Wait(1)
        end
    end)

    RegisterKeyMapping(Config.toggleEngineCommand, 'Toggle Engine', 'keyboard', Config.toggleEngineKey)
end

if Config.Indicator == true then
    function Indicator(vehicle, indicator)
        local indicatorState = GetVehicleIndicatorLights(vehicle)
        print(indicatorState)
        if indicator == 1 then -- Left indicator
            if indicatorState == 1 then
                SetVehicleIndicatorLights(vehicle, indicator, false)
            else
                SetVehicleIndicatorLights(vehicle, indicator, true)
            end
        elseif indicator == 0 then -- Right Indicator
            if indicatorState == 2 then
                SetVehicleIndicatorLights(vehicle, indicator, false)
            else
                SetVehicleIndicatorLights(vehicle, indicator, true)
            end
        elseif indicator == 'hazard' then
            if indicatorState == 3 then
                SetVehicleIndicatorLights(vehicle, 1, false)
                SetVehicleIndicatorLights(vehicle, 0, false)
            else
                SetVehicleIndicatorLights(vehicle, 1, true)
                SetVehicleIndicatorLights(vehicle, 0, true)
            end
        end
    end

    RegisterCommand('indicator:left', function(source, args, rawCommand)
        local player = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(player, false)
        Indicator(vehicle, 1)
    end, false)

    RegisterCommand('indicator:right', function(source, args, rawCommand) -- Indicator right = 2
        local player = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(player, false)
        Indicator(vehicle, 0)
    end, false)

    RegisterCommand('indicator:hazard', function(source, args, rawCommand) -- Indicator Hazard = 3
        local player = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(player, false)
        Indicator(vehicle, 'hazard')
    end, false)

    -- Register Keymappings for Indicators
    RegisterKeyMapping('indicator:left', 'Left vehicle indicator', 'keyboard', 'F1')
    RegisterKeyMapping('indicator:right', 'Right vehicle indicator', 'keyboard', 'F3')
    RegisterKeyMapping('indicator:hazard', 'Hazard Vehicle indicator', 'keyboard', 'F4')
end

local CruiseControl = false

RegisterCommand(Config.CruiseControlCommand, function (source, args, rawCommand)
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player, false)
    if CruiseControl == false then
        print(CruiseControl)
        local CruiseControlSpeed = GetEntitySpeed(vehicle)
        SetEntityMaxSpeed(vehicle, CruiseControlSpeed)
        CruiseControl = true
    else
        local maxSpeed = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveMaxFlatVel')
        print(CruiseControl)
        SetEntityMaxSpeed(vehicle, maxSpeed)
        CruiseControl = false
    end
end, false)

RegisterKeyMapping(Config.CruiseControlCommand, 'Cruise Control Toggle', 'keyboard', Config.CruiseControlKey)