# EC-CD-6D or E0-1A-EA

$JumboSetting = "9014" # Jumbo frames enabled

# Later, a ForEach ($adap in $CurrMac ........ )
$CurrMac = get-netadapter | Where-Object {$_.MacAddress -Like "E0-1A-EA*"} | Where-Object {$_.Status -Like "Up"}
#If no matches found, don't try
if ($null -ne $CurrMac)
{
Set-NetAdapterAdvancedProperty $CurrMac.Name -DisplayName "Jumbo*" -RegistryValue $JumboSetting
Get-NetAdapterAdvancedProperty $CurrMac.Name -DisplayName "Jumbo*" # Display jumbo setting
}

$CurrMac = get-netadapter | Where-Object {$_.MacAddress -Like "EC-CD-6D*"} | Where-Object {$_.Status -Like "Up"}
#If no matches found, don't try
if ($null -ne $CurrMac)
{
Set-NetAdapterAdvancedProperty $CurrMac.Name -DisplayName "Jumbo*" -RegistryValue $JumboSetting
Get-NetAdapterAdvancedProperty $CurrMac.Name -DisplayName "Jumbo*" # Display jumbo setting
}
# Clear var values
$CurrMac = ""
$JumboSetting = ""