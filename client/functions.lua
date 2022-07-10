local Utils = exports.plouffe_lib:Get("Utils")

AddEventHandler("ooc_core:playerloaded", function()
    TriggerEvent('ooc_core:getCore', function(Core) 
        while not Core.Player:IsPlayerLoaded() do
            Wait(500)
        end
    
        CayoFnc:Start()
    end)
end)

function CayoFnc:Start()
	CayoFnc:Exports()
	CayoFnc:RegisterAllEvents()
	CayoFnc:StartMainThread()
	CayoFnc:InitCayo()
end

function CayoFnc:InitCayo()
    CayoFnc:SetOutOfRange()
end

function CayoFnc:RegisterAllEvents() 
    RegisterNetEvent('plouffe_cayo_perico_show_entrance_item', function(item)
        for k,v in pairs(Cayo.EntranceItems) do
            if item == v then
                for x,y in pairs(Cayo.EntranceZone) do
                    if exports.plouffe_lib:IsInZone(y) then
                        Utils:ProgressCircle({
                            name = "check_invitation",
                            duration = 5000,
                            label = "Vérification en cours",
                            useWhileDead = false,
                            canCancel = true,
                            controlDisables = {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true,
                            },
                            animation = {
                                animDict = "mp_common",
                                anim = "givetake1_b",
                            },
                        }, function(status)
                            if not status then
                                Cayo.Utils.allowedInCamp = true
                                Utils:Notify('inform', "Vous etes maintenant autorisé dans Cayo Perico", 5500)
                                -- TriggerServerEvent('plouffe_cayo_removeitem',item,1,Cayo.Utils.MyAuthKey)
                            end
                        end)
                        break   
                    end
                end
                break
            end
        end
    end)
    
    RegisterNetEvent('InCayoPericoCamp', function(params)
        Cayo.Utils.ped = PlayerPedId()
        Cayo.Utils.pedCoords = GetEntityCoords(Cayo.Utils.ped)
        -- CayoFnc:SpawnAllGuards()
        -- CayoFnc:StartInCayoZone()
    end)
    
    RegisterNetEvent('OutOfCayoPericoCamp', function(params)
        Cayo.Utils.ped = PlayerPedId()
        Cayo.Utils.pedCoords = GetEntityCoords(Cayo.Utils.ped)
        Cayo.Utils.inCamp = false
        CayoFnc:DeleteAllGuards()
    end)
    
    RegisterNetEvent('CayoPericoInZone', function(params)
        Cayo.Utils.ped = PlayerPedId()
        Cayo.Utils.pedCoords = GetEntityCoords(Cayo.Utils.ped)
        CayoFnc:CalculateNewDistance()
    end)
    
    RegisterNetEvent('InCayoPerico', function(params)
        Cayo.Utils.ped = PlayerPedId()
        Cayo.Utils.pedCoords = GetEntityCoords(Cayo.Utils.ped)
        -- CayoFnc:SpawnAllGuards()
    end)
    
    RegisterNetEvent('OutOfCayoPerico', function(params)
        Cayo.Utils.ped = PlayerPedId()
        Cayo.Utils.pedCoords = GetEntityCoords(Cayo.Utils.ped)
        Cayo.Utils.allowedInCamp = false
        -- CayoFnc:DeleteAllGuards()
    end)
    
    RegisterNetEvent('CayoPericoInMidRange', function(params)
        Cayo.Utils.ped = PlayerPedId()
        Cayo.Utils.pedCoords = GetEntityCoords(Cayo.Utils.ped)
        CayoFnc:CalculateNewDistance()
    end)
    
    RegisterNetEvent('CayoPericoInLongRange', function(params)
        Cayo.Utils.ped = PlayerPedId()
        Cayo.Utils.pedCoords = GetEntityCoords(Cayo.Utils.ped)
        CayoFnc:CalculateNewDistance()
    end)
    
    RegisterNetEvent('CayoPericoOutOfRange', function(params)
        Cayo.Utils.ped = PlayerPedId()
        Cayo.Utils.pedCoords = GetEntityCoords(Cayo.Utils.ped)
        CayoFnc:CalculateNewDistance()
    end)
    
    RegisterNetEvent('CayoPericoDeleteEntities',function(params)
        Cayo.Utils.ped = PlayerPedId()
        Cayo.Utils.pedCoords = GetEntityCoords(Cayo.Utils.ped)
        Cayo.Utils.inCamp = false
        Cayo.Utils.allowedInCamp = false
        CayoFnc:DeleteAllCampEntities()
        CayoFnc:DeleteAllGuards()
    end)
