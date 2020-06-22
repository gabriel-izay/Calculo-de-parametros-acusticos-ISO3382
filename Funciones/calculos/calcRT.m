function [T,nT,rT]=calcRT(x,fm)
%% Calcula el EDT,TR10, TR20 y TR30 de la señal
% Devuelve:
% T = {RT10 RT20 RT30 EDT}
% nT = {nT10 nT20 nT30 nEDT}  % se utilizan para la aproximacion 
% rT = {rT10 rT20 rT30 rEDT}  % por cuadrados minimos.
x=x';
    T = cell(4,1);
    nT = cell(4,1);
    rT = cell(4,1);
    n = 1/fm:1/fm:length(x)/fm;
    for i = 1:4   
        sup = find(x<=-5,1,'first');
        low = find(x<=(-i*10- 5),1,'first');
        if i == 4
            sup = find(x<=0,1,'first');
            low = find(x<=-10,1,'first');
        end
        nT{i,1} = n(sup:low);
        rT{i,1} = x(sup:low);
        [b,m] = cuadMin(nT{i},rT{i});
        rT{i,1} = m*n(sup:low)+b;
        T{i,1} = (-60-b)/m;
    end
end