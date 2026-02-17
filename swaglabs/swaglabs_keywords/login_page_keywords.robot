*** Settings ***
Resource    ../swaglabs_constants/login_page_constants.robot

*** Keywords ***
Login To Swaglabs
    [Arguments]    ${email}    ${password}
    Input Text    ${LOGIN_EMAIL_INPUT_FIELD}       ${email}
    Input Text    ${LOGIN_PASSWORD_INPUT_FIELD}    ${password}
    Click         ${LOGIN_SUBMIT_BUTTON}
    Get Url    *=    inventory.html    # *= means contains, == means exactly equal
    