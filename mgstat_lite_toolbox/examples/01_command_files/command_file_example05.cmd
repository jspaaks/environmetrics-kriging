#
# Stratified ordinary kriging (within-category ordinary kriging)
# Two categories: 0 and 1

data(poros0): 'poros0.eas', x=1, y=2, v=3, min=25, max=75, radius=55;  # where category = 0
data(poros1): 'poros1.eas', x=1, y=2, v=3, min=25, max=75, radius=55;  # where category = 1

variogram(poros0): 0.004 Nug(0) + 0.548 Sph(35);
variogram(poros1): 0.716 Sph (12);

# the mask map is 0 for poros0 locations, 1 for poros1
mask: 'parts_0_1';

# stratified mode: one map holds predictions for all vars:
predictions: 'sok_poros_pre';

# another the prediction variances for all vars:
variances:   'sok_poros_var';
