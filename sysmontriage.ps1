#Requires -RunAsAdministrator
Set-ExecutionPolicy Bypass

#Resources:
# https://www.reddit.com/r/PowerShell/comments/7ttggn/how_would_you_use_powershell_to_parse_sysmon_logs/
# https://stackoverflow.com/questions/24329237/count-sort-and-group-by-in-powershell

cls
Write-Host "Sysmon Triage is starting to collect logs." -ForegroundColor red -BackgroundColor white
sleep 1.5
Write-Host "You can access .csv files --> C:\SysmonTriage\*.csv" -ForegroundColor red -BackgroundColor white
sleep 1.5 
Write-Host "Creating a new folder if it is necessary..." -ForegroundColor red -BackgroundColor white
$path = "C:\SysmonTriage"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}
Write-Host "Clearing the folder if it is not empty..." -ForegroundColor red -BackgroundColor white
Get-ChildItem -Path C:\SysmonTriage\ -Include * -File -Recurse | foreach { $_.Delete()}

Write-Host "[+] Retrieving Sysmon Dns Queries"
Write-Host
$account = @()
$events = Get-WinEvent -FilterHashtable @{logname="Microsoft-Windows-Sysmon/Operational"; Id=22}  
ForEach ($event in $events) 
{
    if ($event.Message.Contains("QueryName"))
    {
     
        # Create hashtable
        $Dictionary = @{}
        # Convert event message to string
        $string = $event.Message.ToString()
        # Split lines in event message based off newline, and remove any null values
        $string.Split([environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries) | ForEach-Object {
            #Split each pair into key and value based off ':' delimiter
            $key,$value = $_.Split(':')
            #Write-Host "Key: " $key
            #Write-Host "Value: " $value
            #Populate $Dictionary
            $Dictionary[$key] = $value
            } 
        }
  $Dictionary.Item("QueryName") >>  C:\SysmonTriage\dnsQueries.csv

    }

   Get-Content -Path C:\SysmonTriage\dnsQueries.csv |    Group-Object -NoElement | Sort-Object –Descending -Property Count  |   Out-GridView -Title DnsQueryNames
   
Write-Host "[+] Retrieving Sysmon Destination IP Queries"
Write-Host
$account = @()
$events = Get-WinEvent -FilterHashtable @{logname="Microsoft-Windows-Sysmon/Operational"; Id=3}  
ForEach ($event in $events) 
{
    if ($event.Message.Contains("DestinationIp"))
    {
     
        # Create hashtable
        $Dictionary = @{}
        # Convert event message to string
        $string = $event.Message.ToString()
        # Split lines in event message based off newline, and remove any null values
        $string.Split([environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries) | ForEach-Object {
            #Split each pair into key and value based off ':' delimiter
            $key,$value = $_.Split(':')
            #Write-Host "Key: " $key
            #Write-Host "Value: " $value
            #Populate $Dictionary
            $Dictionary[$key] = $value
            } 
        }
  $Dictionary.Item("DestinationIp") >>  C:\SysmonTriage\destinationIP.csv

  }

   Get-Content -Path C:\SysmonTriage\destinationIP.csv |    Group-Object -NoElement | Sort-Object -Property Count  |   Out-GridView -Title destinationIP
    
Write-Host "[+] Retrieving CommandLine Queries"
Write-Host
$account = @()
$events = Get-WinEvent -FilterHashtable @{logname="Microsoft-Windows-Sysmon/Operational"; Id=1}  
ForEach ($event in $events) 
{
    if ($event.Message.Contains("CommandLine"))
    {
     
        # Create hashtable
        $Dictionary = @{}
        # Convert event message to string
        $string = $event.Message.ToString()
        # Split lines in event message based off newline, and remove any null values
        $string.Split([environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries) | ForEach-Object {
            #Split each pair into key and value based off ':' delimiter
            $key,$value = $_.Split(':')
            #Write-Host "Key: " $key
            #Write-Host "Value: " $value
            #Populate $Dictionary
            $Dictionary[$key] = $value
            } 
        }
  $Dictionary.Item("CommandLine") >>  C:\SysmonTriage\commandLine.csv



  }

   Get-Content -Path C:\SysmonTriage\commandLine.csv |    Group-Object -NoElement | Sort-Object -Property Count  |   Out-GridView -Title commandLine
   
Write-Host "[+] Retrieving DestinationPort List"
Write-Host
$account = @()
$events = Get-WinEvent -FilterHashtable @{logname="Microsoft-Windows-Sysmon/Operational"; Id=3}  
ForEach ($event in $events) 
{
    if ($event.Message.Contains("DestinationPort"))
    {
     
        # Create hashtable
        $Dictionary = @{}
        # Convert event message to string
        $string = $event.Message.ToString()
        # Split lines in event message based off newline, and remove any null values
        $string.Split([environment]::NewLine,[System.StringSplitOptions]::RemoveEmptyEntries) | ForEach-Object {
            #Split each pair into key and value based off ':' delimiter
            $key,$value = $_.Split(':')
            #Write-Host "Key: " $key
            #Write-Host "Value: " $value
            #Populate $Dictionary
            $Dictionary[$key] = $value
            } 
        }
  $Dictionary.Item("DestinationPort") >>  C:\SysmonTriage\DestinationPort.csv

  }

   Get-Content -Path C:\SysmonTriage\DestinationPort.csv |    Group-Object -NoElement | Sort-Object –Descending -Property Count  |   Out-GridView -Title DestinationPort

  sleep 2
  Write-Host "Check csv files for detailed logs..." -ForegroundColor red -BackgroundColor white
