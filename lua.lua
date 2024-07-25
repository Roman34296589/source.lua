print("SnapSanix Hub Loading...")
game.StarterGui:SetCore("SendNotification", {
	Title = "SnapSanix Hub V4.2 Release";
	Text = "Hi! Hub Version 4.2";
	Icon = "http://www.roblox.com/asset/?id=17816113278";
	Duration = 5;
})


local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local newflyspeed = 50
local c
local h
local bv
local bav
local cam
local flying
local p = game.Players.LocalPlayer
local buttons = {W = false, S = false, A = false, D = false, Moving = false}

function startFly()
    if not p.Character or not p.Character.Head or flying then return end
    c = p.Character
    h = c.Humanoid
    h.PlatformStand = true
    cam = workspace:WaitForChild('Camera')
    bv = Instance.new("BodyVelocity")
    bav = Instance.new("BodyAngularVelocity")
    bv.Velocity, bv.MaxForce, bv.P = Vector3.new(0, 0, 0), Vector3.new(10000, 10000, 10000), 1000
    bav.AngularVelocity, bav.MaxTorque, bav.P = Vector3.new(0, 0, 0), Vector3.new(10000, 10000, 10000), 1000
    bv.Parent = c.Head
    bav.Parent = c.Head
    flying = true
    h.Died:connect(function() flying = false end)
end
  
function endFly()
    if not p.Character or not flying then return end
    h.PlatformStand = false
    bv:Destroy()
    bav:Destroy()
    flying = false
end

function setVec(vec)
    return vec * (newflyspeed / vec.Magnitude)
end

local flinglist = {}
local playerlist = {}
local playerlistfe = {}
local antijoinlist = {}

table.insert(playerlist,"None")
table.insert(flinglist,"All")
table.insert(playerlistfe,"All")
table.insert(playerlistfe,game.Players.LocalPlayer.Name)


for i,v in pairs(game.Players:GetPlayers())do
    if v ~= game.Players.LocalPlayer then
        table.insert(flinglist,v.Name)
        table.insert(playerlist,v.Name)
        table.insert(playerlistfe,v.Name)
    end
end

game.Players.PlayerAdded:Connect(function(player)
    local name = player.Name
    table.insert(flinglist,name)
    table.insert(playerlist,name)
    table.insert(playerlistfe,name)
    if antijoinloop == true then
        table.insert(antijoinlist,name)
    end
end)

game.Players.PlayerRemoving:Connect(function(player)
    local name = player.Name
    for i,v in pairs(flinglist)do
        if v == name then  
            table.remove(flinglist,i)
        end
    end
    for i,v in pairs(playerlist)do
        if v == name then  
            table.remove(playerlist,i)
        end
    end
    for i,v in pairs(playerlistfe)do
        if v == name then  
            table.remove(playerlistfe,i)
        end
    end
    if antijoinloop == true then
        for i,v in pairs(antijoinlist)do
            if v == name then  
                table.remove(antijoinlist,i)
            end
        end
    end
end)
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local N = game:GetService("VirtualInputManager")

local Window = Fluent:CreateWindow({
    
    Title = "SnapSanix Hub Murder Mystery 2 Support Solara",
    SubTitle = "by SnapSan",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl -- Used when theres no MinimizeKeybind
})

--Fluent provides Lucide Icons https://lucide.dev/icons/ for the tabs, icons are optional
local Tabs = {
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "arrow-left-right" }),
    Combat = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    Trolling = Window:AddTab({ Title = "Trolling", Icon = "angry" }),
    ESP = Window:AddTab({ Title = "ESP", Icon = "person-standing" }),
    Visual = Window:AddTab({ Title = "Visual", Icon = "eye" }),
    Other = Window:AddTab({ Title = "Other", Icon = "power" }),
    Autofarm = Window:AddTab({ Title = "AutoFarm", Icon = "puzzle" }),
    Credits = Window:AddTab({ Title = "Credits", Icon = "link" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}



--charcter section
local Section = Tabs.Player:AddSection("Character")

--walkspeed
local Slider = Tabs.Player:AddSlider("WalkSpeed", 
{
    Title = "WalkSpeed",
    Description = "",
    Default = 16,
    Min = 16,
    Max = 250,
    Rounding = 1,
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
})
--jump power
local Slider = Tabs.Player:AddSlider("JumpPower", 
{
    Title = "JumpPower",
    Description = "",
    Default = 50,
    Min = 50,
    Max = 500,
    Rounding = 1,
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
    end
})

local Toggle = Tabs.Player:AddToggle("fly", 
{
    Title = "Fly", 
    Description = "",
    Default = false,
    Callback = function(enablefly)
        if flyfirst ~= true then
            flyfirst = true
            game:GetService("UserInputService").InputBegan:connect(function (input, GPE) 
                if GPE then return end
                for i, e in pairs(buttons) do
                    if i ~= "Moving" and input.KeyCode == Enum.KeyCode[i] then
                        buttons[i] = true
                        buttons.Moving = true
                    end
                end
            end)
              
            game:GetService("UserInputService").InputEnded:connect(function (input, GPE) 
                if GPE then return end
                local a = false
                for i, e in pairs(buttons) do
                    if i ~= "Moving" then
                        if input.KeyCode == Enum.KeyCode[i] then
                            buttons[i] = false
                        end
                        if buttons[i] then a = true end
                    end
                end
                buttons.Moving = a
            end)
    
            game:GetService("RunService").Heartbeat:connect(function (step) -- The actual fly function, called every frame
                if flying and c and c.PrimaryPart then
                    local p = c.PrimaryPart.Position
                    local cf = cam.CFrame
                    local ax, ay, az = cf:toEulerAnglesXYZ()
                    c:SetPrimaryPartCFrame(CFrame.new(p.x, p.y, p.z) * CFrame.Angles(ax, ay, az))
                    if buttons.Moving then
                        local t = Vector3.new()
                        if buttons.W then t = t + (setVec(cf.lookVector)) end
                        if buttons.S then t = t - (setVec(cf.lookVector)) end
                        if buttons.A then t = t - (setVec(cf.rightVector)) end
                        if buttons.D then t = t + (setVec(cf.rightVector)) end
                        c:TranslateBy(t * step)
                    end
                end
            end)
        end
        if enablefly == true then
            startFly()
        elseif enablefly == false then
            endFly()
        end
    end 
})

local Slider = Tabs.Player:AddSlider("Slider", 
{
    Title = "Fly Speed",
    Description = "",
    Default = 50,
    Min = 50,
    Max = 500,
    Rounding = 1,
    Callback = function(flyspeed)
        newflyspeed = tonumber(flyspeed)
    end
})


--noclip
local Toggle = Tabs.Player:AddToggle("Noclip", 
{
    Title = "Noclip", 
    Description = "",
    Default = false,
    Callback = function(noclip)
        loopnoclip = noclip
		while loopnoclip do
			function loopnoclipfix()
			for a, b in pairs(game.Workspace:GetChildren()) do
				if b.Name == game.Players.LocalPlayer.Name then
					for i, v in pairs(game.Workspace[game.Players.LocalPlayer.Name]:GetChildren()) do
						if v:IsA("BasePart") then
							v.CanCollide = false
						end
					end 
				end 
			end
			wait()
		end
		wait()
		pcall(loopnoclipfix)
		end
    end 
})

local Slider = Tabs.Player:AddSlider("fov", 
{
    Title = "FOV",
    Description = "",
    Default = 70,
    Min = 0,
    Max = 120,
    Rounding = 1,
    Callback = function(FOV)
        game:GetService'Workspace'.Camera.FieldOfView = FOV
    end
})


Tabs.Player:AddButton({
    Title = "Respawn",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.Humanoid.Health = 0
    end
})

local Section = Tabs.Player:AddSection("Other")

Tabs.Player:AddButton({
    Title = "Rejoin",
    Description = "",
    Callback = function()
        game:GetService'TeleportService':TeleportToPlaceInstance(game.PlaceId,game.JobId,game:GetService'Players'.LocalPlayer)
    end
})


local Section = Tabs.Teleport:AddSection("Teleport To")

Tabs.Teleport:AddButton({
    Title = "Teleport to Map",
    Description = "",
    Callback = function()
        for i,v in pairs (workspace:GetDescendants()) do
            if v.Name == "Spawn" then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Position) * CFrame.new(0,2.5,0)
            elseif v.Name == "PlayerSpawn" then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Position) * CFrame.new(0,2.5,0)
            end
        end
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Voting Room",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-120.88883972167969, 143.0824432373047, 68.76313781738281)
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Lobby",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-108.88531494140625, 139.6814422607422, -14.229801177978516)
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Secret Room",
    Description = "",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-93.99636840820312, 143.0824432373047, 104.05944061279297)
    end
})

local Dropdown = Tabs.Teleport:AddDropdown("Dropdown", {
    Title = "Teleport To",
    Description = "",
    Values = playerlist,
    Multi = false,
    Default = 1,
})

Tabs.Teleport:AddButton({
    Title = "Update Player List",
    Description = "Manually",
    Callback = function()
        Dropdown:SetValue("None")
    end
})

Dropdown:OnChanged(function(Value)
    if Value == "None" then
        print("None")
    else
        tptoplayer = players:FindFirstChild(Value)
        LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = CFrame.new(tptoplayer.Character:WaitForChild("HumanoidRootPart").Position)
    end
end)

Tabs.Teleport:AddButton({
    Title = "Teleport to Murderer",
    Description = "",
    Callback = function()
        local plrs = game:GetService("Players")
        for i,v in pairs(plrs:GetPlayers()) do
            if v.Character and (v.Character:FindFirstChild("Knife") or (v.Backpack and v.Backpack:FindFirstChild("Knife"))) then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
            end
        end
    end
})

Tabs.Teleport:AddButton({
    Title = "Teleport to Sheriff",
    Description = "",
    Callback = function()
        local plrs = game:GetService("Players")
        for i,v in pairs(plrs:GetPlayers()) do
            if v.Character and (v.Character:FindFirstChild("Gun") or (v.Backpack and v.Backpack:FindFirstChild("Gun"))) then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
            end
        end
    end
})

local localplayer = game:GetService("Players").LocalPlayer
local Section = Tabs.Teleport:AddSection("Grabber")

local function TeleportToGun()

    if not workspace:FindFirstChild("Normal") then 
        Fluent:Notify({
            Title = "SnapSanix Hub",
            Content = "Wait for the Sheriff's death to grab the gun",
            SubContent = "",
            Duration = 5
        })
    elseif not workspace.Normal:FindFirstChild("GunDrop") then
        Fluent:Notify({
            Title = "SnapSanix Hub",
            Content = "Wait for the Sheriff's death to grab the gun",
            SubContent = "",
            Duration = 5
        })
    else
        local currentX = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X
	    local currentY = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Y
	    local currentZ = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z

        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Normal:FindFirstChild("GunDrop").CFrame
        wait(0.26)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(currentX, currentY + 5, currentZ)

        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")

        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end

Tabs.Teleport:AddButton({
    Title = "Grab Gun",
    Description = "",
    Callback = TeleportToGun,
})


local Keybind = Tabs.Teleport:AddKeybind("Keybind", {
    Title = "Grab Gun Keybind",
    Description = "",
    Mode = "Toggle", -- Always, Toggle, Hold
    Default = "R", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

    -- Occurs when the keybind is clicked, Value is `true`/`false`
    Callback = function()
        if grabber == true then
            TeleportToGun()
        end
    end,

    -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
    ChangedCallback = function(New)
        print("Keybind changed!", New)
    end
})


local Toggle = Tabs.Teleport:AddToggle("MyToggle", 
{
    Title = "Toggle Grab Gun Keybind", 
    Description = "",
    Default = false,
    Callback = function(togglegrab)
        if togglegrab == true then
            grabber = true
        end
        if togglegrab == false then
            grabber = false
        end
    end 
})

local Section = Tabs.Combat:AddSection("Combat Universal")

