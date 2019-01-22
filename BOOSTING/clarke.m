function [total, percentage] = clarke(y,yp)
% CLARKE    Performs Clarke Error Grid Analysis
%
% The Clarke error grid approach is used to assess the clinical
% significance of differences between the glucose measurement technique
% under test and the venous blood glucose reference measurements. The
% method uses a Cartesian diagram, in which the values predicted by the
% technique under test are displayed on the y-axis, whereas the values
% received from the reference method are displayed on the x-axis. The
% diagonal represents the perfect agreement between the two, whereas the
% points below and above the line indicate, respectively, overestimation
% and underestimation of the actual values. Zone A (acceptable) represents
% the glucose values that deviate from the reference values by ?0% or are
% in the hypoglycemic range (<70 mg/dl), when the reference is also within
% the hypoglycemic range. The values within this range are clinically exact
% and are thus characterized by correct clinical treatment. Zone B (benign
% errors) is located above and below zone A; this zone represents those
% values that deviate from the reference values, which are incremented by
% 20%. The values that fall within zones A and B are clinically acceptable,
% whereas the values included in areas C-E are potentially dangerous, and
% there is a possibility of making clinically significant mistakes. [1-4]
%
% SYNTAX:
% 
% [total, percentage] = clarke(y,yp)
% 
% INPUTS: 
% y             Reference values (mg/dl) 
% yp            Predicted/estimtated values (mg/dl)
% 
% OUTPUTS: 
% total         Total points per zone: 
%               total(1) = zone A, 
%               total(2) = zone B, and so on
% percentage    Percentage of data which fell in certain region:
%               percentage(1) = zone A, 
%               percentage(2) = zone B, and so on.
% 
% EXAMPLE:      load example_data.mat 
%               [tot, per] = clarke(y,yp)
% 
% References:  
% [1]   A. Maran et al. "Continuous Subcutaneous Glucose Monitoring in Diabetic 
%       Patients" Diabetes Care, Volume 25, Number 2, February 2002
% [2]   B.P. Kovatchev et al. "Evaluating the Accuracy of Continuous Glucose-
%       Monitoring Sensors" Diabetes Care, Volume 27, Number 8, August 2004
% [3]   E. Guevara and F. J. Gonzalez, “Prediction of Glucose Concentration by
%       Impedance Phase Measurements,?in MEDICAL PHYSICS: Tenth Mexican 
%       Symposium on Medical Physics, Mexico City (Mexico), 2008, vol. 1032, pp.
%       259?61. 
% [4]   E. Guevara and F. J. Gonzalez, “Joint optical-electrical technique for
%       noninvasive glucose monitoring,?REVISTA MEXICANA DE FISICA, vol. 56, 
%       no. 5, pp. 430?34, Sep. 2010. 
% 
% ?Edgar Guevara Codina 
% codina@REMOVETHIScactus.iico.uaslp.mx 
% File Version 1.2 
% March 29 2013 
% 
% Ver. 1.2 Statistics verified, fixed some errors in the display; thanks to Tim
% Ruchti from Hospira Inc. for the corrections
% Ver. 1.1 corrected upper B-C boundary, lower B-C boundary slope ok; thanks to
% Steven Keith from BD Technologies for the corrections! 
% 
% MATLAB ver. 7.10.0.499 (R2010a)
% ------------------------------------------------------------------------------

% Error checking
if nargin == 0
 error('clarke:Inputs','There are no inputs.')
end
if length(yp) ~= length(y)
    error('clarke:Inputs','Vectors y and yp must be the same length.')
end
if (max(y) > 400) || (max(yp) > 400) || (min(y) < 0) || (min(yp) < 0)
    error('clarke:Inputs','Vectors y and yp are not in the physiological range of glucose (<400mg/dl).')
