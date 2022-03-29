# EC-CD-6D or E0-1A-EA
# If this starts failing, consider that it used to look for non-disabled ports instead of just Up
$JumboSetting = "1514" # Jumbo frames disabled

# Later, a ForEach ($adap in $CurrMac ........ ) to support multi-port NICs
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