library(dplyr)

source('01_parse_data.R')

convocations <- data.frame(
  convocation = c(1, 2, 3, 4, 5, 6, 7, 8, 9),
  years = c('1990-1994', '1994-1998', 
            '1998-2002', '2002-2006', 
            '2006-2007', '2007-2012', 
            '2012-2014', '2014-2019', '2019-    '),
  stringsAsFactors = F
)

df <- parse_data() %>% 
  select(-id, -birthday) %>% 
  inner_join(convocations) %>% 
  mutate(start = stringr::str_extract(years, '\\d{4}'),
         age_at_start = as.numeric(start) - year,
         full_name = paste(first_name, last_name)) %>% 
  arrange(convocation, year, -gender) %>% 
  group_by(convocation,  age_at_start) %>% 
  mutate(label = row_number()) 

write.csv(df, 'data/parsed/mps.csv', row.names = F)
