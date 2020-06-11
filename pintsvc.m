function [acc,time,tot_ite,times]= pintsvc(C,test_data,Y,c,mu,tau) 
[no_input,no_col]=size(C);
Y_test=test_data(:,no_col);
Y1=Y_test;
[no_test]=size(Y_test,1);

X=C(:,1:no_col-1);
X_test=test_data(:,1:no_col-1);
tol=0.001;
eps=0.0000001;
M=X;      
K=zeros(no_input,no_input);
tic
for i=1:no_input
    for j=1:no_input
        nom = norm( X(i,:)  - M(j,:)  );
        K(i,j) = exp( -1/(2*mu*mu) * nom * nom );
    end
end
time_k=toc;
X=K;
num=max(Y);
totalu=zeros(1+size(X,2),num);
diff=1;
diff2=1;
prev=0;
prevY=0;
times=0;
time=0;
tot_ite=0;
 
while ((norm(diff)>0.1)&(norm(diff2)~=0)&times<=5)
    times=times+1;
    for i=1:num
        inputA=X(Y==i,:);
        inputB=X(Y~=i,:);
        if(isempty(inputA))
            continue;
        end
        if(isempty(inputB))
            continue;
        end

        u0=FirstStep(inputA);
        [m1,n]=size(inputA);
        m2=size(inputB,1);    
        ite=0;
        som=1;
        e1=ones(m1,1);
        e2=ones(m2,1);
        f = -[e2];
        tic
        while som>tol && ite<30
            ite=ite+1;
            u=u0;
            G=[inputB,e2];
            H=[inputA,e1]; 
            G=diag(sign(inputB*u(1:n,:)+u(n+1,1)))*G;
            kerH=G*((H'*H+eps*eye(n+1))\G');
            kerH=(kerH+kerH')/2;        
            gamma=quadprog(kerH,f,[],[],[],[],-c*e2,tau*c*e2,[],optimset('display','off'));
            u0=(H'*H+eps*eye(n+1))\(G'*gamma(1:m2));
            som=norm(u-u0);  
        end
        time=time+toc/ite;
        tot_ite=tot_ite+ite;
        totalu(:,i)=u0/norm(u0(1:size(u0,1)-1,:));
    end
    [d,pY]=min(abs([X,ones(size(X,1),1)]*totalu),[],2);
    Y=pY;
    diff=sum(d)-prev;
    prev=sum(d);
    diff2=pY-prevY;
    prevY=pY;
end
time=time/times+time_k;
%Testing
K=zeros(no_test,no_input);
   
for i=1:no_test
    for j=1:no_input
        nom = norm( X_test(i,:)  - M(j,:)  );
        K(i,j) = exp( -1/(2*mu*mu) * nom * nom );
    end
end

X_test=K;

[d,pY]=min(abs([X_test,ones(size(X_test,1),1)]*totalu),[],2);
MT=zeros(no_test);
for i=1:no_test
    for j=1:no_test
        if(Y1(i)==Y1(j))  
            MT(i,j)=1;
        end
    end
end

MP=zeros(no_test);
for i=1:no_test
    for j=1:no_test
        if(pY(i)==pY(j))  
            MP(i,j)=1;
        end
    end
end

n00=0;n11=0;cc=0;
for i=1:no_test
    for j=1:no_test
        if(MT(i,j)==MP(i,j))
            if(MT(i,j)==0)
                n00=n00+1;
            else
                n11=n11+1;
            end
        end       
    end
end

m=no_test;
acc=(n00+n11-m)/(m^2-m)*100;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Additional functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   

function u=FirstStep(A)
% compute: min ||Aw+be||, s.t. ||w||=1.
% u=[w;b]
m=size(A,1);
H=A'*(1/m*ones(m,m)-eye(m))*A;
[V,D]=eig(H);
[tmp,n]=min(abs(diag(D)));
w=V(:,n);
w = real(w);
b=-1/m*sum(A,1)*w;
u=[w;b];
end