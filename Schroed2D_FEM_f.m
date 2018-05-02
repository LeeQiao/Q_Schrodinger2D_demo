function[E,psi]=Schroed2D_FEM_f(x,y,V0,Mass,n)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Constants %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h=6.62606896E-34;               %% Planck constant [J.s]
hbar=h/(2*pi);
e=1.602176487E-19;              %% electron charge [C]
me=9.10938188E-31;              %% electron mass [kg]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Nx=length(x);
Ny=length(y);

dx=x(2)-x(1);
dy=y(2)-y(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% Building of the operators %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%% Second derivative X %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DX2(Ny=5,Nx=4); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                  %
%  -2   0   0   0   0 | 1   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0  -2   0   0   0 | 0   1   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0   0  -2   0   0 | 0   0   1   0   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0   0   0  -2   0 | 0   0   0   1   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0   0   0   0  -2 | 0   0   0   0   1 | 0   0   0   0   0 | 0   0   0   0   0  %
%   -----------------------------------------------------------------------------  %
%   1   0   0   0   0 |-2   0   0   0   0 | 1   0   0   0   0 | 0   0   0   0   0  %
%   0   1   0   0   0 | 0  -2   0   0   0 | 0   1   0   0   0 | 0   0   0   0   0  %
%   0   0   1   0   0 | 0   0  -2   0   0 | 0   0   1   0   0 | 0   0   0   0   0  %
%   0   0   0   1   0 | 0   0   0  -2   0 | 0   0   0   1   0 | 0   0   0   0   0  %
%   0   0   0   0   1 | 0   0   0   0  -2 | 0   0   0   0   1 | 0   0   0   0   0  %
%   -----------------------------------------------------------------------------  %
%   0   0   0   0   0 | 1   0   0   0   0 |-2   0   0   0   0 | 1   0   0   0   0  %
%   0   0   0   0   0 | 0   1   0   0   0 | 0  -2   0   0   0 | 0   1   0   0   0  %
%   0   0   0   0   0 | 0   0   1   0   0 | 0   0  -2   0   0 | 0   0   1   0   0  %
%   0   0   0   0   0 | 0   0   0   1   0 | 0   0   0  -2   0 | 0   0   0   1   0  %
%   0   0   0   0   0 | 0   0   0   0   1 | 0   0   0   0  -2 | 0   0   0   0   1  %
%   -----------------------------------------------------------------------------  %
%   0   0   0   0   0 | 0   0   0   0   0 | 1   0   0   0   0 |-2   0   0   0   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   1   0   0   0 | 0  -2   0   0   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   0   1   0   0 | 0   0  -2   0   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   1   0 | 0   0   0  -2   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   1 | 0   0   0   0  -2  %
%                                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Axy = ones(1,(Nx-1)*Ny);
DX2 = (-2)*diag(ones(1,Ny*Nx)) + (1)*diag(Axy,-Ny) + (1)*diag(Axy,Ny);

%%%%%%%%%%%%%%%%%%%%%%%%%%% Second derivative Y %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DY2(Ny=5,Nx=4); %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                  %
%  -2   1   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   1  -2   1   0   0 | 0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0   1  -2   1   0 | 0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0   0   1  -2   1 | 0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0   0   0   1  -2 | 0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   -----------------------------------------------------------------------------  %
%   0   0   0   0   0 |-2   1   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0   0   0   0   0 | 1  -2   1   0   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0   0   0   0   0 | 0   1  -2   1   0 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0   0   0   0   0 | 0   0   1  -2   1 | 0   0   0   0   0 | 0   0   0   0   0  %
%   0   0   0   0   0 | 0   0   0   1  -2 | 0   0   0   0   0 | 0   0   0   0   0  %
%   -----------------------------------------------------------------------------  %
%   0   0   0   0   0 | 0   0   0   0   0 |-2   1   0   0   0 | 0   0   0   0   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 1  -2   1   0   0 | 0   0   0   0   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   1  -2   1   0 | 0   0   0   0   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   0   1  -2   1 | 0   0   0   0   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   1  -2 | 0   0   0   0   0  %
%   -----------------------------------------------------------------------------  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0 |-2   1   0   0   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0 | 1  -2   1   0   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0 | 0   1  -2   1   0  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0 | 0   0   1  -2   1  %
%   0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   0   0 | 0   0   0   1  -2  %
%                                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AA=ones(1,Nx*Ny);
BB=ones(1,Nx*Ny-1);
BB(Ny:Ny:end)=0;

DY2=(-2)*diag(AA) + (1)*diag(BB,-1) + (1)*diag(BB,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% Building of the Hamiltonien %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H=(-hbar^2/(2*me*Mass)) * ( DX2/dx^2 + DY2/dy^2 ) +  diag(V0(:)*e) ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Diagonalisation of the Hamiltonien %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

H=sparse(H);
[PSI,Energy] = eigs(H,n,'SM');
E = diag(Energy)/e;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%% Normalization of the Wavefunctions %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:n
    psi_temp=reshape(PSI(:,i),Ny,Nx);
    psi(:,:,i) = psi_temp / sqrt( trapz( y' , trapz(x,abs(psi_temp).^2 ,2) , 1 )  );  % normalisation of the wave function psi
end

psi=psi(:,:,end:-1:1);
E=E(end:-1:1);

end
