*** Settings ***
Documentation    This test suite will test the swaglabs features:
...              - Login
...              - Adding items
...              - Check cart 
...              - Fill out the information details
...              - Checkout the order
Test Tags        Swaglabs
Suite Setup      Navigate To Swaglabs
Suite Teardown   Close Browser
Resource         ../../global_resources/global_keywords.robot
Resource         ../swaglabs_keywords/login_page_keywords.robot
Resource         ../swaglabs_keywords/inventory_page_keywords.robot

*** Test Cases ***
SWAGLABS-001: As A User, I Should Be Able To Login Using The Standard User Credentails. 
    Login To Swaglabs    standard_user    secret_sauce

SWAGLABS-002: As A Standard User, I Should Be Able To Add Items To The Cart Successfully.
    User Adds Items To The Cart  
    ...    Sauce Labs Backpack
    ...    Sauce Labs Onesie
    User Checks The Added Items In The Cart
    ...    Sauce Labs Backpack
    ...    Sauce Labs Onesie

SWAGLABS-003: As A Standard User, I Should Be Able To Check Out The Items Successfully.
    User Checkouts The Items

SWAGLABS-004: As A Standard User, I Should Be Able To Fill Out The Checkout Details.
    User Fills Out Checkout Details
    ...    Chris
    ...    Cuevas
    ...    1212

SWAGLABS-005: As A Standard User, I Should Be Able To Confirm The Checkout Details.
    User Confirms The Details 
