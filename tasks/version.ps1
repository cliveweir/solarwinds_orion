<#
.Synopsis
This script detects the version of the SolarWinds Orion Platform and returns the version & hotfix version.
.Description
The version & hotfix version are parsed from the footer of the Orion login page as recommended here:
https://support.solarwinds.com/SuccessCenter/s/article/Determine-which-version-of-a-SolarWinds-Orion-product-I-have-installed?language=en_US
.Outputs
Output is JSON format:
{
  "status" 	: String (Descriptive text)
  "version" : String (Detected SolarWinds Orion version)
  "hotfix"	: Number (Detected SolarWinds Orion hotfix, 0 means none was detected)
}
#>

Function CreateResult {
	Param ([string]$action, [string]$message, [string]$version, [int]$hotfix)
	@{
		status	= $message
		version	= $version
		hotfix	= $hotfix
	} | ConvertTo-Json
}

Function ParseFooterText {
	Param ([string]$footerText)
	$footerRegex1 = "^Orion\sPlatform[A-Z0-9 ,]+:\s[0-9]{4}[\.0-9]+\s"
	$footerRegex2 = "^Orion Platform\s[0-9]{4}[\.0-9]+"
	
	if ($footerText -match $footerRegex1) {
		$version = $footerText.Split(":")[1].Split("©")[0].Trim()
		$hf = $footerText.Split(" ")[2].TrimEnd(",")
	} elseif ($footerText -match $footerRegex2) {
		$version = $footerText.Split(" ")[2].TrimEnd(",")
		$hf = $footerText.Split(" ")[3].TrimEnd(",")
	}

	if ($hf -match "^HF[0-9]+") {
		$hotfix = [int]($hf.Replace("HF", ""))
	} else {
		$hotfix = 0
	}

	if ($null -eq $version -or $null -eq $hotfix) {
		CreateResult -message "Failed to extract version information from: $footerText"
		return
	}

	if ($hotfix -gt 0) {
		CreateResult -message "SolarWinds Orion $version HF$hotfix detected" -version $version -hotfix $hotfix
	} else {
		CreateResult -message "SolarWinds Orion $version (no hotfix) detected" -version $version -hotfix $hotfix
	}
}

# Check for Orion services
try {
	$svcs = Get-Service -Name "OrionModuleEngine" -ErrorAction Stop
} catch {
	# SolarWinds OrionModuleEngine service is not present
}

# If the Orion Core Services package is installed get the version from the package name
# to use as a fallback in case we can't access the login page.
try {
	$pkgs = Get-Package -Name "SolarWinds Orion Core Services *" -ErrorAction Stop
	if ($pkgs.Length -gt 0) {
		$pkgVersion = $pkgs[0].Name.Split(" ")[4]
	}
} catch {
	# SolarWinds Orion Core Services package is not present
}

# Exit if no packages or services were found
if ($svcs.Length -eq 0 -and $pkgs.Length -eq 0) {
	CreateResult -message "SolarWinds Orion is not installed"
	return
}

# Request the Orion login page
try {
	$loginPage = Invoke-WebRequest -Uri "http://localhost:8787/Orion/Login.aspx" -ErrorAction Stop
} catch {
	CreateResult -message "SolarWinds Orion $pkgVersion detected, login to check the hotfix version" -version $pkgVersion
	return
}

# Make sure the footer exists
if ($loginPage.StatusCode -ne 200 -or $loginPage.ParsedHtml.getElementById("footer") -eq [System.DBNull]::Value) {
	CreateResult -message "SolarWinds Orion $pkgVersion detected, login to check the hotfix version" -version $pkgVersion
	return
}

ParseFooterText -footerText $loginPage.ParsedHtml.getElementById("footer").textContent.Trim()
