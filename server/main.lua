ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('SelltoPlayers:CreateSell')
AddEventHandler('SelltoPlayers:CreateSell', function(recipient, item, price, quantity)
    -- Get the selling player
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayerName = xPlayer.getName()
    
    -- Get the buyer
    local yPlayer = ESX.GetPlayerFromId(recipient)
    local yPlayerName = yPlayer.getName()

    -- Get the friendly name for the item
    local friendlyitem = ESX.GetItemLabel(item)

    -- Print info
    print('Sell Created')
    print('Seller: ' .. xPlayerName)
    print('Buyer: ' .. yPlayerName)
    print('Item: ' .. friendlyitem)
    print('Price: $' .. price)
    print('Quanity: ' .. quantity)

    -- Trigger event that ask buyer if they want to accept the sell request
    yPlayer.triggerEvent('SelltoPlayers:ConfirmPurchase', xPlayerName, friendlyitem, price, quantity, source, item)
end)

RegisterNetEvent('SelltoPlayers:AcceptedSell')
AddEventHandler('SelltoPlayers:AcceptedSell', function(sellerID, item, price, quantity)
    -- Get the buyer and seller
    local buyer = ESX.GetPlayerFromId(source)
    local seller = ESX.GetPlayerFromId(sellerID)

    -- Check the inventory of the seller
    if seller.getInventoryItem(item).count >= tonumber(quantity) then
        -- Remove the item from seller
        seller.removeInventoryItem(item, quantity)
        -- Adds the item to the buyer
        buyer.addInventoryItem(item, quantity)
        -- Takes money from buyer
        buyer.removeMoney(price)
        -- Gives money to seller
        seller.addMoney(price)
        -- Show notifications
        seller.showNotification("You sold ~y~" .. quantity .. " ~b~" .. item .. " ~w~to ~p~" .. buyer.name)
        buyer.showNotification("You bought ~y~" .. quantity .. " ~b~" .. item .. " ~w~from ~p~" .. seller.name)
    else
        seller.showNotification("~r~[ERROR]~w~ You do not have that item to sell!")
        buyer.showNotification("~r~[ERROR]~w~ The seller did not have the item they were trying to sell.")
    end
end)