Tabs.Combat:AddButton({
    Title = "Godmode",
    Description = "Two Lifes",
    Callback = function()
        local player = game.Players.LocalPlayer
		if player.Character then
			if player.Character:FindFirstChild("Humanoid") then
				player.Character.Humanoid.Name = "1"
			end
			local l = player.Character["1"]:Clone()
			l.Parent = player.Character
			l.Name = "Humanoid"; wait(0.1)
			player.Character["1"]:Destroy()
			workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
			player.Character.Animate.Disabled = true; wait(0.1)
			player.Character.Animate.Disabled = false
		end
    end
})

Tabs.Combat:AddButton({
    Title = "Create Fake Knife",
    Description = "Need Fake Knife from Marketplace",
    Callback = function()
        if game.Players.LocalPlayer.Character ~= nil then
			local lp = game.Players.LocalPlayer
			local tool;
			local handle;
			local knife;
		
			local animation1 = Instance.new("Animation")
			animation1.AnimationId = "rbxassetid://2467567750"
		
			local animation2 = Instance.new("Animation")
			animation2.AnimationId = "rbxassetid://1957890538"
		
			local anims = {animation1, animation2}
		
			tool = Instance.new("Tool")
			tool.Name = "Fake Knife"
			tool.Grip = CFrame.new(0, -1.16999984, 0.0699999481, 1, 0, 0, 0, 1, 0, 0, 0, 1)
			tool.GripForward = Vector3.new(-0, -0, -1)
			tool.GripPos = Vector3.new(0, -1.17, 0.0699999)
			tool.GripRight = Vector3.new(1, 0, 0)
			tool.GripUp = Vector3.new(0, 1, 0)
			handle = Instance.new("Part")
			handle.Size = Vector3.new(0.310638815, 3.42103457, 1.08775854)
			handle.Name = "Handle"
			handle.Transparency = 1
			handle.Parent = tool
			tool.Parent = lp.Backpack

			knife = lp.Character:WaitForChild("KnifeDisplay")
			knife.Massless = true
		
			lp:GetMouse().Button1Down:Connect(function()
				if tool and tool.Parent == lp.Character then
					local an = lp.Character.Humanoid:LoadAnimation(anims[math.random(1, 2)])
					an:Play()
				end
			end)
		end
    end
})


local Keybind = Tabs.Combat:AddKeybind("Keybind", {
    Title = "Sprint",
    Description = "",
    Mode = "Toggle", -- Always, Toggle, Hold
    Default = "LeftControl", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

    -- Occurs when the keybind is clicked, Value is `true`/`false`
    Callback = function(Value)
        if sprint == true then
            if Value then
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 32
            else
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
        end
    end,

    -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
    ChangedCallback = function(New)
        print("Keybind changed!", New)
    end
})

local Toggle = Tabs.Combat:AddToggle("MyToggle", 
{
    Title = "Toggle Sprint", 
    Description = "",
    Default = false,
    Callback = function(sprintt)
        if sprintt == true then
            sprint = true
        end
        if sprintt == false then
            sprint = false
        end
    end 
})

--get all emotes
Tabs.Combat:AddButton({
    Title = "Get All Emotes",
    Description = "its FE and Keybind is ,",
    Callback = function()
        loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Gi7331/scripts/main/Emote.lua"))()
    end
})

local Section = Tabs.Combat:AddSection("Combat Murderer")

function Stab()
    game:GetService("Players").LocalPlayer.Character.Knife.Stab:FireServer("Down")
 end
function EquipTool()
    for _,obj in next, game.Players.LocalPlayer.Backpack:GetChildren() do
        if obj.Name == "Knife" then
            local equip = game.Players.LocalPlayer.Backpack.Knife
            equip.Parent = game.Players.LocalPlayer.Character
        end
    end
end

local Toggle = Tabs.Combat:AddToggle("Autokillall", 
{
    Title = "Auto Kill All", 
    Description = "",
    Default = false,
    Callback = function(autokillall)
        autokillallloop = autokillall
        while autokillallloop do
            function autokillallloopfix()
            EquipTool()
            wait()
            local localCharacter = game.Players.LocalPlayer.Character
            local knife = localCharacter and localCharacter:FindFirstChild("Knife")
            wait()
            for _, player in ipairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer then
                    wait()
                    local playerCharacter = player.Character
                    local humanoidRootPart = playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart")
                    
                    if humanoidRootPart then
                        Stab()
                        firetouchinterest(humanoidRootPart, knife.Handle, 1)
                        firetouchinterest(humanoidRootPart, knife.Handle, 0)
                    end
                end
            end
            wait()
        end
        wait()
        pcall(autokillallloopfix)
        end
    end 
})

local function GetSheriff()
    local plrs = game:GetService("Players")
    for i,v in pairs(plrs:GetPlayers()) do
        if v.Character and (v.Character:FindFirstChild("Gun") or (v.Backpack and v.Backpack:FindFirstChild("Gun"))) then
            return v
        end
    end
    return nil
 end

local function KillSheriff()
    local Sheriff = GetSheriff() --// Gets the userdata of the sheriff
    if Sheriff then
        local pos = Sheriff.Character.HumanoidRootPart.Position
        repeat
            if Sheriff.Character.Humanoid.Health > 0 then --// Checking if there actually is a living sheriff
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Sheriff.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
                workspace.CurrentCamera.CFrame = Sheriff.Character.HumanoidRootPart.CFrame
            end
            wait()
        until Sheriff.Character.Humanoid.Health == 0
    end
end

Tabs.Combat:AddButton({
    Title = "Kill Sheriff",
    Description = "",
    Callback = function()
        local players = game:GetService("Players")
        local player = players.LocalPlayer
		if player.Backpack:FindFirstChild("Knife") or player.Character:FindFirstChild("Knife") then
			KillSheriff()
		else
            Fluent:Notify({
                Title = "SnapSanix Hub",
                Content = "You are not a murderer!",
                SubContent = "",
                Duration = 4
            })
		end
    end
})

local Toggle = Tabs.Combat:AddToggle("MyToggle", 
{
    Title = "View Murderer", 
    Description = "",
    Default = false,
    Callback = function(viewmurd)
        if viewmurd then
            local m = nil
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and (player.Character:FindFirstChild("Knife") or (player.Backpack and player.Backpack:FindFirstChild("Knife"))) then
                    m = player
                    break  -- Once we find the murderer, no need to continue looping
                end
            end
            if m then
                game.Workspace.CurrentCamera.CameraSubject = m.Character:WaitForChild("Humanoid")
            else
                game.Workspace.CurrentCamera.CameraSubject = nil  -- Reset CameraSubject if no murderer found
            end
        else
            game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
        end
    end 
})


local Toggle = Tabs.Combat:AddToggle("knifeaura", 
{
    Title = "Knife Aura", 
    Description = "",
    Default = false,
    Callback = function(knifeaura)
        knifeauraloop = knifeaura
		while knifeauraloop do
			function thtrhthtr()
			for i,v in pairs(game.Players:GetPlayers()) do
				if v ~= game.Players.LocalPlayer and game.Players.LocalPlayer:DistanceFromCharacter(v.Character.HumanoidRootPart.Position) < kniferangenum then
					EquipTool()
					wait()
					local localCharacter = game.Players.LocalPlayer.Character
					local knife = localCharacter and localCharacter:FindFirstChild("Knife")
					wait()
					local playerCharacter = v.Character
					local humanoidRootPart = playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart")
					
					if humanoidRootPart then
						Stab()
						firetouchinterest(humanoidRootPart, knife.Handle, 1)
						firetouchinterest(humanoidRootPart, knife.Handle, 0)
					end
				end
			end
		end
		wait()
		pcall(thtrhthtr)
	end
    end 
})
local Slider = Tabs.Combat:AddSlider("kniferange", 
{
    Title = "Knife Aura Range",
    Description = "",
    Default = 20,
    Min = 5,
    Max = 100,
    Rounding = 1,
    Callback = function(kniferange)
        kniferangenum = tonumber(kniferange)
    end
})
knifethrow = false
local Toggle = Tabs.Combat:AddToggle("throwknife", 
{
    Title = "Fast Throw Knife", 
    Description = "",
    Default = false,
    Callback = function(throw)
        if throw then
            knifethrow = true
        else
            knifethrow = false
        end
    end 
})
local Keybind = Tabs.Combat:AddKeybind("Keybind", {
    Title = "Fast Throw KeyBind",
    Description = "",
    Mode = "Toggle", -- Always, Toggle, Hold
    Default = "E", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

    -- Occurs when the keybind is clicked, Value is `true`/`false`
    Callback = function()
        if knifethrow == true then
            if game.Players.LocalPlayer.Character:FindFirstChild("Knife") then
                game:GetService("Players").LocalPlayer.Character.Knife.Throw:FireServer(
                    CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position),
                    game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                )
            elseif game.Players.LocalPlayer.Backpack:FindFirstChild("Knife") then
                game:GetService("Players").LocalPlayer.Backpack.Knife.Throw:FireServer(
                    CFrame.new(game.Players.LocalPlayer:GetMouse().Hit.Position),
                    game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                )
            end
        end
    end,

    -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
    ChangedCallback = function(New)
        print("Keybind changed!", New)
    end
})
local simulateKnifeThrow = false

local function findNearestPlayer()
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer

    local nearestPlayer = nil
    local shortestDistance = math.huge -- Initialize with a very large distance

    -- Iterate through all players
    for _, player in ipairs(Players:GetPlayers()) do
        -- Skip the local player and any players who have left the game
        if player ~= localPlayer and player.Character then 

            -- Get the positions of both players' HumanoidRootParts
            local localRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
            local otherRootPart = player.Character:FindFirstChild("HumanoidRootPart")

            -- Ensure both players have a HumanoidRootPart for accurate distance calculation
            if localRootPart and otherRootPart then
                local distance = (localRootPart.Position - otherRootPart.Position).Magnitude

                -- Update nearest player if a closer one is found
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestPlayer = player
                end
            end
        end
    end

    return nearestPlayer
end

local simulateKnifeThrow = false
local kill = false
local Toggle = Tabs.Combat:AddToggle("MyToggle", 
{
    Title = "Toggle Kill Nearest Player", 
    Description = "",
    Default = false,
    Callback = function(togglekill)
        if togglekill == true then
            kill = true
        end
        if togglekill == false then
            kill = false
        end
    end 
})

local Keybind = Tabs.Combat:AddKeybind("Keybind", {
    Title = "Kill Nearest Player",
    Description = "KeyBind",
    Mode = "Toggle", -- Always, Toggle, Hold
    Default = "R", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

    -- Occurs when the keybind is clicked, Value is `true`/`false`
    Callback = function()
        if kill == true then
            local function GetMurder()
                local plrs = game:GetService("Players")
                for i,v in pairs(plrs:GetPlayers()) do
                    if v.Character and (v.Character:FindFirstChild("Knife") or (v.Backpack and v.Backpack:FindFirstChild("Knife"))) then
                        return v
                    end
                end
                return nil
            end
            if GetMurder() ~= localplayer then print("You're not murderer.") return end
            if not localplayer.Character:FindFirstChild("Knife") then
                local hum = localplayer.Character:FindFirstChild("Humanoid")
                if localplayer.Backpack:FindFirstChild("Knife") then
                    localplayer.Character:FindFirstChild("Humanoid"):EquipTool(localplayer.Backpack:FindFirstChild("Knife"))
                else
                    print("You don't have the knife..?")
                    return
                end
            end
    
            local NearestPlayer = findNearestPlayer()
    
            if not NearestPlayer or not NearestPlayer.Character then
                print("Can't find a player!?")
                return
            end
            local nearestHRP = NearestPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not nearestHRP then
                print("Can't find the player's pivot.")
            end
    
            if not localplayer.Character:FindFirstChild("HumanoidRootPart") then print("You're not a valid character.") return end
            if not simulateKnifeThrow then
                nearestHRP.Anchored = true
                nearestHRP.CFrame = localplayer.Character:FindFirstChild("HumanoidRootPart").CFrame + localplayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 2
                task.wait(0.1)
                local args = {
                    [1] = "Slash"
                }
    
                localplayer.Character.Knife.Stab:FireServer(unpack(args))
                return
            else
                local lpknife = localplayer.Character:FindFirstChild("Knife")
                if not lpknife then return end
    
                local raycastParams = RaycastParams.new()
                raycastParams.FilterType = Enum.RaycastFilterType.Exclude
                raycastParams.FilterDescendantsInstances = {localplayer.Character}
                local rayResult = workspace:Raycast(lpknife:GetPivot().Position, (nearestHRP.Position - localplayer.Character:FindFirstChild("HumanoidRootPart").Position).Unit * 350, raycastParams)
                local toThrow = nearestHRP.Position
                if rayResult then
                    toThrow = rayResult.Position
                end
                if math.random(0, 10) == 5 then -- idk what the fuk im doing
                    toThrow = nearestHRP.Position
                end
                local args = {
                    [1] = lpknife:GetPivot(), 
                    [2] = toThrow
                }
    
                localplayer.Character.Knife.Throw:FireServer(unpack(args))
                return
            end
        end
    end,

    -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
    ChangedCallback = function(New)
        print("Keybind changed!", New)
    end
})

