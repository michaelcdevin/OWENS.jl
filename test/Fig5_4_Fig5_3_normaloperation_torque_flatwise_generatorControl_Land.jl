using PyPlot
PyPlot.pygui(true)
using Statistics:mean
using Statistics
# close("all")
using Test
import PyPlot
import DelimitedFiles
import FLOWMath
import OWENSFEA
import OWENS
import OWENSAero
# import FFTW

path = splitdir(@__FILE__)[1]

PyPlot.rc("figure", figsize=(4.5, 3))
PyPlot.rc("font", size=10.0)
PyPlot.rc("lines", linewidth=1.5)
PyPlot.rc("lines", markersize=3.0)
PyPlot.rc("legend", frameon=false)
PyPlot.rc("axes.spines", right=false, top=false)
PyPlot.rc("figure.subplot", left=.18, bottom=.17, top=0.9, right=.9)
PyPlot.rc("figure",max_open_warning=500)
# PyPlot.rc("axes", prop_cycle=["348ABD", "A60628", "009E73", "7A68A6", "D55E00", "CC79A7"])
plot_cycle=["#348ABD", "#A60628", "#009E73", "#7A68A6", "#D55E00", "#CC79A7"]

##############################################
# Setup
#############################################

SNL34m_5_3_Vinf = DelimitedFiles.readdlm("$(path)/data/SAND-91-2228_Data/5.3_Vinf.csv",',',skipstart = 0)
SNL34m_5_3_RPM = DelimitedFiles.readdlm("$(path)/data/SAND-91-2228_Data/5.3_RPM.csv",',',skipstart = 0)
SNL34m_5_3_Torque = DelimitedFiles.readdlm("$(path)/data/SAND-91-2228_Data/5.3_Torque.csv",',',skipstart = 0)


# Plot
PyPlot.rc("figure", figsize=(4.5, 3))
PyPlot.rc("axes.spines", right=false, top=false)
PyPlot.rc("figure.subplot", left=.18, bottom=.17, top=0.85, right=.9)
PyPlot.figure()
PyPlot.plot(SNL34m_5_3_Vinf[:,1],SNL34m_5_3_Vinf[:,2],"k.-",label="Windspeed (m/s)")
PyPlot.xlabel("Time (s)")
PyPlot.ylabel("Windspeed (m/s)")
PyPlot.ylim([0,12.0])
PyPlot.xlim([0,100.0])
# PyPlot.legend(loc=(.4,.3))
# PyPlot.savefig("$(path)/../figs/NormalOperation_Vinf.pdf",transparent = true)

new_t = LinRange(SNL34m_5_3_RPM[1,1],SNL34m_5_3_RPM[end,1],100)
new_RPM = FLOWMath.akima(SNL34m_5_3_RPM[:,1],SNL34m_5_3_RPM[:,2],new_t)

new_Torque = FLOWMath.akima(SNL34m_5_3_Torque[:,1],SNL34m_5_3_Torque[:,2],new_t)

Vinf_spec = FLOWMath.akima(SNL34m_5_3_Vinf[:,1],SNL34m_5_3_Vinf[:,2],new_t)

t_Vinf = [0;new_t;1e6]
Vinf_spec = [Vinf_spec[1];Vinf_spec;Vinf_spec[end]]
# PyPlot.figure()
# PyPlot.plot(new_RPM,new_Torque,".",label="Orig")
# PyPlot.xlabel("RPM")
# PyPlot.ylabel("Torque")
#
# PyPlot.figure()
# PyPlot.plot(Vinf_spec,new_Torque,".",label="Orig")
# PyPlot.xlabel("Vinf")
# PyPlot.ylabel("Torque")
#
# PyPlot.figure()
# PyPlot.plot(new_t,new_Torque,".-",label="Orig")
# PyPlot.xlabel("t")
# PyPlot.ylabel("Torque")
#
# PyPlot.figure()
# PyPlot.plot(new_t,new_RPM,".-",label="Orig")
# PyPlot.xlabel("t")
# PyPlot.ylabel("RPM")
#
# PyPlot.figure()
# PyPlot.plot(new_t,Vinf_spec,".-",label="Orig")
# PyPlot.xlabel("t")
# PyPlot.ylabel("Vinf")
# PyPlot.plot(t_Vinf,Vinf_spec,label="New")
# PyPlot.legend()

#Put in one place so its not repeated for all of the analyses
import QuadGK
##############################################
# Setup Structures
#############################################
starttime = time()
# SNL34_unit_xz = DelimitedFiles.readdlm("$(path)/data/SNL34m_unit_blade_shape.txt",'\t',skipstart = 0)
# include("$(path)/34mBladeshapeAnalytical2.jl")
# Optimized
# z_shape = collect(LinRange(0,41.9,12))
# x_shape =[0.0, 6.366614283571894, 10.845274468506549, 14.262299623370412, 16.295669420203165, 17.329613328115716, 17.158774783226303, 15.813537149178769, 13.479124754351849, 10.04333990055769, 5.606817958279066,0.0]
# Old 3.5%
# controlpts =[3.256322421104705, 5.774184885976885, 8.647885597459139, 11.186664047211988, 13.145770457622106, 14.674641597073201, 15.804683728982331, 16.61865064561603, 17.108011791043822, 17.296713936456687, 17.19399803467357, 16.803560229287708, 16.108240799302397, 15.118450192780204, 13.803814107334938, 12.21986771504199, 10.359459126160356, 8.205302489986666, 5.765600261682509, 2.975874178673999]
# New 2.15#
controlpts = [3.6479257474344826, 6.226656883619295, 9.082267631309085, 11.449336766507562, 13.310226748873827, 14.781369210504563, 15.8101544043681, 16.566733104331984, 17.011239869982738, 17.167841319391137, 17.04306679619916, 16.631562597633675, 15.923729603782338, 14.932185789551408, 13.62712239754136, 12.075292152969496, 10.252043906945818, 8.124505683235517, 5.678738418596312, 2.8959968657512207]

