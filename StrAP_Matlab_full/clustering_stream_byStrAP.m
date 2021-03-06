%%%  the stream is clustered by  StrAP v1.1
%%%  differring from StrAP v1.0, the PH parameter 'lambda' is adapted by
%%%  e-greedy search and gaussian regression process
%%%
%%%  by Xiangliang Zhang @ INRIA and University Paris Sud 11, Jan 2009.
%%%  xlzhang@lri.fr, xiangliangzhang@gmail.com
%%%
%%%  CopyRight (c) 2008-2010, Xiangliang ZHANG
%%%  All rights reserved.

clear
close all

path_gp=[pwd '/gpml-matlab'];
addpath(path_gp)

%%%  test on the KDDcup 99 data
%%%% load the data  all by once
data=load('data/kddcup_1_per_conti.txt');
label=load('data/kddcup_1_per_label_23','%s');
[nb_data_to_process, nb_f]=  size(data);
B_n=1000;
random_start = 3;  %%%in first "random_start" restarting steps, 'lambda' is set randomly in the given range

%  %%%%%  use Maximum Size of Reservoir as restart triggering criterion
%  [model,pie_chart,label_given,restart,ssii,option1,option2,option3]=stream_AP_load(data,B_n,label,nb_data_to_process,nb_f,...
%    'distance', 2, ...
%    'X',10000,...
%    'damp',0.8,...
%    'gp',...
%    'Max_cache',300);       %%% if 'Max_cache'  is used, 'PH' will be disabled

%%%%%%  use PH as restart triggering criterion
[model,pie_chart,label_given,restart,ssii,option1,option2,option3,option4] = stream_AP_load (data, B_n,label,nb_data_to_process,nb_f,...
    'distance', 2, ...
    'PH',...
    'lambda',[20 30],...
    'damp',0.8,...
    'gp',...           %% or 'egreedy',  or nothing (use fixed value of 'lambda')
    'random_start',random_start,...
    'X',10000);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%% or  read the data line by line (like streaming) if the file is too large
% fid_data = fopen('data/kddcup_1_per_conti.txt','r');
% fid_label = fopen('data/kddcup_1_per_label_23','r');
% 
% nb_data_to_process = 49402;
% B_n=1000;
% nb_f=34;
% 
%  [model,pie_chart,label_given,restart,ssii,option1,option2,option3,option4] = stream_AP_read (fid_data,B_n,fid_label,nb_data_to_process,nb_f,...
%    'distance', 2, ...
%    'is_label_num',1,...   %%% the label is numerical (1) or categorical(0)
%    'PH',...
%    'lambda',[20 30],...
%    'damp',0.8,...
%    'gp',...          %% or 'egreedy',  or nothing (use fixed value of 'lambda')
%    'random_start',random_start,...
%    'X',10000);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% final accuracy
[u1,u2]=uniq_my(label_given);
disp(sprintf('Outliers = %4.2f%% (%d)',100*u2(1)/sum(u2),u2(1)));
disp(sprintf('Error = %4.2f%% (%d)',100*u2(2)/sum(u2),u2(2)));
disp(sprintf('Correct = %4.2f%%  (%d)',100*u2(3)/sum(u2),u2(3)));

%%%%%%%%  draw the accuracy along time
draw_accu(label_given,restart);    %%% draw_accu(label_given); without restart

%%%%%%%%  draw the purity along time (with the number of clusters)
draw_purity(ssii);

%%%%%%%%  online clustering output demonstrated by bars
model_online_report(ssii)

