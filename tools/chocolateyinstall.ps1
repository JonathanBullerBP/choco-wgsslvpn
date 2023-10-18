
$ErrorActionPreference = 'Stop'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = https://cdn.watchguard.com/SoftwareCenter/Files/MUVPN_SSL/12_10/WG-MVPN-SSL_12_10.exe''

$packageArgs = @{
  packageName   = $env:ChocolateyPackageName
  unzipLocation = $toolsDir
  fileType      = 'EXE'
  url           = $url

  softwareName  = 'WatchGuard Mobile VPN with SSL client*'

  checksum      = ''
  checksumType  = 'sha256'

  $silentArgs   = '/silent /verysilent'
}

Install-ChocolateyPackage @packageArgs



















function Add-OpenVPNTAPCert {
  Write-Output "Installing OpenVPN TAP certificate"
  Import-Certificate -FilePath certificate.cer -CertStoreLocation Cert:\LocalMachine\TrustedPublisher
}

function Start-SSLVPNUpdate {
  Write-Output "Starting update"
  Write-Output "Stopping running VPN client"
  if (Get-Process "wgsslvpnc") {
      Stop-Process -Name "wgsslvpnc" -Force
  }
  Install-ChocolateyPackage @packageArgs
}

function Start-SSLVPNInstall {
  Install-ChocolateyPackage @packageArgs
  
}

function Get-SSLVPNClientVersion {
  (Get-Package -Name "*WatchGuard mobile VPN with SSL client*").Name -match "WatchGuard Mobile VPN with SSL client (([0-9]+(\.[0-9]+)+))" | Out-Null
  return $Matches.1
}


  If (Get-SSLVPNClientVersion -lt $LatestVersionNumber)
  {
      Start-SSLVPNUpdate 
  }
  Else {
      Write-Output "VPN client is already up to date"
  }
Else{
  Start-SSLVPNInstall
  Add-OpenVPNTAPCert

}
