%¥ ∆µø… ”ªØ
%filename = 'classqq100.txt';% '../..\result\classqq2.txt';
docpath='../data/docset1/';
num_docs=50;
for i=1:1:num_docs
filename =  [ docpath 'doc_' num2str(i) '.txt'];
dict_size = 25;
%class_all=load(filename);
 class_i=countwordfrequency(filename,dict_size);

    h=figure(i);
    imlayout(class_i,[sqrt(dict_size) sqrt(dict_size) 1 1],[min(class_i) max(class_i)],'y');
    set(h,'visible','off');
str=sprintf([docpath 'doc(%d)'],i);
saveas(h,str,'jpg');
end

% %imlayout(topics, [5 5 1 numclass],[min(topics(:)) max(topics(:))],'y');
% imlayout(freq,[sqrt(dict_size) sqrt(dict_size) 1 1],[min(freq(:)) max(freq(:))],'y');
