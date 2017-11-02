#This script will enable non-owner mailbox access auditing on every mailbox in your tenancy

#This gets us logged in and connected to an Exchange remote powershell service
#Note: this requires the newer Exchange Powershell available through the Hybrid section of https://outlook.office365.com/ecp/
#This section modified 11/2 to support Modern Authentication and Microsoft's MFA.
$ExoSession = Connect-EXOPSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ 
Import-PSSession $ExoSession

#Enable global audit logging
Get-Mailbox -ResultSize Unlimited -Filter {RecipientTypeDetails -eq "UserMailbox" -or RecipientTypeDetails -eq "SharedMailbox" -or RecipientTypeDetails -eq "RoomMailbox" -or RecipientTypeDetails -eq "DiscoveryMailbox"}| Set-Mailbox -AuditEnabled $true -AuditLogAgeLimit 365 -AuditOwner Create,HardDelete,MailboxLogin,MoveToDeletedItems,SoftDelete,Update

#Double-Check It!
Get-Mailbox -ResultSize Unlimited | Select Name, AuditEnabled, AuditLogAgeLimit | Out-Gridview
