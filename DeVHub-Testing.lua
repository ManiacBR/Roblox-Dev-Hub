-- DevHub: Script Ajustado (HUD Mais Profissional)

if getgenv().DevHubLoaded then 
    warn("Script já carregado anteriormente, abortando...")
    return 
end
getgenv().DevHubLoaded = true

-- Declaração de variáveis globais
local Main
local floatingButton

-- Sistema de logs
local debugLog = {}
local debugLogString = ""
local logFilter = "Todos"

local function addDebugLog(message, logType)
    table.insert(debugLog, {text = message, type = logType or "Notificações"})
    if #debugLog > 50 then
        table.remove(debugLog, 1)
    end
    local filteredLogs = {}
    for _, log in ipairs(debugLog) do
        if logFilter == "Todos" or log.type == logFilter then
            table.insert(filteredLogs, log.text)
        end
    end
    debugLogString = table.concat(filteredLogs, "\n")
    if logText then
        logText.Text = "Logs:\n" .. debugLogString
    end
end

-- Sistema de notificações com animação
local function showNotification(message)
    local notification = Instance.new("TextLabel")
    notification.Size = UDim2.new(0, 200, 0, 50)
    notification.Position = UDim2.new(0.5, -100, 1, 50)
    notification.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    notification.BackgroundTransparency = 0.1
    notification.TextColor3 = Color3.fromRGB(255, 255, 255)
    notification.Text = message
    notification.TextSize = 14
    notification.Font = Enum.Font.Gotham
    notification.ZIndex = 10010
    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(0, 10)
    uic.Parent = notification
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 128)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = notification
    notification.Parent = ScreenGui

    local TweenService = game:GetService("TweenService")
    local slideIn = TweenService:Create(notification, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -100, 1, -60)})
    local slideOut = TweenService:Create(notification, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -100, 1, 50)})
    slideIn:Play()
    slideIn.Completed:Connect(function()
        wait(2)
        slideOut:Play()
        slideOut.Completed:Connect(function()
            notification:Destroy()
        end)
    end)
end

addDebugLog("Sistema de notificações carregado", "Notificações")

-- Função para criar a janela de logs com filtros
local function createLogWindow()
    local logFrame = Instance.new("Frame")
    logFrame.Size = UDim2.new(1, -20, 1, -50)
    logFrame.Position = UDim2.new(0, 10, 0, 40)
    logFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    logFrame.BackgroundTransparency = 0.1
    logFrame.ZIndex = 10000
    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(0, 10)
    uic.Parent = logFrame
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 255, 128)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = logFrame
    logFrame.Parent = logsPage

    logText = Instance.new("TextLabel")
    logText.Size = UDim2.new(1, -20, 1, -20)
    logText.Position = UDim2.new(0, 10, 0, 10)
    logText.BackgroundTransparency = 1
    logText.TextColor3 = Color3.fromRGB(255, 255, 255)
    logText.Text = "Logs:\n" .. debugLogString
    logText.TextSize = 12
    logText.TextXAlignment = Enum.TextXAlignment.Left
    logText.TextYAlignment = Enum.TextYAlignment.Top
    logText.Font = Enum.Font.Gotham
    logText.ZIndex = 10001
    logText.Parent = logFrame

    local filterBtn = createButton(logFilter, logFrame, UDim2.new(0, 10, 0, 0), UDim2.new(0, 100, 0, 20))
    filterBtn.Position = UDim2.new(1, -110, 0, 10)

    local filterOptions = Instance.new("Frame")
    filterOptions.Size = UDim2.new(0, 100, 0, 60)
    filterOptions.Position = UDim2.new(1, -110, 0, 30)
    filterOptions.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    filterOptions.BackgroundTransparency = 0.1
    filterOptions.ZIndex = 10004
    filterOptions.Visible = false
    filterOptions.Parent = logFrame
    local uicFilter = Instance.new("UICorner")
    uicFilter.CornerRadius = UDim.new(0, 8)
    uicFilter.Parent = filterOptions
    local strokeFilter = Instance.new("UIStroke")
    strokeFilter.Color = Color3.fromRGB(0, 255, 128)
    strokeFilter.Thickness = 1
    strokeFilter.Transparency = 0.5
    strokeFilter.Parent = filterOptions

    local function createFilterOption(name, pos)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 20)
        btn.Position = pos
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Text = name
        btn.BackgroundTransparency = 0.1
        btn.TextSize = 12
        btn.ZIndex = 10005
        btn.Font = Enum.Font.Gotham
        btn.Parent = filterOptions
        btn.MouseButton1Click:Connect(function()
            logFilter = name
            filterBtn.Text = name
            filterOptions.Visible = false
            local filteredLogs = {}
            for _, log in ipairs(debugLog) do
                if logFilter == "Todos" or log.type == logFilter then
                    table.insert(filteredLogs, log.text)
                end
            end
            debugLogString = table.concat(filteredLogs, "\n")
            logText.Text = "Logs:\n" .. debugLogString
        end)
    end

    createFilterOption("Todos", UDim2.new(0, 0, 0, 0))
    createFilterOption("Erros", UDim2.new(0, 0, 0, 20))
    createFilterOption("Notificações", UDim2.new(0, 0, 0, 40))

    filterBtn.MouseButton1Click:Connect(function()
        filterOptions.Visible = not filterOptions.Visible
    end)

    local lastLogTime = 0
    local logCooldown = 0.5
    local function safeAddLog(message, logType)
        local currentTime = tick()
        if currentTime - lastLogTime >= logCooldown then
            addDebugLog(message, logType)
            lastLogTime = currentTime
        end
    end

    return logFrame
