#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Dec 30 14:29:12 2023

@author: olab
"""


import numpy as np
import pandas as pd
import os
import json
#import pickle as pk
#import scipy.io as sio
import csv
import glob
#import codecs


fileDirectory='/Users/olab/tolmanRM/home'

#fileDirectory='/home'

results = fileDirectory+'/shared/MBMF_Hab/mbmf_badvols/'


participants_control_patient = pd.read_excel(fileDirectory + '/shared/MBMF_Hab/R01_Participants_Control_Patient_Info.xlsx')

   
sub_path =fileDirectory+'/shared/MBMF_Hab/MBMF_Hab_bids/derivatives/fmriprep-23p1p3/'



allFiles=os.listdir(sub_path)

sublist = [f for f in allFiles if f[0:3] == 'sub' and f[-4:] != 'html' ]


fd_threshold_runs=[]

    
new_confounds_mbmf_summaryStats = pd.DataFrame(columns = (['participant',
                                                    'badVols_run1',
                                                    'badVols_run2']),dtype='object')



for f in sublist:
    
    idx = f[4:]==participants_control_patient.ScanID
    cp=participants_control_patient.Control_Patient[idx]

    

    
    path = fileDirectory+'/shared/MBMF_Hab/MBMF_Hab_bids/derivatives/fmriprep-23p1p3/' + f + '/func/'

    files = os.listdir(path)


    summary = pd.DataFrame(columns = (['participant']), dtype='object')

    os.chdir(path)


    #os.chdir(f)
    print(f)
    #funcData = 'func/'
    #print(funcData)
    #os.chdir(funcData)
    data_mbmfRun1 = pd.read_csv (f + '_task-MBMF_run-1_desc-confounds_timeseries.tsv', sep = '\t')
    data_mbmfRun2 = pd.read_csv (f + '_task-MBMF_run-2_desc-confounds_timeseries.tsv', sep = '\t')
    
    
    
    scubbedVols = pd.DataFrame(columns = ([]))

 
    new_confounds_mbmfRun1 = pd.DataFrame(columns = ([ 'framewise_displacement',
                                                       'badVolumes']), dtype='object')
    
    new_confounds_mbmfRun2 = pd.DataFrame(columns = ([ 'framewise_displacement', 
                                                       'badVolumes']), dtype='object')
    

    
    
    
    new_confounds_mbmfRun1['framewise_displacement'] = data_mbmfRun1.framewise_displacement
    new_confounds_mbmfRun1.loc[0,'framewise_displacement'] = 0
    
    fd =new_confounds_mbmfRun1['framewise_displacement'] 
    q3, q1 = np.percentile(fd, [75 ,25])
    iqr = q3 - q1

    threshold = q3+1.5*iqr;
    
    #threshold_std = np.mean(fd[1:])+2.5*np.std(fd[1:])
    
    fd_threshold_runs.append(threshold)
    
    
    
    
    new_confounds_mbmfRun2['framewise_displacement'] = data_mbmfRun2.framewise_displacement
    new_confounds_mbmfRun2.loc[0,'framewise_displacement'] = 0
    
    
    fd =new_confounds_mbmfRun2['framewise_displacement'] 
    q3, q1 = np.percentile(fd, [75 ,25])
    iqr = q3 - q1

    threshold = q3+1.5*iqr;
    
    #threshold_std = np.mean(fd[1:])+2.5*np.std(fd[1:])
    
    fd_threshold_runs.append(threshold)


# estimate motion threshold (0.77) based upon population distribution 522 runs of both controls and patients fMRI motion data

x=np.asarray(fd_threshold_runs)

q3, q1 = np.percentile(x, [75 ,25])
iqr = q3 - q1

threshold = q3+1.5*iqr;  # threshold =0.77 


# Use the estimated motion threshold (0.77) for participant exclusion due to too much head motion
for f in sublist:
    
    idx = f[4:]==participants_control_patient.ScanID
    cp=participants_control_patient.Control_Patient[idx]

    

    
    path = fileDirectory+'/shared/MBMF_Hab/MBMF_Hab_bids/derivatives/fmriprep-23p1p3/' + f + '/func/'

    files = os.listdir(path)


    summary = pd.DataFrame(columns = (['participant']), dtype='object')

    os.chdir(path)


    #os.chdir(f)
    print(f)
    #funcData = 'func/'
    #print(funcData)
    #os.chdir(funcData)
    data_mbmfRun1 = pd.read_csv (f + '_task-MBMF_run-1_desc-confounds_timeseries.tsv', sep = '\t')
    data_mbmfRun2 = pd.read_csv (f + '_task-MBMF_run-2_desc-confounds_timeseries.tsv', sep = '\t')
    
    
    
    scubbedVols = pd.DataFrame(columns = ([]))

 
    new_confounds_mbmfRun1 = pd.DataFrame(columns = ([ 'framewise_displacement',
                                                       'badVolumes']), dtype='object')
    
    new_confounds_mbmfRun2 = pd.DataFrame(columns = ([ 'framewise_displacement', 
                                                       'badVolumes']), dtype='object')
    

    
    
    
    new_confounds_mbmfRun1['framewise_displacement'] = data_mbmfRun1.framewise_displacement
    new_confounds_mbmfRun1.loc[0,'framewise_displacement'] = 0
    
    
    
    fd_threshold = 0.77
    FD_run1 = new_confounds_mbmfRun1['framewise_displacement'] 
    badVols_run1 = FD_run1>fd_threshold
    new_confounds_mbmfRun1['badVolumes'] = badVols_run1
    new_confounds_mbmfRun1['badVolumes'] = new_confounds_mbmfRun1['badVolumes']*1
    num_bad_vols_run1 = sum(badVols_run1)
    percent_bad_vols_run1 = num_bad_vols_run1/len(data_mbmfRun1)*100
    print(percent_bad_vols_run1 )
    
    new_confounds_mbmfRun1_clear = new_confounds_mbmfRun1.drop(new_confounds_mbmfRun1[new_confounds_mbmfRun1.badVolumes == 1].index)
    
    
    new_confounds_mbmfRun2['framewise_displacement'] = data_mbmfRun2.framewise_displacement
    new_confounds_mbmfRun2.loc[0,'framewise_displacement'] = 0
    
    
    
    
    fd_threshold = 0.77
    FD_run2 = new_confounds_mbmfRun2['framewise_displacement'] 
    badVols_run2 = FD_run2>fd_threshold
    new_confounds_mbmfRun2['badVolumes'] = badVols_run2
    new_confounds_mbmfRun2['badVolumes'] = new_confounds_mbmfRun2['badVolumes']*1
    num_bad_vols_run2 = sum(badVols_run2)
    percent_bad_vols_run2 = num_bad_vols_run2/len(data_mbmfRun2)*100
    print(percent_bad_vols_run2 )
    
    
    new_confounds_mbmfRun2_clear = new_confounds_mbmfRun2.drop(new_confounds_mbmfRun2[new_confounds_mbmfRun2.badVolumes == 1].index)
    
   
    
    new_confounds_mbmf_summaryStats = new_confounds_mbmf_summaryStats._append({'participant':f, 'badVols_run1':percent_bad_vols_run1, 'badVols_run2':percent_bad_vols_run2}, ignore_index = True)
    
  

import matplotlib.pyplot as plt
plt.hist(x)
plt.show() 
    


exclude_participant=[]

for i in range(0,new_confounds_mbmf_summaryStats.shape[0]):
    bV_run1 = new_confounds_mbmf_summaryStats.loc[i,'badVols_run1']
    bV_run2 = new_confounds_mbmf_summaryStats.loc[i,'badVols_run2']
    
    if bV_run1>=15 or bV_run2>=15:
    
        exclude_participant.append(new_confounds_mbmf_summaryStats.loc[i,'participant'])
        
            
print(exclude_participant)  # excluded participant IDs based upon fMRI motion 
    
    
    
    