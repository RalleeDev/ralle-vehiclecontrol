RegisterCommand('toggleEngine', function (source, args, rawCommand)
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

RegisterKeyMapping('toggleEngine', 'Toggle Engine', 'keyboard', 'y')