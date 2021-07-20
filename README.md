# simons_sweet_shop_challenge

A new Flutter project.

## Getting Started

This project is a work in progress. There are multiple issues that need address and general code tidy up.

ONLY TESTED ON ANDROID DEVICE

I took this challenge as an opportunity to learn Bloc state management pattern as it was mentioned as being used in the company's own app. I haven't quite got to grips with it but it seems very powerful.

Unit Test partially written - The only unit test written is for the algorithm in your terminal run 'flutter test test'.  Test are missing their comparison to their expected outcome.

Calculation Algorithm has been through a few re-writes but it can still be optimised. The final method [cartCleanUp] needs reworking, Subset Sum solution is required.

StoreFront - HomeScreen - missing background image, carousel isn't full implemented it use placeholder array to display images that should be pulled from the database. Same with the decription and sweet title but these are located in the database.

Inputting a order amount and pressing 'Add to Cart' will send you to the basket however I have not finished model and database mapping to display the orders so no orders will be visible. You can however see the alogrithm work in the terminal.

Backend - AdminView - I have hidden a 'Load Mock Data' button in a drawer that can only accessed from this view. There an odd glitch I haven't figured out the cause of yet, if you press the Load Mock Data Button only 5000 packs appears however if you leave the page and re-enter the remainder of the list is populated.

EDIT, DELETE buttons have yet to be implemented

Assets - Assets haven't been intergrated fully as recommended for Android and IOS devices.
