#################################################### Name Picker ########################################################################
# This script is written to create new AD computer objects in a organized and logical fashion. The original problem was that the
# newly formatted laptops had names such as "OPTIMUMHIT-552", when in fact we only had around 300 workstations in circulation.
# To avoid this problem, I was tasked with combing through the all of the AD computer objects through the GUI AD app, finding 
# numericle "holes" and filling them. The process was teadious; One, because it took precious time while having to format 20-40
# new laptops. Two, because sometimes there were gaps due to the workstation name being a different OU's (Disabled and such). ARRG!
# So, 
# 1) It will export a list from AD of all the current workstations to a CSV file and import that into List# 1
# 2) A second List will be created with all the workstation names from OPTIMUMHIT-001 to OPTIMUMHIT-557, althought we won't need so many.
# 3) This script will promt the user for a number of new laptops that need to be added to AD.
# 4) The script will loop through both lists. If the name of a given workstation only exist in one list, then it is added to the
# third list. The number of workstations in the third list is dependant on the number that the user inputs when prompted earlier.
# 
# 5) The script loops through the third list creating the new workstations. Yay!
#
# In an added effort to avoid Franking things up I have also included the feature of adding the workstations to the workstaions OU at the 
# end of the script. Now that's using your noodle, Frankelton. 
######################################################################################################################################## 



# Export all existing Workstation names to a CSV file with a beefy one liner. 

Get-ADComputer -Filter 'Name -like "OPTIMUMHIT-*"' -Property * | 
Sort-Object | Select-Object Name | 
Export-Csv C:\users\ftaylor\Desktop\ADComputerList.csv -NoTypeInformation -Encoding UTF8



#Import all of the existing Active Directory workstion names into an empty array list.

$Path = Import-Csv -Path C:\Users\ftaylor\Desktop\ADComputerList.csv

$ExistingNames = [System.Collections.ArrayList]@()

ForEach ($workstation in $Path) {

#Write-Host $workstation.Name

$ExistingNames.Add($workstation.Name)

}


#Create and add all potential workstation names from 'OPTIMUMHIT-001' to 'OPTIMUMHIT-557' to and empty array list. 

$PotentialName = [System.Collections.ArrayList]@()

$Name = "OPTIMUMHIT-"

$Name1 = "OPTIMUMHIT-0"

$Name2 = "OPTIMUMHIT-00"

$Number = 0

#I had to add this to avoid it allways popping up in the Compare-Object list.
$PotentialName.Add("OPTIMUMHIT-000")

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

Compare-Object -ReferenceObject $PotentialName -DifferenceObject $ExistingNames | 
select InputObject | 
Export-Csv -Path C:\Users\ftaylor\Desktop\PossibleNames.csv -NoTypeInformation -Encoding UTF8

$UsableNames = [System.Collections.ArrayList]@()
$Path2 = Import-Csv -Path C:\Users\ftaylor\Desktop\PossibleNames.csv
Foreach ($WS in $Path2) {

Write-Host $WS.InputObject

$UsableNames.Add($WS.InputObject)

}

#foreach ($PosName in $UsableNames){
#Write-Host $PosName
#}


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
write-host "Okay Bye!"
}










