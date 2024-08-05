# # [Simply Running OWENS](@id simple1)
# 
# In this example, we show the first level of what is going on behind the precompiled binary
# Running julia directly with this as a starting point could make things like automating many runs in 
# a way that is not compatible with the current interface, but your design design fits.
#
# OWENS is comprised of many building blocks.  These series of examples progressively shows the internals
# of several of the key building blocks a new user might employ for their projects.  Fundamentally, OWENS has been 
# built to be as generalizable as possible. The lowest level of building blocks enable this, however, there are many
# common use cases for which helper functions have been developed, such as for meshing certain standard architectures
# and calculating and applying sectional properties to these architectures. The figure below summarizes this at a high 
# level.  
# TODO: yml file definition and inputs expanded 
#
# ![](../assets/OWENS_Example_Figure_Building_Blocks.png)
#
#-
#md # !!! tip
#md #     This example is also available as a Jupyter notebook todo: get link working:
#-

import OWENS
using HDF5
using Test
using YAML
using OrderedCollections

runpath = splitdir(@__FILE__)[1]

OWENS_Options = OWENS.MasterInput("$runpath/modeling_options_OWENS_windioExample.yml")

WINDIO_filename = "$runpath/WINDIO_example.yaml"
windio = YAML.load_file(WINDIO_filename; dicttype=OrderedCollections.OrderedDict{Symbol,Any})
# NuMad_materials_xlscsv_file = windio
OWENS.runOWENSWINDIO(windio,OWENS_Options,runpath)

# Alternatively OWENS.runOWENSWINDIO(WINDIO_filename,OWENS_Options,runpath)

file = "$runpath/InitialDataOutputs_UNIT.h5"
t_UNIT = HDF5.h5read(file,"t")
aziHist_UNIT = HDF5.h5read(file,"aziHist")
OmegaHist_UNIT = HDF5.h5read(file,"OmegaHist")
OmegaDotHist_UNIT = HDF5.h5read(file,"OmegaDotHist")
gbHist_UNIT = HDF5.h5read(file,"gbHist")
gbDotHist_UNIT = HDF5.h5read(file,"gbDotHist")
gbDotDotHist_UNIT = HDF5.h5read(file,"gbDotDotHist")
FReactionHist_UNIT = HDF5.h5read(file,"FReactionHist")
FTwrBsHist_UNIT = HDF5.h5read(file,"FTwrBsHist")
genTorque_UNIT = HDF5.h5read(file,"genTorque")
genPower_UNIT = HDF5.h5read(file,"genPower")
torqueDriveShaft_UNIT = HDF5.h5read(file,"torqueDriveShaft")
uHist_UNIT = HDF5.h5read(file,"uHist")
uHist_prp_UNIT = HDF5.h5read(file,"uHist_prp")
epsilon_x_hist_UNIT = HDF5.h5read(file,"epsilon_x_hist")
epsilon_y_hist_UNIT = HDF5.h5read(file,"epsilon_y_hist") 
epsilon_z_hist_UNIT = HDF5.h5read(file,"epsilon_z_hist")
kappa_x_hist_UNIT = HDF5.h5read(file,"kappa_x_hist")
kappa_y_hist_UNIT = HDF5.h5read(file,"kappa_y_hist")
kappa_z_hist_UNIT = HDF5.h5read(file,"kappa_z_hist") 
massOwens_UNIT = HDF5.h5read(file,"massOwens")
stress_U_UNIT = HDF5.h5read(file,"stress_U")
SF_ult_U_UNIT = HDF5.h5read(file,"SF_ult_U")
SF_buck_U_UNIT = HDF5.h5read(file,"SF_buck_U")
stress_L_UNIT = HDF5.h5read(file,"stress_L")
SF_ult_L_UNIT = HDF5.h5read(file,"SF_ult_L")
SF_buck_L_UNIT = HDF5.h5read(file,"SF_buck_L")
stress_TU_UNIT = HDF5.h5read(file,"stress_TU")
SF_ult_TU_UNIT = HDF5.h5read(file,"SF_ult_TU")
SF_buck_TU_UNIT = HDF5.h5read(file,"SF_buck_TU")
stress_TL_UNIT = HDF5.h5read(file,"stress_TL")
SF_ult_TL_UNIT = HDF5.h5read(file,"SF_ult_TL")
SF_buck_TL_UNIT = HDF5.h5read(file,"SF_buck_TL")
topstrainout_blade_U_UNIT = HDF5.h5read(file,"topstrainout_blade_U")
topstrainout_blade_L_UNIT = HDF5.h5read(file,"topstrainout_blade_L")
topstrainout_tower_U_UNIT = HDF5.h5read(file,"topstrainout_tower_U")
topstrainout_tower_L_UNIT = HDF5.h5read(file,"topstrainout_tower_L")
topDamage_blade_U_UNIT = HDF5.h5read(file,"topDamage_blade_U")
topDamage_blade_L_UNIT = HDF5.h5read(file,"topDamage_blade_L")
topDamage_tower_U_UNIT = HDF5.h5read(file,"topDamage_tower_U")
topDamage_tower_L_UNIT = HDF5.h5read(file,"topDamage_tower_L")


