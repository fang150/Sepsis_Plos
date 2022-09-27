
init_to_Ai_Aj_Ak_count=csvread('init_to_Ai_Aj_Ak_count_2d.csv',0,0);
init_to_Ai_Aj_Ak_prob=csvread('init_to_Ai_Aj_Ak_prob_2d.csv',0,0);

Ai_Aj_Ak_to_Ai_Aj_Ak_count_2d=csvread('Ai_Aj_Ak_to_Ai_Aj_Ak_count_2d.csv',0,0);
Ai_Aj_Ak_to_Ai_Aj_Ak_prob_2d=csvread('Ai_Aj_Ak_to_Ai_Aj_Ak_prob_2d.csv',0,0);


%init_to_Ai_Aj_Ak_input_total_avg_2d = csvread('init_to_Ai_Aj_Ak_input_total_avg_2d.csv',0,0);
%init_to_Ai_Aj_Ak_max_dose_vaso_avg_2d = csvread('init_to_Ai_Aj_Ak_max_dose_vaso_avg_2d.csv',0,0);
%init_to_Ai_Aj_Ak_mechvent_avg_2d = csvread('init_to_Ai_Aj_Ak_mechvent_avg_2d.csv',0,0);


%Ai_Aj_Ak_to_Ai_Aj_Ak_input_total_avg_2d = csvread('Ai_Aj_Ak_to_Ai_Aj_Ak_input_total_avg_2d.csv',0,0);
%Ai_Aj_Ak_to_Ai_Aj_Ak_max_dose_vaso_avg_2d = csvread('Ai_Aj_Ak_to_Ai_Aj_Ak_max_dose_vaso_avg_2d.csv',0,0);
%Ai_Aj_Ak_to_Ai_Aj_Ak_mechvent_avg_2d = csvread('Ai_Aj_Ak_to_Ai_Aj_Ak_mechvent_avg_2d.csv',0,0);




Ai_Aj_Ak_to_survive_death_count_2d=csvread('Ai_Aj_Ak_to_survive_death_count_2d.csv',0,0);
Ai_Aj_Ak_to_survive_death_prob_2d=csvread('Ai_Aj_Ak_to_survive_death_prob_2d.csv',0,0);


input = zeros(6*6*6+1,6*6*6+1);
vaso = zeros(6*6*6+1,6*6*6+1);
mechvent = zeros(6*6*6+1,6*6*6+1);

%input(1,2:217) = reshape(init_to_Ai_Aj_Ak_input_total_avg_2d,[1,216]);
%input(2:217,2:217)=Ai_Aj_Ak_to_Ai_Aj_Ak_input_total_avg_2d;

%vaso(1,2:217) = reshape(init_to_Ai_Aj_Ak_max_dose_vaso_avg_2d,[1,216]);
%vaso(2:217,2:217)=Ai_Aj_Ak_to_Ai_Aj_Ak_max_dose_vaso_avg_2d;

%mechvent(1,2:217) = reshape(init_to_Ai_Aj_Ak_mechvent_avg_2d,[1,216]);
%mechvent(2:217,2:217)=Ai_Aj_Ak_to_Ai_Aj_Ak_mechvent_avg_2d;



P = zeros(6*6*6+1,6*6*6+1);

P(1,2:217)=reshape(init_to_Ai_Aj_Ak_prob,[1,216]);
P(2:217,2:217)=Ai_Aj_Ak_to_Ai_Aj_Ak_prob_2d;
%P(2:37,38:39)=Ai_Aj_to_survive_death_prob_2d;


P_count = zeros(6*6*6+1,6*6*6+1);


P_count(1,2:217)=reshape(init_to_Ai_Aj_Ak_count,[1,216]);
P_count(2:217,2:217)=Ai_Aj_Ak_to_Ai_Aj_Ak_count_2d;
%P_count(2:37,38:39)=Ai_Aj_to_survive_death_count_2d;


    
    
least_point= 15

