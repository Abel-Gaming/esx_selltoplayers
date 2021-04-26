ESX              = nil
local salePending = false
local salePendingItem = nil
local salePendingPrice = nil
local salePendingSeller = nil
local salePendingQuantity = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(250)
	end
end)

-- Chat Suggestion
Citizen.CreateThread(function()
	-- SELL SUGGESTION
	TriggerEvent('chat:addSuggestion', '/sell', 'Sell item to player', {
		{ name="Player ID", help="Input Recipient ID" },
		{ name="Item", help="Input Item (Use DB Name)" },
		{ name="Price", help="Input Price" },
		{ name="Quantity", help="Input Quantity" },
	})
	TriggerEvent('chat:addSuggestion', '/accept-purchase', 'Accept pending purchase')
end)

-- Commands
RegisterCommand("sell", function(source, args)
	-- Define Variables
	local recipient = args[1]
	local item = args[2]
	local price = args[3]
	local quantity = args[4]
	--Trigger Server Event
	TriggerServerEvent('SelltoPlayers:CreateSell', recipient, item, price, quantity)
	print('Event Triggered')
end, false)

RegisterCommand("accept-purchase", function(source, args)
	if salePending then
		ESX.ShowNotification("Purchase Accepted")
		TriggerServerEvent('SelltoPlayers:AcceptedSell', salePendingSeller, salePendingItem, salePendingPrice, salePendingQuantity)
		salePending = false
		salePendingItem = nil
		salePendingPrice = nil
		salePendingSeller = nil
	else
		ESX.ShowNotification("No pending purchase")
	end
end, false)

-- Events
RegisterNetEvent('SelltoPlayers:ConfirmPurchase')
AddEventHandler('SelltoPlayers:ConfirmPurchase', function(seller, item, price, quantity, sellerID, dbItem)
	local msg = "~o~Sell Request: ~p~" .. seller .. " ~w~is requesting to sell you ~y~" .. quantity .. " ~b~" .. item .. " ~w~for ~g~$" .. price .. "~w~."
	ESX.ShowHelpNotification(msg, true, true, -1)
	ESX.ShowNotification("Do ~b~/accept-purchase~w~ to accept purchase")
	salePending = true
	salePendingItem = dbItem
	salePendingPrice = price
	salePendingSeller = sellerID
	salePendingQuantity = quantity
end)