local Toggle = Tabs.Combat:AddToggle("MyToggle", 
{
    Title = "Simulate Knife Throw", 
    Description = "For Kill Nearest Player",
    Default = false,
    Callback = function(state)
        simulateKnifeThrow = state
		if state then
            print("Simulating a knife throw can make you look legitimate. However, note that it's less reliable and may miss the target.")
		end
    end 
})

local Section = Tabs.Combat:AddSection("Combat Sheriff")

local function GetMurder()
    local plrs = game:GetService("Players")
    for i,v in pairs(plrs:GetPlayers()) do
        if v.Character and (v.Character:FindFirstChild("Knife") or (v.Backpack and v.Backpack:FindFirstChild("Knife"))) then
            return v
        end
    end
    return nil
end

local function getPredictedPosition(player, shootOffset)
    pcall(function()
        player = player.Character
        if not player.Character then print("No murderer to predict position.") return end
    end)
    local playerHRP = player:FindFirstChild("UpperTorso")
    local playerHum = player:FindFirstChild("Humanoid")
    if not playerHRP or not playerHum then
        return Vector3.new(0,0,0), "Could not find the player's HumanoidRootPart."
    end

    local playerPosition = playerHRP.Position
    local velocity = Vector3.new()
    velocity = playerHRP.AssemblyLinearVelocity
    local playerMoveDirection = playerHum.MoveDirection
    local playerLookVec = playerHRP.CFrame.LookVector
    local yVelFactor = velocity.Y > 0 and -1 or 0.5
    local predictedPosition
    predictedPosition = playerHRP.Position + ((velocity * Vector3.new(0, 0.5, 0))) * (shootOffset / 15) +playerMoveDirection * shootOffset

    -- failed so hard i had to revert back to v1.11 :sob:

    --predictedPosition = Vector3.new(predictedPositiomurdererHRP.Position + ((murdererVelocity * Vector3.new(0, 0.5, 0))) * (shootOffset / 15) + murderer.Character.Humanoid.MoveDirection * shootOffsetn.X, math.clamp(predictedPosition.Y, playerPosition.Y - 2, playerPosition.Y + 2), predictedPosition.Z)


    return predictedPosition
end

local function ShootMurder()
	local shootOffset = 3.5
    local Murder = GetMurder()
		if Murder then
            local currentX = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.X
			local currentY = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Y
			local currentZ = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Z

			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Murder.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 7)
            wait(0.18)
            if GetSheriff() ~= localplayer then 
                print("You're not sheriff/hero.") 
                return 
            end
    
            local murderer = GetMurder()
            if not murderer then
                print("No murderer to shoot.")
                return
            end
    
            if not localplayer.Character:FindFirstChild("Gun") then
                local hum = localplayer.Character:FindFirstChild("Humanoid")
                if localplayer.Backpack:FindFirstChild("Gun") then
                    hum:EquipTool(localplayer.Backpack:FindFirstChild("Gun"))
                else
                    print("You don't have the gun..?")
                    return
                end
            end
    
            local murdererHRP = murderer.Character:FindFirstChild("HumanoidRootPart")
            if not murdererHRP then
                print("Could not find the murderer's HumanoidRootPart.")
                return
            end
    
            local predictedPosition = getPredictedPosition(murderer, shootOffset)
    
            local args = {
                [1] = 1,
                [2] = predictedPosition,
                [3] = "AH2"
            }
    
            
            localplayer.Character.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))

            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(currentX, currentY, currentZ)
		else
			print("no murder")
		end
	end


Tabs.Combat:AddButton({
    Title = "Shoot Murderer",
    Description = "",
    Callback = function()
        local players = game:GetService("Players")
        local player = players.LocalPlayer
		if player.Backpack:FindFirstChild("Gun") or player.Character:FindFirstChild("Gun") then
			ShootMurder()
		else
            Fluent:Notify({
                Title = "SnapSanix Hub",
                Content = "You re not a Sheriff/Hero",
                SubContent = "",
                Duration = 4
            })
		end
    end
})

local Toggle = Tabs.Combat:AddToggle("MyToggle", 
{
    Title = "View Sheriff", 
    Description = "",
    Default = false,
    Callback = function(viewmurd)
        if viewmurd then
            local S = nil
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character and (player.Character:FindFirstChild("Gun") or (player.Backpack and player.Backpack:FindFirstChild("Gun"))) then
                    S = player
                    break  -- Once we find the murderer, no need to continue looping
                end
            end
            if S then
                game.Workspace.CurrentCamera.CameraSubject = S.Character:WaitForChild("Humanoid")
            else
                game.Workspace.CurrentCamera.CameraSubject = nil  -- Reset CameraSubject if no murderer found
            end
        else
            game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
        end
    end 
})
local shootOffset = 3.5
local function getPredictedPosition(player, shootOffset)
    pcall(function()
        player = player.Character
        if not player.Character then print("No murderer to predict position.") return end
    end)
    local playerHRP = player:FindFirstChild("UpperTorso")
    local playerHum = player:FindFirstChild("Humanoid")
    if not playerHRP or not playerHum then
        return Vector3.new(0,0,0), "Could not find the player's HumanoidRootPart."
    end

    local playerPosition = playerHRP.Position
    local velocity = Vector3.new()
    velocity = playerHRP.AssemblyLinearVelocity
    local playerMoveDirection = playerHum.MoveDirection
    local playerLookVec = playerHRP.CFrame.LookVector
    local yVelFactor = velocity.Y > 0 and -1 or 0.5
    local predictedPosition
    predictedPosition = playerHRP.Position + ((velocity * Vector3.new(0, 0.5, 0))) * (shootOffset / 15) +playerMoveDirection * shootOffset

    -- failed so hard i had to revert back to v1.11 :sob:

    --predictedPosition = Vector3.new(predictedPositiomurdererHRP.Position + ((murdererVelocity * Vector3.new(0, 0.5, 0))) * (shootOffset / 15) + murderer.Character.Humanoid.MoveDirection * shootOffsetn.X, math.clamp(predictedPosition.Y, playerPosition.Y - 2, playerPosition.Y + 2), predictedPosition.Z)


    return predictedPosition
end
local aim = false
local Toggle = Tabs.Combat:AddToggle("MyToggle", 
{
    Title = "Toggle Silent Aim", 
    Description = "",
    Default = false,
    Callback = function(toggleaim)
        if toggleaim == true then
            aim = true
        end
        if toggleaim == false then
            aim = false
        end
    end
})


local localplayer = game:GetService("Players").LocalPlayer

local Keybind = Tabs.Combat:AddKeybind("silentaimm", {
    Title = "Silent Aim",
    Description = "Acts over a short distance",
    Mode = "Toggle", -- Always, Toggle, Hold
    Default = "Q", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

    Callback = function()
        if aim == true then
            if GetSheriff() ~= localplayer then 
                print("You're not sheriff/hero.") 
                return 
            end
    
            local murderer = GetMurder()
            if not murderer then
                print("No murderer to shoot.")
                return
            end
    
            if not localplayer.Character:FindFirstChild("Gun") then
                local hum = localplayer.Character:FindFirstChild("Humanoid")
                if localplayer.Backpack:FindFirstChild("Gun") then
                    hum:EquipTool(localplayer.Backpack:FindFirstChild("Gun"))
                else
                    print("You don't have the gun..?")
                    return
                end
            end
    
            local murdererHRP = murderer.Character:FindFirstChild("HumanoidRootPart")
            if not murdererHRP then
                print("Could not find the murderer's HumanoidRootPart.")
                return
            end
    
            local predictedPosition = getPredictedPosition(murderer, shootOffset)
    
            local args = {
                [1] = 1,
                [2] = predictedPosition,
                [3] = "AH2"
            }
    
    
            localplayer.Character.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
        end
    end,

    ChangedCallback = function(New)
        print("Keybind changed!", New)
    end
})

Tabs.Combat:AddButton({
    Title = "Aimbot",
    Description = "KeyBind is Z and X",
    Callback = function()
        local Area = game:GetService("Workspace")
		local RunService = game:GetService("RunService")
		local UIS = game:GetService("UserInputService")
		local Players = game:GetService("Players")
		local CoreGui = game:GetService("CoreGui")
		local LocalPlayer = Players.LocalPlayer
		local Mouse = LocalPlayer:GetMouse()
		local MyView = Area.CurrentCamera
		local MyTeamColor = LocalPlayer.TeamColor
		local HoldingM2 = false
		local Active = false
		local Lock = false
		local Epitaph = 0.200 ---Note: The Bigger The Number, The More Prediction.
		local HeadOffset = Vector3.new(0, .1, 0)

		_G.Character_Find_Method = 2

		-- Method 1: Find nearest
		-- Method 2: Find nearest player to mouse

		_G.TeamCheck = false
		_G.PredictUserMovement = true
		_G.FOV_Radius = 240
		_G.AimPart = "HumanoidRootPart"

		local function CursorLock()
			UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
		end

		local function UnLockCursor()
			HoldingM2 = false Active = false Lock = false 
			UIS.MouseBehavior = Enum.MouseBehavior.Default
		end

		function GetClosestPlayerToMouse()
			local target, mag = nil, _G.FOV_Radius
			for i,v in pairs(Players:GetPlayers()) do
				if not _G.TeamCheck then
					if v.Character and ((v.Character:FindFirstChild("Knife") ~= nil) or (v.Backpack and v.Backpack:FindFirstChild("Knife") ~= nil)) and v.Character:FindFirstChild(_G.AimPart) and v ~= LocalPlayer and v.Character:FindFirstChildOfClass("Humanoid").Health ~= 0 then
						local pos, onscreen = MyView:WorldToViewportPoint(v.Character[_G.AimPart].Position)
						if onscreen then
							local dist = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
							if dist < mag then
								target = v.Character
								mag = dist
							end
						end
					end
				end
			end
			return target
		end

		UIS.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton2 then
				HoldingM2 = true
				Active = true
				Lock = true
				if Active then
					local The_Enemy = nil
					The_Enemy = GetClosestPlayerToMouse()
					while HoldingM2 do task.wait(.000001)
						if Lock and The_Enemy ~= nil then
							local Future = nil
							if _G.PredictUserMovement then
								Future = The_Enemy[_G.AimPart].CFrame + (The_Enemy[_G.AimPart].Velocity * Epitaph + HeadOffset)
							else
								Future = The_Enemy[_G.AimPart].CFrame
							end
							MyView.CFrame = CFrame.lookAt(MyView.CFrame.Position, Future.Position)
							CursorLock()
						end
					end
				end
			end
		end)

		UIS.InputEnded:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton2 then
				UnLockCursor()
			end
		end)

		UIS.InputBegan:Connect(function(input, gameProcessedEvent)
			if gameProcessedEvent then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.Z then
					_G.TeamCheck = not _G.TeamCheck
					_G.PredictUserMovement = not _G.PredictUserMovement
					game.StarterGui:SetCore("SendNotification", {
						Title = "Aimbot for Sheriff"; --the notifications
						Text = "Aimbot " ..tostring(not _G.TeamCheck); 
						Duration = 2;
					})
				end
				if input.KeyCode == Enum.KeyCode.X then
					_G.PredictUserMovement = not _G.PredictUserMovement
					game.StarterGui:SetCore("SendNotification", {
						Title = "Aimbot"; --the notifications
						Text = "Predict movement: " ..tostring(_G.PredictUserMovement); 
						Duration = 2;
					})
				end
			end
		end)
    end
})




