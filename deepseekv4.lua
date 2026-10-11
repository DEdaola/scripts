-- [[ TERMINAL_HUB — OPTIMIZED REDESIGN ]]

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")

local X = {
    Players=Players, LP=LP, PG=PG,
    Tween=game:GetService("TweenService"),
    UIS=game:GetService("UserInputService"),
    Light=game:GetService("Lighting"),
    Run=game:GetService("RunService"),
    VU=game:GetService("VirtualUser"),
    tabs={}, tabButtons={}, arrowFrames={}, ui={},
    tabMeta={PLAYER={h="PLAYER",t="[ PLAYER ]"},VISUAL={h="VISUAL",t="[ VISUAL ]"},SETTINGS={h="SETTINGS",t="[ SETTINGS ]"}},
    C={
        BG=Color3.fromRGB(8,8,8),CARD=Color3.fromRGB(15,15,15),CARD_ACT=Color3.fromRGB(13,25,18),
        BORDER=Color3.fromRGB(32,32,32),BORDER_ACT=Color3.fromRGB(0,190,100),
        GREEN=Color3.fromRGB(0,205,110),GREEN_BG=Color3.fromRGB(14,32,20),
        TEXT=Color3.fromRGB(200,200,200),TEXT_DIM=Color3.fromRGB(115,115,115),
        TEXT_MUTE=Color3.fromRGB(85,85,85),RED=Color3.fromRGB(200,60,60),
        RED_BG=Color3.fromRGB(26,14,14),BTN=Color3.fromRGB(10,10,10),
    },
}
local C = X.C
local Tween = X.Tween
local TI = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
X.TI = TI

do
    local HIDDEN = "???"
    local function hide(ch)
        local h = ch and ch:FindFirstChildOfClass("Humanoid")
        if h then h.DisplayName = HIDDEN end
    end
    if LP.Character then task.defer(hide, LP.Character) end
    LP.CharacterAdded:Connect(function(ch) task.defer(hide, ch) end)
end

for _, v in ipairs(PG:GetChildren()) do
    if v.Name == "HackerTerminalHub" then v:Destroy() end
end

-- ========== HELPERS ==========
do
    function X.styleCard(card)
        Instance.new("UICorner", card).CornerRadius = UDim.new(0,6)
        local s = Instance.new("UIStroke", card)
        s.Color = C.BORDER; s.Thickness = 1
        return s
    end
    function X.makeIcon(row, icon)
        local ic = Instance.new("TextLabel")
        ic.Size=UDim2.new(0,26,1,0); ic.Position=UDim2.new(0,10,0,0)
        ic.BackgroundTransparency=1; ic.TextColor3=C.GREEN; ic.Text=icon or "◉"
        ic.TextSize=14; ic.Font=Enum.Font.RobotoMono; ic.Parent=row
        return ic
    end
    function X.makeTitle(row, text, off)
        local t = Instance.new("TextLabel")
        t.Size=UDim2.new(1,off or -140,1,0); t.Position=UDim2.new(0,38,0,0)
        t.BackgroundTransparency=1; t.TextColor3=C.TEXT; t.Text=text
        t.TextSize=12; t.Font=Enum.Font.RobotoMono
        t.TextXAlignment=Enum.TextXAlignment.Left; t.Parent=row
        return t
    end
    function X.createToggleInput(tabName, name, defVal, order, cb, icon)
        local target = X.tabs[tabName]; if not target then return end
        local row = Instance.new("Frame")
        row.Size=UDim2.new(1,0,0,42); row.LayoutOrder=order
        row.BackgroundColor3=C.CARD; row.Parent=target
        local stroke = X.styleCard(row)
        X.makeIcon(row, icon); X.makeTitle(row, name, -190)
        local vb = Instance.new("TextBox")
        vb.Size=UDim2.new(0,48,0,24); vb.Position=UDim2.new(1,-132,0.5,-12)
        vb.BackgroundColor3=C.BTN; vb.TextColor3=C.TEXT; vb.Text=tostring(defVal)
        vb.TextSize=12; vb.Font=Enum.Font.RobotoMono; vb.ClearTextOnFocus=false
        vb.Parent=row
        Instance.new("UICorner", vb).CornerRadius=UDim.new(0,4)
        Instance.new("UIStroke", vb).Color=Color3.fromRGB(38,38,38)
        local tb = Instance.new("TextButton")
        tb.Size=UDim2.new(0,72,0,24); tb.Position=UDim2.new(1,-78,0.5,-12)
        tb.BackgroundColor3=C.BTN; tb.TextColor3=C.RED; tb.Text="[ OFF ]"
        tb.TextSize=11; tb.Font=Enum.Font.RobotoMono; tb.AutoButtonColor=false
        tb.Parent=row
        Instance.new("UICorner", tb).CornerRadius=UDim.new(0,4)
        local ts = Instance.new("UIStroke", tb)
        ts.Color=Color3.fromRGB(40,20,20)
        local en = false
        local function upd() cb(en, tonumber(vb.Text) or defVal) end
        tb.MouseButton1Click:Connect(function()
            en = not en
            if en then
                tb.Text="[ ON ]"
                Tween:Create(row,TI,{BackgroundColor3=C.CARD_ACT}):Play()
                Tween:Create(stroke,TI,{Color=C.BORDER_ACT,Thickness=1.2}):Play()
                Tween:Create(tb,TI,{BackgroundColor3=C.GREEN_BG,TextColor3=C.GREEN}):Play()
                Tween:Create(ts,TI,{Color=C.BORDER_ACT}):Play()
            else
                tb.Text="[ OFF ]"
                Tween:Create(row,TI,{BackgroundColor3=C.CARD}):Play()
                Tween:Create(stroke,TI,{Color=C.BORDER,Thickness=1}):Play()
                Tween:Create(tb,TI,{BackgroundColor3=C.BTN,TextColor3=C.RED}):Play()
                Tween:Create(ts,TI,{Color=Color3.fromRGB(40,20,20)}):Play()
            end
            upd()
        end)
        vb.FocusLost:Connect(upd)
    end
    function X.createToggle(tabName, name, order, cb, icon)
        local target = X.tabs[tabName]; if not target then return end
        local row = Instance.new("Frame")
        row.Size=UDim2.new(1,0,0,42); row.LayoutOrder=order
        row.BackgroundColor3=C.CARD; row.Parent=target
        local stroke = X.styleCard(row)
        X.makeIcon(row, icon); X.makeTitle(row, name, -140)
        local tb = Instance.new("TextButton")
        tb.Size=UDim2.new(0,72,0,24); tb.Position=UDim2.new(1,-82,0.5,-12)
        tb.BackgroundColor3=C.BTN; tb.TextColor3=C.RED; tb.Text="[ OFF ]"
        tb.TextSize=11; tb.Font=Enum.Font.RobotoMono; tb.AutoButtonColor=false
        tb.Parent=row
        Instance.new("UICorner", tb).CornerRadius=UDim.new(0,4)
        local ts = Instance.new("UIStroke", tb)
        ts.Color=Color3.fromRGB(40,20,20)
        local en = false
        tb.MouseButton1Click:Connect(function()
            en = not en
            if en then
                tb.Text="[ ON ]"
                Tween:Create(row,TI,{BackgroundColor3=C.CARD_ACT}):Play()
                Tween:Create(stroke,TI,{Color=C.BORDER_ACT,Thickness=1.2}):Play()
                Tween:Create(tb,TI,{BackgroundColor3=C.GREEN_BG,TextColor3=C.GREEN}):Play()
                Tween:Create(ts,TI,{Color=C.BORDER_ACT}):Play()
            else
                tb.Text="[ OFF ]"
                Tween:Create(row,TI,{BackgroundColor3=C.CARD}):Play()
                Tween:Create(stroke,TI,{Color=C.BORDER,Thickness=1}):Play()
                Tween:Create(tb,TI,{BackgroundColor3=C.BTN,TextColor3=C.RED}):Play()
                Tween:Create(ts,TI,{Color=Color3.fromRGB(40,20,20)}):Play()
            end
            cb(en)
        end)
    end
    function X.createButton(tabName, name, order, cb, icon)
        local target = X.tabs[tabName]; if not target then return end
        local row = Instance.new("Frame")
        row.Size=UDim2.new(1,0,0,42); row.LayoutOrder=order
        row.BackgroundColor3=C.CARD; row.Parent=target
        X.styleCard(row); X.makeIcon(row, icon); X.makeTitle(row, name, -140)
        local b = Instance.new("TextButton")
        b.Size=UDim2.new(0,82,0,24); b.Position=UDim2.new(1,-92,0.5,-12)
        b.BackgroundColor3=C.BTN; b.TextColor3=C.TEXT; b.Text="[ OPEN ]"
        b.TextSize=11; b.Font=Enum.Font.RobotoMono; b.AutoButtonColor=false
        b.Parent=row
        Instance.new("UICorner", b).CornerRadius=UDim.new(0,4)
        Instance.new("UIStroke", b).Color=Color3.fromRGB(45,45,45)
        b.MouseButton1Click:Connect(cb)
    end
end

