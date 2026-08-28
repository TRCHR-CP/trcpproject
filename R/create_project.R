#' Create a standardized TRCP analysis project
#'
#' Interactively creates a TRCP project with a standard folder structure,
#' analysis-specific R scripts, a Quarto report, and an optional Git repository.
#'
#' @param path Optional path to the project directory or its parent directory.
#'   If NULL, the user is asked interactively.
#' @param project_name Optional human-readable project name.
#' @param analyst_name Optional name of the analyst initializing the project.
#' @param analysis_type Optional analysis type. One of "general", "survival",
#'   "regression", or "prediction".
#' @param git Logical. Should a Git repository be initialized?
#'   If NULL, the user is asked interactively.
#' @param open Logical. Should the project be opened in RStudio after creation?
#'
#' @return Invisibly returns the path to the newly created project.
#' @export
create_project <- function(
    path = NULL,
    project_name = NULL,
    analyst_name = NULL,
    analysis_type = NULL,
    git = NULL,
    open = FALSE
) {

  message("")
  message("TRCP Analysis Project Setup")
  message("===========================")
  message("")

  # ----------------------------------------------------------
  # Project location
  # ----------------------------------------------------------

  if (is.null(path)) {

    path <- readline(
      "Project directory (parent folder or full project path): "
    )

    if (!nzchar(path)) {
      stop(
        "A project directory is required.",
        call. = FALSE
      )
    }
  }

  # ----------------------------------------------------------
  # Project name
  # ----------------------------------------------------------

  if (is.null(project_name)) {

    project_name <- readline(
      "Project name: "
    )

    if (!nzchar(project_name)) {
      stop(
        "A project name is required.",
        call. = FALSE
      )
    }
  }

  # ----------------------------------------------------------
  # Analyst name
  # ----------------------------------------------------------

  if (is.null(analyst_name)) {

    analyst_name <- readline(
      "Analyst name: "
    )
  }

  # ----------------------------------------------------------
  # Analysis type
  # ----------------------------------------------------------

  if (is.null(analysis_type)) {

    analysis_type <- .trcp_choose_analysis_type()

  } else {

    analysis_type <- .trcp_normalize_analysis_type(
      analysis_type
    )
  }

  # ----------------------------------------------------------
  # Git
  # ----------------------------------------------------------

  if (is.null(git)) {

    git <- .trcp_yes_no(
      "Initialize Git repository?",
      default = TRUE
    )
  }

  # ----------------------------------------------------------
  # Create project slug
  # ----------------------------------------------------------

  project_slug <- .trcp_slug(
    project_name
  )

  # ----------------------------------------------------------
  # Determine project directory
  # ----------------------------------------------------------

  path <- path.expand(path)

  path_basename <- basename(
    normalizePath(
      path,
      winslash = "/",
      mustWork = FALSE
    )
  )

  if (identical(path_basename, project_slug)) {

    project_dir <- path

  } else {

    project_dir <- file.path(
      path,
      project_slug
    )
  }

  # ----------------------------------------------------------
  # Check existing directory
  # ----------------------------------------------------------

  if (dir.exists(project_dir)) {

    existing_files <- list.files(
      project_dir,
      all.files = TRUE,
      no.. = TRUE
    )

    if (length(existing_files) > 0) {

      stop(
        paste0(
          "Project directory already exists and is not empty:\n",
          project_dir
        ),
        call. = FALSE
      )
    }

  } else {

    dir.create(
      project_dir,
      recursive = TRUE,
      showWarnings = FALSE
    )
  }

  # ----------------------------------------------------------
  # Confirmation
  # ----------------------------------------------------------

  message("")
  message("Project configuration")
  message("--------------------")
  message("Project name: ", project_name)
  message(
    "Analyst name: ",
    if (nzchar(analyst_name))
      analyst_name
    else
      "Not specified"
  )
  message(
    "Analysis type: ",
    .trcp_analysis_label(analysis_type)
  )
  message("Project directory: ", project_dir)
  message("")

  proceed <- .trcp_yes_no(
    "Create project?",
    default = TRUE
  )

  if (!proceed) {

    message("Project creation cancelled.")

    return(
      invisible(NULL)
    )
  }

  # ----------------------------------------------------------
  # Create directories
  # ----------------------------------------------------------

  .create_directories(
    project_dir
  )

  message("✓ Creating directories")

  # ----------------------------------------------------------
  # Create files
  # ----------------------------------------------------------

  .trcp_write_project_files(
    project_dir = project_dir,
    project_name = project_name,
    project_slug = project_slug,
    analyst_name = analyst_name,
    analysis_type = analysis_type
  )

  message("✓ Creating analysis files")
  message("✓ Creating Quarto report")
  message("✓ Creating README")
  message("✓ Creating RStudio project")

  # ----------------------------------------------------------
  # Git
  # ----------------------------------------------------------

  if (isTRUE(git)) {

    .trcp_init_git(
      project_dir
    )
  }

  # ----------------------------------------------------------
  # Open project
  # ----------------------------------------------------------

  if (isTRUE(open)) {

    .trcp_open_project(
      project_dir
    )
  }

  # ----------------------------------------------------------
  # Done
  # ----------------------------------------------------------

  message("")
  message("Project created successfully!")
  message("")
  message("Project location:")
  message(
    normalizePath(
      project_dir,
      winslash = "/",
      mustWork = FALSE
    )
  )
  message("")

  message(
    "Analysis type: ",
    .trcp_analysis_label(analysis_type)
  )

  message(
    "Git: ",
    if (isTRUE(git))
      "initialized"
    else
      "not initialized"
  )

  message("")

  invisible(
    normalizePath(
      project_dir,
      winslash = "/",
      mustWork = FALSE
    )
  )
}


