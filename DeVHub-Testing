-- DevHub: Script Ajustado (HUD Mais Profissional)

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
local logFilter = "Todos" -- Filtro padrão para logs

-- Função pra adicionar logs com cooldown
local function addDebugLog(message, logType)
    logType = logType or "Notificações" -- Tipo padrão é "Notificações"
    
    local currentTime = tick()
    
    -- Verificar se a mensagem já foi logada recentemente (cooldown de 1 segundo)
    if lastLogTimes[message] and (currentTime - lastLogTimes[message] < 1) then
        return -- Não logar se estiver dentro do cooldown
    end
    
    lastLogTimes[message] = currentTime
    
    -- Adicionar o log à tabela com o tipo
    table.insert(debugLog, {text = message, type = logType})
    
    -- Limitar o número de linhas
    if #debugLog > MAX_LOG_LINES then
        table.remove(debugLog, 1) -- Remove a linha mais antiga
    end
    
    -- Atualizar a string de logs com base no filtro
    local filteredLogs = {}
    for _, log in ipairs(debugLog) do
        if logFilter == "Todos" or log.type == logFilter then
            table.insert(filteredLogs, log.text)
        end
    end
    debugLogString = table.concat(filteredLogs, "\n")
    
    -- Atualizar a janela de logs, se existir
    if logText then
        logText.Text = "Logs:\n" .. debugLogString
    end
    
    -- Exibir no console para depuração
    print("[DevHub Log]: " .. message)
end

addDebugLog("Iniciando script ajustado...", "Notificações")

-- Função pra criar a janela de logs
local function createLogWindow()
    addDebugLog("Tentando criar janela de logs...", "Notificações")
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
        addDebugLog("Falha ao usar CoreGui - " .. tostring(errCoreGui), "Erros")
        local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            parent = playerGui
            logGui.Parent = playerGui
            addDebugLog("Usando PlayerGui como fallback para logs", "Notificações")
        else
            addDebugLog("PlayerGui não encontrado", "Erros")
            return
        end
    end
    addDebugLog("ScreenGui de logs criada com parent: " .. tostring(parent), "Notificações")

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
    logText.Size = UDim2.new(1, -20, 1, -90)
    logText.Position = UDim2.new(0, 10, 0, 40)
    logText.BackgroundTransparency = 1
    logText.TextColor3 = Color3.fromRGB(255, 255, 255)
    logText.Text = "Logs:\n" .. debugLogString
    logText.TextSize = 14
    logText.TextWrapped = true
    logText.TextYAlignment = Enum.TextYAlignment.Top
    logText.ZIndex = 10001
    logText.Font = Enum.Font.Gotham
    logText.Parent = logFrame

    -- Dropdown para filtro de logs
    local filterFrame = Instance.new("Frame")
    filterFrame.Size = UDim2.new(0, 100, 0, 20)
    filterFrame.Position = UDim2.new(0, 10, 0, 10)
    filterFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    filterFrame.BackgroundTransparency = 0.1
    filterFrame.ZIndex = 10002
    filterFrame.Parent = logFrame

    local function createUICorner(obj, rad)
        local uic = Instance.new("UICorner")
        uic.CornerRadius = UDim.new(0, rad)
        uic.Parent = obj
    end
    createUICorner(filterFrame, 8)

    local strokeFilter = Instance.new("UIStroke")
    strokeFilter.Color = Color3.fromRGB(0, 255, 128)
    strokeFilter.Thickness = 1
    strokeFilter.Transparency = 0.5
    strokeFilter.Parent = filterFrame

    local filterBtn = Instance.new("TextButton")
    filterBtn.Size = UDim2.new(1, 0, 1, 0)
    filterBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    filterBtn.Text = logFilter
    filterBtn.BackgroundTransparency = 1
    filterBtn.TextSize = 12
    filterBtn.ZIndex = 10003
    filterBtn.Font = Enum.Font.Gotham
    filterBtn.Parent = filterFrame

    local filterOptions = Instance.new("Frame")
    filterOptions.Size = UDim2.new(0, 100, 0, 60)
    filterOptions.Position = UDim2.new(0, 0, 1, 0)
    filterOptions.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    filterOptions.BackgroundTransparency = 0.1
    filterOptions.ZIndex = 10004
    filterOptions.Visible = false
    filterOptions.Parent = filterFrame
    createUICorner(filterOptions, 8)

    local strokeOptions = Instance.new("UIStroke")
    strokeOptions.Color = Color3.fromRGB(0, 255, 128)
    strokeOptions.Thickness = 1
    strokeOptions.Transparency = 0.5
    strokeOptions.Parent = filterOptions

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
        btn.Parent = filterOffset
        btn.MouseButton1Click:Connect(function()
            logFilter = name
            filterBtn.Text = name
            filterOptions.Visible = false
            -- Atualizar logs
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
    createFilterOption("Notificações", UDim2.new(0, 0, 0, 40))filterBtn.MouseButton1Click:Connect(function()
        filterOptions.Visible = not filterOptions.Visible
    end)

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
    copyBtn.TextSize = 14
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
            setclipboard(debugLogString)
            addDebugLog("Log copiado para o clipboard", "Notificações")
        else
            addDebugLog("Executor não suporta setclipboard", "Erros")
        end
    end)

    closeBtn.MouseButton1Click:Connect(function()
        logGui:Destroy()
        logGui = nil
        logText = nil
        addDebugLog("Janela de logs fechada", "Notificações")
    end)

    addDebugLog("Janela de logs criada com sucesso", "Notificações")