end

function CayoFnc:SetMidRange()
    SetScenarioGroupEnabled('Heist_Island_Peds', false)
    -- Citizen.InvokeNative(0x5E1460624D194A38, false) -- fuck la map
    Citizen.InvokeNative(0xF74B1FFA4A15FBEA, false)
    Citizen.InvokeNative(0x53797676AD34A9AA, true)
    SetAudioFlag('PlayerOnDLCHeist4Island', false)
    SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', false, false)
    SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', true, false)
    if Cayo.Utils.massiveLoad == true then
        Citizen.InvokeNative(0x9A9D1BA639675CF1, 'HeistIsland', false)
        Wait(100)
    end
    local index = "midRange"
    local this = Cayo.Ipls[index]
    this.isSet = true
    CayoFnc:LoadIplFromArray(this.list)
    CayoFnc:ResetOtherZone(index)
    Cayo.Utils.lastSet = index
    CayoFnc:StartBombsThread()
end

function CayoFnc:SetInZone()
    SetScenarioGroupEnabled('Heist_Island_Peds', true)
    SetDeepOceanScaler(0.0)
    -- Citizen.InvokeNative(0x5E1460624D194A38, true) -- fuck la map
    Citizen.InvokeNative(0x9A9D1BA639675CF1, 'HeistIsland', true)
    Citizen.InvokeNative(0xF74B1FFA4A15FBEA, true)
    Citizen.InvokeNative(0x53797676AD34A9AA, false)
    SetAudioFlag('PlayerOnDLCHeist4Island', true)
    SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', true, true)
    SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', false, true)
    Cayo.Utils.massiveLoad = true
    local index = "inZone"
    local this = Cayo.Ipls[index]
    this.isSet = true
    CayoFnc:LoadIplFromArray(this.list)
    CayoFnc:ResetOtherZone(index)
    Cayo.Utils.lastSet = index
    CayoFnc:StartBombsThread()
end

function CayoFnc:SetOutOfRange()
    SetScenarioGroupEnabled('Heist_Island_Peds', false)
    -- Citizen.InvokeNative(0x5E1460624D194A38, false) -- fuck la map
    Citizen.InvokeNative(0xF74B1FFA4A15FBEA, false)
    Citizen.InvokeNative(0x53797676AD34A9AA, true)
    SetAudioFlag('PlayerOnDLCHeist4Island', false)
    SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', false, false)
    SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', true, false)
    if Cayo.Utils.massiveLoad == true then
        Citizen.InvokeNative(0x9A9D1BA639675CF1, 'HeistIsland', false)
        Wait(100)
    end
    local index = "outOfRange"
    local this = Cayo.Ipls[index]
    this.isSet = true
    CayoFnc:LoadIplFromArray(this.list)
    CayoFnc:ResetOtherZone(index)
    Cayo.Utils.lastSet = index
end

function CayoFnc:SetLongRange()
    SetScenarioGroupEnabled('Heist_Island_Peds', false)
    -- Citizen.InvokeNative(0x5E1460624D194A38, false) -- fuck la map
    Citizen.InvokeNative(0xF74B1FFA4A15FBEA, false)
    Citizen.InvokeNative(0x53797676AD34A9AA, true)
    SetAudioFlag('PlayerOnDLCHeist4Island', false)
    SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Zones', false, false)
    SetAmbientZoneListStatePersistent('AZL_DLC_Hei4_Island_Disabled_Zones', true, false)
    if Cayo.Utils.massiveLoad == true then
        Citizen.InvokeNative(0x9A9D1BA639675CF1, 'HeistIsland', false)
        Wait(100)
    end
    local index = "longrange"
    local this = Cayo.Ipls[index]
    this.isSet = true
    CayoFnc:LoadIplFromArray(this.list)
    CayoFnc:ResetOtherZone(index)
    Cayo.Utils.lastSet = index
