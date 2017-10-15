%get back ground in this file
close all;
clear all;
clc 
%%
%average
image=dir('./*.jpg')
n=5000
SUM=[];%single(imread(image(1).name));
for i=2:10:n
SUM=cat(4,SUM, imread(image(i).name));
end
background=uint8(mean(SUM,4));

%%
%imshow(uint8(background),[]);
% h=imshow(background)
% saveas(h,'0000000.jpg','jpg')
imwrite(background,'000000.jpg');
%%
close all
clear all
clc
image=dir('./*.jpg');
%mkdir('./imageList.txt');
fid=fopen('./imageList.txt','w');
for i=1:1:length(image)
    fprintf(fid,'%s',image(i).name);
    fprintf(fid,'\n');
end
fclose(fid);