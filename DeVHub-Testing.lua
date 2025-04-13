-- DevHub: Script Ajustado (HUD Modernizado)

-- Evitar múltiplas execuções
if getgenv().DevHubLoaded then 
    warn("Script já carregado anteriormente, abortando...")
    return 
end
getgenv().DevHubLoaded = true

-- Log básico
local debugLog = {} -- Tabela para armazenar logs
local debugLogString = ""
local logGui
local logText
local lastLogTimes = {} -- Para rastrear o tempo do último log de cada mensagem
local MAX_LOG_LINES = 100 -- Limite de linhas na janela de logs

-- Função pra adicionar logs com cooldown
local function addDebugLog(message)
    local currentTime = tick()
    
    if lastLogTimes[message] and (currentTime - lastLogTimes[message] < 1) then
        return
    end
    
    lastLogTimes[message] = currentTime
    
    table.insert(debugLog, message)
    
    if #debugLog > MAX_LOG_LINES then
        table.remove(debugLog, 1)
    end
    
    if logText then
        logText.Text = "Logs:\n" .. table.concat(debugLog, "\n")
    end
    
    print("[DevHub Log]: " .. message)
end

addDebugLog("Iniciando script ajustado...")

-- Função pra criar a janela de logs
local function createLogWindow()
    addDebugLog("Tentando criar janela de logs...")
    logGui = Instance.new("ScreenGui")
    logGui.Name = "DevHubLogGui"
    logGui.ResetOnSpawn = false
    logGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    logGui.DisplayOrder = 10000
    
    local parent
    local successCoreGui, errCoreGui = pcall(function()
        parent = game:GetService("CoreGui")
        logGui.Parent = parent
    end)
    if not successCoreGui then
        addDebugLog("Falha ao usar CoreGui - " .. tostring(errCoreGui))
        local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            parent = playerGui
            logGui.Parent = playerGui
            addDebugLog("Usando PlayerGui como fallback para logs")
        else
            addDebugLog("PlayerGui não encontrado")
            return
        end
    end
    addDebugLog("ScreenGui de logs criada com parent: " .. tostring(parent))

    local logFrame = Instance.new("Frame")
    logFrame.Size = UDim2.new(0, 300, 0, 200)
    logFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    logFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    logFrame.BackgroundTransparency = 0.1
    logFrame.ZIndex = 10000
    logFrame.Parent = logGui

    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(0, 12)
    uic.Parent = logFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 128)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = logFrame

    logText = Instance.new("TextLabel")
    logText.Size = UDim2.new(1, -20, 1, -60)
    logText.Position = UDim2.new(0, 10, 0, 10)
    logText.BackgroundTransparency = 1
    logText.TextColor3 = Color3.fromRGB(255, 255, 255)
    logText.Text = "Logs:\n" .. table.concat(debugLog, "\n")
    logText.TextSize = 14
    logText.TextWrapped = true
    logText.TextYAlignment = Enum.TextYAlignment.Top
    logText.ZIndex = 10001
    logText.Font = Enum.Font.Gotham
    logText.Parent = logFrame

    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0, 100, 0, 30)
    copyBtn.Position = UDim2.new(0, 10, 1, -40)
    copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyBtn.Text = "Copiar Log"
    copyBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    copyBtn.BackgroundTransparency = 0.1
    copyBtn.TextSize = 14
    copy- Tela cheia
    copyBtn.ZIndex = 10002
    copyBtn.Font = Enum.Font.Gotham
    copyBtn.Parent = logFrame

    local strokeCopy = Instance.new("UIStroke")
    strokeCopy.Color = Color3.fromRGB(0, 255, 128)
    strokeCopy.Thickness = 1
    strokeCopy.Transparency = 0.5
    strokeCopy.Parent = copyBtn

    local uicCopy = Instance.new("UICorner")
    uicCopy.CornerRadius = UDim.new(0, 8)
    uicCopy.Parent = copyBtn

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 100, 0, 30)
    closeBtn.Position = UDim2.new(1, -110, 1, -40)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Text = "Fechar"
    closeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    closeBtn.BackgroundTransparency = 0.1
    closeBtn.TextSize = 14
    closeBtn.ZIndex = 10002
    closeBtn.Font = Enum.Font.Gotham
    closeBtn.Parent = logFrame

    local strokeClose = Instance.new("UIStroke")
    strokeClose.Color = Color3.fromRGB(0, 255, 128)
    strokeClose.Thickness = 1
    strokeClose.Transparency = 0.5
    strokeClose.Parent = closeBtn

    local uicClose = Instance.new("UICorner")
    uicClose.CornerRadius = UDim.new(0, 8)
    uicClose.Parent = closeBtn

    copyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(table.concat(debugLog, "\n"))
            addDebugLog("Log copiado para o clipboard")
        else
            addDebugLog("Executor não suporta setclipboard")
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        logGui:Destroy()
        logGui = nil
        logText = nil
        addDebugLog("Janela de logs fechada")
    end)

    addDebugLog("Janela de logs criada com sucesso")
