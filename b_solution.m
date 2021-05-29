clc 
clear all
close all

load data/lake_depth_data

surf(XX,YY,FF)
shading interp
axis equal

N = 10^5

f_min = -44
f_max = 0
x_min = 0
x_max = 100
y_min = 0
y_max = 100
z_min = -50
z_max = 0 
delta_x = x_max-x_min;
delta_y = y_max-y_min;
delta_z = z_max-z_min;
N_1 = 0;

for i = 1:N
    x = rand() * delta_x + x_min;
    y = rand() * delta_y + y_min;
    z = rand() * delta_z +z_min;
    f_x = depth(x,y);
    if z <= f_max && z > f_x
       N_1 = N_1 + 1; 
    end
end
V = (N_1/N) * abs((x_min-x_max)*(y_min-y_max)*(z_min-z_max))