end

-- Definir a função initialize
local function initialize()
    -- Carregar serviços
    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local MarketplaceService = game:GetService("MarketplaceService")
    local Lighting = game:GetService("Lighting")
    addDebugLog("Serviços carregados com sucesso", "Notificações")

    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then
        addDebugLog("LocalPlayer não encontrado, esperando...", "Erros")
        LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
    end
    addDebugLog("LocalPlayer carregado - " .. (LocalPlayer and LocalPlayer.Name or "N/A"), "Notificações")

    -- Detectar o jogo atual
    local currentPlaceId = game.PlaceId
    addDebugLog("Jogo detectado - PlaceId: " .. tostring(currentPlaceId), "Notificações")

    -- Lista de jogos com anti-cheat (PlaceIds conhecidos)
    local antiCheatGames = {
        2788229376, -- Jailbreak
        286090429,  -- Arsenal
        292439477,  -- Phantom Forces
        -- Adicione mais PlaceIds conforme necessário
    }
    local hasAntiCheat = false
    for _, placeId in ipairs(antiCheatGames) do
        if currentPlaceId == placeId then
            hasAntiCheat = true
            break
        end
    end
    if hasAntiCheat then
        addDebugLog("Jogo com anti-cheat detectado, desativando funcionalidades arriscadas", "Notificações")
        showNotification("Jogo com anti-cheat detectado! Fly e NoClip desativados.")
    end

    -- Configurações salvas (temporárias, usando uma tabela global)
    getgenv().DevHubSettings = getgenv().DevHubSettings or {
        flySpeed = 50,
        flying = false,
        noclip = false,
        espEnabled = false,
        mapNoClip = false,
        dayNight = false
    }
    local settings = getgenv().DevHubSettings

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
        addDebugLog("ScreenGui criada no CoreGui", "Notificações")
    end)
    if not successCoreGui then
        addDebugLog("Falha ao usar CoreGui - " .. tostring(errCoreGui), "Erros")
        local playerGui = LocalPlayer:WaitForChild("PlayerGui", 5)
        if playerGui then
            ScreenGui.Parent = playerGui
            parentSet = true
            addDebugLog("Usando PlayerGui como fallback", "Notificações")
        else
            addDebugLog("PlayerGui não encontrado após espera", "Erros")
        end
    end
    
    if not parentSet then
        error("Não foi possível definir o parent da ScreenGui")
    end
    addDebugLog("ScreenGui criada com sucesso", "Notificações")

    -- Configurações iniciais
    local flySpeed = settings.flySpeed
    local flying = settings.flying
    local flyConnection
    local bodyVelocity
    local noclip = settings.noclip
    local verticalFly = 0
    local espEnabled = settings.espEnabled
    local mapNoClip = settings.mapNoClip
    local dayNight = settings.dayNight

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
    floatingButton = Instance.new("TextButton")
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
    addDebugLog("Botão flutuante criado com sucesso", "Notificações")

    floatingButton.MouseButton1Click:Connect(function()
        Main.Visible = not Main.Visible
        floatingButton.Visible = not Main.Visible
        addDebugLog("HUD " .. (Main.Visible and "aberto" or "fechado") .. " via botão flutuante", "Notificações")
    end)-- Criar frame principal (HUD)
    Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 500, 0, 350) -- Aumentado para caber mais abas
    Main.Position = UDim2.new(0.5, -250, 0.5, -175)
    Main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Main.BackgroundTransparency = 0.1
    Main.Visible = false
    Main.ZIndex = 10000
    Main.Parent = ScreenGui
    createUICorner(Main, 20)
    neonify(Main)
    addDebugLog("Frame principal criado com sucesso", "Notificações")

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
        local hoverColor = Color3.fromRGB(40, 40, 40)

        local function tweenColor(toColor)
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = toColor}):Play()
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
            addDebugLog("Erro: Personagem ou HumanoidRootPart não encontrado", "Erros")
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

    -- Criar frame para as abas (à esquerda)
    local tabButtonsFrame = Instance.new("Frame")
    tabButtonsFrame.Size = UDim2.new(0, 120, 1, -50) -- 120 pixels de largura, altura ajustada para caber abaixo da dragBar
    tabButtonsFrame.Position = UDim2.new(0, 10, 0, 50)
    tabButtonsFrame.BackgroundTransparency = 1
    tabButtonsFrame.Parent = Main

    -- Criar frame para o conteúdo das abas (à direita)
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -140, 1, -50) -- Ocupa o espaço restante à direita
    contentFrame.Position = UDim2.new(0, 130, 0, 50)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = Main

    -- Criar botões de controle (Reset, Minimizar, Fechar) no topo direito
    local resetBtn = createButton("Reset", dragBar, UDim2.new(1, -140, 0, 5), UDim2.new(0, 60, 0, 30))
    local closeBtn = createButton("X", dragBar, UDim2.new(1, -35, 0, 5), UDim2.new(0, 30, 0, 30))
    closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    local minimizeBtn = createButton("−", dragBar, UDim2.new(1, -70, 0, 5), UDim2.new(0, 30, 0, 30))

    -- Criar botões das abas (listados verticalmente à esquerda)
    local adminTabButton = createButton("Admin", tabButtonsFrame, UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 30), true)
    local playerTabButton = createButton("Player", tabButtonsFrame, UDim2.new(0, 0, 0, 35), UDim2.new(1, 0, 0, 30), true)
    local gameTabButton = createButton("Game", tabButtonsFrame, UDim2.new(0, 0, 0, 70), UDim2.new(1, 0, 0, 30), true)
    local gamepassTabButton = createButton("Gamepass", tabButtonsFrame, UDim2.new(0, 0, 0, 105), UDim2.new(1, 0, 0, 30), true)
    local logsTabButton = createButton("Logs", tabButtonsFrame, UDim2.new(0, 0, 0, 140), UDim2.new(1, 0, 0, 30), true)

    -- Linha divisória vertical entre abas e conteúdo
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(0, 1, 1, -60)
    divider.Position = UDim2.new(0, 125, 0, 50)
    divider.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
    divider.BackgroundTransparency = 0.5
    divider.BorderSizePixel = 0
    divider.Parent = Main

    -- Criar páginas das abas (agora dentro do contentFrame)
    local adminPage = Instance.new("Frame")
    adminPage.Size = UDim2.new(1, 0, 1, 0)
    adminPage.Position = UDim2.new(0, 0, 0, 0)
    adminPage.BackgroundTransparency = 1
    adminPage.Visible = true
    adminPage.Parent = contentFrame

    local playerPage = Instance.new("Frame")
    playerPage.Size = UDim2.new(1, 0, 1, 0)
    playerPage.Position = UDim2.new(0, 0, 0, 0)
    playerPage.BackgroundTransparency = 1
    playerPage.Visible = false
    playerPage.Parent = contentFrame

    local gamePage = Instance.new("Frame")
    gamePage.Size = UDim2.new(1, 0, 1, 0)
    gamePage.Position = UDim2.new(0, 0, 0, 0)
    gamePage.BackgroundTransparency = 1
    gamePage.Visible = false
    gamePage.Parent = contentFrame

    local gamepassPage = Instance.new("Frame")
    gamepassPage.Size = UDim2.new(1, 0, 1, 0)
    gamepassPage.Position = UDim2.new(0, 0, 0, 0)
    gamepassPage.BackgroundTransparency = 1
    gamepassPage.Visible = false
    gamepassPage.Parent = contentFrame

    local logsPage = Instance.new("Frame")
    logsPage.Size = UDim2.new(1, 0, 1, 0)
    logsPage.Position = UDim2.new(0, 0, 0, 0)
    logsPage.BackgroundTransparency = 1
    logsPage.Visible = false
    logsPage.Parent = contentFrame

    -- Função pra alternar entre abas
    local function switchTab(tab)
        adminPage.Visible = (tab == "Admin")
        playerPage.Visible = (tab == "Player")
        gamePage.Visible = (tab == "Game")
        gamepassPage.Visible = (tab == "Gamepass")
        logsPage.Visible = (tab == "Logs")
        adminTabButton.BackgroundTransparency = (tab == "Admin") and 0.1 or 0.3
        playerTabButton.BackgroundTransparency = (tab == "Player") and 0.1 or 0.3
        gameTabButton.BackgroundTransparency = (tab == "Game") and 0.1 or 0.3
        gamepassTabButton.BackgroundTransparency = (tab == "Gamepass") and 0.1 or 0.3
        logsTabButton.BackgroundTransparency = (tab == "Logs") and 0.1 or 0.3
    end

    adminTabButton.MouseButton1Click:Connect(function() switchTab("Admin") end)
    playerTabButton.MouseButton1Click:Connect(function() switchTab("Player") end)
    gameTabButton.MouseButton1Click:Connect(function() switchTab("Game") end)
    gamepassTabButton.MouseButton1Click:Connect(function() switchTab("Gamepass") end)
    logsTabButton.MouseButton1Click:Connect(function() switchTab("Logs") end)

    showNotification("Script carregado com sucesso!")
    addDebugLog("Botão flutuante visível, inicialização concluída", "Notificações")