end

-- Sistema de notificações
local function showNotification(message, notificationType)
    local ScreenGui = game:GetService("CoreGui"):FindFirstChild("DevHubUI") or game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if not ScreenGui then 
        addDebugLog("Erro: ScreenGui não encontrada para notificação")
        return 
    end

    local notifFrame = Instance.new("Frame")
    notifFrame.Size = UDim2.new(0, 200, 0, 40)
    notifFrame.Position = UDim2.new(1, -220, 1, -60)
    notifFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    notifFrame.BackgroundTransparency = 0.1
    notifFrame.ZIndex = 10000
    notifFrame.Parent = ScreenGui

    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(0, 8)
    uic.Parent = notifFrame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = notifFrame

    if notificationType == "error" then
        stroke.Color = Color3.fromRGB(255, 100, 100)
    elseif notificationType == "success" then
        stroke.Color = Color3.fromRGB(0, 255, 128)
    else
        stroke.Color = Color3.fromRGB(100, 100, 255)
    end

    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -10, 1, 0)
    notifText.Position = UDim2.new(0, 5, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.Text = message
    notifText.TextSize = 14
    notifText.ZIndex = 10001
    notifText.Font = Enum.Font.Gotham
    notifText.Parent = notifFrame

    local TweenService = game:GetService("TweenService")
    local slideUp = TweenService:Create(notifFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, -220, 1, -80)})
    slideUp:Play()

    task.delay(2, function()
        local slideDown = TweenService:Create(notifFrame, TweenInfo.new(0.3), {Position = UDim2.new(1, -220, 1, -60)})
        slideDown:Play()
        slideDown.Completed:Connect(function()
            notifFrame:Destroy()
        end)
    end)
end

