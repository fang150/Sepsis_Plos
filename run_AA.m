
diary ./output/orig/myDiaryFile

label_table=readtable("./features/extradatatable.txt"); 
data_table=readtable("./features/datatable.txt"); 


Y=table2array(label_table);
X=table2array(data_table);

for i = 1:size(X,1)
    X(i,2)=X(i,2)/365.0;
end



delta=0;
opts.maxiter=1000;
opts.conv_crit=1e-6;

X=transpose(X);





for noc = 1:30 % Number of archetypes

	U=1:size(X,2); % Entries in X used that is modelled by the AA model
	I=1:size(X,2); % Entries in X used to define archetypes

	% if two expensive to useall entries for I find N relevant observations by
	% the following procedure:

	%N=1000;
	%I=FurthestSum(X,N,ceil(rand*size(X,2)));



	[XC,S,C,SSE,varexpl]=PCHA(X,noc,I,U,delta,opts);

	varexpl_file = fopen(strcat('./output/varexpl_',int2str(noc),'.txt'),'w');
	fprintf(varexpl_file,'%f',varexpl);
	fclose(varexpl_file);

	SSE_file = fopen(strcat('./output/SSE_',int2str(noc),'.txt'),'w');
	fprintf(SSE_file,'%f',SSE);
	fclose(SSE_file);


	XC_file = strcat('./output/XC_',int2str(noc),'.mat');
	S_file = strcat('./output/S_',int2str(noc),'.mat');
	C_file = strcat('./output/C_',int2str(noc),'.mat');


	save(XC_file,'XC');
	save(S_file,'S');
	save(C_file,'C');


end


