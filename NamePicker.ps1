



# Export all existing Workstation names to a CSV file with a beefy one liner. 
# !! Removing this - we can store the AD objects in memory for a speed enhancment (like a speed hole)

$allPCs = Get-ADComputer -Filter 'Name -like "FRANKSTATION-*"' -Property *  
 
#Import all of the existing Active Directory workstion names into an empty array list.
#!! removing this for the same reasons as above, we can do this in memory for quickification
#$Path = Import-Csv -Path C:\Users\ftaylor\Desktop\ADComputerList.csv

$ExistingNames = [System.Collections.ArrayList]@()

ForEach ($workstation in $allPCs) {

#Write-Host $workstation.Name

$ExistingNames.Add($workstation.Name)

}


#Create and add all potential workstation names from 'OPTIMUMHIT-001' to 'OPTIMUMHIT-557' to and empty array list. 

$PotentialName = [System.Collections.ArrayList]@()

$Name = "FRANKSTATION-"

$Name1 = "FRANKSTATION-0"

$Name2 = "FRANKSTATION-00"

$Number = 0

#I had to add this to avoid it allways popping up in the Compare-Object list.
$PotentialName.Add("FRANKSTATION-000")

DO
{

$Number++

#Write-Host "$($Name2)$($Number)"

$PotentialName.Add("$($Name2)$($Number)")

} While ($Number -le 8)

DO
{

$Number++

#Write-Host "$($Name1)$($Number)"

$PotentialName.Add("$($Name1)$($Number)")

} While ($Number -gt 8 -and $Number -le 98)


DO
{

$Number++

#Write-Host "$($Name)$($Number)"

$PotentialName.Add("$($Name)$($Number)")

} While ($Number -gt 98 -and $Number -le 556)

#This little guy compares the two array lists above. It finds all the workstation names that don't matach and creates a csv file containing usable names. 
$UsableNames = [System.Collections.ArrayList]@()
$availableWorkstationNames = Compare-Object -ReferenceObject $PotentialName -DifferenceObject $ExistingNames | 
Select-Object InputObject
Foreach ($WS in $availableWorkstationNames) {

Write-Host $WS.InputObject
$UsableNames.Add($WS.InputObject)

}

#Here's where the magic happens.
$Available = Read-Host -Prompt "Enter the number of new AD workstions needed"

Read-Host "Press 'Enter' for the available names in this range"
$Available = $Available - 1
$UsableNames[0..$Available]

$create = Read-Host -prompt "Create these Workstations in AD?(y/n)"

If ($create = "y") {

$load = $UsableNames[0..$Available]

$FinalAnswer = [System.Collections.ArrayList]@()

Foreach ($computer in $load){
Write-Host $computer
$FinalAnswer.Add($computer)

forEach ($computer in $FinalAnswer) {

New-ADComputer -Name $computer -Path "OU=Field Machines,OU=Workstations,DC=OPTIMUMHIT,DC=local"

}
foreach($computer in $FinalAnswer){

$name = Get-ADComputer $computer
Add-ADGroupMember -Members $name -Identity 'Workstations'
}

} 
}Else {
write-host "Okay, whatever"
}