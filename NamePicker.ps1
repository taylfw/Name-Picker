# Grab all existing workstation names

$ExistingNames = (Get-ADComputer -Filter 'Name -like "CONTOSO-*"' -Property * | 
Sort-Object | Select-Object Name).Name


#Create and add all potential workstation names from 'CONTOSO-001' to 'CONTOSO-800' to and empty array list. 

$PotentialName = [System.Collections.ArrayList]@()

$Name = "CONTOSO-"

$Name1 = "CONTOSO-0"

$Name2 = "CONTOSO-00"

$Number = 0 

#I had to add these to avoid them allways popping up in the Compare-Object list.
$PotentialName.Add("CONTOSO-000")
$PotentialName.Add("CONTOSO-999")
Write-Host "Beep Boop"
DO
{

    $Number++
    $PotentialName.Add("$($Name2)$($Number)") > $null

} 

While ($Number -le 8)

DO
{

    $Number++
    $PotentialName.Add("$($Name1)$($Number)") > $null

} 

While ($Number -gt 8 -and $Number -le 98)

DO
{

    $Number++  
    $PotentialName.Add("$($Name)$($Number)") > $null

} 

While ($Number -gt 98 -and $Number -le 800) 

Write-Host "Beep..."

#Compares the two array lists above. It finds all the workstation names that don't matach and creates an array containing usable names. 
$UsableNames = (Compare-Object -ReferenceObject $PotentialName -DifferenceObject $ExistingNames | 
Select-Object InputObject).InputObject 

#Here's where the magic happens.
$Available = Read-Host -Prompt "Enter the number of new AD workstions needed"

Read-Host "Press 'Enter' for the available names in this range"
$Available = $Available - 1
$UsableNames[0..$Available]

$create = Read-Host -prompt "Create these Workstations in AD?(y/n)"

If ($create -eq "y") {

    $load = $UsableNames[0..$Available]

    $FinalAnswer = [System.Collections.ArrayList]@()

    Foreach ($computer in $load){

        Write-Host $computer
        $FinalAnswer.Add($computer)

    } 

    forEach ($computer in $FinalAnswer) {

        New-ADComputer -Name $computer -Path "OU=Field Machines,OU=Workstations,DC=CONTOSO,DC=local"
        Start-Sleep -Seconds 5 -Verbose
        $name = Get-ADComputer $computer
        Write-Host $name.DistinguishedName
        #Optional to add the computer to any security groups for GPO purposes
        Add-ADGroupMember -Members $name.DistinguishedName -Identity 'Workstations'

        Write-Host $computer " created in Active Directory and added to workstations group."

    }
    

} Else {

     write-host "Okay Bye!"

}
