*** Variables ***
### INPUT FIELDS ###
${CHECKOUT_DETAILS_FIRST_NAME_INPUT_FIELD}     input[placeholder="First Name"] , input[name="firstName"]
${CHECKOUT_DETAILS_LAST_NAME_INPUT_FIELD}      input[placeholder="Last Name"] , input[name="lastName"]
${CHECKOUT_DETAILS_ZIPCODE_INPUT_FIELD}        input[placeholder="Zip/Postal Code"] , input[name="postalCode"]


### BUTTONS ###
${CART_BUTTON}                         css=#shopping_cart_container a
${CHECKOUT_BUTTON}                     button[name="checkout"]
${CHECKOUT_DETAILS_CONTINUE_BUTTON}    input[type="submit"] , input[name="continue"]
${CHECKOUT_OVERVIEW_FINISH_BUTTON}     css=#finish , button[name=finish] 