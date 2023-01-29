ESX = nil

local target
local PlayerData = {}

Citizen.CreateThread(function()

    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end 

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(0)
    end 

    isPlayerWhitelisted = refreshPlayerWhitelisted()
    PlayerData = ESX.GetPlayerData()

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    isPlayerWhitelisted = refreshPlayerWhitelisted()
end)

function refreshPlayerWhitelisted()
    if not ESX.PlayerData then
        return false
    end

    if not ESX.PlayerData.job then
        return false
    end

    for k,v in ipairs('barber') do
        if v == PlayerData.job and PlayerData.job.name == 'barber' then
            return true
        end
    end

    return false

end

local function DrawTopNotification(txt, beep)
    SetTextComponentFormat("jamyfafi")
    AddTextComponentString(txt)
    if string.len(txt) > 99 and AddLongString then AddLongString(txt) end
    DisplayHelpTextFromStringLabel(0, 0, beep, -1)
end

local MenuCoiffeurs = {
    Base = { Header = {"shopui_title_barber3", "shopui_title_barber3"}, Color = {color_black}, HeaderColor = {255, 255, 255, 220}, Blocked = true, Title = "Coiffeur" }, -- Blocked = true, pour bloqué le menu
    Data = { currentMenu = "Coiffeurs" },
    Events = {
        onExited = function(self, _, btn, CMenu, menuData, currentButton, currentBtn, currentSlt, result, slide, onSlide) 
			ClearPedTasks(PlayerPedId())
            TriggerEvent('skinchanger:modelLoaded')
        end,
        onSelected = function(self, _, btn, PMenu, menuData, currentButton, currentBtn, currentSlt, result, slide)
            -- locals
			local slide, btn, check, closestPlayer, closestDistance, playerPed, coords = btn.slidenum, btn.name, btn.unkCheckbox, ESX.Game.GetClosestPlayer(), PlayerPedId(), GetEntityCoords(playerPed)

            if slide == 2 and btn == "Selection" then
                TriggerServerEvent('annulertarget', target)
                FreezeEntityPosition(GetPlayerPed(-1), false)
                CloseMenu(true)
            elseif slide == 1 and btn == "Selection" then
                local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
                local prop_name = "p_cs_scissors_s"
                ciseau = CreateObject(GetHashKey(prop_name), x, y, z,  true,  true, true)
                AttachEntityToEntity(ciseau, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 28422), -0.0, 0.03, 0, 0, -270.0, -20.0, true, true, false, true, 1, true)
                SetEntityCoords(PlayerPedId(), 138.12, -1708.47, 28.30)
                SetEntityHeading(PlayerPedId(), 210.8189697)
                FreezeEntityPosition(GetPlayerPed(-1), false)
                startAnims("misshair_shop@barbers", "keeper_idle_b")
                Wait(10500)
                DeleteObject(ciseau)
                DetachEntity(ciseau, 1, true)
                ClearPedTasksImmediately(GetPlayerPed(-1))
                ClearPedSecondaryTask(GetPlayerPed(-1))

                TriggerServerEvent('saveskintarget', target)
                ESX.ShowNotification("~r~Coiffeurs~s~\nVous avez changer la coupe de votre client.")
                CloseMenu(true)
            end
        end,
        onSlide = function(menuData, btn, currentButton, currentSlt, slide, PMenu)
            local currentMenu, currentBtn, slide, btn, ped = menuData.currentMenu, menuData.currentBtn, btn.slidenum, btn.name, GetPlayerPed(-1)

            if btn == "Coupes" and slide ~= -1 then
                coupe = slide - 1
                TriggerServerEvent('skinchanger:changetarget', target, 'hair_1', coupe)
            elseif btn == "Teinture" and slide ~= -1 then
                teinture1 = slide - 1
                TriggerServerEvent('skinchanger:changetarget', target, 'hair_color_1', teinture1)
            elseif btn == "Teinture 2" and slide ~= -1 then
                teinture2 = slide - 1
                TriggerServerEvent('skinchanger:changetarget', target, 'hair_color_2', teinture2)
            elseif btn == "Barbes" and slide ~= -1 then
                barbe = slide - 1
                TriggerServerEvent('skinchanger:changetarget', target, 'beard_1', barbe)
            elseif btn == "Taille" and slide ~= -1 then
                tbarbe = slide - 1
                TriggerServerEvent('skinchanger:changetarget', target, 'beard_2', tbarbe)
            elseif btn == "Teinture Barbe" and slide ~= -1 then
                teinture1b = slide - 1
                TriggerServerEvent('skinchanger:changetarget', target, 'beard_3', teinture1b)
            elseif btn == "Sourcil" and slide ~= -1 then
                sourciltype = slide - 1
                TriggerServerEvent('skinchanger:changetarget', target, 'eyebrows_1', sourciltype)
            elseif btn == "Taille  " and slide ~= -1 then
                taillesourcilss = slide - 1
                TriggerServerEvent('skinchanger:changetarget', target, 'eyebrows_2', taillesourcilss)
            elseif btn == "Teinture Sourcil" and slide ~= -1 then
                couleursourcil = slide - 1
                TriggerServerEvent('skinchanger:changetarget', target, 'eyebrows_3', couleursourcil)
            elseif btn == "Maquillage " and slide ~= -1 then
                maquillage = slide - 1
                TriggerServerEvent('skinchanger:changetarget', target, 'makeup_1', maquillage)
            elseif btn == "Taille " and slide ~= -1 then
                tmaquillage = slide - 1
                TriggerServerEvent('skinchanger:changetarget', target, 'makeup_2', tmaquillage)
            elseif btn == "Couleur" and slide ~= -1 then
                cmaquillage = slide - 1
                TriggerServerEvent('skinchanger:changetarget', target, 'makeup_3', cmaquillage)
            end
        end
    },

    Menu = {
        ["Coiffeurs"] = {
            b = {
                {name = "Cheveux", ask = "→", askX = true},
                {name = "Barbe", ask = "→", askX = true},
                {name = "Sourcils", ask = "→", askX = true},
                {name = "Maquillage", ask = "→", askX = true},
                {name = "Selection", slidemax = {"~g~Valider~s~","~r~Annuler~s~"}}, 
            }
        },
        ["cheveux"] = {
            b = {
                {name = "Coupes", slidemax = 102},
                {name = "Teinture", slidemax = 63},
                {name = "Teinture 2", slidemax = 63},
            }
        },
        ["barbe"] = {
            b = {
                {name = "Barbes", slidemax = 28},
                {name = "Taille", slidemax = 10},
                {name = "Teinture Barbe", slidemax = 63},
            }
        },
        ["sourcils"] = {
            b = {
                {name = "Sourcil", slidemax = 28},
                {name = "Taille  ", slidemax = 10},
                {name = "Teinture Sourcil", slidemax = 63},
            }
        },
        ["maquillage"] = {
            b = {
                {name = "Maquillage ", slidemax = 71},
                {name = "Taille ", slidemax = 10},
                {name = "Couleur", slidemax = 63},
            }
        },
    }
}

