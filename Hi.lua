getgenv().v1 = {
    Enabled = true,
    TargetPart = "Hitbox_Head",
    FieldOfView = 300,
    HitChance = 100,
    Flags = {},
    Settings = {
        ShowBoxes = true,
        BoxMode = "Full",
        BoxFill = false,
        BoxFillTransparency = 0.5,
        ShowFOV = false,
        ShowNames = true,
        ShowHealth = true,
        ShowSkeletons = false,
        ShowChams = true,
        ShowStats = true
    },
    Guns = {
        Enabled = true,
        FireRateRodifer = true,
        Firerate = 100,
        NoSpread = true,
        NoRecoil = true
    },
    Colors = {
        Accent = Color3.fromRGB(165, 255, 0),
        BoxColor = Color3.fromRGB(255, 255, 255),
        BoxFillColor = Color3.fromRGB(255, 255, 255),
        SkeletonColor = Color3.fromRGB(255, 255, 255),
        TargetColor = Color3.fromRGB(0, 191, 255),
        FOVColor = Color3.fromRGB(255, 255, 255),
        NameColor = Color3.fromRGB(255, 255, 255),
        HealthTextColor = Color3.fromRGB(255, 255, 255),
        StatsColor = Color3.fromRGB(255, 255, 255),
        ChamsColor = Color3.fromRGB(0, 191, 255)
    }
}

local v2 = game:GetService("Players")
local v3 = game:GetService("RunService")
local v4 = game:GetService("ReplicatedStorage")
local v5 = v2.LocalPlayer
local v6 = v5:GetMouse()
local v7 = workspace.CurrentCamera
local v8 = v4:WaitForChild("Common")
local v9 = v8:WaitForChild("Components")
local v10 = v9:WaitForChild("FastCastRedux")
local v11 = require(v10:WaitForChild("ActiveCast"))

local functions = {}

local v12 = Drawing.new("Circle")
v12.Thickness = 1
v12.NumSides = 100
v12.Filled = false

local v_stats = Drawing.new("Text")
v_stats.Size = 18
v_stats.Outline = true
v_stats.Center = false
v_stats.Position = Vector2.new(20, 20)

local v13 = {}

function functions.create(v15, v16)
    local v17 = Drawing.new(v15)
    for v18, v19 in pairs(v16) do
        v17[v18] = v19
    end
    return v17
end

