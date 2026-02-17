*** Settings ***
Resource    ../swaglabs_constants/inventory_page_constants.robot

*** Keywords ***
User Adds Items To The Cart 
    [Arguments]    @{items}
    FOR    ${item}    IN     @{items}
        Click    //div[@class="inventory_item"][contains(string(), "${item}")]//button
        Wait For Elements State    //div[@class="inventory_item"][contains(string(), "${item}")]//button[string()="Remove"]    visible    
    END

User Checks The Added Items In The Cart
    [Arguments]    @{items}
    FOR    ${eachItem}    IN    @{items}
        Wait For Elements State    //div[@data-test="inventory-item-name"][string()="${eachItem}"]    visible
    END
    
    Click    ${CART_BUTTON}
    Get Url    *=    cart.html

User Checkouts The Items
    Click    ${CHECKOUT_BUTTON}
    Get Url    *=    checkout-step-one.html

User Fills Out Checkout Details
    [Arguments]    ${firstName}    ${lastName}    ${zipCode}
    Input Text    ${CHECKOUT_DETAILS_FIRST_NAME_INPUT_FIELD}    ${firstName}
    Input Text    ${CHECKOUT_DETAILS_LAST_NAME_INPUT_FIELD}    ${lastName}
    Input Text    ${CHECKOUT_DETAILS_ZIPCODE_INPUT_FIELD}    ${zipCode}
    Click         ${CHECKOUT_DETAILS_CONTINUE_BUTTON}
    Get Url    *=    checkout-step-two.html

User Confirms The Details 
    Click    ${CHECKOUT_OVERVIEW_FINISH_BUTTON}
    Get Url    *=    checkout-complete.html