# z_shape = collect(LinRange(0,41.9,length(x_shape)))
z_shape1 = collect(LinRange(0,41.9,length(controlpts)+2))
x_shape1 = [0.0;controlpts;0.0]
z_shape = collect(LinRange(0,41.9,60))
x_shape = FLOWMath.akima(z_shape1,x_shape1,z_shape)#[0.0,1.7760245854312287, 5.597183088188207, 8.807794161662574, 11.329376903432605, 13.359580331518579, 14.833606099357858, 15.945156349709, 16.679839160110422, 17.06449826588358, 17.10416552269884, 16.760632435904647, 16.05982913536134, 15.02659565585254, 13.660910465851046, 11.913532434360155, 9.832615229216344, 7.421713825584581, 4.447602800040282, 0.0]
toweroffset = 4.3953443986241725
# Analytical
# z_shape = [0.0, 0.4027099927689326, 0.8054199855378652, 1.2081299783067978, 1.6108399710757304, 2.013549963844663, 2.4162599566135956, 2.818969949382528, 3.221679942151461, 3.624389934920394, 4.027099927689326, 4.429809920458259, 4.832519913227191, 5.235229905996124, 5.637939898765056, 6.221683770581164, 6.821719178571302, 7.437583162221221, 8.068800548394838, 8.714884317956601, 9.375335981533686, 10.049645964128134, 10.737293998282153, 11.437749525493246, 12.305529745531164, 13.201631116890074, 14.122956691386433, 15.066322345375763, 16.028467784161606, 17.00606780965343, 17.995743812332336, 18.994075447807884, 19.997612457611687, 21.002886593374797, 22.006423603178604, 23.004755238654155, 23.99443124133306, 24.97203126682489, 25.934176705610724, 26.877542359600053, 27.79886793409642, 28.694969305455324, 29.562749525493246, 30.263205052704336, 30.950853086858352, 31.62516306945281, 32.285614733029895, 32.93169850259165, 33.56291588876527, 34.1787798724152, 34.77881528040533, 35.362559152221436, 35.821422444858186, 36.280285737494935, 36.739149030131685, 37.198012322768435, 37.656875615405184, 38.11573890804193, 38.57460220067868, 39.03346549331543, 39.49232878595218, 39.951192078588925, 40.410055371225674, 40.868918663862424, 41.32778195649917, 41.78664524913592]
# x_shape = [0.0, 0.6201190084429031, 1.2402380168858063, 1.8603570253287094, 2.4804760337716125, 3.1005950422145157, 3.720714050657419, 4.340833059100322, 4.960952067543225, 5.581071075986128, 6.201190084429031, 6.821309092871934, 7.441428101314838, 8.061547109757742, 8.681666118200644, 9.276344926168852, 9.854581297981857, 10.41592909228786, 10.959955198206961, 11.48623986950018, 11.994377048426914, 12.4839746790409, 12.954655009683117, 13.406054884438076, 13.913532546749641, 14.369140295018864, 14.771303537761444, 15.118632389006988, 15.409926471778816, 15.644179066626025, 15.820580590870494, 15.938521396544312, 15.997593877348054, 15.997593877348054, 15.938521396544312, 15.820580590870494, 15.644179066626029, 15.409926471778816, 15.118632389006992, 14.771303537761447, 14.369140295018864, 13.913532546749645, 13.406054884438078, 12.954655009683123, 12.483974679040909, 11.994377048426916, 11.486239869500185, 10.959955198206966, 10.415929092287865, 9.85458129798186, 9.276344926168857, 8.681666118200653, 8.061547968581657, 7.441429818962661, 6.821311669343665, 6.201193519724669, 5.581075370105673, 4.960957220486675, 4.340839070867679, 3.7207209212486827, 3.1006027716296867, 2.480484622010689, 1.8603664723916928, 1.2402483227726968, 0.6201301731537008, 1.2023534704752592e-5]
# y_shape = zero(x_shape)

SNL34_unit_xz = [x_shape;;z_shape]
#Ensure the data is fully unitized since the hand picking process is only good to one or two significant digits.
SNL34x = SNL34_unit_xz[:,1]./maximum(SNL34_unit_xz[:,1])
SNL34z = SNL34_unit_xz[:,2]./maximum(SNL34_unit_xz[:,2])

#Scale the turbine to the full dimensions
height = 41.9 #m
radius = 17.1 #m
SNL34Z = SNL34z.*height
SNL34X = SNL34x.*radius

Nbld = 2

