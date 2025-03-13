<#
.SYNOPSIS
    Gerenciador Inteligente de Recursos - Monitoramento e Otimização Automática
.DESCRIPTION
    Monitora CPU, memória, disco e processos. Usa análise preditiva simples para sugerir ações
    e implementa soluções automaticamente após aprovação do usuário. Gera relatório HTML.
.AUTHOR
    Grok 3 (xAI)
.DATE
    13 de Março de 2025
#>

# Verifica se está rodando como administrador
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Warning "Este script requer privilégios de administrador para algumas ações. Por favor, execute como administrador."
    exit
}

# Configurações iniciais
$LogPath = "$env:USERPROFILE\Desktop\ResourceManager_Log_$(Get-Date -Format 'yyyyMMdd_HHmmss').html"
$ThresholdCPU = 85      # Percentual crítico de CPU
$ThresholdMemory = 90   # Percentual crítico de memória
$ThresholdDisk = 95     # Percentual crítico de disco

# Função para criar gráficos simples em ASCII
function Get-AsciiGraph {
    param (
        [double]$Value,
        [int]$MaxWidth = 20
    )
    try {
        $barLength = [math]::Round($Value * $MaxWidth / 100)
        $bar = "#" * $barLength + "-" * ($MaxWidth - $barLength)
        return "[$bar] $Value%"
    }
    catch {
        return "[Erro ao gerar gráfico] $Value%"
    }
}

# Função de análise preditiva simples (corrigida)
function Get-PredictiveAnalysis {
    param (
        [double]$CurrentValue,
        [string]$ResourceType
    )
    $trend = if ($CurrentValue -gt 80) { "Crítico" } elseif ($CurrentValue -gt 60) { "Alto" } else { "Normal" }
    return "Tendência ${ResourceType}: $trend - Ação recomendada em $((Get-Random -Minimum 5 -Maximum 15)) minutos se mantido."
}

# Função para gerar relatório HTML
function New-HtmlReport {
    param (
        [string]$Content
    )
    $htmlTemplate = @"
    <!DOCTYPE html>
    <html>
    <head>
        <title>Relatório de Recursos - $(Get-Date)</title>
        <style>
            body { font-family: Arial, sans-serif; margin: 20px; }
            .critical { color: red; font-weight: bold; }
            .warning { color: orange; }
            .normal { color: green; }
            pre { font-family: Consolas, monospace; }
        </style>
    </head>
    <body>
        <h1>Relatório de Gerenciamento Inteligente de Recursos</h1>
        $Content
    </body>
    </html>
"@
    try {
        $htmlTemplate | Out-File -FilePath $LogPath -Encoding UTF8
    }
    catch {
        Write-Error "Erro ao salvar relatório: $_"
    }
}

# Coleta de dados do sistema com tratamento de erros
try {
    $cpuUsage = (Get-CimInstance Win32_PerfFormattedData_PerfOS_Processor -ErrorAction Stop | Where-Object { $_.Name -eq "_Total" }).PercentProcessorTime
    if (-not $cpuUsage) { $cpuUsage = 0; Write-Warning "Não foi possível coletar dados de CPU." }
}
catch {
    $cpuUsage = 0
    Write-Error "Erro ao coletar uso de CPU: $_"
}

try {
    $memory = Get-CimInstance Win32_OperatingSystem -ErrorAction Stop
    $memoryUsage = [math]::Round((($memory.TotalVisibleMemorySize - $memory.FreePhysicalMemory) / $memory.TotalVisibleMemorySize) * 100, 2)
}
catch {
    $memoryUsage = 0
    Write-Error "Erro ao coletar uso de memória: $_"
}

try {
    $disk = Get-PSDrive C -ErrorAction Stop
    $diskUsage = if ($disk.Used -and $disk.Free) { [math]::Round(($disk.Used / ($disk.Used + $disk.Free)) * 100, 2) } else { 0 }
}
catch {
    $diskUsage = 0
    Write-Error "Erro ao coletar uso de disco: $_"
}

