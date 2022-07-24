function test_tcp_ip_received(ip,port)

tcpipClient = tcpip(ip, port,'Timeout',30);
set(tcpipClient,'InputBufferSize',300);
set(tcpipClient,'Timeout',1); %Waiting time in seconds to complete read and write operations
fopen(tcpipClient);
get(tcpipClient, 'BytesAvailable');
%%
DataReceived =[];

%rawData = fread(tcpipClient,300000/8,'double');
rawData = fread(tcpipClient,300/8,'double');
DataReceived = [DataReceived rawData];
fprintf('Succecfully recevied: \n %s\n\n ',char(DataReceived));
end