end

function CayoFnc:StartBombsThread()
    if Cayo.Utils.mineThreadActive == true or Cayo.Utils.useMines == false then
        return
    end

    Cayo.Utils.mineThreadActive = true
    CreateThread(function()
        while Cayo.Utils.lastSet == 'inZone' or Cayo.Utils.lastSet == 'midRange' do
            local sleepTimer = 1000
            local bombModel = -839564162
            local bomb = GetClosestObjectOfType(Cayo.Utils.pedCoords,25.0, bombModel, false, true,true)
            if bomb ~= 0 then
                sleepTimer = 0
                local bombCoords = GetEntityCoords(bomb)
                local dstCheck = #(Cayo.Utils.pedCoords - bombCoords)
                local boat = GetVehiclePedIsIn(Cayo.Utils.ped, false)
                local boatCoords = GetEntityCoords(boat)
                if dstCheck <= 50.0 and boat ~= 0 then
                    Cayo.Utils.pedCoords = GetEntityCoords(Cayo.Utils.ped)
                    AddExplosion(boatCoords,"EXPLOSION_PLANE", 1, true, false, 1, false)
                    ClearPedTasksImmediately(Cayo.Utils.ped)
                    SetPedToRagdoll(Cayo.Utils.ped, 1000, 1000, 0, true, true, true)
                    SetEntityVelocity(boat, math.random(10,20),math.random(10,20),10.0)
                    SetEntityVelocity(Cayo.Utils.ped, math.random(100,200),math.random(100,200),20.0)
                    Wait(1000)
                    if DoesEntityExist(boat) then
                        DeleteEntity(boat)
                    end
                    Wait(4000)
                end
            end
            Wait(sleepTimer)
        end
        Cayo.Utils.mineThreadActive = false
    end)
end

function CayoFnc:ResetOtherZone(myZone)
    for k,v in pairs(Cayo.Ipls) do
        if k ~= myZone then
            v.isSet = false
        end
    end
end

function CayoFnc:LoadIplFromArray(list)
    for k,v in pairs(list) do
        _ENV[v.fnc](v.ipl)
    end
end

function CayoFnc:RequestModel(model)
    CreateThread(function()
        RequestModel(model)
    end)
end

function CayoFnc:SpawnAllGuards()
    CreateThread(function()
        Cayo.Utils.ped = PlayerPedId()
        Cayo.Utils.pedCoords = GetEntityCoords(Cayo.Utils.ped)
        local data = {pedType = 7, noCriticals = true, agressive = true, health = 500, armor = 100, flee = false}
        if Cayo.Utils.allowedInCamp then
            data.blockActions = true
        end
        for k,v in pairs(Cayo.PedTowerCoords) do
            local coords = vector3(v.coords.x,v.coords.y,v.coords.z - 1)
            v.pedId = CayoFnc:CreatePed(coords,v.heading,v.weapons,Cayo.PedModelList,data,false,true,vehicleInfo,false)
            Wait(50)
            FreezeEntityPosition(v.pedId, true)
            SetEntityInvincible(v.pedId, true)
        end
    end)
end

function CayoFnc:SpawnRocketPed()
    CreateThread(function()
        Cayo.Utils.ped = PlayerPedId()
        Cayo.Utils.pedCoords = GetEntityCoords(Cayo.Utils.ped)
        local weapons = {{"WEAPON_HOMINGLAUNCHER"}}
        local coords = vector3(Cayo.Utils.pedCoords.x,Cayo.Utils.pedCoords.y,Cayo.Utils.pedCoords.z - GetEntityHeightAboveGround(Cayo.Utils.ped))
        local data = {pedType = 7, noCriticals = true, agressive = true, health = 500, armor = 100, flee = false}
        local thisPed = CayoFnc:CreatePed(coords,0.0,weapons,Cayo.PedModelList,data,true,true,vehicleInfo,false)
        TaskCombatPed(thisPed, Cayo.Utils.ped)
        SetPedKeepTask(thisPed, true)
        table.insert(Cayo.CurrentPedList, thisPed)
        table.insert(Cayo.CurrentEntities, thisPed)
    end)
