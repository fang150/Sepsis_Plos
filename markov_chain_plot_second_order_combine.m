


init_to_Ai_Aj_count=csvread('init_to_Ai_Aj_count.csv',0,0);
init_to_Ai_Aj_prob=csvread('init_to_Ai_Aj_prob.csv',0,0);

Ai_Aj_to_Ai_Aj_count_2d=csvread('Ai_Aj_to_Ai_Aj_count_2d.csv',0,0);
Ai_Aj_to_Ai_Aj_prob_2d=csvread('Ai_Aj_to_Ai_Aj_prob_2d.csv',0,0);


Ai_Aj_to_survive_death_count_2d=csvread('Ai_Aj_to_survive_death_count_2d.csv',0,0);
Ai_Aj_to_survive_death_prob_2d=csvread('Ai_Aj_to_survive_death_prob_2d.csv',0,0);





P = zeros(39,39);

P(1,2:37)=reshape(init_to_Ai_Aj_prob,[1,36]);
P(2:37,2:37)=Ai_Aj_to_Ai_Aj_prob_2d;
P(2:37,38:39)=Ai_Aj_to_survive_death_prob_2d;


P_count = zeros(39,39);

P_count(1,2:37)=reshape(init_to_Ai_Aj_count,[1,36]);
P_count(2:37,2:37)=Ai_Aj_to_Ai_Aj_count_2d;
P_count(2:37,38:39)=Ai_Aj_to_survive_death_count_2d;


    
    
least_point= 100

stateNames = ["Init" "11" "12" "13" "14" "15" "16" "21" "22" "23" "24" "25" "26" "31" "32" "33" "34" "35" "36" "41" "42" "43" "44" "45" "46" "51" "52" "53" "54" "55" "56" "61" "62" "63" "64" "65" "66"];

%stateNames = {'Init' '11' '12' '13' '14' '15' '16' '21' '22' '23' '24' '25' '26' '31' '32' '33' '34' '35' '36' '41' '42' '43' '44' '45' '46' '51' '52' '53' '54' '55' '56' '61' '62' '63' '64' '65' '66'};

%digraph( cellstr(["Boston" "New York" "Washington D.C."]),cellstr(["New York" "New Jersey" "Pittsburgh"]) )

h4=figure;

s=[];
t=[];
w=[];
for i = 1:37
    
    if sum(P_count(i,1:37))>=least_point
        
        for j=1:37
            s=horzcat(s,stateNames(i));
            t=horzcat(t,stateNames(j));
            w=horzcat(w,P(i,j));
    end
        end
        
end
% 
% number_of_edge=size(s,2);
% ss=[];
% tt=[];
% ww=[];
% 
% for i= 1:size(s,2)
%     if w(i)>0.02
%         ss=horzcat(ss,s(i));
%         tt=horzcat(tt,t(i));
%         ww=horzcat(ww,w(i));
%     end
% end



number_of_edge=size(s,2);
ss=[];
tt=[];
ww=[];

for i= 1:size(s,2)
    if w(i)>0.02
        %ss{end+1} = s(i);
        %tt{end+1} = t(i);
        %ww{end+1} = w(i);
        ss=horzcat(ss,s(i));
        tt=horzcat(tt,t(i));
        ww=horzcat(ww,w(i));
    end
end





for i =1:size(Ai_Aj_to_survive_death_count_2d,1)
    if sum(Ai_Aj_to_survive_death_count_2d(i,:))>=least_point
        ss=horzcat(stateNames(i+1),ss);
        tt=horzcat("death",tt);
        ww=horzcat(Ai_Aj_to_survive_death_prob_2d(i,2),ww);
    end
end


g = digraph(cellstr(ss),cellstr(tt),ww);


h=plot(g,'Layout','layered');


colormap jet           % select color palette 
h.EdgeCData=g.Edges.Weight;    % define edge colors

h.MarkerSize = 7;

colorbar

set(h4,'PaperSize',[8 8]); %set the paper size to what you want  
%print(h4,'Transition_Graph_second_order','-dpdf')




%saveas(f1,'finename.svg')