clear;
clc;
close all;

materialList = {'Concrete' 16 30 96000 900 5 5;
             'Wood' 23 53 115000 800 12 11;
             'Adobe' 18 42 68000 600 6 5};

choice = menu('Wall Material', materialList{:,1});

material = materialList(choice,:);

surfaceArea = 3000;

ftToIn = 12;
yearToMonth = 4;

materialName = material{1};
wallThickness = material{2};
materialCost = material{3};
miscCosts = material{4};
workerPay = material{5};
workerCount = material{6};
constructionTime = material{7};

energyCost = input('Energy cost [$/week]: ');
laborCost = input('Labor cost [$/week]: ');
maintenanceCost = input('Maintence cost [$/week]: ');
landfillCost = input('Landfill cost [$/week]: ');

weeksOpen = input('Number of weeks open a year: ');
analysisLength = input('Number of years for analysis: ');

ticketPrice = input('Price of admission per person [$/person]: ');
weeklyVisitors = input('Number of customers per week: ');
weeklyDonations = input('Expected donations [$/week]: ');

wallCost = materialCost * (wallThickness / ftToIn) * surfaceArea;
workerCost = workerPay * workerCount * constructionTime;

constructionCost = workerCost + wallCost + miscCosts;

weeklyCost = energyCost + laborCost + maintenanceCost + landfillCost;
weeklyRevenue = (ticketPrice * weeklyVisitors) + weeklyDonations;

yearsRequested = [0:1:analysisLength];

costChart = (weeksOpen * weeklyCost) * yearsRequested;
revenueChart = (weeklyRevenue * weeksOpen * yearsRequested);
profitChart = revenueChart - costChart;

breakevenOne = (constructionCost / (weeklyRevenue - weeklyCost) / yearToMonth);
breakevenDonation = constructionCost - ((weeklyRevenue - weeklyCost) * yearToMonth * 7);

fprintf('Material: %s\n', materialName); 
fprintf('\t Operating %0.0f weeks per year will generate per year:\n',weeksOpen);
fprintf('\t \t Revenue: \t $%0.0f\n', weeklyRevenue);
fprintf('\t \t Cost: \t $%0.0f\n', weeklyCost);
fprintf('\t The breakeven time is %0.2f months\n',breakevenOne);
fprintf('\t The total profit after %0.0f years is $%0.3e\n', analysisLength, profitChart(end))

fprintf('It will take a one-time donation of $%0.2f to breakeven in seven months.\n', breakevenDonation);

wallTotalCost = (constructionCost) + costChart;

costSlope = (wallTotalCost(end)-wallTotalCost(1))/(analysisLength);
revenueSlope = (revenueChart(end)-revenueChart(1))/(analysisLength);

breakevenX = constructionCost/(revenueSlope-costSlope);
breakevenY = (revenueSlope*breakevenX);

plot(yearsRequested, wallTotalCost, yearsRequested, revenueChart);
hold on;
plot(breakevenX, breakevenY, 'k.', 'MarkerSize', 20);

title('Cost/Revenue Chart');
xlabel('Years');
ylabel('$ millions');
grid on;

legend({'Total Cost','Revenue'},'Location','Best');

hold off;

figure;
profitSlope = revenueSlope-costSlope;
projectBreakevenX = constructionCost/(profitSlope);
projectBreakevenY = profitSlope*projectBreakevenX;

plot(yearsRequested, profitChart);
hold on;
plot(projectBreakevenX, projectBreakevenY, 'k.', 'MarkerSize', 20);
hold off;

grid on;

title('Profit vs Time');
xlabel('Years');
ylabel('$ Millions');

legend({'Profit'},'Location','Best');