-- ========== BUILD UI ==========
do
    local UIS, Run = X.UIS, X.Run
    function X.buildMainUI()
        local SG = Instance.new("ScreenGui")
        SG.Name="HackerTerminalHub"; SG.ResetOnSpawn=false
        SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; SG.Parent=PG
        local MF = Instance.new("Frame")
        MF.Size=UDim2.new(0,600,0,420); MF.Position=UDim2.new(0.5,-300,0.5,-210)
        MF.BackgroundColor3=C.BG; MF.BorderSizePixel=0; MF.Active=true
        MF.ClipsDescendants=true; MF.Parent=SG
        Instance.new("UICorner", MF).CornerRadius=UDim.new(0,8)
        local ms = Instance.new("UIStroke", MF)
        ms.Color=C.BORDER; ms.Thickness=1.2
        X.ui.mainFrame = MF
        local isOpen = true
        local anim = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local function toggleMenu()
            isOpen = not isOpen
            if isOpen then
                MF.Visible=true; MF.Size=UDim2.new(0,0,0,0); MF.Position=UDim2.new(0.5,0,0.5,0)
                Tween:Create(MF,anim,{Size=UDim2.new(0,600,0,420),Position=UDim2.new(0.5,-300,0.5,-210)}):Play()
            else
                local t = Tween:Create(MF,anim,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0)})
                t:Play(); t.Completed:Wait()
                if not isOpen then
                    MF.Visible=false; MF.Size=UDim2.new(0,600,0,420); MF.Position=UDim2.new(0.5,-300,0.5,-210)
                end
            end
        end
        X.ui.toggleMenu = toggleMenu
        UIS.InputBegan:Connect(function(i,p)
            if not p and (i.KeyCode==Enum.KeyCode.LeftAlt or i.KeyCode==Enum.KeyCode.RightAlt) then toggleMenu() end
        end)
        local TB = Instance.new("Frame")
        TB.Size=UDim2.new(1,0,0,34); TB.BackgroundColor3=Color3.fromRGB(11,11,11)
        TB.BorderSizePixel=0; TB.Parent=MF
        Instance.new("UICorner", TB).CornerRadius=UDim.new(0,8)
        local tm = Instance.new("Frame")
        tm.Size=UDim2.new(1,0,0,8); tm.Position=UDim2.new(0,0,1,-8)
        tm.BackgroundColor3=Color3.fromRGB(11,11,11); tm.BorderSizePixel=0; tm.Parent=TB
        local lg = Instance.new("TextLabel")
        lg.Size=UDim2.new(0,24,1,0); lg.Position=UDim2.new(0,12,0,0)
        lg.BackgroundTransparency=1; lg.TextColor3=C.GREEN; lg.Text="▶"
        lg.TextSize=14; lg.Font=Enum.Font.RobotoMono; lg.Parent=TB
        local ttl = Instance.new("TextLabel")
        ttl.Size=UDim2.new(1,-140,1,0); ttl.Position=UDim2.new(0,36,0,0)
        ttl.BackgroundTransparency=1; ttl.TextColor3=C.TEXT
        ttl.Text="TERMINAL_HUB   //   by 71033"; ttl.TextSize=12
        ttl.Font=Enum.Font.RobotoMono; ttl.TextXAlignment=Enum.TextXAlignment.Left; ttl.Parent=TB
        local function topBtn(text,col,hov,xoff)
            local b = Instance.new("TextButton")
            b.Size=UDim2.new(0,26,1,0); b.Position=UDim2.new(1,xoff,0,0)
            b.BackgroundTransparency=1; b.AutoButtonColor=false
            b.TextColor3=col; b.Text=text; b.TextSize=14
            b.Font=Enum.Font.RobotoMono; b.Parent=TB
            b.MouseEnter:Connect(function() Tween:Create(b,TI,{TextColor3=hov}):Play() end)
            b.MouseLeave:Connect(function() Tween:Create(b,TI,{TextColor3=col}):Play() end)
            return b
        end
        local mb = topBtn("—",C.TEXT_DIM,C.TEXT,-60)
        local cb2 = topBtn("✕",C.RED,Color3.fromRGB(255,110,110),-32)
        cb2.MouseButton1Click:Connect(function() if isOpen then toggleMenu() end end)
        mb.MouseButton1Click:Connect(function() if isOpen then toggleMenu() end end)
        local drag, ds, sp = false, Vector2.new(), UDim2.new()
        TB.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                drag=true; ds=UIS:GetMouseLocation(); sp=MF.Position
                local c
                c = UIS.InputEnded:Connect(function(e)
                    if e.UserInputType==Enum.UserInputType.MouseButton1 or e.UserInputType==Enum.UserInputType.Touch then
                        drag=false; if c then c:Disconnect() end
                    end
                end)
            end
        end)
        Run.RenderStepped:Connect(function()
            if drag then
                local m = UIS:GetMouseLocation()
                local d = m - ds
                MF.Position = UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
            end
        end)
        local SB = Instance.new("Frame")
        SB.Size=UDim2.new(0,148,1,-34); SB.Position=UDim2.new(0,0,0,34)
        SB.BackgroundColor3=Color3.fromRGB(10,10,10); SB.BorderSizePixel=0; SB.Parent=MF
        local sd = Instance.new("Frame")
        sd.Size=UDim2.new(0,1,1,0); sd.Position=UDim2.new(1,-1,0,0)
        sd.BackgroundColor3=C.BORDER; sd.BorderSizePixel=0; sd.Parent=SB
        local SL = Instance.new("UIListLayout", SB)
        SL.FillDirection=Enum.FillDirection.Vertical; SL.SortOrder=Enum.SortOrder.LayoutOrder
        SL.Padding=UDim.new(0,0)
        Instance.new("UIPadding", SB).PaddingTop=UDim.new(0,8)
        local CC = Instance.new("Frame")
        CC.Size=UDim2.new(1,-148,1,-34); CC.Position=UDim2.new(0,148,0,34)
        CC.BackgroundColor3=C.BG; CC.BorderSizePixel=0; CC.Parent=MF
        local CH = Instance.new("Frame")
        CH.Size=UDim2.new(1,0,0,42); CH.BackgroundColor3=Color3.fromRGB(10,10,10)
        CH.BorderSizePixel=0; CH.Parent=CC
        local chI = Instance.new("TextLabel")
        chI.Size=UDim2.new(0,30,1,0); chI.Position=UDim2.new(0,16,0,0)
        chI.BackgroundTransparency=1; chI.TextColor3=C.GREEN; chI.Text="◉"
        chI.TextSize=16; chI.Font=Enum.Font.RobotoMono; chI.Parent=CH
        local chL = Instance.new("TextLabel")
        chL.Size=UDim2.new(1,-60,1,0); chL.Position=UDim2.new(0,44,0,0)
        chL.BackgroundTransparency=1; chL.TextColor3=C.GREEN; chL.Text="VISUAL"
        chL.TextSize=14; chL.Font=Enum.Font.RobotoMono
        chL.TextXAlignment=Enum.TextXAlignment.Left; chL.Parent=CH
        local chT = Instance.new("TextLabel")
        chT.Size=UDim2.new(0,120,1,0); chT.Position=UDim2.new(1,-130,0,0)
        chT.BackgroundTransparency=1; chT.TextColor3=C.TEXT_DIM; chT.Text="[ VISUAL ]"
        chT.TextSize=11; chT.Font=Enum.Font.RobotoMono
        chT.TextXAlignment=Enum.TextXAlignment.Right; chT.Parent=CH
        local chLn = Instance.new("Frame")
        chLn.Size=UDim2.new(1,0,0,1); chLn.Position=UDim2.new(0,0,1,-1)
        chLn.BackgroundColor3=C.BORDER; chLn.BorderSizePixel=0; chLn.Parent=CH
        X.ui.chLabel = chL; X.ui.chTag = chT
        local function createTab()
            local sf = Instance.new("ScrollingFrame")
            sf.Size=UDim2.new(1,0,1,-42); sf.Position=UDim2.new(0,0,0,42)
            sf.BackgroundTransparency=1; sf.BorderSizePixel=0
            sf.CanvasSize=UDim2.new(0,0,0,0); sf.AutomaticCanvasSize=Enum.AutomaticSize.Y
            sf.ScrollBarThickness=3; sf.ScrollBarImageColor3=C.GREEN
            sf.ScrollBarImageTransparency=0.4; sf.Visible=false; sf.Parent=CC
            local p = Instance.new("UIPadding", sf)
            p.PaddingTop=UDim.new(0,10); p.PaddingBottom=UDim.new(0,10)
            p.PaddingLeft=UDim.new(0,12); p.PaddingRight=UDim.new(0,12)
            local l = Instance.new("UIListLayout", sf)
            l.SortOrder=Enum.SortOrder.LayoutOrder; l.Padding=UDim.new(0,7)
            return sf
        end
        X.tabs.PLAYER = createTab()
        X.tabs.VISUAL = createTab()
        X.tabs.SETTINGS = createTab()
        local function createTabBtn(name, order)
            local h = Instance.new("Frame")
            h.Size=UDim2.new(1,0,0,44); h.BackgroundTransparency=1
            h.LayoutOrder=order; h.Parent=SB
            local b = Instance.new("TextButton")
            b.Size=UDim2.new(1,-8,1,-4); b.Position=UDim2.new(0,4,0,2)
            b.BackgroundColor3=Color3.fromRGB(10,10,10); b.AutoButtonColor=false
            b.Text=""; b.BorderSizePixel=0; b.Parent=h
            Instance.new("UICorner", b).CornerRadius=UDim.new(0,6)
            local s = Instance.new("UIStroke", b)
            s.Color=Color3.fromRGB(20,20,20); s.Thickness=1
            local mk = Instance.new("Frame")
            mk.Size=UDim2.new(0,3,0.55,0); mk.Position=UDim2.new(0,0,0.225,0)
            mk.BackgroundColor3=C.GREEN; mk.BorderSizePixel=0
            mk.BackgroundTransparency=1; mk.Parent=b
            Instance.new("UICorner", mk).CornerRadius=UDim.new(1,0)
            local il = Instance.new("TextLabel")
            il.Size=UDim2.new(0,26,1,0); il.Position=UDim2.new(0,12,0,0)
            il.BackgroundTransparency=1; il.TextColor3=C.TEXT_DIM
            il.Text="◉"; il.TextSize=14; il.Font=Enum.Font.RobotoMono; il.Parent=b
            local nl = Instance.new("TextLabel")
            nl.Size=UDim2.new(1,-50,1,0); nl.Position=UDim2.new(0,42,0,0)
            nl.BackgroundTransparency=1; nl.TextColor3=C.TEXT_DIM
            nl.Text="[ "..name.." ]"; nl.TextSize=12
            nl.Font=Enum.Font.RobotoMono; nl.TextXAlignment=Enum.TextXAlignment.Left; nl.Parent=b
            X.tabButtons[name] = {Button=b, Stroke=s, Marker=mk, Icon=il, Label=nl}
            return b
        end
        local function switchTab(tabName)
            for n, tb in pairs(X.tabs) do tb.Visible = (n == tabName) end
            local meta = X.tabMeta[tabName]
            if meta then chL.Text = meta.h; chT.Text = meta.t end
            for n, d in pairs(X.tabButtons) do
                local act = (n == tabName)
                local tbg = act and C.GREEN_BG or Color3.fromRGB(10,10,10)
                local ts = act and C.BORDER_ACT or Color3.fromRGB(20,20,20)
                local tt = act and C.GREEN or C.TEXT_DIM
                Tween:Create(d.Button,TI,{BackgroundColor3=tbg}):Play()
                Tween:Create(d.Stroke,TI,{Color=ts,Thickness=act and 1.2 or 1}):Play()
                Tween:Create(d.Icon,TI,{TextColor3=tt}):Play()
                Tween:Create(d.Label,TI,{TextColor3=tt}):Play()
                Tween:Create(d.Marker,TI,{BackgroundTransparency=act and 0 or 1}):Play()
            end
        end
        X.switchTab = switchTab
        createTabBtn("PLAYER",1).MouseButton1Click:Connect(function() switchTab("PLAYER") end)
        createTabBtn("VISUAL",2).MouseButton1Click:Connect(function() switchTab("VISUAL") end)
        createTabBtn("SETTINGS",3).MouseButton1Click:Connect(function() switchTab("SETTINGS") end)
    end
end
X.buildMainUI()

-- ========== HORIZONTAL SCROLL ==========
do
    local HAT = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local STEP = 120
    local function updateCanvas(f)
        if not f or not f.Parent then return 0 end
        if f:FindFirstChild("ServerEmpty") then
            f.CanvasSize = UDim2.new(0, f.AbsoluteSize.X, 0, f.AbsoluteSize.Y)
            if math.abs(f.CanvasPosition.X) > 0.01 then f.CanvasPosition = Vector2.new(0,0) end
            return 0
        end
        local l = f:FindFirstChildOfClass("UIListLayout")
        if not l then return 0 end
        local w = l.AbsoluteContentSize.X
        local p = f:FindFirstChildOfClass("UIPadding")
        if p then w = w + p.PaddingLeft.Offset + p.PaddingRight.Offset end
        local cw = math.max(w + 10, f.AbsoluteSize.X)
        f.CanvasSize = UDim2.new(0, cw, 0, f.AbsoluteSize.Y)
        local mx = math.max(0, cw - f.AbsoluteSize.X)
        local cx = math.clamp(f.CanvasPosition.X, 0, mx)
        if math.abs(f.CanvasPosition.X - cx) > 0.01 then f.CanvasPosition = Vector2.new(cx, 0) end
        return mx
    end
    local function updateProgress(d)
        if not d or not d.frame or not d.frame.Parent then return end
        local f = d.frame
        local mx = updateCanvas(f)
        local cur = math.clamp(f.CanvasPosition.X, 0, mx)
        local can = mx > 1
        d.left.Visible = can and cur > 1
        d.right.Visible = can and cur < mx - 1
        if d.progressTrack and d.progressFill then
            d.progressTrack.Visible = true
            if can then
                local vw = math.max(f.AbsoluteSize.X, 1)
                local cw = vw + mx
                local tr = math.clamp(vw / cw, 0.16, 1)
                local tw = math.max(d.progressTrack.AbsoluteSize.X, 1)
                local th = math.max(10, tw * tr)
                local trav = math.max(0, tw - th)
                local pr = mx > 0 and (cur / mx) or 0
                d.progressFill.Size = UDim2.new(0, th, 1, 0)
                d.progressFill.Position = UDim2.new(0, trav * pr, 0, 0)
            else
                d.progressFill.Size = UDim2.new(0, 28, 1, 0)
                d.progressFill.Position = UDim2.new(0.5, -14, 0, 0)
            end
        end
    end
    local function scrollTo(f, tx)
        if not f or not f.Parent then return end
        local mx = updateCanvas(f)
        tx = math.clamp(tx, 0, mx)
        local d = X.arrowFrames[f]
        if d and d.tween then d.tween:Cancel() end
        if d then
            d.tween = Tween:Create(f, HAT, {CanvasPosition = Vector2.new(tx, 0)})
            d.tween:Play()
        else f.CanvasPosition = Vector2.new(tx, 0) end
    end
    local function makeArrow(p, f, text, side)
        local b = Instance.new("TextButton")
        b.Name = side == "left" and "ScrollLeft" or "ScrollRight"
        b.Size=UDim2.new(0,16,0,20)
        b.AnchorPoint = side == "left" and Vector2.new(0,0.5) or Vector2.new(1,0.5)
        local fp, fs = f.Position, f.Size
        local cy = fp.Y.Offset + (fs.Y.Offset * 0.5)
        b.Position = side == "left"
            and UDim2.new(fp.X.Scale, fp.X.Offset+1, fp.Y.Scale, cy)
            or UDim2.new(fp.X.Scale+fs.X.Scale, fp.X.Offset+fs.X.Offset-1, fp.Y.Scale, cy)
        b.BackgroundTransparency=1; b.BorderSizePixel=0; b.AutoButtonColor=false
        b.Text=text; b.TextColor3=C.TEXT_DIM; b.TextSize=13
        b.Font=Enum.Font.RobotoMono; b.ZIndex=20; b.Parent=p
        b.MouseEnter:Connect(function() Tween:Create(b,HAT,{TextColor3=C.GREEN}):Play() end)
        b.MouseLeave:Connect(function() Tween:Create(b,HAT,{TextColor3=C.TEXT_DIM}):Play() end)
        return b
    end
    function X.enableArrowScroll(f)
        if not f or X.arrowFrames[f] then return end
        f.Active=true; f.Selectable=false; f.ScrollingEnabled=false
        f.ScrollingDirection=Enum.ScrollingDirection.X
        f.AutomaticCanvasSize=Enum.AutomaticSize.None; f.ScrollBarThickness=0
        local p = f.Parent; if not p then return end
        local track = Instance.new("Frame")
        track.Name="HorizontalScrollTrack"
        track.Size=UDim2.new(f.Size.X.Scale, f.Size.X.Offset-8, 0, 2)
        track.Position=UDim2.new(f.Position.X.Scale, f.Position.X.Offset+4,
            f.Position.Y.Scale, f.Position.Y.Offset+f.Size.Y.Offset-2)
        track.BackgroundColor3=C.BORDER; track.BorderSizePixel=0
        track.ZIndex=19; track.Visible=false; track.Parent=p
        Instance.new("UICorner", track).CornerRadius=UDim.new(1,0)
        local fill = Instance.new("Frame")
        fill.Name="Thumb"; fill.Size=UDim2.new(0,28,1,0)
        fill.BackgroundColor3=C.GREEN; fill.BorderSizePixel=0; fill.ZIndex=20
        fill.Parent=track
        Instance.new("UICorner", fill).CornerRadius=UDim.new(1,0)
        local d = {frame=f, left=makeArrow(p,f,"‹","left"), right=makeArrow(p,f,"›","right"),
            progressTrack=track, progressFill=fill, tween=nil}
        X.arrowFrames[f] = d
        d.left.ZIndex = math.max(f.ZIndex+1, 20)
        d.right.ZIndex = math.max(f.ZIndex+1, 20)
        d.left.MouseButton1Click:Connect(function()
            if updateCanvas(f) > 0 then scrollTo(f, f.CanvasPosition.X - STEP) end
        end)
        d.right.MouseButton1Click:Connect(function()
            if updateCanvas(f) > 0 then scrollTo(f, f.CanvasPosition.X + STEP) end
        end)
        local l = f:FindFirstChildOfClass("UIListLayout")
        if l then l:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() updateProgress(d) end) end
        f:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() updateProgress(d) end)
        f:GetPropertyChangedSignal("CanvasPosition"):Connect(function() updateProgress(d) end)
        task.defer(function() updateProgress(d) end)
    end
end

