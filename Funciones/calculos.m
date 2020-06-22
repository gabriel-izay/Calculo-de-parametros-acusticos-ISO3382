function calculos(handles)






%% Callbacks
    set(handles.seleccionararchivo,'callback',{@carga_imp,handles});
    set(handles.calcular,'callback',{@btncalcular,handles});
    set(handles.selectorFiltro,'callback',{@verdatos,handles});
    set(handles.graficar,'callback',{@verdatos,handles});
    set(handles.optionOctavas,'callback',{@cargarSelectorOctavas,handles});
    set(handles.optionTercios,'callback',{@cargarSelectorTercios,handles});

%% Carga IR(s)
    function carga_imp(~,~,handles)
        %try
            [filename, pathname] = uigetfile({'*.wav'},'Seleccione los archivos','Multiselect','on');
            pathfile = strcat(pathname,filename);
            if ischar(filename)
            [x,fmcell{1,1}] = audioread(pathfile);
            x={x};
            else
            [x,fmcell] = cellfun(@audioread,pathfile,'UniformOutput',0);      
            end
            fm=fmcell{1,1};
            nFiles=length(x);

            set(handles.calcular,'Enable','off');
            set(handles.graficar,'Enable','off');
            
            % Recorte incial de señal desde el maximo pico hasta Lundeby
            x = cellfun(@Cortar,x,fmcell,'UniformOutput',0);

            setappdata(handles.d,'fm',fm);
            setappdata(handles.d,'nFiles',nFiles);
            setappdata(handles.d,'fmcell',fmcell);
            setappdata(handles.d,'x',x);

            set(handles.calcular,'Enable','on');
            set(handles.selectorIR,'String',filename);
        %catch Me
          % disp('Error al cargar IR: ');
         %  disp(Me.identifier);
        %end
    end
