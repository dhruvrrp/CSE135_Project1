
Allen Gong 			CSE 135  
Dhruv Kaushal		Milestone 1
Jasmine Nguyen		1 May 2014

===================================================================



GENERAL ASSUMPTIONS
-----------------------

Welcome to Papa Yannis's Thrift Shop! Your go-to place for unbeatable
e-commerce deals. This web abb is most optimally viewed in a fully expanded
web browser. Also note that input is indeed case-sensitive.

Below are more specific assumptions for each of the pages of the web app.



SIGN UP
-----------------------

At the sign-up page, our web application requires that all fields must be
correctly filled out for a successful user registration. In particular,
the username must be unique (i.e., it cannot already exist in the database)
and the user's age must be of a valid type (i.e., an integer).



LOG IN
-----------------------

Upon successful login (i.e., the username exists in the database), the user
will be directed to a landing page containing the possible pages of the web app
that they have access to. An Owner can see all pages of the site, as well as
possess their own shopping cart, while a Customer may only directly access
the product browsing page.

If a user is NOT logged in, they can only access: the login page, sthe sign up
page, and the product browsing page.



CATEGORIES
-----------------------

By default, the categories page show all of the categories in the database.
Our web application requires that the "Name" field must be correctly filled out
for a successful insertion into the database. The category name must be unique
(i.e., it cannot already exist in the database). The description may be left
blank to be updated later, if desired.

In addition to not being able to delete a category with products attached to
it, the user is not allowed to update a category if another user has deleted
it. For example, the page allows the user update a Category X, but by the time
the user updates X, the situation has changed (due to an action of another
user), and updating will no longer be allowed.

Upon any database modification (insertions, updates, or deletions) a helpful
message will appear above the forms, relaying whether or not said modification
was successful or ended in a failure.



PRODUCTS
-----------------------
By default, the products page shows all of the products in the database.
Similarly in the categories page, the products page does not allow a user to
update a product that has been deleted by another user. Additionally, a user
cannot delete a product if it is already in another user's shopping cart.

If a user inputs text in the search field and clicks on a category link
in the side bar instead of clicking the "Search" button, the text in the search
field is ignored and only products of the selected category are shown.



PRODUCT BROWSING
-----------------------

By default, the product browsing page shows all of the products in the
database. Similarly to the products page, if a user inputs text in the 
search field and clicks on a category link in the side bar instead of
clicking the "Search" button, the text in the search field is ignored
and only products of the selected category are shown.



PRODUCT ORDER
-----------------------

The user must add a quantity greater than 0 to their cart. Additionally, a user
cannot add a product to their cart that has been deleted by another user.



SHOPPING CART
-----------------------

A user must be logged in in order to see their shopping cart. If their cart is
empty (i.e., they have yet to add any products into their cart), they will see
a friendly message with a link prompting them to browse the products. At the
shopping cart page, the customer can choose either to add more items to their 
cart or purchase the items currently in their existing cart. He/she must fill
out all of the requested information in the credit card form in order for the 
purchase to be successful.