-- ========== PLAYER ==========
do
    local UIS, Run = X.UIS, X.Run
    local speedEn, speedVal = false, 32
    X.createToggleInput("PLAYER","SPEED",32,1,function(e,v)
        speedEn=e; speedVal=v
        local ch=LP.Character
        local h=ch and ch:FindFirstChildOfClass("Humanoid")
        if h then h.WalkSpeed = speedEn and speedVal or 16 end
    end,"▶")
    local jumpEn, jumpVal = false, 100
    X.createToggleInput("PLAYER","JUMP_POWER",100,2,function(e,v)
        jumpEn=e; jumpVal=v
        local ch=LP.Character
        local h=ch and ch:FindFirstChildOfClass("Humanoid")
        if h then h.UseJumpPower=true; h.JumpPower=jumpEn and jumpVal or 50 end
    end,"▲")
    LP.CharacterAdded:Connect(function(c)
        local h=c:WaitForChild("Humanoid",5)
        if h then
            if speedEn then h.WalkSpeed=speedVal end
            if jumpEn then h.UseJumpPower=true; h.JumpPower=jumpVal end
        end
    end)
    local ijConn
    X.createToggle("PLAYER","INFINITY_JUMP",3,function(e)
        if e then
            ijConn = UIS.JumpRequest:Connect(function()
                local ch=LP.Character
                local h=ch and ch:FindFirstChildOfClass("Humanoid")
                if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        else if ijConn then ijConn:Disconnect() ijConn=nil end end
    end,"↥")
    local tpEn = false
    local tpTool, tpMouse, tpEq = nil, nil, false
    local tpActC, tpEqC, tpUnC
    local function destroyTP()
        if tpActC then tpActC:Disconnect() tpActC=nil end
        if tpEqC then tpEqC:Disconnect() tpEqC=nil end
        if tpUnC then tpUnC:Disconnect() tpUnC=nil end
        tpMouse, tpEq = nil, false
        if tpTool then pcall(function() tpTool:Destroy() end) tpTool=nil end
    end
    local function makeTP()
        destroyTP()
        local bp = LP:FindFirstChildOfClass("Backpack"); if not bp then return end
        local tool = Instance.new("Tool")
        tool.Name="TP Tool"; tool.ToolTip="Click to teleport"
        tool.RequiresHandle=false; tool.CanBeDropped=false; tool.Parent=bp
        tpTool = tool
        tpEqC = tool.Equipped:Connect(function(m) tpMouse=m; tpEq=true end)
        tpUnC = tool.Unequipped:Connect(function() tpMouse=nil; tpEq=false end)
        tpActC = tool.Activated:Connect(function()
            if not tpEn or not tpEq then return end
            local ch=LP.Character
            local root=ch and ch:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local cam=workspace.CurrentCamera; if not cam then return end
            local rp=RaycastParams.new()
            rp.FilterType=Enum.RaycastFilterType.Exclude
            rp.FilterDescendantsInstances={ch, tpTool}
            local x, y
            if tpMouse then x, y = tpMouse.X, tpMouse.Y
            else local p=UIS:GetMouseLocation(); x, y = p.X, p.Y end
            local ray=cam:ViewportPointToRay(x, y)
            local r=workspace:Raycast(ray.Origin, ray.Direction * 2000, rp)
            if not r then return end
            local pos=r.Position + Vector3.new(0,3,0)
            local pivot=ch:GetPivot()
            local rot=pivot - pivot.Position
            ch:PivotTo(CFrame.new(pos) * rot)
            pcall(function()
                root.AssemblyLinearVelocity=Vector3.zero
                root.AssemblyAngularVelocity=Vector3.zero
            end)
        end)
    end
    X.createToggle("PLAYER","TP_TOOL",4,function(e)
        tpEn=e
        if e then makeTP() else destroyTP() end
    end,"➤")
    LP.CharacterAdded:Connect(function()
        if tpEn then task.wait(0.25); makeTP() end
    end)
    
    local tpTarget
    local tpBtns = {}
    local tpRow = Instance.new("Frame")
    tpRow.Size=UDim2.new(1,0,0,96); tpRow.LayoutOrder=5
    tpRow.BackgroundColor3=C.CARD; tpRow.Parent=X.tabs.PLAYER
    X.styleCard(tpRow); X.makeIcon(tpRow,"◉"); X.makeTitle(tpRow,"TP_TO_PLAYER",-140)
    local tpBtn = Instance.new("TextButton")
    tpBtn.Size=UDim2.new(0,72,0,24); tpBtn.Position=UDim2.new(1,-82,0,9)
    tpBtn.BackgroundColor3=C.BTN; tpBtn.TextColor3=C.TEXT; tpBtn.Text="[ TP ]"
    tpBtn.TextSize=11; tpBtn.Font=Enum.Font.RobotoMono; tpBtn.AutoButtonColor=false
    tpBtn.Parent=tpRow
    Instance.new("UICorner", tpBtn).CornerRadius=UDim.new(0,4)
    Instance.new("UIStroke", tpBtn).Color=Color3.fromRGB(45,45,45)
    local tpList = Instance.new("ScrollingFrame")
    tpList.Size=UDim2.new(1,-20,0,40); tpList.Position=UDim2.new(0,10,0,48)
    tpList.BackgroundTransparency=1; tpList.BorderSizePixel=0; tpList.ScrollBarThickness=0
    tpList.Active=true; tpList.ScrollingDirection=Enum.ScrollingDirection.X
    tpList.AutomaticCanvasSize=Enum.AutomaticSize.X; tpList.CanvasSize=UDim2.new(0,0,0,0)
    tpList.Parent=tpRow
    local tpl = Instance.new("UIListLayout", tpList)
    tpl.FillDirection=Enum.FillDirection.Horizontal; tpl.Padding=UDim.new(0,5)
    X.enableArrowScroll(tpList)
    local function tpSet(p)
        tpTarget=p
        for pl, b in pairs(tpBtns) do
            local s = pl == p
            b.Text=(s and "[✓] " or "[ ] ") .. pl.Name
            b.TextColor3=s and C.GREEN or Color3.fromRGB(180,180,180)
            b.BackgroundColor3=s and C.GREEN_BG or C.BTN
        end
    end
    local function tpRefresh()
        for _, b in pairs(tpBtns) do pcall(function() b:Destroy() end) end
        tpBtns={}; tpList.CanvasPosition=Vector2.new(0,0)
        if tpTarget and (not tpTarget.Parent or tpTarget==LP) then tpTarget=nil end
        local found=false
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then found=true; break end
        end
        if not found then
            local l=Instance.new("TextLabel")
            l.Name="ServerEmpty"; l.Size=UDim2.new(1,0,1,0)
            l.BackgroundTransparency=1; l.TextColor3=C.TEXT_DIM
            l.Text="[ SERVER EMPTY ]"; l.TextSize=14; l.Font=Enum.Font.RobotoMono
            l.TextXAlignment=Enum.TextXAlignment.Center
            l.TextYAlignment=Enum.TextYAlignment.Center; l.Parent=tpList
            return
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then
                local b = Instance.new("TextButton")
                b.Size=UDim2.new(0, math.max(104, math.min(170, #p.Name*8+46)), 0, 30)
                b.BackgroundColor3=C.BTN; b.TextColor3=Color3.fromRGB(180,180,180)
                b.Text="[ ] "..p.Name; b.TextSize=11; b.Font=Enum.Font.RobotoMono
                b.AutoButtonColor=false; b.Parent=tpList
                Instance.new("UICorner", b).CornerRadius=UDim.new(0,4)
                Instance.new("UIStroke", b).Color=Color3.fromRGB(45,45,45)
                tpBtns[p]=b
                b.MouseButton1Click:Connect(function() tpSet(p) end)
            end
        end
        if tpTarget then tpSet(tpTarget) end
    end
    tpRefresh()
    tpBtn.MouseButton1Click:Connect(function()
        local p=tpTarget
        if not p or not p.Parent then return end
        local tc=p.Character; local tr=tc and tc:FindFirstChild("HumanoidRootPart")
        local ch=LP.Character; local root=ch and ch:FindFirstChild("HumanoidRootPart")
        if not tr or not root then return end
        ch:PivotTo(tr.CFrame * CFrame.new(0,3,0))
        pcall(function()
            root.AssemblyLinearVelocity=Vector3.zero
            root.AssemblyAngularVelocity=Vector3.zero
        end)
    end)
    Players.PlayerAdded:Connect(function() task.defer(tpRefresh) end)
    Players.PlayerRemoving:Connect(function(p)
        if tpTarget==p then tpTarget=nil end
        task.defer(tpRefresh)
    end)
    
    -- FLING
    local flTarget, flBtns, flBusy = nil, {}, false
    local FL_DUR, FL_RAD, FL_SPIN, FL_LIN = 1.35, 0.55, 350000, 900
    local flRow=Instance.new("Frame")
    flRow.Size=UDim2.new(1,0,0,96); flRow.LayoutOrder=6
    flRow.BackgroundColor3=C.CARD; flRow.Parent=X.tabs.PLAYER
    X.styleCard(flRow); X.makeIcon(flRow,"✦"); X.makeTitle(flRow,"FLING",-140)
    local flBtn=Instance.new("TextButton")
    flBtn.Size=UDim2.new(0,82,0,24); flBtn.Position=UDim2.new(1,-92,0,9)
    flBtn.BackgroundColor3=C.BTN; flBtn.TextColor3=C.TEXT; flBtn.Text="[ FLING ]"
    flBtn.TextSize=11; flBtn.Font=Enum.Font.RobotoMono; flBtn.AutoButtonColor=false
    flBtn.Parent=flRow
    Instance.new("UICorner", flBtn).CornerRadius=UDim.new(0,4)
    Instance.new("UIStroke", flBtn).Color=Color3.fromRGB(45,45,45)
    local flList=Instance.new("ScrollingFrame")
    flList.Size=UDim2.new(1,-20,0,40); flList.Position=UDim2.new(0,10,0,48)
    flList.BackgroundTransparency=1; flList.BorderSizePixel=0; flList.ScrollBarThickness=0
    flList.Active=true; flList.ScrollingDirection=Enum.ScrollingDirection.X
    flList.AutomaticCanvasSize=Enum.AutomaticSize.X; flList.CanvasSize=UDim2.new(0,0,0,0)
    flList.Parent=flRow
    local fll=Instance.new("UIListLayout", flList)
    fll.FillDirection=Enum.FillDirection.Horizontal; fll.Padding=UDim.new(0,5)
    X.enableArrowScroll(flList)
    local function flSet(p)
        flTarget=p
        for pl, b in pairs(flBtns) do
            local s = pl == p
            b.Text=(s and "[✓] " or "[ ] ") .. pl.Name
            b.TextColor3=s and C.GREEN or Color3.fromRGB(180,180,180)
            b.BackgroundColor3=s and C.GREEN_BG or C.BTN
        end
    end
    local function flRefresh()
        for _, b in pairs(flBtns) do pcall(function() b:Destroy() end) end
        flBtns={}; flList.CanvasPosition=Vector2.new(0,0)
        if flTarget and (not flTarget.Parent or flTarget==LP) then flTarget=nil end
        local found=false
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then found=true; break end
        end
        if not found then
            local l=Instance.new("TextLabel")
            l.Name="ServerEmpty"; l.Size=UDim2.new(1,0,1,0)
            l.BackgroundTransparency=1; l.TextColor3=C.TEXT_DIM
            l.Text="[ SERVER EMPTY ]"; l.TextSize=14; l.Font=Enum.Font.RobotoMono
            l.TextXAlignment=Enum.TextXAlignment.Center
            l.TextYAlignment=Enum.TextYAlignment.Center; l.Parent=flList
            return
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then
                local b=Instance.new("TextButton")
                b.Size=UDim2.new(0, math.max(104, math.min(170, #p.Name*8+46)), 0, 30)
                b.BackgroundColor3=C.BTN; b.TextColor3=Color3.fromRGB(180,180,180)
                b.Text="[ ] "..p.Name; b.TextSize=11; b.Font=Enum.Font.RobotoMono
                b.AutoButtonColor=false; b.Parent=flList
                Instance.new("UICorner", b).CornerRadius=UDim.new(0,4)
                Instance.new("UIStroke", b).Color=Color3.fromRGB(45,45,45)
                flBtns[p]=b
                b.MouseButton1Click:Connect(function() flSet(p) end)
            end
        end
        if flTarget then flSet(flTarget) end
    end
    flRefresh()
    flBtn.MouseButton1Click:Connect(function()
        local p=flTarget
        if flBusy or not p or not p.Parent or p==LP then return end
        local tc=p.Character
        local tr=tc and tc:FindFirstChild("HumanoidRootPart")
        local th=tc and tc:FindFirstChildOfClass("Humanoid")
        local ch=LP.Character; local root=ch and ch:FindFirstChild("HumanoidRootPart")
        if not tr or not th or th.Health<=0 or not root then return end
        flBusy=true; flBtn.Text="[ ... ]"
        flBtn.TextColor3=Color3.fromRGB(220,180,60)
        local oCF, oV, oA = root.CFrame, root.AssemblyLinearVelocity, root.AssemblyAngularVelocity
        local start, ang = os.clock(), 0
        local conn
        conn = Run.Heartbeat:Connect(function(dt)
            if not root.Parent or not tr.Parent or not th.Parent or th.Health<=0 then
                conn:Disconnect()
                pcall(function()
                    root.AssemblyAngularVelocity=Vector3.zero
                    root.AssemblyLinearVelocity=Vector3.zero
                    root.CFrame=oCF
                    root.AssemblyLinearVelocity=oV
                    root.AssemblyAngularVelocity=oA
                end)
                flBusy=false; flBtn.Text="[ FLING ]"; flBtn.TextColor3=C.TEXT
                return
            end
            if os.clock()-start >= FL_DUR then
                conn:Disconnect()
                pcall(function()
                    root.AssemblyAngularVelocity=Vector3.zero
                    root.AssemblyLinearVelocity=Vector3.zero
                    root.CFrame=oCF
                    root.AssemblyLinearVelocity=oV
                    root.AssemblyAngularVelocity=oA
                end)
                flBusy=false; flBtn.Text="[ FLING ]"; flBtn.TextColor3=C.TEXT
                return
            end
            ang = ang + dt*55
            local v = math.sin(ang*2.0)*0.35
            local off = Vector3.new(math.cos(ang)*FL_RAD, v, math.sin(ang)*FL_RAD)
            local tp = tr.Position + off
            local inw = tr.Position - tp
            if inw.Magnitude > 0.001 then tp = tp + inw.Unit * 0.22 end
            local dir = tr.Position - tp
            local vel = dir.Magnitude > 0.001 and dir.Unit * FL_LIN or Vector3.zero
            pcall(function()
                root.CFrame = CFrame.lookAt(tp, tr.Position)
                root.AssemblyAngularVelocity = Vector3.new(0, FL_SPIN, 0)
                root.AssemblyLinearVelocity = vel
            end)
        end)
    end)
    Players.PlayerAdded:Connect(function() task.defer(flRefresh) end)
    Players.PlayerRemoving:Connect(function(p)
        if flTarget==p then flTarget=nil end
        task.defer(flRefresh)
    end)
    
    local ncConn
    X.createToggle("PLAYER","NOCLIP",7,function(e)
        if e then
            ncConn=Run.Stepped:Connect(function()
                local ch=LP.Character
                if ch then
                    for _, p in ipairs(ch:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide=false end
                    end
                end
            end)
        else
            if ncConn then ncConn:Disconnect() ncConn=nil end
            local ch=LP.Character
            if ch then
                for _, p in ipairs(ch:GetDescendants()) do
                    if p:IsA("BasePart") and p.Name~="HumanoidRootPart" then p.CanCollide=true end
                end
            end
        end
    end,"◇")
    
    local flyConn
    X.createToggleInput("PLAYER","FLY",50,8,function(e, sp)
        local ch=LP.Character
        local h=ch and ch:FindFirstChildOfClass("Humanoid")
        local hrp=ch and ch:FindFirstChild("HumanoidRootPart")
        if e then
            if not flyConn then
                flyConn=Run.RenderStepped:Connect(function()
                    local c=LP.Character; if not c then return end
                    local hh=c:FindFirstChildOfClass("Humanoid")
                    local r=c:FindFirstChild("HumanoidRootPart")
                    if not hh or not r or hh.Health<=0 then return end
                    hh.PlatformStand=true
                    local cam=workspace.CurrentCamera
                    local d=Vector3.new()
                    if UIS:IsKeyDown(Enum.KeyCode.W) then d=d+cam.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.S) then d=d-cam.CFrame.LookVector end
                    if UIS:IsKeyDown(Enum.KeyCode.A) then d=d-cam.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.D) then d=d+cam.CFrame.RightVector end
                    if UIS:IsKeyDown(Enum.KeyCode.Space) then d=d+Vector3.new(0,1,0) end
                    if UIS:IsKeyDown(Enum.KeyCode.LeftShift) or UIS:IsKeyDown(Enum.KeyCode.RightShift) then d=d-Vector3.new(0,1,0) end
                    r.AssemblyLinearVelocity = d.Magnitude>0 and d.Unit*sp or Vector3.zero
                end)
            end
        else
            if flyConn then flyConn:Disconnect() flyConn=nil end
            if h then h.PlatformStand=false end
            if hrp then hrp.AssemblyLinearVelocity=Vector3.zero end
        end
    end,"✦")
    
    -- HITBOX
    local hbEn, hbSize = false, 20
    local hbData, hbConn = {}, nil
    local function rmHb(p)
        local d=hbData[p]; if not d then return end
        local r=d.Root
        if r and r.Parent then
            pcall(function()
                r.Size=d.OrigSize; r.Transparency=d.OrigTrans
                r.CanQuery=d.OrigQuery; r.CanCollide=d.OrigCollide; r.CanTouch=d.OrigTouch
            end)
        end
        if d.Visual then pcall(function() d.Visual:Destroy() end) end
        hbData[p]=nil
    end
    local function makeHb(p)
        if p==LP or not hbEn then return end
        local ch=p.Character
        local h=ch and ch:FindFirstChildOfClass("Humanoid")
        local r=ch and ch:FindFirstChild("HumanoidRootPart")
        if not ch or not h or h.Health<=0 or not r or not r:IsA("BasePart") then rmHb(p); return end
        local d=hbData[p]
        if not d or d.Root~=r then
            if d then rmHb(p) end
            d={Root=r, OrigSize=r.Size, OrigTrans=r.Transparency,
               OrigQuery=r.CanQuery, OrigCollide=r.CanCollide, OrigTouch=r.CanTouch, Visual=nil}
            hbData[p]=d
        end
        local sz=math.clamp(tonumber(hbSize) or 20, 2, 200)
        local es=Vector3.new(sz, sz, sz)
        pcall(function()
            r.Size=es; r.CanCollide=false; r.CanQuery=true; r.CanTouch=d.OrigTouch
        end)
        local v=d.Visual
        if not v or not v.Parent then
            v=Instance.new("BoxHandleAdornment")
            v.Name="HackerHitboxVisual"; v.Adornee=r; v.AlwaysOnTop=true
            v.ZIndex=10; v.Size=es
            v.Color3=Color3.fromRGB(255,255,255); v.Transparency=0.35; v.Parent=r
            d.Visual=v
        else v.Adornee=r; v.Size=es end
    end
    X.createToggleInput("PLAYER","HITBOX_SIZE",20,9,function(e,v)
        hbEn=e; hbSize=math.clamp(tonumber(v) or 20, 2, 200)
        if not hbEn then
            if hbConn then hbConn:Disconnect() hbConn=nil end
            for p in pairs(hbData) do rmHb(p) end
            return
        end
        if hbConn then hbConn:Disconnect() end
        hbConn=Run.RenderStepped:Connect(function()
            if not hbEn then return end
            local act={}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP then act[p]=true; makeHb(p) end
            end
            for p in pairs(hbData) do if not act[p] then rmHb(p) end end
        end)
    end,"▣")
    
    -- VECTOR ANCHORS
    local redP, blueP, redV, blueV = nil, nil, nil, nil
    local function ground(ch)
        local r=ch and ch:FindFirstChild("HumanoidRootPart")
        local h=ch and ch:FindFirstChildOfClass("Humanoid")
        if not r or not h then return nil, nil end
        local pm=RaycastParams.new()
        pm.FilterType=Enum.RaycastFilterType.Exclude
        pm.FilterDescendantsInstances={ch}; pm.IgnoreWater=false
        local res=workspace:Raycast(r.Position+Vector3.new(0,2,0), Vector3.new(0,-100,0), pm)
        local gp
        if res then gp=res.Position
        else gp=r.Position - Vector3.new(0, h.HipHeight + r.Size.Y/2, 0) end
        return gp, r.Position.Y - gp.Y
    end
    local function mkAnchor(col, nm)
        local p=Instance.new("Part")
        p.Name=nm; p.Size=Vector3.new(4.5,0.18,4.5); p.Anchored=true
        p.CanCollide=false; p.CanTouch=false; p.CanQuery=false; p.CastShadow=false
        p.Material=Enum.Material.Neon; p.Color=col; p.Transparency=0.12; p.Parent=workspace
        local l=Instance.new("PointLight")
        l.Color=col; l.Brightness=0.7; l.Range=8; l.Shadows=false; l.Parent=p
        return p
    end
    do
        local row=Instance.new("Frame")
        row.Size=UDim2.new(1,0,0,120); row.LayoutOrder=10
        row.BackgroundColor3=C.CARD; row.Parent=X.tabs.PLAYER
        local stroke=X.styleCard(row)
        X.makeIcon(row,"⌖")
        local title=Instance.new("TextLabel")
        title.Size=UDim2.new(1,-140,0,22); title.Position=UDim2.new(0,38,0,8)
        title.BackgroundTransparency=1; title.TextColor3=C.TEXT
        title.Text="VECTOR_ANCHORS"; title.TextSize=12
        title.Font=Enum.Font.RobotoMono; title.TextXAlignment=Enum.TextXAlignment.Left; title.Parent=row
        local sub=Instance.new("TextLabel")
        sub.Size=UDim2.new(1,-140,0,14); sub.Position=UDim2.new(0,38,0,26)
        sub.BackgroundTransparency=1; sub.TextColor3=C.TEXT_MUTE
        sub.Text="SAVE TWO POINTS"; sub.TextSize=8
        sub.Font=Enum.Font.RobotoMono; sub.TextXAlignment=Enum.TextXAlignment.Left; sub.Parent=row
        local tg=Instance.new("TextButton")
        tg.Size=UDim2.new(0,72,0,24); tg.Position=UDim2.new(1,-82,0,10)
        tg.BackgroundColor3=C.BTN; tg.TextColor3=C.RED; tg.Text="[ OFF ]"
        tg.TextSize=11; tg.Font=Enum.Font.RobotoMono; tg.AutoButtonColor=false; tg.Parent=row
        Instance.new("UICorner", tg).CornerRadius=UDim.new(0,4)
        local tgs=Instance.new("UIStroke", tg); tgs.Color=Color3.fromRGB(40,20,20)
        local rc=Instance.new("Frame")
        rc.Size=UDim2.new(0.5,-14,0,48); rc.Position=UDim2.new(0,8,0,62)
        rc.BackgroundColor3=Color3.fromRGB(22,13,13); rc.Parent=row
        Instance.new("UICorner", rc).CornerRadius=UDim.new(0,6)
        Instance.new("UIStroke", rc).Color=Color3.fromRGB(75,30,30)
        local rl=Instance.new("TextLabel")
        rl.Size=UDim2.new(0,62,0,16); rl.Position=UDim2.new(0,9,0,5)
        rl.BackgroundTransparency=1; rl.TextColor3=Color3.fromRGB(255,90,90)
        rl.Text="RED"; rl.TextSize=10; rl.Font=Enum.Font.RobotoMono
        rl.TextXAlignment=Enum.TextXAlignment.Left; rl.Parent=rc
        local rs=Instance.new("TextLabel")
        rs.Size=UDim2.new(0,90,0,16); rs.Position=UDim2.new(0,9,0,25)
        rs.BackgroundTransparency=1; rs.TextColor3=Color3.fromRGB(120,55,55)
        rs.Text="● NOT SET"; rs.TextSize=8; rs.Font=Enum.Font.RobotoMono
        rs.TextXAlignment=Enum.TextXAlignment.Left; rs.Parent=rc
        local rtp=Instance.new("TextButton")
        rtp.Size=UDim2.new(0,52,0,24); rtp.Position=UDim2.new(1,-58,0,6)
        rtp.BackgroundColor3=Color3.fromRGB(28,15,15); rtp.TextColor3=Color3.fromRGB(255,110,110)
        rtp.Text="TP"; rtp.TextSize=9; rtp.Font=Enum.Font.RobotoMono
        rtp.AutoButtonColor=false; rtp.Parent=rc
        Instance.new("UICorner", rtp).CornerRadius=UDim.new(0,4)
        Instance.new("UIStroke", rtp).Color=Color3.fromRGB(85,32,32)
        local rst=Instance.new("TextButton")
        rst.Size=UDim2.new(0,52,0,24); rst.Position=UDim2.new(1,-114,0,6)
        rst.BackgroundColor3=Color3.fromRGB(28,15,15); rst.TextColor3=Color3.fromRGB(255,110,110)
        rst.Text="SET"; rst.TextSize=9; rst.Font=Enum.Font.RobotoMono
        rst.AutoButtonColor=false; rst.Parent=rc
        Instance.new("UICorner", rst).CornerRadius=UDim.new(0,4)
        Instance.new("UIStroke", rst).Color=Color3.fromRGB(85,32,32)
        local bc=Instance.new("Frame")
        bc.Size=UDim2.new(0.5,-14,0,48); bc.Position=UDim2.new(0.5,6,0,62)
        bc.BackgroundColor3=Color3.fromRGB(13,17,23); bc.Parent=row
        Instance.new("UICorner", bc).CornerRadius=UDim.new(0,6)
        Instance.new("UIStroke", bc).Color=Color3.fromRGB(30,50,80)
        local bl=Instance.new("TextLabel")
        bl.Size=UDim2.new(0,62,0,16); bl.Position=UDim2.new(0,9,0,5)
        bl.BackgroundTransparency=1; bl.TextColor3=Color3.fromRGB(90,160,255)
        bl.Text="BLUE"; bl.TextSize=10; bl.Font=Enum.Font.RobotoMono
        bl.TextXAlignment=Enum.TextXAlignment.Left; bl.Parent=bc
        local bs=Instance.new("TextLabel")
        bs.Size=UDim2.new(0,90,0,16); bs.Position=UDim2.new(0,9,0,25)
        bs.BackgroundTransparency=1; bs.TextColor3=Color3.fromRGB(120,55,55)
        bs.Text="● NOT SET"; bs.TextSize=8; bs.Font=Enum.Font.RobotoMono
        bs.TextXAlignment=Enum.TextXAlignment.Left; bs.Parent=bc
        local btp=Instance.new("TextButton")
        btp.Size=UDim2.new(0,52,0,24); btp.Position=UDim2.new(1,-58,0,6)
        btp.BackgroundColor3=Color3.fromRGB(15,22,32); btp.TextColor3=Color3.fromRGB(100,170,255)
        btp.Text="TP"; btp.TextSize=9; btp.Font=Enum.Font.RobotoMono
        btp.AutoButtonColor=false; btp.Parent=bc
        Instance.new("UICorner", btp).CornerRadius=UDim.new(0,4)
        Instance.new("UIStroke", btp).Color=Color3.fromRGB(35,60,95)
        local bst=Instance.new("TextButton")
        bst.Size=UDim2.new(0,52,0,24); bst.Position=UDim2.new(1,-114,0,6)
        bst.BackgroundColor3=Color3.fromRGB(15,22,32); bst.TextColor3=Color3.fromRGB(100,170,255)
        bst.Text="SET"; bst.TextSize=9; bst.Font=Enum.Font.RobotoMono
        bst.AutoButtonColor=false; bst.Parent=bc
        Instance.new("UICorner", bst).CornerRadius=UDim.new(0,4)
        Instance.new("UIStroke", bst).Color=Color3.fromRGB(35,60,95)
        local en=false
        local function setAct(a)
            for _, b in ipairs({rst, rtp, bst, btp}) do
                b.Active=a; b.AutoButtonColor=a
                b.TextTransparency = a and 0 or 0.5
                b.BackgroundTransparency = a and 0 or 0.4
            end
        end
        setAct(false)
        tg.MouseButton1Click:Connect(function()
            en=not en
            if en then
                setAct(true); tg.Text="[ ON ]"
                Tween:Create(row,TI,{BackgroundColor3=C.CARD_ACT}):Play()
                Tween:Create(stroke,TI,{Color=C.BORDER_ACT,Thickness=1.2}):Play()
                Tween:Create(tg,TI,{BackgroundColor3=C.GREEN_BG,TextColor3=C.GREEN}):Play()
                Tween:Create(tgs,TI,{Color=C.BORDER_ACT}):Play()
            else
                setAct(false); tg.Text="[ OFF ]"
                Tween:Create(row,TI,{BackgroundColor3=C.CARD}):Play()
                Tween:Create(stroke,TI,{Color=C.BORDER,Thickness=1}):Play()
                Tween:Create(tg,TI,{BackgroundColor3=C.BTN,TextColor3=C.RED}):Play()
                Tween:Create(tgs,TI,{Color=Color3.fromRGB(40,20,20)}):Play()
                if redV then redV:Destroy() redV=nil end
                if blueV then blueV:Destroy() blueV=nil end
                redP, blueP = nil, nil
                rs.Text="● NOT SET"; rs.TextColor3=Color3.fromRGB(120,55,55)
                bs.Text="● NOT SET"; bs.TextColor3=Color3.fromRGB(120,55,55)
            end
        end)
        rst.MouseButton1Click:Connect(function()
            if not en then return end
            local ch=LP.Character
            if not ch or not ch:FindFirstChild("HumanoidRootPart") then return end
            local gp=ground(ch); if not gp then return end
            redP=gp
            if redV then redV:Destroy() end
            redV=mkAnchor(Color3.fromRGB(255,60,60), "RedVectorAnchor")
            redV.Position=gp+Vector3.new(0,0.09,0)
            rs.Text="● LINKED"; rs.TextColor3=Color3.fromRGB(255,90,90)
        end)
        bst.MouseButton1Click:Connect(function()
            if not en then return end
            local ch=LP.Character
            if not ch or not ch:FindFirstChild("HumanoidRootPart") then return end
            local gp=ground(ch); if not gp then return end
            blueP=gp
            if blueV then blueV:Destroy() end
            blueV=mkAnchor(Color3.fromRGB(50,150,255), "BlueVectorAnchor")
            blueV.Position=gp+Vector3.new(0,0.09,0)
            bs.Text="● LINKED"; bs.TextColor3=Color3.fromRGB(90,160,255)
        end)
        rtp.MouseButton1Click:Connect(function()
            if not en or not redP then return end
            local ch=LP.Character
            local root=ch and ch:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local _, off = ground(ch)
            if off then root.CFrame = CFrame.new(redP + Vector3.new(0, off, 0)) end
        end)
        btp.MouseButton1Click:Connect(function()
            if not en or not blueP then return end
            local ch=LP.Character
            local root=ch and ch:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local _, off = ground(ch)
            if off then root.CFrame = CFrame.new(blueP + Vector3.new(0, off, 0)) end
        end)
    end
end

-- ========== TELEKINESIS ==========
do
    local UIS, Run = X.UIS, X.Run
    local tkEn, tkPart, tkDist, tkMode = false, nil, 18, "DROP"
    local tkRender, tkJK
    local tkTool, tkToolEq, tkAnimConn = nil, false, nil
    local TK_MIN, TK_MAX = 4, 80
    local TK_PULL, TK_MAXV, TK_THROW = 34, 220, 125
    local TK_DROP_IMG = "rbxassetid://139334701849666"
    local TK_THROW_IMG = "rbxassetid://134979152121573"
    local function tkIsChar(p)
        if not p or not p:IsA("BasePart") then return false end
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl.Character and p:IsDescendantOf(pl.Character) then return true end
        end
        return false
    end
    local function tkClear(stop)
        local p = tkPart
        tkPart = nil
        if stop and p and p.Parent then
            pcall(function()
                p.AssemblyLinearVelocity=Vector3.zero
                p.AssemblyAngularVelocity=Vector3.zero
            end)
        end
    end
    local function tkGrab()
        if tkPart then return end
        local m = LP:GetMouse()
        local t = m and m.Target
        if not t or not t:IsA("BasePart") then return end
        if t.Anchored or tkIsChar(t) then return end
        if not workspace.CurrentCamera then return end
        tkPart = t; tkDist = 18
        pcall(function() t.AssemblyAngularVelocity=Vector3.zero end)
    end
    local function tkRelease()
        local p = tkPart
        if not p or not p.Parent then tkClear(false); return end
        if tkMode == "THROW" then
            local m = LP:GetMouse()
            if m then
                pcall(function()
                    p.AssemblyAngularVelocity=Vector3.zero
                    p.AssemblyLinearVelocity=m.UnitRay.Direction * TK_THROW
                end)
            end
            tkClear(false)
        else tkClear(true) end
    end
    local function tkChange(d)
        tkDist = math.clamp(tkDist + d, TK_MIN, TK_MAX)
        X.tkUI()
    end
    function X.tkUI()
        if X.tkModeBtn then X.tkModeBtn.Text = tkMode == "THROW" and "[THROW]" or "[DROP]" end
        if X.tkInfo then
            if tkPart then
                X.tkInfo.Text = string.format("LMB: GRAB / RELEASE   |   DIST: %d", math.floor(tkDist + 0.5))
            else
                X.tkInfo.Text = "LMB: GRAB / RELEASE"
            end
        end
    end
    local function tkStart()
        if tkRender then return end
        tkRender = Run.RenderStepped:Connect(function()
            local p = tkPart
            if not p or not p.Parent or p.Anchored or tkIsChar(p) then tkClear(true); return end
            local cam = workspace.CurrentCamera
            local m = LP:GetMouse()
            if not cam or not m then return end
            local t = cam.CFrame.Position + m.UnitRay.Direction * tkDist
            local d = t - p.Position
            local v = d * TK_PULL
            if v.Magnitude > TK_MAXV then v = v.Unit * TK_MAXV end
            pcall(function()
                p.AssemblyLinearVelocity = v
                p.AssemblyAngularVelocity = Vector3.zero
            end)
        end)
        tkJK = UIS.InputBegan:Connect(function(i, gp)
            if gp or not tkToolEq or not tkPart then return end
            if i.KeyCode == Enum.KeyCode.J then tkChange(-3)
            elseif i.KeyCode == Enum.KeyCode.K then tkChange(3) end
        end)
    end
    local function tkStop()
        if tkRender then tkRender:Disconnect() tkRender=nil end
        if tkJK then tkJK:Disconnect() tkJK=nil end
        tkClear(true)
    end
    local function tkImg()
        return tkMode == "THROW" and TK_THROW_IMG or TK_DROP_IMG
    end
    local function tkCreate()
        if tkTool and tkTool.Parent then
            tkTool.Name = "Telekinesis [" .. tkMode .. "]"
            tkTool.TextureId = tkImg()
            return tkTool
        end
        local bp = LP:FindFirstChildOfClass("Backpack")
        if not bp then return nil end
        local t = Instance.new("Tool")
        t.Name = "Telekinesis"; t.ToolTip = "Created by 71033"
        t.RequiresHandle = false; t.CanBeDropped = false
        t.TextureId = tkImg()
        t.Equipped:Connect(function()
            tkToolEq = true
            t.TextureId = tkImg()
            if tkAnimConn then tkAnimConn:Disconnect() end
            tkAnimConn = Run.RenderStepped:Connect(function()
                if not tkToolEq then return end
                local ch = LP.Character
                local h = ch and ch:FindFirstChildOfClass("Humanoid")
                local a = h and h:FindFirstChildOfClass("Animator")
                if a then
                    for _, tr in ipairs(a:GetPlayingAnimationTracks()) do
                        local n = string.lower(tr.Name or "")
                        if string.find(n, "tool", 1, true) then
                            pcall(function() tr:Stop(0) end)
                        end
                    end
                end
            end)
            X.tkUI()
        end)
        t.Unequipped:Connect(function()
            tkToolEq = false
            if tkAnimConn then tkAnimConn:Disconnect() tkAnimConn=nil end
            if tkPart then tkRelease() end
            X.tkUI()
        end)
        t.Activated:Connect(function()
            if not tkEn or not tkToolEq then return end
            if tkPart then tkRelease() else tkGrab() end
            X.tkUI()
        end)
        t.Parent = bp
        tkTool = t
        return t
    end
    local function tkRemove()
        tkToolEq = false
        if tkAnimConn then tkAnimConn:Disconnect() tkAnimConn=nil end
        if tkTool then pcall(function() tkTool:Destroy() end) tkTool=nil end
    end
    
    local row = Instance.new("Frame")
    row.Size=UDim2.new(1,0,0,88); row.LayoutOrder=11
    row.BackgroundColor3=C.CARD; row.Parent=X.tabs.PLAYER
    local stroke = X.styleCard(row)
    X.makeIcon(row,"⌘"); X.makeTitle(row,"TELEKINESIS",-220)
    local modeBtn = Instance.new("TextButton")
    modeBtn.Size=UDim2.new(0,82,0,24); modeBtn.Position=UDim2.new(1,-174,0,9)
    modeBtn.BackgroundColor3=C.BTN; modeBtn.TextColor3=Color3.fromRGB(220,180,80)
    modeBtn.Text="[DROP]"; modeBtn.TextSize=11; modeBtn.Font=Enum.Font.RobotoMono
    modeBtn.AutoButtonColor=false; modeBtn.Parent=row
    Instance.new("UICorner", modeBtn).CornerRadius=UDim.new(0,4)
    Instance.new("UIStroke", modeBtn).Color=Color3.fromRGB(70,60,30)
    local tg = Instance.new("TextButton")
    tg.Size=UDim2.new(0,72,0,24); tg.Position=UDim2.new(1,-82,0,9)
    tg.BackgroundColor3=C.BTN; tg.TextColor3=C.RED; tg.Text="[ OFF ]"
    tg.TextSize=11; tg.Font=Enum.Font.RobotoMono; tg.AutoButtonColor=false; tg.Parent=row
    Instance.new("UICorner", tg).CornerRadius=UDim.new(0,4)
    local tgs = Instance.new("UIStroke", tg); tgs.Color=Color3.fromRGB(40,20,20)
    local info = Instance.new("TextLabel")
    info.Size=UDim2.new(1,-220,0,26); info.Position=UDim2.new(0,38,0,42)
    info.BackgroundTransparency=1; info.TextColor3=C.TEXT_DIM
    info.Text="LMB: GRAB / RELEASE"; info.TextSize=10; info.Font=Enum.Font.RobotoMono
    info.TextXAlignment=Enum.TextXAlignment.Left; info.Parent=row
    X.tkInfo = info; X.tkModeBtn = modeBtn
    local dD = Instance.new("TextButton")
    dD.Size=UDim2.new(0,66,0,22); dD.Position=UDim2.new(1,-152,0,48)
    dD.BackgroundColor3=C.BTN; dD.TextColor3=C.TEXT; dD.Text="[J] -"
    dD.TextSize=10; dD.Font=Enum.Font.RobotoMono; dD.AutoButtonColor=false; dD.Parent=row
    Instance.new("UICorner", dD).CornerRadius=UDim.new(0,4)
    Instance.new("UIStroke", dD).Color=Color3.fromRGB(50,50,50)
    local dU = Instance.new("TextButton")
    dU.Size=UDim2.new(0,66,0,22); dU.Position=UDim2.new(1,-82,0,48)
    dU.BackgroundColor3=C.BTN; dU.TextColor3=C.TEXT; dU.Text="[K] +"
    dU.TextSize=10; dU.Font=Enum.Font.RobotoMono; dU.AutoButtonColor=false; dU.Parent=row
    Instance.new("UICorner", dU).CornerRadius=UDim.new(0,4)
    Instance.new("UIStroke", dU).Color=Color3.fromRGB(50,50,50)
    dD.MouseButton1Click:Connect(function() tkChange(-3) end)
    dU.MouseButton1Click:Connect(function() tkChange(3) end)
    modeBtn.MouseButton1Click:Connect(function()
        tkMode = tkMode == "DROP" and "THROW" or "DROP"
        if tkTool and tkTool.Parent then
            tkTool.Name = "Telekinesis [" .. tkMode .. "]"
            tkTool.TextureId = tkImg()
        end
        X.tkUI()
    end)
    tg.MouseButton1Click:Connect(function()
        tkEn = not tkEn
        if tkEn then
            tkStart(); tkCreate()
            if tkTool then
                tkTool.Name = "Telekinesis [" .. tkMode .. "]"
                tkTool.TextureId = tkImg()
            end
            tg.Text="[ ON ]"
            Tween:Create(row,TI,{BackgroundColor3=C.CARD_ACT}):Play()
            Tween:Create(stroke,TI,{Color=C.BORDER_ACT,Thickness=1.2}):Play()
            Tween:Create(tg,TI,{BackgroundColor3=C.GREEN_BG,TextColor3=C.GREEN}):Play()
            Tween:Create(tgs,TI,{Color=C.BORDER_ACT}):Play()
        else
            tkStop(); tkRemove()
            tg.Text="[ OFF ]"
            Tween:Create(row,TI,{BackgroundColor3=C.CARD}):Play()
            Tween:Create(stroke,TI,{Color=C.BORDER,Thickness=1}):Play()
            Tween:Create(tg,TI,{BackgroundColor3=C.BTN,TextColor3=C.RED}):Play()
            Tween:Create(tgs,TI,{Color=Color3.fromRGB(40,20,20)}):Play()
        end
        X.tkUI()
    end)
    X.tkUI()
end

-- ========== VISUAL ==========
do
    local UIS, Run, Light = X.UIS, X.Run, X.Light
    local PG2 = X.PG
    
    -- ESP
    local espEn, special = false, {}
    local espConn, espBB, espHL = nil, {}, {}
    local espExcBtns, espExcList = {}, nil
    local function isSpec(n) return special[string.lower(n)] == true end
    local function syncSpec()
        special = {}
        for p, s in pairs(espExcBtns) do
            if s then special[string.lower(p.Name)] = true end
        end
    end
    local function refreshExc()
        if not espExcList then return end
        for _, c in ipairs(espExcList:GetChildren()) do
            if c:IsA("TextButton") or (c:IsA("TextLabel") and c.Name=="ServerEmpty") then c:Destroy() end
        end
        espExcBtns = {}; espExcList.CanvasPosition = Vector2.new(0,0)
        local found=false
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then found=true; break end
        end
        if not found then
            local l=Instance.new("TextLabel")
            l.Name="ServerEmpty"; l.Size=UDim2.new(1,0,1,0)
            l.BackgroundTransparency=1; l.TextColor3=C.TEXT_DIM
            l.Text="[ SERVER EMPTY ]"; l.TextSize=14; l.Font=Enum.Font.RobotoMono
            l.TextXAlignment=Enum.TextXAlignment.Center
            l.TextYAlignment=Enum.TextYAlignment.Center; l.Parent=espExcList
            return
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP then
                local b=Instance.new("TextButton")
                b.Size=UDim2.new(0, math.max(104, math.min(170, #p.Name*8+46)), 0, 30)
                b.BackgroundColor3=C.BTN; b.TextColor3=Color3.fromRGB(180,180,180)
                b.Text="[ ] "..p.Name; b.TextSize=11; b.Font=Enum.Font.RobotoMono
                b.AutoButtonColor=false; b.Parent=espExcList
                Instance.new("UICorner", b).CornerRadius=UDim.new(0,4)
                Instance.new("UIStroke", b).Color=Color3.fromRGB(45,45,45)
                espExcBtns[p]=false
                b.MouseButton1Click:Connect(function()
                    espExcBtns[p] = not espExcBtns[p]
                    local s = espExcBtns[p]
                    b.Text = (s and "[✓] " or "[ ] ") .. p.Name
                    b.TextColor3 = s and C.GREEN or Color3.fromRGB(180,180,180)
                    b.BackgroundColor3 = s and C.GREEN_BG or C.BTN
                    syncSpec()
                end)
            end
        end
    end
    local row = Instance.new("Frame")
    row.Size=UDim2.new(1,0,0,96); row.LayoutOrder=1
    row.BackgroundColor3=C.CARD; row.Parent=X.tabs.VISUAL
    local stroke = X.styleCard(row)
    X.makeIcon(row,"🔒"); X.makeTitle(row,"ESP_PLAYERS",-140)
    local tg = Instance.new("TextButton")
    tg.Size=UDim2.new(0,72,0,24); tg.Position=UDim2.new(1,-82,0,9)
    tg.BackgroundColor3=C.BTN; tg.TextColor3=C.RED; tg.Text="[ OFF ]"
    tg.TextSize=11; tg.Font=Enum.Font.RobotoMono; tg.AutoButtonColor=false; tg.Parent=row
    Instance.new("UICorner", tg).CornerRadius=UDim.new(0,4)
    local tgs = Instance.new("UIStroke", tg); tgs.Color=Color3.fromRGB(40,20,20)
    local clr = Instance.new("TextButton")
    clr.Size=UDim2.new(0,58,0,22); clr.Position=UDim2.new(0,10,0,48)
    clr.BackgroundColor3=C.RED_BG; clr.TextColor3=Color3.fromRGB(235,70,70)
    clr.Text="[CLR]"; clr.TextSize=10; clr.Font=Enum.Font.RobotoMono
    clr.AutoButtonColor=false; clr.Parent=row
    Instance.new("UICorner", clr).CornerRadius=UDim.new(0,4)
    Instance.new("UIStroke", clr).Color=Color3.fromRGB(90,20,20)
    espExcList = Instance.new("ScrollingFrame")
    espExcList.Size=UDim2.new(1,-76,0,40); espExcList.Position=UDim2.new(0,72,0,50)
    espExcList.BackgroundTransparency=1; espExcList.BorderSizePixel=0
    espExcList.ScrollBarThickness=0; espExcList.Active=true
    espExcList.ScrollingDirection=Enum.ScrollingDirection.X
    espExcList.AutomaticCanvasSize=Enum.AutomaticSize.X
    espExcList.CanvasSize=UDim2.new(0,0,0,0); espExcList.Parent=row
    local el=Instance.new("UIListLayout", espExcList)
    el.FillDirection=Enum.FillDirection.Horizontal; el.Padding=UDim.new(0,5)
    X.enableArrowScroll(espExcList)
    refreshExc()
    local function startESP()
        if espConn then espConn:Disconnect() end
        espConn = Run.RenderStepped:Connect(function()
            local lc = LP.Character
            local lr = lc and lc:FindFirstChild("HumanoidRootPart")
            for p, g in pairs(espBB) do
                local c = p.Character
                local h = c and c:FindFirstChildOfClass("Humanoid")
                if not p.Parent or not c or not c:FindFirstChild("HumanoidRootPart") or not h or h.Health<=0 then
                    if g then g:Destroy() end
                    espBB[p]=nil
                    if espHL[p] then espHL[p]:Destroy() espHL[p]=nil end
                end
            end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP then
                    local c=p.Character
                    local r=c and c:FindFirstChild("HumanoidRootPart")
                    local h=c and c:FindFirstChildOfClass("Humanoid")
                    local hd=c and c:FindFirstChild("Head")
                    if r and h and hd and h.Health>0 then
                        local g=espBB[p]
                        if not g then
                            g=Instance.new("BillboardGui")
                            g.Name="HackerESP"; g.Size=UDim2.new(0,220,0,70)
                            g.StudsOffset=Vector3.new(0,3,0); g.AlwaysOnTop=true
                            g.Adornee=hd
                            local l=Instance.new("TextLabel")
                            l.Name="Text"; l.Size=UDim2.new(1,0,1,0)
                            l.BackgroundTransparency=1; l.TextSize=20
                            l.Font=Enum.Font.RobotoMono
                            l.TextStrokeTransparency=0.2; l.TextStrokeColor3=Color3.fromRGB(0,0,0)
                            l.Parent=g
                            g.Parent=hd
                            espBB[p]=g
                        end
                        local hl=espHL[p]
                        if not hl then
                            hl=Instance.new("Highlight")
                            hl.Name="HackerHighlight"; hl.Adornee=c
                            hl.FillTransparency=0.5; hl.OutlineTransparency=0
                            hl.Parent=c
                            espHL[p]=hl
                        else hl.Adornee=c end
                        local l=g:FindFirstChild("Text")
                        if l then
                            local d = lr and math.floor((lr.Position - r.Position).Magnitude) or 0
                            l.Text = string.format("[%s]\nHP: %d/%d | %dm", p.Name, math.floor(h.Health), math.floor(h.MaxHealth), d)
                            if isSpec(p.Name) then
                                l.TextColor3=Color3.fromRGB(255,60,60)
                                hl.FillColor=Color3.fromRGB(255,60,60)
                            else
                                l.TextColor3=Color3.fromRGB(50,150,255)
                                hl.FillColor=Color3.fromRGB(50,150,255)
                            end
                            hl.OutlineColor=Color3.fromRGB(255,255,255)
                        end
                    end
                end
            end
        end)
    end
    tg.MouseButton1Click:Connect(function()
        espEn = not espEn
        if espEn then
            tg.Text="[ ON ]"; refreshExc(); startESP()
            Tween:Create(row,TI,{BackgroundColor3=C.CARD_ACT}):Play()
            Tween:Create(stroke,TI,{Color=C.BORDER_ACT,Thickness=1.2}):Play()
            Tween:Create(tg,TI,{BackgroundColor3=C.GREEN_BG,TextColor3=C.GREEN}):Play()
            Tween:Create(tgs,TI,{Color=C.BORDER_ACT}):Play()
        else
            tg.Text="[ OFF ]"
            if espConn then espConn:Disconnect() espConn=nil end
            for _, g in pairs(espBB) do if g then g:Destroy() end end
            for _, h in pairs(espHL) do if h then h:Destroy() end end
            espBB, espHL = {}, {}
            Tween:Create(row,TI,{BackgroundColor3=C.CARD}):Play()
            Tween:Create(stroke,TI,{Color=C.BORDER,Thickness=1}):Play()
            Tween:Create(tg,TI,{BackgroundColor3=C.BTN,TextColor3=C.RED}):Play()
            Tween:Create(tgs,TI,{Color=Color3.fromRGB(40,20,20)}):Play()
        end
    end)
    clr.MouseButton1Click:Connect(function()
        for p, b in pairs(espExcBtns) do
            espExcBtns[p]=false
            b.Text="[ ] "..p.Name
            b.TextColor3=Color3.fromRGB(180,180,180)
            b.BackgroundColor3=C.BTN
        end
        syncSpec()
    end)
    Players.PlayerAdded:Connect(function() refreshExc() end)
    Players.PlayerRemoving:Connect(function(p)
        if espExcBtns[p] then espExcBtns[p]=nil end
        syncSpec(); task.defer(refreshExc)
    end)
    
    local fbConn
    local origB, origC, origS, origO, origA
    X.createToggle("VISUAL","FULLBRIGHT",2,function(e)
        if e then
            origB=Light.Brightness; origC=Light.ClockTime
            origS=Light.GlobalShadows; origO=Light.OutdoorAmbient; origA=Light.Ambient
            fbConn=Run.RenderStepped:Connect(function()
                Light.Brightness=2; Light.ClockTime=14
                Light.GlobalShadows=false
                Light.OutdoorAmbient=Color3.fromRGB(255,255,255)
                Light.Ambient=Color3.fromRGB(255,255,255)
            end)
        else
            if fbConn then fbConn:Disconnect() fbConn=nil end
            if origB then Light.Brightness=origB end
            if origC then Light.ClockTime=origC end
            if origS ~= nil then Light.GlobalShadows=origS end
            if origO then Light.OutdoorAmbient=origO end
            if origA then Light.Ambient=origA end
        end
    end,"☀")
    
    local nfConn
    local origFE, origFS
    local origAtm = {}
    X.createToggle("VISUAL","NO_FOG",3,function(e)
        if e then
            origFE=Light.FogEnd; origFS=Light.FogStart
            origAtm={}
            for _, c in ipairs(Light:GetChildren()) do
                if c:IsA("Atmosphere") then origAtm[c]=c.Density end
            end
            nfConn=Run.RenderStepped:Connect(function()
                Light.FogEnd=1000000; Light.FogStart=0
                for _, c in ipairs(Light:GetChildren()) do
                    if c:IsA("Atmosphere") then c.Density=0 end
                end
            end)
        else
            if nfConn then nfConn:Disconnect() nfConn=nil end
            if origFE then Light.FogEnd=origFE end
            if origFS then Light.FogStart=origFS end
            for c, d in pairs(origAtm) do
                if c and c.Parent then c.Density=d end
            end
            origAtm = {}
        end
    end,"▤")
    
    -- AIMBOT
    do
        local FOV_R, SMOOTH, MAXD = 180, 0.92, 2000
        local fovGui, fovCircle, fovStroke, target, en, conn
        local arow=Instance.new("Frame")
        arow.Size=UDim2.new(1,0,0,42); arow.LayoutOrder=4
        arow.BackgroundColor3=C.CARD; arow.Parent=X.tabs.VISUAL
        local astroke = X.styleCard(arow)
        X.makeIcon(arow,"⊙"); X.makeTitle(arow,"AIMBOT / FOV",-190)
        local fb=Instance.new("TextBox")
        fb.Size=UDim2.new(0,50,0,24); fb.Position=UDim2.new(1,-132,0.5,-12)
        fb.BackgroundColor3=C.BTN; fb.TextColor3=C.TEXT; fb.Text="180"
        fb.TextSize=12; fb.Font=Enum.Font.RobotoMono; fb.ClearTextOnFocus=false
        fb.Parent=arow
        Instance.new("UICorner", fb).CornerRadius=UDim.new(0,4)
        Instance.new("UIStroke", fb).Color=Color3.fromRGB(38,38,38)
        local atg=Instance.new("TextButton")
        atg.Size=UDim2.new(0,72,0,24); atg.Position=UDim2.new(1,-78,0.5,-12)
        atg.BackgroundColor3=C.BTN; atg.TextColor3=C.RED; atg.Text="[ OFF ]"
        atg.TextSize=11; atg.Font=Enum.Font.RobotoMono; atg.AutoButtonColor=false
        atg.Parent=arow
        Instance.new("UICorner", atg).CornerRadius=UDim.new(0,4)
        local atgs=Instance.new("UIStroke", atg); atgs.Color=Color3.fromRGB(40,20,20)
        local function getTgt()
            local cam=workspace.CurrentCamera; if not cam then return nil end
            local v=cam.ViewportSize
            local cn=Vector2.new(v.X*0.5, v.Y*0.5)
            local bt, bs, bw = nil, FOV_R, math.huge
            local lc=LP.Character
            local lr=lc and lc:FindFirstChild("HumanoidRootPart")
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP then
                    local c=p.Character
                    local h=c and c:FindFirstChildOfClass("Humanoid")
                    local hd=c and c:FindFirstChild("Head")
                    if c and h and h.Health>0 and hd and hd.Parent then
                        if not lr or (hd.Position - lr.Position).Magnitude <= MAXD then
                            local sp, on = cam:WorldToViewportPoint(hd.Position)
                            if on and sp.Z > 0 then
                                local pt=Vector2.new(sp.X, sp.Y)
                                local d=(pt - cn).Magnitude
                                local wd=(hd.Position - cam.CFrame.Position).Magnitude
                                if d <= FOV_R then
                                    if d < bs or (math.abs(d-bs)<0.5 and wd<bw) then
                                        bs=d; bw=wd; bt=hd
                                    end
                                end
                            end
                        end
                    end
                end
            end
            return bt
        end
        local function updateCircle(cam)
            if not fovCircle then return end
            local v=cam.ViewportSize
            fovCircle.Size=UDim2.fromOffset(FOV_R*2, FOV_R*2)
            fovCircle.Position=UDim2.fromOffset(v.X*0.5, v.Y*0.5)
        end
        local function destroyFov()
            target=nil
            if fovGui then fovGui:Destroy() fovGui=nil end
            fovCircle, fovStroke = nil, nil
        end
        local function start()
            if conn then conn:Disconnect() conn=nil end
            if fovGui then fovGui:Destroy() end
            fovGui=Instance.new("ScreenGui")
            fovGui.Name="HackerAimbotFOV"
            fovGui.IgnoreGuiInset=true; fovGui.ResetOnSpawn=false
            fovGui.DisplayOrder=999; fovGui.Parent=PG2
            fovCircle=Instance.new("Frame")
            fovCircle.AnchorPoint=Vector2.new(0.5,0.5)
            fovCircle.BackgroundTransparency=1; fovCircle.BorderSizePixel=0
            fovCircle.Parent=fovGui
            Instance.new("UICorner", fovCircle).CornerRadius=UDim.new(1,0)
            fovStroke=Instance.new("UIStroke")
            fovStroke.Thickness=1.5; fovStroke.Transparency=0.15
            fovStroke.Color=Color3.fromRGB(0,255,120); fovStroke.Parent=fovCircle
            local cam=workspace.CurrentCamera
            if cam then updateCircle(cam) end
            conn=Run.RenderStepped:Connect(function()
                local c=workspace.CurrentCamera; if not c then return end
                updateCircle(c)
                if not UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
                    target=nil
                    if fovStroke then fovStroke.Color=Color3.fromRGB(0,255,120) end
                    return
                end
                if target then
                    local tc=target.Parent
                    local tp=tc and Players:GetPlayerFromCharacter(tc)
                    local th=tc and tc:FindFirstChildOfClass("Humanoid")
                    if not tp or not tc or not tc.Parent or not th or th.Health<=0 or not target.Parent then
                        target=nil
                    end
                end
                if not target then target=getTgt() end
                if target then
                    if fovStroke then fovStroke.Color=Color3.fromRGB(255,255,255) end
                    local d=CFrame.lookAt(c.CFrame.Position, target.Position)
                    c.CFrame=c.CFrame:Lerp(d, SMOOTH)
                else
                    if fovStroke then fovStroke.Color=Color3.fromRGB(0,255,120) end
                end
            end)
        end
        local function stop()
            if conn then conn:Disconnect() conn=nil end
            destroyFov()
        end
        fb.FocusLost:Connect(function()
            local v=tonumber(fb.Text)
            if not v then fb.Text=tostring(FOV_R); return end
            FOV_R=math.clamp(math.floor(v), 20, 1000)
            fb.Text=tostring(FOV_R)
            if en and workspace.CurrentCamera then updateCircle(workspace.CurrentCamera) end
        end)
        atg.MouseButton1Click:Connect(function()
            en = not en
            if en then
                atg.Text="[ ON ]"
                Tween:Create(arow,TI,{BackgroundColor3=C.CARD_ACT}):Play()
                Tween:Create(astroke,TI,{Color=C.BORDER_ACT,Thickness=1.2}):Play()
                Tween:Create(atg,TI,{BackgroundColor3=C.GREEN_BG,TextColor3=C.GREEN}):Play()
                Tween:Create(atgs,TI,{Color=C.BORDER_ACT}):Play()
                start()
            else
                atg.Text="[ OFF ]"
                Tween:Create(arow,TI,{BackgroundColor3=C.CARD}):Play()
                Tween:Create(astroke,TI,{Color=C.BORDER,Thickness=1}):Play()
                Tween:Create(atg,TI,{BackgroundColor3=C.BTN,TextColor3=C.RED}):Play()
                Tween:Create(atgs,TI,{Color=Color3.fromRGB(40,20,20)}):Play()
                stop()
            end
        end)
    end
    
    -- INVENTORY VIEWER
    do
        local invConn, invBB, invSig, invSel, invBtns, invList
        local INVP_W, INVP_H = 250, 150
        local invDist = 105
        local INV_MIN, INV_MAX = 20, 300
        local function updateScale(gui, p)
            if not gui or not gui.Parent then return end
            local panel=gui:FindFirstChild("Panel"); if not panel then return end
            panel.Size=UDim2.new(0, INVP_W, 0, INVP_H)
            local cam=workspace.CurrentCamera
            local c=p.Character
            local h=c and c:FindFirstChild("Head")
            if not cam or not h then panel.Visible=false; return end
            local d=(cam.CFrame.Position - h.Position).Magnitude
            if d > invDist then panel.Visible=false; return end
            local wp=h.Position + Vector3.new(0, 2.9, 0)
            local sp, on=cam:WorldToViewportPoint(wp)
            if not on or sp.Z<=0 then panel.Visible=false; return end
            panel.Visible=true
            panel.Position=UDim2.fromOffset(sp.X, sp.Y)
        end
        local function getIcon(item)
            if not item then return "" end
            local t = item:IsA("Tool") and item.TextureId or ""
            if typeof(t)=="string" and t~="" then return t end
            for _, a in ipairs({"Icon","Image","TextureId","IconId"}) do
                local v=item:GetAttribute(a)
                if typeof(v)=="string" and v~="" then return v end
                if typeof(v)=="number" and v>0 then return "rbxassetid://"..tostring(v) end
            end
            for _, cn in ipairs({"Icon","Image","TextureId"}) do
                local c=item:FindFirstChild(cn)
                if c then
                    if c:IsA("StringValue") and c.Value~="" then return c.Value end
                    if (c:IsA("IntValue") or c:IsA("NumberValue")) and c.Value>0 then
                        return "rbxassetid://"..tostring(c.Value)
                    end
                    if (c:IsA("ImageLabel") or c:IsA("ImageButton")) and c.Image~="" then return c.Image end
                end
            end
            return ""
        end
        local function collect(p)
            local g, total = {}, 0
            local bp=p:FindFirstChildOfClass("Backpack")
            local c=p.Character
            local function add(item)
                if not item or not item:IsA("Tool") then return end
                local ic=getIcon(item)
                local k=item.Name.."\0"..ic
                g[k]=g[k] or {Name=item.Name, Icon=ic, Count=0}
                g[k].Count=g[k].Count+1
                total=total+1
            end
            if bp then for _, i in ipairs(bp:GetChildren()) do add(i) end end
            if c then for _, i in ipairs(c:GetChildren()) do add(i) end end
            local items={}
            for _, i in pairs(g) do table.insert(items, i) end
            table.sort(items, function(a,b) return string.lower(a.Name)<string.lower(b.Name) end)
            return items, total, bp and "LIVE" or "CHAR"
        end
        local function mkBB(p)
            local pg=LP:FindFirstChildOfClass("PlayerGui"); if not pg then return nil end
            local c=p.Character
            local h=c and c:FindFirstChild("Head"); if not h then return nil end
            local gui=Instance.new("ScreenGui")
            gui.Name="HackerInventoryViewer_"..tostring(p.UserId)
            gui.IgnoreGuiInset=true; gui.ResetOnSpawn=false
            gui.DisplayOrder=20; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
            gui.Parent=pg
            local main=Instance.new("Frame")
            main.Name="Panel"; main.Size=UDim2.new(0, INVP_W, 0, INVP_H)
            main.AnchorPoint=Vector2.new(0.5,1); main.Visible=false
            main.BackgroundColor3=Color3.fromRGB(11,11,11)
            main.BackgroundTransparency=0.06; main.BorderSizePixel=0; main.Parent=gui
            Instance.new("UICorner", main).CornerRadius=UDim.new(0,7)
            Instance.new("UIStroke", main).Color=Color3.fromRGB(42,42,42)
            local head=Instance.new("Frame")
            head.Name="Header"; head.Size=UDim2.new(1,-8,0,23)
            head.Position=UDim2.new(0,4,0,3)
            head.BackgroundColor3=Color3.fromRGB(18,18,18)
            head.BorderSizePixel=0; head.Parent=main
            Instance.new("UICorner", head).CornerRadius=UDim.new(0,5)
            local nl=Instance.new("TextLabel")
            nl.Name="PlayerName"; nl.Size=UDim2.new(1,-58,1,0); nl.Position=UDim2.new(0,6,0,0)
            nl.BackgroundTransparency=1; nl.TextColor3=Color3.fromRGB(205,205,205)
            nl.Text="[ > ] "..p.Name; nl.TextSize=10; nl.Font=Enum.Font.RobotoMono
            nl.TextXAlignment=Enum.TextXAlignment.Left
            nl.TextTruncate=Enum.TextTruncate.AtEnd; nl.Parent=head
            local ct=Instance.new("TextLabel")
            ct.Name="Count"; ct.Size=UDim2.new(0,54,1,0); ct.Position=UDim2.new(1,-58,0,0)
            ct.BackgroundTransparency=1; ct.TextColor3=Color3.fromRGB(80,160,255)
            ct.Text="0"; ct.TextSize=9; ct.Font=Enum.Font.RobotoMono
            ct.TextXAlignment=Enum.TextXAlignment.Right; ct.Parent=head
            local items=Instance.new("ScrollingFrame")
            items.Name="Items"; items.Size=UDim2.new(1,-8,1,-30)
            items.Position=UDim2.new(0,4,0,29); items.BackgroundTransparency=1
            items.BorderSizePixel=0; items.ScrollBarThickness=2
            items.ScrollBarImageColor3=Color3.fromRGB(65,65,65)
            items.AutomaticCanvasSize=Enum.AutomaticSize.Y; items.Parent=main
            local p2=Instance.new("UIPadding", items)
            p2.PaddingTop=UDim.new(0,2); p2.PaddingBottom=UDim.new(0,3)
            p2.PaddingLeft=UDim.new(0,2); p2.PaddingRight=UDim.new(0,2)
            local g=Instance.new("UIGridLayout", items)
            g.CellSize=UDim2.new(0,52,0,42); g.CellPadding=UDim2.new(0,4,0,4)
            g.SortOrder=Enum.SortOrder.LayoutOrder
            return gui
        end
        local function clearItems(gui)
            local it=gui and gui:FindFirstChild("Panel") and gui.Panel:FindFirstChild("Items")
            if not it then return end
            for _, c in ipairs(it:GetChildren()) do
                if c:IsA("GuiObject") and not c:IsA("UIGridLayout") and not c:IsA("UIPadding") then c:Destroy() end
            end
        end
        local function emptyState(gui, txt, col)
            local it=gui and gui:FindFirstChild("Panel") and gui.Panel:FindFirstChild("Items")
            if not it then return end
            clearItems(gui)
            local e=Instance.new("TextLabel")
            e.Size=UDim2.new(1,-8,0,32)
            e.BackgroundColor3=Color3.fromRGB(16,16,16)
            e.BackgroundTransparency=0.1
            e.TextColor3=col or Color3.fromRGB(130,130,130)
            e.Text=txt; e.TextSize=8; e.Font=Enum.Font.RobotoMono
            e.TextWrapped=true; e.Parent=it
            Instance.new("UICorner", e).CornerRadius=UDim.new(0,5)
        end
        local function rebuild(gui, p)
            if not gui or not gui.Parent then return end
            local panel=gui:FindFirstChild("Panel")
            local it=panel and panel:FindFirstChild("Items")
            local head=panel and panel:FindFirstChild("Header")
            if not panel or not it or not head then return end
            local ct=head:FindFirstChild("Count")
            local nl=head:FindFirstChild("PlayerName")
            local items, total, src = collect(p)
            local sp={src, tostring(total)}
            for _, i in ipairs(items) do table.insert(sp, i.Name.."x"..tostring(i.Count).."["..i.Icon.."]") end
            local sig=table.concat(sp, "|")
            if invSig[p]==sig then
                if nl then nl.Text="[ > ] "..p.Name end
                return
            end
            invSig[p]=sig; clearItems(gui)
            if nl then nl.Text="[ > ] "..p.Name end
            if ct then
                ct.Text=tostring(total).." ITEM"..(total==1 and "" or "S")
                ct.TextColor3=total>0 and Color3.fromRGB(80,160,255) or Color3.fromRGB(130,130,130)
            end
            if #items==0 then
                if src=="CHAR" then emptyState(gui, "[ NO BACKPACK DATA ]", Color3.fromRGB(160,120,80))
                else emptyState(gui, "[ EMPTY ]", Color3.fromRGB(130,130,130)) end
                return
            end
            for idx, item in ipairs(items) do
                local cd=Instance.new("Frame")
                cd.BackgroundColor3=Color3.fromRGB(17,17,17)
                cd.BorderSizePixel=0; cd.LayoutOrder=idx; cd.Parent=it
                Instance.new("UICorner", cd).CornerRadius=UDim.new(0,5)
                Instance.new("UIStroke", cd).Color=Color3.fromRGB(34,34,34)
                local ic=Instance.new("ImageLabel")
                ic.Size=UDim2.new(0,24,0,24); ic.Position=UDim2.new(0.5,-12,0,2)
                ic.BackgroundTransparency=1; ic.Image=item.Icon
                ic.ImageTransparency=item.Icon=="" and 1 or 0; ic.Parent=cd
                local fb2=Instance.new("TextLabel")
                fb2.Size=UDim2.new(0,24,0,24); fb2.Position=UDim2.new(0.5,-12,0,2)
                fb2.BackgroundColor3=Color3.fromRGB(25,25,25)
                fb2.TextColor3=Color3.fromRGB(150,150,150)
                fb2.Text=string.sub(item.Name, 1, 1):upper()
                fb2.TextSize=11; fb2.Font=Enum.Font.RobotoMono
                fb2.Visible=item.Icon==""; fb2.Parent=cd
                Instance.new("UICorner", fb2).CornerRadius=UDim.new(0,4)
                local nm=Instance.new("TextLabel")
                nm.Size=UDim2.new(1,-4,0,10); nm.Position=UDim2.new(0,2,0,24)
                nm.BackgroundTransparency=1; nm.TextColor3=Color3.fromRGB(190,190,190)
                nm.Text=item.Name; nm.TextSize=9; nm.Font=Enum.Font.RobotoMono
                nm.TextTruncate=Enum.TextTruncate.AtEnd; nm.Parent=cd
                local am=Instance.new("TextLabel")
                am.Size=UDim2.new(1,-4,0,9); am.Position=UDim2.new(0,2,1,-10)
                am.BackgroundTransparency=1; am.TextColor3=Color3.fromRGB(80,160,255)
                am.Text="x"..tostring(item.Count); am.TextSize=9
                am.Font=Enum.Font.RobotoMono; am.Parent=cd
            end
        end
        local function cleanup()
            for p, g in pairs(invBB) do
                if g then g:Destroy() end
                invBB[p]=nil; invSig[p]=nil
            end
        end
        local function updateBtns()
            if invList then invList.CanvasPosition=Vector2.new(0,0) end
            local alive={}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP then alive[p]=true end
            end
            local empty = invList and invList:FindFirstChild("ServerEmpty")
            if empty then empty:Destroy() end
            if invList and next(alive)==nil then
                invList.CanvasPosition=Vector2.new(0,0)
                invList.ScrollingEnabled=false
                local l=invList:FindFirstChildOfClass("UIListLayout")
                if l then
                    l.HorizontalAlignment=Enum.HorizontalAlignment.Center
                    l.VerticalAlignment=Enum.VerticalAlignment.Center
                end
                local lbl=Instance.new("TextLabel")
                lbl.Name="ServerEmpty"; lbl.Size=UDim2.new(1,0,1,0)
                lbl.BackgroundTransparency=1; lbl.TextColor3=C.TEXT_DIM
                lbl.Text="[ SERVER EMPTY ]"; lbl.TextSize=14
                lbl.Font=Enum.Font.RobotoMono
                lbl.TextXAlignment=Enum.TextXAlignment.Center
                lbl.TextYAlignment=Enum.TextYAlignment.Center
                lbl.LayoutOrder=-1; lbl.ZIndex=7; lbl.Parent=invList
            elseif invList then
                local l=invList:FindFirstChildOfClass("UIListLayout")
                if l then
                    l.HorizontalAlignment=Enum.HorizontalAlignment.Left
                    l.VerticalAlignment=Enum.VerticalAlignment.Top
                end
            end
            for p, b in pairs(invBtns) do
                if not alive[p] then
                    if b then b:Destroy() end
                    invBtns[p]=nil; invSel[p]=nil
                end
            end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and not invBtns[p] and invList then
                    local b=Instance.new("TextButton")
                    b.Name="Player_"..p.UserId
                    b.Size=UDim2.new(0, math.max(90, math.min(150, #p.Name*8+38)), 0, 24)
                    b.BackgroundColor3=C.BTN; b.TextColor3=Color3.fromRGB(180,180,180)
                    b.Text="[ ] "..p.Name; b.TextSize=11; b.Font=Enum.Font.RobotoMono
                    b.AutoButtonColor=false; b.Active=true
                    b.LayoutOrder=p.UserId; b.ZIndex=6; b.Parent=invList
                    Instance.new("UICorner", b).CornerRadius=UDim.new(0,4)
                    Instance.new("UIStroke", b).Color=Color3.fromRGB(45,45,45)
                    b.MouseButton1Click:Connect(function()
                        invSel[p] = not invSel[p]
                        local s = invSel[p]
                        b.Text = (s and "[✓] " or "[ ] ") .. p.Name
                        b.TextColor3 = s and C.GREEN or Color3.fromRGB(180,180,180)
                        b.BackgroundColor3 = s and C.GREEN_BG or C.BTN
                        if not s then
                            if invBB[p] then invBB[p]:Destroy() end
                            invBB[p]=nil; invSig[p]=nil
                        end
                    end)
                    invBtns[p]=b
                end
            end
            for p, b in pairs(invBtns) do
                if b and b:IsA("TextButton") then
                    local s = invSel[p]==true
                    b.Text = (s and "[✓] " or "[ ] ") .. p.Name
                    b.TextColor3 = s and C.GREEN or Color3.fromRGB(180,180,180)
                    b.BackgroundColor3 = s and C.GREEN_BG or C.BTN
                end
            end
        end
        local row=Instance.new("Frame")
        row.Size=UDim2.new(1,0,0,148); row.LayoutOrder=5
        row.BackgroundColor3=C.CARD; row.Parent=X.tabs.VISUAL
        local stroke = X.styleCard(row)
        X.makeIcon(row,"▤")
        local title=Instance.new("TextLabel")
        title.Size=UDim2.new(1,-140,0,24); title.Position=UDim2.new(0,38,0,4)
        title.BackgroundTransparency=1; title.TextColor3=C.TEXT
        title.Text="INVENTORY_VIEWER"; title.TextSize=12
        title.Font=Enum.Font.RobotoMono; title.TextXAlignment=Enum.TextXAlignment.Left; title.Parent=row
        local sub=Instance.new("TextLabel")
        sub.Size=UDim2.new(1,-140,0,14); sub.Position=UDim2.new(0,38,0,24)
        sub.BackgroundTransparency=1; sub.TextColor3=C.TEXT_MUTE
        sub.Text="SELECT TARGETS"; sub.TextSize=9
        sub.Font=Enum.Font.RobotoMono; sub.TextXAlignment=Enum.TextXAlignment.Left; sub.Parent=row
        local tg=Instance.new("TextButton")
        tg.Size=UDim2.new(0,72,0,24); tg.Position=UDim2.new(1,-82,0,9)
        tg.BackgroundColor3=C.BTN; tg.TextColor3=C.RED; tg.Text="[ OFF ]"
        tg.TextSize=11; tg.Font=Enum.Font.RobotoMono; tg.AutoButtonColor=false; tg.Parent=row
        Instance.new("UICorner", tg).CornerRadius=UDim.new(0,4)
        local tgs=Instance.new("UIStroke", tg); tgs.Color=Color3.fromRGB(40,20,20)
        local dl=Instance.new("TextLabel")
        dl.Size=UDim2.new(0,40,0,20); dl.Position=UDim2.new(0,14,0,48)
        dl.BackgroundTransparency=1; dl.TextColor3=C.TEXT_DIM
        dl.Text="DIST:"; dl.TextSize=10; dl.Font=Enum.Font.RobotoMono
        dl.TextXAlignment=Enum.TextXAlignment.Left; dl.Parent=row
        local db=Instance.new("TextBox")
        db.Size=UDim2.new(0,58,0,24); db.Position=UDim2.new(0,54,0,46)
        db.BackgroundColor3=C.BTN; db.TextColor3=C.TEXT; db.Text="105"
        db.TextSize=10; db.Font=Enum.Font.RobotoMono; db.ClearTextOnFocus=false; db.Parent=row
        Instance.new("UICorner", db).CornerRadius=UDim.new(0,4)
        Instance.new("UIStroke", db).Color=Color3.fromRGB(40,40,40)
        local allB=Instance.new("TextButton")
        allB.Size=UDim2.new(0,54,0,24); allB.Position=UDim2.new(0,118,0,46)
        allB.BackgroundColor3=C.BTN; allB.TextColor3=Color3.fromRGB(100,200,120)
        allB.Text="[ALL]"; allB.TextSize=10; allB.Font=Enum.Font.RobotoMono
        allB.AutoButtonColor=false; allB.Parent=row
        Instance.new("UICorner", allB).CornerRadius=UDim.new(0,4)
        Instance.new("UIStroke", allB).Color=Color3.fromRGB(30,60,40)
        local selfB=Instance.new("TextButton")
        selfB.Size=UDim2.new(0,58,0,24); selfB.Position=UDim2.new(0,176,0,46)
        selfB.BackgroundColor3=C.BTN; selfB.TextColor3=Color3.fromRGB(180,180,180)
        selfB.Text="[SELF]"; selfB.TextSize=10; selfB.Font=Enum.Font.RobotoMono
        selfB.AutoButtonColor=false; selfB.Parent=row
        Instance.new("UICorner", selfB).CornerRadius=UDim.new(0,4)
        Instance.new("UIStroke", selfB).Color=Color3.fromRGB(45,45,45)
        local clrB=Instance.new("TextButton")
        clrB.Size=UDim2.new(0,60,0,24); clrB.Position=UDim2.new(0,238,0,46)
        clrB.BackgroundColor3=C.RED_BG; clrB.TextColor3=Color3.fromRGB(235,70,70)
        clrB.Text="[CLR]"; clrB.TextSize=10; clrB.Font=Enum.Font.RobotoMono
        clrB.AutoButtonColor=false; clrB.Parent=row
        Instance.new("UICorner", clrB).CornerRadius=UDim.new(0,4)
        Instance.new("UIStroke", clrB).Color=Color3.fromRGB(90,20,20)
        invList=Instance.new("ScrollingFrame")
        invList.Size=UDim2.new(1,-20,0,40); invList.Position=UDim2.new(0,10,0,84)
        invList.BackgroundColor3=Color3.fromRGB(11,11,11)
        invList.BorderSizePixel=0; invList.ScrollBarThickness=0
        invList.ScrollingDirection=Enum.ScrollingDirection.X
        invList.CanvasSize=UDim2.new(0,0,0,40)
        invList.AutomaticCanvasSize=Enum.AutomaticSize.None
        invList.ClipsDescendants=true; invList.Active=true; invList.ZIndex=5
        invList.Parent=row
        Instance.new("UICorner", invList).CornerRadius=UDim.new(0,4)
        Instance.new("UIStroke", invList).Color=Color3.fromRGB(30,30,30)
        local il=Instance.new("UIListLayout", invList)
        il.FillDirection=Enum.FillDirection.Horizontal
        il.HorizontalAlignment=Enum.HorizontalAlignment.Left
        il.VerticalAlignment=Enum.VerticalAlignment.Top
        il.Padding=UDim.new(0,5); il.SortOrder=Enum.SortOrder.LayoutOrder
        local ip=Instance.new("UIPadding", invList)
        ip.PaddingLeft=UDim.new(0,5); ip.PaddingRight=UDim.new(0,5)
        ip.PaddingTop=UDim.new(0,4)
        X.enableArrowScroll(invList)
        invConn, invBB, invSig, invSel, invBtns = nil, {}, {}, {}, {}
        updateBtns()
        task.defer(updateBtns)
        Players.PlayerAdded:Connect(function() task.defer(updateBtns) end)
        Players.PlayerRemoving:Connect(function(p)
            invSel[p]=nil
            if invBB[p] then invBB[p]:Destroy() end
            invBB[p]=nil; invSig[p]=nil
            task.defer(updateBtns)
        end)
        db.FocusLost:Connect(function()
            local v=tonumber(db.Text)
            if not v then v=invDist end
            v=math.clamp(math.floor(v+0.5), INV_MIN, INV_MAX)
            invDist=v; db.Text=tostring(v)
        end)
        allB.MouseButton1Click:Connect(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP then invSel[p]=true end
            end
            updateBtns()
        end)
        selfB.MouseButton1Click:Connect(function()
            invSel = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP then invSel[p]=true end
            end
            updateBtns()
        end)
        clrB.MouseButton1Click:Connect(function()
            invSel = {}
            cleanup(); updateBtns()
        end)
        local en = false
        local el2 = 0
        tg.MouseButton1Click:Connect(function()
            en = not en
            if en then
                tg.Text="[ ON ]"
                Tween:Create(row,TI,{BackgroundColor3=C.CARD_ACT}):Play()
                Tween:Create(stroke,TI,{Color=C.BORDER_ACT,Thickness=1.2}):Play()
                Tween:Create(tg,TI,{BackgroundColor3=C.GREEN_BG,TextColor3=C.GREEN}):Play()
                Tween:Create(tgs,TI,{Color=C.BORDER_ACT}):Play()
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LP then invSel[p]=true end
                end
                updateBtns()
                el2 = 0
                invConn = Run.Heartbeat:Connect(function(dt)
                    for p, g in pairs(invBB) do
                        if invSel[p] and g and g.Parent then updateScale(g, p) end
                    end
                    el2 = el2 + dt
                    if el2 < 0.4 then return end
                    el2 = 0
                    updateBtns()
                    local act = {}
                    for p, s in pairs(invSel) do
                        if s and p ~= LP and p.Parent then
                            local c=p.Character
                            local h=c and c:FindFirstChildOfClass("Humanoid")
                            local hd=c and c:FindFirstChild("Head")
                            if hd and h and h.Health>0 then
                                act[p]=true
                                local g=invBB[p]
                                if not g or not g.Parent then
                                    if g then g:Destroy() end
                                    g=mkBB(p); invBB[p]=g; invSig[p]=nil
                                end
                                if g then rebuild(g, p) end
                            end
                        end
                    end
                    for p, g in pairs(invBB) do
                        if not act[p] then
                            if g then g:Destroy() end
                            invBB[p]=nil; invSig[p]=nil
                        end
                    end
                end)
            else
                tg.Text="[ OFF ]"
                Tween:Create(row,TI,{BackgroundColor3=C.CARD}):Play()
                Tween:Create(stroke,TI,{Color=C.BORDER,Thickness=1}):Play()
                Tween:Create(tg,TI,{BackgroundColor3=C.BTN,TextColor3=C.RED}):Play()
                Tween:Create(tgs,TI,{Color=Color3.fromRGB(40,20,20)}):Play()
                if invConn then invConn:Disconnect() invConn=nil end
                cleanup()
            end
        end)
    end
end

-- ========== FREECAM ==========
do
    local UIS, Run = X.UIS, X.Run
    local active, camera, root
    local savedAnch, savedCamType, savedSubj
    local savedMB, savedMI, savedCF, savedFov
    local position, yaw, pitch, mouseHeld
    local speed = 42
    local keys = {}
    local connections = {}
    local renderConn
    local function cleanupConn()
        for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
        table.clear(connections)
        if renderConn then renderConn:Disconnect() renderConn=nil end
    end
    local function fcStop()
        if not active then return end
        active = false
        cleanupConn()
        UIS.MouseBehavior = savedMB or Enum.MouseBehavior.Default
        if savedMI ~= nil then UIS.MouseIconEnabled = savedMI end
        if root and root.Parent and savedAnch ~= nil then
            pcall(function()
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                root.Anchored = savedAnch
            end)
        end
        local cam = workspace.CurrentCamera or camera
        if cam then
            cam.CameraType = savedCamType or Enum.CameraType.Custom
            local c = LP.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            cam.CameraSubject = h or savedSubj
            if savedCF then cam.CFrame = savedCF end
            if savedFov then cam.FieldOfView = savedFov end
        end
        table.clear(keys)
        camera, root, position = nil, nil, nil
        mouseHeld = false
    end
    local function fcStart()
        if active then return end
        local cam = workspace.CurrentCamera
        local c = LP.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if not cam or not r then return false end
        active = true
        camera, root = cam, r
        savedAnch = r.Anchored
        savedCamType, savedSubj = cam.CameraType, cam.CameraSubject
        savedCF, savedFov = cam.CFrame, cam.FieldOfView
        savedMB, savedMI = UIS.MouseBehavior, UIS.MouseIconEnabled
        local look = cam.CFrame.LookVector
        position = cam.CFrame.Position
        yaw = math.atan2(-look.X, -look.Z)
        pitch = math.asin(math.clamp(look.Y, -0.98, 0.98))
        table.clear(keys)
        r.AssemblyLinearVelocity = Vector3.zero
        r.AssemblyAngularVelocity = Vector3.zero
        r.Anchored = true
        cam.CameraType = Enum.CameraType.Scriptable
        UIS.M           ouseBehavior = Enum.MouseBehavior.Default
        table.insert(connections, UIS.InputBegan:Connect(function(i, p)
            if not active then return end
            if i.UserInputType == Enum.UserInputType.MouseButton2 then
                mouseHeld = true
                UIS.MouseBehavior = Enum.MouseBehavior.LockCurrentPosition
            elseif not p and (i.KeyCode==Enum.KeyCode.W or i.KeyCode==Enum.KeyCode.A
                or i.KeyCode==Enum.KeyCode.S or i.KeyCode==Enum.KeyCode.D
                or i.KeyCode==Enum.KeyCode.Space or i.KeyCode==Enum.KeyCode.LeftShift
                or i.KeyCode==Enum.KeyCode.RightShift or i.KeyCode==Enum.KeyCode.LeftControl
                or i.KeyCode==Enum.KeyCode.RightControl) then
                keys[i.KeyCode] = true
            end
        end))
        table.insert(connections, UIS.InputEnded:Connect(function(i)
 if i.UserInputType == Enum.UserInputType.MouseButton2 then
                mouseHeld = false
                UIS.MouseBehavior = Enum.MouseBehavior.Default
            end
            keys[i.KeyCode] = nil
        end))
        table.insert(connections, UIS.InputChanged:Connect(function(i)
            if not active then return end
            if mouseHeld and i.UserInputType == Enum.UserInputType.MouseMovement then
                yaw = yaw - i.Delta.X * 0.0025
                pitch = math.clamp(pitch - i.Delta.Y * 0.0025, math.rad(-85), math.rad(85))
            end
        end))
        renderConn = Run.RenderStepped:Connect(function(dt)
            if not active or not camera then return end
            local rot = CFrame.fromOrientation(pitch, yaw, 0)
            local mv = Vector3.zero
            if keys[Enum.KeyCode.W] then mv = mv + rot.LookVector end
            if keys[Enum.KeyCode.S] then mv = mv - rot.LookVector end
            if keys[Enum.KeyCode.D] then mv = mv + rot.RightVector end
            if keys[Enum.KeyCode.A] then mv = mv - rot.RightVector end
            local fd = math.clamp(dt, 0, 0.05)
            if mv.Magnitude > 0 then position = position + mv.Unit * speed * fd end
            if keys[Enum.KeyCode.LeftControl] or keys[Enum.KeyCode.RightControl] then
                position = position + Vector3.yAxis * -(speed * (24/42)) * fd
            elseif keys[Enum.KeyCode.Space] then
                position = position + Vector3.yAxis * (speed * (20/42)) * fd
            elseif keys[Enum.KeyCode.LeftShift] or keys[Enum.KeyCode.RightShift] then
                position = position + Vector3.yAxis * -(speed * (20/42)) * fd
            end
            camera.CFrame = CFrame.lookAt(position, position + rot.LookVector)
        end)
        return true
    end
    local row=Instance.new("Frame")
    row.Size=UDim2.new(1,0,0,42); row.LayoutOrder=6
    row.BackgroundColor3=C.CARD; row.Parent=X.tabs.VISUAL
    local stroke=X.styleCard(row)
    X.makeIcon(row,"◎"); X.makeTitle(row,"FREECAM / SPEED",-190)
    local sb=Instance.new("TextBox")
    sb.Size=UDim2.new(0,50,0,24); sb.Position=UDim2.new(1,-132,0.5,-12)
    sb.BackgroundColor3=C.BTN; sb.TextColor3=C.TEXT; sb.Text=tostring(speed)
    sb.TextSize=12; sb.Font=Enum.Font.RobotoMono; sb.ClearTextOnFocus=false; sb.Parent=row
    Instance.new("UICorner", sb).CornerRadius=UDim.new(0,4)
    Instance.new("UIStroke", sb).Color=Color3.fromRGB(38,38,38)
    sb.FocusLost:Connect(function()
        local v=tonumber(sb.Text)
        if not v then sb.Text=tostring(speed); return end
        speed=math.clamp(math.floor(v), 1, 200)
        sb.Text=tostring(speed)
    end)
    local tg=Instance.new("TextButton")
    tg.Size=UDim2.new(0,72,0,24); tg.Position=UDim2.new(1,-78,0.5,-12)
    tg.BackgroundColor3=C.BTN; tg.TextColor3=C.RED; tg.Text="[ OFF ]"
    tg.TextSize=11; tg.Font=Enum.Font.RobotoMono; tg.AutoButtonColor=false; tg.Parent=row
    Instance.new("UICorner", tg).CornerRadius=UDim.new(0,4)
    local tgs=Instance.new("UIStroke", tg); tgs.Color=Color3.fromRGB(40,20,20)
    local en=false
    tg.MouseButton1Click:Connect(function()
        en=not en
        if en then
            tg.Text="[ ON ]"
            Tween:Create(row,TI,{BackgroundColor3=C.CARD_ACT}):Play()
            Tween:Create(stroke,TI,{Color=C.BORDER_ACT,Thickness=1.2}):Play()
            Tween:Create(tg,TI,{BackgroundColor3=C.GREEN_BG,TextColor3=C.GREEN}):Play()
            Tween:Create(tgs,TI,{Color=C.BORDER_ACT}):Play()
            if not fcStart() then task.defer(fcStop) end
        else
            tg.Text="[ OFF ]"
            Tween:Create(row,TI,{BackgroundColor3=C.CARD}):Play()
            Tween:Create(stroke,TI,{Color=C.BORDER,Thickness=1}):Play()
            Tween:Create(tg,TI,{BackgroundColor3=C.BTN,TextColor3=C.RED}):Play()
            Tween:Create(tgs,TI,{Color=Color3.fromRGB(40,20,20)}):Play()
            fcStop()
        end
    end)
    LP.CharacterAdded:Connect(function()
        if active then task.defer(fcStop) end
    end)
end

-- ========== SETTINGS ==========
do
    local VU = X.VU
    X.createButton("SETTINGS","UI_THEME_DARK",1,function()
        print("[SETTINGS]: Dark theme already active.")
    end,"▦")
    local afkConn
    X.createToggle("SETTINGS","ANTI_AFK",2,function(e)
        if e then
            afkConn = LP.Idled:Connect(function()
                VU:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VU:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        else
            if afkConn then afkConn:Disconnect() afkConn=nil end
        end
    end,"◐")
    local origHolds = {}
    local ipConn
    X.createToggle("SETTINGS","INSTANT_PROMPT",3,function(e)
        if e then
            for _, d in ipairs(workspace:GetDescendants()) do
                if d:IsA("ProximityPrompt") then
                    origHolds[d] = d.HoldDuration
                    d.HoldDuration = 0
                end
            end
            ipConn = workspace.DescendantAdded:Connect(function(d)
                if d:IsA("ProximityPrompt") then
                    origHolds[d] = d.HoldDuration
                    d.HoldDuration = 0
                end
            end)
        else
            if ipConn then ipConn:Disconnect() ipConn=nil end
            for p, o in pairs(origHolds) do
                if p and p.Parent then p.HoldDuration = o end
            end
            origHolds = {}
        end
    end,"⚡")
end

X.switchTab("VISUAL")
