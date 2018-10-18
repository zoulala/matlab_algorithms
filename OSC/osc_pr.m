function [ X ] = osc_pr( x,pr,wr )
%P_OSC_PR Summary of this function goes here
%   Detailed explanation goes here
m=size(pr,2);
for i=1:m
    t(:,i)=x*wr(:,i);
    x=x-t(:,i)*pr(:,i)';
end
X=x;
end

