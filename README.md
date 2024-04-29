# STAT-447-Final-Project
UIUC STAT $447$ Final Project - University of Washington Seattle (UW) GPA Data: $2010 - 2015$ Shiny Application

## Authors and Contributions

-   **Name:** Nicholas Wong
-   **Email:** [nwong27\@illinois.edu](mailto:nwong27@illinois.edu)
-   **Contributions:** Created the Project Slides, found the `UWgpa.csv` dataset, implemented majority of Shiny App code in `app.R`        including the dropdown menus and visualizations (Histograms), and wrote the `README.md` file
-   **Name:** Akhil Gogineni
-   **Email:** [vg23\@illinois.edu](mailto:vg23@illinois.edu)
-   **Contributions:** Implemented visualizations (Box plots) in the Shiny App code found in `app.R` and recorded the presentation         video
-   **Name:** Sam Hwang
-   **Email:** [shwang62\@illinois.edu](mailto:shwang62@illinois.edu)
-   **Contributions:** Implemented visualizations (Linear Regression plot) in the Shiny App code found in `app.R` and wrote the 
    Project Report

## Project Proposal

## Purpose

The purpose of this application here is to analyze the dataset of course grades from $2010 - 2015$ at the University of Washington Seattle. For analysis, we chose a dataset of class information for each class taught at the University of Washington Seattle from 
Fall $2010$ to Fall $2015.$ We were particularly interested in the breakdown of the letter grading within each class. This data is anonymized and can be manipulated to highlight features which are important to current University of Washington Seattle students. 
Using our visualizations and this data, the user can discover which classes have a higher average GPA when stratified by year.

## Data

The data here comes from a Final Project $3$ students from the University of Washington Seattle worked on in a course they took called INFO $201$: Technical Foundations of Informatics. The dataset is primarily divided up into $20$ columns which consists of the Year, Quarter, Class, Title, Instructor, Student Count, Average GPA, and $13$ columns for letter grades (A, A-, B+, B, B-, C+, C, C-, D+, D, 
D-, F, and W). We decided to have the app be filtered mainly by $3$ of these columns, which are the Class, Instructor, and Year. The 
Class would be conditionally dependent on the Year and the Instructor would be conditionally dependent on both the Class and Year.

## Shiny App Example

![](images/UW-GPA-Shiny-App-Example.png)

Shiny App of University of Washington Seattle GPA Data from $2010 - 2015$ when $\text{Year} \mathbf{=} 2013, \text{Class} \mathbf{=} \text{STAT} 311, \text{Instructor} \mathbf{=} \text{Cardoso, Tomre}$ showing histograms, box plots, and linear regression plot. 

## Presentation

[University of Illinois Box Link](https://uofi.app.box.com/folder/0)

## References
-  [University of Washington Seattle Grades Dataset from Info 201 Course Grades](https://github.com/joshkeating/info-201-coursegrades/)
-  [University of Washington Seattle: Standard Grading System](https://www.washington.edu/students/gencat/front/Grading_Sys.html)
-  [UWgpa.csv Dataset](https://github.com/joshkeating/info-201-coursegrades/blob/master/resources/UWgpa.csv)