%% Presiono el Boton Calcular
    function btncalcular(~,~,handles)
        %%Deshabilita los botones
        cla (handles.axx,'reset'); 
        set(handles.calcular,'String','Espere...');
        set(handles.calcular,'Enable','off');
        drawnow;
                
        %%Levanta data
        fm=getappdata(handles.d,'fm');
        nFiles=getappdata(handles.d,'nFiles');
        x=getappdata(handles.d,'x');
        FC1=getappdata(handles.d,'FC1');
        FC3=getappdata(handles.d,'FC3');
        filter144=getappdata(handles.d,'filter144');
        filter344=getappdata(handles.d,'filter344');
        filter148=getappdata(handles.d,'filter148');
        filter348=getappdata(handles.d,'filter348');
        filter196=getappdata(handles.d,'filter196');
        filter396=getappdata(handles.d,'filter396');
     
        %% Filtra todos los IRs en ocatava y tercios de octava, según SampleRate fm 
        sigFil1=cell(1,nFiles);
        sigFil3=cell(1,nFiles);
        switch fm
            case 44100
                for n=1:nFiles
                    [sigFil1{n},sigFil3{n}]=Filtrar(x{n},FC1,FC3,filter144,filter344);
                end
            case 48000
                for n=1:nFiles
                    [sigFil1{n},sigFil3{n}]=Filtrar(x{n},FC1,FC3,filter148,filter348);
                end
            case 96000
                for n=1:nFiles
                    [sigFil1{n},sigFil3{n}]=Filtrar(x{n},FC1,FC3,filter196,filter396);
                end
        end
                    
        % fm en cell para usar cellfun
        fmcell10={fm,fm,fm,fm,fm,fm,fm,fm,fm,fm};
        fmcell30={fm,fm,fm,fm,fm,fm,fm,fm,fm,fm,fm,fm,fm,fm,fm,fm,fm,fm,fm,fm,fm,fm,fm,fm,fm,fm,fm,fm,fm,fm};
        
        %%Ventana Temporal
        for n=1:nFiles
        sigFil1{1,n} = cellfun(@Cortar,sigFil1{1,n},fmcell10,'UniformOutput',0);
        sigFil3{1,n} = cellfun(@Cortar,sigFil3{1,n},fmcell30,'UniformOutput',0);
        end
        
        sigSua1=cell(1,nFiles);
        sigSua3=cell(1,nFiles);
        envelope1=cell(1,nFiles);
        envelope3=cell(1,nFiles);
        
        %% Schroeder
        for n=1:nFiles
        [envelope1{1,n},sigSua1{1,n}] = cellfun(@Suavizado,sigFil1{1,n},'UniformOutput',0);
        [envelope3{1,n},sigSua3{1,n}] = cellfun(@Suavizado,sigFil3{1,n},'UniformOutput',0);
        end

        %% Calcula y Guarda los resultados
        data1=cell(4,10);
        data3=cell(4,30);
        %data3={8,n};
        
            % Tabla octavas
            data1(:,1)=calcRT(sigSua1{1,n}{1,1},fm);
            data1(:,2)=calcRT(sigSua1{1,n}{1,2},fm);
            data1(:,3)=calcRT(sigSua1{1,n}{1,3},fm);
            data1(:,4)=calcRT(sigSua1{1,n}{1,4},fm);
            data1(:,5)=calcRT(sigSua1{1,n}{1,5},fm);
            data1(:,6)=calcRT(sigSua1{1,n}{1,6},fm);
            data1(:,7)=calcRT(sigSua1{1,n}{1,7},fm);
            data1(:,8)=calcRT(sigSua1{1,n}{1,8},fm);
            data1(:,9)=calcRT(sigSua1{1,n}{1,9},fm);
            data1(:,10)=calcRT(sigSua1{1,n}{1,10},fm);
        handles.tablaoctava.Data=data1;
            
            % Tabla tercios de octava
            data3(:,1)=calcRT(sigSua3{1,n}{1,1},fm);
            data3(:,2)=calcRT(sigSua3{1,n}{1,2},fm);
            data3(:,3)=calcRT(sigSua3{1,n}{1,3},fm);
            data3(:,4)=calcRT(sigSua3{1,n}{1,4},fm);
            data3(:,5)=calcRT(sigSua3{1,n}{1,5},fm);
            data3(:,6)=calcRT(sigSua3{1,n}{1,6},fm);
            data3(:,7)=calcRT(sigSua3{1,n}{1,7},fm);
            data3(:,8)=calcRT(sigSua3{1,n}{1,8},fm);
            data3(:,9)=calcRT(sigSua3{1,n}{1,9},fm);
            data3(:,10)=calcRT(sigSua3{1,n}{1,10},fm);
            data3(:,11)=calcRT(sigSua3{1,n}{1,11},fm);
            data3(:,12)=calcRT(sigSua3{1,n}{1,12},fm);
            data3(:,13)=calcRT(sigSua3{1,n}{1,13},fm);
            data3(:,14)=calcRT(sigSua3{1,n}{1,14},fm);
            data3(:,15)=calcRT(sigSua3{1,n}{1,15},fm);
            data3(:,16)=calcRT(sigSua3{1,n}{1,16},fm);
            data3(:,17)=calcRT(sigSua3{1,n}{1,17},fm);
            data3(:,18)=calcRT(sigSua3{1,n}{1,18},fm);
            data3(:,19)=calcRT(sigSua3{1,n}{1,19},fm);
            data3(:,20)=calcRT(sigSua3{1,n}{1,20},fm);
            data3(:,21)=calcRT(sigSua3{1,n}{1,21},fm);
            data3(:,22)=calcRT(sigSua3{1,n}{1,22},fm);
            data3(:,23)=calcRT(sigSua3{1,n}{1,23},fm);
            data3(:,24)=calcRT(sigSua3{1,n}{1,24},fm);
            data3(:,25)=calcRT(sigSua3{1,n}{1,25},fm);
            data3(:,26)=calcRT(sigSua3{1,n}{1,26},fm);
            data3(:,27)=calcRT(sigSua3{1,n}{1,27},fm);
            data3(:,28)=calcRT(sigSua3{1,n}{1,28},fm);
            data3(:,29)=calcRT(sigSua3{1,n}{1,29},fm);
            data3(:,30)=calcRT(sigSua3{1,n}{1,30},fm);
        handles.tablatercio.Data=data3;
            
            
        
        
        %%Guarda los Datos
        setappdata(handles.d,'data1',data1);
        setappdata(handles.d,'data3',data3);
        setappdata(handles.d,'sigFil1',sigFil1);
        setappdata(handles.d,'sigFil3',sigFil3);
        setappdata(handles.d,'sigSua1',sigSua1);
        setappdata(handles.d,'sigSua3',sigSua3);
     
        
        %%Habilita los botones
        set(handles.calcular,'Enable','on');
        set(handles.calcular,'String','Calcular');
        set(handles.graficar,'Enable','on');
        set(handles.selectorFiltro,'Enable','on');
    end
      
