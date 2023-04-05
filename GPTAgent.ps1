$endpoint = "https://api.openai.com/v1/chat/completions"
$apikey = "<insert your api key here>"
$headers = @{ Authorization = "Bearer $apikey"; "Content-Type" = "application/json" }

$initialSystemPrompt = @"
You are an agent who will be assigned a task and must make a series of commands one by one to achieve your task. You can browse the internet by making HTTP requests, but you do not have any API keys available for protected APIs.
Be aware that all your commands and their resulting outputs will be stored in your command history, and you have a miximum of 8000 tokens, so avoid polluting it with large strings.
You will have access to the command history to see which commands have already been issued. The results will be returned to you.

You must issue powershell commands with the following format:
{
  "thoughtProcess": "<Thoughts about how to achieve your task>",
  "actionDescription": "<Description of your action>",
  "command": "<Powershell command or nothing if you are finished - do not use backticks>"
}
Do not give any additional commentary or content ourside of this JSON object.
"@

$conversationHistory = New-Object System.Collections.ArrayList

function resetConversationHistory() {
    $conversationHistory = New-Object System.Collections.ArrayList
}

function addToConversationHistory($role, $message) {
    $conversationHistory.Add(@{
        role = $role
        content = $message
    }) | Out-Null
}

function sendMessage($unsavedMessage = $null) {
    $messagesToSend = @(
            @{
                role = "system"
                content = $initialSystemPrompt
            }
            $conversationHistory
    )

    if ($unsavedMessage -ne $null) {
        $messagesToSend += $unsavedMessage
    }

    $json = @{
        model = "gpt-4"
        messages = $messagesToSend
    } | ConvertTo-Json -Compress

    $response = Invoke-RestMethod -Uri $endpoint -Method Post -Body $json -Headers $headers
    return $response.choices[0].message.content
}

function parseMessage($message) {
    try {
        $jsonObject = $message | ConvertFrom-Json
        Write-Host "Thoughts: " $jsonObject.thoughtProcess -ForegroundColor Yellow
        Write-Host "Action: " $jsonObject.actionDescription -ForegroundColor Blue
        Write-Host "Command: " $jsonObject.command
        return $jsonObject.command
    } catch {
        Write-Host "Error: Unable to parse JSON message " $message -ForegroundColor Red
        return "error"
    }
}


$continue = $true

function beginProcess($initialCommand) {
    resetConversationHistory
    addToConversationHistory "user" $initialCommand

    while ($continue) {
        $result = sendMessage
        addToConversationHistory "assistant" $result
        $command = parseMessage $result

        if ($command -eq "") {
            $continue = $false
        } else {
            $commandResult = Invoke-Expression $command 2>&1

            Write-Host "Result: " $commandResult -ForegroundColor White -BackgroundColor Black
            $commandResultSingleLine = $commandResult -replace "`r`n|`r|`n", " "
            addToConversationHistory "user" $commandResultSingleLine
        }
    }
}
