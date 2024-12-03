function [X,IDX] = sampleDistributions(name,plt)
%simulated flim data
bins=256;
ed=linspace(0,12500,bins);
% calibration with rhodamine
[microtimes] = lifetimeMeasurement(1e6,4);
[s,g]=expectedPhasorPosition(4,8e7,1);
ph=histc(microtimes,ed);
% figure,bar(ed,ph)
[S,G] = flimPhasors(ph',1,[1,1]);
PD=atan2(s,g)-atan2(S,G);
MF=sqrt((s*s)+(g*g))/sqrt((S*S)+(G*G));
if(nargin<2),plt=0;end
  S=[];G=[];IDX=[];
switch name
    case 'easy'
        %% test1: 3 isolated clusters
       
        
        Npix=100;
        Npho=1e4;
        % all fotons in all pixels L1
        [microtimes] = lifetimeMeasurement(Npho*Npix,2.5);
        ph=zeros(Npix,length(ed));prev2=1;
        for kk=1:Npix% separate by chunks of Npho
            arrivaltimes=microtimes(prev2:prev2+Npho-1);
            ph(kk,:)=histc(arrivaltimes,ed);
            prev2=prev2+Npho;
        end
        [ST,GT] = flimPhasors(ph,1,[Npix,1]);
        % apply calibration
        pha=atan2(ST,GT)+PD;modu=sqrt((ST.*ST)+(GT.*GT))*MF;ST=modu.*sin(pha); GT=modu.*cos(pha);
        % accumulate
        S=[S;ST];G=[G;GT];IDX=[IDX;ones(size(GT))*1];
        
        % all fotons in all pixels L2
        [microtimes] = lifetimeMeasurement(Npho*Npix,3.5);
        ph=zeros(Npix,length(ed));prev2=1;
        for kk=1:Npix% separate by chunks of Npho
            arrivaltimes=microtimes(prev2:prev2+Npho-1);
            ph(kk,:)=histc(arrivaltimes,ed);
            prev2=prev2+Npho;
        end
        [ST,GT] = flimPhasors(ph,1,[Npix,1]);
        % apply calibration
        pha=atan2(ST,GT)+PD;modu=sqrt((ST.*ST)+(GT.*GT))*MF;ST=modu.*sin(pha); GT=modu.*cos(pha);
        % accumulate
        S=[S;ST];G=[G;GT];IDX=[IDX;ones(size(GT))*2];
        
        % all fotons in all pixels L2
        frac=.8;
        [microtimes1] = lifetimeMeasurement(Npho*frac*Npix,3.5);
        [microtimes2] = lifetimeMeasurement(Npho*(1-frac)*Npix,0.5);
        ph=zeros(Npix,length(ed));prev1=1;prev2=1;
        for kk=1:Npix% separate by chunks of Npho
            arrivaltimes=[microtimes1(prev1:prev1+(Npho*frac)-1);microtimes2(prev2:prev2+round(Npho*(1-frac))-1)];
            ph(kk,:)=histc(arrivaltimes,ed);
            prev1=prev1+Npho*frac;prev2=prev2+round(Npho*(1-frac));
        end
        [ST,GT] = flimPhasors(ph,1,[Npix,1]);
        % apply calibration
        pha=atan2(ST,GT)+PD;modu=sqrt((ST.*ST)+(GT.*GT))*MF;ST=modu.*sin(pha); GT=modu.*cos(pha);
        % accumulate
        S=[S;ST];G=[G;GT];IDX=[IDX;ones(size(GT))*3];
        
        if(plt==1),figure(1);clf;phasorPlot2(S,G,round([.6 1]*256),1,[0,1;0 .6],0,0,1);scatter(G,S,'.');end
        %        figure(1);
    case 'skew'
        %% test2: 3 isolated clusters skewed with unmodulated light
         
        
        
        Npix=100;
        Npho=1e4;Nunmod=.1e4;StdUnmod=Nunmod*.8;
        % all fotons in all pixels L1
        [microtimes] = lifetimeMeasurement(Npho*Npix,2.5);
        ph=zeros(Npix,length(ed));prev2=1;
        for kk=1:Npix% separate by chunks of Npho
            arrivaltimes=[microtimes(prev2:prev2+Npho-1);round(12500*rand(round(Nunmod+StdUnmod*randn(1,1)),1))];
            
            ph(kk,:)=histc(arrivaltimes,ed);
            prev2=prev2+Npho;
        end
        [ST,GT] = flimPhasors(ph,1,[Npix,1]);
        % apply calibration
        pha=atan2(ST,GT)+PD;modu=sqrt((ST.*ST)+(GT.*GT))*MF;ST=modu.*sin(pha); GT=modu.*cos(pha);
        % accumulate
        S=[S;ST];G=[G;GT];IDX=[IDX;ones(size(GT))*1];
        %   figure(1);clf;phasorPlot2(S,G,round([.6 1]*256),1,[0,1;0 .6],0,0,1);scatter(G,S,'.')
        % all fotons in all pixels L2
        [microtimes] = lifetimeMeasurement(Npho*Npix,3.5);
        ph=zeros(Npix,length(ed));prev2=1;
        for kk=1:Npix% separate by chunks of Npho
            arrivaltimes=[microtimes(prev2:prev2+Npho-1);round(12500*rand(round(Nunmod+StdUnmod*randn(1,1)),1))];
            ph(kk,:)=histc(arrivaltimes,ed);
            prev2=prev2+Npho;
        end
        [ST,GT] = flimPhasors(ph,1,[Npix,1]);
        % apply calibration
        pha=atan2(ST,GT)+PD;modu=sqrt((ST.*ST)+(GT.*GT))*MF;ST=modu.*sin(pha); GT=modu.*cos(pha);
        % accumulate
        S=[S;ST];G=[G;GT];IDX=[IDX;ones(size(GT))*2];
        
        % all fotons in all pixels L2
        frac=.8;
        [microtimes1] = lifetimeMeasurement(Npho*frac*Npix,3.5);
        [microtimes2] = lifetimeMeasurement(Npho*(1-frac)*Npix,0.5);
        ph=zeros(Npix,length(ed));prev1=1;prev2=1;
        for kk=1:Npix% separate by chunks of Npho
            arrivaltimes=[microtimes1(prev1:prev1+(Npho*frac)-1);microtimes2(prev2:prev2+round(Npho*(1-frac))-1)];
            arrivaltimes=[arrivaltimes;round(12500*rand(round(Nunmod+StdUnmod*randn(1,1)),1))];
            ph(kk,:)=histc(arrivaltimes,ed);
            prev1=prev1+Npho*frac;prev2=prev2+round(Npho*(1-frac));
        end
        [ST,GT] = flimPhasors(ph,1,[Npix,1]);
        % apply calibration
        pha=atan2(ST,GT)+PD;modu=sqrt((ST.*ST)+(GT.*GT))*MF;ST=modu.*sin(pha); GT=modu.*cos(pha);
        % accumulate
        S=[S;ST];G=[G;GT];IDX=[IDX;ones(size(GT))*3];
        
        if(plt==1),figure(1);clf;phasorPlot2(S,G,round([.6 1]*256),1,[0,1;0 .6],0,0,1);scatter(G,S,'.');end
        %
    case 'size'
        %% test3: 3  clusters 1 much bigger (less fotons)
         
        
        Npix=100;
        Npho=1e2;
        % all fotons in all pixels L1
        [microtimes] = lifetimeMeasurement(Npho*Npix,2.5);
        ph=zeros(Npix,length(ed));prev2=1;
        for kk=1:Npix% separate by chunks of Npho
            arrivaltimes=microtimes(prev2:prev2+Npho-1);
            ph(kk,:)=histc(arrivaltimes,ed);
            prev2=prev2+Npho;
        end
        [ST,GT] = flimPhasors(ph,1,[Npix,1]);
        % apply calibration
        pha=atan2(ST,GT)+PD;modu=sqrt((ST.*ST)+(GT.*GT))*MF;ST=modu.*sin(pha); GT=modu.*cos(pha);
        % accumulate
        S=[S;ST];G=[G;GT];IDX=[IDX;ones(size(GT))*1];
        
        Npho=3e3;
        % all fotons in all pixels L2
        [microtimes] = lifetimeMeasurement(Npho*Npix,3.5);
        ph=zeros(Npix,length(ed));prev2=1;
        for kk=1:Npix% separate by chunks of Npho
            arrivaltimes=microtimes(prev2:prev2+Npho-1);
            ph(kk,:)=histc(arrivaltimes,ed);
            prev2=prev2+Npho;
        end
        [ST,GT] = flimPhasors(ph,1,[Npix,1]);
        % apply calibration
        pha=atan2(ST,GT)+PD;modu=sqrt((ST.*ST)+(GT.*GT))*MF;ST=modu.*sin(pha); GT=modu.*cos(pha);
        % accumulate
        S=[S;ST];G=[G;GT];IDX=[IDX;ones(size(GT))*2];
        
        % all fotons in all pixels L2
        frac=.8;
        [microtimes1] = lifetimeMeasurement(Npho*frac*Npix,3.5);
        [microtimes2] = lifetimeMeasurement(Npho*(1-frac)*Npix,0.5);
        ph=zeros(Npix,length(ed));prev1=1;prev2=1;
        for kk=1:Npix% separate by chunks of Npho
            arrivaltimes=[microtimes1(prev1:prev1+(Npho*frac)-1);microtimes2(prev2:prev2+round(Npho*(1-frac))-1)];
            ph(kk,:)=histc(arrivaltimes,ed);
            prev1=prev1+Npho*frac;prev2=prev2+round(Npho*(1-frac));
        end
        [ST,GT] = flimPhasors(ph,1,[Npix,1]);
        % apply calibration
        pha=atan2(ST,GT)+PD;modu=sqrt((ST.*ST)+(GT.*GT))*MF;ST=modu.*sin(pha); GT=modu.*cos(pha);
        % accumulate
        S=[S;ST];G=[G;GT];IDX=[IDX;ones(size(GT))*3];
        if(plt==1),figure(1);clf;phasorPlot2(S,G,round([.6 1]*256),1,[0,1;0 .6],0,0,1);scatter(G,S,'.');end
        %
    case 'nums'
        %% test1: 4  clusters 1 less points
         
        
        Npix=30;
        Npho=1e3;
        % all fotons in all pixels L1
        [microtimes] = lifetimeMeasurement(Npho*Npix,2.5);
        ph=zeros(Npix,length(ed));prev2=1;
        for kk=1:Npix% separate by chunks of Npho
            arrivaltimes=microtimes(prev2:prev2+Npho-1);
            ph(kk,:)=histc(arrivaltimes,ed);
            prev2=prev2+Npho;
        end
        [ST,GT] = flimPhasors(ph,1,[Npix,1]);
        % apply calibration
        pha=atan2(ST,GT)+PD;modu=sqrt((ST.*ST)+(GT.*GT))*MF;ST=modu.*sin(pha); GT=modu.*cos(pha);
        % accumulate
        S=[S;ST];G=[G;GT];IDX=[IDX;ones(size(GT))*1];
        
        Npho=6e2;
        Npix=150;
        % all fotons in all pixels L2
        [microtimes] = lifetimeMeasurement(Npho*Npix,3.5);
        ph=zeros(Npix,length(ed));prev2=1;
        for kk=1:Npix% separate by chunks of Npho
            arrivaltimes=microtimes(prev2:prev2+Npho-1);
            ph(kk,:)=histc(arrivaltimes,ed);
            prev2=prev2+Npho;
        end
        [ST,GT] = flimPhasors(ph,1,[Npix,1]);
        % apply calibration
        pha=atan2(ST,GT)+PD;modu=sqrt((ST.*ST)+(GT.*GT))*MF;ST=modu.*sin(pha); GT=modu.*cos(pha);
        % accumulate
        S=[S;ST];G=[G;GT];IDX=[IDX;ones(size(GT))*2];
        
        % all fotons in all pixels L2
        frac=.8;
        [microtimes1] = lifetimeMeasurement(Npho*frac*Npix,3.5);
        [microtimes2] = lifetimeMeasurement(Npho*(1-frac)*Npix,0.5);
        ph=zeros(Npix,length(ed));prev1=1;prev2=1;
        for kk=1:Npix% separate by chunks of Npho
            arrivaltimes=[microtimes1(prev1:prev1+(Npho*frac)-1);microtimes2(prev2:prev2+round(Npho*(1-frac))-1)];
            ph(kk,:)=histc(arrivaltimes,ed);
            prev1=prev1+Npho*frac;prev2=prev2+round(Npho*(1-frac));
        end
        [ST,GT] = flimPhasors(ph,1,[Npix,1]);
        % apply calibration
        pha=atan2(ST,GT)+PD;modu=sqrt((ST.*ST)+(GT.*GT))*MF;ST=modu.*sin(pha); GT=modu.*cos(pha);
        % accumulate
        S=[S;ST];G=[G;GT];IDX=[IDX;ones(size(GT))*3];
        
        if(plt==1),figure(1);clf;phasorPlot2(S,G,round([.6 1]*256),1,[0,1;0 .6],0,0,1);scatter(G,S,'.');end
        %
    case 'hard'
        %% test1: 5 clusters overlapping, one skewed with unmodulated light the other containing different fractions of the [.5 2.5]
         
        
        
        Npix=100;
        Npho=1e4;Nunmod=.2e4;StdUnmod=Nunmod*.86;
        % all fotons in all pixels L1
        [microtimes] = lifetimeMeasurement(Npho*Npix,2.5);
        ph=zeros(Npix,length(ed));prev2=1;
        for kk=1:Npix% separate by chunks of Npho
            arrivaltimes=[microtimes(prev2:prev2+Npho-1);round(12500*rand(round(Nunmod+StdUnmod*randn(1,1)),1))];
            
            ph(kk,:)=histc(arrivaltimes,ed);
            prev2=prev2+Npho;
        end
        [ST,GT] = flimPhasors(ph,1,[Npix,1]);
        % apply calibration
        pha=atan2(ST,GT)+PD;modu=sqrt((ST.*ST)+(GT.*GT))*MF;ST=modu.*sin(pha); GT=modu.*cos(pha);
        % accumulate
        S=[S;ST];G=[G;GT];IDX=[IDX;ones(size(GT))*1];
        if(plt==1),figure(1);clf;phasorPlot2(S,G,round([.6 1]*256),1,[0,1;0 .6],0,0,1);scatter(G,S,'.');end
        
        %   figure(1);clf;phasorPlot2(S,G,round([.6 1]*256),1,[0,1;0 .6],0,0,1);scatter(G,S,'.')
        % all fotons in all pixels L2
        [microtimes] = lifetimeMeasurement(Npho*Npix,3.5);
        ph=zeros(Npix,length(ed));prev2=1;
        for kk=1:Npix% separate by chunks of Npho
            arrivaltimes=[microtimes(prev2:prev2+Npho-1)];
            ph(kk,:)=histc(arrivaltimes,ed);
            prev2=prev2+Npho;
        end
        [ST,GT] = flimPhasors(ph,1,[Npix,1]);
        % apply calibration
        pha=atan2(ST,GT)+PD;modu=sqrt((ST.*ST)+(GT.*GT))*MF;ST=modu.*sin(pha); GT=modu.*cos(pha);
        % accumulate
        S=[S;ST];G=[G;GT];IDX=[IDX;ones(size(GT))*2];
        
        % all fotons in all pixels L2
        frac0=.8;
        [microtimes1] = lifetimeMeasurement(10*Npho*frac0*Npix,3.5);
        [microtimes2] = lifetimeMeasurement(10*Npho*(1-frac0)*Npix,0.5);
        ph=zeros(Npix,length(ed));prev1=1;prev2=1;
        for kk=1:Npix% separate by chunks of Npho
            frac=frac0+randn(1,1)*.1;
            arrivaltimes=[microtimes1(prev1:prev1+round(Npho*frac)-1);microtimes2(prev2:prev2+round(Npho*(1-frac))-1)];
            ph(kk,:)=histc(arrivaltimes,ed);
            prev1=prev1+round(Npho*frac);prev2=prev2+round(Npho*(1-frac));
        end
        [ST,GT] = flimPhasors(ph,1,[Npix,1]);
        % apply calibration
        pha=atan2(ST,GT)+PD;modu=sqrt((ST.*ST)+(GT.*GT))*MF;ST=modu.*sin(pha); GT=modu.*cos(pha);
        % accumulate
        S=[S;ST];G=[G;GT];IDX=[IDX;ones(size(GT))*3];
        
        if(plt==1),figure(1);clf;phasorPlot2(S,G,round([.6 1]*256),1,[0,1;0 .6],0,0,1);scatter(G,S,'.');end
end

X=[S,G];
end