%s2 = serial('COM2','BaudRate',9600);
%fopen(s2);
currentFolder = pwd;
addpath (currentFolder);
addpath ([currentFolder,'\cfpn']);
addpath ([currentFolder,'\current_monitor']);
% addpath ([currentFolder,'\data']);
addpath ([currentFolder,'\refgen']);
addpath ([currentFolder,'\sweep_hist']);
addpath ([currentFolder,'\test_row']);
addpath ([currentFolder,'\startup']);
addpath ([currentFolder,'\noi_hist']);
addpath ([currentFolder,'\color_gui']);