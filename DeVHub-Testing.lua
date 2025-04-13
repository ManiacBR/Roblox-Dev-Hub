-- DevHub: Script Ajustado (HUD Mais Profissional com Novas Funcionalidades)

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
    
    -- Verificar se a mensagem já foi logada recentemente (cooldown de 1 segundo)
    if lastLogTimes[message] and (currentTime - lastLogTimes[message] < 1) then
        return -- Não logar se estiver dentro do cooldown
    end
    
    lastLogTimes[message] = currentTime
    
    -- Adicionar o log à tabela
    table.insert(debugLog, message)
    
    -- Limitar o número de linhas
    if #debugLog > MAX_LOG_LINES then
        table.remove(debugLog, 1) -- Remove a linha mais antiga
    end
    
    -- Atualizar apenas a UI se necessário
    if logText then
        logText.Text = "Logs:\n" .. table.concat(debugLog, "\n")
    end
    
    -- Exibir no console para depuração
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

    -- Definir cor com base no tipo
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
    -- Carregar serviços
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

    -- Criar ScreenGui
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

    -- Configurações iniciais
    local flySpeed = 50
    local flying = false
    local flyConnection
    local bodyVelocity
    local noclip = false
    local verticalFly = 0

    -- Função pra criar UICorner
    local function createUICorner(obj, rad)
        local uic = Instance.new("UICorner")
        uic.CornerRadius = UDim.new(0, rad)
        uic.Parent = obj
    end

    -- Função pra aplicar estilo neon
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

    -- Criar botão flutuante
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

    -- Criar frame principal (HUD)
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 500, 0, 300)
    Main.Position = UDim2.new(0.5, -250, 0.5, -150)
    Main.BackgroundTransparency = 0.1
    Main.ZIndex = 10000
    Main.Parent = ScreenGui
    createUICorner(Main, 20)

    -- Adicionar gradiente
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
    })
    gradient.Rotation = 45
    gradient.Parent = Main
    neonify(Main)
    addDebugLog("Frame principal criado com gradiente")

    -- Criar área de arrastar (topo da HUD)
    local dragBar = Instance.new("Frame")
    dragBar.Size = UDim2.new(1, 0, 0, 40)
    dragBar.Position = UDim2.new(0, 0, 0, 0)
    dragBar.BackgroundTransparency = 1
    dragBar.ZIndex = 10002
    dragBar.Parent = Main

    -- Função pra criar botões com hover
    local function createButton(text, parent, position, size, isTab)
        local btn = Instance.new("TextButton")
        btn.Size = size or UDim2.new(0, 120, 0, 30)
        btn.Position = position
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = text
        btn.ZIndex = 10001
        btn.TextSize = 14
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

    -- Função pra criar toggles
    local function createToggle(text, parent, position, toggle)
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Size = UDim2.new(0, 150, 0, 24)
        toggleFrame.Position = position
        toggleFrame.BackgroundTransparency = 1
        toggleFrame.ZIndex = 10001
        toggleFrame.Parent = parent

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 90, 1, 0)
        label.Position = UDim2.new(0, 0, 0, 0)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Text = text
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Gotham
        label.ZIndex = 10002
        label.Parent = toggleFrame

        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 40, 0, 20)
        toggleBtn.Position = UDim2.new(1, -40, 0.5, -10)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        toggleBtn.BackgroundTransparency = 0.1
        toggleBtn.Text = ""
        toggleBtn.ZIndex = 10002
        toggleBtn.Parent = toggleFrame
        createUICorner(toggleBtn, 10)

        local toggleKnob = Instance.new("Frame")
        toggleKnob.Size = UDim2.new(0, 16, 0, 16)
        toggleKnob.Position = UDim2.new(0, 4, 0.5, -8)
        toggleKnob.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        toggleKnob.ZIndex = 10003
        toggleKnob.Parent = toggleBtn
        createUICorner(toggleKnob, 8)

        local function updateToggle(state)
            local knobPos = state and UDim2.new(1, -20, 0.5, -8) or UDim2.new(0, 4, 0.5, -8)
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

    -- Criar frame de abas
    local tabButtonsFrame = Instance.new("Frame")
    tabButtonsFrame.Size = UDim2.new(1, 0, 0, 40)
    tabButtonsFrame.BackgroundTransparency = 1
    tabButtonsFrame.Position = UDim2.new(0, 0, 0, 0)
    tabButtonsFrame.Parent = Main

    local movementTabButton = createButton("Movement", tabButtonsFrame, UDim2.new(0, 10, 0, 5), UDim2.new(0, 100, 0, 30), true)
    local logsTabButton = createButton("Logs", tabButtonsFrame, UDim2.new(0, 115, 0, 5), UDim2.new(0, 100, 0, 30), true)
    local playersTabButton = createButton("Players", tabButtonsFrame, UDim2.new(0, 220, 0, 5), UDim2.new(0, 100, 0, 30), true)

    local closeBtn = createButton("X", tabButtonsFrame, UDim2.new(1, -35, 0, 5), UDim2.new(0, 30, 0, 30))
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        if flyConnection then flyConnection:Disconnect() end
        if bodyVelocity then bodyVelocity:Destroy() end
        showNotification("Script fechado!", "info")
        addDebugLog("Script destruído")
        getgenv().DevHubLoaded = nil
    end)

    local minimizeBtn = createButton("−", tabButtonsFrame, UDim2.new(1, -70, 0, 5), UDim2.new(0, 30, 0, 30))
    minimizeBtn.MouseButton1Click:Connect(function()
        Main.Visible = false
        floatingButton.Visible = true
        showNotification("HUD minimizado!", "info")
    end)

    -- Linha divisória abaixo das abas
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, -20, 0, 1)
    divider.Position = UDim2.new(0, 10, 0, 40)
    divider.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
    divider.BackgroundTransparency = 0.5
    divider.BorderSizePixel = 0
    divider.Parent = Main

    -- Criar páginas das abas
    local movementPage = Instance.new("Frame")
    movementPage.Size = UDim2.new(1, 0, 1, -50)
    movementPage.Position = UDim2.new(0, 0, 0, 50)
    movementPage.BackgroundTransparency = 1
    movementPage.Visible = true
    movementPage.Parent = Main

    local logsPage = Instance.new("Frame")
    logsPage.Size = UDim2.new(1, 0, 1, -50)
    logsPage.Position = UDim2.new(0, 0, 0, 50)
    logsPage.BackgroundTransparency = 1
    logsPage.Visible = false
    logsPage.Parent = Main

    local playersPage = Instance.new("Frame")
    playersPage.Size = UDim2.new(1, 0, 1, -50)
    playersPage.Position = UDim2.new(0, 0, 0, 50)
    playersPage.BackgroundTransparency = 1
    playersPage.Visible = false
    playersPage.Parent = Main

    -- Função pra alternar entre abas
    local function switchTab(tab)
        movementPage.Visible = (tab == "Movement")
        logsPage.Visible = (tab == "Logs")
        playersPage.Visible = (tab == "Players")
        movementTabButton.BackgroundTransparency = (tab == "Movement") and 0.1 or 0.3
        logsTabButton.BackgroundTransparency = (tab == "Logs") and 0.1 or 0.3
        playersTabButton.BackgroundTransparency = (tab == "Players") and 0.1 or 0.3
    end

    movementTabButton.MouseButton1Click:Connect(function() switchTab("Movement") end)
    logsTabButton.MouseButton1Click:Connect(function() switchTab("Logs") end)
    playersTabButton.MouseButton1Click:Connect(function() switchTab("Players") end)

    -- Conteúdo da aba Movement
    local flyToggle = { state = false }
    local flyFrame = createToggle("Fly", movementPage, UDim2.new(0, 10, 0, 10), flyToggle)

    -- Slider de velocidade (à direita do Fly)
    local speedFrame = Instance.new("Frame")
    speedFrame.Size = UDim2.new(0, 150, 0, 24)
    speedFrame.Position = UDim2.new(0, 170, 0, 10)
    speedFrame.BackgroundTransparency = 1
    speedFrame.ZIndex = 10000
    speedFrame.Parent = movementPage

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
    speedKnobContainer.Size = UDim2.new(0, 12, 0, 12)
    speedKnobContainer.Position = UDim2.new((flySpeed - 20) / (200 - 20), -6, 0.5, -6)
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
    createUICorner(speedKnob, 6)
    neonify(speedKnob)

    local touchArea = Instance.new("TextButton")
    touchArea.Size = UDim2.new(0, 24, 0, 24)
    touchArea.Position = UDim2.new(0.5, -12, 0.5, -12)
    touchArea.BackgroundTransparency = 1
    touchArea.Text = ""
    touchArea.ZIndex = 10004
    touchArea.Parent = speedKnobContainer

    local speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(1, 0, 0, 16)
    speedLabel.Position = UDim2.new(0, 0, 0, -16)
    speedLabel.BackgroundTransparency = 1
    speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    speedLabel.Text = "Velocidade: " .. flySpeed
    speedLabel.TextSize = 12
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
        speedKnobContainer.Position = UDim2.new(newPos, -6, 0.5, -6)
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

    -- NoClip (abaixo do Fly)
    local noclipToggle = { state = false }
    local noclipFrame = createToggle("NoClip", movementPage, UDim2.new(0, 10, 0, 40), noclipToggle)

    -- ESP (abaixo do NoClip)
    local espToggle = { state = false }
    local espFrame = createToggle("ESP", movementPage, UDim2.new(0, 10, 0, 70), espToggle)

    -- Função para gerenciar ESP
    local espHighlights = {}
    local function updateESP(state)
        local players = game:GetService("Players"):GetPlayers()
        local localPlayer = game:GetService("Players").LocalPlayer

        if state then
            for _, player in ipairs(players) do
                if player ~= localPlayer and player.Character then
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

    game:GetService("Players").PlayerAdded:Connect(function(player)
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

    game:GetService("Players").PlayerRemoving:Connect(function(player)
        if espHighlights[player] then
            espHighlights[player]:Destroy()
            espHighlights[player] = nil
        end
    end)
    addDebugLog("Sistema de ESP adicionado")

    -- Função para gerenciar o fly
    local flyControlFrame = Instance.new("Frame")
    flyControlFrame.Size = UDim2.new(0, 100, 0, 100)
    flyControlFrame.Position = UDim2.new(1, -120, 0.5, -50)
    flyControlFrame.BackgroundTransparency = 1
    flyControlFrame.Visible = false
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

    -- Configurar o toggle de fly
    flyToggle.onToggle = function(state)
        flying = state
        local character = LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then
            addDebugLog("Erro: Não foi possível ativar fly - personagem não carregado")
            flying = false
            flyToggle.state = false
            createToggle("Fly", movementPage, UDim2.new(0, 10, 0, 10), flyToggle)
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

    -- Configurar o toggle de noclip
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

    -- Conteúdo da aba Logs
    local logBtn = createButton("Ver Logs", logsPage, UDim2.new(0, 10, 0, 10))
    logBtn.MouseButton1Click:Connect(function()
        createLogWindow()
        showNotification("Logs abertos!", "info")
    end)

    local commandBox = Instance.new("TextBox")
    commandBox.Size = UDim2.new(1, -20, 0, 30)
    commandBox.Position = UDim2.new(0, 10, 0, 50)
    commandBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    commandBox.BackgroundTransparency = 0.1
    commandBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    commandBox.PlaceholderText = "Digite um comando Lua..."
    commandBox.Text = ""
    commandBox.TextSize = 14
    commandBox.Font = Enum.Font.Gotham
    commandBox.ZIndex = 10001
    commandBox.Parent = logsPage
    createUICorner(commandBox, 8)
    neonify(commandBox)

    commandBox.FocusLost:Connect(function(enterPressed)
        if enterPressed and commandBox.Text ~= "" then
            local success, result = pcall(function()
                local func = loadstring(commandBox.Text)
                if func then
                    return func()
                else
                    error("Comando inválido")
                end
            end)
            if success then
                showNotification("Comando executado com sucesso!", "success")
                addDebugLog("Comando executado: " .. commandBox.Text)
            else
                showNotification("Erro: " .. tostring(result), "error")
                addDebugLog("Erro ao executar comando: " .. tostring(result))
            end
            commandBox.Text = ""
        end
    end)
    addDebugLog("Campo de comando adicionado à aba Logs")

    -- Conteúdo da aba Players
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -20, 1, -60)
    scrollFrame.Position = UDim2.new(0, 10, 0, 10)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 128)
    scrollFrame.ZIndex = 10001
    scrollFrame.Parent = playersPage

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 5)
    uiListLayout.Parent = scrollFrame

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -20, 0, 30)
    searchBox.Position = UDim2.new(0, 10, 1, -40)
    searchBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    searchBox.BackgroundTransparency = 0.1
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.PlaceholderText = "Buscar jogador..."
    searchBox.Text = ""
    searchBox.TextSize = 14
    searchBox.Font = Enum.Font.Gotham
    searchBox.ZIndex = 10001
    searchBox.Parent = playersPage
    createUICorner(searchBox, 8)
    neonify(searchBox)

    local function updatePlayerList(filter)
        for _, child in pairs(scrollFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        local players = game:GetService("Players"):GetPlayers()
        local localPlayer = game:GetService("Players").LocalPlayer

        for _, player in ipairs(players) do
            if player ~= localPlayer and (not filter or string.find(string.lower(player.Name), string.lower(filter))) then
                local btn = createButton(player.Name, scrollFrame, UDim2.new(0, 0, 0, 0), UDim2.new(1, -10, 0, 30))
                btn.MouseButton1Click:Connect(function()
                    local character = localPlayer.Character
                    local targetCharacter = player.Character
                    if character and targetCharacter then
                        local root = character:FindFirstChild("HumanoidRootPart")
                        local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
                        if root and targetRoot then
                            root.CFrame = targetRoot.CFrame + Vector3.new(0, 0, 2)
                            showNotification("Teleportado para " .. player.Name, "success")
                            addDebugLog("Teleportado para " .. player.Name)
                        else
                            showNotification("Erro: Personagem não encontrado", "error")
                            addDebugLog("Erro: HumanoidRootPart não encontrado para teleporte")
                        end
                    end
                end)
            end
        end

        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
    end

    updatePlayerList()
    game:GetService("Players").PlayerAdded:Connect(function() updatePlayerList(searchBox.Text) end)
    game:GetService("Players").PlayerRemoving:Connect(function() updatePlayerList(searchBox.Text) end)

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        updatePlayerList(searchBox.Text)
    end)
    addDebugLog("Aba de jogadores criada com sucesso")

    -- Sistema de arrastar
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

    -- Conectar botão flutuante
    floatingButton.MouseButton1Click:Connect(function()
        Main.Visible = true
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
