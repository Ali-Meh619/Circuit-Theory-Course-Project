%%Q.1
syms s
Z(s) = [0 s 0 1/(3*s);s 0 1/(2*s) 4;0 1/(2*s) 0 5*s];
C=NF(Z);


%%
%Q.2
syms t
L(t)=["R1","RES",2,0,1,4,"0",0,0;
    "C1","CAP",2,0,1,2,"0",0,0;
    "IS1","CS",sin(t),0,1,4,"0",0,0;
    "VC1","VSCV",2,0,1,3,"R3",2,3;
    "R2","RES",2,0,2,4,"0",0,0;
    "R3","RES",2,0,2,3,"0",0,0;
    "R4","RES",2,0,3,4,"0",0,0;
    "CC1","CSCV",2,0,3,4,"C1",1,2];


M=HAL(L);


%%
%FUNCTIONS
function M=NF(A)
syms s
%A(s) = [0 1 0 1/s;1 0 1 1/s;0 1 0 1/s)];
p=size(A(s));
n=p(2);
A=A(s);
y(s)=s*zeros(n)-s*zeros(n);
y=y(s);
for i= 1:n-1
    for j= 1:n-1
              if(i~=j&&A(i,j)==0)
                y(i,j)=0;
          
              elseif(i~=j&&A(i,j)~=0)
                y(i,j)=-(A(i,j)^-1);
              end 
        for k= 1:n
            if(i==j&&A(i,k)~=0)
                l=y(i,j)+A(i,k)^-1;
                y(i,j)=l;
              end
            end
        end
end    
y(n,:)=[];%removing last row
y(:,n)=[];%removing last column
p=det(y);
M=double(solve(p,s));
M(M==0)=[];%zeros are not accepted
%
end



function U=HAL(T)
syms s t
T=T(t);
x=double(max(T(:,6)));
z=double(max(T(:,5)));
if(x>z)
    n=x             
else                %bozorgtarin gere ra zamin mikonim
    n=z
end 

p=size(T);
O=p(1);      %tedad satr
P=p(2);      %tedad sotton
q=0;         %tedad jarian hayi ke bayad ezafe shavad
w=0;
 B=s*zeros(O,P)- s*zeros(O,P);  %matrix baraye CSCC
       V=s*zeros(1,P)-s*zeros(1,P);
        F=s*zeros(O,P)- s*zeros(O,P); %MATRIX baraye VSCC
       R=s*zeros(1,P)-s*zeros(1,P);
       
       c=0;%tedad CSCC
       d=0;%tedad VSCC
for k=1:O
    if(T(k,2)=="CSCC")
       c=c+1; 
    end
    if(T(k,2)=="VSCC")
       d=d+1; 
    end
end
for k=1:O
   J=T;
   if((J(k,2)=="RES" || J(k,2)=="IND" || J(k,2)=="CAP")&&(J(k,5)>J(k,6)) )
       f=J(k,5);
       J(k,5)=J(k,6);       %agar gere sare mosbat az manfi bozorgtar
       J(k,6)=f;            %bood,jay anhara avaz mikonim va meghdar avalie ra gharine
       J(k,4)=-J(k,4);
   end
   if((J(k,2)=="VS" || J(k,2)=="CS")&&(J(k,5)>J(k,6)) )
       f=J(k,5);
       J(k,5)=J(k,6);       %agar gere sare mosbat az manfi bozorgtar
       J(k,6)=f;            %bood,jaye gere ha avaz va meghdar gharine
       J(k,3)=-J(k,3);
   end
if((J(k,2)=="VSCC" || J(k,2)=="CSCC" || J(k,2)=="VSCV" || J(k,2)=="CSCV")&&(J(k,8)>J(k,9)))
       f=J(k,8);
       J(k,8)=J(k,9);
       J(k,9)=f;                         %manand bala
       J(k,3)=-J(k,3);
       
