function [sFilt1, sFilt3] = Filtrar(y,FC1,FC3,filter1,filter3) 
%% Filtra la señal 'y' aplicando los filtros de Octava y Tercio de Octava
    
    sFilt1 = cell(1,length(FC1));
    for i = 1:length(FC1)
        sFilt1{i} = filter(filter1{i},y);
    end
    sFilt3 = cell(1,length(FC3));
    for i = 1:length(FC3)
        sFilt3{i} = filter(filter3{i},y);
    end

    
end          