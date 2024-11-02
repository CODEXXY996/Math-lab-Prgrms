function MainMenu()
clc;
clear all;
close all;
    fig = figure('Position', [300, 300, 300, 300], 'MenuBar', 'none', ...
                 'Name', 'Simple Function Menu', 'NumberTitle', 'off', ...
                 'CloseRequestFcn', @closeGui);

    startMenu();

    function startMenu()
        selection = questdlg('PRESS START TO CONTINUE!', ...
            'Start Menu', ...
            'Start', 'Cancel', 'Start');

        switch selection
            case 'Start'
                createMainMenu();
            case 'Cancel'
                closeGui();
        end
    end

    function createMainMenu()
        uicontrol('Style', 'pushbutton', 'String', 'Geometric Progression', ...
                  'Position', [50, 220, 200, 30], 'Callback', @gpCallback);

        uicontrol('Style', 'pushbutton', 'String', 'Parallel Resistance', ...
                  'Position', [50, 180, 200, 30], 'Callback', @parallelResistanceCallback);

        uicontrol('Style', 'pushbutton', 'String', 'Check Prime', ...
                  'Position', [50, 140, 200, 30], 'Callback', @primeCheckerCallback);

        uicontrol('Style', 'pushbutton', 'String', 'Plot Frequency Curve', ...
                  'Position', [50, 100, 200, 30], 'Callback', @plotFrequencyCallback);
    end

    function closeGui(~, ~)
        delete(fig);
    end

    function gpCallback(~, ~)
        prompt = {'Enter the first term (a):', 'Enter the common ratio (r):'};
        dlgtitle = 'Geometric Progression Input';
        dims = [1 35];
        definput = {'3', '2'};
        answer = inputdlg(prompt, dlgtitle, dims, definput);
        
        if ~isempty(answer)
            a = str2double(answer{1});
            r = str2double(answer{2});
            gpTerms = generateGP(a, r);
            resultStr = sprintf('The first ten terms of the geometric progression are:\n%s', num2str(gpTerms));
            msgbox(resultStr, 'Geometric Progression Result');
        end
    end

    function parallelResistanceCallback(~, ~)
        prompt = {'Enter resistance R1 (ohms):', 'Enter resistance R2 (ohms):'};
        dlgtitle = 'Parallel Resistance Input';
        dims = [1 35];
        definput = {'2', '3'};
        answer = inputdlg(prompt, dlgtitle, dims, definput);
        
        if ~isempty(answer)
            R1 = str2double(answer{1});
            R2 = str2double(answer{2});
            result = parallelResistanceCalc(R1, R2);
            msgbox(['Equivalent resistance: ', num2str(result), ' ohms'], 'Parallel Resistance Result');
        end
    end

    function primeCheckerCallback(~, ~)
        prompt = {'Enter a number to check if it is prime:'};
        dlgtitle = 'Prime Number Check';
        dims = [1 35];
        definput = {'2'};
        answer = inputdlg(prompt, dlgtitle, dims, definput);
        
        if ~isempty(answer)
            numToCheck = str2double(answer{1});
            result = primechecker(numToCheck);
            if result
                msgbox([num2str(numToCheck), ' is a prime number.'], 'Prime Number Result');
            else
                msgbox([num2str(numToCheck), ' is not a prime number.'], 'Prime Number Result');
            end
        end
    end

    function plotFrequencyCallback(~, ~)
        prompt = {'Enter your frequency data in kHz (use square brackets for array format):'};
        dlgtitle = 'Frequency Curve Input';
        dims = [1 35];
        definput = {'[1, 2, 1.5, 3, 2.5, 3.5, 2, 1.8, 1.2, 3]'};
        answer = inputdlg(prompt, dlgtitle, dims, definput);
        
        if ~isempty(answer)
            data_khz = str2num(answer{1});
            plotFrequencyCurve(data_khz);
            msgbox('Frequency curve plotted successfully!', 'Plot Result');
        end
    end
end

function gpTerms = generateGP(a, r)
    gpTerms = a * (r.^(0:9));
end

function eqresistance = parallelResistanceCalc(R1, R2)
    eqresistance = (R1 * R2) / (R1 + R2);
end

function isPrime = primechecker(num)
    if num <= 1
        isPrime = false;
        return;
    end
    for i = 2:sqrt(num)
        if mod(num, i) == 0
            isPrime = false;
            return;
        end
    end
    isPrime = true;
end

function plotFrequencyCurve(data_khz)
    [freq, edges] = histcounts(data_khz, 'Normalization', 'probability');
    binCenters = edges(1:end-1) + diff(edges)/2;

    figure;
    plot(binCenters, freq, '-o', 'LineWidth', 2);
    title('Frequency Curve of Input Data in kHz');
    xlabel('Frequency (kHz)');
    ylabel('Probability Density');
    grid on; 
end
