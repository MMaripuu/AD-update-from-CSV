#********************************************************
# NAME : AD-update-from-CSV.ps1
# Original script by : Rudy Mens
# Modified by : Marius Maripuu
# Version : 1.0
# DATE : 19th of June 2019
# Description : Imports CSV file values and modifies 
# AD account attributes and group membership 
# 
#
# Feedback & issues:
# https://github.com/MMaripuu/AD-update-from-CSV/issues
#
#********************************************************


#Script location query
$ScriptPath = (Get-Item $PSScriptRoot).FullName

#CSV file import path
$csvimport = Import-Csv -Delimiter ";" -Path ($ScriptPath + "\aduser-mobile-group.csv")

foreach($user in $csvimport){
 #Find AD user
   $ADUser = Get-ADUser -Filter "displayname -eq '$($user.name)'" -Properties SamAccountName

 #Modify AD account attributes and add group membership
    if ($ADUser){
        Set-ADUser -Identity $ADUser -Mobile $user.mobile
        Add-ADGroupMember -Identity $user.group -Members ($ADUser).SamAccountName

    }else{
        Write-Warning ("AD account update failed on " + $($user.name))
    }
 }