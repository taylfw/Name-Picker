#### Workstation-Creation ####
 This script is written to create new AD computer objects in a organized and logical fashion. The original problem was that the
 newly formatted laptops had names such as "CONTOSO-552", when in fact we only had around 300 workstations in circulation.
To avoid this problem, I was tasked with combing through all of the AD computer objects through the GUI AD app, finding 
 numericle "holes" and filling them. The process was teadious; One, because it took precious time while having to format 20-40
 new laptops. Two, because sometimes there were gaps due to the workstation name being a different OU's such as "Disabled", "Main Office" and such.

* This script makes three array lists:
1) All current workstation names in AD
2) All names trailing with "-000" to "-800"
3) Names that are in the second list but not in the first.

* It will prompt the user for the number of needed names.
* Builds a new array the number of desired new names. 
* loops through and adds the computer and then sets them in the oppriate security groups for group policy purposes. 
Many thanks to @joewpat for his contributions and guidance!
