import numpy as np 
#  Columns 1 through 8
#    {'icustayid'}    {'charttime'}    {'bloc'}    {'subject_id'}    {'re_admission'}    {'died_in_hosp'}    {'died_within_48...'}    {'mortality_90d'}
#  Column 9          10                         11                       12                    13                     14                     15 
#    {'archetype'}  

Patient_Trajectories=np.loadtxt("Patient_Trajectories.csv",delimiter=",",skiprows=1)
#Patient_Trajectories=np.loadtxt("Patient_Trajectories.csv",delimiter=",",skiprows=1)


# Find unique stays ids
distinct_patients_list = np.unique(Patient_Trajectories[:,0])
patient_traj_list=[]

# Get all patient trajectories
for i in range(0,len(distinct_patients_list)):
    
    # Find the indices that belongs to the current stay
    Patient_Trajectories_idx=np.where(Patient_Trajectories[:,0] == distinct_patients_list[i])
    # Get the trajectoris for this particular stay
    traj_list = Patient_Trajectories[  Patient_Trajectories_idx  , : ]
    
    # Put that trajectory into the list
    if(i==0):
        patient_traj_list=[traj_list]
    else:
        patient_traj_list.append(traj_list)

init_to_Ai_Aj_Ak_count=np.zeros( (6,6,6) )
init_to_Ai_Aj_Ak_count_2d=np.zeros( (6*6*6,1) )
Ai_Aj_Ak_to_Ai_Aj_Ak_count= np.zeros((6,6,6,6,6,6))
Ai_Aj_Ak_to_survive_death_count =np.zeros((6,6,6,2))

## Loop over all patient trajectories
## Compute init_to_Ai_Aj_Ak_count, Ai_Aj_Ak_to_Ai_Aj_Ak_count, Ai_Aj_Ak_to_survive_death_count

freq_dict={}