# ============================================================
# Ask analysis type
# ============================================================

.trcp_choose_analysis_type <- function() {

  cat(
    "\n",
    "Analysis type:\n",
    "\n",
    "1: General\n",
    "2: Survival analysis\n",
    "3: Regression\n",
    "4: Clinical prediction model\n",
    "\n",
    sep = ""
  )

  repeat {

    answer <- readline(
      "Selection: "
    )

    choice <- suppressWarnings(
      as.integer(answer)
    )

    if (choice %in% 1:4) {

      return(
        c(
          "general",
          "survival",
          "regression",
          "prediction"
        )[[choice]]
      )
    }

    message(
      "Please enter 1, 2, 3, or 4."
    )
  }
}


# ============================================================
# Normalize analysis type
# ============================================================

.trcp_normalize_analysis_type <- function(x) {

  x <- tolower(
    trimws(x)
  )

  aliases <- c(
    "1" = "general",
    "2" = "survival",
    "3" = "regression",
    "4" = "prediction",

    "general" = "general",

    "survival" = "survival",
    "survival analysis" = "survival",

    "regression" = "regression",

    "prediction" = "prediction",
    "clinical prediction model" = "prediction"
  )

  if (!x %in% names(aliases)) {

    stop(
      paste0(
        "analysis_type must be one of: ",
        "general, survival, regression, prediction."
      ),
      call. = FALSE
    )
  }

  unname(
    aliases[[x]]
  )
}


# ============================================================
# Analysis type labels
# ============================================================

.trcp_analysis_label <- function(type) {

  switch(
    type,

    general =
      "General",

    survival =
      "Survival analysis",

    regression =
      "Regression",

    prediction =
      "Clinical prediction model"
  )
}


# ============================================================
# Yes / no question
# ============================================================

.trcp_yes_no <- function(
    question,
    default = TRUE
) {

  suffix <- if (default)
    " [Y/n]: "
  else
    " [y/N]: "

  repeat {

    answer <- tolower(
      trimws(
        readline(
          paste0(
            question,
            suffix
          )
        )
      )
    )

    if (!nzchar(answer)) {

      return(
        default
      )
    }

    if (answer %in% c("y", "yes")) {

      return(TRUE)
    }

    if (answer %in% c("n", "no")) {

      return(FALSE)
    }

    message(
      "Please answer y or n."
    )
  }
}


# ============================================================
# Convert project name to folder-safe name
# ============================================================

.trcp_slug <- function(x) {

  x <- iconv(
    x,
    from = "",
    to = "ASCII//TRANSLIT"
  )

  x <- tolower(x)

  x <- gsub(
    "[^a-z0-9]+",
    "_",
    x
  )

  x <- gsub(
    "^_+|_+$",
    "",
    x
  )

  if (!nzchar(x)) {

    stop(
      "Could not create a valid project name.",
      call. = FALSE
    )
  }

  x
}


# ============================================================
# Create folder structure
# ============================================================

.create_directories <- function(
    project_dir
) {

  dirs <- c(

    "0_admin",

    "1_data/raw",
    "1_data/derived",

    "2_programs/functions",

    "3_results/tables",
    "3_results/figures",
    "3_results/supplementary",

    "4_report",

    "5_output"
  )

  for (directory in dirs) {

    dir.create(
      file.path(
        project_dir,
        directory
      ),
      recursive = TRUE,
      showWarnings = FALSE
    )
  }
}


# ============================================================
# Find template
# ============================================================

.trcp_template_path <- function(
    name,
    root = "templates"
) {

  path <- system.file(
    root,
    name,
    package = "trcpproject"
  )

  if (!nzchar(path)) {

    stop(
      paste0(
        "Template not found in installed package: ",
        name
      ),
      call. = FALSE
    )
  }

  path
}


# ============================================================
# Render template
# ============================================================

.trcp_render <- function(
    text,
    values
) {

  for (key in names(values)) {

    placeholder <- paste0(
      "{{",
      key,
      "}}"
    )

    text <- gsub(
      placeholder,
      values[[key]],
      text,
      fixed = TRUE
    )
  }

  text
}


# ============================================================
# Write project files
# ============================================================

