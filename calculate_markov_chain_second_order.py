import numpy as np 


#  Columns 1 through 8
#    {'icustayid'}    {'charttime'}    {'bloc'}    {'subject_id'}    {'re_admission'}    {'died_in_hosp'}    {'died_within_48...'}    {'mortality_90d'}
#  Column 9          10                         11                       12                    13                     14                     15 
#    {'archetype'}  
Patient_Trajectories = np.loadtxt("Patient_Trajectories.csv", delimiter = "," , skiprows = 1 )

# Find unique stays ids
distinct_patients_list=np.unique(Patient_Trajectories[:,0])
patient_traj_list=[]

## Get all patient trajectories 
for i in range(0,len(distinct_patients_list)):
    
    # Find the indices that belongs to the current stay
    Patient_Trajectories_idx = np.where( Patient_Trajectories[:,0] == distinct_patients_list[i] )
    
    # Get the trajectoirs for this particular stay
    traj_list = Patient_Trajectories[Patient_Trajectories_idx, : ]
    
    ## Put that trajectory into the list
    if(i==0):
        patient_traj_list=[traj_list]
    else:
        patient_traj_list.append(traj_list)

init_to_Ai_Aj_count=np.zeros( (6,6) )
Ai_Aj_to_Ai_Aj_count= np.zeros((6,6,6,6))
Ai_Aj_to_survive_death_count =np.zeros((6,6,2))


## Loop over all patient trajectories
## Compute init_to_Ai_Aj_count, Ai_Aj_to_Ai_Aj_count, Ai_Aj_to_survive_death_count (end state)
for i in range(0,len(patient_traj_list)):
    ## Get the current trajectory
    traj = patient_traj_list[i]
    ## Go through each time point
    number_of_time_points = traj.shape[1]
    for j in range(0, number_of_time_points):
        if number_of_time_points == 1:
            continue
        ## number of points equals  2 
        elif number_of_time_points == 2:
            if j == 0:
                continue
            else:
                ## example a b 
                ##         ^ ^
                ##         p c
                ## update init_to_Ai_Aj
                Archetype_cur = int(traj[0,j,8])
                Archetype_prev = int(traj[0,j-1,8])                
                init_to_Ai_Aj_count[ Archetype_prev - 1, Archetype_cur - 1] += 1
                ## update Ai_Aj_to_survive_death_count
                if(traj[0,j,5] == 1):
                    Ai_Aj_to_survive_death_count[ Archetype_prev - 1 , Archetype_cur - 1, 1 ] += 1
                else:
                    Ai_Aj_to_survive_death_count[ Archetype_prev - 1 , Archetype_cur - 1, 0 ] += 1
        elif number_of_time_points == 3:
            if(j==0):
                continue
            elif(j==1):
                ## example a b c   
                ##         ^ ^
                ##         p c
                Archetype_cur = int(traj[0,j,8])
                Archetype_prev = int(traj[0,j-1,8])                
                init_to_Ai_Aj_count[ Archetype_prev - 1, Archetype_cur - 1] += 1


                if(traj[0,j,5] == 1):
                    Ai_Aj_to_survive_death_count[ Archetype_prev - 1 , Archetype_cur - 1, 1 ] += 1
                else:
                    Ai_Aj_to_survive_death_count[ Archetype_prev - 1 , Archetype_cur - 1, 0 ] += 1


            ## In the middle of states, update Ai_Aj_to_Ai_Aj_count
            elif( j == 2):
                ## example   a b c 
                ##           ^ ^ ^
                ##          pp p c
                Archetype_prev_prev = int(traj[0,j-2,8])
                Archetype_prev = int(traj[0,j-1,8])
                Archetype_cur = int(traj[0,j,8])
                Ai_Aj_to_Ai_Aj_count[ Archetype_prev_prev - 1, Archetype_prev - 1, Archetype_prev - 1, Archetype_cur - 1] += 1
                

                if(traj[0,j,5] == 1):
                    Ai_Aj_to_survive_death_count[ Archetype_prev - 1 , Archetype_cur - 1, 1 ] += 1
                else:
                    Ai_Aj_to_survive_death_count[ Archetype_prev - 1 , Archetype_cur - 1, 0 ] += 1




        else:
            if(j==0):
                continue
            elif(j==1):
                ## example a b c d   
                ##         ^ ^
                ##         p c
                Archetype_cur = int(traj[0,j,8])
                Archetype_prev = int(traj[0,j-1,8])                
                init_to_Ai_Aj_count[ Archetype_prev - 1, Archetype_cur - 1] += 1


                if(traj[0,j,5] == 1):
                    Ai_Aj_to_survive_death_count[ Archetype_prev - 1 , Archetype_cur - 1, 1 ] += 1
                else:
                    Ai_Aj_to_survive_death_count[ Archetype_prev - 1 , Archetype_cur - 1, 0 ] += 1



            ## In the middle of states, update Ai_Aj_to_Ai_Aj_count
            elif( j < number_of_time_points - 1):
                ## example   a b c d 
                ##           ^ ^ ^
                ##          pp p c
                Archetype_prev_prev = int(traj[0,j-2,8])
                Archetype_prev = int(traj[0,j-1,8])
                Archetype_cur = int(traj[0,j,8])
                Ai_Aj_to_Ai_Aj_count[ Archetype_prev_prev - 1, Archetype_prev - 1, Archetype_prev - 1, Archetype_cur - 1] += 1

                if(traj[0,j,5] == 1):
                    Ai_Aj_to_survive_death_count[ Archetype_prev - 1 , Archetype_cur - 1, 1 ] += 1
                else:
                    Ai_Aj_to_survive_death_count[ Archetype_prev - 1 , Archetype_cur - 1, 0 ] += 1



            ## reach to the end states, update Ai_Aj_to_Ai_Aj_count and Ai_Aj_to_survive_death_count
            else:
                ## example   a b c d
                ##             ^ ^ ^
                ##            pp p c
                Archetype_prev_prev = int(traj[0,j-2,8])
                Archetype_prev = int(traj[0,j-1,8])
                Archetype_cur = int(traj[0,j,8])
                Ai_Aj_to_Ai_Aj_count[ Archetype_prev_prev - 1, Archetype_prev - 1, Archetype_prev - 1, Archetype_cur - 1] += 1
                if(traj[0,j,5] == 1):
                    Ai_Aj_to_survive_death_count[ Archetype_prev - 1 , Archetype_cur - 1, 1 ] += 1
                else:
                    Ai_Aj_to_survive_death_count[ Archetype_prev - 1 , Archetype_cur - 1, 0 ] += 1

