Function Get-InstalledSoftware
{
  <#
  .SYNOPSIS
  Gets a list of installed software by querying the registry's uninstall keys. Safer than querying WMI directly for installed applications.

  .DESCRIPTION
  Useful to getting a list of possibly vulnerable applications for privilege escalation. Since any services/software running with privileged permissions is likely to be windows compliant, this method should be suitable. 
  #>

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
      if($Value)
      {
          WRITE-HOST $Value - $Version
      }
  }  

}
