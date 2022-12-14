<#--

(c) Sayantan Basu

USAGE: 
In PowerShell, navigate to directory and enter

	.\script.ps1 -minutes <No. of Minutes> -mouse --> for simulating cursor movement
	OR
	.\script.ps1 -minutes <No. of Minutes> -keyboard --> for simulating keyboard input

If minutes parameter is omitted, defaults to 45 minutes. For ease of use, configure batch file to run script.
NOTE: Code for -keyboard option only works when no other instance of Notepad is present. 
CLOSE ALL NOTEPAD INSTANCES BEFORE TRIGGERING.

--#>

param(
	[switch]$mouse=$false,
	[switch]$keyboard=$false,
	[int]$minutes=45,
	[System.Security.SecureString]$code = $(Read-Host "AUTH CODE" -AsSecureString)
)

if ((New-Object PSCredential ("default", $code)).GetNetworkCredential().Password -ceq "qWerTy") {
	$timer = 1
	if($mouse -and $keyboard) {
		Write-Host "***TOO MANY ARGUMENTS***"
	} elseif ($mouse) {
		Add-Type -AssemblyName System.Windows.Forms
		Write-Host "PRESS CTRL + C TO STOP"
		while ($timer -le $minutes * 12) {
			$Pos = [System.Windows.Forms.Cursor]::Position
			for($i = 1; $i -le 100; $i++) {
				$jig = [Math]::Pow(-1, $timer) * $i
				[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point((($Pos.X) + $jig), (($Pos.Y) + $jig))
			}
			Start-Sleep -Seconds 5
			$timer++
		}
	} elseif ($keyboard) {
		Write-Host "CLOSE NOTEPAD TO STOP"
		Start-Sleep -Seconds 5
		notepad.exe
		Start-Sleep -Seconds 1
		$WShell = New-Object -ComObject Wscript.Shell
		$check = $WShell.AppActivate("notepad")
		Start-Sleep -Seconds 5
		while ($timer -le $minutes * 12 -and $check) {
			$WShell.SendKeys("G")
			Start-Sleep -Seconds 5
			$timer++
			$check = @($true, $false)[(Get-Process "notepad" -ErrorAction SilentlyContinue).id -eq $null]
		}
	} else { Write-Host "***TOO FEW ARGUMENTS***" }
} else { Write-Host "***UNAUTHORIZED***" }