mymesh,myort,myjoint = OWENS.create_mesh_struts(;Ht=0.5,
    Hb = height, #blade height
    R = radius, # m bade radius
    AD15hubR=0.0,
    nblade = Nbld,
    ntelem = 20, #tower elements
    nbelem = 60, #blade elements
    nselem = 3,
    strut_twr_mountpointbot = 0.03,
    strut_twr_mountpointtop = 0.03,
    strut_bld_mountpointbot = 0.03,
    strut_bld_mountpointtop = 0.03,
    bshapex = SNL34X,#cos.(LinRange(0,0,12)).*SNL34X, #Blade shape, magnitude is irrelevant, scaled based on height and radius above
    bshapez = SNL34Z, #Blade shape, magnitude is irrelevant, scaled based on height and radius above
    # bshapey = sin.(LinRange(0,0,12)).*SNL34X,
    angularOffset = pi/2)

# PyPlot.figure()
# PyPlot.plot(mymesh.x,mymesh.z,"b-")
#  for myi = 1:length(mymesh.y)
#      PyPlot.text(mymesh.x[myi].+rand()/30,mymesh.z[myi].+rand()/30,"$myi",ha="center",va="center")
#      PyPlot.draw()
#      sleep(0.1)
#  end
# PyPlot.xlabel("x")
# PyPlot.ylabel("y")
# # PyPlot.axis("equal")
# visualize_orts = true
# if visualize_orts
#     import PyPlot
#     PyPlot.pygui(true)
#     PyPlot.rc("figure", figsize=(15, 15))
#     PyPlot.rc("font", size=10.0)
#     PyPlot.rc("lines", linewidth=1.5)
#     PyPlot.rc("lines", markersize=4.0)
#     PyPlot.rc("legend", frameon=true)
#     PyPlot.rc("axes.spines", right=false, top=false)
#     PyPlot.rc("figure.subplot", left=.18, bottom=.17, top=0.9, right=.9)
#     PyPlot.rc("figure",max_open_warning=500)
#     # PyPlot.rc("axes", prop_cycle=["348ABD", "A60628", "009E73", "7A68A6", "D55E00", "CC79A7"])
#     plot_cycle=["#348ABD", "#A60628", "#009E73", "#7A68A6", "#D55E00", "#CC79A7"]

#     ####################################################################################
#     ################## Plot for the elements #########################
#     ####################################################################################


#     PyPlot.figure()
#     PyPlot.scatter3D(mymesh.x,mymesh.y,mymesh.z,color=plot_cycle[1])
#     # PyPlot.zlim(([90,120]))

#     # Allocate the node angle arrays
#     Psi_d_Nodes = zeros(mymesh.numNodes)
#     Theta_d_Nodes = zeros(mymesh.numNodes)
#     Twist_d_Nodes = zeros(mymesh.numNodes)

#     function rotate_normal(i_el, mymesh, myort;vec=[0,1,0.0],normal_len=1)
#         # * `Psi_d::Array{<:float}`: length NumEl, element rotation about 3 in global FOR (deg) These angles are used to transform from the global coordinate frame to the local element/joint frame via a 3-2 Euler rotation sequence.
#         # * `Theta_d::Array{<:float}`: length NumEl, element rotation about 2 (deg)
#         # * `Twist_d::Array{<:float}`: length NumEl, element twist (deg)
        
#         # Map from element to node
#         nodenum1 = Int(mymesh.conn[i_el,1])
#         nodenum2 = Int(mymesh.conn[i_el,2])

#         # Extract the element angles
#         Psi_d_el = myort.Psi_d[i_el]
#         Theta_d_el = myort.Theta_d[i_el]
#         Twist_d_el = myort.Twist_d[i_el]

#         # Map the element angles to the node angles
#         Psi_d_Nodes[[nodenum1,nodenum2]] .= Psi_d_el
#         Theta_d_Nodes[[nodenum1,nodenum2]] .= Theta_d_el
#         Twist_d_Nodes[[nodenum1,nodenum2]] .= Twist_d_el

#         # Use a line and rotate it about the angles, different starting vectors show different angles.
#         myvec = vec.*normal_len

#         # apply the twist rotation, which is about the x (1) axis
#         DCM_roll = [1.0 0.0 0.0
#             0.0 cosd(Twist_d_el) -sind(Twist_d_el)
#             0.0 sind(Twist_d_el) cosd(Twist_d_el)]

#         # apply theta rotation, which is the tilt angle, or about the y (2) axis in global
#         DCM_pitch = [cosd(Theta_d_el) 0.0 sind(Theta_d_el)
#             0.0 1.0 0.0
#             -sind(Theta_d_el) 0.0 cosd(Theta_d_el)]

#         # apply Psi rotation, which is about Z (3) axis in global
#         DCM_yaw = [cosd(Psi_d_el) -sind(Psi_d_el) 0.0
#             sind(Psi_d_el) cosd(Psi_d_el) 0.0
#             0.0 0.0 1.0]

#         # Get the location of the element
#         x_el = (mymesh.x[nodenum1]+mymesh.x[nodenum2])/2
#         y_el = (mymesh.y[nodenum1]+mymesh.y[nodenum2])/2
#         z_el = (mymesh.z[nodenum1]+mymesh.z[nodenum2])/2

