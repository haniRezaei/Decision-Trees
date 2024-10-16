#### Decision Trees ####

library(ElemStatLearn)
data("prostate")

## Regression trees ####
library(tree)

n<-nrow(prostate)
set.seed(1234)
train<-sample(1:n,ceiling(n/2))

tree_pros<-tree(lpsa~.,data=prostate[,-ncol(prostate)],
                subset=train)
summary(tree_pros)
mean(prostate$lpsa[train])

yhat<-predict(tree_pros,newdata = prostate[-train,-ncol(prostate)])
mean((prostate$lpsa[-train]-yhat)^2)

plot(tree_pros)
text(tree_pros,digits=3)

### Pruning of the regression tree ####
set.seed(1234)
cv_prostate<-cv.tree(tree_pros,K=5,FUN=prune.tree)
cv_prostate
best_tn<-cv_prostate$size[which.min(cv_prostate$dev)]
# best no. of terminal nodes


pruned_prostate<-prune.tree(tree_pros,best=best_tn)
plot(pruned_prostate)
text(pruned_prostate)

pruned_yhat<-predict(pruned_prostate,newdata=prostate[-train,-ncol(prostate)])
mean((prostate$lpsa[-train]-pruned_yhat)^2)

## Classification trees #####
data("SAheart")
n<-nrow(SAheart)

# For classification trees, the response MUST be a factor
x<-SAheart[,-ncol(SAheart)]
y<-SAheart[,ncol(SAheart)]

heart<-data.frame(chd=as.factor(y),x)

### Accuracy of the fully grown tree ####
set.seed(1234)
train<-sample(1:n,ceiling(n/2),replace=F)
heart_test<-heart[-train,]

# DON'T FIT THE TREE ON THE NUMERICAL RESPONSE, IT DOES NOT RETURN ANY WARNING
# pippo=tree(chd~.,SAheart[train,])
# summary(pippo)

tree_heart<-tree(chd~.,heart,subset=train)
summary(tree_heart)

plot(tree_heart)
text(tree_heart,pretty=0)
#pretty=0 allows to display the labels of the categorical
#variables

tree_heart

yhat_heart<-predict(tree_heart,newdata=heart_test,type="class")

table(yhat=yhat_heart,y=heart_test$chd)
mean(yhat_heart!=heart_test$chd)


### Accuracy of the pruned tree ####
set.seed(1234)
cv_heart<-cv.tree(tree_heart,FUN=prune.misclass)

best_size<-cv_heart$size[which.min(cv_heart$dev)]

pruned_heart<-prune.misclass(tree_heart,best=best_size)


plot(pruned_heart)
text(pruned_heart,pretty = 0)

yhat_pruned<-predict(pruned_heart,newdata=heart_test,type="class")
# Confusion matrix
table(yhat=yhat_pruned,y=heart_test$chd)
mean(yhat_pruned!=heart_test$chd)

pruned_heart2<-prune.misclass(tree_heart,best=15)
yhat2<-predict(pruned_heart2,newdata = heart_test,type="class")
mean(yhat2!=heart_test$chd)


# Bagging and Random Forests ####

## Regression - Bagging ####
# install.packages('randomForest')
library(randomForest)
?randomForest

data("prostate")
colnames(prostate)

x<-prostate[,-ncol(prostate)]
p<-ncol(x)-1 # no. of predictors
n<-nrow(x) # no. of units

set.seed(1234)
train<-sample(1:n,ceiling(n/2))
x_test<-x[-train,]

set.seed(1234)
bag.prostate<-randomForest(lpsa~.,data=x,subset=train,
                           mtry=p,importance=T)
bag.prostate

# Variable importance
importance(bag.prostate)
varImpPlot(bag.prostate)

summary(bag.prostate)

#### Accuracy in the validation set ####
yhat.bag<-predict(bag.prostate,newdata=x_test)
head(yhat.bag)
mean((yhat.bag-x_test$lpsa)^2)


### Regression - Random Forests ####
set.seed(1234)
rf.prostate<-randomForest(lpsa~.,data=x,subset=train,
                           importance=T)
rf.prostate
varImpPlot(rf.prostate)

#### Accuracy in the validation set ####
yhat.rf<-predict(rf.prostate,newdata=x_test)
head(yhat.rf)
mean((yhat.rf-x_test$lpsa)^2)


### Classification - Bagging ####
data("SAheart")
colnames(SAheart)
x<-SAheart[,-ncol(SAheart)]
y<-SAheart[,ncol(SAheart)]
heart<-data.frame(chd=as.factor(y),x)

n<-nrow(x)
p<-ncol(x)

set.seed(1234)
train<-sample(1:n,ceiling(n/2),replace=F)
heart_test<-heart[-train,]

set.seed(1234)
bag.heart<-randomForest(chd~.,data=heart,subset = train,
                        mtry=p,importance=T)

# REMEMBER: ALWAYS CODE THE RESPONSE AS FACTOR FOR CLASSIFICATION FORESTS
# pippo2<-randomForest(chd~.,data=SAheart,subset = train,
#                         mtry=p,importance=T)

yhat.bag<-predict(bag.heart,newdata=heart_test)
table(yhat.bag,heart_test$chd)
mean(yhat.bag!=heart_test$chd)


### Classification - Random Forests ####
set.seed(1234)
rf.heart<-randomForest(chd~.,data=heart,subset = train,
                        importance=T)
rf.heart
yhat.rf<-predict(rf.heart,newdata=heart_test)
table(yhat.rf,heart_test$chd)
mean(yhat.rf!=heart_test$chd)

