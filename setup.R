library(stringr)
library(tidyverse)
url = "https://raw.githubusercontent.com/joshkeating/info-201-coursegrades/master/resources/UWgpa.csv"
uwgpa = read_csv(url)
uwgpa$Course_Title = str_to_title(uwgpa$Course_Title)
uwgpa$Primary_Instructor = str_to_title(uwgpa$Primary_Instructor)
uwgpa$Quarter = str_replace(uwgpa$Quarter, "Autumn", "Fall")
order_grade = c("A", "A-", "B+", "B", "B-", "C+", "C", "C-", "D+", "D", "D-", "F", "W")
uwgpa = uwgpa |>
  drop_na() |>
  select(-"Academic Year", -Term, -"Class 2") |>
  rename(Title = "Course_Title", Instructor = "Primary_Instructor", Students = "Student_Count", AverageGPA = "Average_GPA")

write_csv(x = uwgpa, file = "data/uwgpa.csv")

uwgpa |>
  filter(Year == 2010) |>
  filter(Class == "ECON 200") |>
  filter(Instructor == "Salehi-Esfahani, Haideh") |>
  pivot_longer(A:W, names_to = "Letter", values_to = "Count") |>
  group_by(Letter) |>
  summarise(Count = sum(Count)) |>
  mutate(Letter = factor(Letter, levels = order_grade)) |>
  ggplot() +
  aes(x = Letter, y = Count, fill = Letter) |>
  geom_bar(stat = "identity") +
  theme_bw()