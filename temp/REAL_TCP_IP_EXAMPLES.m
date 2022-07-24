
%%
ip = '192.168.0.3';   % SERVER PC's IP
port = 30000; % SERVER PC's Port

%% SERVER (fMRI stimulus comuputer) in fMRI_task
ip_server = '0.0.0.0';
trg_dat = 100;
trg_dat = im2double(trg_dat);
trg_dat = double('메롱');
s = whos('trg_data');
tcpipServer = tcpip(ip_server, 30000, 'NetworkRole','server');
set(tcpipServer, 'OutputBufferSize',s.bytes);
fopen(tcpipServer);
fwrite(tcpipServer, trg_dat(:), 'double'); % send data 
fclose(tcpipServer);
%% CLIENT (Estimating pain task) in out_task
clc;
tic;
tcpipClient = tcpip(ip, port);
set(tcpipClient,'InputBufferSize',300);
set(tcpipClient,'Timeout',1); %Waiting time in seconds to complete read and write operations
fopen(tcpipClient);
get(tcpipClient, 'BytesAvailable');
DataReceived =[];

%rawData = fread(tcpipClient,300000/8,'double');
rawData = fread(tcpipClient,300/8,'double');
DataReceived = [DataReceived rawData];
disp('received');
pause(0.1)

disp(DataReceived);
toc;

fclose(tcpipClient);
delete(tcpipClient);
clear tcpipClient
% ploting