#         # Offset the myvector by the location of the element
#         myvec = DCM_yaw*DCM_pitch*DCM_roll*myvec + [x_el,y_el,z_el]
#         x_el_plot = [x_el,myvec[1]]
#         y_el_plot = [y_el,myvec[2]]
#         z_el_plot = [z_el,myvec[3]]
#         return x_el_plot, y_el_plot, z_el_plot
#     end

#     # Add the orientation vectors, ort is on elements
#     for i_el = 1:mymesh.numEl
#         x_el_plot, y_el_plot, z_el_plot = rotate_normal(i_el, mymesh, myort;vec=[10,0,0.0])
#         PyPlot.plot3D(x_el_plot,y_el_plot,z_el_plot,"-",color=plot_cycle[2])
#     end

#     for i_el = 1:mymesh.numEl
#         x_el_plot, y_el_plot, z_el_plot = rotate_normal(i_el, mymesh, myort;vec=[0,5,0.0])
#         PyPlot.plot3D(x_el_plot,y_el_plot,z_el_plot,"-",color=plot_cycle[3])
#     end

#     for i_el = 1:mymesh.numEl
#         x_el_plot, y_el_plot, z_el_plot = rotate_normal(i_el, mymesh, myort;vec=[0,0,5.0])
#         PyPlot.plot3D(x_el_plot,y_el_plot,z_el_plot,"-",color=plot_cycle[4])
#     end

#     PyPlot.plot3D([0.0],[0.0],[0.0],"-",color=plot_cycle[2],label="X-norm")
#     PyPlot.plot3D([0.0],[0.0],[0.0],"-",color=plot_cycle[3],label="Y-norm")
#     PyPlot.plot3D([0.0],[0.0],[0.0],"-",color=plot_cycle[4],label="Z-norm")
#     PyPlot.legend()
#     # for i_joint = 1:length(myjoint[:,1])
#     #     i_el = findall(x->x==myjoint[i_joint,2],mymesh.conn[:,1])
#     #     if length(i_el)==0 #Use the other element associated with the joint
#     #         i_el = findall(x->x==myjoint[i_joint,2],mymesh.conn[:,2])
#     #     end
#     #     if length(i_el)==0 #Use the other element associated with the joint
#     #         i_el = findall(x->x==myjoint[i_joint,3],mymesh.conn[:,2])
#     #     end
#     #     x_el_plot, y_el_plot, z_el_plot = rotate_normal(i_el[1], mymesh, myort;normal_len=3)
#     #     PyPlot.plot3D(x_el_plot,y_el_plot,z_el_plot,"-",color=plot_cycle[5])
#     # end

#     PyPlot.xlabel("x")
#     PyPlot.ylabel("y")
#     PyPlot.zlabel("z")
#     PyPlot.axis("equal")
# end

nTwrElem = Int(mymesh.meshSeg[1])+2
nBldElem = Int(mymesh.meshSeg[2])+1
#Blades
NuMad_geom_xlscsv_file = "$path/data/SNL34mGeom.csv"
numadIn_bld = OWENS.readNuMadGeomCSV(NuMad_geom_xlscsv_file)

for (i,airfoil) in enumerate(numadIn_bld.airfoil)
    numadIn_bld.airfoil[i] = "$path/airfoils/$airfoil"
end

NuMad_mat_xlscsv_file = "$path/data/SNL34mMaterials.csv"
plyprops_bld = OWENS.readNuMadMaterialsCSV(NuMad_mat_xlscsv_file)

bld1start = Int(mymesh.structuralNodeNumbers[1,1])
bld1end = Int(mymesh.structuralNodeNumbers[1,end])
spanpos = [0.0;cumsum(sqrt.(diff(mymesh.x[bld1start:bld1end]).^2 .+ diff(mymesh.z[bld1start:bld1end]).^2))]

bld_precompoutput,bld_precompinput = OWENS.getOWENSPreCompOutput(numadIn_bld;plyprops=plyprops_bld)
sectionPropsArray_bld = OWENS.getSectPropsFromOWENSPreComp(spanpos,numadIn_bld,bld_precompoutput;precompinputs=bld_precompinput)

stiff_bld, mass_bld = OWENS.getSectPropsFromOWENSPreComp(spanpos,numadIn_bld,bld_precompoutput;GX=true)

# thickness_flap is distance from shear center x to top
# thickness_lag is distance from shear center y to trailing edge
# shear center is relative to the blade reference axis
# blade reference axis is from leading edge to le_loc*chord and along the chord line
# reference axes Y is along the chord, and X is perpendicular to the chord

thickness_precomp_lag = zeros(length(bld_precompinput))
thickness_precomp_flap = zeros(length(bld_precompinput))
for ipc = 1:length(bld_precompinput)
    refY = bld_precompinput[ipc].le_loc*bld_precompinput[ipc].chord
                                # Negative distance for lag, to align with SAND-88-1144
    thickness_precomp_lag[ipc] = -(bld_precompinput[ipc].chord-(refY+bld_precompoutput[ipc].y_sc))
    thickness_precomp_flap[ipc] = maximum(bld_precompinput[ipc].ynode)*bld_precompinput[ipc].chord - bld_precompoutput[ipc].x_sc
