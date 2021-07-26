# simons_sweet_shop_challenge

PLEASE SWITCH TO THE DEVELOP BRANCH IF YOU HAVE NOT YET

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