end
T=J;
end
    for k=1:O
    if(T(k,2)=="CSCC")
       B=T;
 V(1,1)="VS0"; V(1,2)="VS"; V(1,3)=0; V(1,4)=0; V(1,5)=T(k,8); V(1,6)=T(k,8)+1; V(1,7)="0"; V(1,8)=0; V(1,9)=0;
 %manba voltage 0 ra ezafe mikonim
 
 for j=[5,6,8,9]
 for i=1:O
     
     if(((B(i,j)>= V(1,6))&&(i~=k || j~=9))||(B(i,1)==T(k,7) && B(i,5)==T(k,8) && B(i,6)==T(k,9)))
       
         B(i,j)=B(i,j)+1;
     end
 end
    
   
 end
 
 Q=vertcat(B,V);
 x=double(max(Q(:,6)));
z=double(max(Q(:,5)));
if(x>z)
    m=x
else            %tayin gere zamin jadid
    m=z
end 

q=q+1;    %jarian ezafe shode
T=Q;
    end
        end
    
   if(c>=1)
        
    A=Q;
    n=m;
    L=size(A);
    r=L(1);
    
        
        if(r>O)
        A(O+1:r, :)=[]; %manba voltage 0 ra hazf mikonim
        
        end
  
    g=size(A);
    O=g(1);
   
   
    
   
    else
        A=T;
    end
   
    
     for k=1:O
    if(A(k,2)=="VSCC")
       F=A;
 R(1,1)="VS0"; R(1,2)="VS"; R(1,3)=0; R(1,4)=0; R(1,5)=T(k,8); R(1,6)=T(k,8)+1; R(1,7)="0"; R(1,8)=0; R(1,9)=0;
 
 
 for j=[5,6,8,9]
 for i=1:O
     
     if(((F(i,j)>= R(1,6))&&(i~=k || j~=9))||(F(i,1)==A(k,7) && F(i,5)==A(k,8) && F(i,6)==A(k,9)))
        
         F(i,j)=F(i,j)+1;
     end
 end
    
   
 end
 
 G=vertcat(F,R);
 x=double(max(G(:,6)));
z=double(max(G(:,5)));
if(x>z)
    t=x
else            %gere zamin jadid
    t=z
end 
q=q+2; %jarian ezafe shode
A=G;
    end
    end
    
    if(d>=1)
        
    A=G;
    n=t;
    L=size(A);
    r=L(1);
    
        
        if(r>O)
        A(O+1:r, :)=[];
        
        end
  
    g=size(A);
    O=g(1);
   
   
    end
   
      
    
    for k=1:O
    if(A(k,2)=="IND")
        q=q+1;
        end
        
     if(A(k,2)=="VS")
         q=q+1;
        end
        
           if(A(k,2)=="VSCV") 
               q=q+1;
         
    end
    end

u(s)=s*zeros(q,n-1+q)-s*zeros(q,n-1+q); %matrix mojaver satri matrix admitance avalie
u=u(s);
h(s)=s*zeros(n-1,q)-s*zeros(n-1,q);%matrix mojaver sotooni matrix admitance avalie 
h=h(s);
y(s)=s*zeros(n-1)-s*zeros(n-1);%matrix admitance avalie
y=y(s);
I(s)=s*zeros(n-1+q,1)-s*zeros(n-1+q,1);%matrix manabe
I=I(s);
D(s)=s*zeros(n-1+q,1)-s*zeros(n-1+q,1);%moshakhas shodan asamie majhoolat
D=D(s);
w=n-1;

