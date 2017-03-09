
dirSave = 'C:\data\lot1_\all_adc\';
listing = dir([dirSave, '*.mat']);
for jj=1: length(listing)
    sname = listing(jj,1).name;
    load([dirSave,sname]);
    k1 = strfind(sname,'=');
    k2 = strfind(sname,' ');

    if (~isempty(k1) && ~isempty(k2) && k2>k1)
        adcbias =  sname(k1+1:k2-1);
        dirSaveWithBias = [dirSave, 'ADCbias=' , num2str(adcbias),' ' ];
        dirSaveImgWithBias = [dirSave, 'imgs\', 'ADCbias=' , num2str(adcbias),' ' ];
        hexBias = dec2hex(adcbias);

        figNum = 88;
        sweepPlot21(swp1, adcbias, figNum, dirSave);
    end
end