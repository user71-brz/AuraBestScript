-- Minificado: Aura AutoWin + ESP (vermelha) + GUI
local p=game.Players.LocalPlayer
local w=workspace
local s=game.Players
local hrp
p.CharacterAdded:Connect(function(c) hrp=c:WaitForChild("HumanoidRootPart") end)
if p.Character then hrp=p.Character:WaitForChild("HumanoidRootPart") end
local wins=p:WaitForChild("leaderstats"):WaitForChild("Wins")
local win0=wins.Value; local sess=0
local WIN_POS=Vector3.new(-222,341,126)
local LAP_POS=Vector3.new(-220,342,110)
local AUTO_WIN_DELAY=55
local auto=false; local espE=false

-- GUI
local g=Instance.new("ScreenGui",p:WaitForChild("PlayerGui"))
g.Name="AuraAutoWin"
local f=Instance.new("Frame",g);f.Size=UDim2.new(0,260,0,270);f.Position=UDim2.new(0.05,0,0.2,0);f.BackgroundColor3=Color3.fromRGB(20,20,20)
Instance.new("UICorner",f).CornerRadius=UDim.new(0,8)
Instance.new("UIStroke",f).Color=Color3.fromRGB(0,255,255)
local h=Instance.new("TextButton",f)
h.Size=UDim2.new(1,0,0,35);h.Text="Ability Tower v2";h.Font=Enum.Font.GothamBold;h.TextSize=16;h.TextColor3=Color3.fromRGB(0,255,255);h.BackgroundColor3=Color3.fromRGB(30,30,30);h.AutoButtonColor=false
Instance.new("UICorner",h).CornerRadius=UDim.new(0,8)
local cont=Instance.new("Frame",f);cont.Size=UDim2.new(1,0,1,-35);cont.Position=UDim2.new(0,0,0,35);cont.BackgroundTransparency=1
local vis=true
h.MouseButton1Click:Connect(function() vis=not vis cont.Visible=vis f.Size=vis and UDim2.new(0,260,0,270) or UDim2.new(0,260,0,35) end)

local function btn(t,y)
 local b=Instance.new("TextButton",cont)
 b.Size=UDim2.new(1,-20,0,30);b.Position=UDim2.new(0,10,0,y);b.Text=t;b.Font=Enum.Font.Gotham;b.TextSize=14;b.TextColor3=Color3.new(1,1,1);b.BackgroundColor3=Color3.fromRGB(50,50,50)
 Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
 return b
end

local bLap=btn("TP to Lap",10)
bLap.MouseButton1Click:Connect(function() local r=hrp or (p.Character and p.Character:FindFirstChild("HumanoidRootPart")) if r then r.CFrame=CFrame.new(LAP_POS) end end)
local bWin=btn("TP to Win",50)
bWin.MouseButton1Click:Connect(function() local r=hrp or (p.Character and p.Character:FindFirstChild("HumanoidRootPart")) if r then r.CFrame=CFrame.new(WIN_POS) end end)

local bAuto=btn("Auto Win: OFF",90)
bAuto.MouseButton1Click:Connect(function()
 auto=not auto
 bAuto.Text="Auto Win: "..(auto and "ON" or "OFF")
 bAuto.BackgroundColor3=auto and Color3.fromRGB(0,170,0) or Color3.fromRGB(50,50,50)
 if auto then local r=hrp or p.Character and p.Character:FindFirstChild("HumanoidRootPart") if r then r.CFrame=CFrame.new(WIN_POS) end end
end)

local lblT=Instance.new("TextLabel",cont)
lblT.Size=UDim2.new(1,-20,0,20);lblT.Position=UDim2.new(0,10,0,130);lblT.Text="Próximo TP em: 0s";lblT.Font=Enum.Font.Gotham;lblT.TextSize=12;lblT.TextColor3=Color3.new(1,1,1);lblT.BackgroundTransparency=1
local lblW=Instance.new("TextLabel",cont)
lblW.Size=UDim2.new(1,-20,0,20);lblW.Position=UDim2.new(0,10,0,155)
lblW.Text="Vitórias farmadas ao total: 0";lblW.Font=Enum.Font.Gotham;lblW.TextSize=12;lblW.TextColor3=Color3.new(1,1,1);lblW.BackgroundTransparency=1

wins:GetPropertyChangedSignal("Value"):Connect(function()
 local d=wins.Value-win0
 if d>sess then sess=d;lblW.Text="Vitórias farmadas ao total: "..sess end
end)

local bESP=btn("ESP: OFF",185)
bESP.BackgroundColor3=Color3.fromRGB(50,50,50)
bESP.MouseButton1Click:Connect(function()
 espE=not espE
 bESP.Text="ESP: "..(espE and "ON" or "OFF")
 bESP.BackgroundColor3=espE and Color3.fromRGB(0,170,0) or Color3.fromRGB(50,50,50)
 for _,v in ipairs(w:GetDescendants()) do
   if (v:IsA("Highlight")and v.Name=="ESP_Highlight")or(v:IsA("BillboardGui")and v.Name=="ESP_NameTag")then v.Enabled=espE end
 end
end)

g.Players.PlayerAdded:Connect(function(pl)
 pl.CharacterAdded:Connect(function(c)
   task.wait(1)
   local hl=Instance.new("Highlight",c);hl.Name="ESP_Highlight";hl.FillTransparency=1;hl.OutlineColor=Color3.fromRGB(255,0,0);hl.OutlineTransparency=0;hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop;hl.Enabled=espE
   local tg=Instance.new("BillboardGui",c);tg.Name="ESP_NameTag";tg.Size=UDim2.new(0,100,0,20);tg.Adornee=c:WaitForChild("Head");tg.StudsOffset=Vector3.new(0,2.5,0);tg.Enabled=espE;local tl=Instance.new("TextLabel",tg);tl.Size=UDim2.new(1,0,1,0);tl.BackgroundTransparency=1;tl.Text=c.Name;tl.TextColor3=Color3.new(1,1,1);tl.Font=Enum.Font.Gotham;tl.TextSize=14
 end)
end)

task.spawn(function()
 while true do
   if auto then
     local r=hrp or p.Character and p.Character:FindFirstChild("HumanoidRootPart")
     if r then r.CFrame=CFrame.new(WIN_POS) end
     for i=AUTO_WIN_DELAY,0,-1 do
       if not auto then break end
       lblT.Text="Próximo TP em: "..i.."s"
       task.wait(1)
     end
   end
   task.wait(0.5)
 end
end)
print("✅ Carregado!")
