# Get-SavedCredential
Creates or retrieves saved credentials securely.
Credentials are saved securely in specified json file. 
Only the user who creates the credential file can retrieve it (any other user will receive an error message).

EXAMPLE

`PS C:\> Get-SavedCredentials -filePath credential.json`

Retrieve credential from .\credential.json file. If file does not exist then prompt for credential and save it.

Dot-source it first (i.e. ". .\Get-SavedCredential") to load it into memory, then use as needed