file = "$runpath/InitialDataOutputs.h5"
t = HDF5.h5read(file,"t")
aziHist = HDF5.h5read(file,"aziHist")
OmegaHist = HDF5.h5read(file,"OmegaHist")
OmegaDotHist = HDF5.h5read(file,"OmegaDotHist")
gbHist = HDF5.h5read(file,"gbHist")
gbDotHist = HDF5.h5read(file,"gbDotHist")
gbDotDotHist = HDF5.h5read(file,"gbDotDotHist")
FReactionHist = HDF5.h5read(file,"FReactionHist")
FTwrBsHist = HDF5.h5read(file,"FTwrBsHist")
genTorque = HDF5.h5read(file,"genTorque")
genPower = HDF5.h5read(file,"genPower")
torqueDriveShaft = HDF5.h5read(file,"torqueDriveShaft")
uHist = HDF5.h5read(file,"uHist")
uHist_prp = HDF5.h5read(file,"uHist_prp")
epsilon_x_hist = HDF5.h5read(file,"epsilon_x_hist")
epsilon_y_hist = HDF5.h5read(file,"epsilon_y_hist")  
epsilon_z_hist = HDF5.h5read(file,"epsilon_z_hist")
kappa_x_hist = HDF5.h5read(file,"kappa_x_hist")
kappa_y_hist = HDF5.h5read(file,"kappa_y_hist")
kappa_z_hist = HDF5.h5read(file,"kappa_z_hist") 
massOwens = HDF5.h5read(file,"massOwens")
stress_U = HDF5.h5read(file,"stress_U")
SF_ult_U = HDF5.h5read(file,"SF_ult_U")
SF_buck_U = HDF5.h5read(file,"SF_buck_U")
stress_L = HDF5.h5read(file,"stress_L")
SF_ult_L = HDF5.h5read(file,"SF_ult_L")
SF_buck_L = HDF5.h5read(file,"SF_buck_L")
stress_TU = HDF5.h5read(file,"stress_TU")
SF_ult_TU = HDF5.h5read(file,"SF_ult_TU")
SF_buck_TU = HDF5.h5read(file,"SF_buck_TU")
stress_TL = HDF5.h5read(file,"stress_TL")
SF_ult_TL = HDF5.h5read(file,"SF_ult_TL")
SF_buck_TL = HDF5.h5read(file,"SF_buck_TL")
topstrainout_blade_U = HDF5.h5read(file,"topstrainout_blade_U")
topstrainout_blade_L = HDF5.h5read(file,"topstrainout_blade_L")
topstrainout_tower_U = HDF5.h5read(file,"topstrainout_tower_U")
topstrainout_tower_L = HDF5.h5read(file,"topstrainout_tower_L")
topDamage_blade_U = HDF5.h5read(file,"topDamage_blade_U")
topDamage_blade_L = HDF5.h5read(file,"topDamage_blade_L")
topDamage_tower_U = HDF5.h5read(file,"topDamage_tower_U")
topDamage_tower_L = HDF5.h5read(file,"topDamage_tower_L")

atol = 1e-8
@test isapprox(t_UNIT,t;atol)
@test isapprox(aziHist_UNIT,aziHist;atol)
@test isapprox(OmegaHist_UNIT,OmegaHist;atol)
@test isapprox(OmegaDotHist_UNIT,OmegaDotHist;atol)
@test isapprox(gbHist_UNIT,gbHist;atol)
@test isapprox(gbDotHist_UNIT,gbDotHist;atol)
@test isapprox(gbDotDotHist_UNIT,gbDotDotHist;atol)
@test isapprox(FReactionHist_UNIT,FReactionHist;atol)
@test isapprox(FTwrBsHist_UNIT,FTwrBsHist;atol)
@test isapprox(genTorque_UNIT,genTorque;atol)
@test isapprox(genPower_UNIT,genPower;atol)
@test isapprox(torqueDriveShaft_UNIT,torqueDriveShaft;atol)
@test isapprox(uHist_UNIT,uHist;atol)
@test isapprox(uHist_prp_UNIT,uHist_prp;atol)
@test isapprox(epsilon_x_hist_UNIT,epsilon_x_hist;atol)
@test isapprox(epsilon_y_hist_UNIT,epsilon_y_hist;atol)
@test isapprox(epsilon_z_hist_UNIT,epsilon_z_hist;atol)
@test isapprox(kappa_x_hist_UNIT,kappa_x_hist;atol)
@test isapprox(kappa_y_hist_UNIT,kappa_y_hist;atol)
@test isapprox(kappa_z_hist_UNIT,kappa_z_hist;atol)
@test isapprox(massOwens_UNIT,massOwens;atol)
@test isapprox(stress_U_UNIT,stress_U;atol)
@test isapprox(SF_ult_U_UNIT,SF_ult_U;atol)
@test isapprox(SF_buck_U_UNIT,SF_buck_U;atol)
@test isapprox(stress_L_UNIT,stress_L;atol)
@test isapprox(SF_ult_L_UNIT,SF_ult_L;atol)
@test isapprox(SF_buck_L_UNIT,SF_buck_L;atol)
@test isapprox(stress_TU_UNIT,stress_TU;atol)
@test isapprox(SF_ult_TU_UNIT,SF_ult_TU;atol)
@test isapprox(SF_buck_TU_UNIT,SF_buck_TU;atol)
@test isapprox(stress_TL_UNIT,stress_TL;atol)
@test isapprox(SF_ult_TL_UNIT,SF_ult_TL;atol)
@test isapprox(SF_buck_TL_UNIT,SF_buck_TL;atol)
@test isapprox(topstrainout_blade_U_UNIT,topstrainout_blade_U;atol)
@test isapprox(topstrainout_blade_L_UNIT,topstrainout_blade_L;atol)
@test isapprox(topstrainout_tower_U_UNIT,topstrainout_tower_U;atol)
@test isapprox(topstrainout_tower_L_UNIT,topstrainout_tower_L;atol)
@test isapprox(topDamage_blade_U_UNIT,topDamage_blade_U;atol)
@test isapprox(topDamage_blade_L_UNIT,topDamage_blade_L;atol)
@test isapprox(topDamage_tower_U_UNIT,topDamage_tower_U;atol)
@test isapprox(topDamage_tower_L_UNIT,topDamage_tower_L;atol)