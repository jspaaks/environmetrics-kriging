% This file creates 3 variables (of type "double", "char", and 
% "double") and writes these to the filename indicated in the
% variable "file_str".
%
% After the file has been written, it is automatically opened 
% using the MATLAB "system" function
 

clc            % clears the command window
clear          % clears the workspace
fclose('all'); % closes any opened files


var01 = 14.3
var02 = 'This is the second line'
var03 = 5

% name of file that the data should be written to:
file_str = 'file_io_test.txt'  

% open the indicated file for writing 
% (as opposed to reading) by the 'w' argument:
fid = fopen(file_str,'w');

% Write the text 'variable 1 = ' into the file and 
% subsequently append variable "var01" to the text 
% already written. Format the value of "var01" 
% according to the format string '%6.3f' (floating 
% point number of 6 characters including the '.' character
% 3 of which are decimals):
fprintf(fid,'variable 1 = %6.3f',var01);

% write the end-of-line character sequence:
fprintf(fid,'\r\n');

% Write the text 'variable 2 = ' into the file and 
% subsequently append variable "var02" to the text 
% already written. Format the value of "var02" 
% according to the format string '%s' (string/char array):
fprintf(fid,'variable 2 = %s',var02);

% write the end-of-line character sequence:
fprintf(fid,'\r\n');


% Write the text 'variable 3 = ' into the file and 
% subsequently append variable "var03" to the text 
% already written. Format the value of "var03" 
% according to the format string '%u' (unsigned integer):
fprintf(fid,'variable 3 = %u',var03);

% write the end-of-line character sequence:
fprintf(fid,'\r\n');

% close the file to complete the procedure:
fclose(fid);

% After the file has been successfully written and closed,
% it may be viewed in any text editor (notepad, wordpad,
% tinn, matlab m-file editor, etc). opening the file can 
% also be automated by using MATLAB's "system" function 
% (see >>doc system):
system(['notepad.exe ' file_str]);

% Note that to return focus to the matlab window, the 
% ascii-file should be closed by clicking the little
% cross in the upper-right part of the notepad window. 


