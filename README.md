# simons_sweet_shop_challenge

PLEASE SWITCH TO THE DEVELOP BRANCH IF YOU HAVE NOT YET

## The Challenge

Simon’s Sweet Shop Challenge 

Simon’s Sweet Shop (SSS) is a confectionery wholesalerthat sells sweets in a variety of pack sizes. They currently have 5 different size packs - 250, 500, 1000, 2000 and 5000. Their customers can order any amount of sweets they wish but they will only ever be sold full packs. They recently changed their pack sizes and may change them again in future depending on demand. 

Requirements 
Build a solution that will enable SSS to send out packs of sweets with as little wastage as possible for any given order size. In orderto achieve this, the following rules should be followed. 
1. Only whole packs can be sent. Packs cannot be broken open. 
2. Within the constraints of Rule 1 above, send out no more Sweets than necessary to fulfil the order. 
3. Within the constraints of Rules 1 & 2 above, send out as few packs as possible to fulfil each order. 
The solution should also be flexible enough to add orremove pack sizes as well as change current pack sizes with minimal adjustments to the program. 

Definitions 
The table below displays correct and incorrect outcomes of a few example orders. You can use this as a guide to test your solution. 

| Sweets ordered | Correct solution | Incorrect solution
-----------------| ----------------- | -----------------|
| 1 | 1 x 250 | 1 x 500 = too many sweets |
| 250 | 1 x 250 |  1 x 500 = too many sweets |
| 251 | 1 x 500 | 2 x 250 = can send less packs with available pack sizes|
| 501 | 1 x 500 | 1 x 1,000 = too many sweets |
| | 1 x 250 | OR 3 x 250 = can send less packs with available pack sizes |
| 12,001 | 2 x 5,000 | 3 x 5,000 = too many sweets  |
| | 1 x 2,000 |
| | 1 x 250 |

Please remember that this is just a guide for some initial testing of your solution. Changing pack sizes may throw up different test cases and challenges thatthis table does not address. 


## Getting Started

This project is a prototype work in progress, it initially started as Flutter v2 but having only worked with v1 and limited time I reverted back to v1. There are multiple issues that need to be addressed and general code tidy up.

TESTED ON AN ANDROID & IPHONE Xr DEVICE 

I took this challenge as an opportunity to learn Bloc state management pattern as it was mentioned as being used in the company's own app. My previous apps all used MVP pattern, I haven't quite got to grips with Bloc but it seems very powerful.

Unit Test partially written - The only unit test written is for the algorithm in your terminal run 'flutter test test'.  Test are missing their comparison to their expected outcome. Unit tests for button presses are next on the list of things to do.

Calculation Algorithm has been through a few re-writes but it can still be optimised. The final method 'cartCleanUp' needs reworking it fails to cleanup packs properly and will in certain instances over order. For example using the mock pack size data as seen in the challenge description with an order amount of 9752 sweets will over order by 1000. My research indicates that Subset Sum solution is required instead.

StoreFront - HomeScreen - missing background image, carousel isn't full implemented it use placeholder array to display images that should be pulled from the database. Same with the description and sweet title but these are located in the database.

Backend - AdminView - I have hidden a 'Load Mock Data' and 'Clear Cart' button in a drawer that can only accessed from this view, simply swipe from right hand side of the screen to the left. The EDIT button has now been implemented however UX isn't perfect, it should only toggle the pack you want to edit not all.

Assets - Assets haven't been intergrated fully as recommended for Android and IOS devices.

APK file can be found in the route of this repo '/app.apk'

If the app doesn't build try running 'flutter clean' to remove all the build files (if there are any) then 'flutter pub get'

