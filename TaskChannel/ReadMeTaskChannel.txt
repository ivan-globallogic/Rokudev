#Strucutre
Homescene is a starting node extended from the scene. It is created in 
main.brs. Children of the Homescene are Grid Screen and Details screen. It also
has fields in interface for populating Grid content and handling events for selecting an item on the
Grid screen.

Grid screen has 3 children, rectangle for background, rowlist for diplsaying list of videos and
Description that is custom component and it extends a LayoutGroup. 

Description has 3 children, 3 Labels for title, date of release and description of content.

Details screen has 5 children, Poster for background, LabelList for buttons,
Ractangle that servers as a background for description text, Description and Video.
