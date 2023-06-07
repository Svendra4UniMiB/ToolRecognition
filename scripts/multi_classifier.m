close all;
clear;

%% Segmentazione ed estrazione features
data = feature_extraction("ANOVA");
features_knn = data.features;
labels_knn = data.labels;
images_knn = data.images;

data = feature_extraction("MRMR");
features_tree = data.features;
labels_tree = data.labels;
images_tree = data.images;
%% Partizionamento
train_test_split = partitioner(features_knn, labels_knn, images_knn);
train_knn = train_test_split.train;
test_knn = train_test_split.test;

train_test_split = partitioner(features_tree, labels_tree, images_tree);
train_tree = train_test_split.train;
test_tree = train_test_split.test;
%% Creazione del modello
% load("train_test.mat");
% KNN (15, mahalanobis)
knnMahalanobis = fitcknn(train_knn.features, train_knn.labels, 'NumNeighbors',15, 'Distance','mahalanobis');
acc_knn = model_evaluation(knnMahalanobis, train_knn, test_knn);

% Tree
cart = fitctree(train_tree.features, train_tree.labels);
view(cart, "Mode","graph");
acc_tree = model_evaluation(cart, train_tree, test_tree);


function out = model_evaluation(classifier, train, test)
    predict_train = predict(classifier, train.features);
    performance_train = confmat(predict_train, train.labels);
    
    predict_test = predict(classifier, test.features);
    performance_test = confmat(predict_test, test.labels);
    
    figure();
    show_confmat(performance_train.cm_raw, performance_train.labels);
    
    figure();
    show_confmat(performance_test.cm_raw, performance_test.labels);
    
    out = [performance_train.accuracy performance_test.accuracy];
end