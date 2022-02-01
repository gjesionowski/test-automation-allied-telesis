# EC-CD-6D or E0-1A-EA
$CurrMac = get-netadapter | Where {$_.MacAddress -Like "E0-1A-EA*"} | Where {$_.Status -Like "Up"}
$SpeedSetting = "7" # 10gb full duplex

Set-NetAdapterAdvancedProperty $CurrMac.Name -DisplayName "Speed*" -RegistryValue $SpeedSetting
Get-NetAdapterAdvancedProperty $CurrMac.Name -DisplayName "Speed*"