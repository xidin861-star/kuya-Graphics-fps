repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- 🎵 เสียง
local function click()
	local s = Instance.new("Sound", workspace)
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
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

-- 🔘 ปุ่มวงกลม
local circle = Instance.new("TextButton", gui)
circle.Size = UDim2.new(0,60,0,60)
circle.Position = UDim2.new(0,20,0.5,-30)
circle.Text = "FPS"
circle.BackgroundColor3 = Color3.fromRGB(30,30,30)
circle.TextColor3 = Color3.new(1,1,1)
circle.Draggable = true
Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)

local cStroke = Instance.new("UIStroke", circle)
rainbow(cStroke)

-- 📦 เมนู
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0,0,0,0)
main.Position = UDim2.new(0.5,-150,0.5,-120)
main.BackgroundColor3 = Color3.fromRGB(25,25,25)
main.Visible = false
main.Active = true
main.Draggable = true
Instance.new("UICorner", main)

local mStroke = Instance.new("UIStroke", main)
rainbow(mStroke)

-- ❌ ปิด
local close = Instance.new("TextButton", main)
close.Size = UDim2.new(0,30,0,30)
close.Position = UDim2.new(1,-35,0,5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(255,0,0)

-- 🏷️ ชื่อ
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,30)
title.Text = "kuya The graphics v1.00"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)

-- 🔘 สร้างปุ่ม
local function newBtn(text,y)
	local b = Instance.new("TextButton", main)
	b.Size = UDim2.new(0.9,0,0,40)
	b.Position = UDim2.new(0.05,0,0,y)
	b.Text = text.." : OFF"
	b.BackgroundColor3 = Color3.fromRGB(255,0,0)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b)
	return b
end

local b1 = newBtn("ลบเสื้อผ้า+หน้า+ผม",40)
local b2 = newBtn("โลกดินน้ำมัน",90)
local b3 = newBtn("ลบต้นไม้+เอฟเฟค",140)
local b4 = newBtn("ท้องฟ้า17:50+ตัวสว่าง",190)

main.Size = UDim2.new(0,300,0,240)

-- 📊 FPS
local fps = Instance.new("TextLabel", gui)
fps.Position = UDim2.new(1,-120,0,10)
fps.Size = UDim2.new(0,110,0,30)
fps.BackgroundColor3 = Color3.fromRGB(20,20,20)
fps.TextScaled = true

local fStroke = Instance.new("UIStroke", fps)
rainbow(fStroke)

local f,last=0,tick()
RunService.RenderStepped:Connect(function()
	f+=1
	if tick()-last>=1 then
		fps.Text="FPS: "..f
		f=0
		last=tick()
	end
end)

-- 🔘 เปิด UI
circle.MouseButton1Click:Connect(function()
	click()
	circle.Visible=false
	main.Visible=true
	main.Size=UDim2.new(0,0,0,0)
	TweenService:Create(main,TweenInfo.new(0.3),{Size=UDim2.new(0,300,0,240)}):Play()
end)

-- ❌ ปิด UI
close.MouseButton1Click:Connect(function()
	click()
	main.Visible=false
	circle.Visible=true
end)

-- 🔁 toggle
local function toggle(btn,func)
	local on=false
	btn.MouseButton1Click:Connect(function()
		click()
		on=not on
		btn.Text=btn.Text:split(":")[1].." : "..(on and "ON" or "OFF")
		btn.BackgroundColor3=on and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
		func(on)
	end)
end

-- 💇 ลบเสื้อผ้า+หน้า+ผม
toggle(b1,function(on)
	if on then
		local function clean(c)
			for _,v in pairs(c:GetDescendants()) do
				if v:IsA("Shirt") or v:IsA("Pants") or v:IsA("Decal") then v:Destroy() end
				if v:IsA("Accessory") then v:Destroy() end
			end
		end
		for _,p in pairs(Players:GetPlayers()) do
			if p.Character then clean(p.Character) end
			p.CharacterAdded:Connect(function(c) task.wait(1) clean(c) end)
		end
	end
end)

-- 🌍 โลกดินน้ำมัน + เอฟเฟคดินน้ำมัน
toggle(b2,function(on)
	if on then
		for _,v in pairs(workspace:GetDescendants()) do
			if v:IsA("BasePart") then
				v.Material = Enum.Material.Plastic
				v.Color = Color3.fromRGB(150,150,150)
				v.Reflectance = 0
			end
			-- เอฟเฟคให้เรียบ
			if v:IsA("ParticleEmitter") or v:IsA("Trail") then
				v.Lifetime = NumberRange.new(0)
			end
		end
	end
end)

-- 💥 ลบต้นไม้+เอฟเฟคหนัก
toggle(b3,function(on)
	if on then
		local function remove(v)
			if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam")
			or v:IsA("Explosion") or v:IsA("Fire") or v:IsA("Smoke") then
				v:Destroy()
			end

			if v:IsA("BasePart") then
				local n=v.Name:lower()
				if n:find("tree") or n:find("grass") or n:find("leaf") then
					v:Destroy()
				end
			end
		end

		for _,v in pairs(workspace:GetDescendants()) do remove(v) end
		workspace.DescendantAdded:Connect(function(v) task.wait() remove(v) end)
	end
end)

-- 🌇 เวลา + ตัวสว่าง
toggle(b4,function(on)
	if on then
		Lighting.ClockTime = 17.83
		Lighting.Brightness = 2
		Lighting.GlobalShadows = false

		for _,p in pairs(Players:GetPlayers()) do
			if p.Character then
				local h = Instance.new("Highlight", p.Character)
				h.FillColor = Color3.new(1,1,1)
				h.FillTransparency = 0.5
			end
		end
	end
end)

print("🔥 kuya The graphics v1.00 โหลดแล้ว")