local Section = Tabs.Trolling:AddSection("Fling")


local Dropdown = Tabs.Trolling:AddDropdown("list", {
    Title = "Select Player",
    Description = "",
    Values = flinglist,
    Multi = false,
    Default = 1,
})

Tabs.Trolling:AddButton({
    Title = "Update Fling List",
    Description = "Manually",
    Callback = function()
        Dropdown:SetValue(flinglist)
    end
})


Dropdown:OnChanged(function(Value)
    Flingtarget = Value
end)



Tabs.Trolling:AddButton({
    Title = "Fling Player",
    Description = "",
    Callback = function()
        local Targets = {Flingtarget} 

        local Players = game:GetService("Players")
        local Player = Players.LocalPlayer

        local AllBool = false

        local GetPlayer = function(Name)
            Name = Name:lower()
            if Name == "all" or Name == "others" then
                AllBool = true
                return
            elseif Name == "random" then
                local GetPlayers = Players:GetPlayers()
                if table.find(GetPlayers, Player) then
                    table.remove(GetPlayers, table.find(GetPlayers, Player))
                end
                return GetPlayers[math.random(#GetPlayers)]
            elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
                for _, x in next, Players:GetPlayers() do
                    if x ~= Player then
                        if x.Name:lower():match("^" .. Name) then
                            return x;
                        elseif x.DisplayName:lower():match("^" .. Name) then
                            return x;
                        end
                    end
                end
            else
                return
            end
        end

        local Message = function(_Title, _Text, Time)
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = _Title, Text = _Text, Duration = Time})
        end

        local SkidFling = function(TargetPlayer)
            local Character = Player.Character
            local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
            local RootPart = Humanoid and Humanoid.RootPart

            local TCharacter = TargetPlayer.Character
            local THumanoid
            local TRootPart
            local THead
            local Accessory
            local Handle

            if TCharacter:FindFirstChildOfClass("Humanoid") then
                THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
            end
            if THumanoid and THumanoid.RootPart then
                TRootPart = THumanoid.RootPart
            end
            if TCharacter:FindFirstChild("Head") then
                THead = TCharacter.Head
            end
            if TCharacter:FindFirstChildOfClass("Accessory") then
                Accessory = TCharacter:FindFirstChildOfClass("Accessory")
            end
            if Accessory and Accessory:FindFirstChild("Handle") then
                Handle = Accessory.Handle
            end

            if Character and Humanoid and RootPart then
                if RootPart.Velocity.Magnitude < 50 then
                    getgenv().OldPos = RootPart.CFrame
                end
                if THumanoid and THumanoid.SeatPart and not AllBool then
                    return Message("Error Occurred", "Target is sitting", 5) -- You can remove this part if you want
                end
                if THead then
                    workspace.CurrentCamera.CameraSubject = THead
                elseif not THead and Handle then
                    workspace.CurrentCamera.CameraSubject = Handle
                elseif THumanoid and TRootPart then
                    workspace.CurrentCamera.CameraSubject = THumanoid
                end
                if not TCharacter:FindFirstChildWhichIsA("BasePart") then
                    return
                end

                local FPos = function(BasePart, Pos, Ang)
                    RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
                    Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
                    RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                    RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
                end

                local SFBasePart = function(BasePart)
                    local TimeToWait = 2
                    local Time = tick()
                    local Angle = 0

                    repeat
                        if RootPart and THumanoid then
                            if BasePart.Velocity.Magnitude < 50 then
                                Angle = Angle + 100

                                FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0))
                                task.wait()
                            else
                                FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(-90), 0, 0))
                                task.wait()

                                FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                                task.wait()
                            end
                        else
                            break
                        end
                    until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.SeatPart or Humanoid.Health <= 0 or tick() > Time + TimeToWait
                end

                workspace.FallenPartsDestroyHeight = 0 / 0

                local BV = Instance.new("BodyVelocity")
                BV.Name = "EpixVel"
                BV.Parent = RootPart
                BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
                BV.MaxForce = Vector3.new(1 / 0, 1 / 0, 1 / 0)

                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

                if TRootPart and THead then
                    if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                        SFBasePart(THead)
                    else
                        SFBasePart(TRootPart)
                    end
                elseif TRootPart and not THead then
                    SFBasePart(TRootPart)
                elseif not TRootPart and THead then
                    SFBasePart(THead)
                elseif not TRootPart and not THead and Accessory and Handle then
                    SFBasePart(Handle)
                else
                    return Message("Error Occurred", "Target is missing everything", 5)
                end

                BV:Destroy()
                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                workspace.CurrentCamera.CameraSubject = Humanoid

                repeat
                    RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
                    Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
                    Humanoid:ChangeState("GettingUp")
                    table.foreach(Character:GetChildren(), function(_, x)
                        if x:IsA("BasePart") then
                            x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                        end
                    end)
                    task.wait()
                until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
                workspace.FallenPartsDestroyHeight = getgenv().FPDH
            else
                return Message("Error Occurred", "Random error", 5)
            end
        end

        if not Welcome then
            Message("Script by AnthonyIsntHere", "Enjoy!", 5)
        end
        getgenv().Welcome = true

        if Targets[1] then
            for _, x in next, Targets do
                GetPlayer(x)
            end
        else
            return
        end

        if AllBool then
            for _, x in next, Players:GetPlayers() do
                SkidFling(x)
            end
        end

        for _, x in next, Targets do
            if GetPlayer(x) and GetPlayer(x) ~= Player then
                if GetPlayer(x).UserId ~= 1414978355 then
                    local TPlayer = GetPlayer(x)
                    if TPlayer then
                        SkidFling(TPlayer)
                    end
                else
                    Message("Error Occurred", "This user is whitelisted! (Owner)", 5)
                end
            elseif not GetPlayer(x) and not AllBool then
                Message("Error Occurred", "Username Invalid", 5)
            end
        end
    end
})



