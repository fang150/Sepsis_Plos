



init_to_Ai_count=csvread('init_to_Ai_count.csv',0,0);
init_to_Ai_prob=csvread('init_to_Ai_prob.csv',0,0);

Ai_to_Aj_count=csvread('Ai_to_Aj_count.csv',0,0);
Ai_to_Aj_prob=csvread('Ai_to_Aj_prob.csv',0,0);



init_to_Ai_mechvent_avg=csvread('init_to_Ai_mechvent_avg.csv',0,0);
init_to_Ai_max_dose_vaso_avg=csvread('init_to_Ai_max_dose_vaso_avg.csv',0,0);
init_to_Ai_input_avg=csvread('init_to_Ai_input_avg.csv',0,0);


Ai_to_Aj_mechvent_avg=csvread('Ai_to_Aj_mechvent_avg.csv',0,0);
Ai_to_Aj_max_dose_vaso_avg=csvread('Ai_to_Aj_max_dose_vaso_avg.csv',0,0);
Ai_to_Aj_input_avg=csvread('Ai_to_Aj_input_avg.csv',0,0);



Ai_to_survive_death_count=csvread('Ai_to_survive_death_count.csv',0,0);
Ai_to_survive_death_prob=csvread('Ai_to_survive_death_prob.csv',0,0);


dose = zeros(7,7);

dose(1,2:7)=init_to_Ai_max_dose_vaso_avg;
dose(2:7,2:7)=Ai_to_Aj_max_dose_vaso_avg;

mechvent = zeros(7,7);
mechvent(1,2:7)=init_to_Ai_mechvent_avg;
mechvent(2:7,2:7)=Ai_to_Aj_mechvent_avg;

input = zeros(7,7);
input(1,2:7)=init_to_Ai_input_avg;
input(2:7,2:7)=Ai_to_Aj_input_avg;

P = zeros(7,7);

P(1,2:7)=init_to_Ai_prob;
P(2:7,2:7)=Ai_to_Aj_prob;


P_count = zeros(7,7);

P_count(1,2:7)=init_to_Ai_count;
P_count(2:7,2:7)=Ai_to_Aj_count;

stateNames = ["Init" "A1" "A2" "A3" "A4" "A5" "A6" ];

h4=figure;
least_point=50

s=[];
t=[];
w=[];

l1 = [];
l2 = [];
l3 = [];


for i = 1:7
    if sum(P_count(i,1:7))>=least_point
        for j=1:7
            s=horzcat(s,stateNames(i));
            t=horzcat(t,stateNames(j));
            w=horzcat(w,P(i,j));
            l1 = horzcat(l1,input(i,j));
            l2 = horzcat(l2,dose(i,j));
            l3 = horzcat(l3,mechvent(i,j));
        end
    end
        
end

number_of_edge=size(s,2);
ss=[];
tt=[];
ww=[];

for i= 1:size(s,2)
    if w(i)>0.02
        ss=horzcat(ss,s(i));
        tt=horzcat(tt,t(i));
        ww=horzcat(ww,w(i));
    end
end


for i =1:size(Ai_to_survive_death_count,1)
    if sum(Ai_to_survive_death_count(i,:))>=least_point
        ss=horzcat(ss,stateNames(i+1));
        tt=horzcat(tt,"death");
        ww=horzcat(ww,Ai_to_survive_death_prob(i,2));
    end
end



label = strings([1,size(ww,2)])
count = 1
for i= 1:size(s,2)
    if w(i)>0.02
        label(count) = num2str(round(l1(i),1)) + " / " + num2str(round(l2(i),2)) + " / " + num2str(round(l3(i),1)) ;
        count = count + 1
    end
end

for i= 1:size(Ai_to_survive_death_count,1)
    if Ai_to_survive_death_prob(i,2)>0.02
        label(count) = num2str(Ai_to_survive_death_prob(i,2))
        count = count + 1
    end
end

s2t_value_map = containers.Map
for i = 1:size(label,2)
    s2t_value_map(char(ss(i)+","+tt(i))) = label(i)
end

keys(s2t_value_map)
values(s2t_value_map)
g = digraph(cellstr(ss),cellstr(tt),ww);
s2t_edge_label = strings([1,size(ww,2)]);
for i =1:size(ww,2)    
    s2t_edge_label(i) = s2t_value_map( strcat(char(g.Edges.EndNodes(i,1)),',',char(g.Edges.EndNodes(i,2))));
end


h=plot(g,'Layout','layered','EdgeLabel',cellstr(s2t_edge_label));



x0=10;
y0=10;
width=800;
height=800
set(gcf,'position',[x0,y0,width,height])

colormap jet           % select color palette 
h.EdgeCData=g.Edges.Weight;    % define edge colors

h.MarkerSize = 7;

colorbar

h = colorbar;
ylabel(h, 'Transition Probability','Rotation',270)
h.Label.Position(1) = 2.5;
set(h4,'PaperSize',[12 12]); %set the paper size to what you want  


