*** Settings ***
Library     Browser    timeout=60s     strict=False    enable_playwright_debug=True    plugins=${CURDIR}/LocationBanner.py;True        #enable_presenter_mode={"duration": "0.2", "width": "2px", "style": "dotted", "color": "blue"}
Library     String
Library     DateTime
Library     Collections
Library     OperatingSystem
Library     FakerLibrary
Library     clipboard
Library     Process
Library     OperatingSystem
Library     String
Library     Dialogs
Resource    global_constants.robot
# Library     SelfHealing    use_llm_for_locator_proposals=True    collect_locator_info=True

*** Keywords ***
Navigate To Swaglabs
    [Arguments]    ${p_skipRecording}=No
    &{recordVideo}             Create Dictionary    dir=${OUTPUT_DIR}/videos
    ${fileDirectory}    Normalize Path    ${CURDIR}/../test_data/external_downloads/
    New Browser    chromium    headless=${HEADLESS}    downloadsPath=${fileDirectory}     reuse_existing=False    # reuse_existing for running tests in multiple browser windows openned. 
    
    IF    "${p_skipRecording}"=="Yes"
        New Context    viewport={'width': 1746, 'height': 818}
    ELSE IF    "${p_skipRecording}"=="No"
        New Context    recordVideo=${recordVideo}    viewport={'width': 1746, 'height': 818}    #tracing=${OUTPUT_DIR}/Browser/traces.zip
    END

    New Page       ${${PROJECT}_BASE_URL}

Go To Link
    [Documentation]       Navigate To A Link With Wait For PHX Connected
    [Arguments]    ${p_link}
    Go To    ${p_link}
    Wait For PHX Connected    
    # Console Log    LINK: ${p_link}

Upload A File
    [Arguments]    ${p_element}    ${p_file}
    ${t_path}=    Normalize Path    ${CURDIR}/../test_data/${p_file}
    Upload File By Selector    ${p_element}    ${t_path}

Input Text
    # It has 50ms delay by default
    [Arguments]    ${p_element}    ${p_input}    ${p_delay}=50ms    ${p_clear}=True
    Type Text    ${p_element}    ${p_input}    ${p_delay}    ${p_clear}
    Sleep    0.5

Get Current Location
    ${t_currentURL}    Get Url
    RETURN    ${t_currentURL}
    
Clear Text Using Keyboard Keys
    # Argument: Field on which you want to clear the pre-filled text. 
    [Arguments]    ${p_field}
    Click    ${p_field}
    Keyboard Key    down     Control    # To Select all contents then Delete
    Keyboard Key    down     KeyA       # To Select all contents then Delete
    Keyboard Key    press    Delete
    Keyboard Key    up    Control
    Keyboard Key    up    KeyA

Accept Alert
    # Arguments: 
    # p_element - The element that will trigger the file explorer to show. E.g Delete button. 
    # p_dialogueMessage - The actual message of the dialogue for checking if the text is correct.
    [Arguments]    ${p_element}    ${p_dialogueMessage}=NONE
    ${promise}     Promise To    Wait For Alert    action=accept    timeout=10
    Click          ${p_element} 
    IF    "${p_dialogueMessage}" != "NONE"
        ${text}        Wait For    ${promise}
        Should Be Equal      ${text}    ${p_dialogueMessage}
    END

Cancel Alert
    # Arguments: 
    # p_element - fibpnt that will trigger the file explorer to show. E.g Delete button. 
    # p_dialogueMessage - The actual message of the dialogue for checking if the text is correct.
    [Arguments]    ${p_element}    ${p_dialogueMessage}=NONE
    ${promise}     Promise To    Wait For Alert    action=dismiss
    Click          ${p_element} 
    IF    "${p_dialogueMessage}" != "NONE"
        ${text}        Wait For    ${promise}
        Should Be Equal      ${text}    ${p_dialogueMessage}
    END

Accept Download
    [Documentation]    Arguments: 
    ...                p_element - The element/selector that will trigger the download or file explorer to show. E.g Delete button. 
    ...                p_fileName - The filename of downloaded file with file type (sample.docx).
    ...                Flow: Removing the fileToBeDownloaded if it's available, a promise that will wait for Download event after clicking a button
    ...                      If the download succeeds, it will assert if the downloaded file is equals to the expected file. 
    ...                Ref: https://marketsquare.github.io/robotframework-browser/Browser.html#Promise%20To%20Wait%20For%20Download
    [Arguments]    ${p_deleteButtonElement}    ${p_fileName}
    
    # Checker if the file is already existing in the output path. It will remove if it's available.
    Remove File    ${CURDIR}/../test_data/external_downloads/${p_fileName}
    ${t_path}    Normalize Path    ${CURDIR}/../test_data/external_downloads/${p_fileName}
 
    # It will wait for the download event to occur at any moment: After clicking the Delete Button Element. 
    ${dl_promise}          Promise To Wait For Download    ${t_path}    wait_for_finished=True    download_timeout=20
    Click    ${p_deleteButtonElement}

    # It will wait for the download event to finish.
    ${file_obj}    Wait For    ${dl_promise}

    # It will wait for the file to be existing and equal with the expected filename.
    File Should Exist     ${file_obj}[saveAs]
    Should Be Equal       ${file_obj.suggestedFilename}    ${p_fileName}    The files are not equal. 

