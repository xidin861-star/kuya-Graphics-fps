repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- 🎵 เสียง
local function click()
    local s = Instance.new("Sound",workspace)
    s.SoundId = "rbxassetid://12222216"
    s.Volume = 1
    s:Play()
    game.Debris:AddItem(s,1)
end

-- 🌈 สีรุ้ง
local function rainbow(obj)
    task.spawn(function()
        while obj.Parent do
            for i=0,1,0.01 do
                obj.Color = Color3.fromHSV(i,1,1)
                task.wait()
            end
        end
    end)
end

-- 📱 GUI
local gui = Instance.new("ScreenGui",game.CoreGui)
gui.ResetOnSpawn = false

-- 🔘 วงกลม
local openBtn = Instance.new("TextButton",gui)
openBtn.Size = UDim2.new(0,60,0,60)
openBtn.Position = UDim2.new(0,20,0.5,-30)
openBtn.Text = "FPS"
openBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
openBtn.Draggable = true
Instance.new("UICorner",openBtn).CornerRadius = UDim.new(1,0)
local st1 = Instance.new("UIStroke",openBtn)
rainbow(st1)

-- 📦 เมนู
local main = Instance.new("Frame",gui)
main.Size = UDim2.new(0,0,0,0)
main.Position = UDim2.new(0.5,-170,0.5,-180)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.Visible = false
main.Active = true
main.Draggable = true
Instance.new("UICorner",main).CornerRadius = UDim.new(0,10)
local st2 = Instance.new("UIStroke",main)
rainbow(st2)

-- ❌ ปิด
local close = Instance.new("TextButton",main)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255,0,0)

-- 🏷️ ชื่อ
local title = Instance.new("TextLabel",main)
title.Size = UDim2.new(1,0,0,30)
title.Text = "kuya The graphics v1.00"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)

-- 🔘 ปุ่ม
local function btn(name,y)
    local b = Instance.new("TextButton",main)
    b.Size = UDim2.new(0.9,0,0,40)
    b.Position = UDim2.new(0.05,0,0,y)
    b.Text = name.." : OFF"
    b.BackgroundColor3 = Color3.fromRGB(255,0,0)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner",b)
    return b
end

local b1 = btn("ลบเสื้อผ้า+หน้า+ผม",40)
local b2 = btn("โลกดินน้ำมัน",90)
local b3 = btn("ลบต้นไม้+เอฟเฟค",140)
local b4 = btn("เวลา17:50+ตัวสว่าง",190)
local b5 = btn("โลกสีเดียว",240)
local b6 = btn("เอฟเฟคสีเดียว",290)

main.Size = UDim2.new(0,340,0,340)

-- 📊 FPS
local fps = Instance.new("TextLabel",gui)
fps.Position = UDim2.new(1,-130,0,10)
fps.Size = UDim2.new(0,120,0,30)
fps.BackgroundColor3 = Color3.fromRGB(20,20,20)
fps.TextScaled = true
local st3 = Instance.new("UIStroke",fps)
rainbow(st3)

local f,l=0,tick()
RunService.RenderStepped:Connect(function()
    f+=1
    if tick()-l>=1 then
        fps.Text="FPS: "..f
        f=0 l=tick()
    end
end)

-- 🔘 เปิด UI
openBtn.MouseButton1Click:Connect(function()
    click()
    openBtn.Visible=false
    main.Visible=true
    main.Size=UDim2.new(0,0,0,0)
    TweenService:Create(main,TweenInfo.new(0.3),{Size=UDim2.new(0,340,0,340)}):Play()
end)

close.MouseButton1Click:Connect(function()
    click()
    main.Visible=false
    openBtn.Visible=true
end)

-- 🔁 toggle
local function toggle(b,func)
    local on=false
    b.MouseButton1Click:Connect(function()
        click()
        on=not on
        b.Text=b.Text:split(":")[1].." : "..(on and "ON" or "OFF")
        b.BackgroundColor3=on and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
        func(on)
    end)
end

-- 💇 ลบผม+หน้า+เสื้อ
toggle(b1,function(on)
    if on then
        local function clean(c)
            for _,v in pairs(c:GetDescendants()) do
                if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("Decal") or v:IsA("Accessory") then
                    v:Destroy()
                end
            end
        end
        for _,p in pairs(Players:GetPlayers()) do
            if p.Character then clean(p.Character) end
            p.CharacterAdded:Connect(function(c) task.wait(1) clean(c) end)
        end
    end
end)

-- 🌍 ดินน้ำมัน + เอฟเฟคดินน้ำมัน
toggle(b2,function(on)
    if on then
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material=Enum.Material.Plastic
            end
            -- 🔥 เอฟเฟค = สีเดียว (เอาสีหลัก)
            if v:IsA("ParticleEmitter") then
                local col=v.Color.Keypoints[1].Value
                v.Color=ColorSequence.new(col)
            end
        end
    end
end)

-- 🌳 ลบต้นไม้ + เอฟเฟคหนัก
toggle(b3,function(on)
    if on then
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter")
            or v:IsA("Trail")
            or v:IsA("Beam")
            or v:IsA("Explosion") then
                v:Destroy()
            end
            if v:IsA("BasePart") then
                local n=v.Name:lower()
                if n:find("tree") or n:find("grass") then
                    v:Destroy()
                end
            end
        end
    end
end)

-- 🌇 เวลา + ตัวสว่าง
toggle(b4,function(on)
    if on then
        Lighting.ClockTime=17.83
        Lighting.Brightness=3
        Lighting.GlobalShadows=false

        for _,p in pairs(Players:GetPlayers()) do
            if p.Character then
                local h=Instance.new("Highlight",p.Character)
                h.FillColor=Color3.new(1,1,1)
            end
        end
    end
end)

-- 🎨 โลกสีเดียว
toggle(b5,function(on)
    if on then
        local color=Color3.fromRGB(0,170,255) -- เปลี่ยนสีได้
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Color=color
            end
        end
    end
end)

-- 🎨 เอฟเฟคสีเดียว
toggle(b6,function(on)
    if on then
        local color=Color3.fromRGB(0,170,255)
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") then
                v.Color=ColorSequence.new(color)
            end
        end
    end
end)

print("🔥 kuya Graphics โหลดแล้ว")