for i in range(0,len(patient_traj_list)):
    ## Get the current trajectory
    traj = patient_traj_list[i]

    number_of_time_points = traj.shape[1]

    if number_of_time_points not in freq_dict:
        freq_dict[number_of_time_points] = 1
    else:
        freq_dict[number_of_time_points] += 1

    ## Go through each time point
    for j in range(0, number_of_time_points):

        if number_of_time_points == 1:
            continue
        elif number_of_time_points == 2:
            continue
        elif number_of_time_points == 3:

            if(j==0 or j==1):
                continue
            else:

                ## example        a b c 
                ##                ^ ^ ^
                ##               pp p c
                Archetype_cur = int(traj[0, j, 8])
                Archetype_prev = int(traj[0, j-1, 8])
                Archetype_prev_prev = int(traj[0, j-2, 8])
                init_to_Ai_Aj_Ak_count[Archetype_prev_prev - 1, Archetype_prev - 1, Archetype_cur - 1] += 1
                
                if(traj[0, j, 5] == 1):
                    Ai_Aj_Ak_to_survive_death_count[Archetype_prev_prev - 1, Archetype_prev - 1, Archetype_cur - 1, 1] += 1
                else:
                    Ai_Aj_Ak_to_survive_death_count[Archetype_prev_prev - 1, Archetype_prev - 1, Archetype_cur - 1, 0] += 1
        elif number_of_time_points == 4:
            if(j==0 or j==1):
                continue
            elif(j == 2):
                ## example  a b c d
                ##          ^ ^ ^
                ##         pp p c
                Archetype_cur=int(traj[0,j,8])
                Archetype_prev=int(traj[0,j-1,8])
                Archetype_prev_prev=int(traj[0,j-2,8])
                init_to_Ai_Aj_Ak_count[Archetype_prev_prev-1,Archetype_prev-1,Archetype_cur-1]+=1

                if(traj[0, j, 5] == 1):
                    Ai_Aj_Ak_to_survive_death_count[Archetype_prev_prev - 1, Archetype_prev - 1, Archetype_cur - 1, 1] += 1
                else:
                    Ai_Aj_Ak_to_survive_death_count[Archetype_prev_prev - 1, Archetype_prev - 1, Archetype_cur - 1, 0] += 1





            elif( j == 3):
                ## example  a b c d  
                ##          ^ ^ ^ ^
                ##       ppp pp p c
                Archetype_prev_prev_prev = int(traj[0, j - 3, 8])
                Archetype_prev_prev = int(traj[0, j - 2, 8])
                Archetype_prev = int(traj[0, j - 1, 8])
                Archetype_cur = int(traj[0, j, 8])
                Ai_Aj_Ak_to_Ai_Aj_Ak_count[ Archetype_prev_prev_prev - 1, Archetype_prev_prev - 1, Archetype_prev - 1, Archetype_prev_prev - 1, Archetype_prev - 1, Archetype_cur - 1] += 1
                
                if(traj[0, j, 5] == 1):
                    Ai_Aj_Ak_to_survive_death_count[Archetype_prev_prev - 1, Archetype_prev - 1, Archetype_cur - 1, 1] += 1
                else:
                    Ai_Aj_Ak_to_survive_death_count[Archetype_prev_prev - 1 , Archetype_prev - 1, Archetype_cur - 1, 0] += 1
        else:

            if(j==0 or j==1):
                continue
            elif(j == 2):
                ## example  a b c d e
                ##          ^ ^ ^
                ##         pp p c
                Archetype_cur=int(traj[0,j,8])
                Archetype_prev=int(traj[0,j-1,8])
                Archetype_prev_prev=int(traj[0,j-2,8])
                init_to_Ai_Aj_Ak_count[Archetype_prev_prev-1,Archetype_prev-1,Archetype_cur-1]+=1


                if(traj[0, j, 5] == 1):
                    Ai_Aj_Ak_to_survive_death_count[Archetype_prev_prev - 1, Archetype_prev - 1, Archetype_cur - 1, 1] += 1
                else:
                    Ai_Aj_Ak_to_survive_death_count[Archetype_prev_prev - 1, Archetype_prev - 1, Archetype_cur - 1, 0] += 1



            elif( j < number_of_time_points - 1):
                ## example  a b c d e  
                ##          ^ ^ ^ ^
                ##       ppp pp p c
                Archetype_prev_prev_prev = int(traj[0, j - 3, 8])
                Archetype_prev_prev = int(traj[0, j - 2, 8])
                Archetype_prev = int(traj[0, j - 1, 8])
                Archetype_cur = int(traj[0, j, 8])
                Ai_Aj_Ak_to_Ai_Aj_Ak_count[ Archetype_prev_prev_prev - 1, Archetype_prev_prev - 1, Archetype_prev - 1, Archetype_prev_prev - 1, Archetype_prev - 1, Archetype_cur - 1] += 1
                

                if(traj[0, j, 5] == 1):
                    Ai_Aj_Ak_to_survive_death_count[Archetype_prev_prev - 1, Archetype_prev - 1, Archetype_cur - 1, 1] += 1
                else:
                    Ai_Aj_Ak_to_survive_death_count[Archetype_prev_prev - 1, Archetype_prev - 1, Archetype_cur - 1, 0] += 1

            else:
                ## example  a b c d e  
                ##            ^ ^ ^ ^
                ##         ppp pp p c
                Archetype_prev_prev_prev = int(traj[0, j - 3, 8])
                Archetype_prev_prev = int(traj[0, j - 2, 8])
                Archetype_prev = int(traj[0, j - 1, 8])
                Archetype_cur = int(traj[0, j, 8])
                Ai_Aj_Ak_to_Ai_Aj_Ak_count[ Archetype_prev_prev_prev - 1, Archetype_prev_prev - 1, Archetype_prev - 1, Archetype_prev_prev - 1, Archetype_prev - 1, Archetype_cur - 1] += 1

                if(traj[0, j, 5] == 1):
                    Ai_Aj_Ak_to_survive_death_count[Archetype_prev_prev - 1, Archetype_prev - 1, Archetype_cur - 1, 1] += 1
                else:
                    Ai_Aj_Ak_to_survive_death_count[Archetype_prev_prev - 1 , Archetype_prev - 1, Archetype_cur - 1, 0] += 1

init_to_Ai_Aj_Ak_prob = np.zeros( (6,6,6) )
init_to_Ai_Aj_Ak_prob_2d = np.zeros( (6*6*6,1) )
Ai_Aj_Ak_to_Ai_Aj_Ak_prob = np.zeros((6,6,6,6,6,6))
Ai_Aj_Ak_to_survive_death_prob = np.zeros((6,6,6,2))


init_to_Ai_Aj_Ak_prob = init_to_Ai_Aj_Ak_count / init_to_Ai_Aj_Ak_count.sum()
for i in range(0,init_to_Ai_Aj_Ak_prob.shape[0]):
    for j in range(0,init_to_Ai_Aj_Ak_prob.shape[1]):
        for k in range(0,init_to_Ai_Aj_Ak_prob.shape[2]):
            init_to_Ai_Aj_Ak_prob_2d[6*6*i+6*j+k,0]=init_to_Ai_Aj_Ak_prob[i,j,k]
            init_to_Ai_Aj_Ak_count_2d[6*6*i+6*j+k,0]=init_to_Ai_Aj_Ak_count[i,j,k]

