# GPT-Agent
This PowerShell script allows you to interact with OpenAI's GPT-4 model through the ChatGPT API as an agent that can execute a series of PowerShell commands based on the given instructions. The agent can also browse the internet by making HTTP requests.

**⚠️ Use this at your own risk - it is going to execute random PowerShell commands on your machine**

## Requirements
You will need an OpenAI API key to use this script.
PowerShell should be installed on your machine.
## How to Use
Clone this repository or copy the code above into a new PowerShell script file (e.g. GPT4Agent.ps1).
Replace <insert your api key here> with your OpenAI API key.
Open a PowerShell terminal and navigate to the directory containing the script.
Execute the script using the following command: .\GPT4Agent.ps1
Call the beginProcess() function with your initial command as a parameter.
### Example:

```
beginProcess "Create a node.js app that will return the reverse of a provided input in a GET request"
```

The agent will then provide a thought process, action description, and command to be executed. It will continue executing commands until it reaches a conclusion or until you stop the script.

![Screenshot 2023-04-05 142018](https://user-images.githubusercontent.com/13717390/230002007-c28f065a-792d-4f00-8d22-388d76033783.png)
  
**Figure: Running a series of commands to create a node.js app**

![Screenshot 2023-04-05 135216](https://user-images.githubusercontent.com/13717390/230002081-a80b35c6-e461-4e02-9dcf-aee26fe0e9cf.png)
  
**Figure: And...it works!**
