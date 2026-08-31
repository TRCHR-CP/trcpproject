    Interactive project to initialize TRCP projects.

    Creates a predefined folder structure, analysis scripts, 
    Quarto reports, and optional Git repositories using 
    analysis-specific templates.

    You need to run this using the one and only function **`create_project()`**. 
    This function will ask you a series of questions about your project and then 
    create the project structure for you. 

    At the start, you can choose whether the main project folder already
    exists. If it does, select that folder interactively; its existing files
    will be listed, and raw data should be placed in `1_data/raw`.

    The setup asks separately for the main folder name, the short project name
    used in report and script titles, and the RStudio project filename. The
    RStudio project filename defaults to `programs.Rproj` and can be changed.

    The function will create a README file that is automatically filled with the 
    project name, analyst name, and date of creation as well as Sesssion Info! No need 
    to remember that anymore. 

    When you later work on a project, always read the README file first, then use 
    the appropriate Dockerized Rversion.
    