local positionbarber = {
    {x = 138.23, y = -1708.48, z = 29.30}
}

Citizen.CreateThread(function()
    while true do
            local wait = 2000
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local marker2 = Vdist2(plyCoords, 138.23, -1708.48, 29.30)
            local barber = Vdist2(plyCoords, 138.23, -1708.48, 29.30)

            if marker2 < 5 and PlayerData.job and PlayerData.job.name == 'barber' then
                wait = 5
                DrawMarker(25, 138.23, -1708.48, 28.40, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.5, 0.5, 0.2, 52, 152, 219, 120, false, false, false, false)
            end 

                if barber < 1 and PlayerData.job and PlayerData.job.name == 'barber' then
                    DrawTopNotification("Appuyez sur ~INPUT_TALK~ pour accéder au ~b~coiffeurs~w~.")
                    if IsControlJustPressed(1, 38) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestDistance ~= -1 and closestDistance <= 3 then
                                TriggerServerEvent('sitchairtarget', GetPlayerServerId(closestPlayer))
                                DoScreenFadeIn(3250) DoScreenFadeOut(1250) 
                                Citizen.Wait(2600)
                                FreezeEntityPosition(GetPlayerPed(-1), true)
                                CreateMenu(MenuCoiffeurs)
                                SetEntityCoords(PlayerPedId(), 138.12, -1708.47, 28.30)
                                SetEntityHeading(PlayerPedId(), 210.8189697)
                                DoScreenFadeIn(2000) DoScreenFadeOut(1550)  DoScreenFadeIn(1000)
                                startAnims("misshair_shop@hair_dressers", "keeper_idle_b")
                                target = GetPlayerServerId(closestPlayer)
                            else
                                ESX.ShowNotification('Il n\'y a ~r~personne~s~ aux alentours')
                            return;
                            end
                        end)
                    end
                    wait = 5
                end

        Citizen.Wait(wait)
    end
end)

