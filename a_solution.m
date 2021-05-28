clc 
clear all
close all

load data/P_ref
a = 0;
b = 5;

result_squares = [];
result_trapezoid = [];
result_simpson = [];
result_montecarlo = [];

%N is the count of intervals
for N = 5:50:10^4
   result_squares = [result_squares, integrateSquares(a,b, N)];
   result_trapezoid = [result_trapezoid, integrateTrapezoid(a,b,N)];
   result_simpson = [result_simpson, integrateSimpson(a,b,N)];
   result_montecarlo = [result_montecarlo, integrateMonteCarlo(a,b,N)];
end


integration_error_squares = abs(result_squares-P_ref);
integration_error_trapezoid = abs(result_trapezoid-P_ref);
integration_error_simpson = abs(result_simpson-P_ref);
integration_error_montecarlo = abs(result_montecarlo-P_ref);


x = 5:50:10^4;
save_loglog_plot(x, integration_error_squares,'error - square integration','plots/squares_integration_errors.png');
save_loglog_plot(x, integration_error_trapezoid, 'error - trapezoid integration', 'plots/trapezoid_integration_errors.png');
save_loglog_plot(x, integration_error_montecarlo, 'error - montecarlo integration', 'plots/montecarlo_integration_errors.png');
save_loglog_plot(x, integration_error_simpson, 'error - simpson integration', 'plots/simpson_integration_errors.png');

N = 10^7;
time_vector = [timeIt(@integrateSquares, [a,b,N]), timeIt(@integrateTrapezoid, [a,b,N]), timeIt(@integrateSimpson, [a,b,N]), timeIt(@integrateMonteCarlo, [a,b,N])];
labels = categorical({'square','trapezoid','Simpson','MonteCarlo'});
labels = reordercats(labels,{'square','trapezoid','Simpson','MonteCarlo'});
bar(labels, time_vector);
title('calculation time for 10^7');
xlabel('used method');
ylabel('time [s]');
saveas(gcf, 'plots/methods_comparision.png');

function result = integrateSquares(a, b, N)
    d_x = (b-a)/N;
    result = 0;
    for i = 1:N
       left = a + (i-1)*d_x;
       right = a + i * d_x;
       result = result + d_x*function_t((left+right)/2);
    end    
end

function result = integrateTrapezoid(a, b, N)
    d_x = (b-a)/N;
    result = 0;
    for i = 1:N
       left = a + (i-1)*d_x;
       right = a + i * d_x;
       result = result + (function_t(left) + function_t(right))/2*d_x;
    end
end

function result = integrateSimpson(a, b, N)
    d_x = (b-a)/N;
    result = 0;
    for i = 1:N
       right = a + (i-1)*d_x;
       left = a + i * d_x;
       result = result + function_t(left) + 4*function_t((left+right)/2) + function_t(right);
    end
    result = result * d_x/6;
end

function result = integrateMonteCarlo(a, b, N)
    f_min = 0;
    f_max = 0.0332;
    delta_f = f_max - f_min;
    delta_i = b - a;
    N_1 = 0;
    for i = 1:N
       x = rand() * delta_i + a;
       y = rand() * delta_f + f_min;
       f_x = function_t(x);
       if y>f_min && y < f_x
           N_1 = N_1 + 1;
       end
    end
    result = (N_1/N) * abs(a-b) * abs(f_min-f_max);
end

function result = function_t(t)
    sigma = 3;
    mu = 10;
    result = 1/(sigma * sqrt(2*pi)) * exp(-(t-mu)^2/(2*sigma^2));
end

function save_loglog_plot(N_vector, integration_error_squares, plot_title, filename)
    x_label_text = 'interval count';
    y_label_text = 'error val';
    loglog(N_vector, integration_error_squares);
    title(plot_title);
    xlabel(x_label_text);
    ylabel(y_label_text);
    saveas(gcf, filename);
end

function result = timeIt(function_to_be_timed, args)
    tic;
    function_to_be_timed(args(1), args(2), args(3));
    result = toc;
end