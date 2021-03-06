% Simulate simple signal and recover it with changing timelimits
% First cell is a filtered hanning window
%
% second cell is both filtered & nonfiltered pos/neg concatenated hanning
% window
%
% agert, behinger
%%
timelimits = {[-1.5,2.5],[-1,2],[-0.5,1.5],[-0.25,1.25],[-0.25,1.5],[-0,1],[0.25,0.75]};
figure
EEGsim = simulate_test_case(2,'noise',0,'basis','hanning','srate',100);
EEGsim = pop_eegfiltnew(EEGsim, 1, []);   % highpass
cfgDesign = [];
cfgDesign.eventtypes = {'stimulusA'};
cfgDesign.codingschema = 'reference';
cfgDesign.formula = 'y ~ 1';

EEGsim = uf_designmat(EEGsim,cfgDesign);
for timelimit =timelimits
    
    % error
    
    
    
    % timelimits = [-1.5,2.5];
    EEG = uf_timeexpandDesignmat(EEGsim,'timelimits',timelimit{1},'method','stick','timeexpandparam',7);
    EEG= uf_glmfit(EEG,'method','lsmr');
    ufresult = uf_condense(EEG);
    plot(ufresult.times,ufresult.beta(1,:,1),'o-')
    hold all
    xlim(timelimits{1})
    ylim([-3 3])
    
end
title('Pos Hanning')
legend(cellfun(@(x)[num2str(x)],timelimits,'UniformOutput',0))


%%

timelimits = {[-0.25,1.25],[-0,1],[0.25,0.75],[0,0.75],[0.4,0.6]};
for filter = 1:2
    figure
    
    EEGsim = simulate_test_case(2,'noise',0,'basis','posneg','srate',100);
    if filter == 2
        
        EEGsim = pop_eegfiltnew(EEGsim, 1, []);   % highpass
    end
    
    cfgDesign = [];
    cfgDesign.eventtypes = {'stimulusA'};
    cfgDesign.codingschema = 'reference';
    cfgDesign.formula = 'y ~ 1';
    
    EEGsim = uf_designmat(EEGsim,cfgDesign);
    for timelimit =timelimits
        
        % error
        
        
        
        % timelimits = [-1.5,2.5];
        EEG = uf_timeexpandDesignmat(EEGsim,'timelimits',timelimit{1},'method','stick','timeexpandparam',7);
        EEG= uf_glmfit(EEG,'method','lsmr');
        ufresult = uf_condense(EEG);
        plot(ufresult.times,ufresult.beta(1,:,1),'o-')
        hold all
        xlim(timelimits{1})
        ylim([-3 3])
        
    end
    if filter == 1
        title('Pos/Neg Hanning')
    else
        title('Pos/Neg Hanning + 1Hz Filter')
    end
    legend(cellfun(@(x)[num2str(x)],timelimits,'UniformOutput',0))
end