for i in range(0,Ai_Aj_Ak_to_Ai_Aj_Ak_prob.shape[0]):
    for j in range(0,Ai_Aj_Ak_to_Ai_Aj_Ak_prob.shape[1]):
        for k in range(0,Ai_Aj_Ak_to_Ai_Aj_Ak_prob.shape[2]):
            for l in range(0,Ai_Aj_Ak_to_Ai_Aj_Ak_prob.shape[3]): 
                for m in range(0,Ai_Aj_Ak_to_Ai_Aj_Ak_prob.shape[4]): 
                    for n in range(0,Ai_Aj_Ak_to_Ai_Aj_Ak_prob.shape[5]): 
                        if(Ai_Aj_Ak_to_Ai_Aj_Ak_count[i,j,k].sum() == 0):
                            print("no entries")
                        else:
                            Ai_Aj_Ak_to_Ai_Aj_Ak_prob[i,j,k,l,m,n] = Ai_Aj_Ak_to_Ai_Aj_Ak_count[i,j,k,l,m,n] / Ai_Aj_Ak_to_Ai_Aj_Ak_count[i,j,k].sum()


for i in range(0,Ai_Aj_Ak_to_survive_death_prob.shape[0]):
     for j in range(0,Ai_Aj_Ak_to_survive_death_prob.shape[1]):
         for k in range(0,Ai_Aj_Ak_to_survive_death_prob.shape[2]):
            if(Ai_Aj_Ak_to_survive_death_count[i,j,k].sum() == 0):
                print("no entries")
            else:    
                Ai_Aj_Ak_to_survive_death_prob[i,j,k] = Ai_Aj_Ak_to_survive_death_count[i,j,k] / Ai_Aj_Ak_to_survive_death_count[i,j,k].sum() 


Ai_Aj_Ak_to_survive_death_count_2d=np.zeros((6*6*6,2))
Ai_Aj_Ak_to_survive_death_prob_2d=np.zeros((6*6*6,2))

for i in range(0,Ai_Aj_Ak_to_survive_death_count.shape[0]):
    for j in range(0,Ai_Aj_Ak_to_survive_death_count.shape[1]):
        for k in range(0,Ai_Aj_Ak_to_survive_death_count.shape[2]):            
            Ai_Aj_Ak_to_survive_death_count_2d[6*6*i+6*j+k]=Ai_Aj_Ak_to_survive_death_count[i,j,k]
            Ai_Aj_Ak_to_survive_death_prob_2d[6*6*i+6*j+k]=Ai_Aj_Ak_to_survive_death_prob[i,j,k]


np.savetxt('init_to_Ai_Aj_Ak_prob_2d.csv', init_to_Ai_Aj_Ak_prob_2d, delimiter=',') 
np.savetxt('init_to_Ai_Aj_Ak_count_2d.csv', init_to_Ai_Aj_Ak_count_2d, delimiter=',') 
np.savetxt('Ai_Aj_Ak_to_survive_death_count_2d.csv', Ai_Aj_Ak_to_survive_death_count_2d, delimiter=',') 
np.savetxt('Ai_Aj_Ak_to_survive_death_prob_2d.csv', Ai_Aj_Ak_to_survive_death_prob_2d, delimiter=',') 


Ai_Aj_Ak_to_Ai_Aj_Ak_count_2d=np.zeros((6*6*6,6*6*6))
Ai_Aj_Ak_to_Ai_Aj_Ak_prob_2d=np.zeros((6*6*6,6*6*6))

for i in range(0,Ai_Aj_Ak_to_Ai_Aj_Ak_prob.shape[0]):
    for j in range(0,Ai_Aj_Ak_to_Ai_Aj_Ak_prob.shape[1]):
        for k in range(0,Ai_Aj_Ak_to_Ai_Aj_Ak_prob.shape[2]):
            for l in range(0,Ai_Aj_Ak_to_Ai_Aj_Ak_prob.shape[3]): 
                for m in range(0,Ai_Aj_Ak_to_Ai_Aj_Ak_prob.shape[4]): 
                    for n in range(0,Ai_Aj_Ak_to_Ai_Aj_Ak_prob.shape[5]): 
                        Ai_Aj_Ak_to_Ai_Aj_Ak_count_2d[i*6*6+j*6+k,l*6*6+m*6+n]=Ai_Aj_Ak_to_Ai_Aj_Ak_count[i,j,k,l,m,n]
                        Ai_Aj_Ak_to_Ai_Aj_Ak_prob_2d[i*6*6+j*6+k,l*6*6+m*6+n]=Ai_Aj_Ak_to_Ai_Aj_Ak_prob[i,j,k,l,m,n]


np.savetxt('Ai_Aj_Ak_to_Ai_Aj_Ak_count_2d.csv', Ai_Aj_Ak_to_Ai_Aj_Ak_count_2d, delimiter=',') 
np.savetxt('Ai_Aj_Ak_to_Ai_Aj_Ak_prob_2d.csv', Ai_Aj_Ak_to_Ai_Aj_Ak_prob_2d, delimiter=',') 


#import pdb;pdb.set_trace();
