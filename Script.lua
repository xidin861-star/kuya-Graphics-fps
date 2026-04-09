repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- 🎵 เสียงกด
local function clickSound()
    local s = Instance.new("Sound", workspace)
    s.SoundId = "rbxassetid://12222216"
    s.Volume = 1
    s:Play()
    game.Debris:AddItem(s,1)
end

-- 🌈 สร้างสีรุ้ง
local function rainbow(stroke)
    spawn(function()
        while stroke.Parent do
            for i=0,1,0.01 do
                stroke.Color = Color3.fromHSV(i,1,1)
                task.wait()
            end
        end
    end)
end

-- 📱 GUI หลัก
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

-- 🔘 ปุ่มวงกลม
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0,60,0,60)
toggleBtn.Position = UDim2.new(0,20,0.5,-30)
toggleBtn.Text = "FPS"
toggleBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Draggable = true

local uicorner = Instance.new("UICorner", toggleBtn)
uicorner.CornerRadius = UDim.new(1,0)

-- 🌈 ขอบวงกลม
local stroke1 = Instance.new("UIStroke", toggleBtn)
stroke1.Thickness = 2
rainbow(stroke1)

-- 📦 เมนู
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,300,0,220)
main.Position = UDim2.new(0.5,-150,0.5,-110)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.Visible = false
main.Active = true
main.Draggable = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0,10)
local stroke2 = Instance.new("UIStroke", main)
rainbow(stroke2)

-- ❌ ปิด
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255,0,0)

-- 🏷️ ชื่อ
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,30)
title.Text = "kuya Graphics fps"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)

-- 🔘 สร้างปุ่ม
local function makeBtn(text, posY)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(0.9,0,0,40)
    b.Position = UDim2.new(0.05,0,0,posY)
    b.Text = text.." : OFF"
    b.BackgroundColor3 = Color3.fromRGB(255,0,0)
    b.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", b)
    return b
end

local b1 = makeBtn("ลบเสื้อผ้า+หน้า",40)
local b2 = makeBtn("โลกดินน้ำมัน",90)
local b3 = makeBtn("ลบสิ่งไม่จำเป็น",140)

-- 📊 FPS
local fpsLabel = Instance.new("TextLabel", gui)
fpsLabel.Position = UDim2.new(1,-120,0,10)
fpsLabel.Size = UDim2.new(0,110,0,30)
fpsLabel.BackgroundColor3 = Color3.fromRGB(20,20,20)
fpsLabel.TextScaled = true
fpsLabel.TextColor3 = Color3.new(1,1,1)

local stroke3 = Instance.new("UIStroke", fpsLabel)
rainbow(stroke3)

local frames, last = 0, tick()
RunService.RenderStepped:Connect(function()
    frames += 1
    if tick()-last >= 1 then
        fpsLabel.Text = "FPS: "..frames
        frames = 0
        last = tick()
    end
end)

-- 🔘 เปิด/ปิด UI
toggleBtn.MouseButton1Click:Connect(function()
    clickSound()
    toggleBtn.Visible = false
    main.Visible = true
    main.Size = UDim2.new(0,0,0,0)
    TweenService:Create(main,TweenInfo.new(0.3),{Size=UDim2.new(0,300,0,220)}):Play()
end)

close.MouseButton1Click:Connect(function()
    clickSound()
    main.Visible = false
    toggleBtn.Visible = true
end)

-- 🧠 ฟังก์ชั่น
local function toggle(btn, func)
    local on = false
    btn.MouseButton1Click:Connect(function()
        clickSound()
        on = not on
        btn.Text = btn.Text:split(":")[1].." : "..(on and "ON" or "OFF")
        btn.BackgroundColor3 = on and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
        func(on)
    end)
end

-- 💇 ลบเสื้อผ้า+หน้า
toggle(b1,function(on)
    if on then
        for _,plr in pairs(Players:GetPlayers()) do
            if plr.Character then
                for _,v in pairs(plr.Character:GetDescendants()) do
                    if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("Decal") then
                        v:Destroy()
                    end
                end
            end
        end
    end
end)

-- 🌍 โลกดินน้ำมัน
toggle(b2,function(on)
    if on then
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            end
        end
    end
end)

-- 💥 ลบสิ่งไม่จำเป็น
toggle(b3,function(on)
    if on then
        for _,v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter")
            or v:IsA("Trail")
            or v:IsA("Beam")
            or v:IsA("Explosion")
            or v:IsA("Fire")
            or v:IsA("Smoke")
            or v:IsA("Sparkles")
            or v:IsA("Decal") then
                v:Destroy()
            end
        end
    end
end)

print("🔥 kuya Graphics fps โหลดแล้ว")
