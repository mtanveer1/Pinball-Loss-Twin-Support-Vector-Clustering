function [accuracy, time, min_c, min_mu, min_tau] = main_pintsvc(filename, file)

max_trial =10;
no_part = 5.;
% parameters
cvs1=[2^-5, 2^-3, 2^-1, 2^1, 2^3, 2^5];
mus=[2^-5,2^-4,2^-3,2^-2,2^-1,2^0,2^1,2^2,2^3,2^4,2^5];
taus=[0.25, 0.50, 0.75, 1];

AA = zeros(6, 11, 4);

%Data file call from folder
A = load(filename);
[m,n] = size(A);
[no_input,no_col] = size(A);
Y = A(:,no_col);

%% initializing crossvalidation variables

[lengthA,n] = size(A);
min_err = -10^-10.;

for i = 1:length(cvs1)
    c = cvs1(i)
    for k = 1:length(taus)
        tau = taus(k)
        for j = 1:length(mus)
            mu = mus(j)
            avgerror = 0;
            time_2 = 0;
            block_size = lengthA/(no_part*1.0);
            part = 0;
            t_1 = 0;
            t_2 = 0;
            dd = 0;
            while ceil((part+1) * block_size) <= lengthA
                %% seprating testing and training datapoints for
                % crossvalidation
                dd = dd + 1;
                t_1 = ceil(part*block_size);
                t_2 = ceil((part+1)*block_size);
                B_t = [A(t_1+1 :t_2,:)];
                Data = [A(1:t_1,:); A(t_2+1:lengthA,:)];
                Data_Y=[Y(1:t_1);Y(t_2+1:lengthA)];

                %% testing and training
                [accuracy_with_zero,time_1] = pintsvc(Data,B_t,Data_Y,c,mu,tau);
                avgerror = avgerror + accuracy_with_zero;
                time_2 = time_2 + time_1;
                part = part+1;
            end            
            AA(i, j, k) = avgerror/dd;
        end
    end
end

min_acc = -10^-10.;

for i = 1:length(cvs1)
    c = cvs1(i);
    for k = 1:length(taus)
        tau = taus(k);
        for j = 1:length(mus)
            mu = mus(j);
            if AA(i, j ,k) > min_acc
                min_acc = AA(i, j ,k);
                min_mu = mu;
                min_c = c;
                min_tau = tau;
            end            
        end
    end
end

accuracy = 0;
time = 0;
block_size = lengthA/(no_part*1.0);
part = 0;
t_1 = 0;
t_2 = 0;
dd = 0;
while ceil((part+1) * block_size) <= lengthA
    %% seprating testing and training datapoints for
    % crossvalidation
    dd = dd + 1;
    t_1 = ceil(part*block_size);
    t_2 = ceil((part+1)*block_size);
    B_t = [A(t_1+1 :t_2,:)];
    Data = [A(1:t_1,:); A(t_2+1:lengthA,:)];
    Data_Y=[Y(1:t_1);Y(t_2+1:lengthA)];
    
    %% testing and training
    [accuracy_with_zero,time_1] = pintsvc(Data,B_t,Data_Y,min_c,min_mu,min_tau);
    accuracy = accuracy + accuracy_with_zero;
    time = time + time_1;
    part = part+1;
end

accuracy = accuracy/dd;
time = time/dd;
