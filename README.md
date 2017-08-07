# Find-VulnerableSoftware
Find privesc CVEs for non-microsoft software with the appropriate version. 

```
010 Editor 8.0 (64-bit)
Explorer Suite IV
OpenVPN 2.4.2-I601 
CVE-2014-8104
	 OpenVPN 2.x before 2.0.11, 2.1.x, 2.2.x before 2.2.3, and 2.3.x before 2.3.6 allows remote authenticated users to cause a denial of service (server crash) via a small control channel packet.
		 http://advisories.mageia.org/MGASA-2014-0512.html
		 http://lists.opensuse.org/opensuse-security-announce/2014-12/msg00008.html
		 http://www.debian.org/security/2014/dsa-3084
		 http://www.mandriva.com/security/advisories?name=MDVSA-2015:139
		 http://www.ubuntu.com/usn/USN-2430-1
		 https://community.openvpn.net/openvpn/wiki/SecurityAnnouncement-97597e732b

```

# Get-InstalledSoftware
Get a list of installed software in a safe manner

Credit to Sean Kearney. I just modified a little bit for version info and more usable for red team/pentest engagements.

This will pulled installed software in a safer manner than WMI queries. It references the uninstall registry keys for name and version.


```
PS C:\Users\> Get-InstalledSoftware

010 Editor 8.0 (64-bit) -
Explorer Suite IV -
Microsoft .NET Framework 4 Client Profile - 4.0.30319
Microsoft .NET Framework 4 Extended - 4.0.30319
OpenVPN 2.4.2-I601  - 2.4.2-I601
Python 2.7 pywin32-219 -
TAP-Windows 9.21.2 - 9.21.2
WinRAR 5.21 (64-bit) - 5.21.0
Microsoft Visual C++ 2013 x64 Additional Runtime - 12.0.40649 - 12.0.40649
Microsoft Visual C++ 2008 Redistributable - x64 9.0.30729.6161 - 9.0.30729.6161
Microsoft .NET Framework 4 Extended - 4.0.30319
Microsoft Office Office 64-bit Components 2010 - 14.0.4763.1000
Microsoft Office Shared 64-bit MUI (English) 2010 - 14.0.4763.1000
Microsoft Office Shared 64-bit Setup Metadata MUI (English) 2010 - 14.0.4763.1000
Microsoft Visual C++ 2013 x64 Minimum Runtime - 12.0.40649 - 12.0.40649
Python 2.7.10 (64-bit) - 2.7.10150
VMware Tools - 9.9.2.2496486
Microsoft .NET Framework 4 Client Profile - 4.0.30319
```