for i=1:n-1%%first admitance matrix
  for k=1:O 
       D(i,1)=i;
    if(A(k,2)=="CSCV")
        if(A(k,5)==i && A(k,5)~=n)
     if(A(k,8)~=n && A(k,9)~=n)
       y(i,A(k,8))=y(i,A(k,8))+A(k,3);
       y(i,A(k,9))=y(i,A(k,9))-A(k,3);
       D(i,1)=i;
     elseif(A(k,8)==n && A(k,9)~=n)
      
       y(i,A(k,9))=y(i,A(k,9))-A(k,3);
     elseif(A(k,8)~=n && A(k,9)==n)
       y(i,A(k,8))=y(i,A(k,8))+A(k,3)
       
        
        
     end
        end
                if(A(k,6)==i && A(k,6)~=n)
     if(A(k,8)~=n && A(k,9)~=n)
       y(i,A(k,8))=y(i,A(k,8))+A(k,3);
       y(i,A(k,9))=y(i,A(k,9))-A(k,3);
     elseif(A(k,8)==n && A(k,9)~=n)
      
       y(i,A(k,9))=y(i,A(k,9))-A(k,3);
     elseif(A(k,8)~=n && A(k,9)==n)
       y(i,A(k,8))=y(i,A(k,8))+A(k,3)
       
        
        
     end
        end
        
    end
   if(A(k,2)=="RES")
        if(A(k,5)==i && A(k,5)~=n)
     if(A(k,6)~=n)
       y(i,A(k,5))=y(i,A(k,5))+A(k,3)^-1;
       y(i,A(k,6))=y(i,A(k,6))-A(k,3)^-1;
     elseif(A(k,6)==n)
      
       y(i,A(k,5))=y(i,A(k,5))+A(k,3)^-1;  
            
     end
        end
                if(A(k,6)==i && A(k,6)~=n)
     if(A(k,5)~=n)
       y(i,A(k,6))=y(i,A(k,6))+A(k,3)^-1;
       y(i,A(k,5))=y(i,A(k,5))-A(k,3)^-1;
     elseif(A(k,5)==n)
      
       y(i,A(k,6))=y(i,A(k,6))+A(k,3)^-1;
       
     end
        end
        
    end
   if(A(k,2)=="CAP")
        if(A(k,5)==i && A(k,5)~=n)
     if(A(k,6)~=n)
       y(i,A(k,5))=y(i,A(k,5))+s*A(k,3);
       y(i,A(k,6))=y(i,A(k,6))-s*A(k,3);
       I(i,1)=I(i,1)+A(k,3)*A(k,4)
     elseif(A(k,6)==n)
      
       y(i,A(k,5))=y(i,A(k,5))+s*A(k,3);  
        I(i,1)=I(i,1)+A(k,3)*A(k,4)    
     end
        end
                if(A(k,6)==i && A(k,6)~=n)
     if(A(k,5)~=n)
       y(i,A(k,6))=y(i,A(k,6))+s*A(k,3);
       y(i,A(k,5))=y(i,A(k,5))-s*A(k,3);
       I(i,1)=I(i,1)-A(k,3)*A(k,4)
     elseif(A(k,5)==n)
      
       y(i,A(k,6))=y(i,A(k,6))+s*A(k,3);
       I(i,1)=I(i,1)-A(k,3)*A(k,4)
     end
        end
        
    end
    if(A(k,2)=="CS")
        if(A(k,5)==i && A(k,5)~=n)
    
       I(i,1)=I(i,1)+laplace(A(k,3));    
     
        end
                if(A(k,6)==i && A(k,6)~=n)
     I(i,1)=I(i,1)-laplace(A(k,3));  
        end
        
    end
  end
  end