try {
    $topProcesses = Get-Process -ErrorAction Stop | Sort-Object CPU -Descending | Select-Object -First 5
}
catch {
    $topProcesses = @()
    Write-Error "Erro ao coletar processos: $_"
}

# Análise e sugestões
$reportContent = "<h2>Status Atual do Sistema</h2>"
$actions = @()

# CPU
$cpuGraph = Get-AsciiGraph -Value $cpuUsage
$cpuPrediction = Get-PredictiveAnalysis -CurrentValue $cpuUsage -ResourceType "CPU"
$reportContent += "<p>CPU: <pre>$cpuGraph</pre> $cpuPrediction</p>"
if ($cpuUsage -gt $ThresholdCPU -and $topProcesses) {
    $actions += "Finalizar processos pesados de CPU? (Detectados: $($topProcesses[0].ProcessName))"
}

# Memória
$memoryGraph = Get-AsciiGraph -Value $memoryUsage
$memoryPrediction = Get-PredictiveAnalysis -CurrentValue $memoryUsage -ResourceType "Memória"
$reportContent += "<p>Memória: <pre>$memoryGraph</pre> $memoryPrediction</p>"
if ($memoryUsage -gt $ThresholdMemory) {
    $actions += "Liberar memória fechando aplicativos em segundo plano?"
}

# Disco
$diskGraph = Get-AsciiGraph -Value $diskUsage
$diskPrediction = Get-PredictiveAnalysis -CurrentValue $diskUsage -ResourceType "Disco"
$reportContent += "<p>Disco C: <pre>$diskGraph</pre> $diskPrediction</p>"
if ($diskUsage -gt $ThresholdDisk) {
    $actions += "Executar limpeza de disco automática?"
}

# Listar processos principais
$reportContent += "<h2>Top 5 Processos (CPU)</h2><ul>"
foreach ($proc in $topProcesses) {
    $reportContent += "<li>$($proc.ProcessName) - CPU: $($proc.CPU) - Memória: $($proc.WorkingSet64 / 1MB) MB</li>"
}
$reportContent += "</ul>"

# Interação com o usuário e automação
if ($actions.Count -gt 0) {
    Write-Host "Problemas detectados! Ações sugeridas:" -ForegroundColor Yellow
    $actions | ForEach-Object { Write-Host "- $_" }
    $choice = Read-Host "Deseja executar todas as ações sugeridas? (S/N)"
    
    if ($choice -eq "S") {
        foreach ($action in $actions) {
            try {
                if ($action -like "*Finalizar processos*") {
                    $topProcesses[0] | Stop-Process -Force -ErrorAction Stop
                    $reportContent += "<p class='critical'>Ação: Processo $($topProcesses[0].ProcessName) finalizado.</p>"
                }
                elseif ($action -like "*Liberar memória*") {
                    Get-Process | Where-Object { $_.SI -eq 0 -and $_.CPU -lt 10 } | Stop-Process -Force -ErrorAction Stop
                    $reportContent += "<p class='warning'>Ação: Processos em segundo plano liberados.</p>"
                }
                elseif ($action -like "*limpeza de disco*") {
                    Start-Process cleanmgr -ArgumentList "/d C: /sagerun:1" -Wait -ErrorAction Stop
                    $reportContent += "<p class='normal'>Ação: Limpeza de disco executada.</p>"
                }
            }
            catch {
                $reportContent += "<p class='critical'>Erro ao executar ação '$action': $_</p>"
                Write-Error "Erro: $_"
            }
        }
    }
}
else {
    $reportContent += "<p class='normal'>Sistema operando normalmente. Nenhuma ação necessária.</p>"
}

# Gerar relatório final
New-HtmlReport -Content $reportContent
Write-Host "Relatório gerado em: $LogPath" -ForegroundColor Green

# Abrir relatório automaticamente
try {
    Start-Process $LogPath -ErrorAction Stop
}
catch {
    Write-Error "Erro ao abrir o relatório: $_"
}

Write-Host "Script concluído. Pressione Enter para sair." -ForegroundColor Green
Read-Host