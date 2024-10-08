%%
clear;clc;
close all;
% Define the number of storeys, rooms in x-y-direction
n_str = 3;
n_rx = 2;
n_ry = 3;
% Define the length, width, and height of the building
l = 5;
b = 5;
h = 3;
% Define the type of foundation as either 'PLATE' or 'FOOTING'
ftyp = 'PLATE';
% Define the velocity of the excitation
V_s =450;
% Define the size of the elements
n_esize = 0.5;
if strcmp(ftyp,'PLATE')
    B_f = n_esize/2;
    L_f = n_esize/2;
else
    B_f = 0.75;
    L_f = 0.75;
end
%%
% rf_fldr = 'MultiUnitBld_GeomVary';
rf_fldr = 'MultiUnitBld_GeomVary_3lby2';

% rf_fldr = 'UnitBld_GeomVary';
% rf_fldr = 'TF_F_Indpn';

bf_nm = 'Disp_Center_%s_%d_l%d_b%d';

cols = {'Freq', 'AMPL'};

cmpt = {'X', 'Y', 'Z'};

f_vect = [];

folder = fns_plot.get_fldrnm(n_str,n_rx,n_ry,l,b,ftyp,V_s,L_f,B_f);
u_ref=1;
for i_str = [0,n_str] %0:n_str
    fil_nm = arrayfun(@(x) sprintf(bf_nm, x{1}, i_str, l, b),...
        cmpt, 'UniformOutput', false);

    cd ..
    cd APDL_codes
    cd Results_Ansys
    fil_pth = fullfile(rf_fldr, folder, fil_nm);
    U_all = cellfun(@(x) readtable(x),fil_pth,'UniformOutput',false);

    if isempty(f_vect)
        f_vect = U_all{1}.(cols{1});
    end
    Uamp_X = U_all{1}.(cols{2});
    Uamp_Y = U_all{2}.(cols{2});
    Uamp_Z = U_all{3}.(cols{2});
%     Uamp_X= 20*log10(Uamp_X/u_ref);
%     Uamp_Y= 20*log10(Uamp_Y/u_ref);
%     Uamp_Z= 20*log10(Uamp_Z/u_ref);
    cd ..
    cd ..
    cd Matlab_codes
    %% Plotting
    ha_cl = @colors;
    lStyl = {'-', '--', ':', '-.'};
    lcol = {ha_cl('boston university red'),ha_cl('black'),...
        ha_cl('denim')};

    figure
    plot(f_vect, Uamp_X, 'LineStyle', lStyl{1}, 'Color', lcol{1},...
        'DisplayName', 'X-dir', 'LineWidth', 1)
    hold on
    plot(f_vect, Uamp_Y, 'LineStyle', lStyl{3}, 'Color', lcol{2},...
        'DisplayName', 'Y-dir', 'LineWidth', 1.2)
    hold on
    plot(f_vect, Uamp_Z, 'LineStyle', lStyl{1}, 'Color', lcol{3},...
        'DisplayName', 'Z-dir', 'LineWidth', 1)

    legend('show', 'Box', 'off', 'Interpreter', 'latex',...
        'FontSize', 8)
    xlabel({'Frequency (Hz)'}, 'FontSize', 10,...
        'Interpreter', 'latex')
    ylabel('Transfer~Function', 'FontSize', 10,...
        'Interpreter', 'latex')

    set(gca, 'XTickLabelMode', 'auto');
    set(gca, 'YTickLabelMode', 'auto');
    set(gca,'FontSize',8, 'Box', 'on','LineWidth',0.2,...
        'TickLabelInterpreter','latex',...
        'TickLength',[0.01,0.01]);
    set(gcf, 'Units', 'inches', 'Position',...
        [18 3 3.0 4/3], 'PaperUnits', 'Inches',...
        'PaperSize', [3.0 4/3]);
    if i_str==0
        ylim([0.5,2])
    % else
    %     ylim([0,15.3])
    end
    xlim([0,80])
    filename = ['TFcentXYZ_', num2str(i_str),...
        '_n_rooms_X_', num2str(n_rx),...
        '_n_rooms_Y_', num2str(n_ry),...
        '_l', num2str(l), '_by_b', num2str(b),...
        '_ftyp_', ftyp, '_Vs_', num2str(V_s),...
        '_Lf_', num2str(L_f), '_Bf_', num2str(B_f), '.pdf'];

    cd SAVE_FIGS
    if ~exist(rf_fldr, 'dir')
        mkdir(rf_fldr);
    end
    saveas(gcf, fullfile(rf_fldr, filename));
    cd ..
    cd ..
    cd Matlab_codes
end