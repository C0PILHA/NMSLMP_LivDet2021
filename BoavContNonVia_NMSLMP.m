function BoavContNonVia_NMSLMP(varargin)
%%
% Author: Dr. Rodrigo Colnago Contreras.
% E-mail: rodrigo.contreras@unesp.br.
% Affiliations: São Paulo State University and University of São Paulo.
%
% Code: Software sent to Liveness Detection Competition 2021 (LivDet2021).
% Patterns: Only Statistic-Dense SIFT.
%

%% Loading functions and environments.

format long;

%% Definitions.

method = "Novel Multiscale Local Mapped Pattern";

is_challenge_1 = 0;
is_challenge_2 = 0;
ndataset = 0;
templateimagesfile = "";
probeimagesfile = "";
livenessoutputfile = "";
IMSoutputfile = "";
embeddingsfile = "";
if (nargin==5) % challenge 1
    
    disp("-----------------------------------------------------------------");
    disp("------------------------ CHALLENGE 1 ----------------------------");
    disp("-----------------------------------------------------------------");

    is_challenge_1 = 1;
    ndataset = str2double(varargin{1});
    templateimagesfile = varargin{2};
    probeimagesfile = varargin{3};
    livenessoutputfile = varargin{4};
    IMSoutputfile = varargin{5};
    
elseif (nargin==4) % challenge 2
    
    disp("-----------------------------------------------------------------");
    disp("------------------------ CHALLENGE 2 ----------------------------");
    disp("-----------------------------------------------------------------");
    
    is_challenge_2 = 1;
    ndataset = str2double(varargin{1});
    probeimagesfile = varargin{2};
    livenessoutputfile = varargin{3};
    embeddingsfile = varargin{4};
end
%% Selecting sensor and loading the classifier.

sensor = "";
disp("Sensor selected:");
switch ndataset
    case 1
        disp('Green Bit.');
        sensor = "GreenBit";
    case 2
        disp('DigitalPersona.');
        sensor = "DigitalPersona";
    case 3
        disp('Dermalog.');
        sensor = "Dermalog";
    otherwise
        disp('The sensor doens''t exist!');
end

disp("Loading the machine learning model for the selected sensor.");
xtrain = load(strcat(sensor,"_2021_MSLMP.dat"));
ytrain = load(strcat(sensor,"_2021_label.dat"));

xmax = max(xtrain);
xmin = min(xtrain);

xtrain_normalized = norm_column(xtrain,xmax,xmin);
SVMModel = fitcsvm(xtrain_normalized,ytrain);
disp("Model Loaded.");
disp("Calculating 10-fold cross validation.");
loss = crossval(SVMModel);
disp("10-fold Loss: "+num2str(kfoldLoss(loss)));


%% Extract the pattern from the given images.

disp("-----------------------------------------------------------------");
disp(strcat("Extracting the ",method," from probe-images."));
disp("-----------------------------------------------------------------");
image_paths = readlinesfromtxt(probeimagesfile);
feature_probe = pattern_extraction_MSLMP(image_paths, 6, 0.25);


disp("-----------------------------------------------------------------");
disp("Normalization initialized.");
feature_probe = norm_column(feature_probe,xmax,xmin);
disp("Normalization finished.");
disp("-----------------------------------------------------------------");


disp("-----------------------------------------------------------------");
disp("Liveness detection (classification) step.");
labels_output = predict(SVMModel,feature_probe);

%labels_output is originally in [-1,1], so we have to lie the results in
%the range [0,100].
%labels_output = 100.0*(labels_output + 1)/2.0;
num_img = size(labels_output,1);
for i=1:num_img
    if labels_output(i,1) == -1
        labels_output(i,1) = 0;
    elseif labels_output(i,1) == 1
        labels_output(i,1) = 100;
    end
end
disp("-----------------------------------------------------------------");


disp("-----------------------------------------------------------------");
disp("Recording the classification results in the given txt-file path:");
disp(livenessoutputfile);

fileIDout = fopen(livenessoutputfile,'wt');
fprintf(fileIDout,'%f\n',labels_output);
fclose(fileIDout);

disp("Results recorded.");
disp("-----------------------------------------------------------------");


%% Steps of Integrated Matching Score and embeddings recordings.

if is_challenge_1 == 1
    
    disp("-----------------------------------------------------------------");
    disp(strcat("Extracting the ",method," from template-images."));
    disp("-----------------------------------------------------------------");
    image_paths = readlinesfromtxt(templateimagesfile);
    feature_temp = pattern_extraction_MSLMP(image_paths, 6, 0.25);
    disp("-----------------------------------------------------------------");
    disp("Pattern extracted.");
    disp("-----------------------------------------------------------------");
    
    
    disp("-----------------------------------------------------------------");
    disp("Normalization initialized.");
    feature_temp = norm_column(feature_temp,xmax,xmin);
    disp("Normalization finished.");
    disp("-----------------------------------------------------------------");
    
    
    
    disp("-----------------------------------------------------------------");
    disp("Calculating the integrated match score (IMS).");
    
    values_of_dists = unique(pdist(xtrain_normalized));
    threshold = (0.1*values_of_dists(1)+0.9*values_of_dists(2));
    
    dists = pdist2(feature_probe, feature_temp);
    num_temp = size(feature_temp,1);
    IMS = zeros(num_temp,1);
    
    for i=1:num_temp
        if labels_output(i,1) > 0
            if dists(i,i) <= threshold
                IMS(i,1) = 100;
            end
        end
    end
    
    disp("IMS calculation finished.");
    disp("-----------------------------------------------------------------");
    
    
    
    disp("-----------------------------------------------------------------");
    disp("Recording the IMS labels in the given txt-file path:");
    disp(IMSoutputfile);

    fileIDout = fopen(IMSoutputfile,'wt');
    fprintf(fileIDout,'%f\n',IMS);
    fclose(fileIDout);

    disp("Results recorded.");
    disp("-----------------------------------------------------------------");

elseif is_challenge_2 == 1
    
    disp("-----------------------------------------------------------------");
    disp("Recording the embeddings extracted from the probe-images in the given file:");
    disp(strcat(embeddingsfile,".mat"));
    
    disp("The embeddings (features) of each image are disposed of in the lines of matrix 'feature_probe' in the same order of probe-images.");

    save(strcat(embeddingsfile,".mat"), 'feature_probe');

    disp("Results recorded.");
    disp("-----------------------------------------------------------------");  
    
else
    disp("This software accepts 4 or 5 input parameters. Other quantities of parameters are not accepted.");
end

end