.trcp_write_project_files <- function(
    project_dir,
    project_name,
    project_slug,
    analyst_name,
    analysis_type
) {

  values <- list(

    PROJECT_NAME =
      project_name,

    PROJECT_SLUG =
      project_slug,

    ANALYST =
      if (nzchar(analyst_name))
        analyst_name
      else
        "Not specified",

    ANALYSIS_TYPE =
      .trcp_analysis_label(
        analysis_type
      ),

    SESSION_INFO =
      paste(
        capture.output(
          sessionInfo()
        ),
        collapse = "\n"
      )
  )


  # ----------------------------------------------------------
  # Base files
  # ----------------------------------------------------------

  base_files <- c(

    "README.md",

    "gitignore",

    "1_data/README.md"
  )

  base_destinations <- c(

    "README.md",

    ".gitignore",

    "1_data/README.md"
  )


  for (index in seq_along(base_files)) {

    relative_path <- base_files[[index]]

    source_file <- .trcp_template_path(
      file.path(
        "base",
        relative_path
      )
    )

    destination_file <- file.path(
      project_dir,
      base_destinations[[index]]
    )

    dir.create(
      dirname(destination_file),
      recursive = TRUE,
      showWarnings = FALSE
    )

    text <- paste(
      readLines(
        source_file,
        warn = FALSE,
        encoding = "UTF-8"
      ),
      collapse = "\n"
    )

    text <- .trcp_render(
      text,
      values
    )

    writeLines(
      text,
      destination_file,
      useBytes = TRUE
    )
  }

  style_source <- .trcp_template_path(
    "styleq.css"
  )

  file.copy(
    style_source,
    file.path(project_dir, "4_report", "styleq.css"),
    overwrite = TRUE
  )


  # ----------------------------------------------------------
  # Analysis-specific templates
  # ----------------------------------------------------------

  analysis_files <- c(

    "2_programs/1_data_setup.R",

    "2_programs/2_descriptive.R",

    "4_report/preliminary_report.qmd"
  )

  analysis_templates <- c(

    "1_data_setup.R",

    "2_descriptive.R",

    "preliminary_report.qmd"
  )

  for (index in seq_along(analysis_files)) {

    relative_path <- analysis_files[[index]]

    filename <- analysis_templates[[index]]

    source_file <- .trcp_template_path(
      file.path(
        analysis_type,
        filename
      ),
      root = "analysis"
    )

    destination_file <- file.path(
      project_dir,
      relative_path
    )

    text <- paste(
      readLines(
        source_file,
        warn = FALSE,
        encoding = "UTF-8"
      ),
      collapse = "\n"
    )

    text <- .trcp_render(
      text,
      values
    )

    writeLines(
      text,
      destination_file,
      useBytes = TRUE
    )
  }


  # ----------------------------------------------------------
  # RStudio project
  # ----------------------------------------------------------

  rproj_file <- file.path(
    project_dir,
    paste0(
      project_slug,
      ".Rproj"
    )
  )


  rproj_contents <- c(

    "Version: 1.0",

    "",

    "RestoreWorkspace: Default",
    "SaveWorkspace: No",
    "AlwaysSaveHistory: Default",

    "",

    "EnableCodeIndexing: Yes",
    "UseSpacesForTab: Yes",
    "NumSpacesForTab: 4",
    "Encoding: UTF-8",

    "",

    "RnwWeave: Sweave",
    "LaTeX: pdfLaTeX",

    ""
  )


  writeLines(
    rproj_contents,
    rproj_file,
    useBytes = TRUE
  )
}


# ============================================================
# Initialize Git
# ============================================================

.trcp_init_git <- function(
    project_dir
) {

  git <- Sys.which(
    "git"
  )

  if (!nzchar(git)) {

    warning(
      paste0(
        "Git was requested, but Git was not found on PATH. ",
        "The project was created without initializing Git."
      ),
      call. = FALSE
    )

    return(
      invisible(FALSE)
    )
  }


  status <- system2(
    git,
    c(
      "-C",
      project_dir,
      "init"
    )
  )


  if (!identical(status, 0L)) {

    warning(
      "Git initialization returned a non-zero status.",
      call. = FALSE
    )

    return(
      invisible(FALSE)
    )
  }


  message(
    "✓ Initializing Git repository"
  )

  invisible(TRUE)
}


# ============================================================
# Open project
# ============================================================

.trcp_open_project <- function(
    project_dir
) {

  rproj <- list.files(
    project_dir,
    pattern = "\\.Rproj$",
    full.names = TRUE
  )

  if (length(rproj) == 0) {

    return(
      invisible(FALSE)
    )
  }


  # RStudio

  if (
    interactive() &&
    requireNamespace(
      "rstudioapi",
      quietly = TRUE
    ) &&
    rstudioapi::isAvailable()
  ) {

    rstudioapi::openProject(
      project_dir
    )

    return(
      invisible(TRUE)
    )
  }


  # Windows

  if (
    .Platform$OS.type == "windows"
  ) {

    shell.exec(
      rproj[[1]]
    )
  }


  # macOS

  else if (
    Sys.info()[["sysname"]] == "Darwin"
  ) {

    system2(
      "open",
      rproj[[1]]
    )
  }


  invisible(TRUE)
}