end
# PyPlot.figure()
# PyPlot.plot(bld_precompinput[1].ynode,bld_precompinput[1].ynode)
spanposmid = cumsum(diff(spanpos))
thickness = FLOWMath.akima(numadIn_bld.span,thickness_precomp_flap,spanposmid)
thickness_lag = FLOWMath.akima(numadIn_bld.span,thickness_precomp_lag,spanposmid)
# thickness = thicknessGX[1:end-1]


NuMad_geom_xlscsv_file = "$path/data/NuMAD_34m_TowerGeom.csv"
numadIn = OWENS.readNuMadGeomCSV(NuMad_geom_xlscsv_file)

for (i,airfoil) in enumerate(numadIn.airfoil)
    numadIn.airfoil[i] = "$path/airfoils/$airfoil"
end

NuMad_mat_xlscsv_file = "$path/data/NuMAD_34m_TowerMaterials.csv"
plyprops_twr = OWENS.readNuMadMaterialsCSV(NuMad_mat_xlscsv_file)

precompoutput,precompinput = OWENS.getOWENSPreCompOutput(numadIn;plyprops=plyprops_twr)
sectionPropsArray_twr = OWENS.getSectPropsFromOWENSPreComp(LinRange(0,1,nTwrElem),numadIn,precompoutput;precompinputs=precompinput)

stiff_twr, mass_twr = OWENS.getSectPropsFromOWENSPreComp(LinRange(0,1,nTwrElem),numadIn,precompoutput;GX=true)
#Struts
# They are the same as the end properties of the blades

# Combined Section Props
bldssecprops = collect(Iterators.flatten(fill(sectionPropsArray_bld, Nbld)))
Nremain = mymesh.numEl-length(sectionPropsArray_twr)-length(bldssecprops) #strut elements remain
sectionPropsArray = [sectionPropsArray_twr;bldssecprops;fill(sectionPropsArray_bld[end],Nremain)]#;sectionPropsArray_str;sectionPropsArray_str;sectionPropsArray_str;sectionPropsArray_str]

rotationalEffects = ones(mymesh.numEl)

for i = 1:length(sectionPropsArray)
    # sectionPropsArray[i].rhoA .*= 0.25
    # sectionPropsArray[i].EIyy .*= 5.0
    # sectionPropsArray[i].EIzz .*= 5.0
    # sectionPropsArray[i].EIyz .*= 5.0
    # sectionPropsArray[i].GJ .*= 5.0
    # sectionPropsArray[i].EA .*= 5.0
    # sectionPropsArray[i].rhoIyy .*= 0.1
    # sectionPropsArray[i].rhoIzz .*= 0.1
    # sectionPropsArray[i].rhoIyz .*= 0.1
    # sectionPropsArray[i].rhoJ .*= 0.1
end


#store data in element object
myel = OWENSFEA.El(sectionPropsArray,myort.Length,myort.Psi_d,myort.Theta_d,myort.Twist_d,rotationalEffects)

top_idx = 23#Int(myjoint[7,2])
pBC = [1 1 0
1 2 0
1 3 0
1 4 0
1 5 0
1 6 0
top_idx 1 0
top_idx 2 0
top_idx 3 0
top_idx 4 0
top_idx 5 0]
# top_idx 6 0]

##############################################
# Setup Aero
#############################################


shapeX_spline = FLOWMath.Akima(SNL34Z, SNL34X)
RefArea_half, error = QuadGK.quadgk(shapeX_spline, 0, height, atol=1e-10)
RefArea = RefArea_half*2*0.95

B = 2
Nslices = 35

T1 = round(Int,(5.8/height)*Nslices)
T2 = round(Int,(11.1/height)*Nslices)
T3 = round(Int,(29.0/height)*Nslices)
T4 = round(Int,(34.7/height)*Nslices)

airfoils = fill("$(path)/airfoils/NACA_0021.dat",Nslices)
airfoils[T1:T4] .= "$(path)/airfoils/Sandia_001850.dat"

chord = fill(1.22,Nslices)
chord[T1:T4] .= 1.07
chord[T2:T3] .= 0.9191
#TODO: when twist introduced, aero should pull it from the precomp input data
rho = 0.94 # for texas site (3880 ft) at 80F

RPM = 34.0
omega = RPM*2*pi/60

# filename = "$(path)/data/legacyfiles/SNL34m"
# OWENS.saveOWENSfiles(filename,mymesh,myort,myjoint,myel,pBC,numadIn_bld)

# system, assembly, sections, frames_ow = OWENS.owens_to_gx(mymesh,myort,myjoint,sectionPropsArray,mass_twr, mass_bld, stiff_twr, stiff_bld;VTKmeshfilename="$path/vtk/SNL34m")

function runmeOWENS()
    mass = 0.0
    for (i,sectionProp) in enumerate(sectionPropsArray)
        lenEl = 0
        try
            lenEl = myort.Length[i]
        catch
            lenEl = myort.Length[i-1]
        end
        rhoA = sectionProp.rhoA[1]
        mass += lenEl*rhoA
    end
return mass
end

