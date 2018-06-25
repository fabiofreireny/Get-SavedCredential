function Get-SavedCredentials {
    <#
    .SYNOPSIS
    Creates or retrieves saved credentials securely
    .DESCRIPTION
    Credentials are saved securely in specified json file. 
    Only the user who creates the credential file can retrieve it (any other user will receive an error message).
    .EXAMPLE
     Get-SavedCredentials -filePath credential.json
     Retrieve credential from .\credential.json file. If file does not exist then prompt for credential and save it.
    .EXAMPLE
     Get-SavedCredentials -filePath credential.json -reset
     Reset credential in .\credential.json file. Prompt regardless if file exists or not and save results.
    .EXAMPLE
    $credential = Get-SavedCredentials ($HOME + "\" + (split-path $MyInvocation.MyCommand.Path -Leaf) + "-credential.json")
    Dynamically create path and filename to store credentials in user's home folder
     .OUTPUTS
    PSCredential
    .LINK
    https://github.com/fabiofreireny/Get-SavedCredential
    .NOTES
    Author: Fabio Freire (@fabiofreireny)
     #>

    param(
        [Parameter(Mandatory=$True)]
            [System.IO.FileInfo]$filePath,
        [switch]$reset
    )
    
    If ((Test-Path $filePath) -and (-not $reset)) {
        $data = get-content $filePath | ConvertFrom-Json
        Write-Host "Retrieving credentials from [$filePath]"
        $credential = New-Object System.Management.Automation.PsCredential($data.Username,($data.Password | ConvertTo-SecureString))
    } Else {
        Write-Host "Enter credentials, saving encrypted to [$filePath]"
        $credential = Get-Credential
        $Pass = $credential.Password | ConvertFrom-SecureString
        $Username = $credential.UserName
        
        $Store = "" | Select-Object Username, Password
        $Store.Username = $Username
        $Store.Password = $Pass
        $Store | ConvertTo-Json | Out-File $filePath -Force
    }
    return $credential
}

#Get-SavedCredentials ($HOME + "\" + (split-path $MyInvocation.MyCommand.Path -Leaf) + "-credential.json") #-reset