end
% -------------------------- Print figure flag ---------------------------------
PRINT_FIGURE = false;
% ------------------------- Determine data length ------------------------------
n = length(y);
% ------------------------- Plot Clarke's Error Grid ---------------------------
h = figure;
plot(y,yp,'ko','MarkerSize',4,'MarkerFaceColor','k','MarkerEdgeColor','k');
xlabel('Reference Concentration [mg/dl]');
ylabel ('Predicted Concentration [mg/dl]');
title('Clarke''s Error Grid Analysis');
set(gca,'XLim',[0 400]);
set(gca,'YLim',[0 400]);
axis square
hold on
plot([0 400],[0 400],'k:')                  % Theoretical 45?regression line
plot([0 175/3],[70 70],'k-')
% plot([175/3 320],[70 400],'k-')
plot([175/3 400/1.2],[70 400],'k-')         % replace 320 with 400/1.2 because 100*(400 - 400/1.2)/(400/1.2) =  20% error
plot([70 70],[84 400],'k-')
plot([0 70],[180 180],'k-')
plot([70 290],[180 400],'k-')               % Corrected upper B-C boundary
% plot([70 70],[0 175/3],'k-')
plot([70 70],[0 56],'k-')                   % replace 175.3 with 56 because 100*abs(56-70)/70) = 20% error
% plot([70 400],[175/3 320],'k-')
plot([70 400],[56 320],'k-')
plot([180 180],[0 70],'k-')
plot([180 400],[70 70],'k-')
plot([240 240],[70 180],'k-')
plot([240 400],[180 180],'k-')
plot([130 180],[0 70],'k-')                 % Lower B-C boundary slope OK
text(30,20,'A','FontSize',12);
text(30,150,'D','FontSize',12);
text(30,380,'E','FontSize',12);
text(150,380,'C','FontSize',12);
text(160,20,'C','FontSize',12);
text(380,20,'E','FontSize',12);
text(380,120,'D','FontSize',12);
text(380,260,'B','FontSize',12);
text(280,380,'B','FontSize',12);
set(h, 'color', 'white');                   % sets the color to white 
% Specify window units
set(h, 'units', 'inches')
% Change figure and paper size (Fixed to 3x3 in)
% set(h, 'Position', [0.1 0.1 3 3])
set(h, 'PaperPosition', [0.1 0.1 3 3])
if PRINT_FIGURE
    % Saves plot as a Enhanced MetaFile
    print(h,'-dmeta','Clarke_EGA');           
    % Saves plot as PNG at 300 dpi
    print(h, '-dpng', 'Clarke_EGA', '-r300'); 
end
total = zeros(5,1);                         % Initializes output
% ------------------------------- Statistics -----------------------------------
for i=1:n,
    if (yp(i) <= 70 && y(i) <= 70) || (yp(i) <= 1.2*y(i) && yp(i) >= 0.8*y(i))
        total(1) = total(1) + 1;            % Zone A
    else
        if ( (y(i) >= 180) && (yp(i) <= 70) ) || ( (y(i) <= 70) && yp(i) >= 180 )
            total(5) = total(5) + 1;        % Zone E
        else
            if ((y(i) >= 70 && y(i) <= 290) && (yp(i) >= y(i) + 110) ) || ((y(i) >= 130 && y(i) <= 180)&& (yp(i) <= (7/5)*y(i) - 182))
                total(3) = total(3) + 1;    % Zone C
            else
                if ((y(i) >= 240) && ((yp(i) >= 70) && (yp(i) <= 180))) || (y(i) <= 175/3 && (yp(i) <= 180) && (yp(i) >= 70)) || ((y(i) >= 175/3 && y(i) <= 70) && (yp(i) >= (6/5)*y(i)))
                    total(4) = total(4) + 1;% Zone D
                else
                    total(2) = total(2) + 1;% Zone B
                end                         % End of 4th if
            end                             % End of 3rd if
        end                                 % End of 2nd if
    end                                     % End of 1st if
end                                         % End of for loop
percentage = (total./n)*100;
% ------------------------------------------------------------------------------
% EOF
