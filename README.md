#### Workstation-Creation ####
 This script is written to create new AD computer objects in a organized and logical fashion. The original problem was that the
 newly formatted laptops had names such as "FRANKSTATION-552", when in fact we only had around 300 workstations in circulation.
To avoid this problem, I was tasked with combing through all of the AD computer objects through the GUI AD app, finding 
 numericle "holes" and filling them. The process was teadious; One, because it took precious time while having to format 20-40
 new laptops. Two, because sometimes there were gaps due to the workstation name being a different OU's such as "Disabled", "Main Office" and such. ARRG!

 So, this script does the following:

1) It will export a list from AD of all the current workstations to an arraylist
2) A second arraylist will be created with all the workstation names from FRANKSTATION-001 to FRANKSTATION-557, althought we won't need so many.
3) This script will promt the user for a number of new laptops that need to be added to AD.
4) The script will loop through both lists. If the name of a given workstation only exist in one list, then it is added to the
third list. The number of workstations in the third list is dependant on the number that the user inputs when prompted earlier.

5) The script loops through the third list creating the new workstations. Yay!

In an added effort to avoid Franking things up I have also included the feature of adding the workstations to the workstaions OU at the 
end of the script. Now that's using your noodle, Frankelton. 

Many thanks to @joewpat for his contributions and guidance!