local MenuF6Barber = {
	Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {255, 255, 255, 220}, Title = "Herr Kutz" },
	Data = { currentMenu = "Coiffeurs"},
	Events = {
		onSelected = function(self, _, btn, PMenu, menuData, currentButton, currentBtn, currentSlt, result, slide)
			PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
			local slide = btn.slidenum
			local btn = btn.name
			local check = btn.unkCheckbox
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			local playerPed = PlayerPedId()
			local coords = GetEntityCoords(playerPed)

			if btn == "Annonce" then
                local result = ESX.KeyboardInput('Annonce', 120)
                if result == nil then 
                    ESX.ShowNotification('~r~Vous devez insérer des caractères')
                else
                    TriggerServerEvent('Annonce:coiffeurs', result)
                end
			elseif btn == "Facture" then
                OpenBillingMenu()

		end
	end,
},
	Menu = {
		["Coiffeurs"] = {
			b = {
				{name = "Annonce", ask = "→", askX = true},
				{name = "Facture", ask = "→", askX = true}
			}
	    }
    }
}

RegisterNetEvent('sitchairtargetcl') 
AddEventHandler('sitchairtargetcl', function(source)
    DoScreenFadeIn(3250) DoScreenFadeOut(1250) 
    Citizen.Wait(2600)
    SetEntityCoords(PlayerPedId(), 138.15, -1709.05, 28.10)
    SetEntityHeading(PlayerPedId(), 236.5154)
    DoScreenFadeIn(2000) DoScreenFadeOut(1550)  DoScreenFadeIn(1000)
    FreezeEntityPosition(GetPlayerPed(-1), true)
    TaskStartScenarioInPlace(GetPlayerPed(-1), 'PROP_HUMAN_SEAT_CHAIR_MP_PLAYER', 0, false)
end)

RegisterNetEvent('skinchanger:changetargetcl') 
AddEventHandler('skinchanger:changetargetcl', function(type, var)
    TriggerEvent('skinchanger:change', type, var)
end)

RegisterNetEvent('annulertargetcl') 
AddEventHandler('annulertargetcl', function(source)
    FreezeEntityPosition(GetPlayerPed(-1), false)
    ClearPedTasksImmediately(GetPlayerPed(-1))
    ClearPedSecondaryTask(GetPlayerPed(-1))
    SetEntityCoords(PlayerPedId(), 137.81, -1709.77, 28.30)
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
end)

RegisterNetEvent('saveskintargetcl') 
AddEventHandler('saveskintargetcl', function(source)
    FreezeEntityPosition(GetPlayerPed(-1), false)
    ClearPedTasksImmediately(GetPlayerPed(-1))
    ClearPedSecondaryTask(GetPlayerPed(-1))
    SetEntityCoords(PlayerPedId(), 137.81, -1709.77, 28.30)
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:save', skin)
    end)
end)

Citizen.CreateThread(function()
	for _, pos in pairs(positionbarber) do
		blips = AddBlipForCoord(pos.x, pos.y, pos.z)
		SetBlipSprite(blips, 71)
		SetBlipScale(blips, 0.8)
		SetBlipDisplay(blips, 4)
		SetBlipColour(blips, 81)
		SetBlipAsShortRange(blips, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Salon Herr Kutz")
		EndTextCommandSetBlipName(blips)
	end
end)

function startAnims(lib, anim)
	local lib, anim = lib,anim
	ESX.Streaming.RequestAnimDict(lib)
	TaskPlayAnim(GetPlayerPed(-1), lib, anim, 8.0, 8.0, -1, 1, 1, 0, 0, 0)
end

function OpenBillingMenu()
	local nombre = ESX.KeyboardInput('Facture', 60)

		if nombre ~= nil then
			nombre = tonumber(nombre)
			
			if type(nombre) == 'number' then
				local amount = tonumber(nombre)
				local player, distance = ESX.Game.GetClosestPlayer()
				local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

				if closestPlayer == -1 or closestDistance > 3.0 then
					TriggerServerEvent('PersonneProximite')
				else

				local playerPed        = GetPlayerPed(-1)
			
				TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
				Citizen.Wait(8000)
				ClearPedTasks(playerPed)
				TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_barber', 'Herr Kutz', amount)
				ESX.ShowNotification('~g~Facture envoyer à votre client.')
			end
		end
	end
end

----- CAISSE

Citizen.CreateThread(function()
    while true do
        wait = 750
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local marker = Vdist2(plyCoords, 134.73, -1707.92, 29.29)
            local menucaisse = Vdist2(plyCoords, 134.73, -1707.92, 29.29)

            if marker < 5 and PlayerData.job and PlayerData.job.name == 'barber' then 
                wait = 5
                DrawMarker(25, 134.73, -1707.92, 28.40, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.5, 0.5, 0.2, 52, 152, 219, 120, false, false, false, false)
            end 

            if menucaisse <= 1.4 and PlayerData.job and PlayerData.job.name == 'barber' then
                wait = 5
                DrawTopNotification("Appuyez sur ~INPUT_TALK~ pour accéder à la ~b~caisse~w~.")
                if IsControlJustPressed(1, 38) then
                    CreateMenu(MenuF6Barber)
                end
            end

        Citizen.Wait(wait)
    end
end)