Set-Location $PSScriptRoot

$Env:HF_HOME="huggingface"
$Env:HF_ENDPOINT="https://hf-mirror.com"
$Env:PIP_DISABLE_PIP_VERSION_CHECK=1
$Env:PIP_NO_CACHE_DIR=1
$Env:PIP_INDEX_URL="https://pypi.mirrors.ustc.edu.cn/simple"
$Env:UV_INDEX_URL="https://pypi.tuna.tsinghua.edu.cn/simple/"
$Env:UV_EXTRA_INDEX_URL="https://download.pytorch.org/whl/cu124"
$Env:UV_CACHE_DIR="./.cache"
$Env:UV_NO_CACHE=0
$Env:UV_LINK_MODE="symlink"
function InstallFail {
    Write-Output "��װʧ�ܡ�"
    Read-Host | Out-Null ;
    Exit
}

function Check {
    param (
        $ErrorInfo
    )
    if (!($?)) {
        Write-Output $ErrorInfo
        InstallFail
    }
}

try {
    ~/.local/bin/uv --version
    Write-Output "uv installed|UVģ���Ѱ�װ."
}
catch {
    Write-Output "Install uv|��װuvģ����..."
    if ($Env:OS -ilike "*windows*") {
        powershell -ExecutionPolicy ByPass -c "./uv-installer.ps1"
        Check "��װuvģ��ʧ�ܡ�"
    }
    else {
        sh "./uv-installer.sh"
        Check "��װuvģ��ʧ�ܡ�"
    }
}

if ($env:OS -ilike "*windows*") {
    if (Test-Path "./venv/Scripts/activate") {
        Write-Output "Windows venv"
        . ./venv/Scripts/activate
    }
    elseif (Test-Path "./.venv/Scripts/activate") {
        Write-Output "Windows .venv"
        . ./.venv/Scripts/activate
    }else{
        Write-Output "Create .venv"
        ~/.local/bin/uv.exe venv -p 3.10
        . ./.venv/Scripts/activate
    }
}
elseif (Test-Path "./venv/bin/activate") {
    Write-Output "Linux venv"
    . ./venv/bin/Activate.ps1
}
elseif (Test-Path "./.venv/bin/activate") {
    Write-Output "Linux .venv"
    . ./.venv/bin/activate.ps1
}
else{
    Write-Output "Create .venv"
    ~/.local/bin/uv venv -p 3.10
    . ./.venv/bin/activate.ps1
}

Write-Output "��װ������������ (�ѽ��й��ڼ��٣����ڹ�����޷�ʹ�ü���Դ�뻻�� install.ps1 �ű�)"

~/.local/bin/uv pip sync requirements-uv.txt --index-strategy unsafe-best-match
Check "������װʧ�ܡ�"

huggingface-cli download fishaudio/fish-speech-1.5 --local-dir checkpoints/fish-speech-1.5

huggingface-cli download fishaudio/fish-agent-v0.1-3b --local-dir checkpoints/fish-agent-v0.1-3b

Write-Output "��װ���"
Read-Host | Out-Null ;
