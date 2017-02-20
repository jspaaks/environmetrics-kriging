#
# Local ordinary block kriging at non-gridded locations
#
data(Pb): 'metals.eas', x=1, y=2, v=3, min=30, max=50, radius=500; # local neighbourhood

variogram(Pb): 1.32e+04 Nug(0) + 4.24e+05 Sph(375);

data(): 'predlocs.eas', x=1, y=2; # prediction locations

blocksize: dx=40, dy=40;          # 40x40 block averages

set output = 'pb_ok.out';         # ascii output file