stateNames = ["Init" "111" "112" "113" "114" "115" "116" "121" "122" "123" "124" "125" "126" "131" "132" "133" "134" "135" "136" "141" "142" "143" "144" "145" "146" "151" "152" "153" "154" "155" "156" "161" "162" "163" "164" "165" "166" "211" "212" "213" "214" "215" "216" "221" "222" "223" "224" "225" "226" "231" "232" "233" "234" "235" "236" "241" "242" "243" "244" "245" "246" "251" "252" "253" "254" "255" "256" "261" "262" "263" "264" "265" "266" "311" "312" "313" "314" "315" "316" "321" "322" "323" "324" "325" "326" "331" "332" "333" "334" "335" "336" "341" "342" "343" "344" "345" "346" "351" "352" "353" "354" "355" "356" "361" "362" "363" "364" "365" "366" "411" "412" "413" "414" "415" "416" "421" "422" "423" "424" "425" "426" "431" "432" "433" "434" "435" "436" "441" "442" "443" "444" "445" "446" "451" "452" "453" "454" "455" "456" "461" "462" "463" "464" "465" "466" "511" "512" "513" "514" "515" "516" "521" "522" "523" "524" "525" "526" "531" "532" "533" "534" "535" "536" "541" "542" "543" "544" "545" "546" "551" "552" "553" "554" "555" "556" "561" "562" "563" "564" "565" "566" "611" "612" "613" "614" "615" "616" "621" "622" "623" "624" "625" "626" "631" "632" "633" "634" "635" "636" "641" "642" "643" "644" "645" "646" "651" "652" "653" "654" "655" "656" "661" "662" "663" "664" "665" "666"];

h4=figure;

s=[];
t=[];
w=[];
l1 = [];
l2 = [];
l3 = [];
for i = 1:217
    
    if sum(P_count(i,1:217))>=least_point
        
        for j=1:217
            s=horzcat(s,stateNames(i));
            t=horzcat(t,stateNames(j));
            w=horzcat(w,P(i,j));
 
            l1 = horzcat(l1,input(i,j));
            l2 = horzcat(l2,vaso(i,j));
            l3 = horzcat(l3,mechvent(i,j));
    end
        end
        
end

number_of_edge=size(s,2);
ss=[];
tt=[];
ww=[];
%label = [];



%countt = 1

for i= 1:size(s,2)
    if w(i)> 0.02
        ss=horzcat(ss,s(i));
        tt=horzcat(tt,t(i));
        ww=horzcat(ww,w(i));

        %label = horzcat(label, num2str(round(l1(i),1))) ;
    end
end


for i =1:size(Ai_Aj_Ak_to_survive_death_count_2d,1)
    if sum(Ai_Aj_Ak_to_survive_death_count_2d(i,:))>=least_point
        ss=horzcat(ss,stateNames(i+1));
        tt=horzcat(tt,"death");
        prob=Ai_Aj_Ak_to_survive_death_count_2d(i,:)/sum(Ai_Aj_Ak_to_survive_death_count_2d(i,:));
        ww=horzcat(ww,Ai_Aj_Ak_to_survive_death_prob_2d(i,2));
        %ss=horzcat(ss,stateNames(i+1));
        %tt=horzcat(tt,"survive");
        %ww=horzcat(ww,Ai_Aj_to_survive_death_prob_2d(i,1));
    end
end

label = strings([1,size(ww,2)])
count = 1
for i= 1:size(s,2)
    if w(i)> 0.02%0.03
        label(count) = num2str(round(l1(i),1)) + " / " + num2str(round(l2(i),1)) ;
        count = count + 1
    end
end
 


g = digraph(cellstr(ss),cellstr(tt),ww);



%h=plot(g,'EdgeLabel',round(g.Edges.Weight,3),'Layout','layered');
%h=plot(g,'Layout','layered','EdgeLabel',cellstr(label));
h=plot(g,'Layout','layered');


colormap jet           % select color palette 
h.EdgeCData=g.Edges.Weight;    % define edge colors

h.MarkerSize = 7;

%colorbar

h = colorbar;
ylabel(h, 'Transition Probability','Rotation',270)
h.Label.Position(1) = 2.5;

x0=10;
y0=10;
width=800;
height=800
set(gcf,'position',[x0,y0,width,height])


set(h4,'PaperSize',[12 12]); %set the paper size to what you want  
print(h4,'Transition_Graph_third_order','-dpdf')




%saveas(f1,'finename.svg')