massOwens = runmeOWENS()
#
# function runmeGX()
#     mass = 0.0
#     for element in assembly.elements
#         mass += element.L*element.mass[1,1]
#     end
# return mass
# end
#
# massGX = runmeGX()
#
println("Mass")
println("massOwens $massOwens")
# println("massGX $massGX")
#
# ei_flap_exp_base = 1.649e7
# ei_flap_exp_mid = 5.197e6
# ei_flap_exp_center = 3.153e6
#
# ei_lag_exp_base = 2.744e8
# ei_lag_exp_mid = 1.125e8
# ei_lag_exp_center = 6.674e7
#
# ea_exp_base = 2.632e9
# ea_exp_mid = 1.478e9
# ea_exp_center = 1.185e9
#
#
# println("1 ei_flap: $(bld_precompoutput[1].ei_flap) exp: $ei_flap_exp_base")
# println("1 ei_lag: $(bld_precompoutput[1].ei_lag) exp: $ei_lag_exp_base")
# println("1 ea: $(bld_precompoutput[1].ea) exp: $ea_exp_base")
# println()
# println("5 ei_flap: $(bld_precompoutput[5].ei_flap) exp: $ei_flap_exp_mid")
# println("5 ei_lag: $(bld_precompoutput[5].ei_lag) exp: $ei_lag_exp_mid")
# println("5 ea: $(bld_precompoutput[5].ea) exp: $ea_exp_mid")
# println()
# println("12 ei_flap: $(bld_precompoutput[12].ei_flap) exp: $ei_flap_exp_center")
# println("12 ei_lag: $(bld_precompoutput[12].ei_lag) exp: $ei_lag_exp_center")
# println("12 ea: $(bld_precompoutput[12].ea) exp: $ea_exp_center")
# println()

Vinf = mean(SNL34m_5_3_Vinf[:,2])
TSR = omega*radius./Vinf
windpower = 0.5*rho*Vinf.^3*RefArea
ntheta = 30#176

OWENSAero.setupTurb(SNL34X,SNL34Z,B,chord,TSR,Vinf;
    eta = 0.5,
    rho,
    mu = 1.7894e-5,
    ntheta,
    Nslices,
    ifw = false,
    turbsim_filename = "$path/data/40mx40mVinf10_41ms10percturb.bts",
    RPI = true,
    DSModel = "BV",
    AModel = "DMS",
    tau = [1e-5,1e-5],
    afname = airfoils)

dt = 1/(RPM/60*ntheta)

aeroForcesDMS(t,azi) = OWENS.mapACDMS(t,azi,mymesh,myel,OWENSAero.AdvanceTurbineInterpolate;alwaysrecalc=true)

offsetTime = 20.0
Omegaocp = [new_RPM[1]; new_RPM; new_RPM[end]]./60 .*0 .+33.92871/60
tocp_Vinf = [0.0;t_Vinf.+offsetTime; 1e6]
Vinfocp = [Vinf_spec[1];Vinf_spec;Vinf_spec[end]].*1e-6

model = OWENS.Inputs(;analysisType = "ROM",
    outFilename = "none",
    tocp = [0.0;new_t.+offsetTime; 1e6],#SNL34m_5_3_RPM[:,1],#[0.0,10.0,100000.1],
    Omegaocp,#SNL34m_5_3_RPM[:,2]./ 60,#[RPM,RPM,RPM] ./ 60,
    tocp_Vinf,
    Vinfocp,
    numTS = 600,
    delta_t = 0.05,#dt,
    aeroLoadsOn = 2,
    turbineStartup = 1,
    generatorOn = true,
    useGeneratorFunction = true,
    driveTrainOn = true,
    JgearBox = 250.0,#(2.15e3+25.7)/12*1.35582*100,
    gearRatio = 1.0,
    gearBoxEfficiency = 1.0,
    driveShaftProps = OWENS.DriveShaftProps(10000,1.5e2), #8.636e5*1.35582*0.6
    OmegaInit = Omegaocp[1]/60)

println(sqrt(model.driveShaftProps.k/model.JgearBox)*60/2/pi/2)

feamodel = OWENSFEA.FEAModel(;analysisType = "ROM",
    joint = myjoint,
    platformTurbineConnectionNodeNumber = 1,
    pBC,
    nlOn=false,
    numNodes = mymesh.numNodes,
    numModes = 200,
    RayleighAlpha = 0.05,
    RayleighBeta = 0.05,
    iterationType = "DI")

# Get Gravity Loads
model.Omegaocp = model.Omegaocp.*0.0
model.OmegaInit = model.OmegaInit.*0.0
model.Vinfocp = model.Vinfocp.*0.0
feamodel.nlOn = true

# Returns data filled with e.g. eps[Nbld,N_ts,Nel_bld]
eps_x_grav,eps_z_grav,eps_y_grav,kappa_x_grav,kappa_y_grav,kappa_z_grav,t,FReactionHist_grav = OWENS.run34m(model,feamodel,mymesh,myel,aeroForcesDMS,OWENSAero.deformTurb;steady=true)

#####
###****** SAND-88-1144 Specifies Bending Strains and Axial Strains Separate ****
#####

Ealuminum = plyprops_bld.plies[end].e1
flatwise_stress1grav = (kappa_y_grav[1,end-1,2:end].* thickness .+ 0*eps_x_grav[1,end-1,2:end]) .* Ealuminum
flatwise_stress2grav = (kappa_y_grav[2,end-1,1:end-1].* thickness .+ 0*eps_x_grav[2,end-1,1:end-1]) .* Ealuminum
lag_stress1grav = (kappa_z_grav[1,end-1,2:end].* thickness_lag .+ 0*eps_x_grav[1,end-1,2:end]) .* Ealuminum
lag_stress2grav = (kappa_z_grav[2,end-1,1:end-1].* thickness_lag .+ 0*eps_x_grav[2,end-1,1:end-1]) .* Ealuminum

