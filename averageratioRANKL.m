function [blue, green, red] = averageratioRANKL(blueexpect, greenexpect, redexpect, blueob, greenob, redob)

blueexpectdata = importdata(blueexpect); %imports blue expecation
blueexpectzero = blueexpectdata == 0; %see's which index of the expectation is equal to 0
blueexpectdata(blueexpectzero) = []; %removes every zero in the blue image
blueexpectverage = mean(blueexpectdata); %gets the average of the blue

blueobdata = importdata(blueob); %imports blue observed
blueobzero = blueobdata == 0; %see's which index of the observed is equal to 0
blueobdata(blueobzero) = [];
blueobaverage = mean(blueobdata);

blue = blueobaverage / blueexpectverage;

greenexpectdata = importdata(greenexpect);
greenexpectzero = greenexpectdata == 0;
greenexpectdata(greenexpectzero) = []; 
greenexpectverage = mean(greenexpectdata); 

greenobdata = importdata(greenob);
greenobzero = greenobdata == 0;
greenobdata(greenobzero) = [];
greenobaverage = mean(greenobdata);

green = greenobaverage / greenexpectverage;

redexpectdata = importdata(redexpect);
redexpectzero = redexpectdata == 0;
redexpectdata(redexpectzero) = []; 
redexpectverage = mean(redexpectdata); 

redobdata = importdata(redob);
redobzero = redobdata == 0;
redobdata(redobzero) = [];
redobaverage = mean(redobdata);

red = redobaverage / redexpectverage;
end