i=1;
      for k=1:O
          
          if(A(k,2)=="IND" && A(k,6)~=n && A(k,5)==n) 
           D(i+n-1,1)=A(k,1);
          u(i,A(k,6))=u(i,A(k,6))-1;
          
          h(A(k,6),i)=h(A(k,6),i)-1;
         
          u(i,w+i)=-s*A(k,3);
          I(n-1+i,1)=-A(k,3)*A(k,4);
          i=i+1
      
    elseif(A(k,2)=="IND" && A(k,6)==n && A(k,5)~=n) 
       
         D(i+n-1,1)=A(k,1);
          u(i,A(k,5))=u(i,A(k,5))+1;
          
          h(A(k,5),i)=h(A(k,5),i)+1;
          u(i,w+i)=-s*A(k,3);
          I(n-1+i,1)=-A(k,3)*A(k,4);
          i=i+1
       
    end
        if(A(k,2)=="IND" && A(k,6)~=n && A(k,5)~=n)
          D(i+n-1,1)=A(k,1);
          u(i,A(k,6))=u(i,A(k,6))-1;
          u(i,A(k,5))=u(i,A(k,5))+1;
          h(A(k,6),i)=h(A(k,6),i)-1;
          h(A(k,5),i)=h(A(k,5),i)+1;
          u(i,w+i)=-s*A(k,3);
          I(n-1+i,1)=-A(k,3)*A(k,4);
          i=i+1
          
        end
          
       
     if(A(k,2)=="VS" && A(k,6)~=n && A(k,5)==n) 
         u(i,A(k,6))=u(i,A(k,6))-1;
          D(i+n-1,1)=A(k,1);
          h(A(k,6),i)=h(A(k,6),i)-1;
          
          I(n-1+i,1)=I(n-1+i,1)+laplace(A(k,3));
          i=i+1;
                            
       
    elseif(A(k,2)=="VS" && A(k,6)==n && A(k,5)~=n) 
         
          u(i,A(k,5))=u(i,A(k,5))+1;
         D(i+n-1,1)=A(k,1);
          h(A(k,5),i)=h(A(k,5),i)+1;
          I(n-1+i,1)=I(n-1+i,1)+laplace(A(k,3));
          i=i+1;
                            
       
    end
        if(A(k,2)=="VS" && A(k,6)~=n && A(k,5)~=n)
            u(i,A(k,6))=u(i,A(k,6))-1;
          u(i,A(k,5))=u(i,A(k,5))+1;
          h(A(k,6),i)=h(A(k,6),i)-1;
          h(A(k,5),i)=h(A(k,5),i)+1;
          I(n-1+i,1)=I(n-1+i,1)+laplace(A(k,3));
           D(i+n-1,1)=A(k,1);
          i=i+1;
          
                           
          
        end
           
                  if(A(k,2)=="VSCV" && A(k,6)~=n && A(k,5)~=n && A(k,8)~=n && A(k,9)~=n) 
          u(i,A(k,6))= u(i,A(k,6))-1;
          u(i,A(k,5))= u(i,A(k,5))+1;
          h(A(k,6),i)= h(A(k,6),i)-1;
          h(A(k,5),i)= h(A(k,5),i)+1;
          u(i,A(k,8))= u(i,A(k,8))-A(k,3);
          u(i,A(k,9))= u(i,A(k,9))+A(k,3);
          D(i+n-1,1)=A(k,1);
          i=i+1;
          
    end
        if(A(k,2)=="VSCV")
            
        if(A(k,6)==n && A(k,5)~=n && A(k,8)~=n && A(k,9)~=n)
                    
          u(i,A(k,5))= u(i,A(k,5))+1;
          D(i+n-1,1)=A(k,1);
          h(A(k,5),i)= h(A(k,5),i)+1;
          u(i,A(k,8))= u(i,A(k,8))-A(k,3);
          u(i,A(k,9))= u(i,A(k,9))+A(k,3);
          i=i+1;
        elseif(A(k,6)~=n && A(k,5)==n && A(k,8)~=n && A(k,9)~=n)
            u(i,A(k,6))= u(i,A(k,6))-1;
          
          h(A(k,6),i)= h(A(k,6),i)-1;
        D(i+n-1,1)=A(k,1);
          u(i,A(k,8))= u(i,A(k,8))-A(k,3);
          u(i,A(k,9))= u(i,A(k,9))+A(k,3);
          i=i+1;
               
        elseif(A(k,6)~=n && A(k,5)~=n && A(k,8)==n && A(k,9)~=n)
            u(i,A(k,6))= u(i,A(k,6))-1;
          u(i,A(k,5))= u(i,A(k,5))+1;
          h(A(k,6),i)= h(A(k,6),i)-1;
          h(A(k,5),i)= h(A(k,5),i)+1;
          D(i+n-1,1)=A(k,1);
          u(i,A(k,9))= u(i,A(k,9))+A(k,3);
          i=i+1;  
        elseif(A(k,6)~=n && A(k,5)~=n && A(k,8)~=n && A(k,9)==n)
           u(i,A(k,6))= u(i,A(k,6))-1;
          u(i,A(k,5))= u(i,A(k,5))+1;
          h(A(k,6),i)= h(A(k,6),i)-1;
          h(A(k,5),i)= h(A(k,5),i)+1;
          u(i,A(k,8))= u(i,A(k,8))-A(k,3);
        D(i+n-1,1)=A(k,1);
          i=i+1;
           
           
        end
      
        end
    
        if(A(k,2)=="VSCV")
            
        if(A(k,6)==n && A(k,5)~=n && A(k,8)==n && A(k,9)~=n)
           D(i+n-1,1)=A(k,1);
          
          u(i,A(k,5))= u(i,A(k,5))+1;
          
          h(A(k,5),i)= h(A(k,5),i)+1;
         
          u(i,A(k,9))= u(i,A(k,9))+A(k,3);
          i=i+1;   
           
        elseif(A(k,6)==n && A(k,5)~=n && A(k,8)~=n && A(k,9)==n)
           
          D(i+n-1,1)=A(k,1);
          u(i,A(k,5))= u(i,A(k,5))+1;
          
          h(A(k,5),i)= h(A(k,5),i)+1;
          u(i,A(k,8))= u(i,A(k,8))-A(k,3);
         
          i=i+1; 
           
        elseif(A(k,6)~=n && A(k,5)==n && A(k,8)==n && A(k,9)~=n)
            u(i,A(k,6))= u(i,A(k,6))-1;
          D(i+n-1,1)=A(k,1);
          h(A(k,6),i)= h(A(k,6),i)-1;
         
        
          u(i,A(k,9))= u(i,A(k,9))+A(k,3);
          i=i+1;
           
        elseif(A(k,6)~=n && A(k,5)==n && A(k,8)~=n && A(k,9)==n)
          u(i,A(k,6))= u(i,A(k,6))-1;
          D(i+n-1,1)=A(k,1);
          h(A(k,6),i)= h(A(k,6),i)-1;
          
          u(i,A(k,8))= u(i,A(k,8))-A(k,3);
          
          i=i+1;  
                    
        end
      
        end
      
    
                  if(A(k,2)=="CSCC" && A(k,6)~=n && A(k,5)~=n && A(k,8)~=n && A(k,9)~=n) 
          h(A(k,8),i)= h(A(k,8),i)+1;
          h(A(k,9),i)= h(A(k,9),i)-1;
          h(A(k,6),i)= h(A(k,6),i)+A(k,3);
          h(A(k,5),i)= h(A(k,5),i)-A(k,3);
          u(i,A(k,8))=u(i,A(k,8))+1;
          u(i,A(k,9))=u(i,A(k,9))-1;
          D(i+n-1,1)=A(k,1);
          i=i+1;
          
                  end
    
        if(A(k,2)=="CSCC")
            
        if(A(k,6)==n && A(k,5)~=n && A(k,8)~=n && A(k,9)~=n)
                   
           h(A(k,8),i)= h(A(k,8),i)+1;
          h(A(k,9),i)= h(A(k,9),i)-1;
          D(i+n-1,1)=A(k,1);
          h(A(k,5),i)= h(A(k,5),i)-A(k,3);
          u(i,A(k,8))=u(i,A(k,8))+1;
          u(i,A(k,9))=u(i,A(k,9))-1;
          i=i+1;
        elseif(A(k,6)~=n && A(k,5)==n && A(k,8)~=n && A(k,9)~=n)
             h(A(k,8),i)= h(A(k,8),i)+1;
          h(A(k,9),i)= h(A(k,9),i)-1;
          h(A(k,6),i)= h(A(k,6),i)+A(k,3);
        D(i+n-1,1)=A(k,1);
          u(i,A(k,8))=u(i,A(k,8))+1;
          u(i,A(k,9))=u(i,A(k,9))-1;
          i=i+1;
               
        elseif(A(k,6)~=n && A(k,5)~=n && A(k,8)==n && A(k,9)~=n)
         
          h(A(k,9),i)= h(A(k,9),i)-1;
          h(A(k,6),i)= h(A(k,6),i)+A(k,3);
          h(A(k,5),i)= h(A(k,5),i)-A(k,3);
        D(i+n-1,1)=A(k,1);
          u(i,A(k,9))=u(i,A(k,9))-1;
          i=i+1;
        elseif(A(k,6)~=n && A(k,5)~=n && A(k,8)~=n && A(k,9)==n)
             h(A(k,8),i)= h(A(k,8),i)+1;
        
          h(A(k,6),i)= h(A(k,6),i)+A(k,3);
          h(A(k,5),i)= h(A(k,5),i)-A(k,3);
          u(i,A(k,8))=u(i,A(k,8))+1;
          D(i+n-1,1)=A(k,1);
          i=i+1;
           
           
        end
      
        end
    
        if(A(k,2)=="CSCC")
            
        if(A(k,6)==n && A(k,5)~=n && A(k,8)==n && A(k,9)~=n)
           
          
     
          h(A(k,9),i)= h(A(k,9),i)-1;
         
          h(A(k,5),i)= h(A(k,5),i)-A(k,3);
       D(i+n-1,1)=A(k,1);
          u(i,A(k,9))=u(i,A(k,9))-1;
          i=i+1;
        elseif(A(k,6)==n && A(k,5)~=n && A(k,8)~=n && A(k,9)==n)
           
           
          h(A(k,8),i)= h(A(k,8),i)+1;
          
         
          h(A(k,5),i)= h(A(k,5),i)-A(k,3);
          u(i,A(k,8))=u(i,A(k,8))+1;
        D(i+n-1,1)=A(k,1);
          i=i+1;
           
        elseif(A(k,6)~=n && A(k,5)==n && A(k,8)==n && A(k,9)~=n)
          
          h(A(k,9),i)= h(A(k,9),i)-1;
          h(A(k,6),i)= h(A(k,6),i)+A(k,3);
         D(i+n-1,1)=A(k,1);
          u(i,A(k,9))=u(i,A(k,9))-1;
          i=i+1;
        elseif(A(k,6)~=n && A(k,5)==n && A(k,8)~=n && A(k,9)==n)
           h(A(k,8),i)= h(A(k,8),i)+1;
        
          h(A(k,6),i)= h(A(k,6),i)+A(k,3);
         
          u(i,A(k,8))=u(i,A(k,8))+1;
       D(i+n-1,1)=A(k,1);
          i=i+1;
                    
        end
      
        end
      
    
                  if(A(k,2)=="VSCC" && A(k,6)~=n && A(k,5)~=n && A(k,8)~=n && A(k,9)~=n) 
          h(A(k,8),i)= h(A(k,8),i)+1;
          h(A(k,9),i)= h(A(k,9),i)-1;
          u(i,A(k,8))=u(i,A(k,8))+1;
          u(i,A(k,9))=u(i,A(k,9))-1;
          
          i=i+1;
          D(i+n-1,1)=A(k,1);
          h(A(k,6),i)= h(A(k,6),i)-1;
          h(A(k,5),i)= h(A(k,5),i)+1;
          u(i,A(k,5))=u(i,A(k,5))+1;
          u(i,A(k,6))=u(i,A(k,6))-1;
          u(i,w+i)=u(i,w+i)-A(k,3);
          i=i+1;
                  end
    
        if(A(k,2)=="VSCC")
            
        if(A(k,6)==n && A(k,5)~=n && A(k,8)~=n && A(k,9)~=n)
                    
             h(A(k,8),i)= h(A(k,8),i)+1;
          h(A(k,9),i)= h(A(k,9),i)-1;
          u(i,A(k,8))=u(i,A(k,8))+1;
          u(i,A(k,9))=u(i,A(k,9))-1;
          i=i+1;
          D(i+n-1,1)=A(k,1);
          
          h(A(k,5),i)= h(A(k,5),i)+1;
          u(i,A(k,5))=u(i,A(k,5))+1;
          
          u(i,w+i)=u(i,w+i)-A(k,3);
          i=i+1;
        elseif(A(k,6)~=n && A(k,5)==n && A(k,8)~=n && A(k,9)~=n)
               h(A(k,8),i)= h(A(k,8),i)+1;
          h(A(k,9),i)= h(A(k,9),i)-1;
          u(i,A(k,8))=u(i,A(k,8))+1;
          u(i,A(k,9))=u(i,A(k,9))-1;
          i=i+1;
          D(i+n-1,1)=A(k,1);
          h(A(k,6),i)= h(A(k,6),i)-1;
          u(i,A(k,6))=u(i,A(k,6))-1;
          u(i,w+i)=u(i,w+i)-A(k,3);
          i=i+1;
            
        elseif(A(k,6)~=n && A(k,5)~=n && A(k,8)==n && A(k,9)~=n)
           
             
          h(A(k,9),i)= h(A(k,9),i)-1;
          
          u(i,A(k,9))=u(i,A(k,9))-1;
          i=i+1;
          D(i+n-1,1)=A(k,1);
          h(A(k,6),i)= h(A(k,6),i)-1;
          h(A(k,5),i)= h(A(k,5),i)+1;
          u(i,A(k,5))=u(i,A(k,5))+1;
          u(i,A(k,6))=u(i,A(k,6))-1;
          u(i,w+i)=u(i,w+i)-A(k,3);
          i=i+1;
        elseif(A(k,6)~=n && A(k,5)~=n && A(k,8)~=n && A(k,9)==n)
          h(A(k,8),i)= h(A(k,8),i)+1;
         
          u(i,A(k,8))=u(i,A(k,8))+1;
        
          i=i+1;
          D(i+n-1,1)=A(k,1);
          h(A(k,6),i)= h(A(k,6),i)-1;
          h(A(k,5),i)= h(A(k,5),i)+1;
          u(i,A(k,5))=u(i,A(k,5))+1;
          u(i,A(k,6))=u(i,A(k,6))-1;
          u(i,w+i)=u(i,w+i)-A(k,3);
          i=i+1;
           
           
        end
      
        end
    
        if(A(k,2)=="VSCC")
            
        if(A(k,6)==n && A(k,5)~=n && A(k,8)==n && A(k,9)~=n)
           
          
          h(A(k,9),i)= h(A(k,9),i)-1;
          
          u(i,A(k,9))=u(i,A(k,9))-1;
          i=i+1;
          D(i+n-1,1)=A(k,1);
          
          h(A(k,5),i)= h(A(k,5),i)+1;
          u(i,A(k,5))=u(i,A(k,5))+1;
      
          u(i,w+i)=u(i,w+i)-A(k,3);
          i=i+1;
        elseif(A(k,6)==n && A(k,5)~=n && A(k,8)~=n && A(k,9)==n)
           
       h(A(k,8),i)= h(A(k,8),i)+1;
         
          u(i,A(k,8))=u(i,A(k,8))+1;
          
          i=i+1;
          
          D(i+n-1,1)=A(k,1);
          h(A(k,5),i)= h(A(k,5),i)+1;
          u(i,A(k,5))=u(i,A(k,5))+1;
          
          u(i,w+i)=u(i,w+i)-A(k,3);
          i=i+1;
        elseif(A(k,6)~=n && A(k,5)==n && A(k,8)==n && A(k,9)~=n)
            
         
          h(A(k,9),i)= h(A(k,9),i)-1;
          
          u(i,A(k,9))=u(i,A(k,9))-1;
          i=i+1;
          D(i+n-1,1)=A(k,1);
          h(A(k,6),i)= h(A(k,6),i)-1;
        
          u(i,A(k,6))=u(i,A(k,6))-1;
          u(i,w+i)=u(i,w+i)-A(k,3);
          i=i+1;
        elseif(A(k,6)~=n && A(k,5)==n && A(k,8)~=n && A(k,9)==n)
             h(A(k,8),i)= h(A(k,8),i)+1;
       
          u(i,A(k,8))=u(i,A(k,8))+1;
          
          i=i+1;
          D(i+n-1,1)=A(k,1);
          h(A(k,6),i)= h(A(k,6),i)-1;
          
          u(i,A(k,6))=u(i,A(k,6))-1;
          u(i,w+i)=u(i,w+i)-A(k,3);
          i=i+1;
                    
        end
      
        end
      
    