# println("Creating GXBeam Inputs and Saving the 3D mesh to VTK")
system, assembly, sections = OWENS.owens_to_gx(mymesh,myort,myjoint,sectionPropsArray,mass_twr, mass_bld, stiff_twr, stiff_bld)#;damp_coef=0.05)


model.Omegaocp = Omegaocp
model.OmegaInit = Omegaocp[1]
model.Vinfocp = [Vinf_spec[1];Vinf_spec;Vinf_spec[end]]
feamodel.nlOn = false
feamodel.analysisType = "ROM"
model.analysisType = "ROM"

eps_x,eps_z,eps_y,kappa_x,kappa_y,kappa_z,t,FReactionHist,omegaHist,genTorque,torqueDriveShaft,aziHist,uHist = OWENS.run34m(model,feamodel,mymesh,myel,
aeroForcesDMS,OWENSAero.deformTurb;steady=false,system,assembly,VTKFilename="$path/vtk/NormalOperation")

# Get stress and "zero" out the loads from the initial 0-RPM
flatwise_stress1 = zeros(length(eps_x[1,:,1]),length(eps_x[1,1,1:end-1]))
flatwise_stress2 = zeros(length(eps_x[1,:,1]),length(eps_x[1,1,1:end-1]))
lag_stress1 = zeros(length(eps_x[1,:,1]),length(eps_x[1,1,1:end-1]))
lag_stress2 = zeros(length(eps_x[1,:,1]),length(eps_x[1,1,1:end-1]))
for its = 1:length(eps_x[1,:,1])
    flatwise_stress1[its,:] = (kappa_y[1,its,2:end].* thickness .+ 0*eps_x[1,its,2:end]) .* Ealuminum .- flatwise_stress1grav
    flatwise_stress2[its,:] = (kappa_y[2,its,1:end-1].* thickness .+ 0*eps_x[2,its,1:end-1]) .* Ealuminum .- flatwise_stress2grav

    lag_stress1[its,:] = (kappa_z[1,its,2:end].* thickness_lag .+ 0*eps_x[1,its,2:end]) .* Ealuminum .- lag_stress1grav
    lag_stress2[its,:] = (kappa_z[2,its,1:end-1].* thickness_lag .+ 0*eps_x[2,its,1:end-1]) .* Ealuminum .- lag_stress2grav
end

# Load in experimental data
SNL34m_5_4_FlatwiseStress = DelimitedFiles.readdlm("$(path)/data/SAND-91-2228_Data/5.4AMF.csv",',',skipstart = 1)

# Plots
PyPlot.figure()
PyPlot.plot(t.-offsetTime,flatwise_stress1[:,end-5]./1e6,"-",color=plot_cycle[1],label = "OWENS Blade 1")
PyPlot.plot(SNL34m_5_4_FlatwiseStress[:,1].-0.8,SNL34m_5_4_FlatwiseStress[:,2],"k-",label = "Experimental")
PyPlot.xlabel("Time (s)")
PyPlot.ylabel("Flapwise Stress (MPa)")
PyPlot.xlim([0,SNL34m_5_4_FlatwiseStress[end,1]])
# PyPlot.ylim([-60,0])
PyPlot.legend(loc = (0.06,1.0),ncol=2)
# PyPlot.savefig("$(path)/../figs/34m_fig5_4_NormalOperation_flapwise_Blade2Way.pdf",transparent = true)

println("here")
exp_std_flap = Statistics.std(SNL34m_5_4_FlatwiseStress[:,2])
println("exp_std_flap $exp_std_flap")
exp_mean_flap = Statistics.mean(SNL34m_5_4_FlatwiseStress[:,2])
println("exp_mean_flap $exp_mean_flap")
sim_std_flap = Statistics.std(flatwise_stress1[:,end-4]./1e6)
println("sim_std_flap $sim_std_flap")
sim_mean_flap = Statistics.mean(flatwise_stress1[:,end-4]./1e6)
println("sim_mean_flap $sim_mean_flap")

SNL34m_5_4_LeadLagStress = DelimitedFiles.readdlm("$(path)/data/SAND-91-2228_Data/5.4AML.csv",',',skipstart = 1)

PyPlot.figure()
PyPlot.plot(t.-offsetTime,lag_stress1[:,end-5]./1e6,"-",color=plot_cycle[1],label = "OWENS Blade 1")
PyPlot.plot(SNL34m_5_4_LeadLagStress[:,1],SNL34m_5_4_LeadLagStress[:,2],"k-",label = "Experimental")
PyPlot.xlabel("Time (s)")
PyPlot.ylabel("Lead-Lag Stress (MPa)")
PyPlot.xlim([0,SNL34m_5_4_LeadLagStress[end,1]])
PyPlot.legend(loc = (0.06,1.0),ncol=2)
# PyPlot.savefig("$(path)/../figs/34m_fig5_4_NormalOperation_LeadLag_Blade2Way.pdf",transparent = true)