Tabs.Trolling:AddButton({
    Title = "Fling Murderer",
    Description = "",
    Callback = function()
        local Targets = {"All"} -- "All", "Target Name", "arian_was_here"
		local Players = game:GetService("Players")
		local Player = Players.LocalPlayer

		local AllBool = false

		local GetPlayer = function(Name)
			Name = Name:lower()
			if Name == "all" or Name == "others" then
				AllBool = true
				return
			elseif Name == "random" then
				local GetPlayers = Players:GetPlayers()
				if table.find(GetPlayers,Player) then table.remove(GetPlayers,table.find(GetPlayers,Player)) end
				return GetPlayers[math.random(#GetPlayers)]
			elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
				for _,x in next, Players:GetPlayers() do
					if x ~= Player then
						if x.Name:lower():match("^"..Name) then
							return x;
						elseif x.DisplayName:lower():match("^"..Name) then
							return x;
						end
					end
				end
			else
				return
			end
		end

		local Message = function(_Title, _Text, Time)
			game:GetService("StarterGui"):SetCore("SendNotification", {Title = _Title, Text = _Text, Duration = Time})
		end

		local SkidFling = function(TargetPlayer)
			local Character = Player.Character
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			local RootPart = Humanoid and Humanoid.RootPart

			local TCharacter = TargetPlayer.Character
			local THumanoid
			local TRootPart
			local THead
			local Accessory
			local Handle

			if TCharacter:FindFirstChildOfClass("Humanoid") then
				THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
			end
			if THumanoid and THumanoid.RootPart then
				TRootPart = THumanoid.RootPart
			end
			if TCharacter:FindFirstChild("Head") then
				THead = TCharacter.Head
			end
			if TCharacter:FindFirstChildOfClass("Accessory") then
				Accessory = TCharacter:FindFirstChildOfClass("Accessory")
			end
			if Accessoy and Accessory:FindFirstChild("Handle") then
				Handle = Accessory.Handle
			end

			if Character and Humanoid and RootPart then
				if RootPart.Velocity.Magnitude < 50 then
					getgenv().OldPos = RootPart.CFrame
				end
				if THumanoid and THumanoid.Sit and not AllBool then
					return Message("Error Occurred", "Targeting is sitting", 5) -- u can remove dis part if u want lol
				end
				if THead then
					game:GetService("Workspace").CurrentCamera.CameraSubject = THead
				elseif not THead and Handle then
					game:GetService("Workspace").CurrentCamera.CameraSubject = Handle
				elseif THumanoid and TRootPart then
					game:GetService("Workspace").CurrentCamera.CameraSubject = THumanoid
				end
				if not TCharacter:FindFirstChildWhichIsA("BasePart") then
					return
				end
				
				local FPos = function(BasePart, Pos, Ang)
					RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
					Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
					RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
					RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
				end
				
				local SFBasePart = function(BasePart)
					local TimeToWait = 2
					local Time = tick()
					local Angle = 0

					repeat
						if RootPart and THumanoid then
							if BasePart.Velocity.Magnitude < 50 then
								Angle = Angle + 100

								FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
								task.wait()

								FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
								task.wait()
							else
								FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
								task.wait()
								
								FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
								task.wait()
							end
						else
							break
						end
					until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
				end
				
				game:GetService("Workspace").FallenPartsDestroyHeight = 0/0
				
				local BV = Instance.new("BodyVelocity")
				BV.Name = "EpixVel"
				BV.Parent = RootPart
				BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
				BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
				
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
				
				if TRootPart and THead then
					if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
						SFBasePart(THead)
					else
						SFBasePart(TRootPart)
					end
				elseif TRootPart and not THead then
					SFBasePart(TRootPart)
				elseif not TRootPart and THead then
					SFBasePart(THead)
				elseif not TRootPart and not THead and Accessory and Handle then
					SFBasePart(Handle)
				else
					return Message("Error Occurred", "Target is missing everything", 5)
				end
				
				BV:Destroy()
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
				game:GetService("Workspace").CurrentCamera.CameraSubject = Humanoid
				
				repeat
					RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
					Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
					Humanoid:ChangeState("GettingUp")
					table.foreach(Character:GetChildren(), function(_, x)
						if x:IsA("BasePart") then
							x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
						end
					end)
					task.wait()
				until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
				game:GetService("Workspace").FallenPartsDestroyHeight = getgenv().FPDH
			else
				return Message("Error Occurred", "Random error", 5)
			end
		end

		if not Welcome then Message("甩飞已开启成功", "猫脚本", 5) end
		getgenv().Welcome = true
		if Targets[1] then for _,x in next, Targets do GetPlayer(x) end else return end
		if AllBool then
			for _,x in pairs(game:GetService("Players"):GetPlayers()) do
				if x.Backpack:FindFirstChild("Knife") or x.Character:FindFirstChild("Knife") then
					SkidFling(x)
				end
			end
		end
    end
})

Tabs.Trolling:AddButton({
    Title = "Fling Sheriff",
    Description = "",
    Callback = function()
        local Targets = {"All"} -- "All", "Target Name", "arian_was_here"

		local Players = game:GetService("Players")
		local Player = Players.LocalPlayer

		local AllBool = false

		local GetPlayer = function(Name)
			Name = Name:lower()
			if Name == "all" or Name == "others" then
				AllBool = true
				return
			elseif Name == "random" then
				local GetPlayers = Players:GetPlayers()
				if table.find(GetPlayers,Player) then table.remove(GetPlayers,table.find(GetPlayers,Player)) end
				return GetPlayers[math.random(#GetPlayers)]
			elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
				for _,x in next, Players:GetPlayers() do
					if x ~= Player then
						if x.Name:lower():match("^"..Name) then
							return x;
						elseif x.DisplayName:lower():match("^"..Name) then
							return x;
						end
					end
				end
			else
				return
			end
		end

		local Message = function(_Title, _Text, Time)
			game:GetService("StarterGui"):SetCore("SendNotification", {Title = _Title, Text = _Text, Duration = Time})
		end

		local SkidFling = function(TargetPlayer)
			local Character = Player.Character
			local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
			local RootPart = Humanoid and Humanoid.RootPart

			local TCharacter = TargetPlayer.Character
			local THumanoid
			local TRootPart
			local THead
			local Accessory
			local Handle

			if TCharacter:FindFirstChildOfClass("Humanoid") then
				THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
			end
			if THumanoid and THumanoid.RootPart then
				TRootPart = THumanoid.RootPart
			end
			if TCharacter:FindFirstChild("Head") then
				THead = TCharacter.Head
			end
			if TCharacter:FindFirstChildOfClass("Accessory") then
				Accessory = TCharacter:FindFirstChildOfClass("Accessory")
			end
			if Accessoy and Accessory:FindFirstChild("Handle") then
				Handle = Accessory.Handle
			end

			if Character and Humanoid and RootPart then
				if RootPart.Velocity.Magnitude < 50 then
					getgenv().OldPos = RootPart.CFrame
				end
				if THumanoid and THumanoid.Sit and not AllBool then
					return Message("Error Occurred", "Targeting is sitting", 5) -- u can remove dis part if u want lol
				end
				if THead then
					game:GetService("Workspace").CurrentCamera.CameraSubject = THead
				elseif not THead and Handle then
					game:GetService("Workspace").CurrentCamera.CameraSubject = Handle
				elseif THumanoid and TRootPart then
					game:GetService("Workspace").CurrentCamera.CameraSubject = THumanoid
				end
				if not TCharacter:FindFirstChildWhichIsA("BasePart") then
					return
				end
				
				local FPos = function(BasePart, Pos, Ang)
					RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
					Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
					RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
					RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
				end
				
				local SFBasePart = function(BasePart)
					local TimeToWait = 2
					local Time = tick()
					local Angle = 0

					repeat
						if RootPart and THumanoid then
							if BasePart.Velocity.Magnitude < 50 then
								Angle = Angle + 100

								FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
								task.wait()

								FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
								task.wait()
							else
								FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
								task.wait()
								
								FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
								task.wait()

								FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
								task.wait()
							end
						else
							break
						end
					until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
				end
				
				game:GetService("Workspace").FallenPartsDestroyHeight = 0/0
				
				local BV = Instance.new("BodyVelocity")
				BV.Name = "EpixVel"
				BV.Parent = RootPart
				BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
				BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
				
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
				
				if TRootPart and THead then
					if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
						SFBasePart(THead)
					else
						SFBasePart(TRootPart)
					end
				elseif TRootPart and not THead then
					SFBasePart(TRootPart)
				elseif not TRootPart and THead then
					SFBasePart(THead)
				elseif not TRootPart and not THead and Accessory and Handle then
					SFBasePart(Handle)
				else
					return Message("Error Occurred", "Target is missing everything", 5)
				end
				
				BV:Destroy()
				Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
				game:GetService("Workspace").CurrentCamera.CameraSubject = Humanoid
				
				repeat
					RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
					Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
					Humanoid:ChangeState("GettingUp")
					table.foreach(Character:GetChildren(), function(_, x)
						if x:IsA("BasePart") then
							x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
						end
					end)
					task.wait()
				until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
				game:GetService("Workspace").FallenPartsDestroyHeight = getgenv().FPDH
			else
				return Message("Error Occurred", "Random error", 5)
			end
		end

		if not Welcome then Message("甩飞已开启成功", "猫脚本", 5) end
		getgenv().Welcome = true
		if Targets[1] then for _,x in next, Targets do GetPlayer(x) end else return end
		if AllBool then
			for _,x in pairs(game:GetService("Players"):GetPlayers()) do
				if x.Backpack:FindFirstChild("Gun") or x.Character:FindFirstChild("Gun") then
					SkidFling(x)
				end
			end
		end
    end
})

local Section = Tabs.Trolling:AddSection("Fake Die")

Tabs.Trolling:AddButton({
    Title = "Lay On Back",
    Description = "",
    Callback = function()
        local Human = game:GetService("Players").LocalPlayer.Character and game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass('Humanoid')
		if not Human then
    		return
		end
		Human.Sit = true
		task.wait(.1)
		Human.RootPart.CFrame = Human.RootPart.CFrame * CFrame.Angles(math.pi * .5, 0, 0)
		for _, v in ipairs(Human:GetPlayingAnimationTracks()) do
            v:Stop()
        end
        wait()
    end
})
Tabs.Trolling:AddButton({
    Title = "Sit Down",
    Description = "",
    Callback = function()
        game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Sit = true
		wait()
    end
})


local Section = Tabs.ESP:AddSection("Esp")

function CreateHighlight()
	for i, v in pairs(game.Players:GetPlayers()) do
		if v ~= game:GetService("Players").LocalPlayer and v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") and not v.Character:FindFirstChild("ESP_Highlight") then
			local esphigh = Instance.new("Highlight", v.Character)
            esphigh.Name = "ESP_Highlight"
            esphigh.FillColor = Color3.fromRGB(160, 160, 160)
            esphigh.OutlineTransparency = 1
            esphigh.FillTransparency = applyesptrans   
        end
	end
end
 
function UpdateHighlights()
	for _, v in pairs(game.Players:GetPlayers()) do
		if v ~= game:GetService("Players").LocalPlayer and v.Character ~= nil and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("ESP_Highlight") then
			local Highlight = v.Character:FindFirstChild("ESP_Highlight")
			if v.Name == Sheriff and IsAlive(v) then
				Highlight.FillColor = Color3.fromRGB(0, 0, 225)
                Highlight.FillTransparency = applyesptrans
			elseif v.Name == Murder and IsAlive(v) then
				Highlight.FillColor = Color3.fromRGB(225, 0, 0)
                Highlight.FillTransparency = applyesptrans
			elseif v.Name == Hero and IsAlive(v) and v.Backpack:FindFirstChild("Gun") then
				Highlight.FillColor = Color3.fromRGB(255, 255, 0)
                Highlight.FillTransparency = applyesptrans
			elseif v.Name == Hero and IsAlive(v) and v.Character:FindFirstChild("Gun") then
				Highlight.FillColor = Color3.fromRGB(255, 255, 0)
                Highlight.FillTransparency = applyesptrans
			elseif not IsAlive(v) then
				Highlight.FillColor = Color3.fromRGB(100, 100, 100)
                Highlight.FillTransparency = applyesptrans
			else
				Highlight.FillColor = Color3.fromRGB(0, 225, 0)
                Highlight.FillTransparency = applyesptrans
			end
		end
	end
end	
 
function IsAlive(Player)
	for i, v in pairs(roles) do
		if Player.Name == i then
			if not v.Killed and not v.Dead then
				return true
			else
				return false
			end
		end
	end
end
 
function HideHighlights()
	for _, v in pairs(game.Players:GetPlayers()) do
		if v ~= game:GetService("Players").LocalPlayer and v.Character ~= nil and v.Character:FindFirstChild("ESP_Highlight") then
			v.Character:FindFirstChild("ESP_Highlight"):Destroy()
		end
	end
end

applyesptrans = 0.5
local Toggle = Tabs.ESP:AddToggle("espall", 
{
    Title = "Esp Players", 
    Description = "",
    Default = false,
    Callback = function(SeeRoles)
        if SeeRoles then
            SSeeRoles = true
            while SSeeRoles == true do
                roles = game:GetService("ReplicatedStorage"):FindFirstChild("GetPlayerData", true):InvokeServer()
                for i, v in pairs(roles) do
                    if v.Role == "Murderer" then
                        Murder = i
                    elseif v.Role == "Sheriff" then
                        Sheriff = i
                    elseif v.Role == "Hero" then
                        Hero = i
                    end
                end
                CreateHighlight()
                UpdateHighlights()
                    end
            else
                SSeeRoles = false
                task.wait(0.2)
                HideHighlights()
        end
    end
})

local Slider = Tabs.ESP:AddSlider("esptran", 
{
    Title = "Esp Transparency",
    Description = "",
    Default = 0.5,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Callback = function(esptrans)
        applyesptrans = esptrans
    end
})


Tabs.ESP:AddButton({
    Title = "Names",
    Description = "",
    Callback = function()
        local c = workspace.CurrentCamera
        local ps = game:GetService("Players")
        local lp = ps.LocalPlayer
        local rs = game:GetService("RunService")

        local function esp(p, cr)
            local h = cr:WaitForChild("Humanoid")
            local hrp = cr:WaitForChild("HumanoidRootPart")

            local text = Drawing.new("Text")
            text.Visible = false
            text.Center = true
            text.Outline = true 
            text.Font = 2
            text.Color = Color3.fromRGB(255, 255, 255)
            text.Size = 18

            local c1
            local c2
            local c3

            local function dc()
                text.Visible = false
                text:Remove()
                if c1 then
                    c1:Disconnect()
                    c1 = nil 
                end
                if c2 then
                    c2:Disconnect()
                    c2 = nil 
                end
                if c3 then
                    c3:Disconnect()
                    c3 = nil 
                end
            end

            c2 = cr.AncestryChanged:Connect(function(_, parent)
                if not parent then
                    dc()
                end
            end)

            c3 = h.HealthChanged:Connect(function(v)
                if (v <= 0) or (h:GetState() == Enum.HumanoidStateType.Dead) then
                    dc()
                end
            end)

            c1 = rs.RenderStepped:Connect(function()
                local hrp_pos, hrp_onscreen = c:WorldToViewportPoint(hrp.Position)
                if hrp_onscreen then
                    text.Position = Vector2.new(hrp_pos.X, hrp_pos.Y)
                    text.Text = p.Name
                    text.Visible = true
                else
                    text.Visible = false
                end
            end)
        end

        local function p_added(p)
            if p.Character then
                esp(p, p.Character)
            end
            p.CharacterAdded:Connect(function(cr)
                esp(p, cr)
            end)
        end

        for i, p in next, ps:GetPlayers() do 
            if p ~= lp then
                p_added(p)
            end
        end

        ps.PlayerAdded:Connect(p_added)
    end
})


local SSeeGun = false

local function highlightGunDrop()
    while SSeeGun do
        repeat wait() until workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("GunDrop")
        
        local gunDrop = workspace.Normal:FindFirstChild("GunDrop")
        if gunDrop and not gunDrop:FindFirstChild("Esp_gun") then
            local espgunhigh = Instance.new("Highlight", gunDrop)
            espgunhigh.Name = "Esp_gun"
            espgunhigh.FillColor = Color3.fromRGB(148, 0, 211)
            espgunhigh.OutlineTransparency = 1
            espgunhigh.FillTransparency = 0
        end
    end
end

local Toggle = Tabs.ESP:AddToggle("MyToggle", {
    Title = "Esp Dropped Gun",
    Description = "",
    Default = false,
    Callback = function(gunDropESP)
        if gunDropESP then
            SSeeGun = true
            spawn(highlightGunDrop)
        else
            SSeeGun = false
            task.wait(0.2)
            local normal = workspace:FindFirstChild("Normal")
            if normal then
                local gunDrop = normal:FindFirstChild("GunDrop")
                if gunDrop then
                    local espGun = gunDrop:FindFirstChild("Esp_gun")
                    if espGun then
                        espGun:Destroy()
                    end
                end
            end
        end
    end
})
local coinbag = {}

local bag
local nl = 40
local ee = 90

table.insert(coinbag,nl)
table.insert(coinbag,ee)

local Dropdown = Tabs.ESP:AddDropdown("Dropdown", {
    Title = "CoinBag Type",
    Description = "Normal or Elite",
    Values = coinbag,
    Multi = false,
    Default = 1,
})

Dropdown:OnChanged(function(Value)
    bag = Value
end)


local Section = Tabs.Visual:AddSection("Visual")

-- Define ChangeXray initially as false
local ChangeXray = false

-- Define XrayFunction first
local function XrayFunction()
    local t = false
    local function scan(z, t)
        for _, i in pairs(z:GetChildren()) do
            if i:IsA("BasePart") and not i.Parent:FindFirstChild("Humanoid") and not i.Parent.Parent:FindFirstChild("Humanoid") then
                i.LocalTransparencyModifier = t
            end
            scan(i, t)
        end
    end
    
    local function x(v)
        if v then
            if ChangeXray then
                scan(workspace, 0.9)
            else
                scan(workspace, 0)
            end
        else
            scan(workspace, 0)
        end
    end
    
    t = not t
    x(t)
end

-- Then define the Toggle with the Callback
local Toggle = Tabs.Visual:AddToggle("xray", 
{
    Title = "Xray", 
    Description = "",
    Default = false,
    Callback = function(Value)
        ChangeXray = Value
        XrayFunction()
    end 
})



local Toggle = Tabs.Visual:AddToggle("improvefps", 
{
    Title = "Improve Fps", 
    Description = "",
    Default = false,
    Callback = function(improvefps)
        improvefpsloop = improvefps
		while improvefpsloop do
			for i,v in pairs (workspace:GetDescendants()) do
				if v.Name == "Pet" then
					v:Destroy()
				elseif v.Name == "KnifeDisplay" then
					v:Destroy()
				elseif v.Name == "GunDisplay" then
					v:Destroy()
				end
			end
			wait(10)
		end
    end 
})


local Lighting = game:GetService("Lighting")

local OldBrightness
local OldColorShiftBottom
local OldColorShiftTop
local OldOutdoorAmbient
local OldClockTime
local OldFogColor
local OldFogEnd
local OldFogStart
local OldExposureCompensation
local OldShadowSoftness
local OldAmbient

local Toggle = Tabs.Visual:AddToggle("shaders", 
{
    Title = "RTX Shaders", 
    Description = "",
    Default = false,
    Callback = function(Value)
        if Value then
            -- Save current lighting settings
            OldBrightness = Lighting.Brightness
            OldColorShiftBottom = Lighting.ColorShift_Bottom
            OldColorShiftTop = Lighting.ColorShift_Top
            OldOutdoorAmbient = Lighting.OutdoorAmbient
            OldClockTime = Lighting.ClockTime
            OldFogColor = Lighting.FogColor
            OldFogEnd = Lighting.FogEnd
            OldFogStart = Lighting.FogStart
            OldExposureCompensation = Lighting.ExposureCompensation
            OldShadowSoftness = Lighting.ShadowSoftness
            OldAmbient = Lighting.Ambient

            -- Apply RTX shaders
            local Bloom = Instance.new("BloomEffect")
            Bloom.Name = "Bloom (RTX Shaders)"
            Bloom.Intensity = 0.1
            Bloom.Threshold = 0
            Bloom.Size = 100
            Bloom.Parent = Lighting
            
            local Tropic = Instance.new("Sky")
            Tropic.Name = "Tropic (RTX Shaders)"
            Tropic.SkyboxUp = "http://www.roblox.com/asset/?id=169210149"
            Tropic.SkyboxLf = "http://www.roblox.com/asset/?id=169210133"
            Tropic.SkyboxBk = "http://www.roblox.com/asset/?id=169210090"
            Tropic.SkyboxFt = "http://www.roblox.com/asset/?id=169210121"
            Tropic.StarCount = 100
            Tropic.SkyboxDn = "http://www.roblox.com/asset/?id=169210108"
            Tropic.SkyboxRt = "http://www.roblox.com/asset/?id=169210143"
            Tropic.Parent = Bloom
            
            local Sky = Instance.new("Sky")
            Sky.Name = "Sky (RTX Shaders)"
            Sky.SkyboxUp = "http://www.roblox.com/asset/?id=196263782"
            Sky.SkyboxLf = "http://www.roblox.com/asset/?id=196263721"
            Sky.SkyboxBk = "http://www.roblox.com/asset/?id=196263721"
            Sky.SkyboxFt = "http://www.roblox.com/asset/?id=196263721"
            Sky.CelestialBodiesShown = false
            Sky.SkyboxDn = "http://www.roblox.com/asset/?id=196263643"
            Sky.SkyboxRt = "http://www.roblox.com/asset/?id=196263721"
            Sky.Parent = Bloom
    
            local Blur = Instance.new("BlurEffect")
            Blur.Name = "Bloom (RTX Shaders)"
            Blur.Size = 2
            Blur.Parent = Lighting
    
            local Efecto = Instance.new("BlurEffect")
            Efecto.Name = "Bloom (RTX Shaders)"
            Efecto.Enabled = false
            Efecto.Size = 2
            Efecto.Parent = Lighting
    
            local Inaritaisha = Instance.new("ColorCorrectionEffect")
            Inaritaisha.Name = "Inari taisha (RTX Shaders)"
            Inaritaisha.Saturation = 0.05
            Inaritaisha.TintColor = Color3.fromRGB(255, 224, 219)
            Inaritaisha.Parent = Lighting
    
            local Normal = Instance.new("ColorCorrectionEffect")
            Normal.Name = "Normal (RTX Shaders)"
            Normal.Enabled = false
            Normal.Saturation = -0.2
            Normal.TintColor = Color3.fromRGB(255, 232, 215)
            Normal.Parent = Lighting
    
            local SunRays = Instance.new("SunRaysEffect")
            SunRays.Name = "SunRays (RTX Shaders)"
            SunRays.Intensity = 0.05
            SunRays.Parent = Lighting
    
            local Sunset = Instance.new("Sky")
            Sunset.Name = "Sunset (RTX Shaders)"
            Sunset.SkyboxUp = "rbxassetid://323493360"
            Sunset.SkyboxLf = "rbxassetid://323494252"
            Sunset.SkyboxBk = "rbxassetid://323494035"
            Sunset.SkyboxFt = "rbxassetid://323494130"
            Sunset.SkyboxDn = "rbxassetid://323494368"
            Sunset.SunAngularSize = 14
            Sunset.SkyboxRt = "rbxassetid://323494067"
            Sunset.Parent = Lighting
    
            local Takayama = Instance.new("ColorCorrectionEffect")
            Takayama.Name = "Takayama (RTX Shaders)"
            Takayama.Enabled = false
            Takayama.Saturation = -0.3
            Takayama.Contrast = 0.1
            Takayama.TintColor = Color3.fromRGB(235, 214, 204)
            Takayama.Parent = Lighting
    
            -- Modify lighting settings for RTX shaders
            Lighting.Brightness = 2.14
            Lighting.ColorShift_Bottom = Color3.fromRGB(11, 0, 20)
            Lighting.ColorShift_Top = Color3.fromRGB(240, 127, 14)
            Lighting.OutdoorAmbient = Color3.fromRGB(34, 0, 49)
            Lighting.ClockTime = 6.7
            Lighting.FogColor = Color3.fromRGB(94, 76, 106)
            Lighting.FogEnd = 1000
            Lighting.FogStart = 0
            Lighting.ExposureCompensation = 0.24
            Lighting.ShadowSoftness = 0
            Lighting.Ambient = Color3.fromRGB(59, 33, 27)
        else
            for _, Child in pairs(Lighting:GetChildren()) do
                if string.find(Child.Name, "RTX Shaders") then
                    Child:Destroy()
                end
            end
            
            Lighting.Brightness = 2
            Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
            Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
            Lighting.OutdoorAmbient = Color3.fromRGB(157, 157, 157)
            Lighting.ClockTime = 14
            Lighting.FogColor = Color3.fromRGB(0, 0, 0)
            Lighting.FogEnd = 1000000000
            Lighting.FogStart = 0
            Lighting.ExposureCompensation = 0
            Lighting.ShadowSoftness = 0.1
            Lighting.Ambient = Color3.fromRGB(157, 157, 157)
        end
    end 
})

Tabs.Visual:AddButton({
    Title = "BoomBox",
    Description = "",
    Callback = function()
        _G.boomboxb = game:GetObjects('rbxassetid://740618400')[1]
        _G.boomboxb.Parent = game:GetService'Players'.LocalPlayer.Backpack
        loadstring(_G.boomboxb.Client.Source)() 
        loadstring(_G.boomboxb.Server.Source)() --the original scripts made by roblox with minor changes.
    end
})

local Toggle = Tabs.Visual:AddToggle("MyToggle", 
{
    Title = "Korblox", 
    Description = "",
    Default = false,
    Callback = function(roblox)
        korblox = roblox
        while korblox do
            local character = Players.LocalPlayer.Character
            local rightLowerLeg = character:FindFirstChild("RightLowerLeg")
            if rightLowerLeg then
                rightLowerLeg.MeshId = "http://www.roblox.com/asset/?id=902942093"
                rightLowerLeg.Transparency = 1
            end

            local rightUpperLeg = character:FindFirstChild("RightUpperLeg")
            if rightUpperLeg then
                rightUpperLeg.MeshId = "http://www.roblox.com/asset/?id=902942096"
                rightUpperLeg.TextureID = "http://www.roblox.com/asset/?id=902843398"
            end

            local rightFoot = character:FindFirstChild("RightFoot")
            if rightFoot then
                rightFoot.MeshId = "http://www.roblox.com/asset/?id=902942089"
                rightFoot.Transparency = 1
            end
			wait(2)
		end
    end 
})

local Toggle = Tabs.Visual:AddToggle("MyToggle", 
{
    Title = "Headless", 
    Description = "",
    Default = false,
    Callback = function(roblo)
        headless = roblo
        while headless do
            local character = Players.LocalPlayer.Character
            local head = character:FindFirstChild("Head")
            if head then
                head.MeshId = "http://www.roblox.com/asset/?id=6686307858"
                head.TextureID = "http://www.roblox.com/asset/?id=6686307858"
                head.Transparency = 1
            end
			wait(2)
		end
    end 
})

local Section = Tabs.Other:AddSection("Protection")

local Toggle = Tabs.Other:AddToggle("antitrap", 
{
    Title = "Anti Trap", 
    Description = "",
    Default = false,
    Callback = function(antitrap)
        antitraploop = antitrap
        while antitraploop do
        function antitraploopfix()
        if LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed == 0.009999999776482582 then
            LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 16
        end
        wait()
    end
    wait()
    pcall(antitraploopfix)
    end
    end
})

local Toggle = Tabs.Other:AddToggle("MyToggle", 
{
    Title = "Anti Fling", 
    Description = "",
    Default = false,
    Callback = function(Value)
        if Value then
            local Services = setmetatable({}, {__index = function(Self, Index)
                local NewService = game.GetService(game, Index)
                if NewService then
                    Self[Index] = NewService
                end
                return NewService
            end})
            
            local LocalPlayer = Services.Players.LocalPlayer
            
            local function PlayerAdded(Player)
                local Detected = false
                local Character;
                local PrimaryPart;
                
                local function CharacterAdded(NewCharacter)
                    Character = NewCharacter
                    repeat
                        wait()
                        PrimaryPart = NewCharacter:FindFirstChild("HumanoidRootPart")
                    until PrimaryPart
                    Detected = false
                end
                
                CharacterAdded(Player.Character or Player.CharacterAdded:Wait())
                AntiFlingCharacterAdded = Player.CharacterAdded:Connect(CharacterAdded)
                AntiFlingConnection = Services.RunService.Heartbeat:Connect(function()
                    if (Character and Character:IsDescendantOf(workspace)) and (PrimaryPart and PrimaryPart:IsDescendantOf(Character)) then
                        if PrimaryPart.AssemblyAngularVelocity.Magnitude > 50 or PrimaryPart.AssemblyLinearVelocity.Magnitude > 100 then
                            Detected = true
                            for i,v in ipairs(Character:GetDescendants()) do
                                if v:IsA("BasePart") then
                                    v.CanCollide = false
                                    v.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                                    v.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                    v.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
                                end
                            end
                            PrimaryPart.CanCollide = false
                            PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                            PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            PrimaryPart.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
                        end
                    end
                end)
            end
            
            for i,v in ipairs(Services.Players:GetPlayers()) do
                if v ~= LocalPlayer then
                    PlayerAdded(v)
                end
            end
            AntiFlingPlayerAdded = Services.Players.PlayerAdded:Connect(PlayerAdded)
            
            local LastPosition = nil
            AntiFlingConnection2 = Services.RunService.Heartbeat:Connect(function()
                pcall(function()
                    local PrimaryPart = LocalPlayer.Character.PrimaryPart
                    if PrimaryPart.AssemblyLinearVelocity.Magnitude > 250 or PrimaryPart.AssemblyAngularVelocity.Magnitude > 250 then
                        PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                        PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        PrimaryPart.CFrame = LastPosition
                    elseif PrimaryPart.AssemblyLinearVelocity.Magnitude < 50 or PrimaryPart.AssemblyAngularVelocity.Magnitude > 50 then
                        LastPosition = PrimaryPart.CFrame
                    end
                end)
            end)
        else
            if AntiFlingPlayerAdded then
                AntiFlingPlayerAdded:Disconnect()
                AntiFlingPlayerAdded = nil
            end
            if AntiFlingCharacterAdded then
                AntiFlingCharacterAdded:Disconnect()
                AntiFlingCharacterAdded = nil
            end
            if AntiFlingConnection then
                AntiFlingConnection:Disconnect()
                AntiFlingConnection = nil
            end
            if AntiFlingConnection2 then
                AntiFlingConnection2:Disconnect()
                AntiFlingConnection2 = nil
            end
        end
    end 
})


local ChangeAntiAFK = false

local Toggle = Tabs.Other:AddToggle("MyToggle", 
{
    Title = "Anti Afk", 
    Description = "",
    Default = false,
    Callback = function(Value)
        ChangeAntiAFK = Value
    end 
})

local VirtualUser = game:GetService("VirtualUser")

if ChangeAntiAFK then
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end

local Section = Tabs.Other:AddSection("Keybinds")

local function FlyFunction()
    if ChangeFly then
        startFly()
    else
        endFly()
    end
end

local Keybind = Tabs.Other:AddKeybind("Keybind", {
    Title = "Fly Keybind",
    Description = "",
    Mode = "Toggle",
    Default = "X",

    -- Occurs when the keybind is clicked, Value is `true`/`false`
    Callback = function()
        if flyy == true then
            if ChangeFly then
                ChangeFly = false
                FlyFunction()
            else
                ChangeFly = true
                FlyFunction()
            end
        end
    end,

    -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
    ChangedCallback = function(New)
        print("Keybind changed!", New)
    end
})

local Toggle = Tabs.Other:AddToggle("MyToggle", 
{
    Title = "Toggle Fly Keybind", 
    Description = "",
    Default = false,
    Callback = function(flytoggle)
        if flytoggle == true then
            flyy = true
        end
        if flytoggle == false then
            flyy = false
        end
    end
})

local np = false
local ChangeNoclip = false

local function NoclipFunction()
    while ChangeNoclip and task.wait() do
        for a, b in pairs(Workspace:GetChildren()) do
            if b.Name == LocalPlayer.Name then
                for i, v in pairs(Workspace[LocalPlayer.Name]:GetChildren()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = not ChangeNoclip
                    end
                end 
            end 
        end
    end
end

local Keybind = Tabs.Other:AddKeybind("Keybind", {
    Title = "Xray Keybind",
    Description = "",
    Mode = "Toggle", -- Always, Toggle, Hold
    Default = "V", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

    -- Occurs when the keybind is clicked, Value is `true`/`false`
    Callback = function(ChangeXrayy)
        if ty == true then
            if ChangeXrayy then
                ChangeXray = true
                XrayFunction()
            else
                ChangeXray = false
                XrayFunction()
            end
        end
    end,

    -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
    ChangedCallback = function(New)
        print("Keybind changed!", New)
    end
})

local Toggle = Tabs.Other:AddToggle("MyToggle", 
{
    Title = "Toggle Xray Keybind", 
    Description = "",
    Default = false,
    Callback = function(togglexray)
        if togglexray == true then
            ty = true
        end
        if togglexray == false then
            ty = false
        end
    end 
})

local Keybind = Tabs.Other:AddKeybind("Keybind", {
    Title = "Noclip Keybind",
    Description = "",
    Mode = "Toggle", -- Always, Toggle, Hold
    Default = "LeftControl", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

    -- Occurs when the keybind is clicked, Value is `true`/`false`
    Callback = function(ChangeNoclipp)
        if np == true then
            if ChangeNoclipp then
                ChangeNoclip = true
                NoclipFunction()
            else
                ChangeNoclip = false
            end
        end
    end,

    -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
    ChangedCallback = function(New)
        print("Keybind changed!", New)
    end
})

local Toggle = Tabs.Other:AddToggle("MyToggle", 
{
    Title = "Toggle Noclip Keybind", 
    Description = "",
    Default = false,
    Callback = function(togglenoclip)
        if togglenoclip == true then
            np = true
        end
        if togglenoclip == false then
            np = false
        end
    end 
})

local Keybind = Tabs.Other:AddKeybind("Keybind", {
    Title = "Respawn Keybind",
    Description = "Keybind Description",
    Mode = "Toggle", -- Always, Toggle, Hold
    Default = "J", -- String as the name of the keybind (MB1, MB2 for mouse buttons)

    -- Occurs when the keybind is clicked, Value is `true`/`false`
    Callback = function()
        if rt == true then
            game.Players.LocalPlayer.Character.Humanoid.Health = 0
        end
    end,

    -- Occurs when the keybind itself is changed, `New` is a KeyCode Enum OR a UserInputType Enum
    ChangedCallback = function(New)
        print("Keybind changed!", New)
    end
})

local Toggle = Tabs.Other:AddToggle("MyToggle", 
{
    Title = "Toggle Respawn Keybind", 
    Description = "",
    Default = false,
    Callback = function(togglere)
        if togglere == true then
            rt = true
        end
        if togglere == false then
            rt = false
        end
    end 
})

local Section = Tabs.Other:AddSection("Notify")

local gundropExists = false
local monitoring = false
local workspace = game:GetService("Workspace")
local runService = game:GetService("RunService")
local connection

local function checkGunDrop()
    if workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("GunDrop") then
        if not gundropExists then
            Fluent:Notify({
                Title = "SnapSanix Hub",
                Content = "Gun has Dropped",
                SubContent = "Find purple highlight!",
                Duration = 6
            })
            gundropExists = true
        end
    elseif gundropExists then
        Fluent:Notify({
            Title = "SnapSanix Hub",
            Content = "Gun has been picked up",
            SubContent = "",
            Duration = 6
        })
        gundropExists = false
    end
end

local function startMonitoring()
    if not monitoring then
        connection = runService.Stepped:Connect(checkGunDrop)
        monitoring = true
        print("Monitoring started")
    end
end

local function stopMonitoring()
    if monitoring then
        connection:Disconnect()
        monitoring = false
        print("Monitoring stopped")
    end
end

local Toggle = Tabs.Other:AddToggle("MyToggle", 
{
    Title = "Gun Drop Notify", 
    Description = "",
    Default = false,
    Callback = function(lol)
        if lol then
            startMonitoring()
        else
            stopMonitoring()
        end
    end 
})

local Section = Tabs.Autofarm:AddSection("Coming Soon")

Tabs.Autofarm:AddParagraph({
    Title = "Someday, but not now.",
    Content = "AutoFarm Coins is very difficult. I hope to do at least by the end of July. Use other Hubs that have Autofarm spoiler for now they are gone."
})

local N = {}
local A = game:GetService("ReplicatedStorage")
local L = game:GetService("ContextActionService")
local O = game:GetService("Players")
local D = O.LocalPlayer
local Z = game:GetService("TweenService")
local z = {
	Event = nil,
	Function = nil
}
local g
local G = game:GetService("RunService")

local x = {}

local RunService = game:GetService("RunService")

local tasks = {}

N.Elapse = {}
N.ManualSpeed = 5

N.FarmSpeedMethod = "Automatic"
N.TpWhenDone = "Map"

N.SmoothFarm = Enum.EasingDirection.InOut

N.CoinType = "Coin and BeachBall"

N.SafeMode = false
N.NoReplicateCoin = 0

N.FarmSTOP = true

N.ResetWhenDone = true

local function AddTask(taskName, event, callback)
    if tasks[taskName] then
        warn("Task already exists")
        return
    end
    local connection
    connection = event:Connect(function(...)
        callback(...)
    end)
    tasks[taskName] = connection
end

local function RemoveTask(taskName)
    if tasks[taskName] then
        tasks[taskName]:Disconnect()
        tasks[taskName] = nil
    else
        warn("No task found with the name:", taskName)
    end
end

-- Example usage:

-- Define the KK function using the above task management functions
--[[local function KK(o)
    if o then
        N.Noclip = true
        AddTask("Noclipping", RunService.RenderStepped, function()
            if D.Character and N.Noclip then
                pcall(function()
                    for a, b in pairs(game.Workspace:GetChildren()) do
                        if b.Name == game.Players.LocalPlayer.Name then
                            print("lol")
                        end 
                    end
                end)
            end
        end)
    else
        N.Noclip = false
        RemoveTask("Noclipping")
    end
end]]


local function ZK()
    for o, Y in pairs(game.Workspace:GetChildren()) do
        if Y.Name == "Normal" then
            return Y
        end
    end
end

local function h(o)
	if o and o.Character then
		return o.Character.FindFirstChild(o.Character, "PrimaryPart") or o.Character.FindFirstChild(o.Character, "HumanoidRootPart")
	end
end

local function QK(o)
    local Y = false
    local j = math.huge
    local Z = ZK()
    local t = (h(D)).Position
    if Z and Z:FindFirstChild("CoinContainer") then
        for _, K in pairs(Z.CoinContainer:GetChildren()) do
            if K.Name == "Coin_Server" and K ~= o then
                local coinVisual = K:FindFirstChild("CoinVisual")
                if coinVisual then
                    local coinType = (coinVisual.ClassName ~= "MeshPart" and "Coin") or "BeachBall"
                    if N.CoinType == coinType or N.CoinType == "Coin and BeachBall" then
                        -- Check if the coin has TouchInterest
                        if K:FindFirstChild("TouchInterest") then
                            local distance = (t - K.CFrame.Position).Magnitude
                            if distance < j then
                                j = distance
                                Y = K
                            end
                        end
                    end
                end
            end
        end
    end
    if Y == N.PreviousCoin then
        N.NoReplicateCoin = N.NoReplicateCoin + 1
        if N.NoReplicateCoin > 5 then
            N.NoReplicateCoin = 0
            task.wait()
            return QK(N.PreviousCoin)
        end
    end
    return Y
end


local function m(o, Y, j)
    if o and o.Character and o.Character:FindFirstChild("HumanoidRootPart") then
        o.Character.HumanoidRootPart.CFrame = j
    end
end



local function DK(o, Y)
    local j = false
    local Z = math.huge
    for Y, t in pairs(Y:GetDescendants()) do
        if t and t:IsA("BasePart") then
            if t.Transparency ~= 1 then
                local Y = (o - t.Position).Magnitude
                if Y < Z then
                    j = t
                    Z = Y
                end
            end
        end
    end
    return j
end

local playerss = game:GetService("Players")
local function l(o)
    if o == true or not o or o == "" or not playerss or not o.Character then
        return
    end
    for Y, j in pairs(playerss:GetPlayers()) do
        if o.Name == j.Name then
            return not j.Dead and not j.Killed
        end
    end
end



local murdero = false
local Toggle = Tabs.Autofarm:AddToggle("MyToggle", 
{
    Title = "Farm Coins Only 1 round", 
    Description = "NOT AUTO FARM",
    Default = false,
    Callback = function(o)
        local wasAutoFarming = true
        N.AutoFarm = o
        if o then
            (coroutine.wrap(function()
                while N.AutoFarm do
                    task.wait()
                    murdero = true
                    local Y
                    if N.CoinType == "Coin" then
                        Y = N.CoinBag ~= 40
                    elseif N.CoinType == "BeachBall" then
                        Y = N. BeachBallBag ~= 20
                    elseif N.CoinType == "Coin and BeachBall" then
                        Y = N.CoinBag ~= 40 and N.BeachBallBag ~= 20
                    end
                    if murdero then
						local o = QK()
						if o and N.PreviousCoin ~= o then
							local Y = o.CFrame
							local j = h(D)
							local t = (h(D)).Position
							local K = (Y.Position - t).Magnitude
							local U = N.FarmSpeedMethod == "Automatic" and (N.FastFarm and K * .0385 or K * .0415) or N.FarmSpeedMethod == "Manual" and tonumber(N.ManualSpeed)
							local r = N.SafeMode
							local G = 0
							local T = 0
							local J
							N.PreviousCoin = o
							N.FarmSTOP = false
							if U >= 10 then
								U = 3
							end

							if r then
								local o = ZK()
								if o then
									local j = nil
									local Z = nil
									for o, Y in pairs(o.Spawns:GetChildren()) do
										if Y.Name == "Spawn" or Y.Name == "PlayerSpawn" then
											Z = CFrame.new(Y.CFrame.X, Y.CFrame.Y, Y.CFrame.Z) * CFrame.Angles(0, 0, 0)
										end
									end
									if Z ~= nil then
										j = CFrame.new(Z.X, (CFrame.new((DK((Z * CFrame.new(0, -999, 0)).Position, o)).Position) * CFrame.new(0, -20, 0)).Y, Z.Z)
										if j ~= nil then
											G = {
												Y.X;
												j.Y,
												Y.Z
											}
											T = j.Y
										end
									end
								end
							else
								G = {
									Y.X;
									Y.Y - 1.875;
									Y.Z
								}
							end
							if r then
								m(D, "CFrame", CFrame.new(j.CFrame.X, T, j.CFrame.Z) * CFrame.Angles(math.rad(90), 0, math.rad(90)))
							end
							J = CFrame.new(G[1], G[2], G[3]) * CFrame.Angles(math.rad(90), 0, math.rad(90))
							N.CurrentTween = Z:Create(h(D), TweenInfo.new(U, Enum.EasingStyle.Linear, N.SmoothFarm), {
								CFrame = J
							})
							N.CurrentTween:Play()
							task.wait(U + .1)
							if N.CurrentTween then
								if r then
									m(D, "CFrame", CFrame.new(Y.X, Y.Y - 1.875, Y.Z) * CFrame.Angles(math.rad(90), 0, math.rad(90)))
								end
							end
						end
					else
                        print("lol")
						--[[if not N.FarmSTOP and (D and (D.Character and l(D))) then
							N.FarmSTOP = true
							N.NoReplicateCoin = 0

							if l(D) then
								if N.TpWhenDone == "Map" then
									local o = ZK()
									if o then
										local Y = nil
										local j = nil
										for o, Y in pairs(o.Spawns:GetChildren()) do
											if Y.Name == "Spawn" or Y.Name == "PlayerSpawn" then
												j = CFrame.new(Y.CFrame.X, Y.CFrame.Y, Y.CFrame.Z) * CFrame.Angles(0, 0, 0)
											end
										end
										if j ~= nil then
											Y = j * CFrame.new(0, 5, 0)
											if Y ~= nil then
												m(D, "CFrame", Y)
											else
												if N.OldPos ~= nil then
													m(D, "CFrame", N.OldPos)
													N.OldPos = nil
												end
											end
										end
									end
								elseif N.TpWhenDone == "Lobby" then
									local o = CFrame.new(-110, 140, 10)
									m(D, "CFrame", o)
									N.OldPos = nil
								elseif N.TpWhenDone == "Void (Safe)" then
									local o = CFrame.new(99999, 99999, 99999)
									m(D, "CFrame", o)
									if not D.Character:FindFirstChild("Safe Void Path") then
										local o = Instance.new("Part")
										o.Name = "Safe Void Path"
										o.Parent = D.Character
										o.CFrame = CFrame.new(99999, 99995, 99999)
										o.Anchored = true
										o.Size = Vector3.new(300, .1, 300)
										o.Transparency = .5
									end
									N.OldPos = nil
								elseif N.TpWhenDone == "Above Map" then
									local o = ZK()
									if o then
										local Y = nil
										local j = nil
										for o, Y in pairs(o.Spawns:GetChildren()) do
											if Y.Name == "Spawn" or Y.Name == "PlayerSpawn" then
												j = CFrame.new(Y.CFrame.X, Y.CFrame.Y, Y.CFrame.Z) * CFrame.Angles(0, 0, 0)
											end
										end
										if j ~= nil then
											Y = CFrame.new(j.X, (CFrame.new((DK((j * CFrame.new(0, 999, 0)).Position, o)).Position) * CFrame.new(0, 3, 0)).Y, j.Z)
											if Y ~= nil then
												m(D, "CFrame", Y)
											else
												if N.OldPos ~= nil then
													m(D, "CFrame", N.OldPos)
													N.OldPos = nil
												end
											end
										end
									end
								end
								if N.ResetWhenDone then
									D.Character.Humanoid.Health = 0
								end
							end
						end]]
					end
				end
            end))()
        else
            if wasAutoFarming and N.AutoFarm then

                
                N.FarmSTOP = true
                murdero = false

                if D.Character.Head:FindFirstChild("Auto Farm Gyro") and D.Character.Head:FindFirstChild("Auto Farm Velocity") then
                    for _, Y in pairs(D.Character:GetChildren()) do
                        if Y:IsA("BasePart") and (Y.Name == "Head" or string.match(Y.Name, "Torso")) then
                            for _, part in pairs(Y:GetChildren()) do
                                if part.Name == "Auto Farm Velocity" or part.Name == "Auto Farm Gyro" then
                                    part:Destroy()
                                end
                            end
                        end
                    end
                    D.Character.Humanoid.PlatformStand = false
                end
                

                N.CollectedCoins = 0
                N.NoReplicateCoin = 0
                N.CurrentCoin = nil
                if N.CurrentTween then
                    N.CurrentTween:Pause()
                    N.CurrentTween = nil
                    task.wait(0.15)
                end
                
                --[[if N.TpWhenDone == "Map" then
                    local o = ZK()
                    if o then
                        local Y = nil
                        local j = nil
                        for o, Y in pairs(o.Spawns:GetChildren()) do
                            if Y.Name == "Spawn" or Y.Name == "PlayerSpawn" then
                                j = CFrame.new(Y.CFrame.X, Y.CFrame.Y, Y.CFrame.Z) * CFrame.Angles(0, 0, 0)
                            end
                        end
                        if j ~= nil then
                            Y = j * CFrame.new(0, 5, 0)
                            if Y ~= nil then
                                m(D, "CFrame", Y)
                            else
                                if N.OldPos ~= nil then
                                    m(D, "CFrame", N.OldPos)
                                    N.OldPos = nil
                                end
                            end
                        end
                    end
                elseif N.TpWhenDone == "Lobby" then
                    local o = CFrame.new(-110, 140, 10)
                    m(D, "CFrame", o)
                    N.OldPos = nil
                elseif N.TpWhenDone == "Void (Safe)" then
                    local o = CFrame.new(99999, 99999, 99999)
                    m(D, "CFrame", o)
                    if not D.Character:FindFirstChild("Safe Void Path") then
                        local o = Instance.new("Part")
                        o.Name = "Safe Void Path"
                        o.Parent = D.Character
                        o.CFrame = CFrame.new(99999, 99995, 99999)
                        o.Anchored = true
                        o.Size = Vector3.new(300, 0.1, 300)
                        o.Transparency = 0.5
                    end
                    N.OldPos = nil
                elseif N.TpWhenDone == "Above Map" then
                    local o = ZK()
                    if o then
                        local Y = nil
                        local j = nil
                        for o, Y in pairs(o.Spawns:GetChildren()) do
                            if Y.Name == "Spawn" or Y.Name == "PlayerSpawn" then
                                j = CFrame.new(Y.CFrame.X, Y.CFrame.Y, Y.CFrame.Z) * CFrame.Angles(0, 0, 0)
                            end
                        end
                        if j ~= nil then
                            Y = CFrame.new(j.X, (CFrame.new((DK((j * CFrame.new(0, 999, 0)).Position, o)).Position) * CFrame.new(0, 3, 0)).Y, j.Z)
                            if Y ~= nil then
                                m(D, "CFrame", Y)
                            else
                                if N.OldPos ~= nil then
                                    m(D, "CFrame", N.OldPos)
                                    N.OldPos = nil
                                end
                            end
                        end
                    end
                end]]
            end
        end
    end 
})

Tabs.Credits:AddButton({
    Title = "Youtube Channel",
    Description = "Copy Link",
    Callback = function()
        setclipboard("https://youtube.com/@snapsan?si=ZF3AY7iivGUnTpOc")
        game.StarterGui:SetCore("SendNotification", {
            Title = "SnapSanix Hub";
            Text = "Youtube Channel Link Copy To Clipboard";
            Icon = "http://www.roblox.com/asset/?id=17816113278";
            Duration = 5;
        })
    end
})
Tabs.Credits:AddButton({
    Title = "Discord Server",
    Description = "Copy Link",
    Callback = function()
        setclipboard("https://discord.gg/3EjQ4mgSqj")
        game.StarterGui:SetCore("SendNotification", {
            Title = "SnapSanix Hub";
            Text = "Discord Server Link Copy To Clipboard";
            Icon = "http://www.roblox.com/asset/?id=17816113278";
            Duration = 5;
        })
    end
})

Tabs.Credits:AddButton({
    Title = "Report Errors",
    Description = "Google Forms",
    Callback = function()
        setclipboard("https://forms.gle/kLxHBZfa9E58Vx5p8")
        Fluent:Notify({
            Title = "SnapSanix Hub",
            Content = "Link Copy to ClipBoard",
            SubContent = "",
            Duration = 8
        })
    end
})

Tabs.Credits:AddParagraph({
    Title = "Script Сreator",
    Content = "My Discord snapsan_"
})

Tabs.Credits:AddParagraph({
    Title = "Important information",
    Content = "Thanks to Pecthicial for some of the scripts. Use r3th priv1 it's a good script too."
})


InterfaceManager:SetLibrary(Fluent)

InterfaceManager:SetFolder("SnapSanixHub")


InterfaceManager:BuildInterfaceSection(Tabs.Settings)

Window:SelectTab(1)


print("SnapSanix Hub Loaded✅")

local SSeeCoin = false

local function addESP(coin)
    local visual = coin:FindFirstChild("CoinVisual")
    if visual and not coin:FindFirstChild("ESP") then
        local partgui = Instance.new("BillboardGui")
        partgui.Size = UDim2.new(1.2, 0, 1.2, 0)
        partgui.AlwaysOnTop = true
        partgui.Name = "ESP"
        partgui.Parent = coin

        local frame = Instance.new("Frame")
        frame.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
        frame.Size = UDim2.new(1.2, 0, 1.2, 0)
        frame.BorderSizePixel = 0
        frame.Parent = partgui
        frame.BackgroundTransparency = 0.3
    end
end

local function highlightCoin()
    while SSeeCoin do
        repeat wait() until workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("CoinContainer")

        local murderr = GetMurder()
        local coinContainer = workspace.Normal.CoinContainer
        for _, coin in pairs(coinContainer:GetChildren()) do
            if coin.Name == "Coin_Server" then
                if coin:FindFirstChild("TouchInterest") then
                    if not coin:FindFirstChild("ESP") and murderr then
                        addESP(coin)
                    elseif coin:FindFirstChild("ESP") and not murderr then
                        coin.ESP:Destroy()
                    end
                end
            end
        end
        wait()
        
        local O = game:GetService("Players")
        local D = O.LocalPlayer

        local o = D and (D.PlayerGui and (D.PlayerGui.MainGUI and (D.PlayerGui.MainGUI.Game and (D.PlayerGui.MainGUI.Game.CoinBags and (D.PlayerGui.MainGUI.Game.CoinBags and (D.PlayerGui.MainGUI.Game.CoinBags.Container and (D.PlayerGui.MainGUI.Game.CoinBags.Container.Coin and (D.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.CurrencyFrame and (D.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.CurrencyFrame.Icon and D.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.CurrencyFrame.Icon.Coins)))))))))

        if tonumber(o.Text) >= bag then
            local coinContainer = workspace.Normal.CoinContainer
            for _, coin in pairs(coinContainer:GetChildren()) do
                if coin.Name == "Coin_Server" then
                    if coin:FindFirstChild("ESP") then
                        coin.ESP:Destroy()
                    end
                end
            end
        end
    end
end

local function deleteCoin()
    repeat wait() until workspace:FindFirstChild("Normal") and workspace.Normal:FindFirstChild("CoinContainer")
    
    local coinContainer = workspace.Normal.CoinContainer
    for _, coin in pairs(coinContainer:GetChildren()) do
        if coin.Name == "Coin_Server" then
            if coin:FindFirstChild("ESP") then
                coin.ESP:Destroy()
            end
        end
    end
end

local Toggle = Tabs.ESP:AddToggle("MyToggle", {
    Title = "Esp Coins",
    Description = "",
    Default = false,
    Callback = function(coinESP)
        if coinESP then
            SSeeCoin = true
            spawn(highlightCoin)
        else
            SSeeCoin = false
            task.wait(0.2)
            deleteCoin()
        end
    end
})
