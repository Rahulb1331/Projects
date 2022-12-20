var express = require('express');
var app = express();
var PORT = 3001;
const speech = require('@google-cloud/speech');
const fs = require('fs');
const keyword_extractor = require("keyword-extractor");


const record_path = "/home/wsadmin/wsmedia-server/var/lib/freeswitch/recordings/"

var params=function(req){

        let result={};
        try {
                let q=req.url.split('?');
                // [ '/', 'filename=rec_2012_1003.wav' ]
                if(q.length>=2){
                        let p= q[1].split('&');
                        // [ '/', 'filename=rec_2012_1003.wav' ]
                        if(p.length > 0) {

                                p.forEach(element => {
                                        let lp= q[1].split('=');
                                        // [ 'filename', 'rec_2012_1003.wav' ]
                                        if(lp.length == 2) {
                                                result[lp[0]] = lp[1];
                                        }
                                });

                        }
                }
        }
        catch(e) {
                console.log("Exception " + e + " 1");
        }
        return result;
        // { filename: 'rec_2012_1003.wav' }
}

function sendresponse(res, code, data) {

        try {

                res.statusCode = code;
                res.send(data);
                //write a response to the client
                res.end();
                //end the response
        }
        catch(e) {
                console.log("Exception " + e + " 2");
        }
}

async function convert_speechto_text(qp, req, res) {

        try {

                // Setting the environment variable
                process.env.GOOGLE_APPLICATION_CREDENTIALS="/home/wsadmin/src/badreenadh-ccp/SPEECH_TOTEXT/rahul-ccp/speech-to-text3-09bd719b108f.json";

                //Instantiate a speech client
                const client = new speech.SpeechClient();
               	
		/*const sleep = (waitTimeInMs) => new Promise(resolve => setTimeout(resolve, waitTimeInMs));
		if(qp.filename == "rec_20231003.wav")
		{
			console.log("start")
			await sleep(10000); 
			console.log("end")
		}*/

		//provide path to the audio file that we want to transcribe
                const filename = record_path + qp.filename;

                //Then use file file system to read the local audio file and convert it to Base64 encoding
                const file = fs.readFileSync(filename);
                const audioBytes = file.toString('base64');

                //Create a document called audio with a field called content, set to that Base64 string of the audio
                const audio = {
                        content: audioBytes
                };

		const phraseSets = {
                        phraseSets: [
                                {
					name : 'projects/861925973159/locations/global/phraseSets/menu'
				}
                                ]
                        };
                //Configuration details of the audio file in an object called config.
                //Encoding, sampleRateHertz & languageCode are neccesary fields.
                //There are some optional field we can add if we want to.
                const config = {
                        encoding: 'LINEAR16',
                        sampleRateHertz: 8000,
                        languageCode: 'en-US',
			useEnhanced: true,
                        alternativeLanguageCodes: ['en-IN', 'en-US' ],
		/*	speechContexts: {
     				 phrases:['sales']
     			};*/
			adaptation: phraseSets
                };


                //Instantiate an object called request which is made up of the audio and config objects.
                //Then call recognise, passing the request object.
                //This returns a promise that resolves to contain the result at zero or more sequential speech recognition result messages.
                const request = {
                        audio: audio,
                        config: config
                };


                const [response] = await client.recognize(request);
                //To print out the transcription get the first alternative from each result, then join them in a single string.
                //Log that transcription. Run the main function and include a catch block to handle any errors.

                const transcription = response.results.map(result => result.alternatives[0].transcript).join('\n');
                console.log(`Transcription: ${transcription}`);

               	/*const extraction_result =
                keyword_extractor.extract(transcription,{
                                         	language:"english",
                                                remove_digits: true,
                                                return_changed_case:true,
                                                remove_duplicates: false
                                    	});

                console.log("Extracted keywords: " + extraction_result);
		let myStr = extraction_result.toString();
		const final_response = myStr.replace(/,/g,' ');
		console.log("Response sent: " + final_response + "\n")
		sendresponse(res, 200, final_response);
		*/
		sendresponse(res, 200, transcription);
                return;
        }
        catch(e) {
                console.log("Exception is " + e + " 3");
        }

        sendresponse(res, 400, 'Bad request');
        return;
}

app.get('/', (req, res) => {
        try {

                let qp = params(req);
                // { filename: 'rec_2012_1003.wav' }
                var count = Object.keys(qp).length;
                // Object.keys(qp) ----> ['filename']
                if(count == 0) {
                        sendresponse(res, 400, 'Bad request');
                        return;
                }

                convert_speechto_text(qp, req, res);

        }
        catch(e) {
                console.log("Exception is " + e + " 4");
        }
});


app.listen(PORT, function(err){
    if (err) console.log(err);
    console.log("Server listening on PORT", PORT);
});