exp_std_lag = Statistics.std(SNL34m_5_4_LeadLagStress[:,2])
println("exp_std_lag $exp_std_lag")
exp_mean_lag = Statistics.mean(SNL34m_5_4_LeadLagStress[:,2])
println("exp_mean_lag $exp_mean_lag")
sim_std_lag = Statistics.std(lag_stress1[:,end-4]./1e6)
println("sim_std_lag $sim_std_lag")
sim_mean_lag = Statistics.mean(lag_stress1[:,end-4]./1e6)
println("sim_mean_lag $sim_mean_lag")

##########################################
#### Torque Plot
##########################################

SNL34m_5_3_Torque = DelimitedFiles.readdlm("$(path)/data/SAND-91-2228_Data/5.3_Torque2.csv",',',skipstart = 0)

filterwindow = 100
PyPlot.ion()
PyPlot.figure()
PyPlot.plot(t.-offsetTime,torqueDriveShaft/1000 ,color=plot_cycle[1],label="Simulated Drive Shaft")
usedLogic = SNL34m_5_3_Torque[:,1].<100
PyPlot.plot(SNL34m_5_3_Torque[usedLogic,1],SNL34m_5_3_Torque[usedLogic,2],"k-",label="Experimental")
PyPlot.xlabel("Time (s)")
PyPlot.xlim([0,100])
PyPlot.ylabel("Torque (kN-m)")
PyPlot.legend()#loc = (0.06,1.0),ncol=2)
# PyPlot.savefig("$(path)/../figs/34m_fig5_32Way.pdf",transparent = true)

# #Extract and Plot Frequency - Amplitude

# lensig = length(flatwise_stress1[:,1])
# ipt = length(flatwise_stress1[1,:])-5
# istart = 1#500
# iend = lensig
# signal = -flatwise_stress1[istart:iend,ipt]./1e6
# L = length(signal)
# if L%2 != 0
#     signal = signal[1:end-1]
#     L = length(signal)
# end
# # signal .-= mean(signal)
# Y = FFTW.fft(signal)


# Fs = 1/(t[2]-t[1])
# P2 = abs.(Y./L)
# P1 = P2[1:Int(L/2)+1]
# P1[2:end-1] = 2*P1[2:end-1]

# f = Fs.*(0:Int(L/2))./L
# PyPlot.figure()
# PyPlot.plot(f,P1)
# PyPlot.title("Single-Sided Amplitude Spectrum of X(t)")
# PyPlot.xlabel("f (Hz)")
# PyPlot.ylabel("|P1(f)|")
# PyPlot.xlim([0.0,10.0])
# PyPlot.ylim([0.0,7.0])
# # PyPlot.savefig("$(path)/../figs/34m_fig5_6_upperRootFlatwiseStressSpectrum2Way.pdf",transparent = true)

################################################################
################ SAVE VTK TIME DOMAIN OUTPUT ###################
################################################################

# println("Saving VTK time domain files")
# OWENS.OWENSFEA_VTK("SNL34m_timedomain_gravityonly",t,uHist,system,assembly,sections;scaling=10)#,azi=aziHist)

# Open Paraview, open animation pane, adjust as desired, export animation (which exports frames)
# ffmpeg -i Ux.%04d.png -vcodec libx264 -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" -r 24 -y -an -pix_fmt yuv420p video34m34RPM_Ux.mp4


println("Saving VTK time domain files")
userPointNames=["EA","EIyy","EIzz"]#,"Fx","Fy","Fz","Mx","My","Mz"]
# userPointData[iname,it,ipt] = Float64

# map el props to points using con
userPointData = zeros(length(userPointNames),length(t),mymesh.numNodes)
EA_points = zeros(mymesh.numNodes)
EIyy_points = zeros(mymesh.numNodes)
EIzz_points = zeros(mymesh.numNodes)

# Time-invariant data
for iel = 1:length(myel.props)
    # iel = 1
    nodes = mymesh.conn[iel,:]
    EA_points[Int.(nodes)] = myel.props[iel].EA
    EIyy_points[Int.(nodes)] = myel.props[iel].EIyy
    EIzz_points[Int.(nodes)] = myel.props[iel].EIzz
end

# fill in the big matrix
for it = 1:length(t)

    userPointData[1,it,:] = EA_points
    userPointData[2,it,:] = EIyy_points
    userPointData[3,it,:] = EIzz_points
    # userPointData[4,it,:] = FReactionHist[it,1:6:end]
    # userPointData[5,it,:] = FReactionHist[it,2:6:end]
    # userPointData[6,it,:] = FReactionHist[it,3:6:end]
    # userPointData[7,it,:] = FReactionHist[it,4:6:end]
    # userPointData[8,it,:] = FReactionHist[it,5:6:end]
    # userPointData[9,it,:] = FReactionHist[it,6:6:end]
end

azi=aziHist#./aziHist*1e-6
saveName = "$path/oldProps"
OWENS.OWENSFEA_VTK(saveName,t,uHist,system,assembly,sections;scaling=1,azi,userPointNames,userPointData)


PyPlot.figure()
PyPlot.plot(mymesh.x,mymesh.z,"bo")
PyPlot.plot(mymesh2.x,mymesh2.z,"r+")
PyPlot.xlabel("x")
PyPlot.ylabel("y")