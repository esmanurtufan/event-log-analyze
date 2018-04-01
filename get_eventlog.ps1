Param
(
  [string]$sunucu,
  [Parameter( 
            Mandatory = $false)] 
            [string] 
            [ValidateSet("security","application","setup","system")] 
            $log_cesidi = "security",
  [int]$zaman,
  [string]$eventid,  
    [Parameter( 
            Mandatory = $false, 
            ParameterSetName = "", 
            ValueFromPipeline = $False)] 
            [string] 
            [ValidateSet("critical","error","warning","information","verbose")] 
            $seviye = ""
)



if($log_cesidi -eq $null -or $log_cesidi -eq "" -or $log_cesidi -eq " "){

Write-Host -ForegroundColor Red "Log Çeşidi boş geçilemez "
Write-Host -ForegroundColor Yellow "Örnek Kullanım: "
Write-Host -ForegroundColor Yellow "get_evenlog.ps1 -sunucu localhost -log_cesidi security -zaman 60 -eventid 4672 "


exit 0
}


if($seviye){
 if($seviye -eq "critical") {$ss="and Level=1" }
 elseif($seviye -eq "error") {$ss="and Level=2"  }
 elseif($seviye -eq "warning") {$ss="and Level=3"  }
 elseif($seviye -eq "information") {$ss="and Level=0 or Level=4"  }
 elseif($seviye -eq "verbose") {$ss= "and Level=5" }  
}
else{
$ss=$null
}


if($eventid){
$id="and (EventID=$eventid)"
}
else{
$id=$null
}

if($zaman){
Write-Host "Son $zaman dakikanın logları alınıyor"
$saniye=$zaman*60*1000
}
else{
Write-Host "Varsayılan olarak son 1 saatin logları alınıyor"
$saniye=60*60*1000
}


#(Level=1 ) 

$query = @"

<QueryList>
  <Query Id="0" Path="$log_cesidi">
    <Select Path="$log_cesidi">*[System[TimeCreated[timediff(@SystemTime) &lt;=$saniye] $id $ss]]</Select>
  </Query>
</QueryList>
"@



$ScriptBlockContent =
{
$q = $args[0]
Get-WinEvent -FilterXml $q
}

if($sunucu -and $sunucu -ne $null -and $sunucu -ne "localhost"){

Write-Host -ForegroundColor red "Uzak bilgisayarda("$sunucu") çalışılıyor"

Invoke-Command -Computer $sunucu -ScriptBlock $ScriptBlockContent -ArgumentList $query,$bb

}

elseif($sunucu -eq $null -or $sunucu -eq "localhost" -or $sunucu -eq " " -or $sunucu -eq ""  -or $sunucu -eq "\ "){

Write-Host -ForegroundColor Green "Lokal bilgisayarda çalışılıyor"

$events=Get-WinEvent -FilterXml $query

$events
}
