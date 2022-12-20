--[[ SPEECH OPERATED IVR START --]]

session:answer(); -- Answer the call
session:execute("playback", "silence_stream://1500");
session:execute("playback", "ivr/welcome_to_ivr.wav");
session:setVariable("curl_timeout", "7")
session:execute("bind_digit_action", "myrealm,1,exec[H]:execute_extension,2006 XML default,both,self"); --support
session:execute("bind_digit_action", "myrealm,2,exec[H]:execute_extension,2024 XML default,both,self"); --billing
session:execute("bind_digit_action", "myrealm,3,exec[H]:execute_extension,2026 XML default,both,self"); --sales
session:execute("bind_digit_action", "myrealm,4,exec[H]:execute_extension,2027 XML default,both,self"); --marketing
-------------------------------------------------------------------------------------------------

local destination_number = session:getVariable("destination_number");
local caller_id_number   = session:getVariable("caller_id_number");
local dialed_extension   = session:getVariable("dialed_extension");
local recordings_dir     = session:getVariable("recordings_dir");
local filename           = 'rec_' .. destination_number .. caller_id_number .. '.wav';
local priapi             = "http://192.168.1.77:3001/?filename=";
local secapi             = "http://192.168.1.77:5001/?filename=";
local maxiterator        = 2;
local minfilesize        = 15000;

-------------------------------------------------------------------------------------------------

-- NODE METHODS

function exerequest()

        local url = priapi .. filename;

        freeswitch.consoleLog("Info", " executing the Voice to text convertion  " .. url .." \n");
        session:execute("curl", url);
        local curl_response = session:getVariable("curl_response_data");
        if(curl_response ~= nil)then
                return curl_response;
        end

       -- url = secapi .. filename;

       -- freeswitch.consoleLog("Info", " executing the secondory Voice to text convertion  " .. url .." \n");
       -- session:execute("curl", url);

       -- return session:getVariable("curl_response_data");
end
------------------------------------------------------------------------------------------------

-- User voice input capture methods start

function getfilesize(l_filename)
        local file = assert(io.open(l_filename, "r"));
        local size  = file:seek("end");
        io.close(file)
        return size;
end

function recorduservoiceinput()

        session:execute("set", "RECORD_APPEND=true");
        local l_filename = recordings_dir .. '/' .. filename;

        local speech_interupt_flag = session:getVariable("audio_interuption_flag");

        freeswitch.consoleLog("Info", " @@@@@@@@@@@@@@@@@@@@@@@@ speech_interupt_flag " .. speech_interupt_flag .. " \n");
        if(speech_interupt_flag == "true")then
                session:execute("record", l_filename .. " 5 100 1 ");
        else
                session:execute("record", l_filename .. " 5 100 3 ");
        end

        return getfilesize(l_filename);
end

-- User voice input capture methods end

------------------------------------------------------------------------------------------------
-- MAIN FUNCTIONALITY

