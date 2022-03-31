# EC-CD-6D or E0-1A-EA

$SpeedSetting = "6" # 1000mb full duplex	

$CurrMac = get-netadapter | Where-Object {$_.MacAddress -Like "E0-1A-EA*"} | Where-Object {$_.Status -Like "Up"}
#If no matches found, don't try
if ($null -ne $CurrMac)
{
Set-NetAdapterAdvancedProperty $CurrMac.Name -DisplayName "Speed*" -RegistryValue $SpeedSetting
Get-NetAdapterAdvancedProperty $CurrMac.Name -DisplayName "Speed*" # Display set speed
}

$CurrMac = get-netadapter | Where-Object {$_.MacAddress -Like "EC-CD-6D*"} | Where-Object {$_.Status -Like "Up"}
#If no matches found, don't try
if ($null -ne $CurrMac)
{
Set-NetAdapterAdvancedProperty $CurrMac.Name -DisplayName "Speed*" -RegistryValue $SpeedSetting
Get-NetAdapterAdvancedProperty $CurrMac.Name -DisplayName "Speed*" # Display set speed
}
# Clear var values
$CurrMac = ""
$SpeedSetting = ""