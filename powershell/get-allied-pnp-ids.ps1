Get-PnpDevice -Class Net |
Where-Object Status -Like "OK" | 
Where-Object DeviceId -Like "*14e4*" | 
Where-Object DeviceId -Like "*1656*" |
Get-PnpDeviceProperty | Where-Object KeyName -Like "*HardwareIds*" | Format-Table DeviceId