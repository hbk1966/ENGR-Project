% Created By Group 6: Gregory Bodnar, Colton Bryce, Derek Perkins
% ENGR 1250 Section 13    02 November 2019
% Breakeven Analysis for contruction of new elephant pen at zoo

clear;
clc;
close all;

%{ 
Variables
analysisLength = length of analysis asked for(years)
breakeven = time until profit = cost (weeks)
breakevenDonation = amount of donation funds to break even (USD)
constructionCost = cost of all construction needs (USD)
constructionTime = time until construction is complete (weeks)
costChart = costs to run over time (USD/week)
energyCost = cost for energy requirements (USD/week)
laborCost = cost to pay for labor (USD/week)
landfillCost = cost to remove trash (USD/week)
maintenanceCost = cost for repairs and upkeep (USD/week)
miscCosts = any forseeable additional costs (USD/week)
profitChart = "this is a profit.....chart" (USD/year)
revenueChart = a table of revenue (USD/year)
ticketPrice = THE price of an admission ticket..no favoritsm (USD)
wallCost = Cost for constructing wall, based on material used (USD)
wallThickness = wall thickness based on material (inches)
weeklyCost = cost per week (USD/week)
weeklyDonations = amount of donations (USD/week)
weeklySales = income for weekly sales (USD/week)
weeklyVisitors = vistiors (people/week)
weeksOpen = number of weeks open (#/year)
workerCost = total cost of labor to complete construction (USD)
workerCount = number of workers needed to complete construction (#)
workerPay = amount the workers get paid (USD)
%} 

% Baseline information
materialList = {'Concrete' 16 30 96000 900 5 5;
             'Wood' 23 53 115000 800 12 11;
             'Adobe' 18 42 68000 600 6 5};

choice = menu('Wall Material', materialList{:,1}); % Creating the menu

material = materialList(choice,:);  % setting the variable for material from selection

surfaceArea = 3000; % problem defined set value

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
energyCost = input('Energy cost [$/week]: ');
laborCost = input('Labor cost [$/week]: ');
maintenanceCost = input('Maintence cost [$/week]: ');
landfillCost = input('Landfill cost [$/week]: ');
weeksOpen = input('Number of weeks open a year: ');
analysisLength = input('Number of years for analysis: ');
ticketPrice = input('Price of admission per person [$/person]: ');
weeklyVisitors = input('Number of customers per week: ');
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
fprintf('Material: %s\n\n', materialName); 
fprintf('\t Operating %0.0f weeks per year will generate:\n',weeksOpen);
fprintf('\t \t Revenue: \t $%0.0f per year\n', weeklyRevenue);
fprintf('\t \t Cost: \t \t $%0.0f per year\n', weeklyCost);
fprintf('\t The breakeven time would occur in %0.2f months\n',breakevenOne);
fprintf('\t The total profit after %0.0f years would be $%0.3e\n\n', analysisLength, profitChart(end))
fprintf('It will take a one-time donation of $%0.2f to breakeven in seven months.\n', breakevenDonation);

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
title('Cost/Revenue Chart');
xlabel('Years');
ylabel('$ Millions');
grid on; % showing gridlines
legend({'Total Cost','Revenue'},'Location','Best'); % placing the legend
hold off;
% adding the second plot as a figure
figure;
profitSlope = revenueSlope-costSlope; % setting the slope
% calculating the breakeven point for this figure
projectBreakevenX = constructionCost/(profitSlope); 
projectBreakevenY = profitSlope*projectBreakevenX;
% plotting the data
plot(yearsRequested, profitChart);
hold on; % keep first plot for this figure for the following
plot(projectBreakevenX, projectBreakevenY, 'k.', 'MarkerSize', 20);
hold off;
% Labeling the plotted data
title('Profit vs Time');
xlabel('Years');
ylabel('$ Millions');
grid on; % showing gridlines
legend({'Profit'},'Location','Best'); % placing the legend
