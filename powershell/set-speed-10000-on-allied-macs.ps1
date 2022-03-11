# EC-CD-6D or E0-1A-EA

$SpeedSetting = "7" # 10gb full duplex	

$CurrMac = get-netadapter | Where {$_.MacAddress -Like "E0-1A-EA*"} | Where {$_.Status -Like "Up"}
#If no matches found, don't try
if ($CurrMac -ne $null)
{
Set-NetAdapterAdvancedProperty $CurrMac.Name -DisplayName "Speed*" -RegistryValue $SpeedSetting
Get-NetAdapterAdvancedProperty $CurrMac.Name -DisplayName "Speed*" # Display set speed
}

$CurrMac = get-netadapter | Where {$_.MacAddress -Like "EC-CD-6D*"} | Where {$_.Status -Like "Up"}
#If no matches found, don't try
if ($CurrMac -ne $null)
{
Set-NetAdapterAdvancedProperty $CurrMac.Name -DisplayName "Speed*" -RegistryValue $SpeedSetting
Get-NetAdapterAdvancedProperty $CurrMac.Name -DisplayName "Speed*" # Display set speed
}
# Clear var values
$CurrMac = ""
$SpeedSetting = ""
