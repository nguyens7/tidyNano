library(tidyverse)
library(tidyNano)
library(broom)

data <- read_csv("revised_MASTER-ExperimentSummary.csv")

data1 <- data %>%
  nanotidy(2:256) %>%
  separate(Sample, into = c("Animal", "Dilution","Injection","Tech_rep"),
           sep = "_", convert = TRUE) %>%
  mutate_at(vars(Animal,Injection,Tech_rep),as.factor)


data2 <- data1 %>%
  nanocount(Animal, Injection, particle_size, param_var = Count) %>%
  nanolyze(Animal, Injection,
           name = "Count",
           param_var = Particle_count)

ANOVA <- function(df){
  aov(Count_mean ~ Animal, data = df)
}

data2 %>%
  nanonest(Injection) %>%
  mutate(ANOVA = map(data, ANOVA))

data2 %>%
  nanoANOVA(Injection, value = Count_mean, variables = Animal)


testtt$data[1]

test1 <- data2 %>%
  nanonest(Injection)

test1$data[1]


test3$Shapiro[1]


testtt <- data2 %>%
  group_by(Injection) %>%
  nest() %>%
  mutate(
         Shapiro = map(data, ~shapiro.test(.x$Count_mean))) %>%
         #ANOVA = map(data, ~aov(Count_mean ~ Animal, data = .x))
  unnest(Shapiro %>%  map(tidy)) %>%
  mutate(Normal_dist = case_when(p.value >.05 ~ TRUE,
                                 p.value <.05 ~ FALSE ),
         Statistical_test = case_when(Normal_dist == TRUE ~ "Perform ANOVA",
                                      Normal_dist == FALSE ~ "Perform Kruskal-Wallis"))
?map2

testtt$data[1]
testtt$Shapiro[1]
testtt$ANOVA[1]
testtt %>% unnest(ANOVA %>% map(glance))

test <- data2 %>%
  nanoANOVA(Injection, value = Count_mean, variables = Animal)

test$data[1]
test$Shapiro[3]



test$data[1]

data1 %>%
  group_by(Animal, Injection, Tech_rep) %>%
  summarise(N = length(Count),
            mean = mean(Count),
            sd = sd(Count),
            se = sd/sqrt(N))


nanolyze(starwars, gender,name = "height", param_var = height)

data1 %>%
  nanolyze(Animal, Injection,Tech_rep,
           name = "Vesicle",
           param_var = Count) %>%
  print() %>%
  nanolyze(Animal,Injection,
           name = "Tech_rep",
           param_var = Vesicle_mean) %>%
  print() %>%
  nanolyze(Animal,
           name = "Injection",
           param_var = Tech_rep_mean)



data1 %>%
  rename(avg = mean) %>%
  select(-sd,-se) %>%
  nanolyze(Animal, Injection, param_var = avg)

data1 %>%
  nanolyze2() %>%
  nanolyze(Animal, Injection, param_var = avg)

data %>%
  nanotidy(2:256) %>%
  separate(Sample, into = c("Animal", "Dilution","Injection","Tech_rep"), sep = "_", convert = TRUE) %>%
  mutate_at(vars(Animal,Injection,Tech_rep),as.factor) %>%
  nanolyze(Animal, Injection,Tech_rep, param_var = Count) %>%
  nanolyze2() %>%
  nanolyze(Animal, Injection, param_var = avg) %>%
  nanolyze2() %>%
  nanolyze(Animal, param_var = avg)




data %>%
  nanotidy(2:256) %>%
  separate(Sample, into = c("Animal", "Dilution","Injection","Tech_rep"), sep = "_", convert = TRUE) %>%
  mutate_at(vars(Animal,Injection,Tech_rep),as.factor) %>%
  nanolyze(Animal, Injection, param_var = Count)

starwars %>%
  filter() %>%
  nanoANOVA(species, value = mass, variables = gender)


?as.name

paste0("Apple","sauce")

name <-  "Name_"

paste0(name,"N")

read_csv("test.csv", skip = 5)

?read_csv

nanoimport("test.csv", skip = 5)

test4 <- read.csv("nanotest.csv")
header <- read.csv("nanotest.csv", skip = 77, header = F, nrows = 1, as.is = T)
df <-  read.csv("nanotest.csv", skip = 87, header = F, nrows = 1000)
colnames(df) <-  header

df

df2 <- df %>%
  rename(particle_size = Filename)
  select(-Average, -`Standard Error`)

dftest <- nanoimport("nanotest.csv")

dftest1 <- dftest %>%
  nanotidy(2:37) %>%
  separate(Sample, into = c("Sample", "Filter", "Dilution", "Tech_rep"),
           sep = "_", convert = TRUE) %>%
  mutate_at(vars(Sample, Filter, Tech_rep),as.factor) %>%
  mutate_at(vars(Count),as.numeric)



dftest2 <- dftest1 %>%
  nanolyze(Sample, Filter,particle_size, name = "Count", param_var = Count) %>%
  nanocount(Sample, Filter, param_var = Count_mean)
dftest2


test4 <- dftest1 %>%
  nanolyze(Sample, Filter, particle_size, param_var = Count) %>%  # avg tech rep
  nanocount(Sample, Filter, param_var = Param_mean) %>%  # count all particles
  mutate(Particle_count = Particle_count/10e6) %>%
  nanonest(Filter) #nest

test4 %>%
  group_by(Filter) %>%
  nest() %>% ungroup()

test4$data[1]

test5 <- test4 %>%
  mutate( kruskal = map(data, ~kruskal.test(Particle_count ~ Sample, data = .x)))

test5$ANOVA[1]
test5 %>%
  unnest(kruskal %>% map(glance))

test5$ANOVA[1]

dftest1 %>%
  # filter(particle_size <300) %>%
  nanolyze(Sample, Filter,particle_size, name = "Count", param_var = Count) %>%
  ggplot(aes(x = particle_size, y = Count_mean, color = Sample)) +
  geom_line() +
  facet_wrap(~Filter)



# old ---------------------------------------------------------------------




# dftest1 %>%
#   group_by(Sample, Filter, Tech_rep) %>%
#   summarize(N = length(Count),
#             Total = sum(Count))

dftest2 <- dftest1 %>%
  nanocount(Sample, Filter, Tech_rep, param_var = Count) %>%
  nanonest(Sample)

dftest2$data[1]
