

Z = table2array(readtable("./metadata/Z_score_pass_through_state.txt")); 






cdata = p_table;
xname={'A1','A2','A3','A4','A5','A6'};
yname={'congestive heart failure' ,'cardiac arrhythmias' ,'valvular disease' ,'pulmonary circulation', 'peripheral vascular' ,'hypertension' ,'paralysis' ,'other neurological' ,'chronic pulmonary' ,'diabetes uncomplicated' ,'diabetes complicated' ,'hypothyroidism' ,'renal failure' ,'liver disease' ,'peptic ulcer' ,'aids' ,'lymphoma' ,'metastatic cancer' ,'solid tumor' ,'rheumatoid arthritis' ,'coagulopathy' ,'obesity' ,'weight loss' ,'fluid electrolyte','blood loss anemia','deficiency anemias','alcohol abuse','drug abuse','psychoses','depression'};


mincolor = min(cdata(:));
maxcolor = max(cdata(:));
mycolormap = customcolormap_preset('red-white-blue');
colorbar;
colormap(mycolormap);

%h = heatmap(xname,yname,cdata,'CellLabelColor','none','Colormap',mycolormap);
h = heatmap(xname,yname,cdata,'Colormap',mycolormap);


h.Title = 'P-value';
h.XLabel = 'Archetype';
h.YLabel = 'Premorbid Status';
h.CellLabelFormat = '%.e';


caxis(h,[mincolor maxcolor]);