end

function CayoFnc:SpawnTruck()
    CreateThread(function()
        Cayo.Utils.ped = PlayerPedId()
        Cayo.Utils.pedCoords = GetEntityCoords(Cayo.Utils.ped)
        local truckModel = GetHashKey("squaddie")
        local weapons = {{"WEAPON_ASSAULTRIFLE_MK2", "WEAPON_MINISMG", "WEAPON_HEAVYSNIPER_MK2", "WEAPON_COMBATMG_MK2"}, {"WEAPON_MINISMG"}}
        local retval, outPosition, outHeading = GetClosestVehicleNodeWithHeading(Cayo.Utils.pedCoords.x + 100, Cayo.Utils.pedCoords.y + 100,Cayo.Utils.pedCoords.z, 1 , 1, 1)

        if IsPedInAnyVehicle(Cayo.Utils.ped, false) then
            if IsPedInAnyPlane(Cayo.Utils.ped) or IsPedInAnyHeli(Cayo.Utils.ped) then
                weapons = {{"WEAPON_HOMINGLAUNCHER"}, {"WEAPON_MINISMG"}}
            else
                weapons = {{"WEAPON_ASSAULTRIFLE_MK2", "WEAPON_COMBATMG_MK2", "WEAPON_RPG"}, {"WEAPON_MINISMG"}}
            end
        end

        local vehicle = Utils:SpawnVehicle(truckModel,outPosition,outHeading,true)

        FreezeEntityPosition(vehicle, true)
        local vehicleInfo = {
            entity = vehicle
        }
        local data = {pedType = 7, noCriticals = true, agressive = true, health = 300, armor = 100, flee = false}
        for i = 1, 4, 1 do 
            local thisPed = CayoFnc:CreatePed(outPosition,outHeading,weapons,Cayo.PedModelList,data,true,true,vehicleInfo,false)
            TaskCombatPed(thisPed, Cayo.Utils.ped)
            SetPedKeepTask(thisPed, true)
            table.insert(Cayo.CurrentPedList, thisPed)
            table.insert(Cayo.CurrentEntities, thisPed)
        end
        table.insert(Cayo.CurrentEntities, vehicle)
        FreezeEntityPosition(vehicle, false)
   
    end)
end

function CayoFnc:CreatePed(coords,heading,weapon,model,data,network,mission,vehicle,cb)
    local validModel, modelHash = CayoFnc:AssureModel(CayoFnc:ValidateModel(model))
    local createdPed = CreatePed(data.pedType or 5, modelHash, coords or GetEntityCoords(PlayerPedId()), heading or GetEntityHeding(PlayerPedId()), network or false, mission or false)
    CayoFnc:SetAttributes(createdPed,data)
    if weapon then
        for k,v in pairs(weapon) do
            local validWeapon, weapon = CayoFnc:AssureWeapon(CayoFnc:ValidateModel(v))
            if validWeapon then
                GiveWeaponToPed(createdPed, weapon, 100, false, true)   
            end
        end
    end
    if vehicle and DoesEntityExist(vehicle.entity) then
        if vehicle.seat and (GetPedInVehicleSeat(vehicle,vehicle.seat) == 0 or GetPedInVehicleSeat(vehicle,vehicle.seat) == -1 ) then 
            TaskWarpPedIntoVehicle(createdPed,vehicle.entity,vehicle.seat)
        elseif not vehicle.seat and AreAnyVehicleSeatsFree(vehicle.entity) then
            for i = -1, GetVehicleModelNumberOfSeats(GetEntityModel(vehicle.entity)), 1 do
                if IsVehicleSeatFree(vehicle.entity, i) then
                    while not (GetPedInVehicleSeat(vehicle.entity,i) == createdPed) do
                        Wait(0)
                        TaskWarpPedIntoVehicle(createdPed,vehicle.entity,i)
                    end
                    break
                end
            end
        end
    end
    if cb then 
        cb() 
    end
    return createdPed
