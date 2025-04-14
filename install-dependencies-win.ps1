# Requires Administrator if you want to set system-wide env vars

# --- Install apps using via Chocolatey ---
choco install python --pre -y
choco install starship -y
choco install qutebrowser -y
choco install npm -y
choco install powershell-core -y

# Define potential MSYS2 installation paths
$possibleRoots = @("C:\tools\msys64", "C:\msys64")
$msysRoot = $possibleRoots | Where-Object { Test-Path $_ } | Select-Object -First 1

# Check if MSYS2 is installed
if ($msysRoot)
{
	Write-Host "MSYS2 found at: $msysRoot"
} else
{
	Write-Host "MSYS2 not found. Installing via Chocolatey..."
	choco install msys2 -y
	Start-Sleep -Seconds 10  # give it a moment
	$msysRoot = "C:\tools\msys64"
	if (-Not (Test-Path $msysRoot))
	{
		$msysRoot = "C:\msys64"
	}
	if (Test-Path $msysRoot)
	{
		Write-Host "MSYS2 successfully installed at: $msysRoot"
	} else
	{
		Write-Error "MSYS2 installation failed or not found at expected locations."
		exit 1
	}
}

# Define the MSYS2 bash path
$msysBash = Join-Path $msysRoot "usr\bin\bash.exe"

# Update and install GCC using pacman
Write-Host "Updating MSYS2 packages and installing GCC..."
& $msysBash -lc "pacman -Syuu --noconfirm"
& $msysBash -lc "pacman -S --needed --noconfirm mingw-w64-x86_64-gcc"

# Add MinGW64 bin directory to system PATH if not already present
$mingwBinPath = Join-Path $msysRoot "mingw64\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::Machine)

if ($currentPath -notlike "*$mingwBinPath*")
{
	Write-Host "Adding $mingwBinPath to system PATH..."
	[Environment]::SetEnvironmentVariable("Path", "$currentPath;$mingwBinPath", [EnvironmentVariableTarget]::Machine)
} else
{
	Write-Host "$mingwBinPath already in system PATH."
}

Write-Host "MSYS2 and GCC setup complete. Please restart your terminal to use gcc/g++."


# --- Locate Python installation ---
Start-Sleep -Seconds 3  # Give Chocolatey a second to settle
$pythonExe = Get-Command python | Select-Object -ExpandProperty Source
$pythonDir = Split-Path $pythonExe -Parent
$scriptsDir = Join-Path $pythonDir "Scripts"

# --- Set PATH for User and System ---
$envPaths = @($pythonDir, $scriptsDir)

function Add-ToPath
{
	param (
		[string]$PathType  # "User" or "Machine"
	)

	foreach ($path in $envPaths)
	{
		$existing = [Environment]::GetEnvironmentVariable("Path", $PathType)
		if (-not $existing.Split(';') -contains $path)
		{
			[Environment]::SetEnvironmentVariable(
				"Path",
				"$existing;$path",
				$PathType
			)
			Write-Host "[+] Added to $PathType PATH: $path"
		} else
		{
			Write-Host "[i] Already in $PathType PATH: $path"
		}
	}
}

Add-ToPath -PathType "User"
Add-ToPath -PathType "Machine"

# --- Refresh current session PATH ---
$env:Path += ";" + ($envPaths -join ";")

# --- Use ensurepip to install pip properly ---
$pipPath = Join-Path $scriptsDir "pip.exe"
if (-not (Test-Path $pipPath))
{
	Write-Host "pip not found, using ensurepip to install..."
	python -m ensurepip --upgrade
} else
{
	Write-Host "pip is already present at: $pipPath"
}

# --- Final check ---
Write-Host "=== Python & pip versions ==="
python --version
 
