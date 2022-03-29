# EC-CD-6D or E0-1A-EA
$CurrMac = get-netadapter | Where-Object {$_.MacAddress -Like "E0-1A-EA*"} | Where-Object {$_.Status -ne "Disabled"}
$JumboSetting = "9014" # Jumbo frames enabled
# Later, a ForEach ($adap in $CurrMac ........ )
Set-NetAdapterAdvancedProperty $CurrMac.Name -DisplayName "Jumbo*" -RegistryValue $JumboSetting
Get-NetAdapterAdvancedProperty $CurrMac.Name -DisplayName "Jumbo*"