%% Muestra los datos en tabla y grafico
    function verdatos(~,~,handles)
        
        fm=getappdata(handles.d,'fm');
        sigFil1 = getappdata(handles.d,'sigFil1');
        sigFil3 = getappdata(handles.d,'sigFil3');
        sigSua1 = getappdata(handles.d,'sigSua1');
        sigSua3 = getappdata(handles.d,'sigSua3');
        nFiles = getappdata(handles.d,'nFiles');
               
        banda=handles.selectorFiltro.Value; 
        if nFiles > 1
            nIR=handles.selectorIR.Value;
        else
            nIR=1;
        end
        
        %Banda que se desea graficar
        if (get(handles.optionOctavas,'Value')==1)
            %Octavas
            yf=sigFil1{1,nIR}{1,banda};
            yf = 20*log10(yf./max(abs(yf)));
            ys=sigSua1{1,nIR}{1,banda}; %Ya viene en dB de Schroeder();
                %Datos para Rectas Ajustes x Octava
                %[~,nEDT,rEDT]=calcEdt(ys,fm);
                %[~,nT10,rT10]=calcT10(ys,fm);
                %[~,nT20,rT20]=calcT20(ys,fm);
                %[~,nT30,rT30]=calcT30(ys,fm);
                [~,nT,rT]=calcRT(ys,fm);
            else
            %Tercios
            yf=sigFil3{1,nIR}{1,banda};
            yf = 20*log10(yf./max(abs(yf)));
            ys=sigSua3{1,nIR}{1,banda};
                %Datos para Rectas Ajustes x Tercios
                %[~,nEDT,rEDT]=calcEdt(ys,fm);
                %[~,nT10,rT10]=calcT10(ys,fm);
                %[~,nT20,rT20]=calcT20(ys,fm);
                %[~,nT30,rT30]=calcT30(ys,fm);  
                [~,nT,rT]=calcRT(ys,fm);
        end
        
        
        t = 0:1/fm:((length(yf)-1)/fm) ;
        cla (handles.axx,'reset'); 
        axes(handles.axx);
        plot(handles.axx,t,yf);hold on; grid on  %Señal
        plot(handles.axx,t,ys);                  %Schroeder
        plot(handles.axx,nT{4,1},rT{4,1});             %EDT
        %plot(handles.axx,nT10,rT10);             %T10
        %plot(handles.axx,nT20,rT20);             %T20
        plot(handles.axx,nT{3,1},rT{3,1});             %T30
        axis(handles.axx,[0 length(yf)/fm -100 5]);
        xlabel('Tiempo[s]');ylabel('dB');
        legend('Señal','Schroeder','EDT','TR30');
    end
%% Carga frecuencias en Pop Up Menu
    function cargarSelectorOctavas(~,~,handles)
        set(handles.selectorFiltro,'String',{'31,5 Hz','63 Hz','125 Hz','250 Hz','500 Hz','1000 Hz','2000 Hz','4000 Hz','8000 Hz','16000 Hz'});
        set(handles.selectorFiltro,'Value',6);
    end
    function cargarSelectorTercios(~,~,handles)
        set(handles.selectorFiltro,'String',{'25 Hz','31,5 Hz','40 Hz','50 Hz','63 Hz','80 Hz','100 Hz', '125 Hz', '160 Hz', '200 Hz', '250 Hz', '315 Hz', '400 Hz', '500 Hz', '630 Hz', '800 Hz', '1000 Hz', '1250 Hz', '1600 Hz', '2000 Hz', '2500 Hz', '3150 Hz', '4000 Hz', '5000 Hz', '6300 Hz', '8000 Hz', '10000 Hz', '12500 Hz', '16000 Hz', '20000 Hz'});
        set(handles.selectorFiltro,'Value',17);
    end
end