Import-Module ActiveDirectory

$servers = @()
$servers += Get-ADGroupMember -Identity "SCCM-IT-Thursday-Servers" | foreach { $_.Name }
$servers += Get-ADGroupMember -Identity "SCCM-IT-Production-Servers" | foreach { $_.Name }
$servers += Get-ADGroupMember -Identity "SCCM-IT-Test-Servers" | foreach { $_.Name }

Invoke-Command -ComputerName $servers -ScriptBlock {
##Clean-up SCCM client cache
Write-Host "Cleaning up the SCCM update cache folder on $env:computername" -ForegroundColor Green

$resman = new-object -com "UIResource.UIResourceMgr"
$cacheInfo = $resman.GetCacheInfo()
$cacheinfo.GetCacheElements() | foreach {$cacheInfo.DeleteCacheElement($_.CacheElementID)}
}