end

-- Executar a inicialização
local success, err = pcall(initialize)
if not success then
    warn("Erro ao inicializar o script: " .. tostring(err))
    addDebugLog("Erro ao inicializar o script: " .. tostring(err), "Erros")
end

-- Keybinds (movido para o final do script)
local keybindsEnabled = true
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if not gameProcessedEvent and keybindsEnabled then
        if input.KeyCode == Enum.KeyCode.H then
            Main.Visible = not Main.Visible
            floatingButton.Visible = not Main.Visible
            addDebugLog("HUD " .. (Main.Visible and "aberto" or "fechado") .. " via keybind H", "Notificações")
        elseif input.KeyCode == Enum.KeyCode.F and not hasAntiCheat then
            flyToggle.state = not flyToggle.state
            flyToggle.onToggle(flyToggle.state)
            addDebugLog("Fly " .. (flyToggle.state and "ativado" or "desativado") .. " via keybind F", "Notificações")
        elseif input.KeyCode == Enum.KeyCode.N and not hasAntiCheat then
            noclipToggle.state = not noclipToggle.state
            noclipToggle.onToggle(noclipToggle.state)
            addDebugLog("NoClip " .. (noclipToggle.state and "ativado" or "desativado") .. " via keybind N", "Notificações")
        end
    end
end)

addDebugLog("Keybinds configurados (H: HUD, F: Fly, N: NoClip)", "Notificações")
