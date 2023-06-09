*** Settings ***
Library             RequestsLibrary
Library             Collections
Library             RPA.JSON
Resource            ../resource/base_url.robot

*** Variables ***
${value_title}            sunt aut facere repellat provident occaecati excepturi optio reprehenderit
${value_body}             quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto
${value_userId}           1
${value_id}               1
${payload_title}          Skill Test Surplus
${payload_body}           API Automation POST Using Robot Framework
${payload_userId}         99

*** Keywords ***
GET Automation Test
    ${response}=    GET    url=${base_url}
    Log To Console    ${response.json()}[0]

    # Validation 
    Should Contain    ${response.json()}[0]    userId
    Should Contain    ${response.json()}[0]    id
    Should Contain    ${response.json()}[0]    title
    Should Contain    ${response.json()}[0]    body

    ${response_userId}=    Get value from JSON    ${response.json()}[0]    userId
    Should Be Equal As Integers    ${response_userId}       ${value_userId}
    ${response_id}=        Get value from JSON    ${response.json()}[0]    id
    Should Be Equal As Integers    ${response_id}           ${value_id}
    ${response_title}=     Get value from JSON    ${response.json()}[0]    title
    Should Be Equal As Strings     ${response_title}        ${value_title}
    ${response_body}=      Get value from JSON    ${response.json()}[0]    body
    Should Be Equal As Strings     ${response_body}         ${value_body}

POST Automation Test
    ${json}=    Load JSON from file    ${CURDIR}/../json_schema/post_account.json
    ${json}=    Update value to JSON    ${json}    $.title        ${payload_title}
    ${json}=    Update value to JSON    ${json}    $.body         ${payload_body}
    ${json}=    Update value to JSON    ${json}    $.userId       ${payload_userId}
    Set Test Variable    ${JSON_SCHEMA}        ${json}
    ${response}=    POST    url=${base_url}    json=${JSON_SCHEMA}
    Log To Console    ${response.json()}

    #Validation
    Should Contain    ${response.json()}    title
    Should Contain    ${response.json()}    body
    Should Contain    ${response.json()}    userId

    ${response_title}=    Get value from JSON    ${response.json()}    title
    Should Be Equal As Strings    ${response_title}      ${payload_title}
    ${response_body}=     Get value from JSON    ${response.json()}    body
    Should Be Equal As Strings    ${response_body}       ${payload_body}
    ${response_userId}=   Get value from JSON    ${response.json()}    userId
    Should Be Equal As Strings    ${response_userId}     ${payload_userId}