function functions.init(v24)
    if v13[v24] then
        return
    end
    local v25 = {
        BoxOutline = functions.create("Square", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false}),
        Box = functions.create("Square", {Thickness = 1, Color = getgenv().v1.Colors.BoxColor, Visible = false}),
        BoxFill = functions.create(
            "Square",
            {Filled = true, Transparency = getgenv().v1.Settings.BoxFillTransparency, Visible = false}
        ),
        Corners = {},
        CornerOutlines = {},
        HealthBarOutline = functions.create(
            "Square",
            {Thickness = 1, Color = Color3.new(0, 0, 0), Filled = true, Visible = false}
        ),
        HealthBar = functions.create(
            "Square",
            {Thickness = 1, Color = Color3.new(0, 1, 0), Filled = true, Visible = false}
        ),
        HealthText = functions.create(
            "Text",
            {Size = 13, Center = true, Outline = true, Color = getgenv().v1.Colors.HealthTextColor, Visible = false}
        ),
        Name = functions.create(
            "Text",
            {Size = 14, Center = true, Outline = true, Color = getgenv().v1.Colors.NameColor, Visible = false}
        ),
        Skeleton = {},
        Chams = Instance.new("Highlight")
    }

    for v26 = 1, 8 do
        v25.CornerOutlines[v26] =
            functions.create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false})
        v25.Corners[v26] =
            functions.create("Line", {Thickness = 1, Color = getgenv().v1.Colors.BoxColor, Visible = false})
    end

    v25.Chams.FillColor = getgenv().v1.Colors.ChamsColor
    v25.Chams.OutlineTransparency = 1
    v25.Chams.FillTransparency = 0.5
    v25.Chams.Parent = v24

    local v_bones = {
        {"Head", "UpperTorso"},
        {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"},
        {"UpperTorso", "RightUpperArm"},
        {"LeftUpperArm", "LeftLowerArm"},
        {"RightUpperArm", "RightLowerArm"},
        {"LowerTorso", "LeftUpperLeg"},
        {"LowerTorso", "RightUpperLeg"},
        {"LeftUpperLeg", "LeftLowerLeg"},
        {"RightUpperLeg", "RightLowerLeg"}
    }

    for _, bone in pairs(v_bones) do
        local v_id = bone[1] .. bone[2]
        v25.Skeleton[v_id .. "Outline"] =
            functions.create("Line", {Thickness = 3, Color = Color3.new(0, 0, 0), Visible = false})
        v25.Skeleton[v_id] =
            functions.create("Line", {Thickness = 1, Color = getgenv().v1.Colors.SkeletonColor, Visible = false})
    end
    v13[v24] = v25
end

function functions.get_target()
    local v32 = nil
    local v33 = getgenv().v1.FieldOfView
    for v34, v35 in pairs(workspace:GetChildren()) do
        local v36 = v35:FindFirstChild("Hitbox")
        local v37 = v35:FindFirstChildOfClass("Humanoid")
        if v36 and v37 and v37.Health > 0 and v35 ~= v5.Character then
            functions.init(v35)
            local v38 = v36:FindFirstChild(getgenv().v1.TargetPart)
            if v38 then
                local v39, v40 = v7:WorldToViewportPoint(v38.Position)
                if v40 then
                    local v41 = (Vector2.new(v6.X, v6.Y) - Vector2.new(v39.X, v39.Y)).Magnitude
                    if v41 < v33 then
                        v32 = v38
                        v33 = v41
                    end
                end
            end
        end
    end
    return v32
end

v3.RenderStepped:Connect(
    function()
        local v42 = functions.get_target()

        v_stats.Visible = getgenv().v1.Settings.ShowStats
        v_stats.Text = string.format("FOV: %d\nHitChance: %d%%", getgenv().v1.FieldOfView, getgenv().v1.HitChance)
        v_stats.Color = getgenv().v1.Colors.StatsColor

        v12.Visible = getgenv().v1.Settings.ShowFOV
        v12.Radius = getgenv().v1.FieldOfView
        v12.Position = Vector2.new(v6.X, v6.Y + 36)
        v12.Color = getgenv().v1.Colors.FOVColor

        for v43, v44 in pairs(v13) do
            local v45 = v43:FindFirstChildOfClass("Humanoid")
            local v46 =
                v43:FindFirstChild("HumanoidRootPart") or
                (v43:FindFirstChild("Hitbox") and v43.Hitbox:FindFirstChild("Hitbox_Torso"))
            local v47 = v42 and v42.Parent == (v43:FindFirstChild("Hitbox") or v43)

            if v45 and v45.Health > 0 and v46 then
                local v48, v49 = v7:WorldToViewportPoint(v46.Position)
                if v49 then
                    local v50 = 1000 / v48.Z
                    local v51 = Vector2.new(v50 * 2.5, v50 * 3.5)
                    local v52 = Vector2.new(v48.X - v51.X / 2, v48.Y - v51.Y / 2)
                    local v53 = math.floor((v7.CFrame.Position - v46.Position).Magnitude)

                    local v_box_c = v47 and getgenv().v1.Colors.TargetColor or getgenv().v1.Colors.BoxColor
                    local v_skel_c = v47 and getgenv().v1.Colors.TargetColor or getgenv().v1.Colors.SkeletonColor

                    v44.Box.Visible = getgenv().v1.Settings.ShowBoxes and getgenv().v1.Settings.BoxMode == "Full"
                    v44.Box.Size, v44.Box.Position, v44.Box.Color = v51, v52, v_box_c
                    v44.BoxOutline.Visible, v44.BoxOutline.Size, v44.BoxOutline.Position = v44.Box.Visible, v51, v52

                    v44.BoxFill.Visible = getgenv().v1.Settings.ShowBoxes and getgenv().v1.Settings.BoxFill
                    v44.BoxFill.Size, v44.BoxFill.Position = v51, v52
                    v44.BoxFill.Color, v44.BoxFill.Transparency =
                        getgenv().v1.Colors.BoxFillColor,
                        getgenv().v1.Settings.BoxFillTransparency

                    local v56 = getgenv().v1.Settings.ShowBoxes and getgenv().v1.Settings.BoxMode == "Corner"
                    for i = 1, 8 do
                        v44.Corners[i].Visible, v44.Corners[i].Color, v44.CornerOutlines[i].Visible = v56, v_box_c, v56
                    end

                    if v56 then
                        local w, h = v51.X / 4, v51.Y / 4
                        local pts = {
                            {v52, Vector2.new(v52.X + w, v52.Y)},
                            {v52, Vector2.new(v52.X, v52.Y + h)},
                            {Vector2.new(v52.X + v51.X, v52.Y), Vector2.new(v52.X + v51.X - w, v52.Y)},
                            {Vector2.new(v52.X + v51.X, v52.Y), Vector2.new(v52.X + v51.X, v52.Y + h)},
                            {Vector2.new(v52.X, v52.Y + v51.Y), Vector2.new(v52.X + w, v52.Y + v51.Y)},
                            {Vector2.new(v52.X, v52.Y + v51.Y), Vector2.new(v52.X, v52.Y + v51.Y - h)},
                            {Vector2.new(v52.X + v51.X, v52.Y + v51.Y), Vector2.new(v52.X + v51.X - w, v52.Y + v51.Y)},
                            {Vector2.new(v52.X + v51.X, v52.Y + v51.Y), Vector2.new(v52.X + v51.X, v52.Y + v51.Y - h)}
                        }
                        for i, p in ipairs(pts) do
                            v44.Corners[i].From, v44.Corners[i].To = p[1], p[2]
                            v44.CornerOutlines[i].From, v44.CornerOutlines[i].To = p[1], p[2]
                        end
                    end

                    v44.Name.Text, v44.Name.Position, v44.Name.Visible, v44.Name.Color =
                        string.format("%s [%d]", v43.Name, v53),
                        Vector2.new(v48.X, v52.Y - 16),
                        getgenv().v1.Settings.ShowNames,
                        getgenv().v1.Colors.NameColor
                    v44.HealthBarOutline.Visible, v44.HealthBarOutline.Size, v44.HealthBarOutline.Position =
                        getgenv().v1.Settings.ShowHealth,
                        Vector2.new(4, v51.Y + 2),
                        Vector2.new(v52.X - 6, v52.Y - 1)

                    local hp_ratio = math.clamp(v45.Health / v45.MaxHealth, 0, 1)
                    local hp_h = v51.Y * hp_ratio
                    v44.HealthBar.Visible, v44.HealthBar.Size, v44.HealthBar.Position =
                        getgenv().v1.Settings.ShowHealth,
                        Vector2.new(2, hp_h),
                        Vector2.new(v52.X - 5, v52.Y + (v51.Y - hp_h))
                    v44.HealthBar.Color = Color3.fromHSV(hp_ratio * 0.3, 1, 1)

                    v44.HealthText.Text, v44.HealthText.Position, v44.HealthText.Visible, v44.HealthText.Color =
                        tostring(math.floor(v45.Health)),
                        Vector2.new(v52.X - 5, v44.HealthBar.Position.Y),
                        getgenv().v1.Settings.ShowHealth and (v45.Health < v45.MaxHealth),
                        getgenv().v1.Colors.HealthTextColor

                    v44.Chams.Enabled, v44.Chams.FillColor =
                        getgenv().v1.Settings.ShowChams,
                        v47 and getgenv().v1.Colors.TargetColor or getgenv().v1.Colors.ChamsColor

                    local v_bones = {
                        {"Head", "UpperTorso"},
                        {"UpperTorso", "LowerTorso"},
                        {"UpperTorso", "LeftUpperArm"},
                        {"UpperTorso", "RightUpperArm"},
                        {"LeftUpperArm", "LeftLowerArm"},
                        {"RightUpperArm", "RightLowerArm"},
                        {"LowerTorso", "LeftUpperLeg"},
                        {"LowerTorso", "RightUpperLeg"},
                        {"LeftUpperLeg", "LeftLowerLeg"},
                        {"RightUpperLeg", "RightLowerLeg"}
                    }

                    for _, bone in pairs(v_bones) do
                        local v_id = bone[1] .. bone[2]
                        local v_l, v_o = v44.Skeleton[v_id], v44.Skeleton[v_id .. "Outline"]
                        local b1 =
                            v43:FindFirstChild(bone[1], true) or
                            (v43:FindFirstChild("Hitbox") and v43.Hitbox:FindFirstChild("Hitbox_" .. bone[1]))
                        local b2 =
                            v43:FindFirstChild(bone[2], true) or
                            (v43:FindFirstChild("Hitbox") and v43.Hitbox:FindFirstChild("Hitbox_" .. bone[2]))
                        if b1 and b2 then
                            local p1, s1 = v7:WorldToViewportPoint(b1.Position)
                            local p2, s2 = v7:WorldToViewportPoint(b2.Position)
                            if s1 and s2 then
                                v_l.From, v_l.To = Vector2.new(p1.X, p1.Y), Vector2.new(p2.X, p2.Y)
                                v_l.Color, v_l.Visible = v_skel_c, getgenv().v1.Settings.ShowSkeletons
                                v_o.From, v_o.To, v_o.Visible = v_l.From, v_l.To, v_l.Visible
                            else
                                v_l.Visible, v_o.Visible = false, false
                            end
                        else
                            v_l.Visible, v_o.Visible = false, false
                        end
                    end
                else
                    v44.Box.Visible,
                        v44.BoxOutline.Visible,
                        v44.BoxFill.Visible,
                        v44.Name.Visible,
                        v44.HealthBar.Visible,
                        v44.HealthBarOutline.Visible,
                        v44.HealthText.Visible,
                        v44.Chams.Enabled = false, false, false, false, false, false, false, false
                    for i = 1, 8 do
                        v44.Corners[i].Visible, v44.CornerOutlines[i].Visible = false, false
                    end
                    for _, s in pairs(v44.Skeleton) do
                        s.Visible = false
                    end
                end
            else
                v44.Box.Visible,
                    v44.BoxOutline.Visible,
                    v44.BoxFill.Visible,
                    v44.Name.Visible,
                    v44.HealthBar.Visible,
                    v44.HealthBarOutline.Visible,
                    v44.HealthText.Visible,
                    v44.Chams.Enabled = false, false, false, false, false, false, false, false
                for i = 1, 8 do
                    v44.Corners[i].Visible, v44.CornerOutlines[i].Visible = false, false
                end
                for _, s in pairs(v44.Skeleton) do
                    s.Visible = false
                end
                if not v43:IsDescendantOf(workspace) then
                    v44.Chams:Destroy()
                    v13[v43] = nil
                end
            end
        end
    end
)

local config = getgenv().v1
local gunConfig = config.Guns

local v1 = require(game:GetService("Players").LocalPlayer.PlayerScripts.Start.Game.WeaponClient.ClientWeapons._Standard)
local v2 = debug.getupvalues(v1.Shoot)

local function apply(target)
    if type(target) ~= "table" then
        return
    end
    local mt = getrawmetatable(target) or {__index = target}
    setreadonly(mt, false)
    local oldIdx = mt.__index

    mt.__index =
        newcclosure(
        function(t, k)
            if gunConfig.Enabled then
                if k == "firerate" and gunConfig.FireRateRodifer then
                    return gunConfig.Firerate
                end
                if (k == "maxSpread" or k == "minSpread") and gunConfig.NoSpread then
                    return 0
                end
                if k == "recoilFactor" and gunConfig.NoRecoil then
                    return 0
                end
            end
            if type(oldIdx) == "table" then
                return oldIdx[k]
            end
            if type(oldIdx) == "function" then
                return oldIdx(t, k)
            end
            return rawget(t, k)
        end
    )
    setreadonly(mt, true)
end

if type(v2) == "table" then
    for _, upv in pairs(v2) do
        if type(upv) == "table" then
            for _, weapon in pairs(upv) do
                if type(weapon) == "table" and (weapon.damage or weapon.magazine) then
                    apply(weapon)
                end
            end
        end
    end
end

local oldShoot = v1.Shoot
v1.Shoot =
    newcclosure(
    function(self, ...)
        if gunConfig.Enabled then
            local data = self:GetWeaponData()
            if data then
                if gunConfig.FireRateRodifer then
                    rawset(data, "firerate", gunConfig.Firerate)
                end
                if gunConfig.NoSpread then
                    rawset(data, "maxSpread", 0)
                    rawset(data, "minSpread", 0)
                end
                if gunConfig.NoRecoil then
                    rawset(data, "recoilFactor", 0)
                end
            end
            self.shootCount = 0
            self.state = "free"
        end
        return oldShoot(self, 0, select(2, ...))
    end
)

local v72 = v11.new
v11.new = function(v73, v74, v75, v76, v77)
    if getgenv().v1.Enabled and math.random(1, 100) <= getgenv().v1.HitChance then
        local v78 = functions.get_target()
        if v78 then
            local v79 = (v78.Position - v74).Unit
            local v80 = typeof(v76) == "number" and v76 or v76.Magnitude
            v75, v76 = v79, v79 * v80
        end
    end
    return v72(v73, v74, v75, v76, v77)
end
