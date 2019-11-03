% Created By Group 6: Gregory Bodnar, Colton Bryce, Derek Perkins
% ENGR 1250 Section 13    02 November 2019
% Breakeven Analysis for contruction of new elephant pen at zoo

clear;
clc;
close all;

%{ 
Variables

analysisLength = Length of analysis asked for (years)
breakevenOne = Time until profit eqals cost (months)
breakevenDonation = Amount of donated funds to break even (USD)
breakevenX = Location of breakeven point on X-axis for breakeven chart (-)
breakevenY = Location of breakeven point on Y-axis for breakeven chart (-)
choice = Numerical location of menu choice from array (-)
constructionCost = Cost of all construction needs (USD)
constructionTime = Time until construction is complete (weeks)
costChart = Array of costs to run over time (USD)
costSlope = Slope point for the breakeven array (-)
energyCost = Cost for energy requirements (USD/week)
ftToIn = Conversion factor to inches from feet (-)
laborCost = Cost to pay for labor (USD/week)
landfillCost = Cost to remove trash (USD/week)
maintenanceCost = Cost for repairs and upkeep (USD/week)
material = Array of information for chosen material (-)
materialCost = Price of the material used (USD/ft^3)
materialList = Array of baseline information (-)
materialName = Script for chosen material from menu (-)
miscCosts = Cost of miscellaneous contruction materials (USD)
profitBreakevenY = Location of breakeven point on Y-axis for profit chart (-)
profitChart = Array of profit over time (USD)
profitSlope = Slope point for the profit array (-)
revenueChart = Array of revenue over time (USD)
revenueSlope = Slope point for the breakeven array (-)
surfaceArea = Predefined surface area of the wall (ft^2)
ticketPrice = The price of an admission ticket (USD)
wallCost = Total cost for constructing wall, based on material used (USD)
wallThickness = Wall thickness based on material used (inches)
wallTotalCost = Array for the cost of the wall (-)
weeklyCost = Total cost per week (USD/week)
weeklyDonations = Amount of estimated donations (USD/week)
weeklyRevenue = Total revenue (USD/week)
weeklyVisitors = Number of visitors per week (customers/week)
weeksOpen = Number of weeks a year the zoo is open (weeks/year)
workerCost = Total cost of labor to complete construction (USD)
workerCount = Number of workers needed to complete construction (workers)
workerPay = Amount the workers get paid (USD/week)
yearsRequested = Number of years the analysis will run for (years)
yearToMonth = Conversion factor for years to months (-)
%} 

% Baseline information
materialList = {'Concrete' 16 30 96000 900 5 5;
             'Wood' 23 53 115000 800 12 11;
             'Adobe' 18 42 68000 600 6 5};

choice = menu('Wall Material', materialList{:,1}); % Creating the menu

material = materialList(choice,:);  % Setting the variable for material from selection

surfaceArea = 3000; % Predifined value for surface area

% Conversion Factors
ftToIn = 12;
yearToMonth = 4;

% Defining Baseline information
materialName = material{1};
wallThickness = material{2};
materialCost = material{3};
miscCosts = material{4};
workerPay = material{5};
workerCount = material{6};
constructionTime = material{7};

% Questions for user input
fprintf('Please answer the following questions for your analysis. \n\n');
energyCost = input('Energy cost [$/week]: ');
laborCost = input('Labor cost [$/week]: ');
maintenanceCost = input('Maintence cost [$/week]: ');
landfillCost = input('Landfill cost [$/week]: ');
weeksOpen = input('Number of weeks open a year [weeks/year]: ');
analysisLength = input('Number of years for analysis [years]: ');
ticketPrice = input('Price of admission per person [$/person]: ');
weeklyVisitors = input('Number of customers per week [customers/week]: ');
weeklyDonations = input('Expected donations [$/week]: ');

% Calculations for construction variables using Baseline information and user input
wallCost = materialCost * (wallThickness / ftToIn) * surfaceArea;
workerCost = workerPay * workerCount * constructionTime;
constructionCost = workerCost + wallCost + miscCosts;
weeklyCost = energyCost + laborCost + maintenanceCost + landfillCost;
weeklyRevenue = (ticketPrice * weeklyVisitors) + weeklyDonations;
yearsRequested = [0:1:analysisLength];
costChart = (weeksOpen * weeklyCost) * yearsRequested;
revenueChart = (weeklyRevenue * weeksOpen * yearsRequested);
profitChart = revenueChart - costChart;

% Calculating Breakeven points through profit alone or by donations
breakevenOne = (constructionCost / (weeklyRevenue - weeklyCost) / yearToMonth);
breakevenDonation = constructionCost - ((weeklyRevenue - weeklyCost) * yearToMonth * 7);

% Outputing the results for review
clc % clean the command window to show only results
fprintf('According to the information provided, here is your breakeven analysis for %s construction. \n\n\n', materialName);
fprintf('Material: %s\n', materialName); 
fprintf('\t Operating %0.0f weeks per year would generate:\n',weeksOpen);
fprintf('\t \t Revenue: \t $%0.0f per year\n', weeklyRevenue);
fprintf('\t \t Cost: \t \t $%0.0f per year\n', weeklyCost);
fprintf('\t The breakeven point would occur in %0.2f months\n',breakevenOne);
fprintf('\t The total profit after %0.0f years would be $%0.3e\n\n', analysisLength, profitChart(end))
fprintf('It would take a one-time donation of $%0.2f to break even in seven months.\n', breakevenDonation);

% Preparing the Charts
% Setting the line to be used for total cost
wallTotalCost = (constructionCost) + costChart;

% calculating the slope for the lines
costSlope = (wallTotalCost(end)-wallTotalCost(1))/(analysisLength);
revenueSlope = (revenueChart(end)-revenueChart(1))/(analysisLength);
% calculating the breakeven point position
breakevenX = constructionCost/(revenueSlope-costSlope);
breakevenY = (revenueSlope*breakevenX);
% Plotting the data
plot(yearsRequested, wallTotalCost, yearsRequested, revenueChart);
hold on; % keep first plot for the following
plot(breakevenX, breakevenY, 'k.', 'MarkerSize', 20);
% Labeling the plot
title('Cost and Revenue vs Time Chart');
xlabel('Years');
ylabel('$ Millions');
grid on; % showing gridlines
legend({'Total Cost','Revenue','Breakeven Point'},'Location','Best'); % placing the legend
hold off;

% adding the second plot as a figure
figure;
profitSlope = revenueSlope-costSlope; % setting the slope
% calculating the breakeven point for this figure
profitBreakevenY = profitSlope*breakevenX;
% plotting the data
plot(yearsRequested, profitChart);
hold on; % keep first plot for this figure for the following
plot(breakevenX, profitBreakevenY, 'k.', 'MarkerSize', 20);
hold off;

% Labeling the plotted data
title('Profit vs Time');
xlabel('Years');
ylabel('$ Millions');
grid on; % showing gridlines
legend({'Profit', 'Breakeven Point'},'Location','northwest'); % placing the legend
