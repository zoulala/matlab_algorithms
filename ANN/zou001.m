
clc;clear;close;
P = [0 1 2 3 4 5 6 7 8 9 11];
 T = [0 1 2 3 4 3 2 1 2 3 4];
  net = newff([0 11],[5 3 1],{'tansig' 'tansig' 'purelin'});
  
  
   Y = sim(net,P);
  plot(P,T,P,Y,'o')
%
%    Here the network is trained for 50 epochs.  Again the network's
%     output is plotted.
%
net.trainParam.epochs = 50;
 net = train(net,P,T);
 Y = sim(net,P);
 plot(P,T,P,Y,'o')