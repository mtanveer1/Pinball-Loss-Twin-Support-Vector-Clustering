clc;
clear all;
close all;

path = './Dataset/';

file1 = fopen('results.txt','a+');
file2 = fopen('parameters.txt', 'a+');

fprintf(file1,'%s\n\n',date);

files = dir('./Dataset/*.txt');

for i =  1:length(files)
    filename = strcat(path, files(i).name)
    fprintf(file1, '\n%s\teps=%g\n\n', files(i).name)
    fprintf(file2, '\n%s\teps=%g\n\n', files(i).name)
    %%%%% Pin TWSVC
    [accuracy_pintsvc, time, min_c, min_mu, min_tau] = main_pintsvc(filename, files(i).name);
    fprintf(file1, 'pintsvc\tacc=%g\ttime=%g\n', accuracy_pintsvc,time)
    fprintf(file2, 'pintsvc\tc=%g\tmu=%g\ttau=%g\n', min_c, min_mu, min_tau)
end
