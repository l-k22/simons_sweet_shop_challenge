# simons_sweet_shop_challenge

PLEASE SWITCH TO THE DEVELOP BRANCH IF YOU HAVE NOT YET

## Getting Started

This project is a prototype work in progress, it initially started as Flutter v2 but having only worked with v1 and limited time I reverted back to v1. There are multiple issues that need to be addressed and general code tidy up.

ONLY TESTED ON ANDROID DEVICE

I took this challenge as an opportunity to learn Bloc state management pattern as it was mentioned as being used in the company's own app. My previous apps all used MVP pattern, I haven't quite got to grips with Bloc but it seems very powerful.

Unit Test partially written - The only unit test written is for the algorithm in your terminal run 'flutter test test'.  Test are missing their comparison to their expected outcome. Unit tests for button presses are next on the list of things to do.

Calculation Algorithm has been through a few re-writes but it can still be optimised. The final method 'cartCleanUp' needs reworking, Subset Sum solution is required.

StoreFront - HomeScreen - missing background image, carousel isn't full implemented it use placeholder array to display images that should be pulled from the database. Same with the decription and sweet title but these are located in the database.

Inputting a order amount and pressing 'Add to Cart' will send you to the basket however I have not finished model and database mapping to display the orders so no orders will be visible. You can however see the alogrithm work in the debug console.

Backend - AdminView - I have hidden a 'Load Mock Data' button in a drawer that can only accessed from this view, simply swipe from left hand side of the screen to the right. There an odd glitch I haven't figured out the cause of yet, if you press the 'Load Mock Data' button only the 5000 pack appears however if you leave the page and re-enter the remainder of the list is populated. The EDIT, DELETE buttons have yet to be implemented, the 'Add Pack' button works however you will not be able to save the new pack.

Assets - Assets haven't been intergrated fully as recommended for Android and IOS devices.

APK file can be found in the route of this repo '/app.apk'

If the app doesn't build try running 'flutter clean' to remove all the build files (if there are any) then 'flutter pub get'

Another TODO is add a gitIgnore file so that the build files are not pushed up to the branch.
