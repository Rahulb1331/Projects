# Projects
1) Speech recognition ivr, when the user calls the extension then an IVR dialplan is played, which accepts the speech (in the form of recording the user's speech input), as well as the digit (DTMF) input. This Ivr is made in Lua language, and this script sends the recording to the NodeJS script which invokes the Google Speech-to-text API, which converts the recorded input to text transcription. After this, the transcription is send back to the Lua script which extracts the keywords from this script and transfers the call to the extension corresponding to the input given. For example, if the user says "I need help with billing" or "billing support" then the customer will be transferred to the extension or number where their billing enquiry will be resolved. This project was done on FreeSWITCH media service, on this media service the dialplans as well as the numbers asscoiated with these dialplans are made, various protocols such as SIP (Session Initiated Protocol), transport protocols such as UDP (Userc Datagram Protocol) and TCP ( Transmission Contol Protocol) are followed by this media service. 