end

y1=horzcat(y,h);
Y=vertcat(y1,u);
X=(Y^-1)*I;% be dast ovordan bordar majhool
v=ilaplace(X);
H=horzcat(v,D);
U=s*zeros(O,4)-s*zeros(O,4);%matrix javab nahayi
M=0;
N=0;
C=0;
P=0;
for k=1:O
    
    
     if(A(k,2)=="RES")
         for i=1:size(H,1)
             if(H(i,2)==A(k,5))
               M=H(i,1);
             end
             if(H(i,2)==A(k,6))
                 N=H(i,1);
             end
         
         end
             
         U(k,1)=A(k,1);%name
         U(k,2)=M-N;%voltage
         U(k,3)=U(k,2)/A(k,3);%current
         U(k,4)=U(k,3)*U(k,2);%power
        
             
     end
        
    
     if(A(k,2)=="CAP")
         for i=1:size(H,1)
             if(H(i,2)==A(k,5))
               M=H(i,1);
             end
             if(H(i,2)==A(k,6))
                 N=H(i,1);
             end
         
         end
             
         U(k,1)=A(k,1);
         U(k,2)=M-N;
         U(k,3)=A(k,3)*diff(U(k,2));
         U(k,4)=U(k,3)*U(k,2);
        
             
     end
       
    
     if(A(k,2)=="IND")
         for i=1:size(H,1)
             if(H(i,2)==A(k,5))
               M=H(i,1);
             end
             if(H(i,2)==A(k,6))
                 N=H(i,1);
             end
             
         
         if(H(i,2)==A(k,1))
             U(k,3)=H(i,1);
         end
         end   
         U(k,1)=A(k,1);
         U(k,2)=M-N;
         
         U(k,4)=U(k,3)*U(k,2);
        
             
     end
       
    
     if(A(k,2)=="CS")
         for i=1:size(H,1)
             if(H(i,2)==A(k,5))
               M=H(i,1);
             end
             if(H(i,2)==A(k,6))
                 N=H(i,1);
             end
         end
         
     
             
         U(k,1)=A(k,1);
         U(k,2)=N-M;
         U(k,3)=A(k,3);
         U(k,4)=U(k,3)*U(k,2);
     end  
             
      if(A(k,2)=="VS")
         for i=1:size(H,1)
             if(H(i,2)==A(k,5))
               M=H(i,1);
             end
             if(H(i,2)==A(k,6))
                 N=H(i,1);
             end
              if(H(i,2)==A(k,1))
             U(k,3)=H(i,1);
         end
             
         end
         
     
             
         U(k,1)=A(k,1);
         U(k,2)=M-N;
         
         U(k,4)=U(k,3)*U(k,2);
     end  
                    
     
        if(A(k,2)=="CSCV")
         for i=1:size(H,1)
             if(H(i,2)==A(k,5))
               M=H(i,1);
             end
             if(H(i,2)==A(k,6))
                 N=H(i,1);
             end
             
          if(H(i,2)==A(k,8))
               C=H(i,1);
          end
             if(H(i,2)==A(k,9))
                 P=H(i,1);
             end
             end
         
             
         U(k,1)=A(k,1);
         U(k,2)=N-M;
         U(k,3)=A(k,3)*(C-P);
         U(k,4)=U(k,3)*U(k,2);
        
             
     end
     if(A(k,2)=="VSCV")
         for i=1:size(H,1)
             if(H(i,2)==A(k,5))
               M=H(i,1);
             end
             if(H(i,2)==A(k,6))
                 N=H(i,1);
             end
             
          if(H(i,2)==A(k,8))
               C=H(i,1);
          end
             if(H(i,2)==A(k,9))
                 P=H(i,1);
             end
          
              if(H(i,2)==A(k,1))
             U(k,3)=H(i,1);
         end
         end
             
         U(k,1)=A(k,1);
         U(k,2)=M-N;
         
         U(k,4)=U(k,3)*U(k,2);
        
             
     end
     if(A(k,2)=="CSCC")
         for i=1:size(H,1)
             if(H(i,2)==A(k,5))
               M=H(i,1);
             end
             if(H(i,2)==A(k,6))
                 N=H(i,1);
             end
             
          if(H(i,2)==A(k,8))
               C=H(i,1);
          end
             if(H(i,2)==A(k,9))
                 P=H(i,1);
             end
          
              if(H(i,2)==A(k,1))
             U(k,3)=H(i,1);
              end
         end
             
         U(k,1)=A(k,1);
         U(k,2)=N-M;
         U(k,3)=A(k,3)*U(k,3);
         U(k,4)=U(k,3)*U(k,2);
        
             
     end
     
     if(A(k,2)=="VSCC")
         for i=1:size(H,1)
             if(H(i,2)==A(k,5))
               M=H(i,1);
             end
             if(H(i,2)==A(k,6))
                 N=H(i,1);
             end
             
         
              if(H(i,2)==A(k,1))
             U(k,3)=H(i,1);
              end
         end
             
         U(k,1)=A(k,1);
         U(k,2)=M-N;
         U(k,3)=U(k,3);
         U(k,4)=U(k,3)*U(k,2);
        
             
     end
     M=0;
     N=0;
     P=0;
     C=0;
     end
end

        
         
            
           
     
        
    