-- Inicialização
local success, err = pcall(function()
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    addDebugLog("Serviços carregados com sucesso")

    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then
        addDebugLog("LocalPlayer não encontrado, esperando...")
        LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
    end
    addDebugLog("LocalPlayer carregado - " .. (LocalPlayer and LocalPlayer.Name or "N/A"))

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "DevHubUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 10000
    
    local parentSet = false
    local successCoreGui, errCoreGui = pcall(function()
        ScreenGui.Parent = game:GetService("CoreGui")
        parentSet = true
        addDebugLog("ScreenGui criada no CoreGui")
    end)
    if not successCoreGui then
        addDebugLog("Falha ao usar CoreGui - " .. tostring(errCoreGui))
        local playerGui = LocalPlayer:WaitForChild("PlayerGui", 5)
        if playerGui then
            ScreenGui.Parent = playerGui
            parentSet = true
            addDebugLog("Usando PlayerGui como fallback")
        else
            addDebugLog("PlayerGui não encontrado após espera")
        end
    end
    
    if not parentSet then
        error("Não foi possível definir o parent da ScreenGui")
    end
    addDebugLog("ScreenGui criada com sucesso")

    local flySpeed = 50
    local flying = false
    local flyConnection
    local bodyVelocity
    local noclip = false
    local verticalFly = 0
    local selectedPlayer = nil

    local function createUICorner(obj, rad)
        local uic = Instance.new("UICorner")
        uic.CornerRadius = UDim.new(0, rad)
        uic.Parent = obj
    end

    local function neonify(obj)
        obj.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        obj.BackgroundTransparency = 0.1
        obj.BorderSizePixel = 0
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 255, 128)
        stroke.Thickness = 1
        stroke.Transparency = 0.5
        stroke.Parent = obj
    end

    local floatingButton = Instance.new("TextButton")
    floatingButton.Size = UDim2.new(0, 50, 0, 50)
    floatingButton.Position = UDim2.new(0, 20, 0.5, -25)
    floatingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    floatingButton.Text = "≡"
    floatingButton.ZIndex = 10000
    floatingButton.Font = Enum.Font.Gotham
    floatingButton.TextSize = 20
    floatingButton.Parent = ScreenGui
    createUICorner(floatingButton, 10)
    neonify(floatingButton)
    addDebugLog("Botão flutuante criado com sucesso")

    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 600, 0, 350)
    Main.Position = UDim2.new(0.5, -300, 0.5, -175)
    Main.BackgroundTransparency = 1
    Main.ZIndex = 10000
    Main.Visible = false
    Main.Parent = ScreenGui
    createUICorner(Main, 20)

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
    })
    gradient.Rotation = 45
    gradient.Parent = Main
    neonify(Main)
    addDebugLog("Frame principal criado com gradiente")

    local dragBar = Instance.new("Frame")
    dragBar.Size = UDim2.new(1, 0, 0, 40)
    dragBar.Position = UDim2.new(0, 0, 0, 0)
    dragBar.BackgroundTransparency = 1
    dragBar.ZIndex = 10002
    dragBar.Parent = Main

    local function createButton(text, parent, position, size, isTab)
        local btn = Instance.new("TextButton")
        btn.Size = size or UDim2.new(0, 100, 0, 25)
        btn.Position = position
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = text
        btn.ZIndex = 10001
        btn.TextSize = 12
        btn.Font = Enum.Font.Gotham
        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        btn.BackgroundTransparency = isTab and 0.3 or 0.1
        btn.Parent = parent
        createUICorner(btn, 8)
        if not isTab then
            neonify(btn)
        end

        local defaultColor = btn.BackgroundColor3
        local hoverColor = Color3.fromRGB(50, 50, 50)

        local function tweenColor(toColor)
            TweenService:Create(btn, TweenInfo.new(0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundColor3 = toColor}):Play()
        end

        btn.MouseEnter:Connect(function() tweenColor(hoverColor) end)
        btn.MouseLeave:Connect(function() tweenColor(defaultColor) end)

        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                tweenColor(hoverColor)
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                tweenColor(defaultColor)
            end
        end)

        return btn
    end

    local function createToggle(text, parent, position, toggle)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(0, 130, 0, 20)
        toggleFrame.Position = position
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.ZIndex = 10001
        toggleFrame.Parent = parent

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 80, 1, 0)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Text = text
        label.TextSize = 10
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.ZIndex = 10002
        label.Parent = toggleFrame

        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 36, 0, 16)
        toggleBtn.Position = UDim2.new(1, -36, 0.5, -8)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        toggleBtn.BackgroundTransparency = 0.1
        toggleBtn.Text = ""
        toggleBtn.ZIndex = 10002
        toggleBtn.Parent = toggleFrame
        createUICorner(toggleBtn, 8)

        local toggleKnob = Instance.new("Frame")
        toggleKnob.Size = UDim2.new(0, 12, 0, 12)
        toggleKnob.Position = UDim2.new(0, 4, 0.5, -6)
        toggleKnob.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        toggleKnob.ZIndex = 10003
        toggleKnob.Parent = toggleBtn
        createUICorner(toggleKnob, 6)

        local function updateToggle(state)
            local knobPos = state and UDim2.new(1, -16, 0.5, -6) or UDim2.new(0, 4, 0.5, -6)
            local knobColor = state and Color3.fromRGB(0, 255, 128) or Color3.fromRGB(100, 100, 100)
            TweenService:Create(toggleKnob, TweenInfo.new(0.2), {Position = knobPos, BackgroundColor3 = knobColor}):Play()
        end

        toggleBtn.MouseButton1Click:Connect(function()
            toggle.state = not toggle.state
            updateToggle(toggle.state)
            if toggle.onToggle then
                toggle.onToggle(toggle.state)
            end
        end)

        updateToggle(toggle.state)
        return toggleFrame
    end

    local tabButtonsFrame = Instance.new("Frame")
    tabButtonsFrame.Size = UDim2.new(0, 120, 1, -40)
    tabButtonsFrame.Position = UDim2.new(0, 10, 0, 40)
    tabButtonsFrame.BackgroundTransparency = 1
    tabButtonsFrame.ZIndex = 10000
    tabButtonsFrame.Parent = Main

    local miscTabButton = createButton("Misc", tabButtonsFrame, UDim2.new(0, 0, 0, 10), UDim2.new(1, -10, 0, 30), true)
    local logsTabButton = createButton("Logs", tabButtonsFrame, UDim2.new(0, 0, 0, 50), UDim2.new(1, -10, 0, 30), true)

    local closeBtn = createButton("X", Main, UDim2.new(1, -30, 0, 5), UDim2.new(0, 25, 0, 25))
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.MouseButton1Click:Connect(function()
        local tweens = {}
        for _, child in pairs(Main:GetDescendants()) do
            if child:IsA("GuiObject") then
                table.insert(tweens, TweenService:Create(child, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}))
            end
        end
        for _, tween in ipairs(tweens) do
            tween:Play()
        end
        TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play():Wait()
        ScreenGui:Destroy()
        if flyConnection then flyConnection:Disconnect() end
        if bodyVelocity then bodyVelocity:Destroy() end
        showNotification("Script fechado!", "info")
        addDebugLog("Script destruído")
        getgenv().DevHubLoaded = nil
    end)

    local minimizeBtn = createButton("−", Main, UDim2.new(1, -60, 0, 5), UDim2.new(0, 25, 0, 25))
    minimizeBtn.MouseButton1Click:Connect(function()
        local tweens = {}
        for _, child in pairs(Main:GetDescendants()) do
            if child:IsA("GuiObject") then
                table.insert(tweens, TweenService:Create(child, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}))
            end
        end
        for _, tween in ipairs(tweens) do
            tween:Play()
        end
        TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play():Wait()
        Main.Visible = false
        floatingButton.Visible = true
        showNotification("HUD minimizado!", "info")
    end)

    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(0, 1, 1, -50)
    divider.Position = UDim2.new(0, 140, 0, 40)
    divider.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
    divider.BackgroundTransparency = 0.5
    divider.BorderSizePixel = 0
    divider.ZIndex = 10000
    divider.Parent = Main

    local miscPage = Instance.new("Frame")
    miscPage.Size = UDim2.new(0, 440, 1, -50)
    miscPage.Position = UDim2.new(0, 150, 0, 40)
    miscPage.BackgroundTransparency = 1
    miscPage.Visible = true
    miscPage.ZIndex = 10000
    miscPage.Parent = Main

    local logsPage = Instance.new("Frame")
    logsPage.Size = UDim2.new(0, 440, 1, -50)
    logsPage.Position = UDim2.new(0, 150, 0, 40)
    logsPage.BackgroundTransparency = 1
    logsPage.Visible = false
    logsPage.ZIndex = 10000
    logsPage.Parent = Main

    local function switchTab(tab)
        miscPage.Visible = (tab == "Misc")
        logsPage.Visible = (tab == "Logs")
        miscTabButton.BackgroundTransparency = (tab == "Misc") and 0.1 or 0.3
        logsTabButton.BackgroundTransparency = (tab == "Logs") and 0.1 or 0.3
    end

    miscTabButton.MouseButton1Click:Connect(function() switchTab("Misc") end)
    logsTabButton.MouseButton1Click:Connect(function() switchTab("Logs") end)

    local flyToggle = { state = false }
    local flyFrame = createToggle("Fly", miscPage, UDim2.new(0, 10, 0, 10), flyToggle)

    local speedFrame = Instance.new("Frame")
    speedFrame.Size = UDim2.new(0, 130, 0, 20)
    speedFrame.Position = UDim2.new(0, 150, 0, 10)
    speedFrame.BackgroundTransparency = 1
    speedFrame.ZIndex = 10000
    speedFrame.Parent = miscPage

    local speedTrack = Instance.new("Frame")
    speedTrack.Size = UDim2.new(1, 0, 0, 4)
    speedTrack.Position = UDim2.new(0, 0, 0.5, -2)
    speedTrack.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    speedTrack.BackgroundTransparency = 0.1
    speedTrack.ZIndex = 10001
    speedTrack.Parent = speedFrame
    createUICorner(speedTrack, 2)
    neonify(speedTrack)

    local speedKnobContainer = Instance.new("Frame")
    speedKnobContainer.Size = UDim2.new(0, 10, 0, 10)
    speedKnobContainer.Position = UDim2.new((flySpeed - 20) / (200 - 20), -5, 0.5, -5)
    speedKnobContainer.BackgroundTransparency = 1
    speedKnobContainer.ZIndex = 10002
    speedKnobContainer.Parent = speedTrack

    local speedKnob = Instance.new("Frame")
    speedKnob.Size = UDim2.new(1, 0, 1, 0)
    speedKnob.Position = UDim2.new(0, 0, 0, 0)
    speedKnob.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    speedKnob.BackgroundTransparency = 0.1
    speedKnob.ZIndex = 10003
    speedKnob.Parent = speedKnobContainer
    createUICorner(speedKnob, 5)
    neonify(speedKnob)

    local touchArea = Instance.new("TextButton")
    touchArea.Size = UDim2.new(0, 20, 0, 20)
    touchArea.Position = UDim2.new(0.5, -10, 0.5, -10)
    touchArea.BackgroundTransparency = 1
    touchArea.Text = ""
    touchArea.ZIndex = 10004
    touchArea.Parent = speedKnobContainer

    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(1, 0, 0, 14)
    speedLabel.Position = UDim2.new(0, 0, 0, -14)
    speedLabel.BackgroundTransparency = 1
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.Text = "Velocidade: " .. flySpeed
    speedLabel.TextSize = 10
    speedLabel.ZIndex = 10001
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.Parent = speedFrame

    local draggingSpeed = false

    local function updateSlider(input)
        local posX = input.Position.X
        local trackPos = speedTrack.AbsolutePosition.X
        local trackWidth = speedTrack.AbsoluteSize.X
        local newPos = math.clamp((posX - trackPos) / trackWidth, 0, 1)
        flySpeed = math.floor(20 + (newPos * (200 - 20)))
        speedKnobContainer.Position = UDim2.new(newPos, -5, 0.5, -5)
        speedLabel.Text = "Velocidade: " .. flySpeed
    end

    touchArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSpeed = true
            updateSlider(input)
        end
    end)

    touchArea.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSpeed = false
            showNotification("Velocidade ajustada para " .. flySpeed, "success")
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingSpeed and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSpeed = false
        end
    end)

    addDebugLog("Slider de velocidade criado")

    local noclipToggle = { state = false }
    local noclipFrame = createToggle("NoClip", miscPage, UDim2.new(0, 10, 0, 40), noclipToggle)

    local espToggle = { state = false }
    local espFrame = createToggle("ESP", miscPage, UDim2.new(0, 10, 0, 70), espToggle)

    local teleportLabel = Instance.new("TextLabel")
    teleportLabel.Size = UDim2.new(0, 80, 0, 20)
    teleportLabel.Position = UDim2.new(0, 10, 0, 100)
    teleportLabel.BackgroundTransparency = 1
    teleportLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportLabel.Text = "Teleporte"
    teleportLabel.TextSize = 10
    teleportLabel.TextXAlignment = Enum.TextXAlignment.Left
    teleportLabel.Font = Enum.Font.Gotham
    teleportLabel.ZIndex = 10001
    teleportLabel.Parent = miscPage

    local selectPlayerBtn = createButton("Selecionar Jogador", miscPage, UDim2.new(0, 150, 0, 100), UDim2.new(0, 100, 0, 20))
    local playerListFrame = Instance.new("ScrollingFrame")
    playerListFrame.Size = UDim2.new(0, 100, 0, 100)
    playerListFrame.Position = UDim2.new(0, 150, 0, 125)
    playerListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    playerListFrame.BackgroundTransparency = 0.1
    playerListFrame.ScrollBarThickness = 4
    playerListFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 128)
    playerListFrame.Visible = false
    playerListFrame.ZIndex = 10002
    playerListFrame.Parent = miscPage
    createUICorner(playerListFrame, 8)
    neonify(playerListFrame)

    local teleportBtn = createButton("Teleportar", miscPage, UDim2.new(0, 150, 0, 230), UDim2.new(0, 100, 0, 20))

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 5)
    uiListLayout.Parent = playerListFrame

    local function updatePlayerList()
        for _, child in pairs(playerListFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        local players = Players:GetPlayers()
        for _, player in ipairs(players) do
            if player ~= LocalPlayer then
                local btn = createButton(player.Name, playerListFrame, UDim2.new(0, 0, 0, 0), UDim2.new(1, -10, 0, 20))
                btn.TextSize = 10
                btn.MouseButton1Click:Connect(function()
                    selectedPlayer = player
                    selectPlayerBtn.Text = player.Name
                    playerListFrame.Visible = false
                end)
            end
        end

        playerListFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
    end

    selectPlayerBtn.MouseButton1Click:Connect(function()
        playerListFrame.Visible = not playerListFrame.Visible
        if playerListFrame.Visible then
            updatePlayerList()
        end
    end)

    teleportBtn.MouseButton1Click:Connect(function()
        if selectedPlayer then
            local character = LocalPlayer.Character
            local targetCharacter = selectedPlayer.Character
            if character and targetCharacter then
                local root = character:FindFirstChild("HumanoidRootPart")
                local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
                if root and targetRoot then
                    root.CFrame = targetRoot.CFrame + Vector3.new(0, 0, 2)
                    showNotification("Teleportado para " .. selectedPlayer.Name, "success")
                    addDebugLog("Teleportado para " .. selectedPlayer.Name)
                else
                    showNotification("Erro: Personagem não encontrado", "error")
                    addDebugLog("Erro: HumanoidRootPart não encontrado para teleporte")
                end
            end
        else
            showNotification("Erro: Selecione um jogador", "error")
            addDebugLog("Erro: Nenhum jogador selecionado para teleporte")
        end
    end)

    Players.PlayerAdded:Connect(updatePlayerList)
    Players.PlayerRemoving:Connect(updatePlayerList)
    addDebugLog("Sistema de teleporte adicionado")

    local espHighlights = {}
    local function updateESP(state)
        local players = Players:GetPlayers()
        if state then
            for _, player in ipairs(players) do
                if player ~= LocalPlayer and player.Character then
                    local highlight = Instance.new("Highlight")
                    highlight.Name = "DevHubESP"
                    highlight.FillColor = Color3.fromRGB(0, 255, 128)
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.FillTransparency = 0.7
                    highlight.OutlineTransparency = 0
                    highlight.Parent = player.Character
                    espHighlights[player] = highlight
                end
            end
        else
            for player, highlight in pairs(espHighlights) do
                if highlight then
                    highlight:Destroy()
                end
            end
            table.clear(espHighlights)
        end
    end

    espToggle.onToggle = function(state)
        updateESP(state)
        showNotification(state and "ESP ativado!" or "ESP desativado!", state and "success" or "info")
        addDebugLog(state and "ESP ativado" or "ESP desativado")
    end

    Players.PlayerAdded:Connect(function(player)
        if espToggle.state and player.Character then
            local highlight = Instance.new("Highlight")
            highlight.Name = "DevHubESP"
            highlight.FillColor = Color3.fromRGB(0, 255, 128)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.7
            highlight.OutlineTransparency = 0
            highlight.Parent = player.Character
            espHighlights[player] = highlight
        end
    end)

    Players.PlayerRemoving:Connect(function(player)
        if espHighlights[player] then
            espHighlights[player]:Destroy()
            espHighlights[player] = nil
        end
    end)
    addDebugLog("Sistema de ESP adicionado")

    local flyControlFrame = Instance.new("Frame")
    flyControlFrame.Size = UDim2.new(0, 80, 0, 80)
    flyControlFrame.Position = UDim2.new(1, -100, 0.5, -40)
    flyControlFrame.BackgroundTransparency = 1
    flyControlFrame.Visible = false
    flyControlFrame.ZIndex = 10000
    flyControlFrame.Parent = ScreenGui

    local upBtn = createButton("↑", flyControlFrame, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0.5, -5))
    upBtn.MouseButton1Down:Connect(function() verticalFly = 1 end)
    upBtn.MouseButton1Up:Connect(function() verticalFly = 0 end)

    local downBtn = createButton("↓", flyControlFrame, UDim2.new(0, 0, 0.5, 5), UDim2.new(1, 0, 0.5, -5))
    downBtn.MouseButton1Down:Connect(function() verticalFly = -1 end)
    downBtn.MouseButton1Up:Connect(function() verticalFly = 0 end)

    local function updateFly()
        local character = LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local cam = workspace.CurrentCamera
        if not root or not humanoid then
            addDebugLog("Erro: Personagem ou HumanoidRootPart não encontrado")
            return
        end

        local camCF = cam.CFrame
        local forward = camCF.LookVector
        local right = camCF.RightVector

        local moveVec = Vector3.zero
        local inputX, inputY, inputZ = 0, verticalFly, 0

        if UserInputService:GetLastInputType() == Enum.UserInputType.Touch then
            moveVec = humanoid.MoveDirection + Vector3.new(0, verticalFly, 0)
        else
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then inputZ = inputZ - 1 end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then inputZ = inputZ + 1 end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then inputX = inputX - 1 end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then inputX = inputX + 1 end
            moveVec = (right * inputX) + (forward * inputZ) + Vector3.new(0, verticalFly, 0)
        end

        if moveVec.Magnitude > 1 then moveVec = moveVec.Unit end
        if bodyVelocity then
            bodyVelocity.Velocity = moveVec * flySpeed
        end
    end

    flyToggle.onToggle = function(state)
        flying = state
        local character = LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then
            addDebugLog("Erro: Não foi possível ativar fly - personagem não carregado")
            flying = false
            flyToggle.state = false
            createToggle("Fly", miscPage, UDim2.new(0, 10, 0, 10), flyToggle)
            showNotification("Erro: Personagem não carregado", "error")
            return
        end

        if state then
            local existing = root:FindFirstChild("DevHubFly")
            if existing then existing:Destroy() end
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.Name = "DevHubFly"
            bodyVelocity.MaxForce = Vector3.new(1, 1, 1) * 1e6
            bodyVelocity.Velocity = Vector3.zero
            bodyVelocity.Parent = root
            humanoid.PlatformStand = true
            flyConnection = RunService.RenderStepped:Connect(updateFly)
            flyControlFrame.Visible = true
            showNotification("Fly ativado!", "success")
            addDebugLog("Fly ativado")
        else
            if bodyVelocity then
                bodyVelocity:Destroy()
                bodyVelocity = nil
            end
            if flyConnection then
                flyConnection:Disconnect()
                flyConnection = nil
            end
            humanoid.PlatformStand = false
            flyControlFrame.Visible = false
            showNotification("Fly desativado!", "info")
            addDebugLog("Fly desativado")
        end
    end

    noclipToggle.onToggle = function(state)
        noclip = state
        if state then
            local connection
            connection = RunService.Stepped:Connect(function()
                if not noclip then
                    connection:Disconnect()
                    return
                end
                local character = LocalPlayer.Character
                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
            showNotification("NoClip ativado!", "success")
            addDebugLog("NoClip ativado")
        else
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
            showNotification("NoClip desativado!", "info")
            addDebugLog("NoClip desativado")
        end
    end

    local logBtn = createButton("Ver Logs", logsPage, UDim2.new(0, 10, 0, 10))
    logBtn.MouseButton1Click:Connect(function()
        createLogWindow()
        showNotification("Logs abertos!", "info")
    end)

    local function makeDraggable(gui, targetFrame)
        local dragging = false
        local dragStart
        local startPos

        gui.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = targetFrame.Position
            end
        end)

        gui.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                targetFrame.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end)

        gui.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
    end

    makeDraggable(dragBar, Main)
    makeDraggable(floatingButton, floatingButton)
    makeDraggable(flyControlFrame, flyControlFrame)

    floatingButton.MouseButton1Click:Connect(function()
        Main.Visible = true
        local tweens = {}
        for _, child in pairs(Main:GetDescendants()) do
            if child:IsA("GuiObject") then
                table.insert(tweens, TweenService:Create(child, TweenInfo.new(0.3), {BackgroundTransparency = child.BackgroundTransparency - 0.1, TextTransparency = 0}))
            end
        end
        for _, tween in ipairs(tweens) do
            tween:Play()
        end
        TweenService:Create(Main, TweenInfo.new(0.3), {BackgroundTransparency = 0.1}):Play()
        floatingButton.Visible = false
        showNotification("HUD aberto!", "info")
    end)

    floatingButton.Visible = true
    addDebugLog("Botão flutuante visível, inicialização concluída")
end)

if not success then
    warn("Erro ao carregar script: " .. tostring(err))
    addDebugLog("Erro crítico: " .. tostring(err))
end