init_to_Ai_Aj_prob = np.zeros( (6,6) )
Ai_Aj_to_Ai_Aj_prob = np.zeros((6,6,6,6))
Ai_Aj_to_survive_death_prob = np.zeros((6,6,2))

init_to_Ai_Aj_prob = init_to_Ai_Aj_count / init_to_Ai_Aj_count.sum()

for i in range(0, Ai_Aj_to_Ai_Aj_prob.shape[0]):
    for j in range(0, Ai_Aj_to_Ai_Aj_prob.shape[1]):
        for k in range(0, Ai_Aj_to_Ai_Aj_prob.shape[2]):
            for l in range(0, Ai_Aj_to_Ai_Aj_prob.shape[3]): 
                if(Ai_Aj_to_Ai_Aj_count[i,j].sum() == 0):
                    print("no entries")
                else:
                    Ai_Aj_to_Ai_Aj_prob[i, j, k, l] = Ai_Aj_to_Ai_Aj_count[i, j, k, l] / Ai_Aj_to_Ai_Aj_count[i, j].sum()


for i in range(0,Ai_Aj_to_survive_death_prob.shape[0]):
    for j in range(0,Ai_Aj_to_survive_death_prob.shape[1]):
        if(Ai_Aj_to_survive_death_count[i,j].sum() == 0):
            print("no entries")
        else:    
            Ai_Aj_to_survive_death_prob[i,j] = Ai_Aj_to_survive_death_count[i,j]/Ai_Aj_to_survive_death_count[i,j].sum() 

Ai_Aj_to_survive_death_count_2d = np.zeros((6*6,2))
Ai_Aj_to_survive_death_prob_2d = np.zeros((6*6,2))

for i in range(0, Ai_Aj_to_survive_death_count.shape[0]):
    for j in range(0, Ai_Aj_to_survive_death_count.shape[1]):
        Ai_Aj_to_survive_death_count_2d[6*i+j] = Ai_Aj_to_survive_death_count[i,j]
        Ai_Aj_to_survive_death_prob_2d[6*i+j] = Ai_Aj_to_survive_death_prob[i,j]

np.savetxt('init_to_Ai_Aj_prob.csv', init_to_Ai_Aj_prob, delimiter=',') 
np.savetxt('init_to_Ai_Aj_count.csv', init_to_Ai_Aj_count, delimiter=',') 
np.savetxt('Ai_Aj_to_survive_death_count_2d.csv', Ai_Aj_to_survive_death_count_2d, delimiter=',') 
np.savetxt('Ai_Aj_to_survive_death_prob_2d.csv', Ai_Aj_to_survive_death_prob_2d, delimiter=',') 

Ai_Aj_to_Ai_Aj_count_2d = np.zeros((6*6,6*6))
Ai_Aj_to_Ai_Aj_prob_2d = np.zeros((6*6,6*6))


for i in range(0, Ai_Aj_to_Ai_Aj_prob.shape[0]):
    for j in range(0, Ai_Aj_to_Ai_Aj_prob.shape[1]):
        for k in range(0, Ai_Aj_to_Ai_Aj_prob.shape[2]):
            for l in range(0, Ai_Aj_to_Ai_Aj_prob.shape[3]): 
                Ai_Aj_to_Ai_Aj_count_2d[i*6+j,k*6+l] = Ai_Aj_to_Ai_Aj_count[i,j,k,l]
                Ai_Aj_to_Ai_Aj_prob_2d[i*6+j,k*6+l] = Ai_Aj_to_Ai_Aj_prob[i,j,k,l]

np.savetxt('Ai_Aj_to_Ai_Aj_count_2d.csv', Ai_Aj_to_Ai_Aj_count_2d, delimiter=',') 
np.savetxt('Ai_Aj_to_Ai_Aj_prob_2d.csv', Ai_Aj_to_Ai_Aj_prob_2d, delimiter=',') 