end

-- Sistema de notificações
local function showNotification(message)
    local ScreenGui = game:GetService("CoreGui"):FindFirstChild("DevHubUI") or game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
    if not ScreenGui then 
        addDebugLog("Erro: ScreenGui não encontrada para notificação", "Erros")
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
    stroke.Color = Color3.fromRGB(0, 255, 128)
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = notifFrame

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
    addDebugLog("Botão flutuante criado com sucesso", "Notificações")

    -- Criar frame principal (HUD)
    local Main = Instance.new("Frame")
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

    local downBtn = createButton("↓", flyControlFrame, UDim2.new(0, 0, 0.5, 5), UDim2.new(1, 0, 0.5, -5))downBtn.MouseButton1Down:Connect(function() verticalFly = -1 end)downBtn.MouseButton1Up:Connect(function() verticalFly = 0 end)

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

    -- Função para resetar configurações
    resetBtn.MouseButton1Click:Connect(function()
        flySpeed = 50
        settings.flySpeed = flySpeed
        flying = false
        settings.flying = flying
        noclip = false
        settings.noclip = noclip
        espEnabled = false
        settings.espEnabled = espEnabled
        mapNoClip = false
        settings.mapNoClip = mapNoClip
        dayNight = false
        settings.dayNight = dayNight

        -- Atualizar UI
        speedKnobContainer.Position = UDim2.new((flySpeed - 20) / (200 - 20), -6, 0.5, -6)
        speedLabel.Text = "Velocidade: " .. flySpeed
        flyToggle.state = false
        flyToggle.onToggle(false)
        noclipToggle.state = false
        noclipToggle.onToggle(false)
        espToggle.state = false
        espToggle.onToggle(false)
        mapNoClipToggle.state = false
        mapNoClipToggle.onToggle(false)
        dayNightToggle.state = false
        dayNightToggle.onToggle(false)

        showNotification("Configurações resetadas!")
        addDebugLog("Configurações resetadas", "Notificações")
    end)

    -- Conteúdo da aba Admin
    local flyToggle = { state = flying }
    local flyFrame = createToggle("Fly", adminPage, UDim2.new(0, 10, 0, 10), flyToggle)

    -- Desativar Fly se o jogo tiver anti-cheat
    if hasAntiCheat then
        flyFrame.Visible = false
    end

    -- Slider de velocidade (à direita do Fly)
    local speedFrame = Instance.new("Frame")
    speedFrame.Size = UDim2.new(0, 150, 0, 24)
    speedFrame.Position = UDim2.new(0, 170, 0, 10)
    speedFrame.BackgroundTransparency = 1
    speedFrame.ZIndex = 10000
    speedFrame.Parent = adminPage

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

    -- Desativar slider de velocidade se o jogo tiver anti-cheat
    if hasAntiCheat then
        speedFrame.Visible = false
    end

    local draggingSpeed = false

    local function updateSlider(input)
        local posX = input.Position.X
        local trackPos = speedTrack.AbsolutePosition.X
        local trackWidth = speedTrack.AbsoluteSize.X
        local newPos = math.clamp((posX - trackPos) / trackWidth, 0, 1)
        flySpeed = math.floor(20 + (newPos * (200 - 20)))
        speedKnobContainer.Position = UDim2.new(newPos, -6, 0.5, -6)
        speedLabel.Text = "Velocidade: " .. flySpeed
        settings.flySpeed = flySpeed
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
            showNotification("Velocidade ajustada para " .. flySpeed)
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

    addDebugLog("Slider de velocidade criado", "Notificações")

    -- NoClip (abaixo do Fly)
    local noclipToggle = { state = noclip }
    local noclipFrame = createToggle("NoClip", adminPage, UDim2.new(0, 10, 0, 40), noclipToggle)

    -- Desativar NoClip se o jogo tiver anti-cheat
    if hasAntiCheat then
        noclipFrame.Visible = false
    end

    -- Teleporte para jogador
    local selectedPlayer = nil
    local playerListFrame

    local selectPlayerBtn = createButton("Selecionar Jogador", adminPage, UDim2.new(0, 10, 0, 70))
    local teleportBtn = createButton("Teleportar", adminPage, UDim2.new(0, 10, 0, 100))
    local refreshBtn = createButton("Refresh", adminPage, UDim2.new(0, 135, 0, 100), UDim2.new(0, 60, 0, 30))

    local function updatePlayerList()
        if playerListFrame then
            playerListFrame:Destroy()
        end
        playerListFrame = Instance.new("Frame")
        playerListFrame.Size = UDim2.new(0, 150, 0, 150)
        playerListFrame.Position = UDim2.new(0, 10, 0, 105)
        playerListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        playerListFrame.BackgroundTransparency = 0.1
        playerListFrame.ZIndex = 10005
        playerListFrame.Visible = false
        playerListFrame.Parent = adminPage
        createUICorner(playerListFrame, 8)
        neonify(playerListFrame)

        local scrollingFrame = Instance.new("ScrollingFrame")
        scrollingFrame.Size = UDim2.new(1, -10, 1, -10)
        scrollingFrame.Position = UDim2.new(0, 5, 0, 5)
        scrollingFrame.BackgroundTransparency = 1
        scrollingFrame.ScrollBarThickness = 4
        scrollingFrame.ZIndex = 10006
        scrollingFrame.Parent = playerListFrame

        local uiListLayout = Instance.new("UIListLayout")
        uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        uiListLayout.Parent = scrollingFrame

        local players = Players:GetPlayers()
        for i, player in ipairs(players) do
            if player ~= LocalPlayer then
                local playerBtn = Instance.new("TextButton")
                playerBtn.Size = UDim2.new(1, 0, 0, 20)
                playerBtn.Position = UDim2.new(0, 0, 0, (i - 1) * 22)
                playerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                playerBtn.Text = player.Name
                playerBtn.BackgroundTransparency = 0.1
                playerBtn.TextSize = 12
                playerBtn.ZIndex = 10007
                playerBtn.Font = Enum.Font.Gotham
                playerBtn.Parent = scrollingFrame
                playerBtn.MouseButton1Click:Connect(function()
                    selectedPlayer = player
                    selectPlayerBtn.Text = "Jogador: " .. player.Name
                    playerListFrame.Visible = false
                end)
            end
        end

        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #players * 22)
    end

    selectPlayerBtn.MouseButton1Click:Connect(function()
        updatePlayerList()
        playerListFrame.Visible = not playerListFrame.Visible
    end)

    teleportBtn.MouseButton1Click:Connect(function()
        if selectedPlayer then
            local character = LocalPlayer.Character
            local targetCharacter = selectedPlayer.Character
            if character and targetCharacter then
                local root = character:FindFirstChild("HumanoidRootPart")
                local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
                if root and targetRoot then
                    root.CFrame = targetRoot.CFrame + Vector3.new(3, 0, 0)
                    showNotification("Teleportado para " .. selectedPlayer.Name)
                    addDebugLog("Teleportado para " .. selectedPlayer.Name, "Notificações")
                else
                    showNotification("Erro: Não foi possível teleportar")
                    addDebugLog("Erro: HumanoidRootPart não encontrado", "Erros")
                end
            else
                showNotification("Erro: Personagem não encontrado")
                addDebugLog("Erro: Personagem não encontrado", "Erros")
            end
        else
            showNotification("Selecione um jogador primeiro!")
            addDebugLog("Tentativa de teleporte sem jogador selecionado", "Erros")
        end
    end)

    refreshBtn.MouseButton1Click:Connect(function()
        updatePlayerList()
        showNotification("Lista de jogadores atualizada")
        addDebugLog("Lista de jogadores atualizada", "Notificações")
    end)

    -- Configurar o toggle de fly
    flyToggle.onToggle = function(state)
        if hasAntiCheat then
            showNotification("Fly desativado neste jogo (anti-cheat detectado)")
            flyToggle.state = false
            return
        end
        flying = state
        settings.flying = flying
        local character = LocalPlayer.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then
            addDebugLog("Erro: Não foi possível ativar fly - personagem não carregado", "Erros")
            flying = false
            settings.flying = flying
            flyToggle.state = false
            createToggle("Fly", adminPage, UDim2.new(0, 10, 0, 10), flyToggle)
            showNotification("Erro: Personagem não carregado")
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
            showNotification("Fly ativado!")
            addDebugLog("Fly ativado", "Notificações")
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
            showNotification("Fly desativado!")
            addDebugLog("Fly desativado", "Notificações")
        end
    end

    -- Configurar o toggle de noclip
    noclipToggle.onToggle = function(state)
        if hasAntiCheat then
            showNotification("NoClip desativado neste jogo (anti-cheat detectado)")
            noclipToggle.state = false
            return
        end
        noclip = state
        settings.noclip = noclip
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
            showNotification("NoClip ativado!")
            addDebugLog("NoClip ativado", "Notificações")
        else
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
            showNotification("NoClip desativado!")
            addDebugLog("NoClip desativado", "Notificações")
        end
    end

    -- Conteúdo da aba Player (ESP)
    local espToggle = { state = espEnabled }
    local espFrame = createToggle("ESP", playerPage, UDim2.new(0, 10, 0, 10), espToggle)

    local espLabels = {}
    local function updateESP()
        for _, label in pairs(espLabels) do
            label:Destroy()
        end
        espLabels = {}

        if espEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local head = player.Character:FindFirstChild("Head")
                    if head then
                        local billboard = Instance.new("BillboardGui")
                        billboard.Name = "ESP_" .. player.Name
                        billboard.Size = UDim2.new(0, 100, 0, 30)
                        billboard.StudsOffset = Vector3.new(0, 3, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Parent = head

                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Size = UDim2.new(1, 0, 1, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
                        nameLabel.Text = player.Name
                        nameLabel.TextSize = 14
                        nameLabel.Font = Enum.Font.Gotham
                        nameLabel.Parent = billboard

                        table.insert(espLabels, billboard)
                    end
                end
            end
        end
    end

    espToggle.onToggle = function(state)
        espEnabled = state
        settings.espEnabled = espEnabled
        updateESP()
        showNotification("ESP " .. (state and "ativado" or "desativado") .. "!")
        addDebugLog("ESP " .. (state and "ativado" or "desativado"), "Notificações")
    end

    Players.PlayerAdded:Connect(updateESP)
    Players.PlayerRemoving:Connect(updateESP)

    -- Conteúdo da aba Game
    local removeDoorsBtn = createButton("Remover Portas", gamePage, UDim2.new(0, 10, 0, 10))
    removeDoorsBtn.MouseButton1Click:Connect(function()
        for _, door in pairs(workspace:GetDescendants()) do
            if door:IsA("BasePart") and door.Name:lower():find("door") then
                door:Destroy()
            end
        end
        showNotification("Portas removidas!")
        addDebugLog("Portas removidas", "Notificações")
    end)

    local dayNightToggle = { state = dayNight }
    local dayNightFrame = createToggle("Dia/Noite", gamePage, UDim2.new(0, 10, 0, 40), dayNightToggle)
    dayNightToggle.onToggle = function(state)
        dayNight = state
        settings.dayNight = dayNight
        Lighting.ClockTime = state and 0 or 12
        showNotification("Tempo ajustado para " .. (state and "Noite" or "Dia"))
        addDebugLog("Tempo ajustado para " .. (state and "Noite" or "Dia"), "Notificações")
    end

    local mapNoClipToggle = { state = mapNoClip }
    local mapNoClipFrame = createToggle("Map NoClip", gamePage, UDim2.new(0, 10, 0, 70), mapNoClipToggle)
    mapNoClipToggle.onToggle = function(state)
        mapNoClip = state
        settings.mapNoClip = mapNoClip
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and not part.Parent:IsA("Model") then
                part.CanCollide = not state
            end
        end
        showNotification("Map NoClip " .. (state and "ativado" or "desativado") .. "!")
        addDebugLog("Map NoClip " .. (state and "ativado" or "desativado"), "Notificações")
    end

    -- Conteúdo da aba Gamepass
    local selectedGamepass = nil -- Para armazenar o gamepass selecionado
    local gamepassListFrame = nil -- Para a lista de gamepasses
    local autoBuyConnection = nil -- Para o loop de auto-compra
    local gamepasses = {} -- Lista de gamepasses detectados

    -- Função para carregar gamepasses
    local function loadGamepasses()
        gamepasses = {} -- Limpar a lista de gamepasses
        local success, gameInfo = pcall(function()
            return MarketplaceService:GetProductInfo(currentPlaceId)
        end)
        if not success then
            addDebugLog("Erro ao obter informações do jogo: " .. tostring(gameInfo), "Erros")
            showNotification("Erro ao carregar gamepasses!")
            return
        end
        addDebugLog("Carregando gamepasses para o jogo: " .. gameInfo.Name, "Notificações")

        -- Tentar obter os gamepasses do jogo
        local successProducts, products = pcall(function()
            return game:GetService("MarketplaceService"):GetDeveloperProductsAsync()
        end)
        if successProducts then
            for _, product in pairs(products:GetCurrentPage()) do
                -- Filtrar apenas gamepasses (ignorar outros produtos)
                local productInfo = MarketplaceService:GetProductInfo(product.ProductId)
                if productInfo.ProductType == "Game Pass" then
                    table.insert(gamepasses, {Name = productInfo.Name, ProductId = productInfo.ProductId})
                end
            end
        else
            addDebugLog("Erro ao carregar gamepasses: " .. tostring(products), "Erros")
        end

        -- Atualizar a lista de gamepasses na UI
        if gamepassListFrame then
            gamepassListFrame:Destroy()
        end
        gamepassListFrame = Instance.new("Frame")
        gamepassListFrame.Size = UDim2.new(1, -20, 0, 150)
        gamepassListFrame.Position = UDim2.new(0, 10, 0, 10)
        gamepassListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        gamepassListFrame.BackgroundTransparency = 0.1
        gamepassListFrame.ZIndex = 10005
        gamepassListFrame.Parent = gamepassPage
        createUICorner(gamepassListFrame, 8)
        neonify(gamepassListFrame)

        local scrollingFrame = Instance.new("ScrollingFrame")
        scrollingFrame.Size = UDim2.new(1, -10, 1, -10)
        scrollingFrame.Position = UDim2.new(0, 5, 0, 5)
        scrollingFrame.BackgroundTransparency = 1
        scrollingFrame.ScrollBarThickness = 4
        scrollingFrame.ZIndex = 10006
        scrollingFrame.Parent = gamepassListFrame

        local uiListLayout = Instance.new("UIListLayout")
        uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        uiListLayout.Parent = scrollingFrame

        for i, gamepass in ipairs(gamepasses) do
            local gamepassBtn = Instance.new("TextButton")
            gamepassBtn.Size = UDim2.new(1, 0, 0, 20)
            gamepassBtn.Position = UDim2.new(0, 0, 0, (i - 1) * 22)
            gamepassBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            gamepassBtn.Text = gamepass.Name
            gamepassBtn.BackgroundTransparency = 0.1
            gamepassBtn.TextSize = 12
            gamepassBtn.ZIndex = 10007
            gamepassBtn.Font = Enum.Font.Gotham
            gamepassBtn.Parent = scrollingFrame
            gamepassBtn.MouseButton1Click:Connect(function()
                selectedGamepass = gamepass
                selectGamepassBtn.Text = "Gamepass: " .. gamepass.Name
                gamepassListFrame.Visible = false
            end)
        end

        scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #gamepasses * 22)
    end

    -- Botão para selecionar gamepass
    local selectGamepassBtn = createButton("Selecionar Gamepass", gamepassPage, UDim2.new(0, 10, 0, 170))
    selectGamepassBtn.MouseButton1Click:Connect(function()
        if not gamepassListFrame then
            loadGamepasses()
        end
        gamepassListFrame.Visible = not gamepassListFrame.Visible
    end)

    -- Botão para comprar o gamepass selecionado
    local buyGamepassBtn = createButton("Comprar Gamepass", gamepassPage, UDim2.new(0, 10, 0, 200))
    buyGamepassBtn.MouseButton1Click:Connect(function()
        if selectedGamepass then
            local ownsGamepass = false
            local success, err = pcall(function()
                ownsGamepass = MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, selectedGamepass.ProductId)
            end)
            if success and not ownsGamepass then
                MarketplaceService:PromptGamePassPurchase(LocalPlayer, selectedGamepass.ProductId)
                showNotification("Solicitando compra de " .. selectedGamepass.Name)
                addDebugLog("Solicitando compra de gamepass: " .. selectedGamepass.Name, "Notificações")
            elseif ownsGamepass then
                showNotification("Você já possui este gamepass!")
                addDebugLog("Gamepass já possuído: " .. selectedGamepass.Name, "Notificações")
            else
                showNotification("Erro ao verificar posse do gamepass")
                addDebugLog("Erro ao verificar posse do gamepass: " .. tostring(err), "Erros")
            end
        else
            showNotification("Selecione um gamepass primeiro!")
            addDebugLog("Tentativa de compra sem gamepass selecionado", "Erros")
        end
    end)

    -- Botão para comprar todos os gamepasses
    local buyAllGamepassesBtn = createButton("Comprar Todos os Gamepasses", gamepassPage, UDim2.new(0, 10, 0, 230))
    buyAllGamepassesBtn.MouseButton1Click:Connect(function()
        if #gamepasses == 0 then
            showNotification("Nenhum gamepass detectado!")
            addDebugLog("Tentativa de comprar todos os gamepasses, mas nenhum foi detectado", "Erros")
            return
        end
        for _, gamepass in ipairs(gamepasses) do
            local ownsGamepass = false
            local success, err = pcall(function()
                ownsGamepass = MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, gamepass.ProductId)
            end)
            if success and not ownsGamepass then
                MarketplaceService:PromptGamePassPurchase(LocalPlayer, gamepass.ProductId)
                task.wait(0.5) -- Pequeno delay para evitar sobrecarga
                addDebugLog("Solicitando compra de gamepass: " .. gamepass.Name, "Notificações")
            elseif ownsGamepass then
                addDebugLog("Gamepass já possuído: " .. gamepass.Name, "Notificações")
            else
                addDebugLog("Erro ao verificar posse do gamepass: " .. tostring(err), "Erros")
            end
        end
        showNotification("Solicitando compra de todos os gamepasses!")
        addDebugLog("Solicitando compra de todos os gamepasses", "Notificações")
    end)

    -- Toggle para auto-comprar o gamepass selecionado
    local autoBuyToggle = { state = false }
    local autoBuyFrame = createToggle("Auto Comprar Selecionado", gamepassPage, UDim2.new(0, 10, 0, 260), autoBuyToggle)
    autoBuyToggle.onToggle = function(state)
        autoBuyToggle.state = state
        if state then
            if not selectedGamepass then
                showNotification("Selecione um gamepass primeiro!")
                addDebugLog("Tentativa de auto-compra sem gamepass selecionado", "Erros")
                autoBuyToggle.state = false
                autoBuyFrame:Destroy()
                autoBuyFrame = createToggle("Auto Comprar Selecionado", gamepassPage, UDim2.new(0, 10, 0, 260), autoBuyToggle)
                return
            end
            autoBuyConnection = RunService.Heartbeat:Connect(function()
                if not autoBuyToggle.state then
                    autoBuyConnection:Disconnect()
                    return
                end
                local ownsGamepass = false
                local success, err = pcall(function()
                    ownsGamepass = MarketplaceService:UserOwnsGamePassAsync(LocalPlayer.UserId, selectedGamepass.ProductId)
                end)
                if success and not ownsGamepass then
                    MarketplaceService:PromptGamePassPurchase(LocalPlayer, selectedGamepass.ProductId)
                    addDebugLog("Auto-compra de gamepass: " .. selectedGamepass.Name, "Notificações")
                elseif ownsGamepass then
                    showNotification("Você já possui este gamepass! Auto-compra desativada.")
                    addDebugLog("Gamepass já possuído, auto-compra desativada: " .. selectedGamepass.Name, "Notificações")
                    autoBuyToggle.state = false
                    autoBuyFrame:Destroy()
                    autoBuyFrame = createToggle("Auto Comprar Selecionado", gamepassPage, UDim2.new(0, 10, 0, 260), autoBuyToggle)
                else
                    addDebugLog("Erro na auto-compra: " .. tostring(err), "Erros")
                end
                task.wait(1) -- Delay para evitar sobrecarga
            end)
            showNotification("Auto-compra ativada para " .. selectedGamepass.Name)
            addDebugLog("Auto-compra ativada para " .. selectedGamepass.Name, "Notificações")
        else
            if autoBuyConnection then
                autoBuyConnection:Disconnect()
                autoBuyConnection = nil
            end
            showNotification("Auto-compra desativada!")
            addDebugLog("Auto-compra desativada", "Notificações")
        end
    end

    -- Carregar gamepasses ao abrir a aba
    loadGamepasses()

    -- Configurar botão de fechar
    closeBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        showNotification("Script encerrado!")
        addDebugLog("Script encerrado", "Notificações")
    end)

    -- Configurar botão de minimizar
    minimizeBtn.MouseButton1Click:Connect(function()
        Main.Visible = false
        floatingButton.Visible = true
    end)

    -- Configurar botão flutuante
    floatingButton.MouseButton1Click:Connect(function()
        Main.Visible = true
        floatingButton.Visible = false
    end)

    -- Keybinds
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.H then
            if Main.Visible then
                Main.Visible = false
                floatingButton.Visible = true
            else
                Main.Visible = true
                floatingButton.Visible = false
            end
        elseif input.KeyCode == Enum.KeyCode.F and not hasAntiCheat then
            flyToggle.state = not flyToggle.state
            flyToggle.onToggle(flyToggle.state)
        elseif input.KeyCode == Enum.KeyCode.N and not hasAntiCheat then
            noclipToggle.state = not noclipToggle.state
            noclipToggle.onToggle(noclipToggle.state)
        end
    end)

    showNotification("Script carregado com sucesso!")
    addDebugLog("Botão flutuante visível, inicialização concluída", "Notificações")
end

-- Executar a inicialização
initialize()
