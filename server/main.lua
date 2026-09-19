local ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback(Config.Eventname..":canPickUp", function(source, cb, item)
    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then cb(false) return end

    local canCarry = exports.ox_inventory:CanCarryItem(source, item, 1)
    cb(canCarry)
end)

RegisterNetEvent(Config.Eventname..":pickedUpItem")
AddEventHandler(Config.Eventname..":pickedUpItem", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if not xPlayer then return end

    if Config.RandomItems then
        local roll = math.random(1, 100)
        for _, data in ipairs(Config.ItemChances) do
            if roll <= data.chancePercent then
                exports.ox_inventory:AddItem(src, data.itemName, 1)
                break
            end
        end
    else
        if Config.RandomItemCount then
            count = math.random(2, 3)
        end

        exports.ox_inventory:AddItem(src, Config.Item, count)
    end
end)