end

function CayoFnc:ValidateModel(model)
    if type(model) == "string" or type(model) == "number" then 
        return model 
    elseif #model then
        if model.model then
            return model[math.random(1,#model)].model
        else
            return model[math.random(1,#model)]
        end
    end
    return "","ERROR INVALID REQUEST"
end

function CayoFnc:SetAttributes(ped,data)
    SetEntityAsMissionEntity(ped)
    local currentFleeAttribute = 1
    if data.noCriticals then 
        SetPedSuffersCriticalHits(ped,false) 
    end
    if data.agressive then 
        SetPedCombatAttributes(ped, 46, 1) 
        SetPedCombatAbility(ped, 2)
        SetPedCombatMovement(ped, 2)
        SetPedCombatRange(ped, 2)
        SetPedCombatAttributes(ped,2,true)
        SetPedAsCop(ped, true)
        if data.blockActions then
            SetBlockingOfNonTemporaryEvents(ped, true)
        end
        -- SetRelationshipBetweenGroups(1, GetPedRelationshipGroupHash(ped), GetPedRelationshipGroupHash(ped))
        -- SetRelationshipBetweenGroups(5, GetPedRelationshipGroupHash(ped), GetHashKey('PLAYER'))
    end
    if data.health then 
        SetPedMaxHealth(ped,data.health)
        SetEntityHealth(ped,data.health)
    end
    if data.armor then 
        SetPedArmour(ped,data.armor)
    end
    if data.flee ~= nil then
        repeat
            SetPedFleeAttributes(ped, currentFleeAttribute, data.flee)
            currentFleeAttribute = currentFleeAttribute * 2
        until currentFleeAttribute >= 65536
    end
    SetPedDropsWeaponsWhenDead(ped, data.canDropWeapon or false)
    return true
end

function CayoFnc:AssureWeapon(weapon)
    local hash = GetHashKey(weapon)
    if IsWeaponValid(weapon) then
        return true,weapon
    elseif IsWeaponValid(hash) then
        return true,hash
    end
    return false, 0
end

function CayoFnc:GetarrayLenght(a)
    local cb = 0
    for k,v in pairs(a) do
        cb = cb + 1
    end
    return cb
end

function CayoFnc:AssureModel(model)
    local maxTimes,currentTime = 5000, 0
    CayoFnc:RequestModel(model)
    while not HasModelLoaded(model) and currentTime < maxTimes do
        CayoFnc:RequestModel(model)
        Wait(0)
        currentTime = currentTime + 1
    end
    return HasModelLoaded(model), GetHashKey(model)
end

function CayoFnc:CalculateNewDistance()
    local current, smollCheck = nil, 90000000000000.0     
    local dstCheck = #(Cayo.Utils.pedCoords - Cayo.Utils.islandCenter)
    local sleepTimer = Cayo.Ipls[Cayo.Utils.lastSet].sleepTimer

    for k,v in pairs(Cayo.Ipls) do
        if dstCheck <= v.maxDst then
            if v.maxDst - dstCheck < smollCheck then
                smollCheck =  v.maxDst - dstCheck
                current = k
            end
        end
    end

    current = current or Cayo.Utils.defaultIpl

    if current ~= Cayo.Utils.lastSet then
        CayoFnc[Cayo.Ipls[current].fnc]()
    end
end

function CayoFnc:StartInCayoZone()
    if Cayo.Utils.inCamp == false then
        Cayo.Utils.inCamp = true
        CreateThread(function()
            local lastSpawns = 0
            while Cayo.Utils.inCamp and not Cayo.Utils.allowedInCamp do
                Wait(500)
                local gameTime = GetGameTimer()
                Cayo.Utils.ped = PlayerPedId()

                if not IsPedDeadOrDying(Cayo.Utils.ped,1) and GetEntityAlpha(Cayo.Utils.ped) > 60 then
                    local smg = GetHashKey("WEAPON_MINISMG")
                    for k,v in pairs(Cayo.CurrentPedList) do
                        if IsPedDeadOrDying(v,1) then
                            table.remove(Cayo.CurrentPedList,k)
                        else
                            if IsPedInAnyVehicle(Cayo.Utils.ped, false) and not IsPedInAnyVehicle(v, false) then
                                if GetEntityHeightAboveGround(Cayo.Utils.ped) > 8 or (#(Cayo.Utils.pedCoords - GetEntityCoords(v)) < 10.0) then
                                    TaskShootAtEntity(v, Cayo.Utils.ped, 5000, GetHashKey("FIRING_PATTERN_FULL_AUTO"))
                                else
                                    TaskCombatPed(v, PlayerPedId(), 0, 16)
                                    SetPedKeepTask(v, true)
                                end
                            else
                                TaskCombatPed(v, PlayerPedId(), 0, 16)
                                SetPedKeepTask(v, true)
                            end
                            if IsPedInAnyVehicle(Cayo.Utils.ped, false) and IsPedInAnyVehicle(v, false) then
                                SetCurrentPedWeapon(v,smg,false)
                            else
                                for x,y in pairs(Cayo.CreatedPedWeaponList) do
                                    if HasPedGotWeapon(v,y,false) and y ~= smg then
                                        SetCurrentPedWeapon(v,y,false)
                                        break
                                    end
                                end
                            end
                        end
                    end

                    for k,v in pairs(Cayo.PedTowerCoords) do
                        local dstCheck = #(Cayo.Utils.pedCoords - GetEntityCoords(v.pedId))

                        if dstCheck <= v.maxDst and not IsPedInAnyVehicle(Cayo.Utils.ped, false) then
                            TaskShootAtEntity(v.pedId, Cayo.Utils.ped, 500, GetHashKey("FIRING_PATTERN_FULL_AUTO"))
                        elseif dstCheck <= v.maxVehDst and IsPedInAnyVehicle(Cayo.Utils.ped, false) then
                            TaskShootAtEntity(v.pedId, Cayo.Utils.ped, 500, GetHashKey("FIRING_PATTERN_FULL_AUTO"))
                        end
                    end

                    if gameTime - lastSpawns > Cayo.Utils.timerBetweenSpawns then
                        lastSpawns = gameTime
                        if GetEntityHeightAboveGround(Cayo.Utils.ped) > 8 then
                            if #Cayo.CurrentPedList < Cayo.Utils.maxPed then
                                CayoFnc:SpawnRocketPed()
                            end
                        else
                            if #Cayo.CurrentPedList < Cayo.Utils.maxPed then
                                CayoFnc:SpawnTruck()
                            end
                        end
                    end
                end
            end

            CayoFnc:DeleteAllCampEntities()
        end)
    end
end

function CayoFnc:DeleteAllCampEntities()
    for k,v in pairs(Cayo.CurrentEntities) do
        DeleteEntity(v)
    end
end

function CayoFnc:DeleteAllGuards()
    for k,v in pairs(Cayo.PedTowerCoords) do
        DeleteEntity(v.pedId)
    end
end

function CayoFnc:Exports()
    CreateThread(function()
        for k,v in pairs(Cayo.Zones) do
            local this = v
            this.aditionalParams = {index = k}
            exports.plouffe_lib:ValidateZoneData(this)
        end
    end)
end

function CayoFnc:StartMainThread()
    Cayo.Utils.ped = PlayerPedId()
    Cayo.Utils.pedCoords = GetEntityCoords(Cayo.Utils.ped)
    -- CreateThread(function()
    --     if Cayo.Utils.forceMap == true then
    --         while true do
    --             Cayo.Utils.ped = PlayerPedId()
    --             Cayo.Utils.pedCoords = GetEntityCoords(Cayo.Utils.ped)
    --             SetRadarAsExteriorThisFrame()
    --             SetRadarAsInteriorThisFrame('h4_fake_islandx', vec(4700.0, -5145.0), 0, 0)
    --             Wait(0)
    --         end
    --     else
    --         while true do
    --             Cayo.Utils.ped = PlayerPedId()
    --             Cayo.Utils.pedCoords = GetEntityCoords(Cayo.Utils.ped)
    --             Wait(500)
    --         end
    --     end
    -- end)
end