Remove File Type In A File
    [Documentation]    This will remove the filetype of a given filename. 
    ...                Current Accepted File types: 
    ...                .docx, .doc, .pdf, .csv, .png, .jpg, .jpeg, .txt, .ppt, .pptx, .xls, .xlsx, .msg, .eml, .mp4, .png
    [Arguments]    ${p_fileName}
    ${FILE_WITHOUT_FILE_TYPE}    Remove String Using Regexp    ${p_fileName}    .docx$|.doc$|.pdf$|.csv$|.png$|.jpg$|.jpeg$|.txt$|.ppt$|.pptx$|.xls$|.xlsx$|.msg$|.eml$|.mp4$    # add file types if necessary
    RETURN    ${FILE_WITHOUT_FILE_TYPE}

Refresh When Redirected To Error 404 Page
    # For Debugging Purpose only.
    FOR    ${each}    IN RANGE    3
        ${t_is404PageDisplayed}    Run Keyword And Return Status
        ...    Wait For Elements State    ${ERROR_404_PAGE}    visible    10        
        IF    "${t_is404PageDisplayed}"=="True"
            Log To Console    Redirects to 404 Page!
            Log To Console    Reloading...
            Reload
            Sleep     10
            Wait For Load State
        ELSE IF    "${each}"=="3"
            Log To Console    The Page Still Shows 404 Page After 3 Refresh Times
        ELSE
            Log To Console    Continuing the steps
            Exit For Loop
        END
    END

Console Log
    [Arguments]     ${p_log}
    Log    ${p_log}    console=True

Switch Browser With Print Log
    [Documentation]    For readability and ease of use switching browsers. 
    ...                This will switch the focused browser and logs which user POV is in focus. 
    [Arguments]       ${p_browserID}    ${p_userRole}    ${p_userName}
    Switch Browser    ${p_browserID}
    # Console Log       \nSwitching To "${p_userName}" : "${p_userRole}" POV.

Switch Browser And Tab With Print Log
    [Documentation]    For readability and ease of use switching browsers. 
    ...                This will switch the focused browser and logs which user POV is in focus. 
    [Arguments]       ${p_browserID}    ${p_browserTabID}    ${p_userRole}    ${p_userName}
    Switch Page       ${p_browserTabID}    browser=${p_browserID}
    # Console Log       \nSwitching To "${p_userName}" : "${p_userRole}" POV.

Wait For Elements State With Hover Element
    [Documentation]      It will hover or scroll to the target element.       
    ...                  Useful for debugging the failed test cases in log files. 
    [Arguments]    ${p_elementToBeHover}    ${p_elementToBeChecked}    ${p_elementState}=visible    ${p_timeout}=30    ${p_errorMessage}=The Selector Is Not Displaying. Please Check On Logs Later! 
    Hover    ${p_elementToBeHover}
    Wait For Elements State    ${p_elementToBeChecked}    ${p_elementState}    ${p_timeout}    ${p_errorMessage}

Reload Page And Wait For Fully Load
    [Documentation]    Reloading the page with Wait For PHX Connected after. 
    Reload
    Wait For PHX Connected    

Go Back And Wait For Fully Load
    [Documentation]    Going Back The Page And Wait For PHX Connected after. 
    Go Back
    Wait For PHX Connected

Wait For Success Toast Message To Be Displayed
    [Arguments]    ${p_message}
    Run Keyword And Warn On Failure    Wait For Elements State    //div[contains(@class,"toastify")][contains(string(), "${p_message}")] | //div[contains(@class, "alert")][contains(string(), "${p_message}")]    visible    3    The Toast Message: "${p_message}" is not displaying after 10 seconds.

Wait For Success Toast Message To Be Displayed (No Assertion Of Message)
    Wait For Elements State    //div[contains(@class, "toastify")]    visible    10    The Success Toast Message is not displaying after 10 seconds.

Wait Until Element Is Not Visible    
    [Arguments]    ${p_locator}    ${p_timeout}=20s    ${p_message}=Timeout: The Element Is Not Visible
    Wait For Elements State    ${p_locator}    hidden    ${p_timeout}    ${p_message}
