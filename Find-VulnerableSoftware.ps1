Function Find-VulnerableSoftware
{
<#
.SYNOPSIS
Gets a list of installed third party software by querying the registry's uninstall keys. Safer than querying WMI directly for installed applications.
 
.DESCRIPTION
Useful to getting a list of possibly vulnerable applications for privilege escalation. Since any services/software running with privileged permissions is likely to be windows compliant, this method should be suitable. 
#>

$SearchURI = 'http://cve.circl.lu/api/search'
$Branch='LocalMachine'   
$SubBranch="SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall"  
 
$registry=[microsoft.win32.registrykey]::OpenRemoteBaseKey('Localmachine',$computername)  
$registrykey=$registry.OpenSubKey($Subbranch)  
$SubKeys=$registrykey.GetSubKeyNames()  
 
Foreach ($key in $subkeys)  
{  
    $exactkey=$key  
    $NewSubKey=$SubBranch+"\\"+$exactkey  
    $ReadUninstall=$registry.OpenSubKey($NewSubKey)  
    $Value=$ReadUninstall.GetValue("DisplayName")
    $Version=$ReadUninstall.GetValue("DisplayVersion")
    if ($Version)
    {
        $split_vers = $Version.Split('.')
        $short_vers = "{0}.{1}" -f $split_vers[0],$split_vers[1]
    }
    # Installed software name is not null and not Microsoft
    if($Value -And -Not ($Value -like "*Microsoft*")) 
    {
        Write-Host $Value 
        $split_string = $Value.Split()
        $searchString = ($SearchURI) +"/"+($split_string[0])+"/"
        if ($split_string[1] -match "^[a-z]"){
            # only use second parameter if its not a version number
            $searchString = $searchString + ($split_string[1]) + "/"
        }
        #Write-Host $searchString
        $response = (New-Object System.Net.WebClient).DownloadString($searchString)

        [void][System.Reflection.Assembly]::LoadWithPartialName("System.Web.Extensions")        
        $jsonserial= New-Object -TypeName System.Web.Script.Serialization.JavaScriptSerializer 
        $jsonserial.MaxJsonLength  = 67108864
        $data = $jsonserial.DeserializeObject($response).data

        Foreach ($cve in $data) 
        {
            # Where access: vector: NETWORK or LOCAL
            if ($cve.access.vector -notlike "NETWORK" -and $cve.access.vector -notlike "LOCAL" ){ continue } 
            # impact: availability: COMPLETE or confidentiality: COMPLETE or integrit: COMPLETE
            if ($cve.impact.availability -like "COMPLETE" -or $cve.impact.confidentiality -like "COMPLETE" -or $cve.impact.integrity -like "COMPLETE") 
            {
                if ($short_vers)
                {
                    $found = $false
                    Foreach ($vuln_vers in $cve.vulnerable_configuration)
                    {
                        if ($vuln_vers -contains $short_vers) 
                        {
                            $found = $true
                            break
                        }
                    }
                    if (-not $found) { continue }
                }   
                Write-Host $cve.id -ForegroundColor Yellow
                Write-Host `t $cve.summary -ForegroundColor DarkYellow
                Foreach ($link in $cve.references)
                {
                    Write-Host `t`t $link -ForegroundColor Gray
                }
                Write-Host `n

            }
        }

    }
}  

}
