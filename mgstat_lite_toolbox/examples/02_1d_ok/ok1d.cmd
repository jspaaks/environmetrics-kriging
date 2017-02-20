# Mgstat Lite command file generated on: 14-Nov-2006 13:47:12
# mode: prediction

# data of variable "testvar":
data(testvar): 'obs_testvar.eas', x=1, v=2;

# semivariogram model of variable "testvar":
variogram(testvar): 0 Nug(0) + 1 Sph(2);

# prediction locations:
data(): 'pred_pos.eas', x=1;

# Missing value character(s):
set mv: '-1';

# gstat output will be written to:
set output: 'ok1d.out';

# set gstat debug level:
set debug = 2;

# set name of log file to which gstat must write:
set logfile: 'ok1d.log';

