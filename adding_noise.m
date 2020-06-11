rs=[0.05,0.075,0.1];
files = ['balance', 'compound'];    % list of files name

for j = 1:length(files)
    file_name = files(j);
    for i = 1:length(rs)
        r = rs(i);
        file = strcat(file_name ,'_', num2str(r), '.txt');
        path = strcat('C:\pinTSVC_upd\Custom Dataset\', file);
        path1 = strcat('C:\pinTSVC_upd\Custom Dataset\', file_name, '.txt');
        data = load(path1);
        lol=data;
        [rows,columns]=size(lol);
        columns=columns-1;
        for i=1:rows
            for j=1:columns
                mu=0;
                sigma=abs(r*lol(i,j));
                noise = mvnrnd(mu,sigma,1);
                lol(i,j)= lol(i,j) + noise; 
            end
        end
        data=lol;
        save(path, 'data', '-ASCII','-append');

    end
end