function confirmoption(optype)

        local l_filename = recordings_dir .. '/' .. filename;
        for i = 0,maxiterator,1
        do

                --os.remove(l_filename);
                session:execute("set", "RECORD_APPEND=false");
                session:setVariable("audio_interuption_flag", "false");
                if(optype == "support")then
                        session:execute("playback", "ivr/support.wav")
                        --session:execute("playback", "ivr/yes_confirm_or_no_repeat.wav")
                        session:execute("play_detect_dtmf_speech","/home/wsadmin/wsmedia-server/share/freeswitch/sounds/en/us/callie/ivr/yes_confirm_or_no_repeat.wav 100 5 100000 200 " .. l_filename);
                elseif(optype == "billing")then
                        session:execute("playback", "ivr/billing.wav")
                        --session:execute("playback", "ivr/yes_confirm_or_no_repeat.wav")
                        session:execute("play_detect_dtmf_speech","/home/wsadmin/wsmedia-server/share/freeswitch/sounds/en/us/callie/ivr/yes_confirm_or_no_repeat.wav 100 5 100000 200 " .. l_filename);
                elseif(optype == "sales")then
                        session:execute("playback", "ivr/sales.wav")
                        --session:execute("playback", "ivr/yes_confirm_or_no_repeat.wav")
                        session:execute("play_detect_dtmf_speech","/home/wsadmin/wsmedia-server/share/freeswitch/sounds/en/us/callie/ivr/yes_confirm_or_no_repeat.wav 100 5 100000 200 " .. l_filename);
                elseif(optype == "marketing")then
                        session:execute("playback", "ivr/marketing.wav")
                        --session:execute("playback", "ivr/yes_confirm_or_no_repeat.wav")
                        session:execute("play_detect_dtmf_speech","/home/wsadmin/wsmedia-server/share/freeswitch/sounds/en/us/callie/ivr/yes_confirm_or_no_repeat.wav 100 5 100000 200 " .. l_filename);
                else
                        return nil;
                end

                local size = recorduservoiceinput();
                freeswitch.consoleLog("Info", " user requires " .. optype .. " confirm this  " .. size .." \n");
                if(size > minfilesize)then

                        local response = exerequest();
                        if(response ~= nil)then
                                if (string.find(response,"yes") or string.find(response, "right")) then
                                        return "yes";
                                else
                                        return response;
                                end

                        end

                end

                if((i < maxiterator and size <= minfilesize) or (i < maxiterator and response == nil and size > minfilesize)) then
                        session:execute("playback", "ivr/no_input.wav")
                end

                if(i == maxiterator) then
                        break;
                end

        end

        return nil;
end

function mainivr()

        for i = 0,maxiterator,1
        do
                session:execute("playback", "silence_stream://500");
                --session:execute("playback","ivr/options_1_2_3_4.wav");
                local l_filename = recordings_dir .. '/' .. filename;
		--os.remove(l_filename);
                session:execute("set", "RECORD_APPEND=false");
                session:setVariable("audio_interuption_flag", "false");
                session:execute("play_detect_dtmf_speech","/home/wsadmin/wsmedia-server/share/freeswitch/sounds/en/us/callie/ivr/options_1_2_3_4.wav 100 5 100000 200 " .. l_filename);

                local size = recorduservoiceinput();
                freeswitch.consoleLog("Info", " user voice input is captured and its file size is  " .. size .." \n");

                if(size > minfilesize)then
                        local response = exerequest();
                        if(response ~= nil)then

                                if(string.find(response, "billing support") or string.find(response, "billing") or string.find(response, "2") or string.find(response, "two"))then
                                        ret = confirmoption("billing");
                                        if(ret == "yes")then
                                                session:execute("transfer", "2024 XML default")
                                                break;
                                        end

                                elseif(string.find(response, "sales support") or string.find(response, "sales") or string.find(response, "3") or string.find(response, "three"))then
                                        ret = confirmoption("sales");
                                        if(ret == "yes")then
                                                session:execute("transfer", "2026 XML default")
                                                break;
                                        end

                                elseif(string.find(response, "customer support") or string.find(response, "support") or string.find(response, "1") or string.find(response, "one"))then
                                        ret = confirmoption("support");
                                        if(ret == "yes")then
                                                session:execute("transfer", " 2006 XML default")
                                                break;
                                        end
                                
				elseif(string.find(response, "marketing") or string.find(response, "4") or string.find(response, "four") or string.find(response, "for") or string.find(response, "por"))then
                                        ret = confirmoption("marketing");
                                        if(ret == "yes")then
                                                session:execute("transfer", "2027 XML default")
                                                break;
                                        end


                                elseif(i < maxiterator)then
                                        session:execute("playback", "ivr/invalid_input.wav");
                                end

                        elseif(i < maxiterator and response == nil)then
                                session:execute("playback", "ivr/no_input.wav");
                        end

                end

                if(size <= minfilesize and i < maxiterator) then
                        session:execute("playback", "ivr/no_input.wav");
                end

                -- If the user did not provided any option route the call to default user
                if(i == maxiterator) then
                        session:execute("playback", "ivr/test-Please_hold_while_I_transfer_your_call.wav");
                        session:execute("playback", "silence_stream://1000");
                        session:execute("playback", "ivr/default.wav");
                        session:execute("playback", "silence_stream://5000");
                        session:execute("playback", "voicemail/vm-goodbye.wav")
                        session:hangup();
                end

        end
end

mainivr();
