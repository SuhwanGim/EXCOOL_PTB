%%
%%
camList = webcamlist;
% Connect to the webcam.
cam = webcam(1);
%%
ipad ='0.0.0.0';
%% SEVRVER
data = snapshot(cam);
%
data =100;
data=im2double(data);
s = whos('data');
s.size;
s.bytes;
tcpipServer = tcpip(ipad, 30000, 'NetworkRole', 'Server');
set(tcpipServer, 'OutputBufferSize', s.bytes);
fopen(tcpipServer);
fwrite(tcpipServer, data(:), 'double');
fclose(tcpipServer)

%% Client
tcpipClient = tcpip(ipad, 30000);
set(tcpipClient,'InputBufferSize',300000);
set(tcpipClient,'Timeout',5); %Waiting time in seconds to complete read and write operations
fopen(tcpipClient);
get(tcpipClient, 'BytesAvailable');
tcpipClient.BytesAvailable
DataReceived =[];
pause(0.1);
while (get(tcpipClient, 'BytesAvailable') > 0)
    tcpipClient.BytesAvailable
    rawData = fread(tcpipClient,300000/8,'double');
    DataReceived = [DataReceived; rawData];
    pause(0.1)
end
fclose(tcpipClient);
delete(tcpipClient);
clear tcpipClient
% ploting
reshapedData = reshape(DataReceived,650,600,3);
imshow(reshapedData)

%%
typecast(img2,'unit8') % ??????